import {
  Component,
  Input,
  OnInit,
  OnDestroy,
  ViewEncapsulation,
  SimpleChanges,
  ChangeDetectorRef,
} from '@angular/core';
import {
  AbstractControl,
  FormArray,
  FormControl,
  FormGroup,
  Validators,
  FormBuilder,
} from '@angular/forms';
import {
  City,
  designationData,
  regulationData,
  priorAssociationDetailsData,
  Income,
} from '../../data';
import { debounceTime, firstValueFrom, Subscription, take } from 'rxjs';
import {
  CommonService,
  DraftFvciApplicationDto,
  DraftFvciGlobalCustodianDetailsDto,
  DraftFvciIncidentsOfLawViolationDto,
  DraftFvciIncomeDetailsDto,
  DraftFvciIndianMarketAssociansDto,
  DraftFvciRegulatoryAuthorityDetailsDto,
  DraftFvicRegistrationDetailsDto,
} from '../../../../../swagger';
import { SaveApplicationService } from '../../../../services/save-application.service';
import { MessageService } from 'primeng/api';
import { Router } from '@angular/router';
import { FormProgressService } from '../../../../services/form-progress.service';
import { FormValidationService } from '../../../../services/form-validation.service';


@Component({
  selector: 'app-registration-form',
  templateUrl: './registration-form.component.html',
  styleUrls: ['./registration-form.component.scss'],
  standalone: false,
  encapsulation: ViewEncapsulation.None, // Add this to allow our preview styles to affect child components
})
export class RegistrationFormComponent implements OnInit, OnDestroy {
  @Input() applicationId?: string | undefined;
  @Input() applicationData!: any;
  @Input() previewMode: boolean = false;
  @Input() formGroup!: FormGroup;
  @Input() masterData!: any;
  @Input() viewMode: string | undefined; // passed from parent
  private saveSubscription!: Subscription;
  showLoader = false;
  download = '/assets/downloads.png';
  countries: any[] = [];
  countryCodes: any[] = [];
  countries_pan: any[] = [];
  countryCodes_pan: any[] = [];
  countryShortCodes_pan: any[] = [];
  ddpOptions!: any[];
  regulatoryAuthorityOptions!: any[];
  custodianOptions!: any[];
  registeredOrAssociatedAs = [
    { name: 'FPI' },
    { name: 'FII' },
    { name: 'Sub Account' },
    { name: 'QFI' },
    { name: 'FVCI' },
  ];

  bankOptions!: any[];
  incomeSourceOptions!: Income[];
  regulationData = regulationData;
  designationData = designationData;
  detailsData: any = priorAssociationDetailsData;
  // Add this line to define the property
  proofOfIdentityOptions!: any[];
  countryShortCodes: any[] = [];
  gcinitialise: boolean = false;

  suppressGlobalCustodianValidation: boolean = false;

  hasOtherEntity = false;

  constructor(
    private readonly commonService: CommonService,
    private readonly saveApplicationService: SaveApplicationService,
    private readonly messageService: MessageService,
    private readonly router: Router,
    private readonly progressService: FormProgressService,
    private validationService: FormValidationService,
    private fb: FormBuilder,
    private cdr: ChangeDetectorRef
  ) {}

  ngOnInit(): void {
    this.initializePriorAssociationRows();

    this.formGroup
      .get('priorAssociation.priorAssociationRadio')
      ?.valueChanges.subscribe((value) => {
        if (value === true && this.priorAssiciationRows.length === 0) {
          this.addPriorAssociationRow();
        }

        if (value === false) {
          this.priorAssiciationRows.clear(); // Optional: Clear rows when user selects "No"
        }
      });

    if (
      !this.regulatoryAuthorityOptions ||
      this.regulatoryAuthorityOptions.length === 0
    ) {
      this.loadMasterData();
    }

    this.validationSubscribe();
  }

