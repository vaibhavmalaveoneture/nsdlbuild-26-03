import { Component } from '@angular/core';
import { announcementData } from '../../../dashboard/new-application/data';

interface Announcement {
  date: string;
  name: string;
}

interface FileMappings {
  [key: string]: { path: string; fileType: string };
}

@Component({
  selector: 'app-announcements',
  standalone: false,
  templateUrl: './announcements.component.html',
  styleUrl: './announcements.component.scss',
})
export class AnnouncementsComponent {
  tableData = announcementData as Announcement[];
  
  fileMappings: FileMappings = {
    [this.tableData[0]?.name || '']: { 
      path: 'assets/pdf/Circulars_2014_0012.zip', 
      fileType: 'zip' 
    },
    [this.tableData[1]?.name || '']: { 
      path: 'assets/pdf/Circulars_2014_0010.zip', 
      fileType: 'zip' 
    },
    [this.tableData[2]?.name || '']: { 
      path: 'assets/pdf/Circulars_2014_0008_1.zip', 
      fileType: 'zip' 
    },
    [this.tableData[3]?.name || '']: { 
      path: 'assets/pdf/SEBI FAQs updated July 25, 2014.pdf', 
      fileType: 'pdf' 
    },
    [this.tableData[4]?.name || '']: { 
      path: 'assets/pdf/SEBI FAQs on Foreign Portfolio Investors.pdf', 
      fileType: 'pdf' 
    }
  };

  /**
   * Downloads the file associated with the announcement
   * @param announcement The announcement object
   * @param rowIndex The index of the row in the table
   */
  downloadFile(announcement: Announcement, rowIndex: number): void {
    const fileInfo = this.fileMappings[announcement.name];
    
    if (fileInfo) {
      this.downloadFileFromPath(fileInfo.path, fileInfo.fileType);
    } else {
      this.downloadFileByIndex(rowIndex);
    }
  }

  downloadFileByIndex(index: number): void {
    const files = [
      { path: 'assets/pdf/Circulars_2014_0012.zip', fileType: 'zip' },
      { path: 'assets/pdf/Circulars_2014_0010.zip', fileType: 'zip' },
      { path: 'assets/pdf/Circulars_2014_0008_1.zip', fileType: 'zip' },
      { path: 'assets/pdf/SEBI FAQs updated July 25, 2014.pdf', fileType: 'pdf' },
      { path: 'assets/pdf/SEBI FAQs on Foreign Portfolio Investors.pdf', fileType: 'pdf' }
    ];
    
    if (index >= 0 && index < files.length) {
      this.downloadFileFromPath(files[index].path, files[index].fileType);
    } else {
      console.warn('Invalid index:', index);
      alert('This document is currently unavailable. Please try again later.');
    }
  }

  /**
   * Helper method to download file from a path
   * @param path The path to the file
   * @param fileType The type of file (pdf or zip)
   */
  private downloadFileFromPath(path: string, fileType: string): void {
    const link = document.createElement('a');
    link.href = path;
    link.download = path.split('/').pop() || `document.${fileType}`;
    
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }
}