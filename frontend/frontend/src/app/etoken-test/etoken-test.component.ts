import { Component, OnInit } from '@angular/core';
import { ETokenServiceService } from './etoken-service.service';
import { PdfService } from '../../swagger';

@Component({
  selector: 'app-etoken-test',
  standalone: false,
  templateUrl: './etoken-test.component.html',
  styleUrl: './etoken-test.component.scss'
})


export class EtokenTestComponent implements OnInit {
  certificates: string[] = [];

  constructor(private eTokenService: ETokenServiceService, private pdfService: PdfService) {}

  // downloadPdf() {
  //   this.pdfService.apiPdfGenerateCertificatePdfPost('body').subscribe(
  //     (response: Blob) => {
  //       const blob = new Blob([response], { type: 'application/pdf' });
  //       const url = window.URL.createObjectURL(blob);
        
  //       const a = document.createElement('a');
  //       a.href = url;
  //       a.download = 'Certificate.pdf'; // Change the file name as needed
  //       document.body.appendChild(a);
  //       a.click();
  //       document.body.removeChild(a);
  //     },
  //     (error) => {
  //       console.error('Download failed:', error);
  //     }
  //   );
  // }

  
  ngOnInit() {
    // this.certificates = this.eTokenService.getCertificates();
  }
}
