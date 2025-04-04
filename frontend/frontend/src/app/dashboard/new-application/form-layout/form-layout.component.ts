import {
  Component,
  Input,
  ViewChild,
  OnInit,
  AfterViewInit,
  viewChild,
} from '@angular/core';
import { SaveApplicationService } from '../../../services/save-application.service';
import { firstValueFrom } from 'rxjs';
import {
  DraftFvciBenificialOwnershipByControlBoDetailsDto,
  DraftFvciDeclarationUndertakingDetailsDto,
  DraftFvciGlobalCustodianDetailsDto,
  DraftFvciIncidentsOfLawViolationDto,
  DraftFvciIndianMarketAssociansDto,
  DraftFvciInfoBasicOfOwnershipBoDetailsDto,
  DraftFvciInformationOfSaSmFvciApplicantDto,
  DraftFvciIsBankDto,
  DraftFvciKraPermissionDto,
  DraftFvciOwnershipDetailsDto,
  DraftFvciRegulatoryAuthorityDetailsDto,
  DraftFvciSubClassBenificialOwnerDetailsDto,
  DraftFvciSubClassDetailsDto,
  FvciApplicationService,
  // PdfService,
  CommonService
} from '../../../../swagger';
import { MessageService } from 'primeng/api';
import { HttpClient } from '@angular/common/http';

import { FvciFormComponent } from './fvci-form/fvci-form.component';
import { MenuComponent } from './menu/menu.component';
import { RegistrationFormComponent } from './registration-form/registration-form.component';
import { AnnexureFormComponent } from './annexure-form/annexure-form.component';
import { DeclarationUndertakingComponent } from './declaration-undertaking/declaration-undertaking.component';
import { DocumentsUploadComponent } from './documents-upload/documents-upload.component'
import { DeclarationUndertakingFormService } from './declaration-init.service'
import { FormCompletionService } from './progress-bar.service'

import { PdfService } from '../../../services/pdf-download.service';

import {
  FormBuilder,
  FormGroup,
  Validators
} from '@angular/forms';
import { docData } from '../data';
import { Router } from '@angular/router';
import { FormInitService } from './ekyc-init.service'
import { RegistartionInitService } from './registration-init.service'
import { AnextureToCafService } from './anexture-init.service'
import { DocUploadInitService } from './doc-upload-init.service';
import { FvciApplicationSaveService } from './fvci-application-save.service';


@Component({
  selector: 'app-form-layout',
  standalone: false,
  templateUrl: './form-layout.component.html',
  styleUrl: './form-layout.component.scss',
})
export class FormLayoutComponent implements OnInit, AfterViewInit {
  @Input() applicationId: string | undefined;
  @Input() currentStep: number = 1;
  @ViewChild(MenuComponent) appMenu!: MenuComponent;
  @ViewChild(FvciFormComponent)
  fvciComponent!: FvciFormComponent;
  @ViewChild(RegistrationFormComponent)
  registrationFormComponent!: RegistrationFormComponent;
  @ViewChild(AnnexureFormComponent)
  anextureToCaf!: AnnexureFormComponent;
  @ViewChild(DeclarationUndertakingComponent)
  declarationUndertakingComponent!: DeclarationUndertakingComponent;
  @ViewChild(DocumentsUploadComponent)
  documentsUploadComponent!: DocumentsUploadComponent;


  fvciForm: FormGroup = new FormGroup({});
  registartionForm: FormGroup = new FormGroup({});
  anextureToCafForm: FormGroup = new FormGroup({});
  documentUploadForm: FormGroup = new FormGroup({});
  declarationAndUndertakimgForm: FormGroup = new FormGroup({});
  masterData!: any[];
  applicationData!: any[];

  showLoader = false;
  formCompletionPercentage = 0;
  docData = docData;
  currentComponent!: string;
  download = '/assets/downloads.png';
  isDownloading: boolean = false;
  // formInitService: any;
  // formCompletionService: any;

  constructor(
    private readonly saveApplicationService: SaveApplicationService,
    private readonly fvciService: FvciApplicationService,
    private formInitService: FormInitService,
    private registartionFormService: RegistartionInitService,
    private anextureFormService: AnextureToCafService,
    private declarationFormService: DeclarationUndertakingFormService,
    private fvciApplicationSaveService: FvciApplicationSaveService,
    private formCompletionService: FormCompletionService,
    private docUploadService: DocUploadInitService,
    private readonly commonService: CommonService,
    private readonly messageService: MessageService,
    private readonly pdfService: PdfService
  ) {}

