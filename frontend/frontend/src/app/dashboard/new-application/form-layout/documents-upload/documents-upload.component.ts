import { Component, EventEmitter, Input, OnInit, Output, SimpleChanges } from '@angular/core';
import { ConfirmationService, MessageService } from 'primeng/api';
import { firstValueFrom, Subscription } from 'rxjs';
import { SaveApplicationService } from '../../../../services/save-application.service';
import { FormProgressService } from '../../../../services/form-progress.service';
import {
  CommonService
} from '../../../../../swagger';
import { AbstractControl, FormArray, FormControl, FormGroup, Validators } from '@angular/forms';
import { PdfService } from '../../../../services/pdf-download.service';

interface FileData {
  name: string;
  doc: string;
  uploadedBy: string;
  uploadedDate: string;
}

interface AdditionalDocument {
  documentDescription: string;
  file?: File;
  status: number; // 0: pending, 1: uploaded
  documentPath?: string;
}

@Component({
  selector: 'app-documents-upload',
  standalone: false,
  templateUrl: './documents-upload.component.html',
  styleUrl: './documents-upload.component.scss',
})
export class DocumentsUploadComponent implements OnInit {
  @Input() applicationId: string | undefined;
  @Input() formGroup!: FormGroup;
  @Input() fvciForm!: FormGroup;
  @Input() masterData!: any;
  @Input() applicationData!: any;
  @Input() viewMode!: string | undefined;
  @Input() documents: { name: string; type: string; status: string; documentPath: string; fileName: string }[] = [];
  @Output() documentsUploaded = new EventEmitter<boolean>();
  
  showLoader: boolean = false;
  download: string = '/assets/downloads.png';
  representative: FileData[] = [];
  kycDocuments: any[] = [];
  files: FileData[] = [];
  POIdocumentIdentifier: string = 'Pending';
  POAdocumentIdentifier: string = 'Pending';
  FormdocumentIdentifier: string = 'Pending';
  AnnexturedocumentIdentifier: string = 'Pending';
  showFormUpload: number= 0;
  hideDeletButtonsPOAI: boolean = false;
  hideDeleteButtonsFA: boolean = false;
  hideAdditionalDocument: boolean = false;
  private saveSubscription!: Subscription;
  //   documents = [
  //   { name: 'Form Upload', type: 'formUpload', status: 'Pending', documentPath: '', fileName: '' },
  //   { name: 'Annexure Upload', type: 'annexureUpload', status: 'Pending', documentPath: '', fileName: '' }
  // ];
  

  getUploadControl(docType: string): FormControl {
    if(docType === 'POA'){
      return this.formGroup.get('poaUpload') as FormControl;
    }else if(docType === 'POI'){
      return this.formGroup.get('poiUpload') as FormControl;
    }else if(docType === 'formUpload'){
      return this.formGroup.get('formUpload') as FormControl;
    }else {
      return this.formGroup.get('annexureUpload') as FormControl;
    }
    
  }


  // Flags for enabling/disabling uploads
  isQuestion14Complete: boolean = false;
  disableMandatoryUploads: boolean = false;

  // Additional supporting documents array
  additionalDocuments: AdditionalDocument[] = [];
  proofOfIdentityOptions!: any[];
  proofOfAddressOptions!: any[];

  // Mapping for progress (mandatory documents: POA and POI)
  requiredMapping = {
    POA: ['documentPath'],
    POI: ['documentPath'],
  };

  // Fixed document upload variables
  selectedFixedFile: File | null = null;
  selectedFixedDocType = "";

  // Additional document upload variables
  selectedAdditionalFile: File | null = null;
  selectedAdditionalIndex: number | null = null;
  additionalDialogVisible: boolean = false;
  additionalUploadProgress: number = -1;

  constructor(
    private readonly messageService: MessageService,
    private readonly saveApplicationService: SaveApplicationService,
    private readonly progressService: FormProgressService,
    private readonly confirmationService: ConfirmationService,
    private readonly commonService: CommonService,
    private readonly pdfService: PdfService
  ) { }

