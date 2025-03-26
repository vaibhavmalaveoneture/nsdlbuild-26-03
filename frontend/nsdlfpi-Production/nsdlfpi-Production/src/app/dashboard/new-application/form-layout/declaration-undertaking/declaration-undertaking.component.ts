import {
  Component,
  Input,
  OnDestroy,
  OnInit,
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
export class DeclarationUndertakingComponent implements OnInit, OnDestroy {
  @Input() applicationId: string | undefined;
  @Input() applicationData: DraftFvciApplicationDto | null = null;
  @Input() previewMode: boolean = false;
  @Input() declarationForm!: FormGroup;
  currentDate: Date = new Date();

  // declarationForm!: FormGroup;
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
    // Handle both direct applicationData (for preview) and fetching
    if (this.previewMode && this.applicationData) {
      // We already have application data for preview
      this.populateFormWithApplicationData(this.applicationData);
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

  // New method to populate form with application data
  private populateFormWithApplicationData(
    appData: DraftFvciApplicationDto
  ): void {
    if (!appData) return;

    if (appData.declarationUndertakingDetails) {
      const details = appData.declarationUndertakingDetails;
      this.declarationForm.patchValue({
        name: details.name,
        capacity: details.capacity,
        place: details.place,
        // Convert the date strings to Date objects:
        date: details.date ? new Date(details.date) : this.currentDate,
        nameOfSignatory: details.nameOfSignatory,
        designationOfSignatory: details.designationOfSignatory,
        dateOfSignature: details.dateOfSignature
          ? new Date(details.dateOfSignature)
          : this.currentDate,
        signature: details.signature,
      });
    }
  }

  ngOnDestroy(): void {
    if (this.saveSubscription) {
      this.saveSubscription.unsubscribe();
    }
  }

  initializeForm(): void {
    // this.declarationForm.get('date')?.disable();
    // this.declarationForm.get('dateOfSignature')?.disable();
    this.declarationForm.updateValueAndValidity();
  }

  // onFormDataChange(): void {
  //   // Update progress or local state as needed.
  //   this.progressService.updateComponentProgress(
  //     'declarationUndertaking',
  //     this.declarationForm.value,
  //     this.requiredMapping
  //   );
  // }

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
        // If the declaration details exist, patch the form with their values.

        if (appData.declarationUndertakingDetails) {
          const details = appData.declarationUndertakingDetails;

          this.declarationForm.patchValue({
            name: details.name,
            capacity: details.capacity,
            place: details.place,
            // Convert the date strings to Date objects:
            date: details.date ? new Date(details.date) : null,
            nameOfSignatory: details.nameOfSignatory,
            designationOfSignatory: details.designationOfSignatory,
            dateOfSignature: details.dateOfSignature
              ? new Date(details.dateOfSignature)
              : null,
            signature: details.signature,
          });
        }
      }

      this.progressService.updateComponentProgress(
        'declarationUndertaking',
        this.declarationForm.value,
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
      existingApp.incomeDetails = this.prepareIncomeDataForSave(existingAppResponse.data)
      // Build the updated declaration details object from the form values
      const updatedDeclaration: DraftFvciDeclarationUndertakingDetailsDto = {
        id: existingApp.declarationUndertakingDetails
          ? existingApp.declarationUndertakingDetails.id
          : 0,
        fvciApplicationId: this.applicationId,
        name: this.declarationForm.value.name,
        capacity: this.declarationForm.value.capacity,
        date: new Date(),
        place: this.declarationForm.value.place,
        nameOfSignatory: this.declarationForm.value.nameOfSignatory,
        designationOfSignatory:
          this.declarationForm.value.designationOfSignatory,
        dateOfSignature: new Date(),
        signature: '',
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
}
