import { Component, Input, Output, EventEmitter, OnInit, input, output } from '@angular/core';
import { SaveApplicationService } from '../../../../services/save-application.service';
import { FormGroup } from '@angular/forms';
import {
  DraftFvciApplicationDto,
  FvciApplicationService,
  CommonService
} from '../../../../../swagger';
import { MessageService } from 'primeng/api';
import { HttpClient } from '@angular/common/http';
import { firstValueFrom } from 'rxjs';

import { FvciApplicationSaveService } from '../fvci-application-save.service';
import { Router } from '@angular/router';


import { DeclarationUndertakingFormService } from '../declaration-init.service'
import { FormInitService } from '../ekyc-init.service'
import { RegistartionInitService } from '../registration-init.service'
import { AnextureToCafService } from '../anexture-init.service'
import { DocUploadInitService } from '../doc-upload-init.service';

import { FormCompletionService } from '../progress-bar.service'

interface AdditionalDocument {
  documentDescription: string;
  documentPath?: string;
  status: number; // 0: pending, 1: uploaded
}

@Component({
  selector: 'app-display-preview',
  standalone: false,
  templateUrl: './display-preview.component.html',
  styleUrl: './display-preview.component.scss',
})
export class DisplayPreviewComponent implements OnInit {
  @Input() visible: boolean = false;
  @Input() applicationId: string | undefined;
  @Output() visibleChange = new EventEmitter<boolean>();
  @Input() fvciForm!: FormGroup;
  @Input() registartionForm!: FormGroup;
  @Input() formGroup!: FormGroup;
  @Input() anextureToCafForm!: FormGroup;
  @Input() documentUploadForm!: FormGroup;
  @Input() declarationAndUndertakimgForm!: FormGroup;
  @Output() submitClicked = new EventEmitter<void>();
  
  @Input() applicationData!: any;
  @Output() handleSaveSubmit = new EventEmitter<void>();
  @Output() setAckActive= new EventEmitter<void>();
  
  applicationData1!: any;
  isLoading: boolean = false;
  isSubmitting: boolean = false;
  previewMode: boolean = false;
  // Document related properties
  kycDocuments: any[] = [];
  additionalDocuments: AdditionalDocument[] = [];
  masterData: any[] = [];

  fvciForm1: FormGroup = new FormGroup({});
  registartionForm1: FormGroup = new FormGroup({});
  anextureToCafForm1: FormGroup = new FormGroup({});
  documentUploadForm1: FormGroup = new FormGroup({});
  declarationAndUndertakimgForm1: FormGroup = new FormGroup({});

  constructor(
    private readonly saveApplicationService: SaveApplicationService,
    private readonly fvciService: FvciApplicationService,
    private readonly messageService: MessageService,
    private readonly http: HttpClient,
    private readonly router: Router,
    private readonly commonService: CommonService,
    private formInitService: FormInitService,
    private registartionFormService: RegistartionInitService,
    private anextureFormService: AnextureToCafService,
    private declarationFormService: DeclarationUndertakingFormService,
    private fvciApplicationSaveService: FvciApplicationSaveService,
    private formCompletionService: FormCompletionService,
    private docUploadService: DocUploadInitService,
  ) {}

  ngOnInit() {
    // When initially rendered, don't fetch data

    this.fvciForm1 = this.formInitService.createFvciForm();

    this.registartionForm1 = this.registartionFormService.createRegistrationForm();

    this.anextureToCafForm1 = this.anextureFormService.createAnnextureForm();

    this.declarationAndUndertakimgForm1 = this.declarationFormService.createDeclrationAndUnderTaking();

    this.documentUploadForm1 = this.docUploadService.createDocUploadForm();
   
  }

  

  loadData(): void {
    // this.showLoader = true;
  
    this.commonService.apiCommonMastersGet().subscribe({
      next: (res: any) => {
        if (res?.success) {
          this.masterData = res.data;
        }
      },
      error: (error) => {
        console.error('Error fetching master data:', error);
      },
      complete: () => {
        // this.showLoader = false;
      }
    });
  }

