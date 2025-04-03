import { Component, Input, OnInit, OnDestroy, ViewEncapsulation, ChangeDetectorRef,AfterViewInit , SimpleChanges, NgZone, input   } from '@angular/core';
import { AbstractControl, FormArray, FormControl, FormGroup, Validators, ValidationErrors, ValidatorFn,FormBuilder } from '@angular/forms';
import { contactData, data, detailsData, docData, tableData, taxData, Income, } from '../../data';
import { debounceTime, firstValueFrom, Subscription } from 'rxjs';
import { SaveApplicationService } from '../../../../services/save-application.service';
import { MessageService } from 'primeng/api';
import { Router } from '@angular/router';
import { FormProgressService } from '../../../../services/form-progress.service';
import { FormValidationService } from '../../../../services/form-validation.service';
import { conditionalCountryValidator, atLeastTwoFieldsRequiredIValidator, percentageValidator, assetAndDateValidator  } from '../form-layout.validators';
import {KeypressUtils } from './../keypress-utils'

interface BusinessCode {
  id: number;
  code: string;
  value: string;
}

interface SourceOfIncome {
  code: number;
  name: string;
}

@Component({
  selector: 'app-fvci-form',
  templateUrl: './fvci-form.component.html',
  standalone: false,
  styleUrls: ['./fvci-form.component.scss'],
  encapsulation: ViewEncapsulation.None, // Add this to allow our preview styles to affect child components
})
export class FvciFormComponent implements OnInit, AfterViewInit  {
  @Input() applicationId: string | undefined;
  @Input() previewMode: boolean = false;
  @Input() formGroup!: FormGroup;
  @Input() masterData!: any;
  @Input() applicationData!: any;
  private saveSubscription!: Subscription;
  showLoader = false;

  maxDate: Date = new Date();

  download = '/assets/downloads.png';
  incomeSourceOptions!: Income[];
  proofOfIdentityOptions!: any[];
  proofOfAddressOptions!: any[];
  selectedIncomeSource!: Income[];
  income: Income[] | undefined;
  businessCodeOptions!: any[];
  countries: any[] = [];
  countries_pan: any[] = [];
  countryShortCodes: any[] = [];
  countryShortCodes_pan: any[] = [];
  countryCodes: any[] = [];
  countryCodes_pan: any[] = [];
  typeOfApplicants: any[] = [];
  typeOfEntity: any[] = [];

  data = data;
  taxData = taxData;
  tableData = tableData;
  contactData = contactData;
  detailsData: any = detailsData;
  docData = docData;
  minCommencementDate: Date | null = null;

  disabledValues: number[] = [];

  activeAccordionIndex: number | null = 0;

  


  readonly managerFields = [
    { id: 'a)', name: 'Name of Entity' },
    { id: 'b)', name: 'Type of Entity' },
    { id: 'c)', name: 'Country' },
    { id: 'd)', name: 'Telephone Number' },
    { id: 'e)', name: 'Fax Number' },
    { id: 'f)', name: 'Email Id' },
  ];


  constructor(
    private readonly saveApplicationService: SaveApplicationService,
    private readonly messageService: MessageService,
    private readonly router: Router,
    private readonly progressService: FormProgressService,
    private readonly validationService: FormValidationService,
    private fb: FormBuilder,
    private cdr: ChangeDetectorRef, 
    private zone: NgZone,

  ) {
    this.formGroup = this.fb.group({
      taxResidencyRows: this.fb.array([])
    });
   }

  ngOnInit(): void {
     this.formGroup.get('dateOfIncorporation')?.valueChanges.subscribe((date: Date) => {
      this.minCommencementDate = this.formGroup.get('dateOfIncorporation')?.value;
    });
    this.subscribe();
    this.addRow(); // Add first row on load
    if (this.managingOfficialRows.length === 0) {
      this.addManagingOfficialRow();
    }
    this.formGroup.get('registeredOffice')?.updateValueAndValidity();
   
  }

  onAccordionChange(index: number): void {
    this.activeAccordionIndex = index;
  }
  ngOnChanges(changes: SimpleChanges): void {
    if (changes['masterData'] && changes['masterData'].currentValue) {
      // Now you can work with masterData here
      this.initializeMasterData();
    }
    if(changes['applicationData'] && changes['applicationData'].currentValue){
      console.log("asdasdasdasd")
      this.initialiseForm()
    }
  }
  ngAfterViewInit(): void{
    console.log("after viewwwwwwwwwww")
    // this.initializeMasterData();
  }