  ngOnInit() {
    this.fetchApplicationData();
    console.log("responsellllllll form layout ", this.applicationData)
    this.loadData();
    this.initializeComponent();
   
    // console.log("responsellllllll", response.data)

    this.fvciForm = this.formInitService.createFvciForm();

    this.registartionForm = this.registartionFormService.createRegistrationForm();

    this.anextureToCafForm = this.anextureFormService.createAnnextureForm();

    this.declarationAndUndertakimgForm = this.declarationFormService.createDeclrationAndUnderTaking();

    this.documentUploadForm = this.docUploadService.createDocUploadForm();

    // Call subscribeToFormChanges as usual
    this.subscribeToFormChanges();
  }

  updateCurrentStep(step: number): void {
    // this.handleSaveClick()
    this.currentStep = step;
    this.saveApplicationService.getSteps().forEach((step) => {
      if (step.step === this.currentStep) {
        this.currentComponent = step.name;
      }
    });
    // this.fvciComponent.fetchUserApplication();
  }

  ngAfterViewInit(): void {
    // this.fvciComponent.fetchUserApplication();
    // this.registrationFormComponent.fetchUserApplication();
    // this.anextureToCaf.fetchUserApplication();
    // this.declarationUndertakingComponent.fetchDeclarationDetails();
    // this.documentsUploadComponent.fetchUserApplication();
    // // }
    // // if (this.registrationFormComponent && this.applicationId) {
    // // this.fvciComponent.fetchUserApplication();
    // // this.registrationFormComponent.fetchUserApplication();
    // // }
  }

  initializeComponent() {
    this.saveApplicationService.getSteps().forEach((step) => {
      if (step.step === this.currentStep) {
        this.currentComponent = step.name;
      }
    });
  }

  async onButtonClick(): Promise<void> {
    const response = await firstValueFrom(
      this.fvciService.apiFvciapplicationSaveOrUpdateApplicationPost()
    );
    if(response.success){
      this.messageService.add({
        severity: 'success',
        summary: 'Success',
        detail: 'Application saved successfully.',
      });
    }else{
      this.messageService.add({
        severity: 'error',
        summary: 'Error',
        detail: 'Failed to save application. Please try again.',
      });
    }
  }

  async fetchApplicationData(){
    const token = localStorage.getItem('token')?? '';
    const response = await firstValueFrom(
      this.fvciApplicationSaveService.getFvciApplicationById(this.applicationId??'', token)
    );
    this.applicationData = response;
  }





  handleSubmit() {
    this.fvciForm.markAllAsTouched();
    this.registartionForm.markAllAsTouched();
    this.anextureToCafForm.markAllAsTouched();
    this.documentUploadForm.markAllAsTouched();
    this.declarationAndUndertakimgForm.markAllAsTouched();

    const fvciValid = this.fvciForm.valid;
    const registrationValid = this.registartionForm.valid;
    const atcValid = this.anextureToCafForm.valid;
    const duValid = this.documentUploadForm.valid;
    const dauValid = this.declarationAndUndertakimgForm.valid;
    
    if (!fvciValid) {
      console.log("into fvciValid valid")
      this.triggerSetActive(0);
    } else if (!registrationValid) {
      console.log("into registrationValid valid")
      this.triggerSetActive(1);
    }else if(!atcValid){
      console.log("into annexture valid")
      this.triggerSetActive(2);
    } else if (!duValid) {
      console.log("into document upload valid")
      this.triggerSetActive(3);
    } else if (!dauValid) {
      console.log("into declaration and undertaking valid")
      this.triggerSetActive(4);
    } else {
      this.appMenu.openPreview();
    }
  }

  triggerSetActive(index: number) {
    if (this.appMenu) {
      this.appMenu.setActive(index);
    }
  }

