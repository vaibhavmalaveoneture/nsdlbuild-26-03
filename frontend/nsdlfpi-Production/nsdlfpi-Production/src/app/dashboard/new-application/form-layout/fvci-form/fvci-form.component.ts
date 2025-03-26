import {
  Component,
  Input,
  OnInit,
  OnDestroy,
  ViewEncapsulation,
  ChangeDetectorRef,
} from '@angular/core';
import {
  AbstractControl,
  FormArray,
  FormControl,
  FormGroup,
  Validators,
  ValidationErrors,
  ValidatorFn,
} from '@angular/forms';
import {
  contactData,
  data,
  detailsData,
  docData,
  tableData,
  taxData,
  Income,
} from '../../data';
import { debounceTime, firstValueFrom, Subscription } from 'rxjs';

import { SaveApplicationService } from '../../../../services/save-application.service';
import { MessageService } from 'primeng/api';
import { Router } from '@angular/router';
import { FormProgressService } from '../../../../services/form-progress.service';
import { FormValidationService } from '../../../../services/form-validation.service';
import {
  CommonService,
  DraftFvciAddressDetailsDto,
  DraftFvciApplicationDto,
  DraftFvciBenificialOwnershipByControlDto,
  DraftFvciComplianceOfficerDetailsDto,
  DraftFvciComplianceOfficerEmailDto,
  DraftFvciEkycBenificialOwnerDetailsDto,
  DraftFvciEkycContactDetailsDto,
  DraftFvciFaxNumberDetailsDto,
  DraftFvciIncomeDetailsDto,
  DraftFvciInvestmentManagerDetailsDto,
  DraftFvciKycDocumentDto,
  DraftFvciKycLeiDetailsDto,
  DraftFvciTelephoneNumberDetailsDto,
  DraftFvicKycDetailsDto,
  DraftFvicRegistrationDetailsDto,
  FvciApplicationService,
} from '../../../../../swagger';

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
export class FvciFormComponent implements OnInit, OnDestroy {
  @Input() applicationId: string | undefined;
  @Input() applicationData: DraftFvciApplicationDto | null = null;
  @Input() previewMode: boolean = false;
  @Input() formGroup!: FormGroup;
  private saveSubscription!: Subscription;
  private cdr!: ChangeDetectorRef;
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
  countryShortCodes: any[] = [];
  countryCodes: any[] = [];
  typeOfApplicants: any[] = [];
  typeOfEntity: any[] = [];

  data = data;
  taxData = taxData;
  tableData = tableData;
  contactData = contactData;
  detailsData: any = detailsData;
  docData = docData;

  readonly managerFields = [
    { id: 'a)', name: 'Name of Entity' },
    { id: 'b)', name: 'Type of Entity' },
    { id: 'c)', name: 'Country' },
    { id: 'd)', name: 'Telephone Number' },
    { id: 'e)', name: 'Fax Number' },
    { id: 'f)', name: 'Email Id' },
  ];

  // preSaveAddValidation() {
  //   this.formControl['name'].addValidators(Validators.required);
  //   // if(!this.formGroup.valid){
  //   //   this.getInvalidFields();
  //   //   this.formGroup.markAllAsTouched();
  //   // }
  // }

  private readonly requiredMapping: any = {
    name: [''],
    applicantOtherName: {
      fields: ['otherNameRadio'],
      conditional: {
        condition: (val: any) => val === true,
        field: 'otherNameField',
      },
    },
    legalForm: [''],
    lei: [''],
    communicationAddress: [''],
    // Add individual controls to required mapping
    dateOfIncorporation: [''],
    dateOfCommencement: [''],
    placeOfIncorporation: [''],
    countryOfIncorporation: [''],
    countryCodeOfIncorporation: [''],
    proofOfIdentity: [''],
    proofOfAddress: [''],
    taxResidencyRows: ['trcNo', 'country'],
    registeredOffice: [
      'registeredFlatNum',
      'registeredBuildingName',
      'registeredCountryName',
      'registeredRoadName',
      'registeredAreaName',
      'registeredTownName',
      'registeredZipName',
      'registeredStateName',
    ],
    OfficeInIndia: [
      'OfficeInIndiaRadio',
      'indianFlatNum',
      'indianBuildingName',
      'indianCountryName',
      'indianRoadName',
      'indianAreaName',
      'indianTownName',
      'indianZipName',
      'indianStateName',
    ],
    foreignOffice: [
      'foreignFlatNum',
      'foreignBuildingName',
      'foreignCountryName',
      'foreignRoadName',
      'foreignAreaName',
      'foreignTownName',
      'foreignZipName',
      'foreignStateName',
    ],
    incomeDetails: [
      'incomeSource',
      'businessCode',
      'annualIncome',
      'assetLess',
    ],
  };

  constructor(
    private readonly commonService: CommonService,
    private readonly saveApplicationService: SaveApplicationService,
    private readonly messageService: MessageService,
    private readonly fvciService: FvciApplicationService,
    private readonly router: Router,
    private readonly progressService: FormProgressService,
    private readonly validationService: FormValidationService
  ) {}

  ngOnInit(): void {
    // this.preSaveAddValidation();
    this.initializeFormControls();

    this.setupValueChangeSubscriptions();

    this.initializeManagingOfficialRow();

    this.handleSameAsAbove();
    this.loadMasterData();

    if (!this.previewMode) {
      this.formGroup.valueChanges
        .pipe(debounceTime(300))
        .subscribe(() => this.onFormDataChange());
      this.saveSubscription =
        this.saveApplicationService.saveTrigger$.subscribe(() => {
          this.saveForm();
        });
    }
    // Handle both direct applicationData (for preview) and fetching
    if (this.previewMode && this.applicationData) {
      // We already have application data for preview
      this.populateFormWithApplicationData(this.applicationData);
      // Disable the form for preview mode
      // this.formGroup.disable();
    } else {
      // Normal case - fetch from API
      // this.fetchUserApplication();
    }
    const officeInIndiaGroup = this.formGroup.get('OfficeInIndia') as FormGroup;

    const fourFieldNames = [
      'indianFlatNum',
      'indianBuildingName',
      'indianRoadName',
      'indianAreaName',
    ];

    const allFieldNames = [
      'indianCountryName',
      'indianTownName',
      'indianZipName',
      'indianStateName',
    ];

    // Function to apply/remove validators dynamically
    const handleOfficeInIndiaValidators = (value: boolean) => {
      // Apply/remove required validators on all fields
      console.log("asdasdasdinto handle")
      allFieldNames.forEach((name) => {
        const control = officeInIndiaGroup.get(name);
        if (control) {
          if (value === true) {
            // control.setValidators([Validators.required]);
            control.setValidators([]);
          } else {
            control.clearValidators();
            control.setValue('');
          }
          control.updateValueAndValidity();
        }
      });

      // Apply/remove group-level validator on only 4 fields
      if (value === true) {
        officeInIndiaGroup.setValidators(
          this.atLeastTwoFieldsRequiredIValidator()
        );
      } else {
        officeInIndiaGroup.clearValidators();
      }
      officeInIndiaGroup.updateValueAndValidity();
    };

    // Handle initially
    handleOfficeInIndiaValidators(
      officeInIndiaGroup.get('OfficeInIndiaRadio')?.value
    );

    // Subscribe to value changes
    officeInIndiaGroup
      .get('OfficeInIndiaRadio')
      ?.valueChanges.subscribe((value) => {
        handleOfficeInIndiaValidators(value);
      });
  }