  initializeMasterData(): void{
    if(Array.isArray(this.masterData.country)){
      this.countries = this.masterData.country.map((country: any) => ({
        name: country.country_name,
        code: country.country_code,
        short_code: country.country_short_code,
        id: country.country_id,
      }));
      this.countryCodes = this.countries
        .map(({ code }) => ({ code }))
        .filter((item) => item.code != null && item.code !== '');
      this.countryShortCodes = this.countries
        .map(({ short_code }) => ({ short_code }))
        .filter((item) => item.short_code != null && item.short_code !== '');
    }

    if(Array.isArray(this.masterData.country_pan)){
      this.countries_pan = this.masterData.country_pan.map((country: any) => ({
        name: country.country_name,
        code: country.country_code.toString(),
        short_code: country.country_short_code,
        id: country.country_id,
      }));
      this.countryCodes_pan = this.countries_pan
        .map(({ code }) => ({ code }))
        .filter((item) => item.code != null && item.code !== '');
      this.countryShortCodes_pan = this.countries_pan
        .map(({ short_code }) => ({ short_code }))
        .filter((item) => item.short_code != null && item.short_code !== '');
    }
    if (Array.isArray(this.masterData.proof_of_identity)) {
      this.proofOfIdentityOptions = this.masterData.proof_of_identity;
    }
    if (Array.isArray(this.masterData.proof_of_address)) {
      this.proofOfAddressOptions = this.masterData.proof_of_address;
    }
    if (Array.isArray(this.masterData.type_of_applicant)) {
      this.typeOfApplicants = this.masterData.type_of_applicant;
    }
    if (Array.isArray(this.masterData.source_of_income)) {
      // Map the income sources from the response to incomeSourceOptions
      this.incomeSourceOptions = this.masterData.source_of_income.map(
        (item: any) => ({
          code: item.code,
          name: item.name,
          disabled: false,
        })
      );
    }
    if (Array.isArray(this.masterData.code_of_business)) {
      this.businessCodeOptions = this.masterData.code_of_business.map(
        (item: any) => ({
          code: item.code,
          name: item.value, // or item.name if that's the correct field
        })
      );
      console.log("businessCodeOptions", this.businessCodeOptions)
    }
    if ( Array.isArray(this.masterData.type_of_entity)) {
      this.typeOfEntity =this.masterData.type_of_entity
    }
    
  }


