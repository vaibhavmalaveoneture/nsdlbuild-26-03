import { Component, Input, ViewChild, OnInit } from '@angular/core';
import { SaveApplicationService } from '../../../services/save-application.service';

export class FVCICommon {
     constructor(
        private readonly saveApplicationService: SaveApplicationService,
        // private readonly fvciService: FvciApplicationService,
        // private readonly pdfService: PdfService,
        // private readonly messageService: MessageService,
        // private readonly http: HttpClient,
        // private readonly fb: FormBuilder,
        // private readonly router: Router
      ) {}

    public fetchUserApplication(applicationId: string | undefined): any {
        
        try {
        if (applicationId == '' || applicationId == undefined) return
          const response = this.saveApplicationService.fetchExistingApplication(
              applicationId?applicationId:'');
            console.log("-------------------------",response)
        //   if (response?.success && response.data) {
        //     const appData = response.data;
            
        //   }else{
            
        //   }
        return
        } finally {
          
        }
      }

}