  atLeastTwoFieldsRequiredIValidator(): ValidatorFn {
    return (group: AbstractControl): ValidationErrors | null => {
      const flatNum = group.get('indianFlatNum')?.value;
      const buildingName = group.get('indianBuildingName')?.value;
      const roadName = group.get('indianRoadName')?.value;
      const areaName = group.get('indianAreaName')?.value;

      let filledCount = 0;

      if (flatNum && flatNum.trim() !== '') filledCount++;
      if (buildingName && buildingName.trim() !== '') filledCount++;
      if (roadName && roadName.trim() !== '') filledCount++;
      if (areaName && areaName.trim() !== '') filledCount++;

      return filledCount >= 2 ? null : { atLeastTwoFieldsRequiredI: true };
    };
  }

  ngOnDestroy(): void {
    if (this.saveSubscription) {
      this.saveSubscription.unsubscribe();
    }
  }

  // New method to populate form with application data
  private populateFormWithApplicationData(
    appData: DraftFvciApplicationDto
  ): void {
    if (!appData) return;

    this.mapInvestmentManagerDetails(appData);
    this.mapKycDetails(appData.kycDetails || {});
    this.mapIncorporationDates(appData.kycDetails || {});
    this.mapTaxResidencyRows(appData.kycLeiDetails || []);
    this.mapIncorporationPlace(appData.kycDetails || {});
    this.mapAddresses(appData.addressDetails || []);
    this.mapComplianceOfficerDetails(appData);
    this.mapContactDetails(
      appData.telephoneNumberDetails || [],
      appData.faxNumberDetails || [],
      appData.contactDetails || {}
    );
    this.mapOwnership(appData.benificialOwnershipByControl);
    this.mapManagingOfficials(appData.ekycBenificialOwnerDetails || []);
    this.mapIncomeDetails(appData.incomeDetails || []);
    this.mapRegistrationDetails(appData.registrationDetails);
    this.mapDocuments(appData.kycDocuments || []);
  }

  // onFormDataChange(): void {
  //   // Call the new aggregated progress update method with the component identifier and mapping.
  //   this.progressService.updateComponentProgress(
  //     'fvciForm',
  //     this.formGroup.value,
  //     this.requiredMapping
  //   );
  // }

  missingFields: any;

  onFormDataChange(): void {
    this.missingFields = [
      ...this.progressService.updateComponentProgress(
        'fvciForm',
        this.formGroup.value,
        this.requiredMapping
      ),
    ];

    if (this.cdr) {
      this.cdr.detectChanges(); // ✅ Ensures UI updates with missing fields
    }
  }

  private initializeFormControls(): void {
    const investmentManagerGroup = this.formGroup.get(
      'investmentManager'
    ) as FormGroup;
    this.managerFields.forEach((field) => {
      if(field.id=='e)'){
        investmentManagerGroup.addControl(field.id, new FormControl(''));
      }if(field.id=='f)'){
        investmentManagerGroup.addControl(field.id, new FormControl('', [Validators.required, Validators.email]));
      }else{
        investmentManagerGroup.addControl(field.id, new FormControl('', Validators.required));
      }
      
    });
  }

