import { firstValueFrom } from 'rxjs';
import {
  DraftFvciApplicationDto,
  FvciApplicationService,
} from '../../../swagger';
import { Component, Input, OnInit } from '@angular/core';
import { UserSyncService } from '../../services/user-sync.service';
import { Router } from '@angular/router';
import { SaveApplicationService } from '../../services/save-application.service';
import { FormProgressService } from '../../services/form-progress.service';
import { progressMappingConfig } from '../../config/progress-mapping.config';
import { FormBuilder, FormGroup, FormControl, FormArray } from '@angular/forms';
import { contactData, data, detailsData, docData, tableData, taxData, City, Income, } from './data';

@Component({
  selector: 'app-new-application',
  templateUrl: './new-application.component.html',
  styleUrls: ['./new-application.component.scss'],
  standalone: false,
})
export class NewApplicationComponent implements OnInit {
  @Input() applicationId: string | undefined;
  @Input() viewMode: string | undefined;
  currentStep = 1;
  sidebarCollapsed = false;



  constructor(
    private readonly userSyncService: UserSyncService,
    private readonly fvciService: FvciApplicationService,
    private readonly router: Router,
    private readonly saveApplicationService: SaveApplicationService,
    private readonly progressService: FormProgressService,
    private fb: FormBuilder
  ) {
    
   }

  ngOnInit(): void {
    
  }

  

  onSidebarToggled(isToggled: boolean): void {
    this.sidebarCollapsed = isToggled;
    localStorage.setItem('sidebarCollapsed', String(isToggled));
  }

  async onButtonClick(): Promise<void> {
    await firstValueFrom(
      this.fvciService.apiFvciapplicationSaveOrUpdateApplicationPost()
    );
  }
}
