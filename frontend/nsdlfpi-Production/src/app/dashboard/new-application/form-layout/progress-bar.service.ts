import { Injectable } from '@angular/core';
import {
  AbstractControl,
  FormArray,
  FormControl,
  FormGroup,
  ValidationErrors,
  Validators,
} from '@angular/forms';
import { hasRequiredValidator } from './form-layout.validators'; // Assuming you've added it there

@Injectable({
  providedIn: 'root'
})
export class FormCompletionService {
  constructor() {}

  updateFormCompletion(
    fvciForm: FormGroup,
    registrationForm: FormGroup,
    annexureForm: FormGroup,
    documentUploadForm: FormGroup,
    declarationForm: FormGroup
  ): number {
    const fvciRequired = this.getRequiredControls(fvciForm);
    const ekycRequired = this.getRequiredControls(registrationForm);
    const annexureRequired = this.getRequiredControls(annexureForm);
    const documentUploadRequired = this.getRequiredControls(documentUploadForm);
    const declarationRequired = this.getRequiredControls(declarationForm);

    const allRequired = [
      ...fvciRequired,
      ...ekycRequired,
      ...annexureRequired,
      ...declarationRequired,
      ...documentUploadRequired
    ];
    let groupErrorCount = 0;
    const groupsToCheck = [
      fvciForm.get('registeredOffice'),
      fvciForm.get('foreignOffice'),
      fvciForm.get('OfficeInIndia')
    ];
    const validCount = allRequired.filter(control =>
      (control.disabled || control.valid) && control.hasValidator(Validators.required)
    ).length;
    // console.log(this.getInvalidRequiredFieldNames(fvciForm))
    const totalRequired = allRequired.length + groupErrorCount;
    return totalRequired === 0 ? 0 : Math.floor((validCount / totalRequired) * 100);
  }

  getRequiredControls(control: AbstractControl): AbstractControl[] {
    const requiredControls: AbstractControl[] = [];

    const traverse = (control: AbstractControl) => {
      if (control instanceof FormGroup) {
        Object.values(control.controls).forEach(traverse);
      } else if (control instanceof FormArray) {
        control.controls.forEach(traverse);
      } else if (control instanceof FormControl) {
        const validator = control.validator?.({} as AbstractControl);
        if (validator && validator['required']) {
          requiredControls.push(control);
        }
      }
    };

    traverse(control);
    return requiredControls;
  }

  getValidRequiredFieldNames(control: AbstractControl, parentKey = ''): string[] {
    let validFields: string[] = [];

    if (control instanceof FormGroup) {
      Object.keys(control.controls).forEach(key => {
        const child = control.controls[key];
        const path = parentKey ? `${parentKey}.${key}` : key;
        validFields = validFields.concat(this.getValidRequiredFieldNames(child, path));
      });
    } else if (control instanceof FormArray) {
      control.controls.forEach((child, i) => {
        const path = `${parentKey}[${i}]`;
        validFields = validFields.concat(this.getValidRequiredFieldNames(child, path));
      });
    } else if (hasRequiredValidator(control) && control.valid) {
      validFields.push(parentKey);
    }

    return validFields;
  }

  getInvalidRequiredFieldNames(control: AbstractControl, parentKey = ''): string[] {
    let invalidFields: string[] = [];

    if (control instanceof FormGroup) {
      Object.keys(control.controls).forEach(key => {
        const child = control.controls[key];
        const path = parentKey ? `${parentKey}.${key}` : key;
        invalidFields = invalidFields.concat(this.getInvalidRequiredFieldNames(child, path));
      });
    } else if (control instanceof FormArray) {
      control.controls.forEach((child, i) => {
        const path = `${parentKey}[${i}]`;
        invalidFields = invalidFields.concat(this.getInvalidRequiredFieldNames(child, path));
      });
    } else if (hasRequiredValidator(control) && control.invalid) {
      invalidFields.push(parentKey);
    }

    return invalidFields;
  }
}
