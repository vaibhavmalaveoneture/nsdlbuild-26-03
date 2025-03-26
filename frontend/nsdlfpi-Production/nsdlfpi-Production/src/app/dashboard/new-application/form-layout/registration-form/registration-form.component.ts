import {
  Component,
  Input,
  OnInit,
  OnDestroy,
  ViewEncapsulation,
} from '@angular/core';
import { AbstractControl, FormArray, FormControl, FormGroup, Validators } from '@angular/forms';
import { City, designationData, regulationData, priorAssociationDetailsData, Income } from '../../data';
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
  @Input() applicationData: DraftFvciApplicationDto | null = null;
  @Input() previewMode: boolean = false;
  @Input() formGroup!: FormGroup;
  private saveSubscription!: Subscription;
  showLoader = false;
  download = '/assets/downloads.png';
  countries: any[] = [];
  countryCodes: any[] = [];
  ddpOptions!: any[];
  custodianOptions!: any[];
  bankOptions!: any[];
    incomeSourceOptions!: Income[];
  regulationData = regulationData;
  designationData = designationData;
   detailsData: any = priorAssociationDetailsData;
  // Add this line to define the property
  proofOfIdentityOptions!: any[];

  hasOtherEntity = false;

  constructor(
    private readonly commonService: CommonService,
    private readonly saveApplicationService: SaveApplicationService,
    private readonly messageService: MessageService,
    private readonly router: Router,
    private readonly progressService: FormProgressService,
    private validationService: FormValidationService
  ) {}

  ngOnInit(): void {
    this.initializeForm();
    this.initializePriorAssociationRows();
    // Handle both direct applicationData (for preview) and fetching
    console.log("applicatiasdad", this.applicationData)
    if (this.previewMode && this.applicationData) {
      // We already have application data for preview
      this.populateFormWithApplicationData(this.applicationData);
      // Disable the form for preview mode
      this.formGroup.disable();
    } else {
      // Normal case - fetch from API
      // this.fetchUserApplication();
    }

    // console.log(this.validationService.validationFlag);
    // if(this.validationService.validationFlag){
    //   this.validationService.requestValidation();
    //   this.formGroup.markAllAsTouched();
    // }
  }

  ngOnDestroy(): void {
    if (this.saveSubscription) {
      this.saveSubscription.unsubscribe();
    }
  }

  private readonly requiredMapping: { [key: string]: any } = {
    applicantType: {
      fields: ['applicantTypeName', 'applicantTypeRadio'],
      conditional: {
        condition: (value: any) => value === 'applicantTypeRadioYes',
        field: 'applicantTypeOtherEntity',
      },
    },
    providedValidForm: [''],
    throughGlobalCustodian: [
      'throughGlobalCustodianRadio',
      'throughGlobalCustodianName',
      'throughGlobalCustodianAddress',
    ],
    designatedBank: ['designatedBankName', 'designatedBankAddress'],
    priorAssociation: ['priorAssociationRadio', 'detailsOfPriorAssociation'],
    hasPan: ['hasPanRadio', 'hasPanNumber'],
    disciplinaryHistory: [
      'disciplinaryHistoryRadio',
      'disciplinaryHistoryText',
    ],
    // Add individual controls to required mapping
    regulatoryAuthorityName: [''],
    regulatoryAuthorityCountry: [''],
    regulatoryAuthorityWebsite: [''],
    regulatoryAuthorityRegNumber: [''],
    regulatoryAuthorityCategory: [''],
    ddpName: [''],
    ddpRegistrationNumber: [''],
    custodianName: [''],
    custodianRegistrationNumber: [''],
    dpName: [''],
    dpRegistrationNumber: [''],
  };

  get allCorrectValue(): boolean {
    return this.formGroup.valid;
  }

  private initializeForm(): void {
    // No need to initialize form arrays anymore
    if (!this.previewMode) {
      this.saveSubscription =
        this.saveApplicationService.saveTrigger$.subscribe(() => {
          this.saveForm();
        });
      this.formGroup.valueChanges
        .pipe(debounceTime(300))
        .subscribe((formValue) => {
          this.progressService.updateComponentProgress(
            'registrationForm',
            formValue,
            this.requiredMapping
          );
        });
    }
  }

  async fetchUserApplication(): Promise<void> {
    console.log("---------------------------------------------------------------2")
    await this.loadMasterData();
    // Use existing applicationData if in preview mode
    if (this.previewMode && this.applicationData) {
      this.populateFormWithApplicationData(this.applicationData);
      this.formGroup.disable();
      return;
    }
    if (!this.applicationId) {
      return;
    }
    this.showLoader = true;
    try {
      const response =
        await this.saveApplicationService.fetchExistingApplication(
          this.applicationId
        );
      if (response?.success && response.data) {
        const appData = response.data;

        this.mapDesignationDetails(appData);
        this.mapApplicantDetails(appData);
        this.mapRegulatoryAuthorityDetails(appData);
        this.populateFormWithApplicationData(appData);
      }
    } catch (error) {
      console.error('Error fetching user application:', error);
      // Optionally show an error message here using messageService
    } finally {
      this.showLoader = false;
    }
  }


 populateFormWithApplicationData(
    appData: DraftFvciApplicationDto
  ): void {
    console.log("indininininininin")
    if (!appData) return;

    // In preview mode, we need to handle dropdown values differently
    if (this.previewMode) {
      // Wait for the master data (dropdown options) to be loaded
      this.loadMasterData().then(() => {
        console.log("into polpulate 2")
        this.mapDesignationDetails(appData);
        this.mapApplicantDetails(appData);
        this.mapRegulatoryAuthorityDetails(appData);
        this.mapIndianMarketAssociations(appData.indianMarketAssocians || []);
        // Disable the form since we're in preview mode
        this.formGroup.disable();
      });
    } else {
      console.log("into polpulate 1")
      // Normal case - proceed as before
      this.mapDesignationDetails(appData);
      this.mapApplicantDetails(appData);
      this.mapRegulatoryAuthorityDetails(appData);
      console.log("appData.indianMarketAssocians", appData.indianMarketAssocians)
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
        appData.registrationDetails?.isProvidedFactaCrsProvided || null,
      throughGlobalCustodian: {
        // Set to null if data isn't available, rather than a default string.
        throughGlobalCustodianRadio: appData.registrationDetails
          ?.isComingFromGlobalCustodian
          ? 'throughGlobalCustodianRadioYes'
          : null,
        throughGlobalCustodianName:
          appData.globalCustodianDetails?.name || '',
        
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
          appData.registrationDetails?.isAssociatedWithSecuritiesMarket || null,
        detailsOfPriorAssociation:
          appData.registrationDetails?.detailsOfPriorAssociation || '',
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
    console.log("priorAssiciationRows", moRows, details.length, details)
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
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  }

  onDdpSelected(event: any, index: number): void {
    const selectedOption = event.value;

    if (index === 0) {
      this.formGroup
        .get('ddpRegistrationNumber')
        ?.patchValue(selectedOption?.registrationNumber || '');
    } else if (index === 1) {
      this.formGroup
        .get('custodianRegistrationNumber')
        ?.patchValue(selectedOption?.registrationNumber || '');
    } else if (index === 2) {
      this.formGroup
        .get('dpRegistrationNumber')
        ?.patchValue(selectedOption?.registrationNumber || '');
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

  async saveForm(): Promise<void> {
    if (!this.applicationId) {
      this.router.navigate(['/dashboard/application-list']);
      return;
    }

    this.showLoader = true;
    try {
      const existingAppResponse =
        await this.saveApplicationService.fetchExistingApplication(
          this.applicationId
        );
      if (!existingAppResponse?.data) {
        this.router.navigate(['/dashboard/application-list']);
        return;
      }
      const existingApp: DraftFvciApplicationDto = existingAppResponse.data;
      existingApp.indianMarketAssocians = this.getIndianMarketAssociationDetails();
      existingApp.incomeDetails = this.prepareIncomeDataForSave(existingAppResponse.data)
      console.log("added indian market association", existingApp.incomeDetails)
      
      
      const registrationData = this.getRegistrationDetails();
      const regulatoryAuthorityDetailsDto =
        this.getRegulatoryAuthorityDetailsDto();
      const globalCustodianDetails = this.getGlobalCustodianDetails();
      const incidentsOfLawViolation = this.getViolationDetails();

      // Ensure all string fields are properly converted
      const updatedRegistrationDetails = {
        ...existingApp.registrationDetails,
        ...registrationData,
        ddpName: String(registrationData.ddpName || ''),
        ddpRegistrationNumber: String(
          registrationData.ddpRegistrationNumber || ''
        ),
        custodianName: String(registrationData.custodianName || ''),
        custodianRegistrationNumber: String(
          registrationData.custodianRegistrationNumber || ''
        ),
        dpName: String(registrationData.dpName || ''),
        dpRegistrationNumber: String(
          registrationData.dpRegistrationNumber || ''
        ),
        bankName: String(registrationData.bankName || ''),
        bankAddress: String(registrationData.bankAddress || ''),
        detailsOfPriorAssociation: String(
          registrationData.detailsOfPriorAssociation || ''
        ),
        panNumber: String(registrationData.panNumber || ''),
      };

      const updatedApp: DraftFvciApplicationDto = {
        ...existingApp,
        applicationId: this.applicationId,
        registrationDetails: updatedRegistrationDetails,
        regulatoryAuthorityDetails: {
          ...existingApp.regulatoryAuthorityDetails,
          ...regulatoryAuthorityDetailsDto,
          regulatoryAuthorityName: String(
            regulatoryAuthorityDetailsDto.regulatoryAuthorityName || ''
          ),
          regulatoryAuthorityCountry: String(
            regulatoryAuthorityDetailsDto.regulatoryAuthorityCountry || ''
          ),
          regulatoryAuthorityWebsite: String(
            regulatoryAuthorityDetailsDto.regulatoryAuthorityWebsite || ''
          ),
          regulatoryAuthorityRegNumber: String(
            regulatoryAuthorityDetailsDto.regulatoryAuthorityRegNumber || ''
          ),
          regulatoryAuthorityCategory: String(
            regulatoryAuthorityDetailsDto.regulatoryAuthorityCategory || ''
          ),
        },
        globalCustodianDetails: {
          ...existingApp.globalCustodianDetails,
          ...globalCustodianDetails,
          name: String(globalCustodianDetails.name || ''),
          address: String(globalCustodianDetails.address || ''),
        },
        incidentsOfLawViolation: {
          ...existingApp.incidentsOfLawViolation,
          ...incidentsOfLawViolation,
          description: String(incidentsOfLawViolation.description || ''),
        },
      };

      // Add console log here to see the data being sent

      const response = await this.saveApplicationService.saveData(updatedApp);
      if (response) {
        this.messageService.add({
          severity: 'success',
          summary: 'Success',
          detail: response.Message || 'Application updated successfully!',
        });
      } else {
        this.messageService.add({
          severity: 'error',
          summary: 'Error',
          detail: 'Failed to update application. Please try again.',
        });
      }
    } catch (error) {
      console.error('Error saving form:', error);
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

  prepareIncomeDataForSave(incomeDetailsData: any): DraftFvciIncomeDetailsDto {
      
  
      // Extract selected sources of income (as an array of strings)
      const selectedSources: string[] = incomeDetailsData.incomeDetails.sourceOfIncome.split(',');
  
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

  private getIndianMarketAssociationDetails(): DraftFvciIndianMarketAssociansDto[]{
    const priorAssiciationRows = this.formGroup.get(
          'priorAssiciationRows'
        ) as FormArray;
        console.log("priorAssiciationRows", priorAssiciationRows)
        return priorAssiciationRows.controls.map((rowControl: AbstractControl) => {
          const rowGroup = rowControl as FormGroup;
          const details = rowGroup.get('details') as FormGroup;
          
          return {
            id: rowGroup.get('id')?.value,
            fvciApplicationId: this.applicationId,
            name: details.get('1')?.value,
            associatedAs: details.get('2')?.value,
            registrationNumber: details.get('3')?.value,
            periodOfRegistration: details.get('4')?.value
          };
        });
  }

  private getGlobalCustodianDetails(): DraftFvciGlobalCustodianDetailsDto {
    const custodianGroup = this.formGroup.get('throughGlobalCustodian');
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

  private getViolationDetails(): DraftFvciIncidentsOfLawViolationDto {
    const disciplinaryGroup = this.formGroup.get('disciplinaryHistory');
    if (disciplinaryGroup?.get('disciplinaryHistoryRadio')?.value) {
      return {
        description:
          disciplinaryGroup.get('disciplinaryHistoryText')?.value || '',
      };
    }
    return { description: undefined };
  }

  submitForm(): boolean {
    this.formGroup.markAllAsTouched();
    if (this.formGroup.valid) {
      return true;
    } else {
      return false;
    }
  }

  get priorAssiciationRows() {
    return this.formGroup.get('priorAssiciationRows') as FormArray<FormGroup>;
  }

  initializePriorAssociationRows(): void {
    const row = new FormGroup({
      id: new FormControl(this.getNextManagingOfficialId()),
      details: new FormGroup(
        this.detailsData.reduce((acc: any, field: any) => {
          if(field.isRequired){
            acc[field.id] = new FormControl('');
          }else{
            acc[field.id] = new FormControl('');
          }
          
          return acc;
        }, {} as { [key: string]: FormControl })
      ),
    });
    this.priorAssiciationRows.push(row);
    // this.progressService.updateComponentProgress(
    //   'ekycForm',
    //   this.formGroup.value,
    //   this.requiredMapping
    // );
  }

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

  addPriorAssociationRow(): void {
    this.initializePriorAssociationRows();
  }

  removePriorAssociationRow(index: number): void {
    if (this.priorAssiciationRows.length > 1) {
      this.priorAssiciationRows.removeAt(index);
    }
  }
}