  initialiseForm() {
    const formData = this.applicationData.data?.ekycForm;
    if (!formData) return;
  
    // Patch simple top-level controls
    this.formGroup.patchValue({
      name: formData.name,
      dateOfIncorporation: formData.dateOfIncorporation ? new Date(formData.dateOfIncorporation) : null,
      dateOfCommencement: formData.dateOfCommencement ? new Date(formData.dateOfCommencement) : null,
      placeOfIncorporation: formData.placeOfIncorporation,
      legalForm: formData.legalForm,
      lei: formData.lei,
      // typeOfApplicants: formData.typeOfApplicants,
      typeOfEntity: formData.typeOfEntity,
      proofOfIdentity: formData.proofOfIdentity,
      proofOfAddress: formData.proofOfAddress,
      politicallyExposed: formData.politicallyExposed,
      relatedToPoliticallyExposed: formData.relatedToPoliticallyExposed,
      communicationAddress: formData.communicationAddress,
      ultimateBeneficialOwner: formData.ultimateBeneficialOwner,
      ultimateBeneficialOwnerHolding: formData.ultimateBeneficialOwnerHolding,
      beneficialOwnership: formData.beneficialOwnership
    });
  
    // Nested form groups
    this.patchNestedGroup('applicantOtherName', formData.applicantOtherName);
    // this.patchNestedGroup('registeredOffice', formData.registeredOffice);
    // this.patchNestedGroup('foreignOffice', formData.foreignOffice);
    // this.patchNestedGroup('OfficeInIndia', formData.OfficeInIndia);
    // this.patchNestedGroup('contactDetails', formData.contactDetails);
    this.patchNestedGroup('investmentManager', formData.investmentManager);
    const investmentManagerObj = this.applicationData.data?.ekycForm?.investmentManager?.country;

    const immatchedCountry = this.countries_pan.find(
      (c) => c.short_code === investmentManagerObj?.short_code
    );

    this.formGroup.get('investmentManager.country')?.setValue(immatchedCountry)
    
    this.patchNestedGroup('complianceOfficerInfo', formData.complianceOfficerInfo);
    // this.patchNestedGroup('incomeDetails', formData.incomeDetails);
    // this.patchNestedGroup('applicantType', formData.applicantType);
  
    // // Country selects
    // this.patchCountryControl('countryOfIncorporation', formData.countryOfIncorporation);
    // this.patchCountryControl('registeredOffice.registeredCountryName', formData.registeredOffice?.registeredCountryName);
    // this.patchCountryControl('foreignOffice.foreignCountryName', formData.foreignOffice?.foreignCountryName);
    // this.patchCountryControl('typeOfApplicants', formData.typeOfApplicants);
  
    this.formGroup.get("applicantType.applicantTypeName")?.setValue(this.applicationData.data?.ekycForm?.applicantType?.applicantTypeName);

    this.formGroup.get("applicantType.applicantTypeOtherEntity")?.setValue(this.applicationData.data?.ekycForm?.applicantType?.applicantTypeOtherEntity);

    const taxResidancyData = this.applicationData.data?.ekycForm?.taxResidencyRows;
    console.log("taxResidancyData.length", taxResidancyData.length)
    if(taxResidancyData.length>0){
      this.taxResidencyRows.clear();

    taxResidancyData.forEach((leiDetail :{ id?: number; trcNo?: string; country?: any }) => {
      console.log("leiDetail?.country?.short_code", leiDetail?.country?.short_code)
      const countryObj = this.countries_pan.find(
        (c) => c.short_code === leiDetail?.country?.short_code
      );
      this.addRow();
      const lastRow = this.taxResidencyRows.at(this.taxResidencyRows.length - 1);
      console.log("countryObj --", countryObj)
      lastRow.patchValue({
        id: leiDetail.id ?? this.taxResidencyRows.length + 1,
        trcNo: leiDetail.trcNo ?? '',
        country: countryObj,
      });
    });
    }

    //registerd
    const countryValue = this.applicationData.data?.ekycForm?.countryOfIncorporation;

    const matchedCountry = this.countries.find(
      (c) => c.short_code === countryValue?.short_code
    );
    console.log("matchedCountry", matchedCountry)
    this.formGroup.get('countryOfIncorporation')?.setValue(matchedCountry);
    

    
    this.formGroup.get('registeredOffice.registeredFlatNum')?.setValue(this.applicationData.data?.ekycForm?.registeredOffice?.registeredFlatNum)
    this.formGroup.get('registeredOffice.registeredBuildingName')?.setValue(this.applicationData.data?.ekycForm?.registeredOffice?.registeredBuildingName)
    this.formGroup.get('registeredOffice.registeredRoadName')?.setValue(this.applicationData.data?.ekycForm?.registeredOffice?.registeredRoadName)
    this.formGroup.get('registeredOffice.registeredAreaName')?.setValue(this.applicationData.data?.ekycForm?.registeredOffice?.registeredAreaName)
    this.formGroup.get('registeredOffice.registeredTownName')?.setValue(this.applicationData.data?.ekycForm?.registeredOffice?.registeredTownName)
    
    this.formGroup.get('registeredOffice.registeredStateName')?.setValue(this.applicationData.data?.ekycForm?.registeredOffice?.registeredStateName)
    this.formGroup.get('registeredOffice.notApplicableResidence')?.setValue(this.applicationData.data?.ekycForm?.registeredOffice?.notApplicableResidence)
    this.formGroup.get('registeredOffice.registeredZipName')?.setValue(this.applicationData.data?.ekycForm?.registeredOffice?.registeredZipName)
    const rcountryValue = this.applicationData.data?.ekycForm?.registeredOffice?.registeredCountryName;
      const rmatchedCountry = this.countries.find(
        (c) => c.short_code === rcountryValue?.short_code
      );
      console.log("matchedCountry", rmatchedCountry)
      this.formGroup.get('registeredOffice.registeredCountryName')?.setValue(rmatchedCountry)

    this.formGroup.get('sameAsAbove')?.setValue(this.applicationData?.data?.ekycForm?.sameAsAbove);
    this.formGroup.get('foreignOffice.foreignFlatNum')?.setValue(this.applicationData.data?.ekycForm?.foreignOffice?.foreignFlatNum)
    this.formGroup.get('foreignOffice.foreignBuildingName')?.setValue(this.applicationData.data?.ekycForm?.foreignOffice?.foreignBuildingName)
    this.formGroup.get('foreignOffice.foreignRoadName')?.setValue(this.applicationData.data?.ekycForm?.foreignOffice?.foreignRoadName)
    this.formGroup.get('foreignOffice.foreignAreaName')?.setValue(this.applicationData.data?.ekycForm?.foreignOffice?.foreignAreaName)
    this.formGroup.get('foreignOffice.foreignTownName')?.setValue(this.applicationData.data?.ekycForm?.foreignOffice?.foreignTownName)
    
    this.formGroup.get('foreignOffice.foreignStateName')?.setValue(this.applicationData.data?.ekycForm?.foreignOffice?.foreignStateName)
    this.formGroup.get('foreignOffice.notApplicableForeignOffice')?.setValue(this.applicationData.data?.ekycForm?.foreignOffice?.notApplicableForeignOffice)
    this.formGroup.get('foreignOffice.foreignZipName')?.setValue(this.applicationData.data?.ekycForm?.foreignOffice?.foreignZipName)
    const fcountryValue = this.applicationData.data?.ekycForm?.registeredOffice?.registeredCountryName;
      const fmatchedCountry = this.countries.find(
        (c) => c.short_code === fcountryValue?.short_code
      );
      console.log("matchedCountry", fmatchedCountry)
      this.formGroup.get('foreignOffice.foreignCountryName')?.setValue(fmatchedCountry)

    this.formGroup.get('OfficeInIndia.indianFlatNum')?.setValue(this.applicationData.data?.ekycForm?.officeInIndia?.indianFlatNum)
    this.formGroup.get('OfficeInIndia.indianBuildingName')?.setValue(this.applicationData.data?.ekycForm?.officeInIndia?.indianBuildingName)
    this.formGroup.get('OfficeInIndia.indianRoadName')?.setValue(this.applicationData.data?.ekycForm?.officeInIndia?.indianRoadName)
    this.formGroup.get('OfficeInIndia.indianAreaName')?.setValue(this.applicationData.data?.ekycForm?.officeInIndia?.indianAreaName)
    this.formGroup.get('OfficeInIndia.indianTownName')?.setValue(this.applicationData.data?.ekycForm?.officeInIndia?.indianTownName)
    
    this.formGroup.get('OfficeInIndia.indianStateName')?.setValue(this.applicationData.data?.ekycForm?.officeInIndia?.indianStateName)
    this.formGroup.get('OfficeInIndia.notApplicableIndOffice')?.setValue(this.applicationData.data?.ekycForm?.officeInIndia?.notApplicableIndOffice)
    console.log("this.applicationData?.data?.ekycForm?.officeInIndia?.officeInIndiaRadio", this.applicationData?.data?.ekycForm?.officeInIndia?.notApplicableIndOffice)
    this.formGroup.get('OfficeInIndia.OfficeInIndiaRadio')?.setValue(this.applicationData?.data?.ekycForm?.officeInIndia?.officeInIndiaRadio);
    this.formGroup.get('OfficeInIndia.indianZipName')?.setValue(this.applicationData.data?.ekycForm?.officeInIndia?.indianZipName)
    const icountryValue = this.applicationData.data?.ekycForm?.registeredOffice?.registeredCountryName;
    const imatchedCountry = this.countries.find(
      (c) => c.short_code === icountryValue?.short_code
    );
    console.log("matchedCountry", imatchedCountry)
    this.formGroup.get('OfficeInIndia.indianCountryName')?.setValue(imatchedCountry)

    this.formGroup.get('communicationAddress')?.setValue(this.applicationData.data?.ekycForm?.communicationAddress)

    const rocountryValue = this.applicationData.data?.ekycForm?.contactDetails?.registered.countryCode;
    console.log("rocountryValue", rocountryValue);
    const romatchedCountry = this.countries_pan.find(
      (c) => c.short_code === rocountryValue?.short_code
    );
    console.log("rocountryValue map", romatchedCountry)
    this.formGroup.get('contactDetails.registered.countryCode')?.setValue(romatchedCountry)
    this.formGroup.get('contactDetails.registered.areaCode')?.setValue(this.applicationData.data?.ekycForm?.contactDetails?.registered.areaCode)
    this.formGroup.get('contactDetails.registered.number')?.setValue(this.applicationData.data?.ekycForm?.contactDetails?.registered.number)
  
    const focountryValue = this.applicationData.data?.ekycForm?.contactDetails?.office.countryCode;
    const fomatchedCountry = this.countries_pan.find(
      (c) => c.short_code === focountryValue?.short_code
    );
    console.log("matchedCountry", focountryValue)
    this.formGroup.get('contactDetails.office.countryCode')?.setValue(fomatchedCountry)
    this.formGroup.get('contactDetails.office.areaCode')?.setValue(this.applicationData.data?.ekycForm?.contactDetails?.office.areaCode)
    this.formGroup.get('contactDetails.office.number')?.setValue(this.applicationData.data?.ekycForm?.contactDetails?.office.number)
  
    const ciocountryValue = this.applicationData.data?.ekycForm?.contactDetails?.indianOffice.countryCode;
    const ciomatchedCountry = this.countries_pan.find(
      (c) => c.short_code === ciocountryValue?.short_code
    );
    console.log("matchedCountry", ciomatchedCountry)
    this.formGroup.get('contactDetails.indianOffice.countryCode')?.setValue(ciomatchedCountry)
    this.formGroup.get('contactDetails.indianOffice.areaCode')?.setValue(this.applicationData.data?.ekycForm?.contactDetails?.indianOffice.areaCode)
    this.formGroup.get('contactDetails.indianOffice.number')?.setValue(this.applicationData.data?.ekycForm?.contactDetails?.indianOffice.number)

    /////fax
    const ffocountryValue = this.applicationData.data?.ekycForm?.contactDetails?.registeredFax.countryCode;

    const ffomatchedCountry = this.countries_pan.find(
      (c) => c.short_code === ffocountryValue?.short_code

    );
    console.log("ffomatchedCountry", ffomatchedCountry)
    this.formGroup.get('contactDetails.registeredFax.countryCode')?.setValue(ffomatchedCountry)
    this.formGroup.get('contactDetails.registeredFax.areaCode')?.setValue(this.applicationData.data?.ekycForm?.contactDetails?.registeredFax.areaCode)
    this.formGroup.get('contactDetails.registeredFax.number')?.setValue(this.applicationData.data?.ekycForm?.contactDetails?.registeredFax.number)
  
    const fciocountryValue = this.applicationData.data?.ekycForm?.contactDetails?.officeFax.countryCode;

    const fciomatchedCountry = this.countries_pan.find(
      (c) => c.short_code === fciocountryValue?.short_code

    );
    console.log("fciomatchedCountry", fciomatchedCountry)
    this.formGroup.get('contactDetails.officeFax.countryCode')?.setValue(fciomatchedCountry)
    this.formGroup.get('contactDetails.officeFax.areaCode')?.setValue(this.applicationData.data?.ekycForm?.contactDetails?.officeFax.areaCode)
    this.formGroup.get('contactDetails.officeFax.number')?.setValue(this.applicationData.data?.ekycForm?.contactDetails?.officeFax.number)
  
    const fiocountryValue = this.applicationData.data?.ekycForm?.contactDetails?.indianOfficeFax.countryCode;

    const fiomatchedCountry = this.countries_pan.find(
      (c) => c.short_code === fiocountryValue?.short_code

    );
    console.log("matchedCountry", fiomatchedCountry)
    this.formGroup.get('contactDetails.indianOfficeFax.countryCode')?.setValue(fiomatchedCountry)
    this.formGroup.get('contactDetails.indianOfficeFax.areaCode')?.setValue(this.applicationData.data?.ekycForm?.contactDetails?.indianOfficeFax.areaCode)

    this.formGroup.get('contactDetails.indianOfficeFax.number')?.setValue(this.applicationData.data?.ekycForm?.contactDetails?.indianOfficeFax.number)
    this.formGroup.get('contactDetails.mobileNumber')?.setValue(this.applicationData.data?.ekycForm?.contactDetails?.mobileNumber)
    this.formGroup.get('contactDetails.emailId')?.setValue(this.applicationData.data?.ekycForm?.contactDetails?.emailId)
    this.formGroup.get('contactDetails.website')?.setValue(this.applicationData.data?.ekycForm?.contactDetails?.website)

    // // Dynamic arrays
    // this.initializeTaxResidencyRows(formData.taxResidencyRows);
    this.initializeManagingOfficials(formData.managingOfficialRows);
    this.initializeIncomeSource(formData.incomeDetails);


    
  
    // Trigger value changes for conditional logic
    setTimeout(() => {
      this.formGroup.get('applicantOtherName.otherNameRadio')?.updateValueAndValidity();
      this.formGroup.get('sameAsAbove')?.updateValueAndValidity();
      this.formGroup.get('OfficeInIndia.OfficeInIndiaRadio')?.updateValueAndValidity();
    });
  }
  
