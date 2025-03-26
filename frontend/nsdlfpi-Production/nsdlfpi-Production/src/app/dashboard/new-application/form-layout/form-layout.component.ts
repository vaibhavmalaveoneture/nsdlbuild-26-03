import {
  Component,
  Input,
  ViewChild,
  OnInit,
  AfterViewInit,
  viewChild,
} from '@angular/core';
import { SaveApplicationService } from '../../../services/save-application.service';
import { firstValueFrom } from 'rxjs';
import {
  DraftFvciBenificialOwnershipByControlBoDetailsDto,
  DraftFvciDeclarationUndertakingDetailsDto,
  DraftFvciGlobalCustodianDetailsDto,
  DraftFvciIncidentsOfLawViolationDto,
  DraftFvciInfoBasicOfOwnershipBoDetailsDto,
  DraftFvciInformationOfSaSmFvciApplicantDto,
  DraftFvciIsBankDto,
  DraftFvciKraPermissionDto,
  DraftFvciOwnershipDetailsDto,
  DraftFvciSubClassBenificialOwnerDetailsDto,
  DraftFvciSubClassDetailsDto,
  FvciApplicationService,
  PdfService,
} from '../../../../swagger';
import { MessageService } from 'primeng/api';
import { HttpClient } from '@angular/common/http';

import { FvciFormComponent } from './fvci-form/fvci-form.component';
import { MenuComponent } from './menu/menu.component';
import { RegistrationFormComponent } from './registration-form/registration-form.component';
import { AnnexureFormComponent } from './annexure-form/annexure-form.component';
import { DeclarationUndertakingComponent } from './declaration-undertaking/declaration-undertaking.component';
import {
  FormBuilder,
  FormGroup,
  Validators,
  FormControl,
  FormArray,
  AbstractControl,
  ValidationErrors,
  ValidatorFn,
} from '@angular/forms';
import { City, docData } from '../data';

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
} from '../../../../swagger';
import { Router } from '@angular/router';

@Component({
  selector: 'app-form-layout',
  standalone: false,
  templateUrl: './form-layout.component.html',
  styleUrl: './form-layout.component.scss',
})
export class FormLayoutComponent implements OnInit, AfterViewInit {
  @Input() applicationId: string | undefined;
  @Input() currentStep: number = 1;
  @ViewChild(MenuComponent) appMenu!: MenuComponent;
  @ViewChild(FvciFormComponent)
  fvciComponent!: FvciFormComponent;
  @ViewChild(RegistrationFormComponent)
  registrationFormComponent!: RegistrationFormComponent;
  @ViewChild(AnnexureFormComponent)
  anextureToCaf!: AnnexureFormComponent;
  @ViewChild(DeclarationUndertakingComponent)
  declarationUndertakingComponent!: DeclarationUndertakingComponent;

  
  fvciForm: FormGroup = new FormGroup({});
  registartionForm: FormGroup = new FormGroup({});
  anextureToCafForm: FormGroup = new FormGroup({});
  documentUploadForm: FormGroup = new FormGroup({});
  declarationAndUndertakimgForm: FormGroup = new FormGroup({});

  showLoader = false;
  formCompletionPercentage = 0;
 docData = docData;
  currentComponent!: string;
  download = '/assets/downloads.png';
  isDownloading: boolean = false;

  constructor(
    private readonly saveApplicationService: SaveApplicationService,
    private readonly fvciService: FvciApplicationService,
    private readonly pdfService: PdfService,
    private readonly messageService: MessageService,
    private readonly http: HttpClient,
    private readonly fb: FormBuilder,
    private readonly router: Router
  ) {}

