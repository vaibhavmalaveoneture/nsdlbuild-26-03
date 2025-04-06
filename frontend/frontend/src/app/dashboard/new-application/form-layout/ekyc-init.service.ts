import { Injectable } from "@angular/core";
import { FormArray, FormBuilder, FormControl, FormGroup, Validators } from "@angular/forms";
import { City } from "../data";
import { atLeastTwoFieldsRequiredValidator,atLeastTwoFieldsRequiredFValidator,assetAndDateValidator,   urlValidator, applicantTypeOtherValidator } from './form-layout.validators';


@Injectable({ providedIn: 'root' })
export class FormInitService {
constructor(private fb: FormBuilder) {}

  createFvciForm(): FormGroup {
    return this.fb.group({
          name: new FormControl('', [
            Validators.required,
            Validators.maxLength(300)
          ]),
          applicantOtherName: new FormGroup({
            otherNameRadio: new FormControl(null, Validators.required),
            otherNameField: new FormControl(''),
          }),
          dateOfIncorporation: new FormControl<Date | null>(null, Validators.required),
          dateOfCommencement: new FormControl<Date | null>(null),
          placeOfIncorporation: new FormControl('', Validators.required),
          countryOfIncorporation: new FormControl(null, Validators.required),
          countryCodeOfIncorporation: new FormControl({ value: null, disabled: true }),
          legalForm: new FormControl(''),
          lei: new FormControl('', [
            Validators.required,
            Validators.maxLength(20), 
            Validators.minLength(20), 
            Validators.pattern('^[a-zA-Z0-9]+$') 
          ]),
          taxResidencyRows: new FormArray<FormGroup>([]),
          registeredOffice: new FormGroup(
            {
              registeredFlatNum: new FormControl(''),
              registeredBuildingName: new FormControl(''),
              registeredCountryName: new FormControl(null, Validators.required),
              registeredRoadName: new FormControl(''),
              registeredAreaName: new FormControl(''),
              registeredTownName: new FormControl('', Validators.required),
              registeredZipName: new FormControl('', Validators.required),
              registeredStateName: new FormControl(''),
              notApplicableResidence: new FormControl(false),
            },
            { validators: atLeastTwoFieldsRequiredValidator() }
          ),
          sameAsAbove: new FormControl(false),
          foreignOffice: new FormGroup(
            {
              foreignFlatNum: new FormControl(''),
              foreignBuildingName: new FormControl(''),
              foreignCountryName: new FormControl(null, Validators.required),
              foreignRoadName: new FormControl(''),
              foreignAreaName: new FormControl(''),
              foreignTownName: new FormControl('', Validators.required),
              foreignZipName: new FormControl('', Validators.required),
              foreignStateName: new FormControl(''),
              notApplicableForeignOffice: new FormControl(false),
            },
            { validators: atLeastTwoFieldsRequiredFValidator() }
          ),
          OfficeInIndia: new FormGroup(
            {
              OfficeInIndiaRadio: new FormControl(null),
              indianFlatNum: new FormControl(''),
              indianBuildingName: new FormControl(''),
              indianCountryName: new FormControl(null),
              indianRoadName: new FormControl(''),
              indianAreaName: new FormControl(''),
              indianTownName: new FormControl(''),
              indianZipName: new FormControl(''),
              indianStateName: new FormControl(''),
              notApplicableIndOffice: new FormControl(null),
            },
            // { validators: atLeastTwoFieldsRequiredIValidator() }
          ),
          communicationAddress: new FormControl('', Validators.required),
          contactDetails: new FormGroup({
            registered: new FormGroup({
              countryCode: new FormControl(null),
              areaCode: new FormControl(''),
              number: new FormControl(''),
            }),
            office: new FormGroup({
              countryCode: new FormControl(null),
              areaCode: new FormControl(''),
              number: new FormControl(''),
            }),
            indianOffice: new FormGroup({
              countryCode: new FormControl(null),
              areaCode: new FormControl(''),
              number: new FormControl(''),
            }),
            registeredFax: new FormGroup({
              countryCode: new FormControl(null),
              areaCode: new FormControl(''),
              number: new FormControl(''),
            }),
            officeFax: new FormGroup({
              countryCode: new FormControl(null),
              areaCode: new FormControl(''),
              number: new FormControl(''),
            }),
            indianOfficeFax: new FormGroup({
              countryCode: new FormControl(null),
              areaCode: new FormControl(''),
              number: new FormControl(''),
            }),
            // Mobile number, email ID, and website controls
            mobileNumber: new FormControl('',[Validators.required, Validators.pattern('^[0-9]+$') ]),
            emailId: new FormControl('',[Validators.required, Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z]{1,20}$/)]),
            website: new FormControl('', [Validators.required, urlValidator()]),
          }),
          // investmentManager: new FormGroup({}),
          investmentManager: new FormGroup({
            nameOfEntity: new FormControl('' , Validators.required),
            typeOfEntity: new FormControl('' , Validators.required),
            country: new FormControl(null, [Validators.required]),
            telephoneNumber: new FormControl('', [ Validators.pattern('^[0-9]+$')]),
            faxNumber: new FormControl('', [ Validators.pattern('^[0-9]+$')]),
            emailId: new FormControl('', [Validators.required, Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z]{1,20}$/)]),
          }),
          complianceOfficerInfo: new FormGroup({
            complianceOfficerInfoName: new FormControl('' , Validators.required),
            complianceOfficerInfoJob: new FormControl('' , Validators.required),
            complianceOfficerInfoMobile: new FormControl('', [Validators.required, Validators.pattern('^[0-9]+$')]),
            complianceOfficerInfoFax: new FormControl('', [ Validators.pattern('^[0-9]+$')]),
            complianceOfficerInfoEmail: new FormControl('', [Validators.required, Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z]{1,20}$/)]),
          }),
          ultimateBeneficialOwner: new FormControl(null, Validators.required),
          ultimateBeneficialOwnerHolding: new FormControl(''), 
          managingOfficialRows: new FormArray<FormGroup>([]),
          beneficialOwnership: new FormControl(null, Validators.required),
          incomeDetails: new FormGroup({
            incomeSource: new FormControl<null>(null, Validators.required),
            businessCode: new FormControl<null>(null),
            annualIncome: new FormControl(null),
            assetLess: new FormControl(null),
            asOnDate:new FormControl<Date | null>(null),
          }, { validators: assetAndDateValidator() }),
          applicantType: new FormGroup({
            applicantTypeName: new FormControl('', Validators.required),
            applicantTypeOtherEntity: new FormControl(''),
          }, { validators: applicantTypeOtherValidator() }),
          // Replace FormArray with individual controls
          proofOfIdentity: new FormControl<string | null>(null, Validators.required),
          proofOfAddress: new FormControl<string | null>(null, Validators.required),
          
          
          
          designationDetails: new FormArray<FormGroup>([]),
          
          date: new FormControl<Date | null>(null),
          typeOfEntity: new FormControl<string | null>(null, Validators.required),
          selectedCity: new FormControl<City | null>(null),
          
          politicallyExposed: new FormControl(null, Validators.required),
          relatedToPoliticallyExposed: new FormControl(null, Validators.required),
        });

        
  }


}