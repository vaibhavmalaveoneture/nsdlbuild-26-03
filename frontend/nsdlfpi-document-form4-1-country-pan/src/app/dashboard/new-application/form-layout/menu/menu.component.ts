import {
  Component,
  EventEmitter,
  Input,
  Output,
  OnInit,
  ViewChild,
} from '@angular/core';
import { ConfirmationService, MenuItem, MessageService } from 'primeng/api';
import { SaveApplicationService } from '../../../../services/save-application.service';
import { FormProgressService } from '../../../../services/form-progress.service';
import { firstValueFrom } from 'rxjs';
import { ActivatedRoute } from '@angular/router';
import { FvciFormComponent } from '../fvci-form/fvci-form.component';
import { FormControl, FormGroup } from '@angular/forms';
import { UserSyncService } from '../../../../services/user-sync.service';
import { FormValidationService } from '../../../../services/form-validation.service';
import {
  AdminService,
  ApproveRejectRequest,
  FvciApplicationService,
} from '../../../../../swagger';

interface ATSData {
  amT_SIGN_NAME: string;
  amT_SIGN_DSGN: string;
  amT_ASM_ID: number;
}

interface Options {
  name: string;
  step: number;
}

interface ButtonOption {
  label: string;
}

@Component({
  selector: 'app-menu',
  standalone: false,
  templateUrl: './menu.component.html',
  styleUrls: ['./menu.component.scss'],
})
export class MenuComponent implements OnInit {
  @Output() stepChanged = new EventEmitter<number>();
  @Output() onButtonClick = new EventEmitter<number>();
  @Output() submitClicked = new EventEmitter<void>();
  @Output() saveClicked = new EventEmitter<void>();
  @Input() applicationId: string | undefined;
  @Input() completionPercentageNew: number = 0;
  @Input() fvciForm!: FormGroup;
  @Input() registartionForm!: FormGroup;
  // Consider removing this if not used:
  @Input() formGroup!: FormGroup;
  @Input() anextureToCafForm!: FormGroup;
  @Input() documentUploadForm!: FormGroup;
  @Input() declarationAndUndertakimgForm!: FormGroup;

  @ViewChild(FvciFormComponent) fvciComponent!: FvciFormComponent;
  isViewMode: boolean = false;

  displayPreview: boolean = false;
  completionPercentage: number = 0;
  crumbItems: MenuItem[] | undefined;

  steps: Options[] = [
    { name: 'EKYC', step: 1 },
    { name: 'FVCI Registration', step: 2 },
    { name: 'Annexture to CAF', step: 3 },
    { name: 'Document Upload', step: 4 },
    { name: 'Declaration and Undertaking', step: 5 },
    { name: 'Acknowledgement', step: 6 },
  ];

  selectItems: Options[] = [];
  selectedItem: Options | undefined;

  isSaving: boolean = false;
  saveSuccess: boolean = false;

  buttons: ButtonOption[] = [];
  visibleButtons: ButtonOption[] = [];

  active: number = 0;
  currentStep: number = 1;
  totalSteps: number = 5; // Default to 5 steps, will update based on submission status

  approveDialogVisible: boolean = false;
  rejectDialogVisible: boolean = false;
  approvalComment: string = '';
  rejectionComment: string = '';

  // User permissions
  userPermissions: string[] = [];

  // Reactive form for approval dialog
  menuForm = new FormGroup({
    selectedCities: new FormControl<ATSData[]>([]),
    SignReqd: new FormControl<number | null>(null),
    atsUser: new FormControl<any[]>([]),
    approvalComment: new FormControl(''),
  });

  constructor(
    private readonly saveApplicationService: SaveApplicationService,
    private readonly progressService: FormProgressService,
    private readonly messageService: MessageService,
    private readonly confirmationService: ConfirmationService,
    private readonly fvciService: FvciApplicationService,
    private readonly userSyncService: UserSyncService,
    private readonly adminService: AdminService,
    private readonly validationService: FormValidationService,
    private readonly route: ActivatedRoute
  ) {}