  ngOnInit() {
    this.initializeComponent();

    this.fvciForm = this.fb.group({
      name: new FormControl('', [
        Validators.required,
        Validators.maxLength(300),
        Validators.pattern(/^[A-Za-z0-9 ]*$/),
      ]),
      applicantOtherName: new FormGroup({
        otherNameRadio: new FormControl(null, Validators.required),
        otherNameField: new FormControl(''),
      }),
      dateOfIncorporation: new FormControl<Date | null>(
        null,   Validators.required
      ),
      dateOfCommencement: new FormControl<Date | null>(
        null,   Validators.required
      ),
      placeOfIncorporation: new FormControl('',   Validators.required),
      countryOfIncorporation: new FormControl([],   Validators.required),
      countryCodeOfIncorporation: new FormControl({ value: new Date(), disabled: true }),
      legalForm: new FormControl('',   Validators.required),
      lei: new FormControl('LEI NUMBER',  [
        Validators.required,
        Validators.maxLength(20),
        Validators.minLength(20),
        Validators.pattern(/^[A-Za-z0-9 ]*$/),
      ]),
      taxResidencyRows: new FormArray<FormGroup>([]),
      registeredOffice: new FormGroup(
        {
          registeredFlatNum: new FormControl(''),
          registeredBuildingName: new FormControl(''),
          registeredCountryName: new FormControl(null, Validators.required),
          registeredRoadName: new FormControl(''),
          registeredAreaName: new FormControl(''),
          registeredTownName: new FormControl('', Validators.required),
          registeredZipName: new FormControl('', Validators.required),
          registeredStateName: new FormControl(''),
          notApplicableResidence: new FormControl(false),
        },
        { validators: this.atLeastTwoFieldsRequiredValidator() }
      ),
      OfficeInIndia: new FormGroup(
        {
          OfficeInIndiaRadio: new FormControl(null, Validators.required),
          indianFlatNum: new FormControl(''),
          indianBuildingName: new FormControl(''),
          indianCountryName: new FormControl(null, Validators.required),
          indianRoadName: new FormControl(''),
          indianAreaName: new FormControl(''),
          indianTownName: new FormControl('', Validators.required),
          indianZipName: new FormControl('', Validators.required),
          indianStateName: new FormControl(''),
          notApplicableIndOffice: new FormControl(null),
        },
        { validators: this.atLeastTwoFieldsRequiredIValidator() }
      ),
      foreignOffice: new FormGroup(
        {
          foreignFlatNum: new FormControl(''),
          foreignBuildingName: new FormControl(''),
          foreignCountryName: new FormControl(null, Validators.required),
          foreignRoadName: new FormControl(''),
          foreignAreaName: new FormControl(''),
          foreignTownName: new FormControl('', Validators.required),
          foreignZipName: new FormControl('', Validators.required),
          foreignStateName: new FormControl(''),
          notApplicableForeignOffice: new FormControl(false),
        },
        { validators: this.atLeastTwoFieldsRequiredFValidator() }
      ),
      communicationAddress: new FormControl('',  Validators.required),
      investmentManager: new FormGroup({}),
      complianceOfficerInfo: new FormGroup({
        complianceOfficerInfoName: new FormControl('',  Validators.required),
        complianceOfficerInfoJob: new FormControl('',  Validators.required),
        complianceOfficerInfoMobile: new FormControl('',  Validators.required),
        complianceOfficerInfoFax: new FormControl(''),
        complianceOfficerInfoEmail: new FormControl(''),
      }),
      ultimateBeneficialOwner: new FormControl(null, Validators.required),
      incomeDetails: new FormGroup({
        incomeSource: new FormControl<City | null>(null, Validators.required),
        businessCode: new FormControl<number | null>(null, Validators.required),
        annualIncome: new FormControl<number | null>(null, Validators.required),
        assetLess: new FormControl<number | null>(null, Validators.required),
      }),
      // Replace FormArray with individual controls
      proofOfIdentity: new FormControl<string | null>(null, Validators.required),
      proofOfAddress: new FormControl<string | null>(null, Validators.required),
      contactDetails: new FormGroup({
        registered: new FormGroup({
          countryCode: new FormControl(null),
          areaCode: new FormControl(''),
          number: new FormControl(''),
        }),
        office: new FormGroup({
          countryCode: new FormControl(null),
          areaCode: new FormControl(''),
          number: new FormControl(''),
        }),
        indianOffice: new FormGroup({
          countryCode: new FormControl(null),
          areaCode: new FormControl(''),
          number: new FormControl(''),
        }),
        registeredFax: new FormGroup({
          countryCode: new FormControl(null),
          areaCode: new FormControl(''),
          number: new FormControl(''),
        }),
        officeFax: new FormGroup({
          countryCode: new FormControl(null),
          areaCode: new FormControl(''),
          number: new FormControl(''),
        }),
        indianOfficeFax: new FormGroup({
          countryCode: new FormControl(null),
          areaCode: new FormControl(''),
          number: new FormControl(''),
        }),
        // Mobile number, email ID, and website controls
        mobileNumber: new FormControl('', Validators.required),
        emailId: new FormControl('',[
          Validators.required,
          Validators.email
        ]),
        website: new FormControl('', [
          Validators.required,
          this.urlValidator
        ]),
      }),
      applicantType: new FormGroup({
        applicantTypeName: new FormControl('', Validators.required),
        applicantTypeRadio: new FormControl(null),
        applicantTypeOtherEntity: new FormControl(''),
      }),
      sameAsAbove: new FormControl(false),
      designationDetails: new FormArray<FormGroup>([]),
      managingOfficialRows: new FormArray<FormGroup>([]),
      date: new FormControl<Date | null>(null),
      typeOfEntity: new FormControl<string | null>(null, Validators.required),
      selectedCity: new FormControl<City | null>(null),
      beneficialOwnership: new FormControl(null, Validators.required),
      politicallyExposed: new FormControl(null),
      relatedToPoliticallyExposed: new FormControl(null),
    });

    this.registartionForm = this.fb.group({
      providedValidForm: new FormControl(null, [Validators.required]),
      throughGlobalCustodian: new FormGroup({
        throughGlobalCustodianRadio: new FormControl('', Validators.required),
        throughGlobalCustodianName: new FormControl(''),
        throughGlobalCustodianAddress: new FormControl(''),
        throughGlobalCustodianRegistration: new FormControl(''),
        throughGlobalCustodianCountry: new FormControl(''),
      }),
      designatedBank: new FormGroup({
        designatedBankName: new FormControl('', Validators.required),
        designatedBankAddress: new FormControl('', Validators.required),
      }),
      priorAssociation: new FormGroup({
        priorAssociationRadio: new FormControl(null),
        detailsOfPriorAssociation: new FormControl(''),
      }),
      priorAssiciationRows: new FormArray<FormGroup>([]),
      hasPan: new FormGroup({
        hasPanRadio: new FormControl(null, Validators.required),
        hasPanNumber: new FormControl(''),
      }),
      disciplinaryHistory: new FormGroup({
        disciplinaryHistoryRadio: new FormControl(null, Validators.required),
        disciplinaryHistoryText: new FormControl(''),
      }),
      // Replace regulatoryAuthorityDetails FormArray with individual controls
      regulatoryAuthorityName: new FormControl(''),
      regulatoryAuthorityCountry: new FormControl(''),
      regulatoryAuthorityWebsite: new FormControl(''),
      regulatoryAuthorityRegNumber: new FormControl(''),
      regulatoryAuthorityCategory: new FormControl(''),

      // Replace designatorDetails FormArray with individual controls
      ddpName: new FormControl('', Validators.required),
      ddpRegistrationNumber: new FormControl('', Validators.required),
      custodianName: new FormControl('', Validators.required),
      custodianRegistrationNumber: new FormControl('', Validators.required),
      dpName: new FormControl('', Validators.required),
      dpRegistrationNumber: new FormControl('', Validators.required),

      selectedCity: new FormControl<City | null>(null),
      hasOtherEntity: new FormControl(null),
      otherEntityDetails: new FormControl(''),
    });

    this.anextureToCafForm = this.fb.group({
      seggregatedPortfolio: new FormGroup({
        seggregatedPortfolioRadio: new FormControl(null, Validators.required),
        seggregatedPortfolioText: new FormControl(''),
      }),
      bankDeclaration: new FormGroup({
        bankDeclarationRadio: new FormControl(null),
        bankDeclarationText: new FormControl(''),
      }),
      consentIntermediary: new FormGroup({
        consentIntermediaryRadio: new FormControl(null),
        consentIntermediaryName: new FormControl(null),
        consentIntermediaryEmail1: new FormControl(null),
        consentIntermediaryEmail2: new FormControl(null),
        consentIntermediaryEmail3: new FormControl(null),
        consentIntermediaryMobile: new FormControl(null),
      }),
      informationOfSaSmFvciApplicant: new FormArray([]),
      signatoryRows: new FormArray<FormGroup>([]),
      materialShareholderRows: new FormArray<FormGroup>([]),
      beneficialOwners: new FormArray<FormGroup>([]),
      managers: new FormArray([]),
      intermediateMaterial: new FormControl(null),
      entityHolding: new FormControl(''),
      beneficialOwnership: new FormControl(null),
    });

    // this.documentUploadForm = this.fb.group({})
    this.declarationAndUndertakimgForm = this.fb.group({
      name: new FormControl('', Validators.required),
      capacity: new FormControl('', Validators.required),
      place: new FormControl('', Validators.required),
      date: new FormControl({ value: new Date(), disabled: true }),
      nameOfSignatory: new FormControl('', Validators.required),
      designationOfSignatory: new FormControl('', Validators.required),
      dateOfSignature: new FormControl({ value: new Date(), disabled: true }),
      signature: new FormControl({ value: '', disabled: true }),
    });

    const applicantOtherNameGroup = this.fvciForm.get(
      'applicantOtherName'
    ) as FormGroup;

    // Subscribe to changes of 'otherNameRadio'
    applicantOtherNameGroup
      .get('otherNameRadio')
      ?.valueChanges.subscribe((value) => {
        const otherNameFieldControl =
          applicantOtherNameGroup.get('otherNameField');
        if (value === true) {
          otherNameFieldControl?.setValidators([
            Validators.required,
            Validators.maxLength(75),
            Validators.pattern(/^[A-Za-z0-9 ]*$/),
          ]);
        } else {
          otherNameFieldControl?.clearValidators();
          otherNameFieldControl?.setValue(''); // Clear the value if No selected
        }
        otherNameFieldControl?.updateValueAndValidity();
      });

    // Call subscribeToFormChanges as usual
    this.subscribeToFormChanges();
  }

