import { Injectable } from '@angular/core';
import { FormGroup, FormControl, Validators, FormBuilder } from '@angular/forms';

@Injectable({
  providedIn: 'root'
})
export class DocUploadInitService {

  constructor(private fb: FormBuilder) { }

    createDocUploadForm(): FormGroup{
      return this.fb.group({
          poiUpload: new FormControl('', Validators.required),
          poaUpload: new FormControl('', Validators.required)
        });
    }
    
}
