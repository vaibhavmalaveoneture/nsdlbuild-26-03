import { Injectable } from "@angular/core";
import { FormArray, FormBuilder, FormControl, FormGroup, Validators } from "@angular/forms";
import { City } from "../data";
import { atLeastTwoFieldsRequiredValidator,atLeastTwoFieldsRequiredFValidator,atLeastTwoFieldsRequiredIValidator,   urlValidator } from './form-layout.validators';


@Injectable({ providedIn: 'root' })
export class AnextureToCafService {
constructor(private fb: FormBuilder) {}


  
  createAnnextureForm(): FormGroup {
        return this.fb.group({
            seggregatedPortfolio: new FormGroup({
              seggregatedPortfolioRadio: new FormControl(null, Validators.required),
              seggregatedPortfolioText: new FormControl('',),
            }),
            bankDeclaration: new FormGroup({
              bankDeclarationRadio: new FormControl(null, Validators.required),
              bankDeclarationText: new FormControl(''),
            }),
            consentIntermediary: new FormGroup({
              consentIntermediaryRadio: new FormControl(null, Validators.required),
              consentIntermediaryName: new FormControl(null),
              consentIntermediaryEmail1: new FormControl(null),
              consentIntermediaryEmail2: new FormControl(null),
              consentIntermediaryEmail3: new FormControl(null),
              consentIntermediaryMobile: new FormControl(null),
            }),
            informationOfSaSmFvciApplicant: new FormArray([]),
            signatoryRows: new FormArray<FormGroup>([]),
            materialShareholderRows: new FormArray<FormGroup>([]),
            beneficialOwners: new FormArray<FormGroup>([]),
            managers: new FormArray([]),
            intermediateMaterial: new FormControl(null, Validators.required),
            entityHolding: new FormControl(null),
            noentityHolding: new FormControl(null),
            beneficialOwnership: new FormControl(null, Validators.required),
          });
  }

}