  updateCurrentStep(step: number): void {
    this.currentStep = step;
    this.saveApplicationService.getSteps().forEach((step) => {
      if (step.step === this.currentStep) {
        this.currentComponent = step.name;
      }
    });
  }

  ngAfterViewInit(): void {
    console.log(
      '---------------------------------------------------------------'
    );
    // Wait for view (and child component) to initialize
    // if (this.fvciComponent && this.applicationId) {
    this.fvciComponent.fetchUserApplication();
    this.registrationFormComponent.fetchUserApplication();
    this.anextureToCaf.fetchUserApplication();
    this.declarationUndertakingComponent.fetchDeclarationDetails();
    // }
    // if (this.registrationFormComponent && this.applicationId) {
    // this.fvciComponent.fetchUserApplication();
    // this.registrationFormComponent.fetchUserApplication();
    // }
  }

  async onButtonClick(): Promise<void> {
    await firstValueFrom(
      this.fvciService.apiFvciapplicationSaveOrUpdateApplicationPost()
    );
  }

  initializeComponent() {
    this.saveApplicationService.getSteps().forEach((step) => {
      if (step.step === this.currentStep) {
        this.currentComponent = step.name;
      }
    });
  }

  async downloadFvciPdf(): Promise<void> {
    if (!this.applicationId) {
      this.messageService.add({
        severity: 'error',
        summary: 'Error',
        detail: 'Application ID is missing. Cannot download the form.',
      });
      return;
    }

    this.isDownloading = true;

    try {
      const response = await firstValueFrom(
        this.pdfService.apiPdfGenerateAndDownloadPost(this.applicationId)
      );

      const blobUrl = URL.createObjectURL(response);
      const a = document.createElement('a');
      a.href = blobUrl;
      a.download = `FVCI_Application_${this.applicationId}.pdf`;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      setTimeout(() => URL.revokeObjectURL(blobUrl), 100);

      this.messageService.add({
        severity: 'success',
        summary: 'Success',
        detail: 'Application downloaded successfully.',
      });
    } catch (error) {
      console.error('Error downloading PDF:', error);
      this.messageService.add({
        severity: 'error',
        summary: 'Error',
        detail: 'Failed to download the application. Please try again.',
      });
    } finally {
      this.isDownloading = false;
    }
  }

  handleSubmit() {
    console.log('asdasdasdads into handle submit');
    this.fvciForm.markAllAsTouched();

    this.registartionForm.markAllAsTouched();
    // this.anextureToCafForm.markAllAsTouched();
    this.documentUploadForm.markAllAsTouched();
    this.declarationAndUndertakimgForm.markAllAsTouched();

    const fvciValid = this.fvciForm.valid;
    const ekycValid = this.registartionForm.valid;
    // const atcValid = this.anextureToCafForm.valid;
    const duValid = this.documentUploadForm.valid;
    const dauValid = this.declarationAndUndertakimgForm.valid;
    console.log('fvciValid', fvciValid);
    console.log('ekycValid', ekycValid);
    // console.log("atcValid",atcValid)
    console.log('duValid', duValid);
    console.log('dauValid', dauValid);
    if (!fvciValid) {
      this.triggerSetActive(0);
    } else if (!ekycValid) {
      this.triggerSetActive(1);
    } else if (!duValid) {
      this.triggerSetActive(3);
    } else if (!dauValid) {
      this.triggerSetActive(4);
    } else {
      this.appMenu.openPreview();
    }
  }

  triggerSetActive(index: number) {
    if (this.appMenu) {
      this.appMenu.setActive(index);
    }
  }

  subscribeToFormChanges() {
    this.fvciForm.valueChanges.subscribe(() => {
      this.updateFormCompletion();
    });

    this.registartionForm.valueChanges.subscribe(() => {
      this.updateFormCompletion();
    });

    this.anextureToCafForm.valueChanges.subscribe(() => {
      this.updateFormCompletion();
    });

    this.declarationAndUndertakimgForm.valueChanges.subscribe(() => {
      this.updateFormCompletion();
    });

    // Initial update
    this.updateFormCompletion();
  }

  getRequiredControls(control: AbstractControl): AbstractControl[] {
    let requiredControls: AbstractControl[] = [];

    if (control instanceof FormGroup) {
      Object.values(control.controls).forEach((childControl) => {
        requiredControls.push(...this.getRequiredControls(childControl));
      });
    } else if (control instanceof FormArray) {
      control.controls.forEach((childControl) => {
        requiredControls.push(...this.getRequiredControls(childControl));
      });
    } else if (control instanceof FormControl) {
      // Check if control has 'required' validator
      if (control.hasValidator && control.hasValidator(Validators.required)) {
        requiredControls.push(control);
      }
    }

    return requiredControls;
  }