  subscribeToFormChanges() {
    const applicantOtherNameGroup = this.fvciForm.get(
      'applicantOtherName'
    ) as FormGroup;

    // Subscribe to changes of 'otherNameRadio'
    applicantOtherNameGroup
      .get('otherNameRadio')
      ?.valueChanges.subscribe((value) => {
        const otherNameFieldControl =
          applicantOtherNameGroup.get('otherNameField');
        if (value === true) {
          otherNameFieldControl?.setValidators([
            Validators.required,
            Validators.maxLength(75)
          ]);
        } else {
          otherNameFieldControl?.clearValidators();
          otherNameFieldControl?.setValue(''); // Clear the value if No selected
        }
        otherNameFieldControl?.updateValueAndValidity();
      });

      this.handleZipToggle(
        'registeredOffice.notApplicableResidence',
        'registeredOffice.registeredZipName'
      );
      this.handleZipToggle(
        'foreignOffice.notApplicableForeignOffice',
        'foreignOffice.foreignZipName'
      );
      this.handleZipToggle(
        'OfficeInIndia.notApplicableIndOffice',
        'OfficeInIndia.indianZipName'
      );
    


    this.fvciForm.valueChanges.subscribe(() => {
      this.formCompletionPercentage = this.formCompletionService.updateFormCompletion(this.fvciForm, this.registartionForm, this.anextureToCafForm, this.documentUploadForm, this.declarationAndUndertakimgForm);
    });

    this.registartionForm.valueChanges.subscribe(() => {
      this.formCompletionPercentage = this.formCompletionService.updateFormCompletion(this.fvciForm, this.registartionForm, this.anextureToCafForm, this.documentUploadForm, this.declarationAndUndertakimgForm);
    });

    this.anextureToCafForm.valueChanges.subscribe(() => {
      this.formCompletionPercentage = this.formCompletionService.updateFormCompletion(this.fvciForm, this.registartionForm, this.anextureToCafForm, this.documentUploadForm, this.declarationAndUndertakimgForm);
    });

    this.documentUploadForm.valueChanges.subscribe(() => {
      this.formCompletionPercentage = this.formCompletionService.updateFormCompletion(this.fvciForm, this.registartionForm, this.anextureToCafForm, this.documentUploadForm, this.declarationAndUndertakimgForm);
    });

    this.declarationAndUndertakimgForm.valueChanges.subscribe(() => {
      console.log("complent asdasdadasdasdasdasdasdassdassdasdasd")
      this.formCompletionPercentage = this.formCompletionService.updateFormCompletion(this.fvciForm, this.registartionForm, this.anextureToCafForm, this.documentUploadForm, this.declarationAndUndertakimgForm);
    });

    // Initial update
    this.formCompletionPercentage = this.formCompletionService.updateFormCompletion(this.fvciForm, this.registartionForm, this.anextureToCafForm, this.documentUploadForm, this.declarationAndUndertakimgForm);
  }



  private handleZipToggle(controlPath: string, zipControlPath: string): void {
    this.fvciForm
      .get(controlPath)
      ?.valueChanges.subscribe((isNotApplicable: boolean) => {
        const zipControl = this.fvciForm.get(zipControlPath);
        if (isNotApplicable) {
          zipControl?.clearValidators();
          zipControl?.disable();
          zipControl?.setValue('N/A');
        } else {
          zipControl?.setValidators(Validators.required);
          zipControl?.setValue('');
          zipControl?.enable();
        }
        zipControl?.updateValueAndValidity();
      });
  }


  async handleSaveClick() {
    console.log("clicked on save");
    this.showLoader = true;
    
    const ekycForm = this.fvciForm.getRawValue();
    const registrationForm = this.registartionForm.getRawValue();
    const declarationAndUndertakingForm = this.declarationAndUndertakimgForm.getRawValue();
    const anextureForm = this.anextureToCafForm.getRawValue();
    const documentUploadForm = this.documentUploadForm.getRawValue();
    
    const finalPayload = {
      ekycForm,
      registrationForm,
      declarationAndUndertakingForm,
      anextureForm,
      documentUploadForm,
      applicationId: this.applicationId
    };
    
    console.log("Saving application data:", finalPayload);
    
    try {
      const token = localStorage.getItem('token');
      
      if (!token) {
        console.error('No token found in localStorage');
        return;
      }
      
      const response = await firstValueFrom(
        this.fvciApplicationSaveService.saveOrUpdateApplication(finalPayload, token)
      );
      
      console.log('Application data saved successfully:', response);
      
      if (response && response.applicationId && !this.applicationId) {
        this.applicationId = response.applicationId;
      }

      if(response.success){
      this.messageService.add({
        severity: 'success',
        summary: 'Success',
        detail: 'Application saved successfully.',
      });
    }else{
      this.messageService.add({
        severity: 'error',
        summary: 'Error',
        detail: 'Failed to save application. Please try again.',
      });
    }
    } catch (error) {
      console.error('Error saving application data:', error);
    } finally {
      this.showLoader = false;
    }
  }

  onBankSelected(event: any): void {
    const selectedBank = event.value;
    const bankGroup = this.registartionForm.get('designatedBank') as FormGroup;
    bankGroup
      .get('designatedBankAddress')
      ?.patchValue(selectedBank?.address || '');
  }

  loadData(): void {
    this.showLoader = true;
  
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
        this.showLoader = false;
      }
    });
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
      console.log("this.applicationId------download", this.applicationId)
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
}