  private patchNestedGroup(path: string, data: any) {
    if (data) {
      this.formGroup.get(path)?.patchValue(data);
    }
  }
  
  private patchCountryControl(path: string, countryData: any) {
    if (!countryData) return;
    
    const control = this.formGroup.get(path);
    const foundCountry = this.countries.find(c => 
      c.code === countryData.code || 
      c.name === countryData.name ||
      c.short_code === countryData.short_code
    );
    
    if (foundCountry) control?.setValue(foundCountry);
  }
  
  private initializeTaxResidencyRows(rows: any[]) {
    this.taxResidencyRows.clear();
    rows?.forEach(row => {
      const newRow = this.createRow();
      newRow.patchValue({
        id: row.id ?? this.taxResidencyRows.length + 1,
        trcNo: row.trcNo,
        country: this.countries_pan.find(c => c.short_code === row.country?.short_code)
      });
      this.taxResidencyRows.push(newRow);
    });
  }
  
  private initializeManagingOfficials(rows: any[]) {
    if(rows.length==0){
      return
    }
    this.managingOfficialRows.clear();
    rows?.forEach(row => {
      const newRow = this.createManagingOfficialRow();
      newRow.patchValue({
        details: {
          ...row.details,
          dateOfBirth: row.details?.dateOfBirth ? new Date(row.details.dateOfBirth) : null,
          taxResidencyJurisdiction: this.countries_pan.find(c => c.short_code === row.details?.taxResidencyJurisdiction.short_code),
          nationality: this.countries_pan.find(c => c.short_code === row.details?.nationality.short_code)
        }
      });
      this.managingOfficialRows.push(newRow);
    });
  }
  