  updateFormCompletion() {
    const fvciRequiredControls = this.getRequiredControls(this.fvciForm);
    const ekycRequiredControls = this.getRequiredControls(
      this.registartionForm
    );
    const anextureToCafRequiredControls = this.getRequiredControls(
      this.anextureToCafForm
    );
    const declarationControls = this.getRequiredControls(
      this.declarationAndUndertakimgForm
    );
    const registeredOfficeGroup = this.fvciForm.get('registeredOffice');
    const foreignOfficeOfficeGroup = this.fvciForm.get('foreignOffice');
    const OfficeInIndiaOfficeGroup = this.fvciForm.get('OfficeInIndia');
    let groupLevelErrorCount = 0;
   
    if (registeredOfficeGroup?.errors?.['atLeastTwoFieldsRequired']) {
      groupLevelErrorCount++;
      groupLevelErrorCount++;
    }

    if (foreignOfficeOfficeGroup?.errors?.['atLeastTwoFieldsRequiredF']) {
      groupLevelErrorCount++;
      groupLevelErrorCount++;
    }
    if (OfficeInIndiaOfficeGroup?.errors?.['atLeastTwoFieldsRequiredI']) {

      groupLevelErrorCount++;
      groupLevelErrorCount++;
    }
   


    const allRequiredControls = [...fvciRequiredControls, ...ekycRequiredControls,...anextureToCafRequiredControls,...declarationControls];
    let totalRequiredFields = allRequiredControls.length+groupLevelErrorCount;

    let validRequiredFields = allRequiredControls.filter(
      (control) => control.valid
    ).length;
    let validControls = allRequiredControls.filter((control) => control.valid);

    console.log('totalRequiredField------------s', totalRequiredFields);
    // console.log("validRequiredFields", validRequiredFields)
    // console.log("validControls", validControls)
    const validFields = this.getValidRequiredFieldNames(this.registartionForm);
    // console.log('Valid Required Fields:', validFields);

    const invalidFields = this.getInvalidRequiredFieldNames(
      this.registartionForm
    );
    // console.log('Invalid Required Fields:', invalidFields);

    const invalidFieldss = this.getInvalidRequiredFieldNames(this.anextureToCafForm);
    if (registeredOfficeGroup?.errors?.['atLeastTwoFieldsRequired'] != undefined){
      if (!registeredOfficeGroup?.errors?.['atLeastTwoFieldsRequired']) {
        validRequiredFields++;
        validRequiredFields++;
      }
    }

    if (foreignOfficeOfficeGroup?.errors?.['atLeastTwoFieldsRequiredF'] != undefined){
      if (!foreignOfficeOfficeGroup?.errors?.['atLeastTwoFieldsRequiredF']) {
        validRequiredFields++;
        validRequiredFields++;
      }
    }
    
   
    if (OfficeInIndiaOfficeGroup?.get('OfficeInIndiaRadio') != null) {
      if (OfficeInIndiaOfficeGroup?.errors?.['atLeastTwoFieldsRequiredI'] != undefined){
        if (!OfficeInIndiaOfficeGroup?.errors?.['atLeastTwoFieldsRequiredI']) {
          validRequiredFields++;
          validRequiredFields++;
        }
      }
    }
    console.log('validRequiredFieldsI', validRequiredFields);
    console.log('totalRequiredFields', totalRequiredFields);
    console.log('validRequiredFields', validRequiredFields);

    this.formCompletionPercentage =
      totalRequiredFields === 0
        ? 0
        : Math.floor((validRequiredFields / totalRequiredFields) * 100);
  }

  otherNameConditionalValidator(
    group: AbstractControl
  ): ValidationErrors | null {
    const radioControl = group.get('otherNameRadio');
    const fieldControl = group.get('otherNameField');
    if (radioControl && fieldControl) {
      if (radioControl.value === true && !fieldControl.value) {
        return { otherNameRequired: true }; // Custom error key
      }
    }

    return null; // Valid
  }

  // Helper: Check if control has 'required' validator
  hasRequiredValidator(control: AbstractControl | null): boolean {
    if (!control?.validator) return false;
    const validatorResult = control.validator({} as AbstractControl);
    return (
      validatorResult !== null && validatorResult['required'] !== undefined
    );
  }

  // Recursive function to get valid required fields
  getValidRequiredFieldNames(
    control: AbstractControl,
    parentKey = ''
  ): string[] {
    let validFields: string[] = [];

    if (control instanceof FormGroup) {
      Object.keys(control.controls).forEach((key) => {
        const childControl = control.controls[key];
        const fieldPath = parentKey ? `${parentKey}.${key}` : key;
        validFields = validFields.concat(
          this.getValidRequiredFieldNames(childControl, fieldPath)
        );
      });
    } else if (control instanceof FormArray) {
      control.controls.forEach((childControl, index) => {
        const fieldPath = `${parentKey}[${index}]`;
        validFields = validFields.concat(
          this.getValidRequiredFieldNames(childControl, fieldPath)
        );
      });
    } else {
      if (this.hasRequiredValidator(control) && control.valid) {
        validFields.push(parentKey);
      }
    }

    return validFields;
  }

  // Recursive function to get invalid required fields
  getInvalidRequiredFieldNames(
    control: AbstractControl,
    parentKey = ''
  ): string[] {
    let invalidFields: string[] = [];

    if (control instanceof FormGroup) {
      Object.keys(control.controls).forEach((key) => {
        const childControl = control.controls[key];
        const fieldPath = parentKey ? `${parentKey}.${key}` : key;
        invalidFields = invalidFields.concat(
          this.getInvalidRequiredFieldNames(childControl, fieldPath)
        );
      });
    } else if (control instanceof FormArray) {
      control.controls.forEach((childControl, index) => {
        const fieldPath = `${parentKey}[${index}]`;
        invalidFields = invalidFields.concat(
          this.getInvalidRequiredFieldNames(childControl, fieldPath)
        );
      });
    } else {
      if (this.hasRequiredValidator(control) && control.invalid) {
        invalidFields.push(parentKey);
      }
    }

    return invalidFields;
  }

  taxResidencyRowsRequiredValidator: ValidatorFn = (
    control: AbstractControl
  ): ValidationErrors | null => {
    const formArray = control as FormArray;
    return formArray && formArray.length > 0 ? null : { required: true };
  };

  atLeastTwoFieldsRequiredValidator(): ValidatorFn {
    return (group: AbstractControl): ValidationErrors | null => {
      const flatNum = group.get('registeredFlatNum')?.value;
      const buildingName = group.get('registeredBuildingName')?.value;
      const roadName = group.get('registeredRoadName')?.value;
      const areaName = group.get('registeredAreaName')?.value;

      let filledCount = 0;

      if (flatNum && flatNum.trim() !== '') filledCount++;
      if (buildingName && buildingName.trim() !== '') filledCount++;
      if (roadName && roadName.trim() !== '') filledCount++;
      if (areaName && areaName.trim() !== '') filledCount++;

      return filledCount >= 2 ? null : { atLeastTwoFieldsRequired: true };
    };
  }

  atLeastTwoFieldsRequiredFValidator(): ValidatorFn {
    return (group: AbstractControl): ValidationErrors | null => {
      const flatNum = group.get('foreignFlatNum')?.value;
      const buildingName = group.get('foreignBuildingName')?.value;
      const roadName = group.get('foreignRoadName')?.value;
      const areaName = group.get('foreignAreaName')?.value;

      let filledCount = 0;

      if (flatNum && flatNum.trim() !== '') filledCount++;
      if (buildingName && buildingName.trim() !== '') filledCount++;
      if (roadName && roadName.trim() !== '') filledCount++;
      if (areaName && areaName.trim() !== '') filledCount++;

      return filledCount >= 2 ? null : { atLeastTwoFieldsRequiredF: true };
    };
  }

  atLeastTwoFieldsRequiredIValidator(): ValidatorFn {
    let filledCount = 0;
    return (group: AbstractControl): ValidationErrors | null => {
      const flatNum = group.get('indianFlatNum')?.value;
      const buildingName = group.get('indianBuildingName')?.value;
      const roadName = group.get('indianRoadName')?.value;
      const areaName = group.get('indianAreaName')?.value;

      if (flatNum && flatNum.trim() !== '') filledCount++;

      if (buildingName && buildingName.trim() !== '') filledCount++;

      if (roadName && roadName.trim() !== '') filledCount++;

      if (areaName && areaName.trim() !== '') filledCount++;

      return filledCount >= 2 ? null : { atLeastTwoFieldsRequiredI: true };
    };
  }