  async submitApplication() {
    if (!this.applicationId) {
      this.messageService.add({
        severity: 'error',
        summary: 'Error',
        detail: 'Application ID is missing. Cannot submit application.',
      });
      return;
    }

    this.isSubmitting = true;
    this.submitClicked.emit();
    try {
      // const response = await firstValueFrom(
      //   this.fvciService.apiFvciapplicationSubmitApplicationAsyncGet(
      //     this.applicationId
      //   )
      // );

      // if (response?.success) {
      //   this.messageService.add({
      //     severity: 'success',
      //     summary: 'Success',
      //     detail: 'Application submitted successfully.',
      //   });
      //   this.saveApplicationService.setSubmissionComplete(true);
      //   // Set submission status to complete
      //   // this.saveApplicationService.setSubmissionComplete(true);
      //   // this.router.navigate(['/dashboard/new-application'], {
      //   //   queryParams: {
      //   //     applicationId: this.applicationId,
      //   //     viewMode: 'true',
      //   //   },
      //   // });

      //   // Close the preview dialog after successful submission
      //   setTimeout(() => {
      //     // this.setAckActive.emit()
      //     this.onHide();
      //     // Navigate to acknowledgement
      //     this.saveApplicationService.navigateToAcknowledgement();
      //   }, 1000);
      // } else {
      //   this.messageService.add({
      //     severity: 'error',
      //     summary: 'Error',
      //     detail:
      //       response?.message ||
      //       'Failed to submit application. Please try again.',
      //   });
      // }
    } catch (error) {
      console.error('Error submitting application:', error);
      this.messageService.add({
        severity: 'error',
        summary: 'Error',
        detail: 'An error occurred while submitting the application.',
      });
    } finally {
      this.isSubmitting = false;
    }
  }

  getKycDocument(docType: string): any {
    return (
      this.kycDocuments.find((doc) => doc.documentType === docType) || {
        documentIdentifier: 'Pending',
      }
    );
  }

  async viewDocument(filePath: string) {
    if (!filePath) {
      this.messageService.add({
        severity: 'error',
        summary: 'Attachment Not Found',
        detail: 'No attachment available to view.',
        life: 3000,
      });
      return;
    }

    this.isLoading = true;

    try {
      // Ensure this call is using GET if the controller expects it
      const response: any = await firstValueFrom(
        this.saveApplicationService.viewFile(filePath)
      );

      // Validate the response
      if (!response?.data?.base64Content) {
        throw new Error('No base64 content received.');
      }

      const { base64Content, contentType } = response.data;
      const byteCharacters = atob(base64Content);
      const byteNumbers = Array.from(byteCharacters, (char) =>
        char.charCodeAt(0)
      );
      const byteArray = new Uint8Array(byteNumbers);

      // Use provided content type, or fallback
      const mimeType = contentType || 'application/octet-stream';
      const blob = new Blob([byteArray], { type: mimeType });

      // Create an object URL for the Blob
      const url = window.URL.createObjectURL(blob);

      // Open the file in a new tab
      window.open(url, '_blank');

      // Revoke the Object URL after a sufficient delay (e.g., 5000ms)
      setTimeout(() => window.URL.revokeObjectURL(url), 5000);
    } catch (error) {
      console.error('Error fetching attachment:', error);
      this.messageService.add({
        severity: 'error',
        summary: 'Error',
        detail: 'Unable to view the attachment. Please try again.',
        life: 3000,
      });
    } finally {
      this.isLoading = false;
    }
  }

  onHide() {
    // this.previewMode = false
    this.visible = false;
    this.visibleChange.emit(this.visible);
  }

  // This will be called whenever the dialog becomes visible
  async onShow() {
    // this.previewMode = true    

    this.loadData();
    this.fetchApplicationData();
    setTimeout(() => {
      this.fetchApplicationData()
    }, 10000);
  }

  async fetchApplicationData(){
    const token = localStorage.getItem('token')?? '';
    const response = await firstValueFrom(
      this.fvciApplicationSaveService.getFvciApplicationById(this.applicationId??'', token)
    );
    this.applicationData1 = response;
  }

  
}
