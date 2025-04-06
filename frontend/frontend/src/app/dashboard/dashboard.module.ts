import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { DashboardRoutingModule } from './dashboard-routing.module';
import { ApplicationListComponent } from './application-list/application-list.component';
import { UserManagementComponent } from './user-management/user-management.component';
import { NewApplicationComponent } from './new-application/new-application.component';
import { MenubarModule } from 'primeng/menubar';
import { TableModule } from 'primeng/table';
import { TagModule } from 'primeng/tag';
import { ButtonModule } from 'primeng/button';
import { CardModule } from 'primeng/card';
import { DatePickerModule } from 'primeng/datepicker';
import { IconFieldModule } from 'primeng/iconfield';
import { InputIconModule } from 'primeng/inputicon';
import { BreadcrumbModule } from 'primeng/breadcrumb';
import { NavbarComponent } from '../standalone/shared/navbar/navbar.component';
import { FvciFormComponent } from './new-application/form-layout/fvci-form/fvci-form.component';
import { RegistrationFormComponent } from './new-application/form-layout/registration-form/registration-form.component';
import { AnnexureFormComponent } from './new-application/form-layout/annexure-form/annexure-form.component';
import { DocumentsUploadComponent } from './new-application/form-layout/documents-upload/documents-upload.component';
import { DeclarationUndertakingComponent } from './new-application/form-layout/declaration-undertaking/declaration-undertaking.component';
import { PreviewComponent } from './new-application/form-layout/preview/preview.component';
import { AcknowledgementComponent } from './new-application/form-layout/acknowledgement/acknowledgement.component';
import { SelectModule } from 'primeng/select';
import { MenuComponent } from './new-application/form-layout/menu/menu.component';
import { DrawerModule } from 'primeng/drawer';
import { OverlayPanelModule } from 'primeng/overlaypanel';
import { PanelMenuModule } from 'primeng/panelmenu';
import { RadioButtonModule } from 'primeng/radiobutton';
import { FileUploadModule } from 'primeng/fileupload';
import { AccordionModule } from 'primeng/accordion';
import { ScrollPanelModule } from 'primeng/scrollpanel';
import { ToastModule } from 'primeng/toast';
import { CheckboxModule } from 'primeng/checkbox';
import { SidebarComponent } from './new-application/form-layout/sidebar/sidebar.component';
import { InputTextModule } from 'primeng/inputtext';
import { LoaderComponent } from '../standalone/loader/loader.component';
import { ConfirmDialogModule } from 'primeng/confirmdialog';
import { TooltipModule } from 'primeng/tooltip';
import { SplitButtonModule } from 'primeng/splitbutton';
import { MultiSelectModule } from 'primeng/multiselect';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgCircleProgressModule } from 'ng-circle-progress';
import { FormLayoutComponent } from './new-application/form-layout/form-layout.component';
import { DisplayPreviewComponent } from './new-application/form-layout/display-preview/display-preview.component';
import { DialogModule } from 'primeng/dialog';
import { PreviewModeDirective } from './new-application/form-layout/directives/preview-mode.directive';
import {DateOnlyInputDirective} from './new-application/form-layout/directives/date-only-input.directive'


@NgModule({
  declarations: [
    ApplicationListComponent,
    UserManagementComponent,
    NewApplicationComponent,
    FvciFormComponent,
    RegistrationFormComponent,
    AnnexureFormComponent,
    DocumentsUploadComponent,
    DeclarationUndertakingComponent,
    PreviewComponent,
    AcknowledgementComponent,
    MenuComponent,
    SidebarComponent,
    FormLayoutComponent,
    DisplayPreviewComponent,
  ],
  imports: [
    LoaderComponent,
    AccordionModule,
    CommonModule,
    ConfirmDialogModule,
    NavbarComponent,
    DashboardRoutingModule,
    ReactiveFormsModule,
    FormsModule,
    MenubarModule,
    TableModule,
    TagModule,
    ButtonModule,
    CardModule,
    DatePickerModule,
    IconFieldModule,
    InputIconModule,
    InputTextModule,
    BreadcrumbModule,
    SelectModule,
    DrawerModule,
    OverlayPanelModule,
    PanelMenuModule,
    RadioButtonModule,
    ScrollPanelModule,
    FileUploadModule,
    TooltipModule,
    ToastModule,
    CheckboxModule,
    ToastModule,
    SplitButtonModule,
    MultiSelectModule,
    NgCircleProgressModule,
    DialogModule,
    PreviewModeDirective,
    
  ],
})
export class DashboardModule {}
