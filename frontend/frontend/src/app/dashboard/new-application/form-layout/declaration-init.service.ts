import { Injectable } from "@angular/core";
import { FormArray, FormBuilder, FormControl, FormGroup, Validators } from "@angular/forms";
import { City } from "../data";
import { atLeastTwoFieldsRequiredValidator,atLeastTwoFieldsRequiredFValidator,atLeastTwoFieldsRequiredIValidator,   urlValidator } from './form-layout.validators';


@Injectable({ providedIn: 'root' })
export class DeclarationUndertakingFormService {
constructor(private fb: FormBuilder) {}


  createDeclrationAndUnderTaking(): FormGroup{
    return this.fb.group({
        name: new FormControl('', Validators.required),
        capacity: new FormControl('', Validators.required),
        place: new FormControl('', Validators.required),
        date: new FormControl({ value: new Date(), disabled: true }),
        nameOfSignatory: new FormControl('', Validators.required),
        designationOfSignatory: new FormControl('', Validators.required),
        dateOfSignature: new FormControl({ value: null, disabled: true }),
        signature: new FormControl({ value: '', disabled: true }),
      });
  }
}