  private initializeIncomeSource(incomeDetails: any) {
    if (!incomeDetails) return;
  
    // 1. Income Source (Multi-Select)
    const incomeSourceControl = this.formGroup.get('incomeDetails.incomeSource');
    if (incomeDetails.incomeSource?.length) {
      const sources = incomeDetails.incomeSource
        .map((code: number) => 
          this.incomeSourceOptions.find(o => o.code === code)
        )
        .filter(Boolean);
        console.log("source of income1111:", sources)
        
        const codeArray = sources.map((item: { code: number }) => item.code);
        incomeSourceControl?.setValue(codeArray);  
        
        
    }
  
    // 2. Business Code (Conditional Field)
    const businessCodeControl = this.formGroup.get('incomeDetails.businessCode');
    if (incomeDetails.businessCode) {
      const businessCode = this.businessCodeOptions.find(
        o => o.code === incomeDetails.businessCode.code
      );
      businessCodeControl?.setValue(businessCode);
    }
    this.formGroup.get('incomeDetails.annualIncome')?.setValue(incomeDetails.annualIncome);
    this.formGroup.get('incomeDetails.assetLess')?.setValue(incomeDetails.assetLess);
    // 3. Asset Date (Date Field)
    const asOnDateControl = this.formGroup.get('incomeDetails.asOnDate');
    if (incomeDetails.asOnDate) {
      asOnDateControl?.setValue(new Date(incomeDetails.asOnDate));
    }
  
    // 4. Re-enable conditional UI state
    setTimeout(() => {
      const hasBusinessIncome = incomeSourceControl?.value?.some(
        (s: any) => s.code === 3 // 3 = Business/Profession code
      );
      
      if (hasBusinessIncome) {
        // Restrict selection to only Business/Profession
        this.incomeSourceOptions = this.incomeSourceOptions.map(opt => ({
          ...opt,
          disabled: opt.code !== 3
        }));
        
        // Force business code validation
        businessCodeControl?.setValidators([Validators.required]);
      }
      
      this.cdr.detectChanges();
    });
  }




  getNextTaxResidencyId(): string {
    if (this.taxResidencyRows.length === 0) return 'a)';
    const lastId = this.taxResidencyRows
      .at(this.taxResidencyRows.length - 1)
      .get('id')?.value;
    const nextChar = String.fromCharCode(lastId.charCodeAt(0) + 1);
    return `${nextChar})`;
  }

