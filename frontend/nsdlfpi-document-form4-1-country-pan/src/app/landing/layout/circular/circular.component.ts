import { Component } from '@angular/core';
import { circularData } from '../../../dashboard/new-application/data';

interface Circular {
  date: string;
  name: string;
}

interface FileMappings {
  [key: number]: { path: string; fileType: string };
}

@Component({
  selector: 'app-circular',
  standalone: false,
  templateUrl: './circular.component.html',
  styleUrl: './circular.component.scss',
})
export class CircularComponent {
  tableData = circularData as Circular[];
  
  fileMapping: FileMappings = {
    0: { path: 'assets/pdf/Circulars_2015_0006.zip', fileType: 'zip' },
    1: { path: 'assets/pdf/Circulars_2015_0005.zip', fileType: 'zip' },
    2: { path: 'assets/pdf/Circulars_2015_0004.zip', fileType: 'zip' },
    3: { path: 'assets/pdf/Circulars_2015_0003.zip', fileType: 'zip' },
    4: { path: 'assets/pdf/Circulars_2015_0002.zip', fileType: 'zip' },
    5: { path: 'assets/pdf/Circulars_2014_0011.zip', fileType: 'zip' },
    6: { path: 'assets/pdf/Circulars_2014_0009.zip', fileType: 'zip' },
    7: { path: 'assets/pdf/Circulars_2014_0006_1.zip', fileType: 'zip' },
    8: { path: 'assets/pdf/Circulars_2014_0005.zip', fileType: 'zip' },
    9: { path: 'assets/pdf/Circulars_2004_0004.zip', fileType: 'zip' },
    10: { path: 'assets/pdf/Circulars_2014_0002.zip', fileType: 'zip' },
    11: { path: 'assets/pdf/Circulars_2014_0001.zip', fileType: 'zip' },
    12: { path: 'assets/pdf/Circulars_2014_0006.zip', fileType: 'zip' },
    13: { path: 'assets/pdf/Circulars_2014_0008.zip', fileType: 'zip' },
    14: { path: 'assets/pdf/2014-0005-Policy-DDP- Investments by FPIs in Non-Convertible _Redeemable....pdf', fileType: 'pdf' },
    15: { path: 'assets/pdf/2014-0005-Policy-DDP-SEBI Circular dated June 17 2014.pdf', fileType: 'pdf' }
  };

  /**
   * Downloads the file associated with the circular row
   * @param rowIndex The index of the row in the table
   */
  downloadFile(rowIndex: number): void {
    const fileInfo = this.fileMapping[rowIndex];
    
    if (fileInfo) {
      const link = document.createElement('a');
      link.href = fileInfo.path;
      link.download = fileInfo.path.split('/').pop() || `document.${fileInfo.fileType}`;
      
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    } else {
      console.warn('No file mapping found for row index:', rowIndex);
      alert('This document is currently unavailable. Please try again later.');
    }
  }
}