  ngOnInit() {
    this.route.queryParams.subscribe((params) => {
      this.isViewMode = params['viewMode'] === 'true';
    });
    this.subscribeATS();

    this.isSaving = true;
    this.crumbItems = [
      { label: 'FPI Monitor' },
      { label: 'New Application' },
      { label: 'EKYC', route: '/new-application' },
    ];

    // Initialize buttons array
    this.buttons = Array.from({ length: this.steps.length }, (_, index) => ({
      label: `${index + 1}`,
    }));

    // Initialize visible buttons and select items based on submission status
    this.updateVisibleButtons();
    this.updateSelectItems();
    this.selectedItem = this.selectItems[0];

    try {
      // Optionally restore current step from localStorage
      // const previousStep = localStorage.getItem('currentStep');
      // if (previousStep && !isNaN(parseInt(previousStep))) {
      //   const stepIndex = parseInt(previousStep);
      //   if (this.isStepAccessible(stepIndex)) {
      //     this.setActive(stepIndex);
      //   } else {
      //     this.setActive(0);
      //   }
      // }
    } catch (err: any) {
      console.error('Error restoring step from localStorage:', err);
      this.setActive(0);
    } finally {
      this.isSaving = false;
    }

    this.progressService.progress$.subscribe((value) => {
      this.completionPercentage = value;
    });

    // Subscribe to submission status changes
    this.saveApplicationService.submissionComplete$.subscribe((complete) => {
      this.updateVisibleButtons();
      this.updateSelectItems();
      this.updateTotalSteps();
      if (complete) {
        this.setActive(5); // Navigate to acknowledgement step
      }
    });

    // Load user permissions
    this.loadUserPermissions();
  }

  async loadUserPermissions() {
    try {
      this.userPermissions = await this.userSyncService.getUserPermissions();
    } catch (error) {
      console.error('Error loading user permissions:', error);
    }
  }

  hasPermission(permission: string): boolean {
    return this.userPermissions?.includes(permission.toLowerCase());
  }

  isViewOnlyUser(): boolean {
    const actionPermissions = [
      'approve_applications_maker',
      'reject_applications_maker',
      'submit_application',
      'save_application',
    ];
    const hasActionPermission = actionPermissions.some((permission) =>
      this.hasPermission(permission)
    );
    const hasViewPermissions =
      this.hasPermission('view_users') ||
      this.hasPermission('view_applications');
    return hasViewPermissions && !hasActionPermission;
  }

  isStepAccessible(index: number): boolean {
    if (index === 5) {
      return this.saveApplicationService.isSubmissionComplete();
    }
    return index >= 0 && index < 5;
  }

  updateVisibleButtons() {
    const isSubmitted = this.saveApplicationService.isSubmissionComplete();
    this.visibleButtons = isSubmitted ? this.buttons : this.buttons.slice(0, 5);
  }

  updateSelectItems() {
    const isSubmitted = this.saveApplicationService.isSubmissionComplete();
    this.selectItems = isSubmitted ? this.steps : this.steps.slice(0, 5);
  }

  updateTotalSteps() {
    this.totalSteps = this.saveApplicationService.isSubmissionComplete()
      ? 6
      : 5;
  }

  async saveForm() {
    this.isSaving = true;
    this.saveSuccess = false;
    try {
      this.saveApplicationService.triggerSave();
      this.saveSuccess = true;
      setTimeout(() => {
        this.saveSuccess = false;
      }, 3000);
    } catch (error) {
      console.error('Error saving data', error);
      this.messageService.add({
        severity: 'error',
        summary: 'Error',
        detail: 'Failed to save application. Please try again.',
      });
    } finally {
      this.isSaving = false;
    }
  }

  setActive(index: number) {
    if (index === 5 && !this.saveApplicationService.isSubmissionComplete()) {
      this.messageService.add({
        severity: 'warn',
        summary: 'Warning',
        detail:
          'Please submit your application before accessing acknowledgement.',
      });
      return;
    }
    localStorage.setItem('currentStep', index.toString());
    this.active = index;
    this.currentStep = index + 1;
    this.selectedItem = this.steps[index];
    this.stepChanged.emit(this.currentStep);
  }

  onStepSelect() {
    if (this.selectedItem) {
      const stepIndex = this.selectedItem.step - 1;
      if (
        stepIndex === 5 &&
        !this.saveApplicationService.isSubmissionComplete()
      ) {
        this.messageService.add({
          severity: 'warn',
          summary: 'Warning',
          detail:
            'Please submit your application before accessing acknowledgement.',
        });
        this.selectedItem = this.steps[this.active];
        return;
      }
      this.active = stepIndex;
      this.currentStep = this.selectedItem.step;
      this.stepChanged.emit(this.currentStep);
    }
  }

