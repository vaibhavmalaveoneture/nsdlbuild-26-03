import { Injectable } from "@angular/core";
import { FormArray, FormBuilder, FormControl, FormGroup, Validators } from "@angular/forms";
import { City } from "../data";
import { priorAssociationRowsRequiredValidator,hasPanConditionalValidator,disciplinaryHistoryConditionalValidator,   urlValidator } from './form-layout.validators';


@Injectable({ providedIn: 'root' })
export class RegistartionInitService {
constructor(private fb: FormBuilder) {}

createRegistrationForm(): FormGroup {
  return this.fb.group({
      providedValidForm: new FormControl(null, [Validators.required]),
      throughGlobalCustodian: new FormGroup({
        throughGlobalCustodianRadio: new FormControl(null, Validators.required),
        throughGlobalCustodianName: new FormControl(null),
        throughGlobalCustodianRegulatorName: new FormControl(null),
        throughGlobalCustodianAddress: new FormControl(null),
        throughGlobalCustodianRegistration: new FormControl(null),
        throughGlobalCustodianCountry: new FormControl(null),
      }),
      designatedBank: new FormGroup({
        designatedBankName: new FormControl(null, Validators.required),
        designatedBankAddress: new FormControl(null, Validators.required),
      }),
      priorAssociation: new FormGroup({
        priorAssociationRadio: new FormControl(null, Validators.required),
      }),
      priorAssiciationRows: new FormArray<FormGroup>([], priorAssociationRowsRequiredValidator()),
      hasPan: new FormGroup({
        hasPanRadio: new FormControl(null, Validators.required),
        hasPanNumber: new FormControl(null),
      }, {validators:hasPanConditionalValidator()}),
      disciplinaryHistory: new FormGroup({
        disciplinaryHistoryRadio: new FormControl(null, Validators.required),
        disciplinaryHistoryText: new FormControl('')
      }, { validators: disciplinaryHistoryConditionalValidator() }),
      // Replace regulatoryAuthorityDetails FormArray with individual controls
      regulatoryAuthorityName: new FormControl(null),
      regulatoryAuthorityCountry: new FormControl(null),
      regulatoryAuthorityWebsite: new FormControl(null),
      regulatoryAuthorityRegNumber: new FormControl(null),
      regulatoryAuthorityCategory: new FormControl(null),

      // Replace designatorDetails FormArray with individual controls
      ddpName: new FormControl(null, Validators.required),
      ddpRegistrationNumber: new FormControl(null, Validators.required),
      custodianName: new FormControl(null, Validators.required),
      custodianRegistrationNumber: new FormControl(null, Validators.required),
      dpName: new FormControl(null, Validators.required),
      dpRegistrationNumber: new FormControl(null, Validators.required),

      selectedCity: new FormControl<City | null>(null),
      hasOtherEntity: new FormControl(null),
      otherEntityDetails: new FormControl(null),
    });
}
}