  leiValidator(control: AbstractControl): ValidationErrors | null {
    const value = control.value;

    if (!value) return null; // Skip if empty (let required validator handle it)

    const alphanumericRegex = /^[a-zA-Z0-9]+$/;

    if (value.length !== 20) {
      return { invalidLength: true };
    }

    if (!alphanumericRegex.test(value)) {
      return { invalidCharacters: true };
    }

    return null; // Valid
  }

  async handleSaveClick() {
    console.log('asdasdadsasdasdasdasdasdasdasdasdasdasdasd');
    this.fvciForm.markAllAsTouched();
    this.registartionForm.markAllAsTouched();
    this.anextureToCafForm.markAllAsTouched();
    this.documentUploadForm.markAllAsTouched();
    this.declarationAndUndertakimgForm.markAllAsTouched();
    // const existingAppResponse =
    //     await this.saveApplicationService.fetchExistingApplication(
    //       this.applicationId!
    //     );
    //   if (!existingAppResponse?.data) {
    //     this.router.navigate(['/dashboard/application-list']);
    //     return;
    //   }
    //   console.log("---------------------------------10")
    //   const existingApp: DraftFvciApplicationDto = existingAppResponse.data;
    //   console.log("---------------------------------11")
    // const kycData: DraftFvicKycDetailsDto = this.fvciComponent.prepareKycDataForSave();
    //       const leiDataArray: Array<DraftFvciKycLeiDetailsDto> =
    //         this.fvciComponent.prepareLeiDataForSave();
    //       const incomeData: DraftFvciIncomeDetailsDto =
    //         this.fvciComponent.prepareIncomeDataForSave();
    //       const beneficialOwnership: DraftFvciBenificialOwnershipByControlDto =
    //         this.fvciComponent.prepareBeneficialOwnershipDataForSave();
    //       const addressesData: Array<DraftFvciAddressDetailsDto> =
    //         this.fvciComponent.prepareAddressDataForSave();
    //       // Replace the array with a single object
    //       const investmentManagerDetails: DraftFvciInvestmentManagerDetailsDto =
    //         this.fvciComponent.getInvestmentManagerDetails();
    //       const complianceOfficerDetails = this.fvciComponent.getComplianceOfficerDetails();
    //       const complianceOfficerEmail = this.fvciComponent.getComplianceOfficerEmail();
    //       const registrationData: DraftFvicRegistrationDetailsDto =
    //         this.fvciComponent.prepareRegistrationDataForSave();
    //       const telephoneData: Array<DraftFvciTelephoneNumberDetailsDto> =
    //         this.fvciComponent.prepareTelephoneDataForSave();
    //       const faxData: Array<DraftFvciFaxNumberDetailsDto> =
    //         this.fvciComponent.prepareFaxDataForSave();
    //       const beneficialOwnerDetails: DraftFvciEkycBenificialOwnerDetailsDto[] =
    //            this.fvciComponent.prepareBeneficialOwnerDetailsDataForSave()
    //       const kycDocumentDetails: DraftFvciKycDocumentDto[] =
    //         this.fvciComponent.prepareDocumentDataForSave();
    //       const contactDetails: DraftFvciEkycContactDetailsDto =
    //         this.fvciComponent.prepareContactDetailsDataForSave();
    //         const updatedComplianceOfficerDetails = this.fvciComponent.mergeSubObject(
    //           existingApp.complianceOfficerDetails,
    //           complianceOfficerDetails
    //         );
    //         const updatedComplianceOfficerEmail = this.fvciComponent.mergeSubObject(
    //           existingApp.complianceOfficerEmail,
    //           complianceOfficerEmail
    //         );
    //         const updatedRegistrationDetails = this.fvciComponent.mergeSubObject(
    //           existingApp.registrationDetails,
    //           registrationData
    //         );
    //         console.log("---------------------------------12")

    const updatedDeclaration: DraftFvciDeclarationUndertakingDetailsDto = {

            fvciApplicationId: this.applicationId,
            name: this.declarationAndUndertakimgForm.value.name,
            capacity: this.declarationAndUndertakimgForm.value.capacity,
            date: new Date(),
            place: this.declarationAndUndertakimgForm.value.place,
            nameOfSignatory: this.declarationAndUndertakimgForm.value.nameOfSignatory,
            designationOfSignatory:
              this.declarationAndUndertakimgForm.value.designationOfSignatory,
            // dateOfSignature: null,
            signature: '',
          };
    const applicationData = this.prepareDataForStep1(
      this.applicationId,
      this.prepareKycDataForSave(),
      
      // incomeData, // Pass the array directly
      this.prepareLeiDataForSave(),
      this.prepareAddressDataForSave(),
      this.getInvestmentManagerDetails(),
      this.getComplianceOfficerDetails(),
      this.prepareIncomeDataForSave(),
      this.getRegistrationDetails(),
      // addressesData,
      // investmentManagerDetails,
      
      // updatedComplianceOfficerEmail,
      // updatedRegistrationDetails,
      this.prepareTelephoneDataForSave(),
      this.prepareFaxDataForSave(),
      this.prepareContactDetailsDataForSave(),
      this.prepareBeneficialOwnershipDataForSave(),
      // faxData,
      // beneficialOwnership,
      this.prepareBeneficialOwnerDetailsDataForSave(),
      // kycDocumentDetails,
      // contactDetails
      this.prepareDocumentDataForSave(),
      this.getGlobalCustodianDetails(),
      this.getViolationDetails(),
      

    this.buildBankDeclaration(),
    this.buildKraPermission(),
    this.buildOwnershipDetails(),
    //     ekycBenificialOwnerDetails: existingApp.ekycBenificialOwnerDetails,
    //     incomeDetails: existingApp.incomeDetails,
    //     registrationDetails: existingApp.registrationDetails,
    //     benificialOwnershipByControlBoDetails:
          this.buildBeneficialOwnershipDetails(),
      this.buildBeneficialOwnershipByControl(),
       this.buildBasicOwnership(),
     this.buildSaSmFvciApplicants(),
    this.buildSubClassDetails(),
    updatedDeclaration
    );
    console.log('---------------------------------14');

    // const combinedFormData = {
    //   fvciForm: this.fvciForm.getRawValue(),
    //   registrationForm: this.registartionForm.getRawValue(),
    //   annexureToCafForm: this.anextureToCafForm.getRawValue(),
    //   documentUploadForm: this.documentUploadForm.getRawValue(),
    //   declarationAndUndertakingForm: this.declarationAndUndertakimgForm.getRawValue(),
    // };

    // console.log("combinedFormData", combinedFormData)

    console.log('Saving Data:', this.prepareKycDataForSave());

    // Replace with your actual save service method
    this.fvciService
      .apiFvciapplicationSaveOrUpdateApplicationPost(applicationData)
      .subscribe({
        next: () => {
          this.messageService.add({
            severity: 'success',
            summary: 'Success',
            detail: 'Application saved successfully!',
          });
        },
        error: (err) => {
          console.error('Save error:', err);
          this.messageService.add({
            severity: 'error',
            summary: 'Save Failed',
            detail: 'Could not save the application. Please try again.',
          });
        },
      });
  }

