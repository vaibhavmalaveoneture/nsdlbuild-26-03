import { Injectable } from '@angular/core';
import {
  BehaviorSubject,
  catchError,
  firstValueFrom,
  Observable,
  Subject,
  throwError,
} from 'rxjs';
import {
  BASE_PATH,
  DeleteFileRequest,
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
} from '../../swagger';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root',
})
export class SaveApplicationService {
  steps: { name: string; step: number }[] = [
    { name: 'EKYC', step: 1 },
    { name: 'FVCI Registration', step: 2 },
    { name: 'Annexture to CAF', step: 3 },
    { name: 'Document Upload', step: 4 },
    { name: 'Declaration and Undertaking', step: 5 },
    { name: 'Acknowledgement', step: 6 },
  ];

  private readonly formDataSubject = new BehaviorSubject<any>(null);
  private readonly saveTriggerSubject = new Subject<void>();
  saveTrigger$ = this.saveTriggerSubject.asObservable();

  constructor(
    private readonly fvciService: FvciApplicationService,
    private readonly http: HttpClient
  ) {}

  setFormData(data: any) {
    this.formDataSubject.next(data);
  }

  prepareDataForStep1(
    applicationId: string | undefined,
    kycData: DraftFvicKycDetailsDto,
    incomeData: DraftFvciIncomeDetailsDto, // Changed from single to array
    leiDataArray: DraftFvciKycLeiDetailsDto[],
    addressesData: DraftFvciAddressDetailsDto[],
    investmentManagerDetails: DraftFvciInvestmentManagerDetailsDto,
    complianceOfficerDetails: DraftFvciComplianceOfficerDetailsDto,
    complianceOfficerEmail: DraftFvciComplianceOfficerEmailDto,
    registrationData: DraftFvicRegistrationDetailsDto,
    telephoneData: DraftFvciTelephoneNumberDetailsDto[],
    faxData: DraftFvciFaxNumberDetailsDto[],
    beneficialOwnershipByControl: DraftFvciBenificialOwnershipByControlDto,
    beneficialOwnerDetails: DraftFvciEkycBenificialOwnerDetailsDto[],
    kycDocumentDetails: DraftFvciKycDocumentDto[],
    contactDetails: DraftFvciEkycContactDetailsDto
  ): DraftFvciApplicationDto {
    return {
      applicationId,
      kycDetails: kycData,
      incomeDetails: incomeData, // No need for conditional here since we're passing an array directly
      kycLeiDetails: leiDataArray,
      addressDetails: addressesData,
      investmentManagerDetails: investmentManagerDetails,
      complianceOfficerDetails,
      complianceOfficerEmail,
      registrationDetails: registrationData,
      telephoneNumberDetails: telephoneData,
      faxNumberDetails: faxData,
      benificialOwnershipByControl: beneficialOwnershipByControl,
      ekycBenificialOwnerDetails: beneficialOwnerDetails,
      kycDocuments: kycDocumentDetails,
      contactDetails: contactDetails,
    };
  }

  getSteps() {
    return this.steps;
  }

  getFormData() {
    return this.formDataSubject.asObservable();
  }

  triggerSave() {
    this.saveTriggerSubject.next();
  }

  async saveData(applicationData: DraftFvciApplicationDto): Promise<any> {
    if (!applicationData?.applicationId) {
      throw new Error('Application data and applicationId are required');
    }

    try {
      const response = await firstValueFrom(
        this.fvciService.apiFvciapplicationSaveOrUpdateApplicationPost(
          applicationData
        )
      );
      return response;
    } catch (error) {
      console.error('Error saving application:', error);
      throw error;
    }
  }

  async createNewApplication(): Promise<string | null> {
    const blankDto: DraftFvciApplicationDto = {
      applicationId: '',
      registrationDetails: {
        ddpName: '',
        ddpRegistrationNumber: '',
        custodianName: '',
        custodianRegistrationNumber: '',
        dpName: '',
        dpRegistrationNumber: '',
        bankName: '',
        bankAddress: '',
        detailsOfPriorAssociation: '',
        panNumber: '',
      },
    };
    try {
      const response = await firstValueFrom(
        this.fvciService.apiFvciapplicationSaveOrUpdateApplicationPost(blankDto)
      );
      return response?.data?.applicationId || null;
    } catch (error) {
      console.error('Error creating new application:', error);
      return null;
    }
  }

  async fetchExistingApplication(applicationId: string) {
    try {
      return await firstValueFrom(
        this.fvciService.apiFvciapplicationGetFvciApplicationByIdAsyncGet(
          applicationId
        )
      );
    } catch (error) {
      console.error(
        `Error fetching application with ID ${applicationId}:`,
        error
      );
      throw new Error('Failed to fetch application. Please try again later.');
    }
  }

  uploadFile(formData: FormData): Observable<any> {
    const url = `${environment.BASE_PATH}/api/fvciapplication/UploadFileAsync`;
    const token = localStorage.getItem('token') ?? '';

    const headers = new HttpHeaders({
      Authorization: `Bearer ${token}`,
    });

    return this.http.post(url, formData, { headers });
  }

  viewFile(filePath: string): Observable<any> {
    return this.fvciService
      .apiFvciapplicationDownloadFileAsyncGet(filePath)
      .pipe(
        catchError((err: any) => {
          console.error('Error in viewFile service:', err);
          // Transform the error if needed and return an observable error.
          return throwError(
            () => new Error(err.message || 'Error fetching file')
          );
        })
      );
  }

  deleteFile(request: DeleteFileRequest) {
    return this.fvciService.apiFvciapplicationDeleteFileAsyncPost(request).pipe(
      catchError((err: any) => {
        console.error('Error in viewFile service:', err);
        // Transform the error if needed and return an observable error.
        return throwError(
          () => new Error(err.message || 'Error fetching file')
        );
      })
    );
  }

  submitApplication(applicationId: string): Observable<any> {
    if (!applicationId) {
      return throwError(
        () => new Error('Application ID is required for submission')
      );
    }

    // Currently using GET as specified in the requirements
    return this.fvciService
      .apiFvciapplicationSubmitApplicationAsyncGet(applicationId)
      .pipe(
        catchError((err: any) => {
          console.error('Error in submitApplication service:', err);
          return throwError(
            () => new Error(err.message || 'Error submitting application')
          );
        })
      );

    // When API changes to POST, update with something like this:
    /*
    const url = `${environment.BASE_PATH}/api/fvci/SubmitApplicationAsync`;
    const token = localStorage.getItem('token') ?? '';
    
    const headers = new HttpHeaders({
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json'
    });
    
    return this.http.post(url, { applicationId }, { headers }).pipe(
      catchError((err: any) => {
        console.error('Error in submitApplication service:', err);
        return throwError(
          () => new Error(err.message || 'Error submitting application')
        );
      })
    );
    */
  }

  private readonly submissionCompleteSubject = new BehaviorSubject<boolean>(
    false
  );
  submissionComplete$ = this.submissionCompleteSubject.asObservable();

  // Method to set submission status
  setSubmissionComplete(status: boolean) {
    this.submissionCompleteSubject.next(status);
  }

  // Method to check if submission is complete
  isSubmissionComplete() {
    return this.submissionCompleteSubject.value;
  }

  navigateToAcknowledgement() {
    // Set current step to the acknowledgement step (index 5, which is step 6)
    localStorage.setItem('currentStep', '5');
  }
}
