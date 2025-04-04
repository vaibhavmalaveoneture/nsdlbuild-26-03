import { Component, ViewChild } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { ConfirmationService, MenuItem, MessageService } from 'primeng/api';
import { Table } from 'primeng/table';
import { FPI } from '../new-application/data';
import { UserSyncService } from '../../services/user-sync.service';

import { firstValueFrom } from 'rxjs';
import { Router } from '@angular/router';
import { DatePipe } from '@angular/common';
import { SaveApplicationService } from '../../services/save-application.service';
import { FormProgressService } from '../../services/form-progress.service';
import { UsbTokenService } from '../../sharedservices/usb-token.service';
import {
  AuthService,
  CertificateUpdateRequest,
  DecryptRequestDto,
  FvciApplicationService,
} from '../../../swagger';
import { PdfService } from '../../services/pdf-download.service';

export interface FvciApplicationMaster {
  applicationId?: string;
  name?: string;
  fvciRegistrationNumber?: string;
  createdAt: string; // ISO date string, e.g., "2025-02-28T00:00:00Z"
  updatedAt: string; // ISO date string
  status?: number;
  isVerify?: string;
}

@Component({
  selector: 'app-application-list',
  standalone: false,
  templateUrl: './application-list.component.html',
  styleUrl: './application-list.component.scss',
})
export class ApplicationListComponent {
  @ViewChild('dt1') dt1!: Table;

  showLoader: boolean = false;
  sidebarCollapsed: boolean = false; // Add property for sidebar state
  showTooltip: boolean = false;
  tooltipTimeout: any;

  crumbItems: MenuItem[] | undefined;
  fpiList: FvciApplicationMaster[] = [];
  filteredFpiList: FvciApplicationMaster[] = [];
  isVerify: any;
  selectedFPI: FPI | undefined;
  first = 0;
  searchForm = new FormGroup({
    query: new FormControl(''),
    dateRange: new FormControl<Date[] | null>(null),
  });

  dscData: any;
  downloadItems!: MenuItem[];

  contactNumber: string = 'N/A';
  email: string = 'N/A';
  selectedCertificate: any;
  certificates: any;

  constructor(
    private readonly router: Router,
    private readonly confirmationService: ConfirmationService,
    private readonly messageService: MessageService,
    private readonly userSyncService: UserSyncService,
    private readonly saveApplicationService: SaveApplicationService,
    private readonly fvciApplicationService: FvciApplicationService,
    private readonly datePipe: DatePipe,
    private readonly progressService: FormProgressService,
    private readonly usbTokenService: UsbTokenService,
    private readonly authService: AuthService,
    private readonly pdfService: PdfService
  ) {}

  async ngOnInit() {
    await this.loadUserProfile();
    this.initializeBreadcrumbs();
    this.loadUserApplications();

    // Restore sidebar state from localStorage
    const savedState = localStorage.getItem('sidebarCollapsed');
    if (savedState !== null) {
      this.sidebarCollapsed = savedState === 'true';
    }

    this.downloadItems = [
      {
        label: 'CSV',
        icon: 'pi pi-file',
        command: () => {
          this.exportCSV();
        },
      },
      {
        label: 'XLSX',
        icon: 'pi pi-file-excel',
        command: () => {
          this.exportXLSX();
        },
      },
    ];
  }

  exportCSV() {
    // CSV header based on the table columns in your HTML template
    let csv =
      'S.No,Application ID,Registration No,FPI Name,Created At,Updated At,Status\n';
    this.filteredFpiList.forEach((fpi, index) => {
      const applicationId = fpi.applicationId;
      const registrationNo = fpi.fvciRegistrationNumber || 'N/A';
      const fpiName = fpi.name || 'N/A';
      const createdAt = fpi.createdAt
        ? this.formatDateForExport(new Date(fpi.createdAt))
        : 'N/A';
      const updatedAt = fpi.updatedAt
        ? this.formatDateForExport(new Date(fpi.updatedAt))
        : 'N/A';
      const status = fpi.status || 'Draft';

      // Build the CSV row, wrapping text values in quotes
      csv += `${
        index + 1
      },"${applicationId}","${registrationNo}","${fpiName}","${createdAt}","${updatedAt}","${status}"\n`;
    });

    // Create a blob and trigger the download
    const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = this.getExportFileName('csv');
    a.click();
    window.URL.revokeObjectURL(url);
  }