  get taxResidencyRows(): FormArray {
    return this.formGroup.get('taxResidencyRows') as FormArray;
  }

  createRow(): FormGroup {
    return this.fb.group({
      id: [this.taxResidencyRows.length + 1],
      trcNo: [''],
      country: [null]
    },
    { validators: conditionalCountryValidator });
  }

  addRow(): void {
    this.taxResidencyRows.push(this.createRow());
  }

  removeRow(index: number): void {
    this.taxResidencyRows.removeAt(index);
    // Update IDs after removal
    this.taxResidencyRows.controls.forEach((group, i) =>
      group.get('id')?.setValue(i + 1)
    );
  }

  createManagingOfficialRow(): FormGroup {
    return this.fb.group({
      details: this.fb.group({
        nameAndAddress: new FormControl('', Validators.required),
        dateOfBirth: new FormControl(null, Validators.required),
        taxResidencyJurisdiction: new FormControl(null, Validators.required),
        nationality: new FormControl(null, Validators.required),
        actingAsGroupDetails: new FormControl(''),
        boGroupShareholding: new FormControl(''),
        governmentIdNumber: new FormControl('')
      })
    });
  }

  get managingOfficialRows(): FormArray {
    return this.formGroup.get('managingOfficialRows') as FormArray;
  }
  
  addManagingOfficialRow(): void {
    this.managingOfficialRows.push(this.createManagingOfficialRow());
    this.zone.run(() => {
      this.cdr.detectChanges(); // detect view update
      this.activeAccordionIndex = this.managingOfficialRows.length - 1;
    });
  
    this.managingOfficialRows.controls.forEach(group => {
      group.get('details')?.markAllAsTouched();
    });
  }
  
  removeManagingOfficialRow(index: number): void {
    this.managingOfficialRows.removeAt(index);
  }


  subscribe(): void{
    this.setupOfficeInIndiaConditionalValidation();
    this.setupCommunicationContactMapping();
    this.setupUltimateBeneficialOwnerValidation();
    this.subscribeToIncomeSourceChange()

    this.formGroup.get('applicantType.applicantTypeName')?.valueChanges.subscribe(() => {
      this.formGroup.get('applicantType')?.updateValueAndValidity();
    });
      const countryControl = this.formGroup.get('countryOfIncorporation');
    const countryCodeControl = this.formGroup.get('countryCodeOfIncorporation');

    countryControl?.valueChanges.subscribe((selectedCountry: any) => {
      if (
        selectedCountry &&
        typeof selectedCountry === 'object' &&
        selectedCountry.short_code
      ) {
        // Find the matching country code object
        const matchingCountryShortCode = this.countryShortCodes.find(
          (cc) => cc.short_code === selectedCountry.short_code
        );
        const matchingCountryCode = this.countryCodes.find(
          (cc) => cc.code === selectedCountry.code
        );
        // Update the country code dropdown
        if (matchingCountryCode) {
          countryCodeControl?.setValue(matchingCountryCode);
        }
      } else if (!selectedCountry) {
        // Clear the country code if country is cleared
        countryCodeControl?.setValue(null);
      }
    });

    this.handleSameAsAbove();
    }

    private handleSameAsAbove(): void {
      const registeredOffice = this.formGroup.get('registeredOffice') as FormGroup;
      const foreignOffice = this.formGroup.get('foreignOffice') as FormGroup;
      const sameAsAbove = this.formGroup.get('sameAsAbove');
    
      let syncSub: Subscription | undefined;
      let zipSyncSub: Subscription | undefined;
    
      sameAsAbove?.valueChanges.subscribe((checked: boolean) => {
        const zipControl = foreignOffice.get('foreignZipName');
    
        if (checked) {
          // 1. Initial copy
          foreignOffice.patchValue({
            foreignFlatNum: registeredOffice.get('registeredFlatNum')?.value,
            foreignBuildingName: registeredOffice.get('registeredBuildingName')?.value,
            foreignCountryName: registeredOffice.get('registeredCountryName')?.value,
            foreignRoadName: registeredOffice.get('registeredRoadName')?.value,
            foreignAreaName: registeredOffice.get('registeredAreaName')?.value,
            foreignTownName: registeredOffice.get('registeredTownName')?.value,
            foreignStateName: registeredOffice.get('registeredStateName')?.value,
            notApplicableForeignOffice: registeredOffice.get('notApplicableResidence')?.value,
            foreignZipName: registeredOffice.get('registeredZipName')?.value,
          });
    
          // 2. Sync all values from registeredOffice
          syncSub = registeredOffice.valueChanges.subscribe((val) => {
            foreignOffice.patchValue({
              foreignFlatNum: val.registeredFlatNum,
              foreignBuildingName: val.registeredBuildingName,
              foreignCountryName: val.registeredCountryName,
              foreignRoadName: val.registeredRoadName,
              foreignAreaName: val.registeredAreaName,
              foreignTownName: val.registeredTownName,
              
              foreignStateName: val.registeredStateName,
              notApplicableForeignOffice: val.notApplicableResidence,
              foreignZipName: val.registeredZipName, // this will now reflect correctly
            }, { emitEvent: false });
          });
    
          // 3. Keep ZIP value as "N/A" when not applicable, but do not disable the field
          zipSyncSub = registeredOffice.get('notApplicableResidence')?.valueChanges.subscribe((isNotApplicable) => {
            foreignOffice.get('notApplicableForeignOffice')?.setValue(isNotApplicable, { emitEvent: false });
    
            if (isNotApplicable) {
              zipControl?.patchValue('N/A', { emitEvent: false });
            } else if (zipControl?.value === 'N/A') {
              zipControl.patchValue('', { emitEvent: false });
            }
            zipControl?.updateValueAndValidity();
          });
    
          // 4. Run ZIP logic once initially
          const initialNA = registeredOffice.get('notApplicableResidence')?.value;
          foreignOffice.get('notApplicableForeignOffice')?.setValue(initialNA, { emitEvent: false });
          if (initialNA) {
            zipControl?.patchValue('N/A', { emitEvent: false });
          }
    
        } else {
          // Unsubscribe
          syncSub?.unsubscribe();
          zipSyncSub?.unsubscribe();
    
          // Reset values and enable manual editing
          foreignOffice.reset();
          Object.keys(foreignOffice.controls).forEach(key => {
            foreignOffice.get(key)?.enable();
          });
        }
      });
    }
    
    
    

