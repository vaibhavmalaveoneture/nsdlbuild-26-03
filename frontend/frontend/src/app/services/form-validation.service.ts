import { Injectable } from '@angular/core';
import { FormGroup, Validators } from '@angular/forms';
import { Subject } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class FormValidationService {
  private validateFormsSource = new Subject<void>();
  validateForms$ = this.validateFormsSource.asObservable();
  private forms: Map<string, FormGroup> = new Map();

  public validationFlag: boolean | undefined;
  // private forms: FormGroup[] = [];

  // Register a form in the service
  registerForm(key: string, form: FormGroup) {
    this.validationFlag = false;
    this.forms.set(key, form);
  }

  // Request validation for all registered forms
  requestValidation() {
    this.forms.forEach((form, key) => {
      if (key == 'fvci') {
        this.addRequiredValidations(form, ['name', 'dateOfIncorporation']);
      }
      if (key == 'register') {
        this.addRequiredValidations(form, [
          'regulatoryAuthorityName',
          'regulatoryAuthorityCountry',
          'regulatoryAuthorityWebsite',
        ]);
      }

      form.markAllAsTouched();
      this.validationFlag = true;
    });
  }

  /** Add required validations dynamically */
  private addRequiredValidations(form: FormGroup, fields: string[]) {
    fields.forEach((field) => {
      if (form.controls[field]) {
        form.controls[field].addValidators(Validators.required);
        form.controls[field].updateValueAndValidity();
      }
    });
  }

  // Get all invalid fields
  getInvalidFields(): string[] {
    let invalidFields: string[] = [];
    this.forms.forEach((form, index) => {
      Object.keys(form.controls).forEach((key) => {
        if (form.controls[key].invalid) {
          invalidFields.push(`Form ${index + 1} - Field: ${key}`);
        }
      });
    });
    return invalidFields;
  }
}
