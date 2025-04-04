import {
  Component,
  Input,
  OnChanges,
  OnDestroy,
  OnInit,
  SimpleChanges,
  ViewEncapsulation,
} from '@angular/core';
import {
  DraftFvciApplicationDto,
  DraftFvciDeclarationUndertakingDetailsDto,
  DraftFvciIncomeDetailsDto,
} from '../../../../../swagger';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { SaveApplicationService } from '../../../../services/save-application.service';
import { FormProgressService } from '../../../../services/form-progress.service';
import { Subscription } from 'rxjs';
import { MessageService } from 'primeng/api';

@Component({
  selector: 'app-declaration-undertaking',
  standalone: false,
  templateUrl: './declaration-undertaking.component.html',
  styleUrl: './declaration-undertaking.component.scss',
  encapsulation: ViewEncapsulation.None,
})
export class DeclarationUndertakingComponent
  implements OnInit, OnChanges, OnDestroy
{
  @Input() applicationId: string | undefined;
  @Input() applicationData!: any;
  @Input() previewMode: boolean = false;
  @Input() declarationForm!: FormGroup;
  @Input() formGroup!: FormGroup;
  currentDate: Date = new Date();

  showLoader: boolean = false;
  saveSubscription!: Subscription;
  maxDate: Date = new Date();

  // Sample table data for signatory information (if needed)
  readonly tableData = [
    {
      name: 'Roopali Katre DSC testing',
      designation: 'AM',
      status: 'Digitally Signed',
    },
  ];

  readonly signatureOptions = [
    { label: 'Option 1', value: 'option1' },
    { label: 'Option 2', value: 'option2' },
    { label: 'Option 3', value: 'option3' },
  ];

  requiredMapping: { [key: string]: string[] } = {
    name: ['name'],
    capacity: ['capacity'],
    place: ['place'],
    date: ['date'],
    nameOfSignatory: ['nameOfSignatory'],
    designationOfSignatory: ['designationOfSignatory'],
    dateOfSignature: ['dateOfSignature'],
    signature: ['signature'],
  };

  constructor(
    private readonly saveApplicationService: SaveApplicationService,
    private readonly progressService: FormProgressService,
    private readonly messageService: MessageService
  ) {}

  ngOnInit(): void {
    console.log('======', this.declarationForm);

    // Handle both direct applicationData (for preview) and fetching
    if (this.previewMode && this.applicationData) {
      // We already have application data for preview
      // this.populateFormWithApplicationData();
      // Disable the form for preview mode
      this.declarationForm.disable();
    } else {
      // Normal case - fetch from API
      this.fetchDeclarationDetails();
    }

    if (!this.previewMode) {
      this.saveSubscription =
        this.saveApplicationService.saveTrigger$.subscribe(() => {
          this.saveDeclaration();
        });
    }
  }

  

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['applicationData'] && changes['applicationData'].currentValue) {
      this.initializeForm();
    }
  }

  ngOnDestroy(): void {
    if (this.saveSubscription) {
      this.saveSubscription.unsubscribe();
    }
  }

  initializeForm(): void {
    // This function now populates the form based on the applicationData
    if (!this.applicationData || !this.applicationData.data) return;

    const declarationData =
      this.applicationData.data.declarationUndertakingDetails ||
      this.applicationData.data.declarationAndUndertakingForm;

    if (declarationData) {
      const date = declarationData.date ? new Date(declarationData.date) : null;
      const dateOfSignature = declarationData.dateOfSignature
        ? new Date(declarationData.dateOfSignature)
        : null;

      // First try to use formGroup if available
      if (this.formGroup) {
        this.formGroup.patchValue({
          name: declarationData.name || '',
          capacity: declarationData.capacity || '',
          place: declarationData.place || '',
          nameOfSignatory: declarationData.nameOfSignatory || '',
          designationOfSignatory: declarationData.designationOfSignatory || '',
          signature: declarationData.signature || '',
          date: date,
          dateOfSignature: dateOfSignature,
        });
      }

      // Also update declarationForm for consistency
      if (this.declarationForm) {
        this.declarationForm.patchValue({
          name: declarationData.name || '',
          capacity: declarationData.capacity || '',
          place: declarationData.place || '',
          nameOfSignatory: declarationData.nameOfSignatory || '',
          designationOfSignatory: declarationData.designationOfSignatory || '',
          signature: declarationData.signature || '',
          date: date,
          dateOfSignature: dateOfSignature,
        });
      }
    }

    // Make sure to update validity
    if (this.formGroup) this.formGroup.updateValueAndValidity();
    if (this.declarationForm) this.declarationForm.updateValueAndValidity();
  }

  async fetchDeclarationDetails(): Promise<void> {
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
        const appData: DraftFvciApplicationDto = response.data;

        // Store the fetched data in applicationData for future reference
        this.applicationData = response;

        // If the declaration details exist, patch the form with their values.
        if (appData.declarationUndertakingDetails) {
          const details = appData.declarationUndertakingDetails;

          if (this.declarationForm) {
            this.declarationForm.patchValue({
              name: details.name || '',
              capacity: details.capacity || '',
              place: details.place || '',
              // Convert the date strings to Date objects:
              date: details.date ? new Date(details.date) : null,
              nameOfSignatory: details.nameOfSignatory || '',
              designationOfSignatory: details.designationOfSignatory || '',
              dateOfSignature: details.dateOfSignature
                ? new Date(details.dateOfSignature)
                : null,
              signature: details.signature || '',
            });
          }
        }
      }

      this.progressService.updateComponentProgress(
        'declarationUndertaking',
        this.declarationForm?.value || {},
        this.requiredMapping
      );
    } catch (error) {
      console.error('Error fetching declaration details:', error);
    } finally {
      this.showLoader = false;
    }
  }

  async saveDeclaration(): Promise<void> {
    if (!this.applicationId) {
      this.messageService.add({
        severity: 'error',
        summary: 'Error',
        detail: 'Application ID is missing.',
      });
      return;
    }

    // Use the appropriate form based on what's available
    const formToUse = this.formGroup || this.declarationForm;
    if (!formToUse || formToUse.invalid) {
      this.messageService.add({
        severity: 'error',
        summary: 'Error',
        detail: 'Please fill all required fields correctly.',
      });
      return;
    }

    this.showLoader = true;
    try {
      // Fetch the current application first
      const existingAppResponse =
        await this.saveApplicationService.fetchExistingApplication(
          this.applicationId
        );
      if (!existingAppResponse?.data) {
        this.messageService.add({
          severity: 'error',
          summary: 'Error',
          detail: 'No existing application data found.',
        });
        return;
      }

      const existingApp: DraftFvciApplicationDto = existingAppResponse.data;

      // Keep income details as they are
      if (existingApp.incomeDetails) {
        existingApp.incomeDetails = this.prepareIncomeDataForSave(
          existingAppResponse.data
        );
      }

      // Build the updated declaration details object from the form values
      const updatedDeclaration: DraftFvciDeclarationUndertakingDetailsDto = {
        id: existingApp.declarationUndertakingDetails
          ? existingApp.declarationUndertakingDetails.id
          : 0,
        fvciApplicationId: this.applicationId,
        name: formToUse.value.name,
        capacity: formToUse.value.capacity,
        date: formToUse.value.date || new Date(),
        place: formToUse.value.place,
        nameOfSignatory: formToUse.value.nameOfSignatory,
        designationOfSignatory: formToUse.value.designationOfSignatory,
        dateOfSignature: formToUse.value.dateOfSignature || new Date(),
        signature: formToUse.value.signature || '',
      };

      // Update only the declarationUndertakingDetails field, leaving other fields intact.
      const updatedApp: DraftFvciApplicationDto = {
        ...existingApp,
        declarationUndertakingDetails: updatedDeclaration,
      };

      const response = await this.saveApplicationService.saveData(updatedApp);
      if (response) {
        this.messageService.add({
          severity: 'success',
          summary: 'Success',
          detail: response.Message || 'Declaration updated successfully!',
        });

        // After successful save, refetch the data to ensure we have the latest
        await this.fetchDeclarationDetails();
      } else {
        this.messageService.add({
          severity: 'error',
          summary: 'Error',
          detail: 'Failed to update declaration. Please try again.',
        });
      }
    } catch (error) {
      console.error('Error saving declaration:', error);
      this.messageService.add({
        severity: 'error',
        summary: 'Error',
        detail: 'An unexpected error occurred. Please try again.',
      });
    } finally {
      this.showLoader = false;
    }
  }

  prepareIncomeDataForSave(incomeDetailsData: any): DraftFvciIncomeDetailsDto {
    if (!incomeDetailsData || !incomeDetailsData.incomeDetails) {
      return {
        fvciApplicationId: this.applicationId,
        sourceOfIncome: [],
        codeOfBusiness: '',
        grossAnnualIncome: 0,
        netWorth: 0,
      };
    }

    // Extract selected sources of income (as an array of strings)
    const selectedSources: string[] =
      typeof incomeDetailsData.incomeDetails.sourceOfIncome === 'string'
        ? incomeDetailsData.incomeDetails.sourceOfIncome.split(',')
        : incomeDetailsData.incomeDetails.sourceOfIncome || [];

    // Prepare the single DTO object
    const incomeDetails: DraftFvciIncomeDetailsDto = {
      fvciApplicationId: this.applicationId,
      sourceOfIncome: selectedSources, // Now storing as an array
      codeOfBusiness:
        incomeDetailsData.incomeDetails.businessCode ||
        incomeDetailsData.incomeDetails.codeOfBusiness ||
        '',
      grossAnnualIncome: Number(
        incomeDetailsData.incomeDetails.annualIncome ||
          incomeDetailsData.incomeDetails.grossAnnualIncome ||
          0
      ),
      netWorth: Number(
        incomeDetailsData.incomeDetails.assetLess ||
          incomeDetailsData.incomeDetails.netWorth ||
          0
      ),
    };

    return incomeDetails;
  }
}