    private setupOfficeInIndiaConditionalValidation(): void {
      const officeGroup = this.formGroup.get('OfficeInIndia') as FormGroup;
      const radioControl = officeGroup.get('OfficeInIndiaRadio');
    
      const requiredKeys = ['indianCountryName', 'indianTownName', 'indianZipName'];
      const allKeys = Object.keys(officeGroup.controls).filter(key => key !== 'OfficeInIndiaRadio');
    
      if (!radioControl) return;
    
      // Handle initial state
      if (radioControl.value !== true) {
        allKeys.forEach((key) => officeGroup.get(key)?.disable());
        officeGroup.clearValidators(); // remove group-level validator
      } else {
        officeGroup.setValidators(atLeastTwoFieldsRequiredIValidator()); // apply group-level validator
      }
    
      // Subscribe to changes
      radioControl.valueChanges.subscribe((selected: boolean) => {
        if (selected === true) {
          // Enable controls and apply field + group-level validators
          allKeys.forEach((key) => {
            const control = officeGroup.get(key);
            control?.enable();
            if (requiredKeys.includes(key)) {
              control?.setValidators(Validators.required);
            }
            control?.updateValueAndValidity();
          });
    
          officeGroup.setValidators(atLeastTwoFieldsRequiredIValidator());
        } else {
          // Disable all fields, clear field + group-level validators
          allKeys.forEach((key) => {
            const control = officeGroup.get(key);
            control?.clearValidators();
            control?.setValue(null);
            control?.disable();
            control?.updateValueAndValidity();
          });
          this.formGroup.get('OfficeInIndia.notApplicableIndOffice')?.setValue(true);
          officeGroup.clearValidators();
          officeGroup.setErrors(null); 
        }
    
        officeGroup.updateValueAndValidity();
      });
    }


    private setupCommunicationContactMapping(): void {
      const contactDetails = this.formGroup.get('contactDetails') as FormGroup;
      const commAddress = this.formGroup.get('communicationAddress');
    
      type CommAddressType = 'registered' | 'foreign' | 'indian';
    
      const contactMap: Record<CommAddressType, FormGroup> = {
        registered: contactDetails.get('registered') as FormGroup,
        foreign: contactDetails.get('office') as FormGroup,
        indian: contactDetails.get('indianOffice') as FormGroup
      };
    
      const allKeys: CommAddressType[] = ['registered', 'foreign', 'indian'];
    
      commAddress?.valueChanges.subscribe((selected: CommAddressType) => {
        allKeys.forEach((key) => {
          const group = contactMap[key];
    
          const areaCode = group.get('areaCode');
          const number = group.get('number');
          const countryCode = group.get('countryCode');
    
          if (key === selected) {
            // ✅ Apply required validators
            areaCode?.setValidators([Validators.required]);
            number?.setValidators([Validators.required, Validators.pattern('^[0-9]+$$')]);
            countryCode?.setValidators([Validators.required])
          } else {
            // ❌ Remove validators & clear values (but don't disable)
            areaCode?.clearValidators();
            areaCode?.setValue('');
            number?.clearValidators();
            number?.setValue('');
          }
    
          areaCode?.updateValueAndValidity();
          number?.updateValueAndValidity();
        });
      });
    
      // Optional: Run once for default selection
      const initial = commAddress?.value as CommAddressType;
      if (initial && contactMap[initial]) {
        allKeys.forEach((key) => {
          const group = contactMap[key];
          const areaCode = group.get('areaCode');
          const number = group.get('number');
    
          if (key === initial) {
            areaCode?.setValidators([Validators.required]);
            number?.setValidators([Validators.required]);
          } else {
            areaCode?.clearValidators();
            number?.clearValidators();
          }
    
          areaCode?.updateValueAndValidity();
          number?.updateValueAndValidity();
        });
      }
    }