  private setupValueChangeSubscriptions(): void {
    this.handleZipToggle(
      'registeredOffice.notApplicableResidence',
      'registeredOffice.registeredZipName'
    );
    this.handleZipToggle(
      'foreignOffice.notApplicableForeignOffice',
      'foreignOffice.foreignZipName'
    );
    this.handleZipToggle(
      'OfficeInIndia.notApplicableIndOffice',
      'OfficeInIndia.indianZipName'
    );

    //logic for conditional business code display
    // this.formGroup
    //   .get('incomeDetails.incomeSource')
    //   ?.valueChanges.subscribe((selectedIncomeSource) => {
    //     this.handleBusinessCode(selectedIncomeSource);
    //   });

    // Update to use individual controls
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
        // console.log("matchingCountryCode", matchingCountryCode)
        // Update the country code dropdown
        if (matchingCountryCode) {
          countryCodeControl?.setValue(matchingCountryCode);
        }
      } else if (!selectedCountry) {
        // Clear the country code if country is cleared
        countryCodeControl?.setValue(null);
      }
    });
  }

  private handleZipToggle(controlPath: string, zipControlPath: string): void {
    this.formGroup
      .get(controlPath)
      ?.valueChanges.subscribe((isNotApplicable: boolean) => {
        const zipControl = this.formGroup.get(zipControlPath);
        if (isNotApplicable) {
          zipControl?.clearValidators();
          zipControl?.disable();
          zipControl?.setValue('N/A');
        } else {
          // zipControl?.setValidators(Validators.required);
          zipControl?.setValue('');
          zipControl?.enable();
        }
        zipControl?.updateValueAndValidity();
      });
  }

  //logic for conditional rendering of business code
  // handleBusinessCode(incomeSource: any): void {
  //   const businessCodeControl = this.formGroup.get(
  //     'incomeDetails.businessCode'
  //   );
  //   if (incomeSource) {
  //     businessCodeControl?.enable();
  //     const matchingSource = this.incomeSourceOptions?.find(
  //       (source) => source.name === incomeSource.name
  //     );
  //     if (matchingSource) {
  //       businessCodeControl?.setValue(matchingSource.code);
  //     }
  //   } else {
  //     businessCodeControl?.disable();
  //     businessCodeControl?.setValue(null);
  //   }
  // }

  private enableForeignOfficeFields(): void {
    const foreignOfficeGroup = this.formGroup.get('foreignOffice') as FormGroup;
    if (foreignOfficeGroup) {
      Object.keys(foreignOfficeGroup.controls).forEach((key) => {
        foreignOfficeGroup.get(key)?.enable();
      });
    }
  }

  convertToLocalDate(isoDate: string): Date {
    const date = new Date(isoDate);
    return new Date(
      date.getUTCFullYear(),
      date.getUTCMonth(),
      date.getUTCDate()
    );
  }

  async fetchUserApplication(): Promise<void> {
    console.log("oasdasdadasdasdasdasdasdasdasdasd")
    await this.loadMasterData();
    // Use existing applicationData if in preview mode
    if (this.previewMode && this.applicationData) {
      this.populateFormWithApplicationData(this.applicationData);
      this.formGroup.disable();
      return;
    }
    console.log("this.applicationId", this.applicationId)
    if (!this.applicationId) return;
    this.showLoader = true;
    try {
      const response =
        await this.saveApplicationService.fetchExistingApplication(
          this.applicationId
        );
      if (response?.success && response.data) {
        const appData = response.data;
        this.mapInvestmentManagerDetails(appData);
        this.mapKycDetails(appData.kycDetails || {});
        this.mapIncorporationDates(appData.kycDetails || {});
        this.mapTaxResidencyRows(appData.kycLeiDetails || []);
        this.mapIncorporationPlace(appData.kycDetails || {});
        this.mapAddresses(appData.addressDetails || []);
        this.mapComplianceOfficerDetails(appData);
        this.mapContactDetails(
          appData.telephoneNumberDetails || [],
          appData.faxNumberDetails || [],
          appData.contactDetails || {}
        );
        this.mapOwnership(appData.benificialOwnershipByControl);
        this.mapManagingOfficials(appData.ekycBenificialOwnerDetails || []);
        this.mapIncomeDetails(appData.incomeDetails || {});
        this.mapRegistrationDetails(appData.registrationDetails);
        this.mapDocuments(appData.kycDocuments || []);
        this.progressService.updateComponentProgress(
          'ekycForm',
          this.formGroup.value,
          this.requiredMapping
        );
      }else{
        this.messageService.add({
          severity: 'error',
          summary: 'Error',
          detail: 'Session is expired.',
        });
      }
    } finally {
      this.showLoader = false;
    }
  }

  // Update the mapping function
  private mapInvestmentManagerDetails(appData: any): void {
    if (appData.investmentManagerDetails) {
      const managerDetails = appData.investmentManagerDetails;
      const investmentManagerGroup = this.formGroup.get(
        'investmentManager'
      ) as FormGroup;

      // Map the single object to the form controls
      investmentManagerGroup.patchValue({
        'a)': managerDetails.name || '',
        'b)': managerDetails.type || '',
        'c)': managerDetails.country || '',
        'd)': managerDetails.phoneNumber || '',
        'e)': managerDetails.faxNumber || '',
        'f)': managerDetails.email || '',
      });
    }
  }

  private mapComplianceOfficerDetails(appData: any) {
    this.formGroup.patchValue({
      complianceOfficerInfo: {
        complianceOfficerInfoName: appData.complianceOfficerDetails?.name || '',
        complianceOfficerInfoJob:
          appData.complianceOfficerDetails?.jobTitle || '',
        complianceOfficerInfoMobile:
          appData.complianceOfficerDetails?.phoneNumber || '',
        complianceOfficerInfoFax:
          appData.complianceOfficerDetails?.faxNumber || '',
        complianceOfficerInfoEmail: appData.complianceOfficerEmail?.email || '',
      },
    });
  }

  private mapKycDetails(kyc: DraftFvicKycDetailsDto): void {
    console.log('kyc.isPoliticallyExposed', kyc.isPoliticallyExposed);
    this.formGroup.patchValue({
      name: kyc.name ?? '',
      applicantOtherName: {
        otherNameRadio: kyc.hasOtherName ?? null,
        otherNameField: kyc.otherName ?? '',
      },
      legalForm: kyc.legalFormAndLawOfIncorporation ?? '',
      lei: kyc.legalEntityIdentifier ?? '',
      communicationAddress: kyc.addressOfCommunication ?? '',
      OfficeInIndia: { OfficeInIndiaRadio: kyc.haveOfficeInIndia ?? null },
      politicallyExposed:
        kyc.isPoliticallyExposed === undefined
          ? null
          : kyc.isPoliticallyExposed
          ? 'politicallyExposedYes'
          : 'politicallyExposedNo',

      relatedToPoliticallyExposed:
        kyc.isRelatedToPoliticallyExposed === undefined
          ? null
          : kyc.isRelatedToPoliticallyExposed
          ? 'relatedToPoliticallyExposedYes'
          : 'relatedToPoliticallyExposedNo',
      beneficialOwnership: kyc.doesOtherPersonHolderOwnership ?? null,
    });
    this.formGroup.patchValue({});
  }

  private mapIncorporationDates(kyc: DraftFvicKycDetailsDto): void {
    const dateOfIncorp = kyc.dateOfIncorporation
      ? new Date(kyc.dateOfIncorporation)
      : null;
    const dateOfComm = kyc.dateOfCommencement
      ? new Date(kyc.dateOfCommencement)
      : null;

    this.formGroup.patchValue({
      dateOfIncorporation: dateOfIncorp,
      dateOfCommencement: dateOfComm,
    });
  }

  private mapTaxResidencyRows(leiDetails: DraftFvciKycLeiDetailsDto[]): void {
    const taxRows = this.formGroup.get(
      'taxResidencyRows'
    ) as FormArray<FormGroup>;
    taxRows.clear();

    // If no data is provided or the array is empty, add one empty row.
    if (!leiDetails || leiDetails.length === 0) {
      this.initializeTaxResidencyRow();
      return;
    }

    // Otherwise, map each detail into a new row.
    leiDetails.forEach((leiDetail) => {
      const countryObj = this.countries.find(
        (c) => c.name === leiDetail.countryOfTaxResidence
      );
      this.initializeTaxResidencyRow();
      const lastRow = taxRows.at(taxRows.length - 1);
      lastRow.patchValue({
        id: leiDetail.id ?? this.getNextTaxResidencyId(),
        trcNo: leiDetail.trcNumber ?? '',
        country: countryObj ? countryObj.name : '',
      });
    });
  }

  private mapIncorporationPlace(kyc: DraftFvicKycDetailsDto): void {
    const place = kyc.placeOfIncorporation ?? '';
    const countryName = kyc.countryOfIncorporation ?? '';
    const isdCode = kyc.isdCountryCodeOfIncorporation ?? '';
    const countryObj = this.countries.find((c) => c.name === countryName);
    const countryCodeObj = this.countryCodes.find(
      (code) => code.code === isdCode
    );

    this.formGroup.patchValue({
      placeOfIncorporation: place,
      countryOfIncorporation: countryObj ?? null,
      countryCodeOfIncorporation: countryCodeObj ?? null,
    });
  }

  private mapAddresses(addresses: DraftFvciAddressDetailsDto[]): void {
    // Registered Office
    const registered = addresses.find(
      (addr) => addr.typeOfAddress === 'registered'
    );
    if (registered) {
      const regCountry = this.countries.find(
        (c) => c.short_code === registered.countryCode
      );
      this.formGroup.get('registeredOffice')?.patchValue({
        registeredFlatNum: registered.flatBlockNo ?? '',
        registeredBuildingName: registered.buildingPremisesVillageName ?? '',
        registeredCountryName: regCountry ?? null,
        registeredRoadName: registered.roadStreetLaneName ?? '',
        registeredAreaName: registered.areaLocalitySubdivision ?? '',
        registeredTownName: registered.townCityDistrict ?? '',
        registeredZipName: registered.zipCode ?? '',
        registeredStateName: registered.state ?? '',
      });
    }
    // Foreign Office
    const foreign = addresses.find(
      (addr) => addr.typeOfAddress === 'foreignOffice'
    );
    if (foreign) {
      const foreignCountry = this.countries.find(
        (c) => c.short_code === foreign.countryCode
      );
      this.formGroup.get('foreignOffice')?.patchValue({
        foreignFlatNum: foreign.flatBlockNo ?? '',
        foreignBuildingName: foreign.buildingPremisesVillageName ?? '',
        foreignCountryName: foreignCountry ?? null,
        foreignRoadName: foreign.roadStreetLaneName ?? '',
        foreignAreaName: foreign.areaLocalitySubdivision ?? '',
        foreignTownName: foreign.townCityDistrict ?? '',
        foreignZipName: foreign.zipCode ?? '',
        foreignStateName: foreign.state ?? '',
      });
    }
    // Office In India
    const india = addresses.find(
      (addr) => addr.typeOfAddress === 'indianOffice'
    );
    if (india) {
      const indiaCountry = this.countries.find(
        (c) => c.short_code === india.countryCode
      );
      this.formGroup.get('OfficeInIndia')?.patchValue({
        indianFlatNum: india.flatBlockNo ?? '',
        indianBuildingName: india.buildingPremisesVillageName ?? '',
        indianCountryName: indiaCountry ?? null,
        indianRoadName: india.roadStreetLaneName ?? '',
        indianAreaName: india.areaLocalitySubdivision ?? '',
        indianTownName: india.townCityDistrict ?? '',
        indianZipName: india.zipCode ?? '',
        indianStateName: india.state ?? '',
      });
    }
  }

  private mapContactDetails(
    phones: DraftFvciTelephoneNumberDetailsDto[],
    faxes: DraftFvciFaxNumberDetailsDto[],
    contactDetails: DraftFvciEkycContactDetailsDto
  ): void {
    const contactGroup = this.formGroup.get('contactDetails') as FormGroup;

    // Map Telephone Numbers
    phones.forEach((phone) => {
      const phonePatchValue = {
        countryCode: { code: phone.countryCode },
        areaCode: phone.stdCode,
        number: phone.phoneNumber,
      };

      if (phone.phoneType === 'registered') {
        contactGroup.get('registered')?.patchValue(phonePatchValue);
      } else if (phone.phoneType === 'foreignOffice') {
        contactGroup.get('office')?.patchValue(phonePatchValue);
      } else if (phone.phoneType === 'indianOffice') {
        contactGroup.get('indianOffice')?.patchValue(phonePatchValue);
      }
    });

    // Map Fax Numbers
    faxes.forEach((fax) => {
      const faxPatchValue = {
        countryCode: { code: fax.countryCode },
        areaCode: fax.stdCode,
        number: fax.faxNumber,
      };

      if (fax.faxType === 'registered') {
        contactGroup.get('registeredFax')?.patchValue(faxPatchValue);
      } else if (fax.faxType === 'foreignOffice') {
        contactGroup.get('officeFax')?.patchValue(faxPatchValue);
      } else if (fax.faxType === 'indianOffice') {
        contactGroup.get('indianOfficeFax')?.patchValue(faxPatchValue);
      }
    });

    // Map Additional Contact Details
    contactGroup.get('emailId')?.patchValue(contactDetails.emailId);
    contactGroup.get('website')?.patchValue(contactDetails.website);
    contactGroup.get('mobileNumber')?.patchValue(contactDetails.mobileNumber);
  }

  private mapOwnership(ownership: any): void {
    if (ownership) {
      this.formGroup.patchValue({
        ultimateBeneficialOwner: !ownership.isNoEntityControlsThroughVoting,
      });
    }
  }

  private mapManagingOfficials(details: any[]): void {
    const moRows = this.formGroup.get('managingOfficialRows') as FormArray;
    moRows.clear();
    if (details.length > 0) {
      details.forEach((ownerDetail) => {
        this.initializeManagingOfficialRow();
        const newRow = moRows.at(moRows.length - 1) as FormGroup;
        newRow.get('details')?.patchValue({
          '1': ownerDetail.nameAddress || '',
          '2': ownerDetail.dateOfBirth
            ? new Date(ownerDetail.dateOfBirth)
            : null,
          '3': ownerDetail.taxResidancyJuridication || '',
          '4': ownerDetail.nationality || '',
          '5': ownerDetail.actingAlongPersonGroupNameAddress || '',
          '6': ownerDetail.boOwnershipInFvci || 0,
          '7': ownerDetail.govermentDocIdentityNumber || '',
          status: ownerDetail.status || 0,
        });
      });
    } else {
      this.initializeManagingOfficialRow();
    }
  }

  private mapIncomeDetails(incomeDetails: any): void {
    const incomeGroup = this.formGroup.get('incomeDetails') as FormGroup;

    if (incomeDetails) {
      // Convert the CSV string (if available) into an array of income source objects
      const incomeSources = incomeDetails.sourceOfIncome
        ? incomeDetails.sourceOfIncome
            .split(',')
            .map((source: string) =>
              this.incomeSourceOptions.find(
                (option) => option.name === source.trim()
              )
            )
            .filter((source: any) => source !== null)
        : [];

      // Patch the form controls with the parsed values
      incomeGroup.patchValue({
        incomeSource: incomeSources,
        businessCode: incomeDetails.codeOfBusiness || '',
        annualIncome: incomeDetails.grossAnnualIncome || 0,
        assetLess: incomeDetails.netWorth || 0,
      });
    }
  }

  private mapRegistrationDetails(registration: any): void {
    const typeOfApplicantControl = this.formGroup.get(
      'applicantType.applicantTypeName'
    );

    if (typeOfApplicantControl && registration?.typeOfApplicant) {
      const selectedTypeOfApplicant = this.typeOfApplicants?.find(
        (option) => option.code === registration.typeOfApplicant
      );

      typeOfApplicantControl.patchValue(selectedTypeOfApplicant.code || null);
    }
    const typeControl = this.formGroup.get('typeOfEntity');
    if (typeControl && registration?.typeOfEntity) {
      const selectedEntity = this.typeOfEntity?.find(
        (option) => option.code === registration.typeOfEntity
      );
      typeControl.patchValue(selectedEntity.code || null);
    }
    this.formGroup
      .get('applicantType.applicantTypeOtherEntity')
      ?.patchValue(registration.otherTypeOfApplicant);
  }

  private mapDocuments(kycDocuments: any[]): void {
    const documentMap = new Map<string, string>();
    kycDocuments.forEach((doc) =>
      documentMap.set(doc.documentType, doc.documentIdentifier)
    );

    // Assuming docData[0] is proof of identity and docData[1] is proof of address
    const proofOfIdentity = documentMap.get(this.docData[0].type) ?? null;
    const proofOfAddress = documentMap.get(this.docData[1].type) ?? null;

    this.formGroup.patchValue({
      proofOfIdentity: proofOfIdentity,
      proofOfAddress: proofOfAddress,
    });
  }

  async downloadFvciPdf(): Promise<void> {
    this.showLoader = true;
    try {
      const resp = await firstValueFrom(
        this.fvciService.apiFvciapplicationDownloadFvciApplicationByIdAsyncGet(
          this.applicationId
        )
      );
      let base64String: string;
      if (typeof resp.data === 'string') {
        base64String = resp.data;
      } else if (resp.data && typeof resp.data.pdfBase64 === 'string') {
        base64String = resp.data.pdfBase64;
      } else {
        return;
      }
      const sanitizedBase64 = base64String.replace(/\s/g, '');
      const byteCharacters = atob(sanitizedBase64);
      const byteNumbers = new Array(byteCharacters.length);
      for (let i = 0; i < byteCharacters.length; i++) {
        byteNumbers[i] = byteCharacters.charCodeAt(i);
      }
      const byteArray = new Uint8Array(byteNumbers);
      const blob = new Blob([byteArray], { type: 'application/pdf' });
      const blobUrl = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = blobUrl;
      a.download = 'FvciApplication.pdf';
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      setTimeout(() => URL.revokeObjectURL(blobUrl), 100);
    } finally {
      this.showLoader = false;
    }
  }

  get taxResidencyRows() {
    return this.formGroup.get('taxResidencyRows') as FormArray<FormGroup>;
  }

  initializeTaxResidencyRow(): void {
    const row = new FormGroup({
      id: new FormControl(this.getNextTaxResidencyId()),
      trcNo: new FormControl('', Validators.required),
      country: new FormControl('', Validators.required),
    });
    this.taxResidencyRows.push(row);
  }

  getNextTaxResidencyId(): string {
    if (this.taxResidencyRows.length === 0) return 'a)';
    const lastId = this.taxResidencyRows
      .at(this.taxResidencyRows.length - 1)
      .get('id')?.value;
    const nextChar = String.fromCharCode(lastId.charCodeAt(0) + 1);
    return `${nextChar})`;
  }

  addTaxResidencyRow(): void {
    this.initializeTaxResidencyRow();
  }

  removeTaxResidencyRow(index: number): void {
    if (this.taxResidencyRows.length > 1) {
      this.taxResidencyRows.removeAt(index);
    }
  }

  get managingOfficialRows() {
    return this.formGroup.get('managingOfficialRows') as FormArray<FormGroup>;
  }

  initializeManagingOfficialRow(): void {
    const row = new FormGroup({
      id: new FormControl(this.getNextManagingOfficialId()),
      details: new FormGroup(
        this.detailsData.reduce((acc: any, field: any) => {
          if (field.isRequire) {
            acc[field.id] = new FormControl('', Validators.required);
          } else {
            acc[field.id] = new FormControl('');
          }

          return acc;
        }, {} as { [key: string]: FormControl })
      ),
    });
    this.managingOfficialRows.push(row);
    this.progressService.updateComponentProgress(
      'ekycForm',
      this.formGroup.value,
      this.requiredMapping
    );
  }

  getFormControl(rowIndex: number, fieldId: string): FormControl {
    return (
      this.managingOfficialRows.at(rowIndex).get('details') as FormGroup
    ).get(fieldId) as FormControl;
  }

  hasError(rowIndex: number, fieldId: string): boolean {
    const control = this.getFormControl(rowIndex, fieldId);
    return control.invalid && (control.dirty || control.touched);
  }

  getNextManagingOfficialId(): string {
    if (this.managingOfficialRows.length === 0) return '1';
    const lastId = parseInt(
      this.managingOfficialRows
        .at(this.managingOfficialRows.length - 1)
        .get('id')?.value,
      10
    );
    return (lastId + 1).toString();
  }

  addManagingOfficialRow(): void {
    this.initializeManagingOfficialRow();
  }

  removeManagingOfficialRow(index: number): void {
    if (this.managingOfficialRows.length > 1) {
      this.managingOfficialRows.removeAt(index);
    }
  }

  async loadMasterData(): Promise<void> {
    this.showLoader = true;
    this.income = [];
    this.businessCodeOptions = [];
    this.incomeSourceOptions = [];

    try {
      const res: any = await firstValueFrom(
        this.commonService.apiCommonMastersGet()
      );
      if (res?.success && Array.isArray(res.data.country)) {
        this.countries = res.data.country.map((country: any) => ({
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
      if (res?.success && Array.isArray(res.data.proof_of_identity)) {
        this.proofOfIdentityOptions = res.data.proof_of_identity;
      }
      if (res?.success && Array.isArray(res.data.proof_of_address)) {
        this.proofOfAddressOptions = res.data.proof_of_address;
      }
      if (res?.success && Array.isArray(res.data.type_of_applicant)) {
        this.typeOfApplicants = res.data.type_of_applicant;
      }
      if (res?.success && Array.isArray(res.data.source_of_income)) {
        // Map the income sources from the response to incomeSourceOptions
        this.incomeSourceOptions = res.data.source_of_income.map(
          (item: any) => ({
            code: item.code,
            name: item.name,
          })
        );
      }
      if (res?.success && Array.isArray(res.data.code_of_business)) {
        this.businessCodeOptions = res.data.code_of_business.map(
          (item: any) => ({
            code: item.code,
            name: item.value, // or item.name if that's the correct field
          })
        );
      }
      if (res?.success && Array.isArray(res.data.type_of_entity)) {
        this.typeOfEntity =res.data.type_of_entity
      }
    } catch (error) {
      // Handle error as needed
    } finally {
      this.showLoader = false;
    }
  }

  private toggleForeignOfficeFieldsDisabled(disabled: boolean): void {
    const foreignOfficeGroup = this.formGroup.get('foreignOffice') as FormGroup;
    if (foreignOfficeGroup) {
      Object.keys(foreignOfficeGroup.controls).forEach((key) => {
        if(key!='notApplicableForeignOffice'){
          const control = foreignOfficeGroup.get(key);
          disabled ? control?.disable() : control?.enable();
        }
        
      });
    }
  }

  private handleSameAsAbove(): void {
    this.formGroup
      .get('sameAsAbove')
      ?.valueChanges.subscribe((isSameAsAbove: boolean) => {
        const registeredOffice = this.formGroup.get('registeredOffice')?.value;
        if (isSameAsAbove) {
          this.formGroup.get('foreignOffice')?.patchValue({
            foreignFlatNum: registeredOffice.registeredFlatNum,
            foreignBuildingName: registeredOffice.registeredBuildingName,
            foreignCountryName: registeredOffice.registeredCountryName,
            foreignRoadName: registeredOffice.registeredRoadName,
            foreignAreaName: registeredOffice.registeredAreaName,
            foreignTownName: registeredOffice.registeredTownName,
            foreignZipName: registeredOffice.registeredZipName,
            foreignStateName: registeredOffice.registeredStateName,
          });
          this.toggleForeignOfficeFieldsDisabled(true);
        } else {
          this.toggleForeignOfficeFieldsDisabled(false);
          this.formGroup.get('foreignOffice')?.reset();
          this.enableForeignOfficeFields();
        }
      });
  }

   mergeSubObject<T>(existing: T | undefined, updates: Partial<T>): T {
    return { ...(existing ?? {}), ...updates } as T;
  }

  get formControl() {
    return this.formGroup.controls;
  }

  get allCorrectValue(): boolean {
    return this.formGroup.valid;
  }

  // preSubmitValidations() {
  //   this.formControl['name'].addValidators(Validators.required);
  //   this.formControl['dateOfIncorporation'].addValidators(Validators.required)
  //   this.formControl['name'].updateValueAndValidity();
  //   this.formControl['dateOfIncorporation'].updateValueAndValidity();
  // }

  validateForm(): string[] {
    if (this.formGroup.invalid) {
      this.formGroup.markAllAsTouched(); // Highlight errors
      return this.getInvalidFields();
    }
    return [];
  }

  getInvalidFields(): string[] {
    const invalidFields: string[] = [];
    Object.keys(this.formGroup.controls).forEach((key) => {
      if (this.formGroup.get(key)?.invalid) {
        invalidFields.push(key);
      }
    });

    return invalidFields;
  }

  async saveForm(): Promise<void> {
    if (this.formGroup.value.name.length == 0) {
      const control = this.formGroup.get('name');

      if (control) {
        control.markAsTouched();
        control.markAsDirty();
        control.updateValueAndValidity(); // Re-run all validators, including custom ones
      }
      this.messageService.add({
        severity: 'error',
        summary: 'Error',
        detail: 'Please enter name to proceed to save as a draft.',
      });
      return;
    }
    this.showLoader = true;
    try {
      const existingAppResponse =
        await this.saveApplicationService.fetchExistingApplication(
          this.applicationId!
        );
      if (!existingAppResponse?.data) {
        this.router.navigate(['/dashboard/application-list']);
        return;
      }
      const existingApp: DraftFvciApplicationDto = existingAppResponse.data;
      const kycData: DraftFvicKycDetailsDto = this.prepareKycDataForSave();
      const leiDataArray: Array<DraftFvciKycLeiDetailsDto> =
        this.prepareLeiDataForSave();
      const incomeData: DraftFvciIncomeDetailsDto =
        this.prepareIncomeDataForSave();
      const beneficialOwnership: DraftFvciBenificialOwnershipByControlDto =
        this.prepareBeneficialOwnershipDataForSave();
      const addressesData: Array<DraftFvciAddressDetailsDto> =
        this.prepareAddressDataForSave();
      // Replace the array with a single object
      const investmentManagerDetails: DraftFvciInvestmentManagerDetailsDto =
        this.getInvestmentManagerDetails();
      const complianceOfficerDetails = this.getComplianceOfficerDetails();
      const complianceOfficerEmail = this.getComplianceOfficerEmail();
      const registrationData: DraftFvicRegistrationDetailsDto =
        this.prepareRegistrationDataForSave();
      const telephoneData: Array<DraftFvciTelephoneNumberDetailsDto> =
        this.prepareTelephoneDataForSave();
      const faxData: Array<DraftFvciFaxNumberDetailsDto> =
        this.prepareFaxDataForSave();
      const beneficialOwnerDetails: DraftFvciEkycBenificialOwnerDetailsDto[] =
           this.prepareBeneficialOwnerDetailsDataForSave()
      const kycDocumentDetails: DraftFvciKycDocumentDto[] =
        this.prepareDocumentDataForSave();
      const contactDetails: DraftFvciEkycContactDetailsDto =
        this.prepareContactDetailsDataForSave();
      const updatedComplianceOfficerDetails = this.mergeSubObject(
        existingApp.complianceOfficerDetails,
        complianceOfficerDetails
      );
      const updatedComplianceOfficerEmail = this.mergeSubObject(
        existingApp.complianceOfficerEmail,
        complianceOfficerEmail
      );
      const updatedRegistrationDetails = this.mergeSubObject(
        existingApp.registrationDetails,
        registrationData
      );
      const applicationData = this.saveApplicationService.prepareDataForStep1(
        this.applicationId,
        kycData,
        incomeData, // Pass the array directly
        leiDataArray,
        addressesData,
        investmentManagerDetails,
        updatedComplianceOfficerDetails,
        updatedComplianceOfficerEmail,
        updatedRegistrationDetails,
        telephoneData,
        faxData,
        beneficialOwnership,
        beneficialOwnerDetails,
        kycDocumentDetails,
        contactDetails
      );
      const response = await this.saveApplicationService.saveData(
        applicationData
      );
      if (response) {
        this.messageService.add({
          severity: 'success',
          summary: 'Success',
          detail: response.Message || 'Application saved successfully!',
        });
      } else {
        this.messageService.add({
          severity: 'error',
          summary: 'Error',
          detail: 'Failed to save application. Please try again.',
        });
      }
    } catch (error) {
      console.log(error);
      this.messageService.add({
        severity: 'error',
        summary: 'Error',
        detail: 'An unexpected error occurred. Please try again.',
      });
    } finally {
      this.showLoader = false;
      this.formGroup.markAsUntouched();
    }
  }

  // Update the data preparation function
   getInvestmentManagerDetails(): DraftFvciInvestmentManagerDetailsDto {
    const investmentManagerGroup = this.formGroup.get(
      'investmentManager'
    ) as FormGroup;
    const value = investmentManagerGroup.value;

    return {
      fvciApplicationId: this.applicationId,
      name: value['a)'] || '',
      type: value['b)'] || '',
      country: value['c)'] || '',
      phoneNumber: value['d)'] || '',
      faxNumber: value['e)'] || '',
      email: value['f)'] || '',
    };
  }

   getComplianceOfficerDetails(): DraftFvciComplianceOfficerDetailsDto {
    const group = this.formGroup.get('complianceOfficerInfo') as FormGroup;
    return {
      fvciApplicationId: this.applicationId,
      name: group.get('complianceOfficerInfoName')?.value,
      jobTitle: group.get('complianceOfficerInfoJob')?.value,
      phoneNumber: group.get('complianceOfficerInfoMobile')?.value,
      faxNumber: group.get('complianceOfficerInfoFax')?.value,
    };
  }

   getComplianceOfficerEmail(): DraftFvciComplianceOfficerEmailDto {
    const group = this.formGroup.get('complianceOfficerInfo') as FormGroup;
    return {
      fvciApplicationId: this.applicationId,
      email: group.get('complianceOfficerInfoEmail')?.value,
    };
  }

  prepareKycDataForSave(): DraftFvicKycDetailsDto {
    const formData = this.formGroup.value;
    return {
      name: formData.name,
      hasOtherName: formData.applicantOtherName?.otherNameRadio ?? false,
      otherName: formData.applicantOtherName.otherNameField,
      dateOfIncorporation: formData.dateOfIncorporation,
      dateOfCommencement: formData.dateOfCommencement,
      placeOfIncorporation: formData.placeOfIncorporation,
      countryOfIncorporation: formData.countryOfIncorporation?.name,
      isdCountryCodeOfIncorporation: formData.countryCodeOfIncorporation?.code,
      legalFormAndLawOfIncorporation: formData.legalForm,
      legalEntityIdentifier: formData.lei,
      addressOfCommunication: formData.communicationAddress,
      haveOfficeInIndia: formData.OfficeInIndia?.OfficeInIndiaRadio ?? false,
      doesOtherPersonHolderOwnership: formData.beneficialOwnership,
      isPoliticallyExposed:
        formData.politicallyExposed === 'politicallyExposedYes',
      isRelatedToPoliticallyExposed:
        formData.relatedToPoliticallyExposed ===
        'relatedToPoliticallyExposedYes',
    };
  }

  prepareAddressDataForSave(): Array<DraftFvciAddressDetailsDto> {
    const formData = this.formGroup.value;
    const addressesData: Array<DraftFvciAddressDetailsDto> = [];
    addressesData.push({
      flatBlockNo: formData.registeredOffice.registeredFlatNum,
      buildingPremisesVillageName:
        formData.registeredOffice.registeredBuildingName,
      roadStreetLaneName: formData.registeredOffice.registeredRoadName,
      areaLocalitySubdivision: formData.registeredOffice.registeredAreaName,
      townCityDistrict: formData.registeredOffice.registeredTownName,
      zipCode: formData.registeredOffice.registeredZipName,
      // countryCode: formData.registeredOffice.registeredCountryName?.code,
      state: formData.registeredOffice.registeredStateName,
      countryCode: formData.registeredOffice.registeredCountryName?.short_code,
      typeOfAddress: 'registered',
    });
    if (
      !formData.sameAsAbove &&
      !formData.foreignOffice.notApplicableForeignOffice
    ) {
      addressesData.push({
        flatBlockNo: formData.foreignOffice.foreignFlatNum,
        buildingPremisesVillageName: formData.foreignOffice.foreignBuildingName,
        roadStreetLaneName: formData.foreignOffice.foreignRoadName,
        areaLocalitySubdivision: formData.foreignOffice.foreignAreaName,
        townCityDistrict: formData.foreignOffice.foreignTownName,
        zipCode: formData.foreignOffice.foreignZipName,
        state: formData.foreignOffice.foreignStateName,
        countryCode: formData.foreignOffice.foreignCountryName?.short_code,
        typeOfAddress: 'foreignOffice',
      });
    }
    if (
      formData.OfficeInIndia.OfficeInIndiaRadio &&
      !formData.OfficeInIndia.notApplicableIndOffice
    ) {
      addressesData.push({
        flatBlockNo: formData.OfficeInIndia.indianFlatNum,
        buildingPremisesVillageName: formData.OfficeInIndia.indianBuildingName,
        roadStreetLaneName: formData.OfficeInIndia.indianRoadName,
        areaLocalitySubdivision: formData.OfficeInIndia.indianAreaName,
        townCityDistrict: formData.OfficeInIndia.indianTownName,
        zipCode: formData.OfficeInIndia.indianZipName,
        state: formData.OfficeInIndia.indianStateName,
        countryCode: formData.OfficeInIndia.indianCountryName?.short_code,
        typeOfAddress: 'indianOffice',
      });
    }
    return addressesData;
  }

  prepareTelephoneDataForSave(): Array<DraftFvciTelephoneNumberDetailsDto> {
    const formData = this.formGroup.value;
    return [
      {
        phoneType: 'registered',
        countryCode: formData.contactDetails.registered.countryCode?.code ?? '',
        stdCode: formData.contactDetails.registered.areaCode,
        phoneNumber: formData.contactDetails.registered.number,
      },
      {
        phoneType: 'foreignOffice',
        countryCode: formData.contactDetails.office.countryCode?.code ?? '',
        stdCode: formData.contactDetails.office.areaCode,
        phoneNumber: formData.contactDetails.office.number,
      },
      {
        phoneType: 'indianOffice',
        countryCode:
          formData.contactDetails.indianOffice.countryCode?.code ?? '',
        stdCode: formData.contactDetails.indianOffice.areaCode,
        phoneNumber: formData.contactDetails.indianOffice.number,
      },
    ];
  }

  prepareFaxDataForSave(): Array<DraftFvciFaxNumberDetailsDto> {
    const formData = this.formGroup.value;
    return [
      {
        faxType: 'registered',
        countryCode:
          formData.contactDetails.registeredFax.countryCode?.code ?? '',
        stdCode: formData.contactDetails.registeredFax.areaCode,
        faxNumber: formData.contactDetails.registeredFax.number,
      },
      {
        faxType: 'foreignOffice',
        countryCode: formData.contactDetails.officeFax.countryCode?.code ?? '',
        stdCode: formData.contactDetails.officeFax.areaCode,
        faxNumber: formData.contactDetails.officeFax.number,
      },
      {
        faxType: 'indianOffice',
        countryCode:
          formData.contactDetails.indianOfficeFax.countryCode?.code ?? '',
        stdCode: formData.contactDetails.indianOfficeFax.areaCode,
        faxNumber: formData.contactDetails.indianOfficeFax.number,
      },
    ];
  }

  prepareRegistrationDataForSave(): DraftFvicRegistrationDetailsDto {
    const formData = this.formGroup.value;
    console.log("formData.typeOfEntity?.code", formData.typeOfEntity    )
    return {
      typeOfEntity: formData.typeOfEntity ?? '',
      typeOfApplicant: formData.applicantType?.applicantTypeName ?? '',
      otherTypeOfApplicant:
        formData.applicantType?.applicantTypeOtherEntity ?? '',
    };
  }

  prepareContactDetailsDataForSave(): DraftFvciEkycContactDetailsDto {
    const formData = this.formGroup.value;
    return {
      fvciApplicationId: this.applicationId,
      website: formData.contactDetails.website,
      mobileNumber: formData.contactDetails.mobileNumber,
      emailId: formData.contactDetails.emailId,
    };
  }

  prepareIncomeDataForSave(): DraftFvciIncomeDetailsDto {
    const formData = this.formGroup.value;

    // Extract selected sources of income (as an array of strings)
    const selectedSources: string[] = formData.incomeDetails.incomeSource
      ? formData.incomeDetails.incomeSource.map((source: any) => source.name)
      : [];

    // Prepare the single DTO object
    const incomeDetails: DraftFvciIncomeDetailsDto = {
      fvciApplicationId: this.applicationId,
      sourceOfIncome: selectedSources, // Now storing as an array
      codeOfBusiness: formData.incomeDetails.businessCode,
      grossAnnualIncome: Number(formData.incomeDetails.annualIncome),
      netWorth: Number(formData.incomeDetails.assetLess),
    };

    return incomeDetails;
  }

  prepareLeiDataForSave(): Array<DraftFvciKycLeiDetailsDto> {
    const formData = this.formGroup.value;
    const leiDataArray: Array<DraftFvciKycLeiDetailsDto> = [];
    formData.taxResidencyRows.forEach((row: any) => {
      if (row.trcNo && row.country) {
        leiDataArray.push({
          trcNumber: row.trcNo,
          countryOfTaxResidence: row.country,
        });
      }
    });
    return leiDataArray;
  }

  prepareBeneficialOwnershipDataForSave(): DraftFvciBenificialOwnershipByControlDto {
    const formData = this.formGroup.value;
    return {
      fvciApplicationId: this.applicationId,
      isNoEntityControlsThroughVoting: !formData.ultimateBeneficialOwner,
    };
  }

  prepareBeneficialOwnerDetailsDataForSave(): DraftFvciEkycBenificialOwnerDetailsDto[] {
    const managingRows = this.formGroup.get(
      'managingOfficialRows'
    ) as FormArray;
    console.log('managingRows', managingRows);
    return managingRows.controls.map((rowControl: AbstractControl) => {
      const rowGroup = rowControl as FormGroup;
      const details = rowGroup.get('details') as FormGroup;
      // Get the date value
      const dateValue = details.get('2')?.value;

      // Format the date properly for API consumption
      let formattedDate = null;
      if (dateValue) {
        // Ensure it's a proper Date object
        if (typeof dateValue === 'string') {
          formattedDate = new Date(dateValue);
        } else {
          formattedDate = dateValue;
        }

        // Make sure it's a valid date
        if (isNaN(formattedDate.getTime())) {
          formattedDate = null;
        }
      }
      return {
        id: rowGroup.get('id')?.value,
        fvciApplicationId: this.applicationId,
        nameAddress: details.get('1')?.value,
        dateOfBirth: formattedDate, // Use the formatted date
        taxResidancyJuridication: details.get('3')?.value,
        nationality: details.get('4')?.value,
        actingAlongPersonGroupNameAddress: details.get('5')?.value,
        boOwnershipInFvci: details.get('6')?.value
          ? details.get('6')?.value
          : null,
        govermentDocIdentityNumber: details.get('7')?.value,
        status: details.get('status')?.value ?? 0,
      };
    });
  }

  prepareDocumentDataForSave(): DraftFvciKycDocumentDto[] {
    const formData = this.formGroup.value;
    const documents: DraftFvciKycDocumentDto[] = [];

    // Add proof of identity document if provided
    if (formData.proofOfIdentity) {
      documents.push({
        documentType: this.docData[0].type,
        documentIdentifier: formData.proofOfIdentity,
        documentPath: '',
        status: 1,
      });
    }

    // Add proof of address document if provided
    if (formData.proofOfAddress) {
      documents.push({
        documentType: this.docData[1].type,
        documentIdentifier: formData.proofOfAddress,
        documentPath: '',
        status: 1,
      });
    }

    return documents;
  }

  submitForm(): boolean {
    this.formGroup.markAllAsTouched();
    if (this.formGroup.valid) {
      return true;
    } else {
      return false;
    }
  }
  allowAlpha(event: KeyboardEvent) {
    // Only letters (upper/lowercase) and space
    const allowedPattern = /^[A-Za-z ]$/;
    if (!allowedPattern.test(event.key)) {
      event.preventDefault();
    }
  }

  allowNumberOnly(event: KeyboardEvent) {
    // Only letters (upper/lowercase) and space
    const allowedPattern = /^[0-9]$/;
    if (!allowedPattern.test(event.key)) {
      event.preventDefault();
    }
  }

  allowAlphaNumeric(event: KeyboardEvent) {
    // Letters (upper/lowercase), numbers, and space allowed
    const allowedPattern = /^[A-Za-z0-9 ]$/;
    if (!allowedPattern.test(event.key)) {
      event.preventDefault();
    }
  }

  onlyAllowAlphaNumeric(event: KeyboardEvent) {
    // Letters (upper/lowercase), numbers, and space allowed
    const allowedPattern = /^[A-Za-z0-9]$/;
    if (!allowedPattern.test(event.key)) {
      event.preventDefault();
    }
  }

  handleKeyPress(event: KeyboardEvent, fieldId: string) {
    if (fieldId === 'e)' || fieldId === 'd)') {
      const allowedPattern = /[0-9]/;
      if (!allowedPattern.test(event.key)) {
        event.preventDefault();
      }
    }
  }
}