  ngOnInit(): void {

    const proofOfIdentityControl = this.fvciForm?.get('proofOfIdentity');

    proofOfIdentityControl?.valueChanges.subscribe(value => {
      const matchedOption = this.proofOfIdentityOptions.find(opt => opt.code === value);
      if (!matchedOption) return;
    
      const updatedDoc = {
        documentType: "POI",
        documentIdentifier: matchedOption.name,
        documentPath: '',
        status: 0
      };
    
      // ✅ Replace if POI already exists
      const index = this.kycDocuments.findIndex(d => d.documentType === "POI");
      if (index !== -1) {
        this.kycDocuments[index] = updatedDoc;
      } else {
        this.kycDocuments.push(updatedDoc);
      }
    
      this.POIdocumentIdentifier = matchedOption.name;
    });

    const proofOfAddressControl = this.fvciForm?.get('proofOfAddress');

    proofOfAddressControl?.valueChanges.subscribe(value => {
      const matchedOption = this.proofOfAddressOptions.find(opt => opt.code === value);
      if (!matchedOption) return;
    
      const updatedDoc = {
        documentType: "POA",
        documentIdentifier: matchedOption.name,
        documentPath: '',
        status: 0
      };
    
      // ✅ Replace if POA already exists
      const index = this.kycDocuments.findIndex(d => d.documentType === "POA");
      if (index !== -1) {
        this.kycDocuments[index] = updatedDoc;
      } else {
        this.kycDocuments.push(updatedDoc);
      }
    
      this.POAdocumentIdentifier = matchedOption.name;
    });

  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['masterData'] && changes['masterData'].currentValue) {
      // Now you can work with masterData here
      this.initializeMasterData();
    }
    if (changes['applicationData'] && changes['applicationData'].currentValue) {
      // Now you can work with masterData here
      if(this.applicationData?.data?.status == 2 || this.applicationData?.data?.status == 10 || this.applicationData?.data?.status == 8){
        this.showFormUpload = this.applicationData?.data?.status
      }

      if(this.applicationData?.data?.status == 2  || this.applicationData?.data?.status == 10 || this.applicationData?.data?.status == 8){
        this.hideDeletButtonsPOAI = true
      }

      if(this.applicationData?.data?.status == 4){
        this.hideDeleteButtonsFA = true
      }


  //     hideDeletButtonsPOAI: boolean = false;
  // hideDeleteButtonsFA: boolean = false;
  // hideAdditionalDocument: boolean = false;
      
      this.initializeData();
    }
  }

  initializeData() {
    if (!this.applicationData?.data?.fvciKycDocument) {
      this.kycDocuments = [];
      return; // optionally early return, or skip mapping logic
    }

    if(this.applicationData?.data?.status == 2){

    }
  
    this.kycDocuments = this.applicationData.data.fvciKycDocument.map((doc: any) => {
      const documentType = doc.documentType;
      const documentPath = doc.documentPath || '';
  
      const documentIdentifier =
        this.proofOfAddressOptions?.find(opt => opt.code === doc.documentIdentifier)?.name ||
        this.proofOfIdentityOptions?.find(opt => opt.code === doc.documentIdentifier)?.name ||
        doc.documentIdentifier;
  
      const controlName =
        documentType === 'POA' ? 'poaUpload' :
        documentType === 'POI' ? 'poiUpload' :
        documentType === 'formUpload' ? 'formUpload' :
        documentType === 'annexureUpload' ? 'annexureUpload' : null;
  
      if (controlName) {
        const control = this.formGroup.get(controlName);
        if (control) {
          if (documentPath) {
            control.clearValidators();
          } else {
            control.setValidators([Validators.required]);
          }
          control.updateValueAndValidity();
        }
      }
  
      if (documentType === 'POA') {
        this.POAdocumentIdentifier = documentIdentifier;
      }
      if (documentType === 'POI') {
        this.POIdocumentIdentifier = documentIdentifier;
      }
  
      return {
        documentType,
        documentIdentifier,
        documentPath,
        status: doc.status ?? 1,
      };
    });
  
    // ✅ Safe check before filtering
    this.additionalDocuments = (this.kycDocuments || [])
      .filter(doc => doc.documentType?.toLowerCase() === 'additional')
      .map(doc => ({
        documentDescription: doc.documentIdentifier,
        documentPath: doc.documentPath,
        status: doc.status ?? 1
      }));
      this.emitIfAllRequiredDocsUploaded();

      // 
  
    if (this.viewMode == "true") {
      this.formGroup.disable();
    }
    
  }

  ngOnDestroy(): void {
    if (this.saveSubscription) {
      this.saveSubscription.unsubscribe();
    }
  }

  initializeMasterData(): void {

    if (Array.isArray(this.masterData.proof_of_identity)) {
      this.proofOfIdentityOptions = this.masterData.proof_of_identity;
    }
    if (Array.isArray(this.masterData.proof_of_address)) {
      this.proofOfAddressOptions = this.masterData.proof_of_address;
    }
  }

  async saveForm(): Promise<void> {
    try {
      // No actual save needed for document uploads since they're saved immediately on upload
      // We just need to show the success message when the save button is clicked

      // If there are pending files that haven't been uploaded yet, show a warning
      const pendingUploads = this.additionalDocuments.some(
        (doc) => doc.file && doc.status === 0
      );

      if (pendingUploads) {
        this.messageService.add({
          severity: 'warn',
          summary: 'Pending Uploads',
          detail:
            'There are documents selected but not yet uploaded. Please upload them before saving.',
        });
        return;
      }

      // Show success message
      this.messageService.add({
        severity: 'success',
        summary: 'Success',
        detail: 'Application saved successfully!',
      });
    } catch (error) {
      this.messageService.add({
        severity: 'error',
        summary: 'Error',
        detail: 'An unexpected error occurred while saving. Please try again.',
      });
    }
  }

  onFixedSelect(event: any, type: string): void {
    const file = event.files?.[0];
    if (file) {
      this.selectedFixedFile = file;
      this.selectedFixedDocType = type;

      // Set the file in the form control
      const control = this.getUploadControl(type);
      control.setValue(file);
      control.markAsTouched();
      control.updateValueAndValidity();
    }
  }


  onFixedClear(event: any, docType: string): void {
    const control = this.getUploadControl(docType);
    control.setValue('');
    control.markAsTouched();
  }

  async uploadFixedFile(identifier: string): Promise<void> {
    if (!this.selectedFixedFile) {
      console.error("No file selected for upload");
      return;
    }
    let controlName =""
    if(identifier=='POA'){
      controlName = this.POAdocumentIdentifier
    }else if(identifier=='POI'){
      controlName = this.POIdocumentIdentifier
    }else if(identifier=='annexureUpload'){
      controlName = 'annexureUpload'
    }else if(identifier=='formUpload'){
      controlName = 'formUpload'
    }
    // const controlName = identifier === 'POA' ? this.POAdocumentIdentifier : identifier === 'POI' ? this.POIdocumentIdentifier : '';
    // this.showLoader = true;
  
    const formData = new FormData();
    formData.append('file', this.selectedFixedFile);
    formData.append('docType', identifier);
    formData.append('documentIdentifier', controlName);
    formData.append('applicationId', this.applicationId ?? '');
  
    try {
      const response = await firstValueFrom(this.saveApplicationService.uploadFile(formData));
  
      if (response.success) {
        this.emitIfAllRequiredDocsUploaded();
        this.messageService.add({
          severity: 'success',
          summary: 'Success',
          detail: 'File uploaded successfully.',
        });
  
        const parsedData = JSON.parse(response.data);
  
        // ✅ Replace kycDocuments with latest data
        this.kycDocuments = parsedData.map((doc: any) => ({
          documentType: doc.DocumentType,
          documentIdentifier:
            this.proofOfAddressOptions.find(opt => opt.name === doc.DocumentIdentifier)?.name ||
            this.proofOfIdentityOptions.find(opt => opt.name === doc.DocumentIdentifier)?.name ||
            doc.DocumentIdentifier,
          documentPath: doc.DocumentPath || '',
          status: doc.Status ?? 0,
        }));
  
        // ✅ Update POA/POI identifier for display
        this.POAdocumentIdentifier =
          this.kycDocuments.find(d => d.documentType === 'POA')?.documentIdentifier || 'Pending';
          const poaDoc = this.kycDocuments.find(d => d.documentType === 'POA');
          if (poaDoc?.documentIdentifier) {
            this.POAdocumentIdentifier = poaDoc.documentIdentifier;
          }

          const poiDoc = this.kycDocuments.find(d => d.documentType === 'POI');
          if (poiDoc?.documentIdentifier) {
            this.POIdocumentIdentifier = poiDoc.documentIdentifier;
          }
      } else {
        this.messageService.add({
          severity: 'error',
          summary: 'Error',
          detail: 'Failed to upload file. Please try again.',
        });
      }
    } catch (error) {
      console.error("Upload failed:", error);
      this.messageService.add({
        severity: 'error',
        summary: 'Upload Error',
        detail: 'Something went wrong while uploading. Please try again.',
      });
    } finally {
      // this.showLoader = false;
    }
  }
  


  cancelFixedUpload(): void {
    this.clearFixedSelection();
  }

  clearFixedSelection(): void {
    this.selectedFixedFile = null;
    const fileUpload = document.querySelector('p-fileupload') as any;
    if (fileUpload?.clear) {
      fileUpload.clear();
    }
  }

 
  onAdditionalSelect(event: any, index: number): void {
    const selected = event.files[0];
    if (selected.type !== 'application/pdf') {
      this.messageService.add({
        severity: 'error',
        summary: 'Invalid File Type',
        detail: 'Only PDF files are allowed!',
      });
      const fileUpload = document.querySelector('p-fileupload') as any;
      if (fileUpload?.clear) {
        fileUpload.clear();
      }
      return;
    }
    // Store the file in the corresponding additional document row.
    this.additionalDocuments[index].file = selected;
  }

  // When the file selection is cleared.
  onAdditionalClear(event: any, index: number): void {
    if (this.additionalDocuments[index]) {
      this.additionalDocuments[index].file = undefined;
    }
  }

  // Upload the selected file for a specific additional document row.
  async uploadAdditionalDocument(index: number): Promise<void> {
    const doc = this.additionalDocuments[index];
  
    if (!doc?.file) {
      this.messageService.add({
        severity: 'error',
        summary: 'Upload Error',
        detail: 'No file selected for upload.',
      });
      return;
    }
  
    if (!doc.documentDescription || doc.documentDescription.trim() === '') {
      this.messageService.add({
        severity: 'error',
        summary: 'Missing Identifier',
        detail: 'Document identifier is required for additional documents.',
      });
      return;
    }
  
    // this.showLoader = true;
  
    const formData = new FormData();
    formData.append('file', doc.file);
    formData.append('docType', 'additional');
    formData.append('documentIdentifier', doc.documentDescription);
    formData.append('applicationId', this.applicationId ?? '');
  
    try {
      const response = await firstValueFrom(this.saveApplicationService.uploadFile(formData));
  
      if (response?.success) {
        this.messageService.add({
          severity: 'success',
          summary: 'Success',
          detail: 'File uploaded successfully.',
        });
  
        const parsedData = JSON.parse(response.data);
  
        // Find the newly uploaded document by identifier
        const uploadedDoc = parsedData.find(
          (d: any) =>
            d.DocumentType.toLowerCase() === 'additional' &&
            d.DocumentIdentifier === doc.documentDescription
        );
        
        if (uploadedDoc) {
          // Update only the local row
          this.additionalDocuments[index] = {
            documentDescription: uploadedDoc.DocumentIdentifier,
            documentPath: uploadedDoc.DocumentPath,
            status: uploadedDoc.Status ?? 1
          };
        }
  
      } else {
        this.messageService.add({
          severity: 'error',
          summary: 'Error',
          detail: 'Failed to upload file. Please try again.',
        });
      }
    } catch (error) {
      console.error('Upload failed:', error);
      this.messageService.add({
        severity: 'error',
        summary: 'Upload Error',
        detail: 'Something went wrong while uploading. Please try again.',
      });
    } finally {
      // this.showLoader = false;
    }
  }

  cancelAdditionalUpload(): void {
    this.additionalDialogVisible = false;
    this.clearAdditionalSelection();
  }

  clearAdditionalSelection(): void {
    this.selectedAdditionalFile = null;
    this.selectedAdditionalIndex = null;
    const fileUpload = document.querySelector('p-fileupload') as any;
    if (fileUpload?.clear) {
      fileUpload.clear();
    }
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

    // this.showLoader = true;

    try {
      // Ensure this call is using GET if the controller expects it.
      this.pdfService.downloadFile(filePath)
      .subscribe(blob => {
        const url = window.URL.createObjectURL(blob);
        window.open(url, '_blank'); // or use download logic if needed
      });
    } catch (error) {
      console.error('Error fetching attachment:', error);
      this.messageService.add({
        severity: 'error',
        summary: 'Error',
        detail: 'Unable to view the attachment. Please try again.',
        life: 3000,
      });
    } finally {
      // this.showLoader = false;
    }
  }


  onDeleteClick(event: Event, filePath: string): void {
    event.preventDefault();
    event.stopPropagation();
    this.deleteFixedDocument(filePath);
  }

  async deleteFixedDocument(filePath: string): Promise<void> {
    console.log("delet3 file path,", filePath);
    if(filePath==""){return}
    this.confirmationService.confirm({
      header: 'Confirm Deletion',
      message: `Are you sure you want to delete this document?`,
      icon: 'pi pi-exclamation-triangle',
      acceptIcon: 'pi pi-check me-2',
      rejectIcon: 'pi pi-times me-2',
      rejectButtonStyleClass: 'p-button-sm me-1',
      acceptButtonStyleClass: 'p-button-outlined p-button-sm me-1',
  
      accept: () => {
        // this.showLoader = true;
        // const body = {
        //   applicationId: this.applicationId!,
        //   filePath: filePath,
        // };
  
        try {
          this.handleDocumentDeletion(filePath);
        } catch (error: any) {
          this.messageService.add({
            severity: 'error',
            summary: 'Delete Failed',
            detail: error.error?.message || 'Failed to delete document.',
          });
        } finally {
          // this.showLoader = false;
          this.confirmationService.close();
        }
      },
  
      reject: () => {
        this.confirmationService.close();
        this.messageService.add({
          severity: 'info',
          summary: 'Deletion Cancelled',
          detail: 'Document deletion has been cancelled.',
        });
      },
    });
  }


  async handleDocumentDeletion(filePath: string): Promise<void> {
    // this.showLoader = true;
    const body = {
      applicationId: this.applicationId!,
      filePath: filePath,
    };
  
    try {
      const response: any = await firstValueFrom(
        this.saveApplicationService.deleteFile(body)
      );
  
      if (response?.success) {
        
        const docIndex = this.additionalDocuments.findIndex(d => d.documentPath === filePath);
        if (docIndex !== -1) {
          this.additionalDocuments.splice(docIndex, 1);
        }
  
        const doc = this.kycDocuments.find(d => d.documentPath === filePath);
        if (doc) {
          const docType = doc.documentType;
          // const identifier = docType === 'POA' ? this.POAdocumentIdentifier : docType === 'POI' ? this.POIdocumentIdentifier : null;
          let identifier =""
          if(docType=='POA'){
            identifier = this.POAdocumentIdentifier
          }else if(docType=='POI'){
            identifier = this.POIdocumentIdentifier
          }else if(docType=='annexureUpload'){
            identifier = 'annexureUpload'
          }else if(docType=='formUpload'){
            identifier = 'formUpload'
          }
          doc.documentPath = '';
          doc.status = 0;
          doc.documentIdentifier = identifier;
  
          let controlName = docType === 'POA' ? 'poaUpload' : docType === 'POI' ? 'poiUpload' : null;
          if(docType=='POA'){
            controlName = 'poaUpload'
          }else if(docType=='POI'){
            controlName = 'poiUpload'
          }else if(docType=='annexureUpload'){
            controlName = 'annexureUpload'
          }else if(docType=='formUpload'){
            controlName = 'formUpload'
          }
          if (controlName) {
            const control = this.formGroup.get(controlName);
            if (control) {
              control.setValidators([Validators.required]);
              control.updateValueAndValidity();
            }
          }
        }
        this.emitIfAllRequiredDocsUploaded();
  
        this.messageService.add({
          severity: 'success',
          summary: 'File Deleted',
          detail: response.message || 'Document has been deleted successfully',
        });
      } else {
        this.messageService.add({
          severity: 'error',
          summary: 'Delete Failed',
          detail: response?.message || 'Failed to delete document.',
        });
      }
    } catch (error: any) {
      this.messageService.add({
        severity: 'error',
        summary: 'Delete Failed',
        detail: error.error?.message || 'Failed to delete document.',
      });
    } finally {
      // this.showLoader = false;
    }
  }



  // ---------------------------
  // Other Methods
  // ---------------------------
  async fetchUserApplication(): Promise<void> {
    if (!this.applicationId) {
      return;
    }
    // this.showLoader = true;
    try {
      const response =
        await this.saveApplicationService.fetchExistingApplication(
          this.applicationId
        );
      if (response?.success && response.data) {
        const appData = response.data;
        if (appData.kycDocuments && Array.isArray(appData.kycDocuments)) {
          
          this.kycDocuments = appData.kycDocuments.map((doc: any) => ({
            documentType: doc.documentType,
            documentIdentifier: this.proofOfAddressOptions.find((cc) => cc.code === doc.documentIdentifier)?.name || doc.documentIdentifier, // Use the existing value if not found
            documentPath: doc.documentPath || '',
            status: doc.status ?? 0, // Use nullish coalescing to default status to 0
          }));
        } else {
          this.kycDocuments = [
            {
              documentType: 'POA',
              documentIdentifier: 'Registration Certificate',
              documentPath: '',
              status: 0,
            },
            {
              documentType: 'POI',
              documentIdentifier: 'Certificate of Incorporation/ Formation',
              documentPath: '',
              status: 0,
            },
          ];
        }

        // Create mandatory documents object for progress
        const mandatoryDocs: { [key: string]: any } = {};
        this.kycDocuments.forEach((doc) => {
          const type = doc.documentType.toUpperCase();
          if (type === 'POA' || type === 'POI') {
            mandatoryDocs[type] = doc;
          }
        });
        this.disableMandatoryUploads = !(
          mandatoryDocs['POA']?.documentType &&
          mandatoryDocs['POA'].documentIdentifier &&
          mandatoryDocs['POI']?.documentType &&
          mandatoryDocs['POI'].documentIdentifier
        );
        this.isQuestion14Complete = !this.disableMandatoryUploads;
        this.progressService.updateComponentProgress(
          'annexureForm',
          mandatoryDocs,
          this.requiredMapping
        );

        // Map additional documents: Filter those with documentType "additional" and map them to additionalDocuments array.
        this.additionalDocuments = this.kycDocuments
          .filter((doc) => doc.documentType.toLowerCase() === 'additional')
          .map((doc) => ({
            documentDescription: doc.documentIdentifier, // using identifier as description; adjust as needed
            status: doc.status,
            // Optionally, if you want to display the file path, you can add:
            // documentPath: doc.documentPath,
          }));
      }
    } catch (error) {
      console.error('Error fetching user application:', error);
    } finally {
      // this.showLoader = false;
    }
  }

  getKycDocument(docType: string): any {
    if (!this.kycDocuments || !Array.isArray(this.kycDocuments)) {
      return {
        documentIdentifier: 'Pending',
      };
    }
  
    return (
      this.kycDocuments.find((doc) => doc.documentType === docType) || {
        documentIdentifier: 'Pending',
      }
    );
  }

  // Additional Documents Methods
  addAdditionalDocument(): void {
    if (
      this.additionalDocuments.length === 0 ||
      this.additionalDocuments[this.additionalDocuments.length - 1].status === 1
    ) {
      this.additionalDocuments.push({ documentDescription: '', status: 0 });
    } else {
      this.messageService.add({
        severity: 'warn',
        summary: 'Incomplete Document',
        detail:
          'Please complete the upload for the current additional document before adding another.',
      });
    }
  }

  canAddAdditionalDocument(): boolean {
    if (this.additionalDocuments.length === 0) {
      return true;
    }
    return (
      this.additionalDocuments[this.additionalDocuments.length - 1].status === 1
    );
  }


  // documents = [
  //   { name: 'Form Upload', type: 'formUpload', status: 'Pending', documentPath: '', fileName: '' },
  //   { name: 'Annexure Upload', type: 'annexureUpload', status: 'Pending', documentPath: '', fileName: '' }
  // ];

  documentStatus = {
    formUpload: 'Pending',
    annexureUpload: 'Pending'
  };

  async onAdvancedUpload(event: any, type: 'formUpload' | 'annexureUpload') {
    const formData = new FormData();
    formData.append('file', event.files[0]);
    formData.append('docType', type);
    formData.append('documentIdentifier', type);
    formData.append('applicationId', this.applicationId ?? '');
  
    try {
      const response = await firstValueFrom(this.saveApplicationService.uploadFile(formData));
  
      if (response.success) {
        this.messageService.add({
          severity: 'success',
          summary: 'Success',
          detail: 'File uploaded successfully.',
        });
  
        const parsedData = JSON.parse(response.data);
        const docData = parsedData.find((d: any) => d.DocumentType === type);
  
        const document = this.documents.find(d => d.type === type);
        if (document) {
          document.status = 'Uploaded';
          document.documentPath = docData?.DocumentPath || '';
          document.fileName = event.files[0].name;
        }
      } else {
        this.messageService.add({
          severity: 'error',
          summary: 'Error',
          detail: 'Failed to upload file. Please try again.',
        });
      }
    } catch (error) {
      console.error("Upload failed:", error);
      this.messageService.add({
        severity: 'error',
        summary: 'Upload Error',
        detail: 'Something went wrong while uploading. Please try again.',
      });
    } finally {
      // this.showLoader = false;
    }
  }
  
  

  onViewFile(documentPath: string) {
    window.open(documentPath, '_blank');
  }
  
  // onDeleteFile(filePath: string) {
  //   this.confirmationService.confirm({
  //     header: 'Confirm Deletion',
  //     message: `Are you sure you want to delete this document?`,
  //     icon: 'pi pi-exclamation-triangle',
  //     acceptIcon: 'pi pi-check me-2',
  //     rejectIcon: 'pi pi-times me-2',
  //     rejectButtonStyleClass: 'p-button-sm me-1',
  //     acceptButtonStyleClass: 'p-button-outlined p-button-sm me-1',
  
  //     accept: async () => {
  //       this.showLoader = true;
  //       const body = {
  //         applicationId: this.applicationId!,
  //         filePath: filePath,
  //       };
  
  //       try {
  //         const response: any = await firstValueFrom(
  //           this.saveApplicationService.deleteFile(body)
  //         );
  
  //         if (response?.success) {
  //           const docIndex = this.additionalDocuments.findIndex(d => d.documentPath === filePath);
          
  //           if (docIndex !== -1) {
  //             this.additionalDocuments.splice(docIndex, 1); // ✅ remove row
  //           }
          
  //           // Also handle fixed docs (POA/POI)
  //           const doc = this.documents.find(d => d.documentPath === filePath);
  //           if (doc) {
  //             const docType = doc.type;
  //             // const identifier = docType === 'POA' ? this.POAdocumentIdentifier : docType === 'POI' ? this.POIdocumentIdentifier : null;
  //             doc.documentPath = '';
  //             doc.status = 'Pending';
  //             doc.type = doc.type;
  //           }
          
  //           this.messageService.add({
  //             severity: 'success',
  //             summary: 'File Deleted',
  //             detail: response.message || 'Document has been deleted successfully',
  //           });
  //         } else {
  //           this.messageService.add({
  //             severity: 'error',
  //             summary: 'Delete Failed',
  //             detail: response?.message || 'Failed to delete document.',
  //           });
  //         }
  //       } catch (error: any) {
  //         this.messageService.add({
  //           severity: 'error',
  //           summary: 'Delete Failed',
  //           detail: error.error?.message || 'Failed to delete document.',
  //         });
  //       } finally {
  //         this.showLoader = false;
  //       }
  //     },
  
  //     reject: () => {
  //       this.confirmationService.close();
  //       this.messageService.add({
  //         severity: 'info',
  //         summary: 'Deletion Cancelled',
  //         detail: 'Document deletion has been cancelled.',
  //       });
  //     },
  //   });
    
  // }

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

  private emitIfAllRequiredDocsUploaded(): void {
    const formDoc = this.kycDocuments.find(doc => doc.documentType === 'formUpload');
    const annexureDoc = this.kycDocuments.find(doc => doc.documentType === 'annexureUpload');
    console.log("this.kycDocumentsthis.kycDocuments", this.kycDocuments, formDoc, annexureDoc)
    if(formDoc == undefined || annexureDoc == undefined){
      console.log("into undefined")
      this.documentsUploaded.emit(false);
    }else{
      if(formDoc?.documentPath=="" || annexureDoc?.documentPath=="" || formDoc?.documentPath==null || annexureDoc?.documentPath==null){
        this.documentsUploaded.emit(false);
      }else{
        this.documentsUploaded.emit(true);
      }
    }
    
   
  }
}