    private setupUltimateBeneficialOwnerValidation(): void {
      const ubo = this.formGroup.get('ultimateBeneficialOwner');
      const holding = this.formGroup.get('ultimateBeneficialOwnerHolding');
    
      if (!ubo || !holding) return;
    
      // React to changes
      ubo.valueChanges.subscribe((isUbo: boolean) => {
        if (isUbo === false) {
          holding.enable();
          holding.setValidators([Validators.required, percentageValidator()]);
        } else {
          holding.setValue(null);
          holding.clearValidators();
          holding.disable();
        }
    
        holding.updateValueAndValidity();
      });
    
      // Run once on init
      if (ubo.value === false) {
        holding.enable();
        holding.setValidators([Validators.required, percentageValidator()]);
      } else {
        holding.disable();
        holding.clearValidators();
        holding.setValue(null);
      }
    
      holding.updateValueAndValidity();
    }

    subscribeToIncomeSourceChange(): void {
      const incomeGroup = this.formGroup.get('incomeDetails') as FormGroup;
      const incomeSourceControl = incomeGroup.get('incomeSource');
      const businessCodeControl = incomeGroup.get('businessCode');
    
      incomeSourceControl?.valueChanges.subscribe((selected: number[]) => {
        // Check if value 3 is selected → make business code required
        const hasValue3 = selected?.includes(3);
        if (hasValue3) {
          businessCodeControl?.setValidators([Validators.required]);
        } else {
          businessCodeControl?.clearValidators();
          businessCodeControl?.setValue(null);
        }
    
        const includes6 = selected?.includes(6);
    
        if (includes6 && selected.length > 1) {
          // Deselect all and select only 6 using setTimeout to avoid PrimeNG bug
          setTimeout(() => {
            incomeSourceControl?.setValue([6], { emitEvent: false });
    
            // Disable all options except 6
            this.incomeSourceOptions = [
              ...this.incomeSourceOptions.map(opt => ({
                ...opt,
                disabled: opt.code !== 6
              }))
            ];
    
            this.cdr.detectChanges(); // Ensure UI updates
          });
        } else if (includes6 && selected.length === 1) {
          // Only 6 selected — just disable other options
          this.incomeSourceOptions = [
            ...this.incomeSourceOptions.map(opt => ({
              ...opt,
              disabled: opt.code !== 6
            }))
          ];
        } else {
          // If 6 is not selected — reset all options
          this.incomeSourceOptions = [
            ...this.incomeSourceOptions.map(opt => ({
              ...opt,
              disabled: false
            }))
          ];
        }

        const includes3 = selected?.includes(3);

        if (includes3 && selected.length > 1) {
          // Deselect all and select only 6 using setTimeout to avoid PrimeNG bug
          setTimeout(() => {
            incomeSourceControl?.setValue([3], { emitEvent: false });
    
            // Disable all options except 6
            this.incomeSourceOptions = [
              ...this.incomeSourceOptions.map(opt => ({
                ...opt,
                disabled: opt.code !== 3
              }))
            ];
    
            this.cdr.detectChanges(); // Ensure UI updates
          });
        } else if (includes3 && selected.length === 1) {
          // Only 6 selected — just disable other options
          this.incomeSourceOptions = [
            ...this.incomeSourceOptions.map(opt => ({
              ...opt,
              disabled: opt.code !== 3
            }))
          ];
        } else {
          // If 6 is not selected — reset all options
          this.incomeSourceOptions = [
            ...this.incomeSourceOptions.map(opt => ({
              ...opt,
              disabled: false
            }))
          ];
        }
    
        businessCodeControl?.updateValueAndValidity();
      });
    }
    
    

    showBusinessCode(): boolean {
      const selected = this.formGroup.get('incomeDetails.incomeSource')?.value;
      return selected?.includes(3);
    }

    // isOptionDisabled = (option: any): boolean => {
    //   return this.disabledValues.includes(option.value);
    // };



    allowNumberOnly(event: KeyboardEvent): void {
      const allowedPattern = /^[0-9]$/;
      if (!allowedPattern.test(event.key)) {
        event.preventDefault();
      }
    }

    alphaNumeric(event: KeyboardEvent): void {
      const allowedPattern = /^[A-Za-z0-9]$/;
      if (!allowedPattern.test(event.key)) {
        event.preventDefault();
      }
    }

    
  sanitizePercentageInput(event: any): void {
    const input = event.target as HTMLInputElement;
    const originalValue = input.value;
    let cursor = input.selectionStart || 0;
  
    // Remove non-numeric and non-dot characters
    let cleaned = originalValue.replace(/[^0-9.]/g, '');
  
    // Only allow one decimal point
    const parts = cleaned.split('.');
    if (parts.length > 2) {
      cleaned = parts[0] + '.' + parts[1];
    }
  
    // Limit to 2 decimal places
    if (parts[1]?.length > 2) {
      cleaned = parts[0] + '.' + parts[1].slice(0, 2);
    }
  
    // Prevent value > 100
    const numericValue = parseFloat(cleaned);
    if (!isNaN(numericValue) && numericValue > 100) {
      cleaned = '100';
    }
  
    if (cleaned !== originalValue) {
      input.value = cleaned;
  
      // Recalculate and restore caret position
      const diff = originalValue.length - cleaned.length;
      const newCursor = Math.max(0, cursor - diff);
      setTimeout(() => {
        input.setSelectionRange(newCursor, newCursor);
      });
    }
  }

  incomeDetails(event: KeyboardEvent): void {
    const allowedPattern = /^[0-9()-]$/;
    if (!allowedPattern.test(event.key)) {
      event.preventDefault();
    }
  }

  }