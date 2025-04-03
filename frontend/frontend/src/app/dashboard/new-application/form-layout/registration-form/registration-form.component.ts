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
  bankOptions!: any[];
  incomeSourceOptions!: Income[];
  regulationData = regulationData;
  designationData = designationData;
  detailsData: any = priorAssociationDetailsData;
  // Add this line to define the property
  proofOfIdentityOptions!: any[];
  countryShortCodes: any[] = [];

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
    // this.initializeForm();
    this.initializePriorAssociationRows();
    // // Handle both direct applicationData (for preview) and fetching
    // if (this.previewMode && this.applicationData) {
    //   // We already have application data for preview
    //   this.populateFormWithApplicationData(this.applicationData);
    //   // Disable the form for preview mode
    //   this.formGroup.disable();
    // } else {
    //   // Normal case - fetch from API
    //   // this.fetchUserApplication();
    // }

    // console.log(this.validationService.validationFlag);
    // if(this.validationService.validationFlag){
    //   this.validationService.requestValidation();
    //   this.formGroup.markAllAsTouched();
    // }

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
        console.log('PAN Radio changed to:', value);
        if (value === true) {
          console.log('SetValidators');
          this.formGroup
            .get('hasPan.hasPanNumber')
            ?.setValidators([Validators.required]);
        } else {
          console.log('removeValidators');
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
        // console.log('PAN Radio changed to:', value);
        if (value === true) {
          // console.log('SetValidators');
          this.formGroup
            .get('disciplinaryHistory.disciplinaryHistoryText')
            ?.setValidators([Validators.required]);
        } else {
          // console.log('removeValidators');
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
        // console.log('PAN Radio changed to:', value);
        if (value === 'throughGlobalCustodianRadioYes') {
          // console.log('SetValidators');
          // this.formGroup
          //   .get('throughGlobalCustodian.throughGlobalCustodianRegulatorName')
          //   ?.setValidators([Validators.required]);
          this.formGroup
            .get('throughGlobalCustodian.throughGlobalCustodianName')
            ?.setValidators([Validators.required]);
          this.formGroup
            .get('throughGlobalCustodian.throughGlobalCustodianAddress')
            ?.setValidators([Validators.required]);
          this.formGroup
            .get('throughGlobalCustodian.throughGlobalCustodianRegistration')
            ?.setValidators([Validators.required]);
          // this.formGroup
          //   .get('throughGlobalCustodian.throughGlobalCustodianCountry')
          //   ?.setValidators([Validators.required]);
        } else {
          // this.formGroup
          //   .get('throughGlobalCustodian.throughGlobalCustodianRegulatorName')
          //   ?.clearValidators();
          // this.formGroup
          //   .get('throughGlobalCustodian.throughGlobalCustodianRegulatorName')
          //   ?.setValue('');
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
          // this.formGroup
          //   .get('throughGlobalCustodian.throughGlobalCustodianCountry')
          //   ?.clearValidators();
          // this.formGroup
          //   .get('throughGlobalCustodian.throughGlobalCustodianCountry')
          //   ?.setValue('');
        }
        // Update validation
        // this.formGroup
        //   .get('throughGlobalCustodian.throughGlobalCustodianRegulatorName')
        //   ?.updateValueAndValidity();
        this.formGroup
          .get('throughGlobalCustodian.throughGlobalCustodianName')
          ?.updateValueAndValidity();
        this.formGroup
          .get('throughGlobalCustodian.throughGlobalCustodianAddress')
          ?.updateValueAndValidity();
        this.formGroup
          .get('throughGlobalCustodian.throughGlobalCustodianRegistration')
          ?.updateValueAndValidity();
        // this.formGroup
        //   .get('throughGlobalCustodian.throughGlobalCustodianCountry')
        //   ?.updateValueAndValidity();
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

      const regularAuthorityObj = this.regulatoryAuthorityOptions.find(
        (c) => c.name === this.applicationData.data?.registrationForm?.regulatoryAuthorityName
      );
      console.log("this.applicationData.data?.registrationForm?.regulatoryAuthorityName", this.applicationData.data.registrationForm.regulatoryAuthorityName)
      this.formGroup.get('regulatoryAuthorityName')?.setValue(this.applicationData.data?.registrationForm?.regulatoryAuthorityName)
      this.formGroup.get('regulatoryAuthorityCountry')?.setValue(this.applicationData.data?.registrationForm?.regulatoryAuthorityCountry)
      this.formGroup.get('regulatoryAuthorityWebsite')?.setValue(this.applicationData.data?.registrationForm?.regulatoryAuthorityWebsite)


    this.formGroup.get('throughGlobalCustodian.throughGlobalCustodianRadio')?.setValue(this.applicationData.data?.registrationForm?.throughGlobalCustodian?.throughGlobalCustodianRadio)
    this.formGroup.get('throughGlobalCustodian.throughGlobalCustodianName')?.setValue(this.applicationData.data?.registrationForm?.throughGlobalCustodian?.throughGlobalCustodianName)
    this.formGroup.get('throughGlobalCustodian.throughGlobalCustodianRegulatorName')?.setValue(this.applicationData.data?.registrationForm?.throughGlobalCustodian?.throughGlobalCustodianRegulatorName)
    this.formGroup.get('throughGlobalCustodian.throughGlobalCustodianAddress')?.setValue(this.applicationData.data?.registrationForm?.throughGlobalCustodian?.throughGlobalCustodianAddress)
    this.formGroup.get('throughGlobalCustodian.throughGlobalCustodianRegistration')?.setValue(this.applicationData.data?.registrationForm?.throughGlobalCustodian?.throughGlobalCustodianRegistration)
    const countryObjg = this.countries_pan.find(
      (c) => c.short_code === this.applicationData.data?.registrationForm?.throughGlobalCustodian?.throughGlobalCustodianCountry.short_code
    );
    this.formGroup.get('throughGlobalCustodian.throughGlobalCustodianCountry')?.setValue(countryObjg)

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

    // Set throughGlobalCustodian fields
    this.formGroup
      .get('throughGlobalCustodian.throughGlobalCustodianRadio')
      ?.setValue(
        this.applicationData.data?.registrationForm?.throughGlobalCustodian
          ?.throughGlobalCustodianRadio
      );
    this.formGroup
      .get('throughGlobalCustodian.throughGlobalCustodianName')
      ?.setValue(
        this.applicationData.data?.registrationForm?.throughGlobalCustodian
          ?.throughGlobalCustodianName
      );
    this.formGroup
      .get('throughGlobalCustodian.throughGlobalCustodianRegulatorName')
      ?.setValue(
        this.applicationData.data?.registrationForm?.throughGlobalCustodian
          ?.throughGlobalCustodianRegulatorName
      );
    this.formGroup
      .get('throughGlobalCustodian.throughGlobalCustodianAddress')
      ?.setValue(
        this.applicationData.data?.registrationForm?.throughGlobalCustodian
          ?.throughGlobalCustodianAddress
      );
    this.formGroup
      .get('throughGlobalCustodian.throughGlobalCustodianRegistration')
      ?.setValue(
        this.applicationData.data?.registrationForm?.throughGlobalCustodian
          ?.throughGlobalCustodianRegistration
      );
    const countryObj = this.countries_pan.find(
      (c) =>
        c.short_code ===
        this.applicationData.data?.registrationForm?.throughGlobalCustodian
          ?.throughGlobalCustodianCountry.short_code
    );
    this.formGroup
      .get('throughGlobalCustodian.throughGlobalCustodianCountry')
      ?.setValue(countryObj);

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
    this.loadMasterData().then(() => {
      // Set DDP field
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
    });
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
    console.log('masterdata initialise', this.masterData);
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
    console.log('indininininininin');
    if (!appData) return;

    // In preview mode, we need to handle dropdown values differently
    if (this.previewMode) {
      // Wait for the master data (dropdown options) to be loaded
      this.loadMasterData().then(() => {
        console.log('into polpulate 2');
        this.mapDesignationDetails(appData);
        this.mapApplicantDetails(appData);
        this.mapRegulatoryAuthorityDetails(appData);
        this.mapIndianMarketAssociations(appData.indianMarketAssocians || []);
        // Disable the form since we're in preview mode
        this.formGroup.disable();
      });
    } else {
      console.log('into polpulate 1');
      // Normal case - proceed as before
      this.mapDesignationDetails(appData);
      this.mapApplicantDetails(appData);
      this.mapRegulatoryAuthorityDetails(appData);
      console.log(
        'appData.indianMarketAssocians',
        appData.indianMarketAssocians
      );
      this.mapIndianMarketAssociations(appData.indianMarketAssocians || []);
    }
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
    console.log('priorAssiciationRows', moRows, details.length, details);
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
    console.log("regulatoryAuthorityOptions", this.regulatoryAuthorityOptions)
    const regulatoryAuthObject = this.regulatoryAuthorityOptions.find(
      (c) => c.name === event.value
    );
    // const selectedAuthority = event.value;
    // console.log('asdasdasdasdasd', selectedAuthority, event);
    // const countries_panObj = this.countries_pan.find(
    //   (c) => c.name === regulatoryAuthObject.country
    // );
    // console.log()
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

  private getRegistrationDetails(): DraftFvicRegistrationDetailsDto {
    const custodianGroup = this.formGroup.get(
      'throughGlobalCustodian'
    ) as FormGroup;
    const bankGroup = this.formGroup.get('designatedBank') as FormGroup;
    const priorAssociationGroup = this.formGroup.get(
      'priorAssociation'
    ) as FormGroup;
    const panGroup = this.formGroup.get('hasPan') as FormGroup;
    const disciplinaryGroup = this.formGroup.get(
      'disciplinaryHistory'
    ) as FormGroup;

    // Handle bank name properly - if it's an object extract the name property
    let bankName = bankGroup.get('designatedBankName')?.value || '';
    if (typeof bankName === 'object' && bankName !== null) {
      bankName = bankName.name || '';
    }

    return {
      // Other existing fields remain the same...
      isProvidedFactaCrsProvided:
        !!this.formGroup.get('providedValidForm')?.value,
      isComingFromGlobalCustodian:
        custodianGroup.get('throughGlobalCustodianRadio')?.value ===
        'throughGlobalCustodianRadioYes',

      // Extract name property from DDP, Custodian and DP objects
      ddpName:
        typeof this.formGroup.get('ddpName')?.value === 'object'
          ? this.formGroup.get('ddpName')?.value?.name || ''
          : this.formGroup.get('ddpName')?.value || '',
      ddpRegistrationNumber:
        this.formGroup.get('ddpRegistrationNumber')?.value || '',
      custodianName:
        typeof this.formGroup.get('custodianName')?.value === 'object'
          ? this.formGroup.get('custodianName')?.value?.name || ''
          : this.formGroup.get('custodianName')?.value || '',
      custodianRegistrationNumber:
        this.formGroup.get('custodianRegistrationNumber')?.value || '',
      dpName:
        typeof this.formGroup.get('dpName')?.value === 'object'
          ? this.formGroup.get('dpName')?.value?.name || ''
          : this.formGroup.get('dpName')?.value || '',
      dpRegistrationNumber:
        this.formGroup.get('dpRegistrationNumber')?.value || '',

      // Use the properly extracted bank name
      bankName: bankName,
      bankAddress: bankGroup.get('designatedBankAddress')?.value || '',

      // The rest remains the same
      isAssociatedWithSecuritiesMarket:
        priorAssociationGroup.get('priorAssociationRadio')?.value === true ||
        priorAssociationGroup.get('priorAssociationRadio')?.value === 'true',
      detailsOfPriorAssociation:
        priorAssociationGroup.get('detailsOfPriorAssociation')?.value || '',
      doesHoldPan:
        panGroup.get('hasPanRadio')?.value === true ||
        panGroup.get('hasPanRadio')?.value === 'true',
      panNumber: panGroup.get('hasPanNumber')?.value || '',
      isViolatedLaw:
        disciplinaryGroup.get('disciplinaryHistoryRadio')?.value === true ||
        disciplinaryGroup.get('disciplinaryHistoryRadio')?.value === 'true',
    };
  }

  private getRegulatoryAuthorityDetailsDto(): DraftFvciRegulatoryAuthorityDetailsDto {
    return {
      fvciApplicationId: this.applicationId,
      regulatoryAuthorityName:
        this.formGroup.get('regulatoryAuthorityName')?.value ?? '',
      regulatoryAuthorityCountry:
        this.formGroup.get('regulatoryAuthorityCountry')?.value ?? '',
      regulatoryAuthorityWebsite:
        this.formGroup.get('regulatoryAuthorityWebsite')?.value ?? '',
      regulatoryAuthorityRegNumber:
        this.formGroup.get('regulatoryAuthorityRegNumber')?.value ?? '',
      regulatoryAuthorityCategory:
        this.formGroup.get('regulatoryAuthorityCategory')?.value ?? '',
    };
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
}