  validationSubscribe() {
    // Subscribe to hasPanRadio value changes
    this.formGroup
      .get('hasPan.hasPanRadio')
      ?.valueChanges.subscribe((value) => {
        if (value === true) {
          this.formGroup
            .get('hasPan.hasPanNumber')
            ?.setValidators([Validators.required]);
        } else {
          this.formGroup.get('hasPan.hasPanNumber')?.clearValidators();
          this.formGroup.get('hasPan.hasPanNumber')?.setValue('');
        }
        // Update validation
        this.formGroup.get('hasPan.hasPanNumber')?.updateValueAndValidity();
      });

    // Subscribe to disciplinaryHistoryRadio value changes
    this.formGroup
      .get('disciplinaryHistory.disciplinaryHistoryRadio')
      ?.valueChanges.subscribe((value) => {
        if (value === true) {
          this.formGroup
            .get('disciplinaryHistory.disciplinaryHistoryText')
            ?.setValidators([Validators.required]);
        } else {
          this.formGroup
            .get('disciplinaryHistory.disciplinaryHistoryText')
            ?.clearValidators();
          this.formGroup
            .get('disciplinaryHistory.disciplinaryHistoryText')
            ?.setValue('');
        }
        // Update validation
        this.formGroup
          .get('disciplinaryHistory.disciplinaryHistoryText')
          ?.updateValueAndValidity();
      });

    // Subscribe to throughGlobalCustodianRadio value changes
    this.formGroup
      .get('throughGlobalCustodian.throughGlobalCustodianRadio')
      ?.valueChanges.subscribe((value) => {
        // if(this.suppressGlobalCustodianValidation){return}
        if (value === 'throughGlobalCustodianRadioYes') {
          this.formGroup
            .get('throughGlobalCustodian.throughGlobalCustodianName')
            ?.setValidators([Validators.required]);
          this.formGroup
            .get('throughGlobalCustodian.throughGlobalCustodianAddress')
            ?.setValidators([Validators.required]);
          this.formGroup
            .get('throughGlobalCustodian.throughGlobalCustodianRegistration')
            ?.setValidators([Validators.required]);
        } else {
          this.formGroup
            .get('throughGlobalCustodian.throughGlobalCustodianName')
            ?.clearValidators();
          this.formGroup
            .get('throughGlobalCustodian.throughGlobalCustodianName')
            ?.setValue('');
          this.formGroup
            .get('throughGlobalCustodian.throughGlobalCustodianAddress')
            ?.clearValidators();
          this.formGroup
            .get('throughGlobalCustodian.throughGlobalCustodianAddress')
            ?.setValue('');
          this.formGroup
            .get('throughGlobalCustodian.throughGlobalCustodianRegistration')
            ?.clearValidators();
          this.formGroup
            .get('throughGlobalCustodian.throughGlobalCustodianRegistration')
            ?.setValue('');
        }
        this.formGroup
          .get('throughGlobalCustodian.throughGlobalCustodianName')
          ?.updateValueAndValidity();
        this.formGroup
          .get('throughGlobalCustodian.throughGlobalCustodianAddress')
          ?.updateValueAndValidity();
        this.formGroup
          .get('throughGlobalCustodian.throughGlobalCustodianRegistration')
          ?.updateValueAndValidity();
      });
  }

  ngOnDestroy(): void {
    if (this.saveSubscription) {
      this.saveSubscription.unsubscribe();
    }
  }

