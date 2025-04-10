import { Component, Input, ViewChild, OnInit } from '@angular/core';
import { SaveApplicationService } from '../../../services/save-application.service';

export class FVCICommon {
     constructor(
        private readonly saveApplicationService: SaveApplicationService,
      ) {}

    public fetchUserApplication(applicationId: string | undefined): any {
        
        try {
        if (applicationId == '' || applicationId == undefined) return
          const response = this.saveApplicationService.fetchExistingApplication(
              applicationId?applicationId:'');
        return
        } finally {
          
        }
      }

}