  onClickSave() {
    this.onButtonClick.emit();
  }

  onSaveClick() {
    this.saveClicked.emit();
  }

  invalidFields: string[] = [];

  validateAllForms(): void {
    this.validationService.requestValidation();
  }

  openPreview() {
    this.displayPreview = true;
  }

  get formControl() {
    return this.menuForm.controls;
  }

  cities: ATSData[] = [];

  subscribeATS() {
    this.menuForm
      .get('selectedCities')
      ?.valueChanges.subscribe((selectedValues: ATSData[] | null) => {
        if (!selectedValues) {
          this.menuForm.get('atsUser')?.setValue([]);
          return;
        }
        const transformedData = selectedValues.map((item) => ({
          ats_name: item.amT_SIGN_NAME,
          asm_id: item.amT_ASM_ID,
        }));
        this.menuForm.get('atsUser')?.setValue(transformedData);
      });
  }

  async approveApplication() {
    // Clear previous comment and prepare to show the approval dialog
    const profileResponse =
      await this.userSyncService.validateSessionAndGetProfile();
    if (!profileResponse) {
      throw new Error('Failed to retrieve user profile');
    }
    try {
      const response = await firstValueFrom(
        this.adminService.apiAdminEtokenGet(profileResponse.data.dp_id)
      );
      this.cities = response.data.ats;
      this.formControl['SignReqd']?.setValue(
        response.data.ats[0]?.amT_SIGN_REQD ?? 0
      );
      // Open the approval dialog after successful data retrieval
      this.menuForm.get('approvalComment')?.setValue('');
      this.approveDialogVisible = true;
    } catch (error) {
      this.messageService.add({
        severity: 'error',
        summary: 'Error',
        detail: 'Failed to approve application',
      });
    }
  }

  rejectApplication() {
    // Clear previous comment and open the rejection dialog
    this.rejectionComment = '';
    this.rejectDialogVisible = true;
  }

  async confirmApprove(): Promise<void> {
    try {
      const trimmedComment = (
        this.menuForm.get('approvalComment')?.value || ''
      ).trim();
      const approvalResult = await firstValueFrom(
        this.fvciService.apiFvciapplicationApproveRejectApplicationAsyncGet(
          this.applicationId,
          'Approved',
          trimmedComment,
          
        )
      );
      const atsRequestPayload: ApproveRejectRequest = {
        applicationId: Number(this.applicationId),
        atsUserList: this.menuForm.get('atsUser')?.value || [],
        signReqd: Number(this.formControl['SignReqd'].value),
      };
      const atsResult = await firstValueFrom(
        this.fvciService.apiFvciapplicationATSSelectedUserPost(
          atsRequestPayload
        )
      );
      this.messageService.add({
        severity: 'success',
        summary: 'Approved',
        detail: 'Application has been approved successfully',
      });
    } catch (error) {
      this.messageService.add({
        severity: 'error',
        summary: 'Error',
        detail: 'Failed to approve application',
      });
    } finally {
      this.approveDialogVisible = false;
    }
  }

  async confirmReject() {
    if (!this.rejectionComment.trim()) {
      this.messageService.add({
        severity: 'warn',
        summary: 'Warning',
        detail: 'Please provide a reason for rejection',
      });
      return;
    }
    try {
      const response = await firstValueFrom(
        this.fvciService.apiFvciapplicationApproveRejectApplicationAsyncGet(
          this.applicationId,
          'Rejected',
          this.rejectionComment,
          
        )
      );
      this.messageService.add({
        severity: 'success',
        summary: 'Rejected',
        detail: 'Application has been rejected successfully',
      });
    } catch (error) {
      this.messageService.add({
        severity: 'error',
        summary: 'Error',
        detail: 'Failed to reject application',
      });
    } finally {
      this.rejectDialogVisible = false;
    }
  }

  cancelDialog(type: 'approve' | 'reject') {
    if (type === 'approve') {
      this.approveDialogVisible = false;
    } else {
      this.rejectDialogVisible = false;
    }
  }

  onSubmitClicked() {
    this.submitClicked.emit();
  }
}