  get allCorrectValue(): boolean {
    return this.formGroup.valid;
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['masterData'] && changes['masterData'].currentValue) {
      // Now you can work with masterData here
      this.initializeMasterData();
    }
    if (changes['applicationData'] && changes['applicationData'].currentValue) {
      this.initialiseForm();
    }
  }

  initialiseForm() {
    // Set basic form values
    this.formGroup
      .get('providedValidForm')
      ?.setValue(
        this.applicationData.data?.registrationForm?.providedValidForm
      );

      // const regularAuthorityObj = this.regulatoryAuthorityOptions.find(
      //   (c) => c.name === this.applicationData.data?.registrationForm?.regulatoryAuthorityName
      // );
      
     this.formGroup.get('regulatoryAuthorityName')?.setValue(this.applicationData.data?.registrationForm?.regulatoryAuthorityName)
      this.formGroup.get('regulatoryAuthorityCountry')?.setValue(this.applicationData.data?.registrationForm?.regulatoryAuthorityCountry)
      this.formGroup.get('regulatoryAuthorityWebsite')?.setValue(this.applicationData.data?.registrationForm?.regulatoryAuthorityWebsite)
      const custodianGroup = this.formGroup.get('throughGlobalCustodian') as FormGroup;
      this.suppressGlobalCustodianValidation = true;
      // this.formGroup.get('throughGlobalCustodian.throughGlobalCustodianRadio')?.setValue(this.applicationData.data?.registrationForm?.throughGlobalCustodian?.throughGlobalCustodianRadio)
    if(this.applicationData.data?.registrationForm?.throughGlobalCustodian?.throughGlobalCustodianRadio == 'throughGlobalCustodianRadioYes'){
      custodianGroup.patchValue({
        throughGlobalCustodianName: this.applicationData.data?.registrationForm?.throughGlobalCustodian?.throughGlobalCustodianName || '',
        throughGlobalCustodianAddress: this.applicationData.data?.registrationForm?.throughGlobalCustodian?.throughGlobalCustodianAddress || '',
        throughGlobalCustodianRegistration: this.applicationData.data?.registrationForm?.throughGlobalCustodian?.throughGlobalCustodianRegistration || ''
      });
     const countryObjg = this.countries_pan.find(
        (c) =>
          c.short_code ===
          this.applicationData.data?.registrationForm?.throughGlobalCustodian?.throughGlobalCustodianCountry?.short_code
      );
      custodianGroup.get('throughGlobalCustodianCountry')?.setValue(countryObjg);

    }
    custodianGroup.get('throughGlobalCustodianRadio')?.setValue(this.applicationData.data?.registrationForm?.throughGlobalCustodian?.throughGlobalCustodianRadio);
    this.suppressGlobalCustodianValidation = false;

    // Set regulatory authority fields
    this.formGroup
      .get('regulatoryAuthorityRegNumber')
      ?.setValue(
        this.applicationData.data?.registrationForm
          ?.regulatoryAuthorityRegNumber
      );
    this.formGroup
      .get('regulatoryAuthorityCategory')
      ?.setValue(
        this.applicationData.data?.registrationForm?.regulatoryAuthorityCategory
      );
    // Set PAN fields
    this.formGroup
      .get('hasPan.hasPanRadio')
      ?.setValue(
        this.applicationData.data?.registrationForm?.hasPan?.hasPanRadio
      );
    this.formGroup
      .get('hasPan.hasPanNumber')
      ?.setValue(
        this.applicationData.data?.registrationForm?.hasPan?.hasPanNumber
      );

    // Set disciplinary history fields
    this.formGroup
      .get('disciplinaryHistory.disciplinaryHistoryRadio')
      ?.setValue(
        this.applicationData.data?.registrationForm?.disciplinaryHistory
          ?.disciplinaryHistoryRadio
      );
    this.formGroup
      .get('disciplinaryHistory.disciplinaryHistoryText')
      ?.setValue(
        this.applicationData.data?.registrationForm?.disciplinaryHistory
          ?.disciplinaryHistoryText
      );

     
    // Set prior association radio
    const priorAssociationRadio =
      this.applicationData.data?.registrationForm?.priorAssociation
        ?.priorAssociationRadio;
    this.formGroup
      .get('priorAssociation.priorAssociationRadio')
      ?.setValue(priorAssociationRadio);

    // Load master data and then set select dropdown values
    // this.loadMasterData().then(() => {
    //   // Set DDP field
      
    // });
    
    if (this.applicationData.data?.registrationForm?.ddpName) {
      const ddpName =
        typeof this.applicationData.data.registrationForm.ddpName === 'object'
          ? this.applicationData.data.registrationForm.ddpName.name
          : this.applicationData.data.registrationForm.ddpName;

      const ddpOption = this.ddpOptions.find((opt) => opt.name === ddpName);
      if (ddpOption) {
        this.formGroup.get('ddpName')?.setValue(ddpOption);
        this.formGroup
          .get('ddpRegistrationNumber')
          ?.setValue(
            this.applicationData.data.registrationForm
              .ddpRegistrationNumber ||
              ddpOption.registrationNumber ||
              ''
          );
      }
    }

    // Set Custodian field
    if (this.applicationData.data?.registrationForm?.custodianName) {
      const custodianName =
        typeof this.applicationData.data.registrationForm.custodianName ===
        'object'
          ? this.applicationData.data.registrationForm.custodianName.name
          : this.applicationData.data.registrationForm.custodianName;

      const custodianOption = this.custodianOptions.find(
        (opt) => opt.name === custodianName
      );
      if (custodianOption) {
        this.formGroup.get('custodianName')?.setValue(custodianOption);
        this.formGroup
          .get('custodianRegistrationNumber')
          ?.setValue(
            this.applicationData.data.registrationForm
              .custodianRegistrationNumber ||
              custodianOption.registrationNumber ||
              ''
          );
      }
    }

    // Set DP field
    if (this.applicationData.data?.registrationForm?.dpName) {
      const dpName =
        typeof this.applicationData.data.registrationForm.dpName === 'object'
          ? this.applicationData.data.registrationForm.dpName.name
          : this.applicationData.data.registrationForm.dpName;

      const dpOption = this.ddpOptions.find((opt) => opt.name === dpName);
      if (dpOption) {
        this.formGroup.get('dpName')?.setValue(dpOption);
        this.formGroup
          .get('dpRegistrationNumber')
          ?.setValue(
            this.applicationData.data.registrationForm.dpRegistrationNumber ||
              dpOption.registrationNumber ||
              ''
          );
      }
    }

    // Set Bank fields
    if (this.applicationData.data?.registrationForm?.designatedBank) {
      const bankData =
        this.applicationData.data.registrationForm.designatedBank;
      let bankOption;

      if (bankData.designatedBankName) {
        const bankName =
          typeof bankData.designatedBankName === 'object'
            ? bankData.designatedBankName.name
            : bankData.designatedBankName;

        bankOption = this.bankOptions.find((opt) => opt.name === bankName);
      }

      if (bankOption) {
        this.formGroup
          .get('designatedBank.designatedBankName')
          ?.setValue(bankOption);
        this.formGroup
          .get('designatedBank.designatedBankAddress')
          ?.setValue(
            bankOption.address || bankData.designatedBankAddress || ''
          );
      } else if (
        bankData.designatedBankName ||
        bankData.designatedBankAddress
      ) {
        const tempBankOption = {
          name:
            typeof bankData.designatedBankName === 'object'
              ? bankData.designatedBankName.name
              : bankData.designatedBankName,
          address: bankData.designatedBankAddress,
          value: null,
        };
        this.formGroup
          .get('designatedBank.designatedBankName')
          ?.setValue(tempBankOption);
        this.formGroup
          .get('designatedBank.designatedBankAddress')
          ?.setValue(bankData.designatedBankAddress || '');
      }
    }

    // Handle prior association rows
    const priorAssociationRows =
      this.applicationData.data?.registrationForm?.priorAssiciationRows;
    if (
      priorAssociationRadio === true &&
      priorAssociationRows &&
      Array.isArray(priorAssociationRows) &&
      priorAssociationRows.length > 0
    ) {
      this.patchPriorAssociation(priorAssociationRows);
    }
    if(this.viewMode =="true"){
      this.formGroup.disable()
    }
  }

  // private patchPriorAssociation(data: any[]): void {
  //   if (!data || data.length === 0) return;

  //   const priorAssociationArray = this.priorAssiciationRows;
  //   // Clear any existing rows
  //   priorAssociationArray.clear();

  //   // Add a row for each item in the data
  //   data.forEach(item => {
  //     // Create a new row
  //     this.addPriorAssociationRow();

  //     // Get the last row (the one we just added)
  //     const lastRow = priorAssociationArray.at(priorAssociationArray.length - 1);

  //     // Patch the form values
  //     lastRow.patchValue({
  //       entityName: item.entityName || '',
  //       registrationType: item.registrationType || '',
  //       sebiRegNumber: item.sebiRegNumber || '',
  //       registrationPeriod: item.registrationPeriod || null
  //     });
  //   });
  // }

  private patchPriorAssociation(data: any[]): void {
    if (!data || data.length === 0) return;

    const priorAssociationArray = this.priorAssiciationRows;
    // Clear any existing rows
    priorAssociationArray.clear();

    // Add a row for each item in the data
    data.forEach((item) => {
      // Create a new row
      this.addPriorAssociationRow();

      // Get the last row (the one we just added)
      const lastRow = priorAssociationArray.at(
        priorAssociationArray.length - 1
      );

      // Convert registration period string dates to Date objects if needed
      let registrationPeriod = item.registrationPeriod;
      if (registrationPeriod && Array.isArray(registrationPeriod)) {
        // Convert ISO strings to Date objects
        registrationPeriod = registrationPeriod.map((date) =>
          typeof date === 'string' ? new Date(date) : date
        );
      }

      // Patch the form values
      lastRow.patchValue({
        entityName: item.entityName || '',
        registrationType: item.registrationType || '',
        sebiRegNumber: item.sebiRegNumber || '',
        registrationPeriod: registrationPeriod,
      });
    });
  }

  initializeMasterData(): void {
    if (Array.isArray(this.masterData.country)) {
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

      if (Array.isArray(this.masterData.ddp)) {
        this.ddpOptions = this.masterData.ddp.map((ddp: any) => ({
          name: ddp.ddp_name,
          value: ddp.ddp_id,
          registrationNumber: ddp.sebi_registration_no,
          ddpId: ddp.ddp_id,
        }));
      }
      if (Array.isArray(this.masterData.country_pan)) {
        this.countries_pan = this.masterData.country_pan.map(
          (country: any) => ({
            name: country.country_name,
            code: country.country_code.toString(),
            short_code: country.country_short_code,
            id: country.country_id,
          })
        );
        this.countryCodes_pan = this.countries_pan
          .map(({ code }) => ({ code }))
          .filter((item) => item.code != null && item.code !== '');
        this.countryShortCodes_pan = this.countries_pan
          .map(({ short_code }) => ({ short_code }))
          .filter((item) => item.short_code != null && item.short_code !== '');
      }
      if (Array.isArray(this.masterData.custodian)) {
        this.custodianOptions = this.masterData.custodian.map(
          (custodian: any) => ({
            name: custodian.cust_nm,
            value: custodian.cust_id,
            registrationNumber: custodian.cust_reg_no,
          })
        );
      }
      if (Array.isArray(this.masterData.bank)) {
        this.bankOptions = this.masterData.bank.map((bank: any) => ({
          name: bank.bank_name,
          value: bank.bank_id,
          address: bank.address,
        }));
      }
      if (Array.isArray(this.masterData.source_of_income)) {
        // Map the income sources from the response to incomeSourceOptions
        this.incomeSourceOptions = this.masterData.source_of_income.map(
          (item: any) => ({
            code: item.code,
            name: item.name,
          })
        );
      }
    }
  }

  populateFormWithApplicationData(appData: DraftFvciApplicationDto): void {
    if (!appData) return;

    // In preview mode, we need to handle dropdown values differently
    
      // Normal case - proceed as before
      this.mapDesignationDetails(appData);
      this.mapApplicantDetails(appData);
      this.mapRegulatoryAuthorityDetails(appData);
      
      this.mapIndianMarketAssociations(appData.indianMarketAssocians || []);
    
  }

  private mapDesignationDetails(appData: any): void {
    // We need to wait for the options to be loaded before setting the values
    // This ensures we have the dropdown options available
    this.loadMasterData().then(() => {
      // Find the matching DDP option based on name or registration number
      const ddpName = appData.registrationDetails?.ddpName || '';
      const ddpOption = this.ddpOptions?.find(
        (opt) =>
          opt.name === ddpName ||
          opt.registrationNumber ===
            appData.registrationDetails?.ddpRegistrationNumber
      );

      // Find the matching Custodian option
      const custodianName = appData.registrationDetails?.custodianName || '';
      const custodianOption = this.custodianOptions?.find(
        (opt) =>
          opt.name === custodianName ||
          opt.registrationNumber ===
            appData.registrationDetails?.custodianRegistrationNumber
      );

      // Find the matching DP option (using same options as DDP)
      const dpName = appData.registrationDetails?.dpName || '';
      const dpOption = this.ddpOptions?.find(
        (opt) =>
          opt.name === dpName ||
          opt.registrationNumber ===
            appData.registrationDetails?.dpRegistrationNumber
      );

      // Now patch the form with the full option objects
      this.formGroup.patchValue({
        ddpName: ddpOption || '',
        ddpRegistrationNumber:
          appData.registrationDetails?.ddpRegistrationNumber || '',
        custodianName: custodianOption || '',
        custodianRegistrationNumber:
          appData.registrationDetails?.custodianRegistrationNumber || '',
        dpName: dpOption || '',
        dpRegistrationNumber:
          appData.registrationDetails?.dpRegistrationNumber || '',
      });
    });
  }

  private mapApplicantDetails(appData: any): void {
    // For bank dropdown, we need to find the matching option
    const bankName = appData.registrationDetails?.bankName || '';
    const bankOption = this.bankOptions?.find(
      (opt) =>
        opt.name === bankName ||
        opt.address === appData.registrationDetails?.bankAddress
    );

    this.formGroup.patchValue({
      applicantType: {
        applicantTypeName: appData.registrationDetails?.typeOfApplicant || '',
        // Instead of defaulting to 'applicantTypeRadioNo', set to null so it isn't counted as filled.
        applicantTypeRadio: appData.registrationDetails?.otherTypeOfApplicant
          ?.length
          ? 'applicantTypeRadioYes'
          : 'applicantTypeRadioNo',
        applicantTypeOtherEntity:
          appData.registrationDetails?.otherTypeOfApplicant || '',
      },
      providedValidForm:
        appData.registrationDetails?.isProvidedFactaCrsProvided || false,
      throughGlobalCustodian: {
        // Set to null if data isn't available, rather than a default string.
        throughGlobalCustodianRadio: appData.registrationDetails
          ?.isComingFromGlobalCustodian
          ? 'throughGlobalCustodianRadioYes'
          : null,
        throughGlobalCustodianName: appData.globalCustodianDetails?.name || '',

        throughGlobalCustodianCountry:
          appData.globalCustodianDetails?.country || '',

        throughGlobalCustodianRegistration:
          appData.globalCustodianDetails?.registrationNumber || '',
        throughGlobalCustodianAddress:
          appData.globalCustodianDetails?.address || '',
      },
      designatedBank: {
        designatedBankName: bankOption || '', // Set the full bank option object
        designatedBankAddress: appData.registrationDetails?.bankAddress || '',
      },
      priorAssociation: {
        priorAssociationRadio:
          appData.registrationDetails?.isAssociatedWithSecuritiesMarket !==
          undefined
            ? !!appData.registrationDetails.isAssociatedWithSecuritiesMarket
            : null,
      },
      hasPan: {
        hasPanRadio: appData.registrationDetails?.doesHoldPan || null,
        hasPanNumber: appData.registrationDetails?.panNumber || '',
      },
      disciplinaryHistory: {
        disciplinaryHistoryRadio:
          appData.registrationDetails?.isViolatedLaw || null,
        disciplinaryHistoryText:
          appData.incidentsOfLawViolation?.description || '',
      },
    });
  }

  private mapIndianMarketAssociations(details: any[]): void {
    const moRows = this.formGroup.get('priorAssiciationRows') as FormArray;
    moRows.clear();
    if (details.length > 0) {
      details.forEach((ownerDetail) => {
        this.initializePriorAssociationRows();
        const newRow = moRows.at(moRows.length - 1) as FormGroup;
        newRow.get('details')?.patchValue({
          '1': ownerDetail.name || '',
          '2': ownerDetail.associatedAs || '',
          '3': ownerDetail.registrationNumber || '',
          '4': ownerDetail.periodOfRegistration || '',
        });
      });
    } else {
      this.initializePriorAssociationRows();
    }
  }

  private mapRegulatoryAuthorityDetails(appData: any): void {
    if (appData.regulatoryAuthorityDetails) {
      const regDetails = appData.regulatoryAuthorityDetails;
      this.formGroup.patchValue({
        regulatoryAuthorityName: regDetails.regulatoryAuthorityName || '',
        regulatoryAuthorityCountry: regDetails.regulatoryAuthorityCountry || '',
        regulatoryAuthorityWebsite: regDetails.regulatoryAuthorityWebsite || '',
        regulatoryAuthorityRegNumber:
          regDetails.regulatoryAuthorityRegNumber || '',
        regulatoryAuthorityCategory:
          regDetails.regulatoryAuthorityCategory || '',
      });
    }
  }

  async loadMasterData(): Promise<void> {
    try {
      const res: any = await firstValueFrom(
        this.commonService.apiCommonMastersGet()
      );
      if (res?.success && Array.isArray(res.data.country)) {
        this.countries = res.data.country.map((country: any) => ({
          name: country.country_name,
          code: country.country_code,
          id: country.country_id,
        }));
        this.countryCodes = this.countries.map(({ code }) => ({ code }));
      }
      if (res?.success && Array.isArray(res.data.ddp)) {
        this.ddpOptions = res.data.ddp.map((ddp: any) => ({
          name: ddp.ddp_name,
          value: ddp.ddp_id,
          registrationNumber: ddp.sebi_registration_no,
          DdpId: ddp.ddp_id,
        }));
      }
      if (res?.success && Array.isArray(res.data.custodian)) {
        this.custodianOptions = res.data.custodian.map((custodian: any) => ({
          name: custodian.cust_nm,
          value: custodian.cust_id,
          registrationNumber: custodian.cust_reg_no,
        }));
      }
      if (res?.success && Array.isArray(res.data.bank)) {
        this.bankOptions = res.data.bank.map((bank: any) => ({
          name: bank.bank_name,
          value: bank.bank_id,
          address: bank.address,
        }));
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
      if (res?.success && Array.isArray(res.data.regulatory_authority)) {
        this.regulatoryAuthorityOptions = res.data.regulatory_authority.map(
          (regulatory_authority: any) => ({
            name: regulatory_authority.regulatory_name, // This should match optionLabel in the template
            country: regulatory_authority.country_name,
            website: regulatory_authority.website,
          })
        );
      }
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  }

  onRegulatoryAuthoritySelected(event: any): void {
    const regulatoryAuthObject = this.regulatoryAuthorityOptions.find(
      (c) => c.name === event.value
    );
    this.formGroup
      .get('regulatoryAuthorityCountry')
      ?.patchValue(regulatoryAuthObject.country || null);
    this.formGroup
      .get('regulatoryAuthorityWebsite')
      ?.patchValue(regulatoryAuthObject.website || 'dd');
  }

  onDdpSelected(event: any, index: number): void {
    const selectedOption = event.value;

    if (index === 0) {
      this.formGroup
        .get('ddpRegistrationNumber')
        ?.patchValue(selectedOption?.value || '');
    } else if (index === 1) {
      this.formGroup
        .get('custodianRegistrationNumber')
        ?.patchValue(selectedOption?.value || '');
    } else if (index === 2) {
      this.formGroup
        .get('dpRegistrationNumber')
        ?.patchValue(selectedOption?.value || '');
    }
  }

  onBankSelected(event: any): void {
    const selectedBank = event.value;
    const bankGroup = this.formGroup.get('designatedBank') as FormGroup;

    bankGroup
      .get('designatedBankAddress')
      ?.patchValue(selectedBank?.address || '');
  }

  get regulatoryAuthorityDetails(): FormArray<FormControl<string | null>> {
    return this.formGroup.get('regulatoryAuthorityDetails') as FormArray<
      FormControl<string | null>
    >;
  }

  get designatorDetails(): FormArray<FormGroup> {
    return this.formGroup.get('designatorDetails') as FormArray<FormGroup>;
  }

  private mergeSubObject<T>(existing: T | undefined, updates: Partial<T>): T {
    return { ...(existing ?? {}), ...updates } as T;
  }

  get formControl() {
    return this.formGroup.controls;
  }

  prepareIncomeDataForSave(incomeDetailsData: any): DraftFvciIncomeDetailsDto {
    // Extract selected sources of income (as an array of strings)
    const selectedSources: string[] =
      incomeDetailsData.incomeDetails.sourceOfIncome.split(',');

    // Prepare the single DTO object
    const incomeDetails: DraftFvciIncomeDetailsDto = {
      fvciApplicationId: this.applicationId,
      sourceOfIncome: selectedSources, // Now storing as an array
      codeOfBusiness: incomeDetailsData.incomeDetails.businessCode,
      grossAnnualIncome: Number(incomeDetailsData.incomeDetails.annualIncome),
      netWorth: Number(incomeDetailsData.incomeDetails.assetLess),
    };

    return incomeDetails;
  }

  

  initializePriorAssociationRows(): FormGroup {
    return this.fb.group({
      entityName: ['', Validators.required],
      registrationType: ['', Validators.required],
      sebiRegNumber: [''],
      registrationPeriod: ['', Validators.required],
    });
  }

  get priorAssiciationRows(): FormArray {
    return this.formGroup.get('priorAssiciationRows') as FormArray;
  }

  addPriorAssociationRow(): void {
    const group = new FormGroup({
      entityName: new FormControl('', Validators.required),
      registrationType: new FormControl('', Validators.required),
      sebiRegNumber: new FormControl('', Validators.required),
      registrationPeriod: new FormControl<Date[] | null>(
        null,
        Validators.required
      ),
    });

    this.priorAssiciationRows.push(group);

    // Force change detection if necessary
    setTimeout(() => this.cdr.detectChanges(), 0);
  }

  removePriorAssociationRow(index: number): void {
    this.priorAssiciationRows.removeAt(index);
  }

  // initializePriorAssociationRows(): void {
  //   const row = new FormGroup({
  //     id: new FormControl(this.getNextManagingOfficialId()),
  //     details: new FormGroup(
  //       this.detailsData.reduce((acc: any, field: any) => {
  //         if(field.isRequired){
  //           acc[field.id] = new FormControl('');
  //         }else{
  //           acc[field.id] = new FormControl('');
  //         }

  //         return acc;
  //       }, {} as { [key: string]: FormControl })
  //     ),
  //   });
  //   this.priorAssiciationRows.push(row);
  //   // this.progressService.updateComponentProgress(
  //   //   'ekycForm',
  //   //   this.formGroup.value,
  //   //   this.requiredMapping
  //   // );
  // }

  getNextManagingOfficialId(): string {
    if (this.priorAssiciationRows.length === 0) return '1';
    const lastId = parseInt(
      this.priorAssiciationRows
        .at(this.priorAssiciationRows.length - 1)
        .get('id')?.value,
      10
    );
    return (lastId + 1).toString();
  }

  hasError(rowIndex: number, fieldId: string): boolean {
    const control = this.getFormControl(rowIndex, fieldId);
    return control.invalid && (control.dirty || control.touched);
  }

  getFormControl(rowIndex: number, fieldId: string): FormControl {
    return (
      this.priorAssiciationRows.at(rowIndex).get('details') as FormGroup
    ).get(fieldId) as FormControl;
  }

  handlePanInput(event: KeyboardEvent, inputElement: HTMLInputElement): void {
    const allowedPattern = /^[A-Z]{0,5}[0-9]{0,4}[A-Z]?$/;
    
    // Get current value + the new character
    const currentValue = inputElement.value.toUpperCase(); // convert to uppercase
    const newChar = (event.key || '').toUpperCase();

    // Allow navigation keys (e.g., arrows, backspace)
    const navigationKeys = ['Backspace', 'ArrowLeft', 'ArrowRight', 'Tab', 'Delete'];
    if (navigationKeys.includes(event.key)) return;

    const proposedValue = currentValue + newChar;

    // Prevent input if the pattern doesn't match or length exceeds 10
    if (!allowedPattern.test(proposedValue) || proposedValue.length > 10) {
        event.preventDefault();
    } else {
        // Apply uppercase immediately
        inputElement.value = currentValue;
    }
}

scrollToFirstInvalidField(): void {
  setTimeout(() => {
    const firstInvalid = this.findFirstInvalidControl(this.formGroup);
    if (firstInvalid) {
      const controlName = this.getControlName(firstInvalid);
      if (controlName) {
        let el = document.querySelector(`[formControlName="${controlName}"]`);

        // 🔁 Fallback for PrimeNG radio buttons or hidden inputs
        if (!el) {
          el = document.querySelector(`[name="${controlName}"]`);
        }

        // Try navigating to the parent radio wrapper if necessary
        if (el && el.closest('.p-radiobutton')) {
          el = el.closest('.p-radiobutton');
        }

        if (el) {
          (el as HTMLElement).scrollIntoView({ behavior: 'smooth', block: 'center' });
          (el as HTMLElement).focus();
        }
      }
    }
  }, 300);
}

private findFirstInvalidControl(form: FormGroup | FormArray): AbstractControl | null {
  for (const key of Object.keys((form as FormGroup).controls || [])) {
    const control = (form as FormGroup).get(key);

    if (control instanceof FormGroup || control instanceof FormArray) {
      const childInvalid = this.findFirstInvalidControl(control);
      if (childInvalid) {
        return childInvalid;
      }
    } else if (control && control.invalid) {
      return control;
    }
  }
  return null;
}

private getControlName(control: AbstractControl): string | null {
  let controlName: string | null = null;

  const findName = (controls: { [key: string]: AbstractControl }, parentPath: string = '') => {
    for (const name in controls) {
      if (controls[name] === control) {
        controlName = parentPath ? `${parentPath}.${name}` : name;
        break;
      } else if (controls[name] instanceof FormGroup) {
        findName((controls[name] as FormGroup).controls, name);
      } else if (controls[name] instanceof FormArray) {
        const arr = controls[name] as FormArray;
        for (let i = 0; i < arr.length; i++) {
          if (arr.at(i) === control) {
            controlName = `${name}[${i}]`;
            break;
          }
          if (arr.at(i) instanceof FormGroup) {
            findName((arr.at(i) as FormGroup).controls, `${name}[${i}]`);
          }
        }
      }
    }
  };

  findName(this.formGroup.controls);
  return controlName;
}
}