  prepareKycDataForSave(): DraftFvicKycDetailsDto {
    const formData = this.fvciForm.value;
    
    const rawValue = this.fvciForm.getRawValue();
    return {
      name: formData.name,
      hasOtherName: formData.applicantOtherName?.otherNameRadio ?? null,
      otherName: formData.applicantOtherName.otherNameField,
      dateOfIncorporation: formData.dateOfIncorporation,
      dateOfCommencement: formData.dateOfCommencement,
      placeOfIncorporation: formData.placeOfIncorporation,
      countryOfIncorporation: formData.countryOfIncorporation?.name,
      isdCountryCodeOfIncorporation: rawValue.countryCodeOfIncorporation?.code,
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

  prepareDataForStep1(
    applicationId: string | undefined,
    kycData: DraftFvicKycDetailsDto,
    leiDataArray: DraftFvciKycLeiDetailsDto[],
    addressesData: DraftFvciAddressDetailsDto[],
    investmentManagerDetails: DraftFvciInvestmentManagerDetailsDto,
    complianceOfficerDetails: DraftFvciComplianceOfficerDetailsDto,
      
    incomeData: DraftFvciIncomeDetailsDto, // Changed from single to array
    // leiDataArray: DraftFvciKycLeiDetailsDto[],
    // addressesData: DraftFvciAddressDetailsDto[],
    // investmentManagerDetails: DraftFvciInvestmentManagerDetailsDto,
    // complianceOfficerDetails: DraftFvciComplianceOfficerDetailsDto,
    // complianceOfficerEmail: DraftFvciComplianceOfficerEmailDto,
    registrationData: DraftFvicRegistrationDetailsDto,
    telephoneData: DraftFvciTelephoneNumberDetailsDto[],
    faxData: DraftFvciFaxNumberDetailsDto[],
    contactDetails: DraftFvciEkycContactDetailsDto,

    // telephoneData: DraftFvciTelephoneNumberDetailsDto[],
    // faxData: DraftFvciFaxNumberDetailsDto[],
    beneficialOwnershipByControl: DraftFvciBenificialOwnershipByControlDto,
    beneficialOwnerDetails: DraftFvciEkycBenificialOwnerDetailsDto[],
    kycDocumentDetails: DraftFvciKycDocumentDto[],
    // contactDetails: DraftFvciEkycContactDetailsDto
    globalCustodianDetails: DraftFvciGlobalCustodianDetailsDto,
    incidentsOfLawViolation: DraftFvciIncidentsOfLawViolationDto,
     isBank: DraftFvciIsBankDto,
     kraPermission: DraftFvciKraPermissionDto,
     ownershipDetails: DraftFvciOwnershipDetailsDto,
     benificialOwnershipByControlBoDetails?: Array<DraftFvciBenificialOwnershipByControlBoDetailsDto>,
     benificialOwnershipByControl?: DraftFvciBenificialOwnershipByControlDto,
     infoBasicOfOwnershipBoDetails?: Array<DraftFvciInfoBasicOfOwnershipBoDetailsDto>,
     informationOfSaSmFvciApplicant?: Array<DraftFvciInformationOfSaSmFvciApplicantDto>,
    subClassDetails?: Array<DraftFvciSubClassDetailsDto>,
    declarationUndertakingDetails?: DraftFvciDeclarationUndertakingDetailsDto,
   
  ): DraftFvciApplicationDto {
    return {
      applicationId,
      kycDetails: kycData,
      incomeDetails: incomeData, // No need for conditional here since we're passing an array directly
      // kycLeiDetails: leiDataArray,
      // addressDetails: addressesData,
      // investmentManagerDetails: investmentManagerDetails,
      // complianceOfficerDetails,
      // complianceOfficerEmail,
      kycLeiDetails: leiDataArray,
        addressDetails: addressesData,
        investmentManagerDetails: investmentManagerDetails,
        complianceOfficerDetails,
      registrationDetails: registrationData,
      telephoneNumberDetails: telephoneData,
        faxNumberDetails: faxData,
      // telephoneNumberDetails: telephoneData,
      // faxNumberDetails: faxData,
      benificialOwnershipByControl: benificialOwnershipByControl,
      ekycBenificialOwnerDetails: beneficialOwnerDetails,
      kycDocuments: kycDocumentDetails,
      contactDetails: contactDetails,
      globalCustodianDetails: globalCustodianDetails,
      incidentsOfLawViolation: incidentsOfLawViolation,
      isBank: isBank,
      kraPermission: kraPermission,
      ownershipDetails:ownershipDetails,
      
      benificialOwnershipByControlBoDetails:benificialOwnershipByControlBoDetails,
      infoBasicOfOwnershipBoDetails:infoBasicOfOwnershipBoDetails,
      informationOfSaSmFvciApplicant:informationOfSaSmFvciApplicant,
      subClassDetails:subClassDetails,  
      declarationUndertakingDetails: declarationUndertakingDetails,
    };
  }

  getRegistrationDetails(): DraftFvicRegistrationDetailsDto {
    const custodianGroup = this.registartionForm.get(
      'throughGlobalCustodian'
    ) as FormGroup;
    const bankGroup = this.registartionForm.get('designatedBank') as FormGroup;
    const priorAssociationGroup = this.registartionForm.get(
      'priorAssociation'
    ) as FormGroup;
    const panGroup = this.registartionForm.get('hasPan') as FormGroup;
    const disciplinaryGroup = this.registartionForm.get(
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
        !!this.registartionForm.get('providedValidForm')?.value,
      isComingFromGlobalCustodian:
        custodianGroup.get('throughGlobalCustodianRadio')?.value ===
        'throughGlobalCustodianRadioYes',

      // Extract name property from DDP, Custodian and DP objects
      ddpName:
        typeof this.registartionForm.get('ddpName')?.value === 'object'
          ? this.registartionForm.get('ddpName')?.value?.name || ''
          : this.registartionForm.get('ddpName')?.value || '',
      ddpRegistrationNumber:
        this.registartionForm.get('ddpRegistrationNumber')?.value || '',
      custodianName:
        typeof this.registartionForm.get('custodianName')?.value === 'object'
          ? this.registartionForm.get('custodianName')?.value?.name || ''
          : this.registartionForm.get('custodianName')?.value || '',
      custodianRegistrationNumber:
        this.registartionForm.get('custodianRegistrationNumber')?.value || '',
      dpName:
        typeof this.registartionForm.get('dpName')?.value === 'object'
          ? this.registartionForm.get('dpName')?.value?.name || ''
          : this.registartionForm.get('dpName')?.value || '',
      dpRegistrationNumber:
        this.registartionForm.get('dpRegistrationNumber')?.value || '',

      // // Use the properly extracted bank name
      bankName: bankName,
      bankAddress: bankGroup.get('designatedBankAddress')?.value || '',

      // // The rest remains the same
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
        typeOfEntity: this.fvciForm.value.typeOfEntity ?? '',
        typeOfApplicant: this.fvciForm.value.applicantType?.applicantTypeName ?? '',
        otherTypeOfApplicant:
        this.fvciForm.value.applicantType?.applicantTypeOtherEntity ?? '',
    };
  }

  private getGlobalCustodianDetails(): DraftFvciGlobalCustodianDetailsDto {
    const custodianGroup = this.registartionForm.get('throughGlobalCustodian');
    if (
      custodianGroup?.get('throughGlobalCustodianRadio')?.value ===
      'throughGlobalCustodianRadioYes'
    ) {
      return {
        fvciApplicationId: this.applicationId,
        name: custodianGroup.get('throughGlobalCustodianName')?.value || '',
        address:
          custodianGroup.get('throughGlobalCustodianAddress')?.value || '',
        country:
          custodianGroup.get('throughGlobalCustodianCountry')?.value || '',
        registrationNumber:
          custodianGroup.get('throughGlobalCustodianRegistration')?.value || '',
      };
    }
    return {} as DraftFvciGlobalCustodianDetailsDto;
  }

  onBankSelected(event: any): void {
    const selectedBank = event.value;
    const bankGroup = this.registartionForm.get('designatedBank') as FormGroup;

    bankGroup
      .get('designatedBankAddress')
      ?.patchValue(selectedBank?.address || '');
  }

  private getViolationDetails(): DraftFvciIncidentsOfLawViolationDto {
    const disciplinaryGroup = this.registartionForm.get('disciplinaryHistory');
    if (disciplinaryGroup?.get('disciplinaryHistoryRadio')?.value) {
      return {
        description:
          disciplinaryGroup.get('disciplinaryHistoryText')?.value || '',
      };
    }
    return { description: undefined };
  }

    prepareLeiDataForSave(): Array<DraftFvciKycLeiDetailsDto> {
      const formData = this.fvciForm.value;
      const leiDataArray: Array<DraftFvciKycLeiDetailsDto> = [];

      formData.taxResidencyRows.forEach((row: any) => {
        if (row.trcNo || row.country) {
          leiDataArray.push({
            trcNumber: row.trcNo,
            countryOfTaxResidence: row.country,
          });
        }
      });
      return leiDataArray;
    }


    prepareAddressDataForSave(): Array<DraftFvciAddressDetailsDto> {
      const formData = this.fvciForm.value;
      const fvciFormRaw = this.fvciForm.getRawValue();
      const addressesData: Array<DraftFvciAddressDetailsDto> = [];
      addressesData.push({
        flatBlockNo: formData.registeredOffice.registeredFlatNum,
        buildingPremisesVillageName:
          formData.registeredOffice.registeredBuildingName,
        roadStreetLaneName: formData.registeredOffice.registeredRoadName,
        areaLocalitySubdivision: formData.registeredOffice.registeredAreaName,
        townCityDistrict: formData.registeredOffice.registeredTownName,
        zipCode: fvciFormRaw.registeredOffice.registeredZipName,
        // countryCode: formData.registeredOffice.registeredCountryName?.code,
        state: formData.registeredOffice.registeredStateName,
        countryCode: formData.registeredOffice.registeredCountryName?.short_code,
        typeOfAddress: 'registered',
      });
     
        addressesData.push({
          flatBlockNo: fvciFormRaw.foreignOffice.foreignFlatNum,
          buildingPremisesVillageName: fvciFormRaw.foreignOffice.foreignBuildingName,
          roadStreetLaneName: fvciFormRaw.foreignOffice.foreignRoadName,
          areaLocalitySubdivision: fvciFormRaw.foreignOffice.foreignAreaName,
          townCityDistrict: fvciFormRaw.foreignOffice.foreignTownName,
          zipCode: fvciFormRaw.foreignOffice.foreignZipName,
          state: fvciFormRaw.foreignOffice.foreignStateName,
          countryCode: fvciFormRaw.foreignOffice.foreignCountryName?.short_code,
          typeOfAddress: 'foreignOffice',
        });
      if (
        formData.OfficeInIndia.OfficeInIndiaRadio 
      ) {
        addressesData.push({
          flatBlockNo: formData.OfficeInIndia.indianFlatNum,
          buildingPremisesVillageName: formData.OfficeInIndia.indianBuildingName,
          roadStreetLaneName: formData.OfficeInIndia.indianRoadName,
          areaLocalitySubdivision: formData.OfficeInIndia.indianAreaName,
          townCityDistrict: formData.OfficeInIndia.indianTownName,
          zipCode: fvciFormRaw.OfficeInIndia.indianZipName,
          state: formData.OfficeInIndia.indianStateName,
          countryCode: formData.OfficeInIndia.indianCountryName?.short_code,
          typeOfAddress: 'indianOffice',
        });
      }
      return addressesData;
    }

    prepareContactDetailsDataForSave(): DraftFvciEkycContactDetailsDto {
      const formData = this.fvciForm.value;
      return {
        fvciApplicationId: this.applicationId,
        website: formData.contactDetails.website,
        mobileNumber: formData.contactDetails.mobileNumber,
        emailId: formData.contactDetails.emailId,
      };
    }
    
    prepareTelephoneDataForSave(): Array<DraftFvciTelephoneNumberDetailsDto> {
      const formData = this.fvciForm.value;
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
      const formData = this.fvciForm.value;
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

    urlValidator(control: AbstractControl): ValidationErrors | null {
      const urlPattern = /^(https?:\/\/)?([\w\-]+\.)+[\w\-]{2,}(\/[\w\-._~:/?#[\]@!$&'()*+,;=]*)?$/i;
    
      if (!control.value) return null; // Let required validator handle empty
    
      return urlPattern.test(control.value)
        ? null
        : { invalidUrl: true };
    }

    getInvestmentManagerDetails(): DraftFvciInvestmentManagerDetailsDto {
      const investmentManagerGroup = this.fvciForm.get(
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
      const group = this.fvciForm.get('complianceOfficerInfo') as FormGroup;
      console.log("--------------------090909909")
      return {
        fvciApplicationId: this.applicationId,
        name: group.get('complianceOfficerInfoName')?.value,
        jobTitle: group.get('complianceOfficerInfoJob')?.value,
        phoneNumber: group.get('complianceOfficerInfoMobile')?.value,
        faxNumber: group.get('complianceOfficerInfoFax')?.value,
      };
    }

    prepareBeneficialOwnershipDataForSave(): DraftFvciBenificialOwnershipByControlDto {
      const formData = this.fvciForm.value;
      return {
        fvciApplicationId: this.applicationId,
        isNoEntityControlsThroughVoting: !formData.ultimateBeneficialOwner,
      };
    }

    prepareBeneficialOwnerDetailsDataForSave(): DraftFvciEkycBenificialOwnerDetailsDto[] {
      const managingRows = this.fvciForm.get(
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
    prepareIncomeDataForSave(): DraftFvciIncomeDetailsDto {
      const formData = this.fvciForm.value;
  
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

    prepareDocumentDataForSave(): DraftFvciKycDocumentDto[] {
      const formData = this.fvciForm.value;
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

    buildBankDeclaration(): DraftFvciIsBankDto {
        const bankFormValue = this.anextureToCafForm.get('bankDeclaration')?.value;
        if (bankFormValue.bankDeclarationRadio === 'bank_with_office') {
          return {
            fvciApplicationId: this.applicationId,
            isBank: true,
            nameOfBank: bankFormValue.bankDeclarationText,
            haveOfficeInIndia: true,
          };
        } else if (bankFormValue.bankDeclarationRadio === 'bank_no_office') {
          return {
            fvciApplicationId: this.applicationId,
            isBank: true,
            nameOfBank: '',
            haveOfficeInIndia: false,
          };
        }
        return {
          fvciApplicationId: this.applicationId,
          isBank: false,
          nameOfBank: '',
          haveOfficeInIndia: false,
        };
      }

      buildKraPermission(): DraftFvciKraPermissionDto {
          const kraFormValue = this.anextureToCafForm.get('consentIntermediary')?.value;
          return {
            fvciApplicationId: this.applicationId,
            isKraRequired: kraFormValue.consentIntermediaryRadio,
            nameOfFvciRepresentative: kraFormValue.consentIntermediaryName,
            email1: kraFormValue.consentIntermediaryEmail1,
            email2: kraFormValue.consentIntermediaryEmail2,
            email3: kraFormValue.consentIntermediaryEmail3,
            phoneNumber: kraFormValue.consentIntermediaryMobile,
      
            // isKraRequired: true,
            // nameOfFvciRepresentative: 'A',
            // email1: 'example',
            // email2: 'exampleeee',
            // email3: 'exampl',
            // phoneNumber: '89',
          };
        }

        private buildOwnershipDetails(): DraftFvciOwnershipDetailsDto {
            const entityHolding =
              parseFloat(this.anextureToCafForm.get('entityHolding')?.value) || 0;
            return {
              fvciApplicationId: this.applicationId,
              isNoEntityHoldingGt:
                this.anextureToCafForm.get('intermediateMaterial')?.value ?? false,
              entityHolding,
            };
          }

          buildBeneficialOwnershipDetails(): DraftFvciBenificialOwnershipByControlBoDetailsDto[] {
              return (this.anextureToCaf.beneficialOwners.controls as FormGroup[]).map(
                (group: FormGroup) => {
                  const val = group.value;
                  return {
                    fvciApplicationId: this.applicationId,
                    nameOfBo: val['a)'],
                    methodOfControl: val['b)'],
                    country: val['c)'],
                    controlPercentage: parseFloat(val['d)']) || undefined,
                    isIndividual: val['e)']?.toLowerCase() === 'individual',
                  } as DraftFvciBenificialOwnershipByControlBoDetailsDto;
                }
              );
            }



 


  private buildBeneficialOwnershipByControl(): DraftFvciBenificialOwnershipByControlDto {
    const noEntityControls = !this.anextureToCafForm.get('beneficialOwnership')?.value;
    return {
      fvciApplicationId: this.applicationId,
      isNoEntityControlsThroughVoting: noEntityControls ?? false,
    };
  }
  

  private buildBasicOwnership(): DraftFvciInfoBasicOfOwnershipBoDetailsDto[] {
      return this.anextureToCaf.materialShareholderRows.controls.map((group: FormGroup) => {
        const val = group.value;
        return {
          fvciApplicationId: this.applicationId,
          nameOfBo: val['a)'],
          stake: parseFloat(val['b)']) || undefined,
          nameOfEntity: val['c)'],
          country: val['d)'],
          stakePercentage: parseFloat(val['e)']) || undefined,
          isIndividual: val['f)']?.toLowerCase() === 'individual',
        } as DraftFvciInfoBasicOfOwnershipBoDetailsDto;
      });
    }

    buildSaSmFvciApplicants(): DraftFvciInformationOfSaSmFvciApplicantDto[] {
        return (this.anextureToCaf.infoSaSmApplicantRows.controls as FormGroup[]).map(
          (group: FormGroup) => {
            return {
              fvciApplicationId: this.applicationId,
              name: group.get('1')?.value,
              relationshipWithApplicant: group.get('2')?.value,
              pan: group.get('3')?.value,
              country: group.get('4')?.value,
              dateOfBirth: group.get('5')?.value
                ? new Date(group.get('5')!.value)
                : undefined,
              address: group.get('6')?.value,
              govermentId: group.get('7')?.value,
            } as DraftFvciInformationOfSaSmFvciApplicantDto;
          }
        );
      }


      buildSubClassDetails(): DraftFvciSubClassDetailsDto[] {
          return this.anextureToCaf.signatoryRows.controls.map(
            (control: FormGroup): DraftFvciSubClassDetailsDto => {
              const value = control.value;
              const parentName =
                Array.isArray(value.details) && value.details.length
                  ? value.details[0]
                  : '';
              const ownerDetailsArray = control.get('ownerDetails') as FormArray;
              const ownerDetails: DraftFvciSubClassBenificialOwnerDetailsDto[] =
                ownerDetailsArray.controls.map((ownerControl: any) => {
                  const ownerValue = (ownerControl as FormGroup).value;
                  return {
                    name: ownerValue['1'],
                    relationshipWithApplicant: ownerValue['2'],
                    pan: ownerValue['3'],
                    nationality: ownerValue['4'],
                    dateOfBirth: ownerValue['5']
                      ? new Date(ownerValue['5'])
                      : undefined,
                    residentialAddress: ownerValue['6'],
                    governmentDocIdentityNumber: ownerValue['7'],
                  } as DraftFvciSubClassBenificialOwnerDetailsDto;
                });
              return {
                fvciApplicationId: this.applicationId,
                name: parentName,
                subClassBenificialOwnerDetails: ownerDetails,
              } as DraftFvciSubClassDetailsDto;
            }
          );
        }
}
