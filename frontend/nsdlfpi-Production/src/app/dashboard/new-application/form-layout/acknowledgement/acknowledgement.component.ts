import { Component, Input, SimpleChanges } from '@angular/core';
import { ConfirmationService, MenuItem, MessageService } from 'primeng/api';
import { PdfService } from '../../../../services/pdf-download.service';

@Component({
  selector: 'app-acknowledgement',
  standalone: false,
  templateUrl: './acknowledgement.component.html',
  styleUrl: './acknowledgement.component.scss',
})

export class AcknowledgementComponent {
  @Input() applicationId: string | undefined;
  @Input() applicationData!: any;
  download: string = '/assets/downloads.png';
  
  isDownloading: boolean = false;
  submittiontime: string = '';
  urnNumber: string = '';
  DDPName: string = '';


  constructor(
    
        private readonly pdfService: PdfService,
      private readonly messageService: MessageService
    ) {}

  ngOnChanges(changes: SimpleChanges): void {
      if(changes['applicationData'] && changes['applicationData'].currentValue){
         this.urnNumber =  this.applicationData?.data?.urnNo
         this.submittiontime =  this.applicationData?.data?.updatedAt
         this.urnNumber =  this.applicationData?.data?.urnNo
         this.DDPName = this.applicationData?.data?.registrationForm?.ddpName?.name
      }
      
    }
  async downloadFvciPdf(): Promise<void> {
    // this.downloadPdf();
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
      this.pdfService
        .generateAndDownload(this.applicationId)
        .subscribe((blob: Blob) => {
          const url = window.URL.createObjectURL(blob);
          const a = document.createElement('a');
          a.href = url;
          a.download = `form_${this.applicationId}.pdf`;
          a.click();
          window.URL.revokeObjectURL(url);
        });


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

  async downloadAnnexture(): Promise<void> {
    // this.downloadPdf();
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
      this.pdfService
        .generateAndDownloadAnnexture(this.applicationId)
        .subscribe((blob: Blob) => {
          const url = window.URL.createObjectURL(blob);
          const a = document.createElement('a');
          a.href = url;
          a.download = `annexture_${this.applicationId}.pdf`;
          a.click();
          window.URL.revokeObjectURL(url);
        });


      this.messageService.add({
        severity: 'success',
        summary: 'Success',
        detail: 'Annexture form downloaded successfully.',
      });
    } catch (error) {
      console.error('Error downloading PDF:', error);
      this.messageService.add({
        severity: 'error',
        summary: 'Error',
        detail: 'Failed to download the annexture form. Please try again.',
      });
    } finally {
      this.isDownloading = false;
    }
  }
}