  exportXLSX() {
    // Start building an XML Spreadsheet (Excel 2003 XML) document
    let xml = `<?xml version="1.0"?>\n`;
    xml += `<?mso-application progid="Excel.Sheet"?>\n`;
    xml += `<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
          xmlns:o="urn:schemas-microsoft-com:office:office"
          xmlns:x="urn:schemas-microsoft-com:office:excel"
          xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
          xmlns:html="http://www.w3.org/TR/REC-html40">\n`;
    xml += `<Worksheet ss:Name="Sheet1">\n<Table>\n`;

    // Header row
    xml += `<Row>\n`;
    xml += `<Cell><Data ss:Type="String">S.No</Data></Cell>\n`;
    xml += `<Cell><Data ss:Type="String">Application ID</Data></Cell>\n`;
    xml += `<Cell><Data ss:Type="String">Registration No</Data></Cell>\n`;
    xml += `<Cell><Data ss:Type="String">FPI Name</Data></Cell>\n`;
    xml += `<Cell><Data ss:Type="String">Created At</Data></Cell>\n`;
    xml += `<Cell><Data ss:Type="String">Updated At</Data></Cell>\n`;
    xml += `<Cell><Data ss:Type="String">Status</Data></Cell>\n`;
    xml += `</Row>\n`;

    // Data rows
    this.filteredFpiList.forEach((fpi, index) => {
      const applicationId = fpi.applicationId;
      const registrationNo = fpi.fvciRegistrationNumber || 'N/A';
      const fpiName = fpi.name || 'N/A';
      const createdAt = fpi.createdAt
        ? this.formatDateForExport(new Date(fpi.createdAt))
        : 'N/A';
      const updatedAt = fpi.updatedAt
        ? this.formatDateForExport(new Date(fpi.updatedAt))
        : 'N/A';
      const status = fpi.status || 'Draft';

      xml += `<Row>\n`;
      xml += `<Cell><Data ss:Type="Number">${index + 1}</Data></Cell>\n`;
      xml += `<Cell><Data ss:Type="String">${this.escapeXml(
        applicationId!
      )}</Data></Cell>\n`;
      xml += `<Cell><Data ss:Type="String">${this.escapeXml(
        registrationNo
      )}</Data></Cell>\n`;
      xml += `<Cell><Data ss:Type="String">${this.escapeXml(
        fpiName
      )}</Data></Cell>\n`;
      xml += `<Cell><Data ss:Type="String">${this.escapeXml(
        createdAt
      )}</Data></Cell>\n`;
      xml += `<Cell><Data ss:Type="String">${this.escapeXml(
        updatedAt
      )}</Data></Cell>\n`;
      xml += `<Cell><Data ss:Type="String">${this.escapeXml(
        status.toString()
      )}</Data></Cell>\n`;
      xml += `</Row>\n`;
    });

    xml += `</Table>\n</Worksheet>\n</Workbook>`;

    // Create a blob and trigger the download
    const blob = new Blob([xml], { type: 'application/vnd.ms-excel' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = this.getExportFileName('xls');
    a.click();
    window.URL.revokeObjectURL(url);
  }

  private escapeXml(unsafe: string): string {
    // Simple XML escape function
    return unsafe.replace(/[<>&'"]/g, function (c) {
      switch (c) {
        case '<':
          return '&lt;';
        case '>':
          return '&gt;';
        case '&':
          return '&amp;';
        case "'":
          return '&apos;';
        case '"':
          return '&quot;';
        default:
          return c;
      }
    });
  }

  private formatDateForExport(date: Date): string {
    const dd = String(date.getDate()).padStart(2, '0');
    const MM = String(date.getMonth() + 1).padStart(2, '0');
    const yyyy = date.getFullYear();
    const hh = String(date.getHours()).padStart(2, '0');
    const mm = String(date.getMinutes()).padStart(2, '0');
    const ss = String(date.getSeconds()).padStart(2, '0');
    return `${dd}/${MM}/${yyyy} ${hh}:${mm}:${ss}`;
  }
  private getExportFileName(extension: string): string {
    const now = new Date();
    const yyyy = now.getFullYear();
    const MM = String(now.getMonth() + 1).padStart(2, '0');
    const dd = String(now.getDate()).padStart(2, '0');
    const hh = String(now.getHours()).padStart(2, '0');
    const mm = String(now.getMinutes()).padStart(2, '0');
    const ss = String(now.getSeconds()).padStart(2, '0');
    return `Application_List_${yyyy}${MM}${dd}_${hh}${mm}${ss}.${extension}`;
  }

  // Add method to handle sidebar toggle
  onSidebarToggled(isToggled: boolean) {
    this.sidebarCollapsed = isToggled;
  }

  async downloadcert(applicationid: string): Promise<void> {
    this.showLoader = true;

    try {
      // const response = await firstValueFrom(
      //   this.pdfService.apiPdfGenerateCertificatePdfPost(applicationid)
      // );

      // const blobUrl = URL.createObjectURL(response);
      // const a = document.createElement('a');
      // a.href = blobUrl;
      // a.download = `FVCI_Application_${applicationid}.pdf`;
      // document.body.appendChild(a);
      // a.click();
      // document.body.removeChild(a);
      // setTimeout(() => URL.revokeObjectURL(blobUrl), 100);

      this.pdfService.generateCertificatePdf(applicationid).subscribe((blob: Blob) => {
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `certificate_${applicationid}.pdf`;
        a.click();
        window.URL.revokeObjectURL(url);
      });

      this.messageService.add({
        severity: 'success',
        summary: 'Success',
        detail: 'Certificate downloaded successfully.',
      });
    } catch (error) {
      console.error('Error downloading PDF:', error);
      this.messageService.add({
        severity: 'error',
        summary: 'Error',
        detail: 'Failed to download the certificate. Please try again.',
      });
    } finally {
      this.showLoader = false;
    }
  }

  confirmNewApplication() {
    this.confirmationService.confirm({
      header: 'Create New Application',
      message: `
      <div style="line-height: 1.4;">
        <p>Creating a new application will start a fresh submission process. Once created, you can fill out the required details and track its status in your dashboard.</p>
        <p>Are you sure you want to continue?</p>
      </div>
    `,
      icon: 'pi pi-exclamation-triangle',
      acceptIcon: 'pi pi-check me-2',
      rejectIcon: 'pi pi-times me-2',
      rejectButtonStyleClass: '',
      acceptButtonStyleClass: '',
      accept: async () => {
        // Call the API to create a new application with a blank DTO
        const newApplicationId =
          await this.saveApplicationService.createNewApplication();
        if (newApplicationId) {
          this.progressService.resetProgress(); // Reset progress to 0
          // Navigate to the new application component with the generated applicationId
          this.router.navigate(['/dashboard/new-application'], {
            queryParams: { applicationId: newApplicationId },
          });
        } else {
          this.messageService.add({
            severity: 'error',
            summary: 'Error',
            detail: 'Failed to create a new application. Please try again.',
          });
        }
      },
      reject: () => {
        this.confirmationService.close();
        this.messageService.add({
          severity: 'info',
          summary: 'Action Cancelled',
          detail: 'Creation of the new application was cancelled.',
        });
      },
    });
  }

  cert_application_id: any;

  enableSocketConn(applicationid: string) {
    // Connect to the token service
    this.usbTokenService.connect();
    // Save the application ID for certificate update
    this.cert_application_id = applicationid;

    // Subscribe only once to the messages$ stream
    this.usbTokenService.messages$.subscribe((data) => {
      if (data) {
        this.dscData =
          'KNEJsRuD8XsMTgVJ+9umCkcITbOgQWeAXMIB01h+tkk3aoQLjG5wneX9l3/e9nkRl1h9AmQjbPzhkG4s2H9vOog/5KJAsqmyj9KpcxCLqJ9Rj3ml4blQaa4z5/DKn/mEBPsd4p36nfWK8AO+o30jbYDtHwdXrZ9zCMDambN5ZZfrHN3mo1tSRXArCCkC0TRcTQtcgTH1k2pg1mrxoZamtw6iBDbYLtYISwBYciLyL0lnVOfLk8kAXa47MOxGoUup9Kcb3ypr5PvsmfKlP2cfLW0NkSXKasRtWd2l1fHT7RTmef3u0KeCGksJ0qTlw2ZsPZpy2byjFRziAbEx7ftg04suJS96DcuoQEGMUrPxaL21A8Z0ixv3hoMaw+HfLw8wjhUCD+rusJLwGkvRSGqxcQ==';
        this.decryptToken();
      }
      // Note: Consider unsubscribing when the component is destroyed.
    });
  }

  decryptToken() {
    const payload: DecryptRequestDto = {
      encryptedToken: this.dscData,
    };

    this.authService.apiAuthDecryptTokenPost(payload).subscribe(
      (response) => {
        console.log('Decrypted Token:', response.decryptedToken);
        this.certificates = this.parseCertificates(response.decryptedToken);
        console.log(this.certificates);
        this.openPopup();
      },
      (error) => {
        console.error('Decryption failed:', error);
      }
    );
  }

  displayPopup = false;

  openPopup() {
    this.displayPopup = true;
  }

  downloadFile() {
    // If you're using a static file from assets
    const link = document.createElement('a');
    link.href = 'assets/sample.pdf'; // Update to your file path if needed
    link.download = 'sample.pdf'; // Set the downloaded filename
    link.click();
  }

  //   downloadFile1() {
  //     this.pdfService.apiPdfGenerateCertificatePdfPost().subscribe(
  //       (response: Blob) => {
  //         if (response) {
  //           const url = window.URL.createObjectURL(response);
  //           const a = document.createElement('a');
  //           a.href = url;
  //           a.download = 'Certificate.pdf'; // Set filename
  //           document.body.appendChild(a);
  //           a.click();
  //           document.body.removeChild(a);
  //           window.URL.revokeObjectURL(url); // Cleanup
  //         } else {
  //           console.error('Empty PDF response');
  //         }
  //       },
  //       (error) => {
  //         console.error('Download failed:', error);
  //       }
  //     );
  // }

  selectCertificate() {
    this.showLoader = true;
    console.log('Selected Certificate:', this.selectedCertificate);
    this.displayPopup = false;

    const payload: CertificateUpdateRequest = {
      application_id: Number(this.cert_application_id), // Ensure this is the correct application ID
      asm_id: 0, // Replace with actual ASM ID if available
      cert_serial_no: this.selectedCertificate.serialno,
      cert_thumbprint: '', // Fill if available
      cert_validdate: this.selectedCertificate.date,
      cert_subname: this.selectedCertificate.name,
    };

    this.fvciApplicationService
      .apiFvciapplicationATSUpdateCertificatePost(payload)
      .subscribe(
        (response) => {
          console.log('API Response:', response);
        },
        (error) => {
          console.error('API Error:', error);
        }
      );
    this.showLoader = false;
  }

  parseCertificates(certString: string) {
    const certificates = certString
      .split('|')
      .filter((cert) => cert.trim() !== '');
    console.log('Parsed Certificates:', certificates);
    return certificates.map((cert) => {
      const parts = cert.split('~');
      const nameMatch = parts[3]?.match(/CN=([^,]+)/);
      return {
        name: nameMatch ? nameMatch[1] : '',
        date: parts[2] || '',
        serialno: parts[0] || '',
      };
    });
  }

  sendMessage(inputValue: string): void {
    this.usbTokenService.sendMessage(inputValue);
  }

  onEdit(fpi: any): void {
    if (fpi?.applicationId) {
      const registrationNumber = fpi.fvciRegistrationNumber || 'Draft Pending';
      const fpiName = fpi.name || 'N/A';
      const formattedCreatedAt = fpi.createdAt
        ? this.datePipe.transform(fpi.createdAt, 'dd/MM/yyyy')
        : 'N/A';

      const confirmMessage = `
      <div style="line-height: 1.4;">
        <p style="margin-top: 1rem;">Do you want to proceed with <strong>editing</strong> this application?</p>
        <ul style="list-style-type: none; padding-left: 0; margin: 0;">
          <li><strong>FPI Name:</strong> ${fpiName}</li>
          <li><strong>Registration No:</strong> ${registrationNumber}</li>
          <li><strong>Created At:</strong> ${formattedCreatedAt}</li>
        </ul>
      </div>
    `;

      this.confirmationService.confirm({
        header: 'Confirm Edit Application',
        message: confirmMessage,
        icon: 'pi pi-exclamation-triangle',
        acceptLabel: 'Yes',
        rejectLabel: 'No',
        acceptIcon: 'pi pi-check',
        rejectIcon: 'pi pi-times',
        acceptButtonStyleClass: 'p-button-success p-button-sm me-2',
        rejectButtonStyleClass:
          'p-button-outlined p-button-sm p-button-secondary me-2',
        accept: () => {
          this.progressService.resetProgress();
          this.router.navigate(['/dashboard/new-application'], {
            queryParams: { applicationId: fpi.applicationId },
          });
        },
        reject: () => {
          this.confirmationService.close();
          this.messageService.add({
            severity: 'info',
            summary: 'Edit Cancelled',
            detail: 'You cancelled the edit action.',
          });
        },
      });
    }
  }

  onView(fpi: any): void {
    if (fpi?.applicationId) {
      const registrationNumber = fpi.fvciRegistrationNumber || 'NA';
      const fpiName = fpi.name || 'N/A';
      const formattedCreatedAt = fpi.createdAt
        ? this.datePipe.transform(fpi.createdAt, 'dd/MM/yyyy')
        : 'N/A';

      const confirmMessage = `
      <div style="line-height: 1.4;">
        <p style="margin-top: 1rem;">Do you want to view this application in read-only mode?</p>
        <ul style="list-style-type: none; padding-left: 0; margin: 0;">
          <li><strong>FPI Name:</strong> ${fpiName}</li>
          <li><strong>Registration No:</strong> ${registrationNumber}</li>
          <li><strong>Created At:</strong> ${formattedCreatedAt}</li>
        </ul>
      </div>
    `;

      this.confirmationService.confirm({
        header: 'View Application',
        message: confirmMessage,
        icon: 'pi pi-eye',
        acceptLabel: 'View',
        rejectLabel: 'Cancel',
        acceptIcon: 'pi pi-check',
        rejectIcon: 'pi pi-times',
        acceptButtonStyleClass: 'p-button-info p-button-sm me-2',
        rejectButtonStyleClass:
          'p-button-outlined p-button-sm p-button-secondary me-2',
        accept: () => {
          this.router.navigate(['/dashboard/new-application'], {
            queryParams: {
              applicationId: fpi.applicationId,
              viewMode: 'true',
            },
          });
        },
        reject: () => {
          this.confirmationService.close();
        },
      });
    }
  }

  private async loadUserProfile() {
    this.showLoader = true;
    try {
      const profile = await this.userSyncService.validateSessionAndGetProfile();
      const userData = profile?.data || {};
      this.contactNumber = userData.contact_no || 'N/A';
      this.email = userData.email_id || 'N/A';
    } catch (error) {
      console.error('Error fetching user info:', error);
    } finally {
      this.showLoader = false;
    }
  }

  private initializeBreadcrumbs() {
    this.crumbItems = [
      { label: 'FPI Monitor', route: '/new-application' },
      { label: 'List of FPI', route: '/application-list' },
    ];
  }

  private async loadUserApplications() {
    this.showLoader = true;
    try {
      const response = await firstValueFrom(
        this.fvciApplicationService.apiFvciapplicationGetApplicationListAsyncGet()
      );
      if (response?.success) {
        this.fpiList = this.filteredFpiList = response.data;
      }
    } catch (err: any) {
      console.error(err);
    } finally {
      this.showLoader = false;
    }
  }

  onSearch() {
    this.dt1.reset();
    const { dateRange, query } = this.searchForm.value;

    // Start with a copy of the complete list.
    this.filteredFpiList = [...this.fpiList];

    // Date range filtering using the createdAt property.
    if (dateRange && Array.isArray(dateRange) && dateRange[0] && dateRange[1]) {
      const startDate = new Date(dateRange[0]);
      const endDate = new Date(dateRange[1]);

      startDate.setHours(0, 0, 0, 0);
      endDate.setHours(23, 59, 59, 999);

      this.filteredFpiList = this.filteredFpiList.filter((fpi) => {
        const createdDate = new Date(fpi.createdAt);
        return createdDate >= startDate && createdDate <= endDate;
      });
    }

    // Text query filtering.
    if (query) {
      const searchQuery = query.toLowerCase();
      this.filteredFpiList = this.filteredFpiList.filter(
        (fpi) =>
          fpi.fvciRegistrationNumber?.toLowerCase().includes(searchQuery) ||
          fpi.name?.toLowerCase().includes(searchQuery) ||
          // Convert createdAt and updatedAt to a string in any format; here we simply use toString()
          fpi.createdAt.toString().toLowerCase().includes(searchQuery) ||
          fpi.updatedAt.toString().toLowerCase().includes(searchQuery) ||
          fpi.status?.toString().toLowerCase().includes(searchQuery)
      );
    }
  }

  onReset() {
    this.searchForm.reset({
      query: '',
      dateRange: null,
    });
    this.filteredFpiList = [...this.fpiList];
    this.dt1.reset();
  }

  onGlobalFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dt1.filterGlobal(filterValue, 'contains');
  }

  getSeverity(status: string): 'success' | 'info' | 'danger' | undefined {
    switch (status) {
      case 'approved':
        return 'success';
      case 'rejected':
        return 'danger';
      case 'Draft':
        return 'info';
      default:
        return undefined;
    }
  }

  isApplicationEditable(status: any): boolean {
    if (typeof status === 'number') {
      return status !== 2;
    }

    if (typeof status === 'string') {
      return status.toLowerCase() !== 'submitted';
    }

    return true;
  }

  formatDate(date: string): string {
    return new Date(date).toLocaleDateString('en-GB', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
    });
  }

  allowAlphaNumeric(event: KeyboardEvent) {
    const charCode = event.charCode;
    const isValid =
      (charCode >= 65 && charCode <= 90) || // A-Z
      (charCode >= 97 && charCode <= 122) || // a-z
      (charCode >= 48 && charCode <= 57) || // 0-9
      charCode === 32; // Space allowed

    if (!isValid) {
      event.preventDefault();

      // Show tooltip
      this.showTooltip = true;

      // Hide tooltip after 1.5 seconds
      clearTimeout(this.tooltipTimeout);
      this.tooltipTimeout = setTimeout(() => {
        this.showTooltip = false;
      }, 1500);
    }
  }

  // Optional: Remove any pasted special characters
  sanitizeInput(event: any) {
    const value = event.target.value;
    const sanitized = value.replace(/[^a-zA-Z0-9 ]/g, '');
    if (value !== sanitized) {
      event.target.value = sanitized;
      // this.yourForm.get('query')?.setValue(sanitized, { emitEvent: false });
    }
  }
}
