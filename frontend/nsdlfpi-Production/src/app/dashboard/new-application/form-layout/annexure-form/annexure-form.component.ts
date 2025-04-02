import {
  Component,
  Input,
  OnInit,
  ViewEncapsulation,
  SimpleChanges,
} from '@angular/core';
import {
  AbstractControl,
  FormArray,
  FormBuilder,
  FormControl,
  FormGroup,
  Validators,
} from '@angular/forms';
import {
  designationData,
  regulationData,
  signatoryData,
  segregatedPortfolio,
} from '../../data';
import { debounceTime, firstValueFrom, Subscription } from 'rxjs';
import {
  CommonService,
  DraftFvciApplicationDto,
  DraftFvciBenificialOwnershipByControlBoDetailsDto,
  DraftFvciBenificialOwnershipByControlDto,
  DraftFvciIncomeDetailsDto,
  DraftFvciInfoBasicOfOwnershipBoDetailsDto,
  DraftFvciInformationOfSaSmFvciApplicantDto,
  DraftFvciIsBankDto,
  DraftFvciKraPermissionDto,
  DraftFvciOwnershipDetailsDto,
  DraftFvciSubClassBenificialOwnerDetailsDto,
  DraftFvciSubClassDetailsDto,
} from '../../../../../swagger';
import { SaveApplicationService } from '../../../../services/save-application.service';
import { MessageService } from 'primeng/api';
import { Router } from '@angular/router';
import { FormProgressService } from '../../../../services/form-progress.service';
import { panValidator, percentageValidator } from '../form-layout.validators';

@Component({
  selector: 'app-annexure-form',
  standalone: false,
  templateUrl: './annexure-form.component.html',
  styleUrls: ['./annexure-form.component.scss'],
  encapsulation: ViewEncapsulation.None,
})
export class AnnexureFormComponent implements OnInit {
  @Input() applicationId: string | undefined;
  // @Input() applicationData: DraftFvciApplicationDto | null = null;
  @Input() applicationData!: any;
  @Input() previewMode: boolean = false;
  @Input() formGroup!: FormGroup;

  @Input() masterData!: any;
  private saveSubscription!: Subscription;
  showLoader = false;
  activeAccordionIndices: number[] = [];
  activePanelIndex: number = -1;
  maxDate: Date = new Date();

  countries: any[] = [];
  countryShortCodes: any[] = [];
  countryCodes: any[] = [];
  detailsData: any[] = [{}];
  regulationData = regulationData;
  designationData = designationData;
  signatoryData = [...signatoryData];
  segregatedPortfolioData = segregatedPortfolio;
  authorizedSignatoryData = [...signatoryData];

  readonly ownerFields = [
    {
      id: 'nameOfBeneficialOwner',
      label: 'a)',
      name: 'Name of Beneficial owner',
      type: 'text',
      placeHolder: 'Enter Name',
    },
    {
      id: 'directIndirectStake',
      label: 'b)',
      name: 'Direct / Indirect Stake',
      type: 'text',
      placeHolder: 'Mention Stake',
    },
    {
      id: 'nameOfEntities',
      label: 'c)',
      name: 'Names of the entity(ies) through which the stake in the FVCI is held indirectly',
      type: 'text',
      placeHolder: 'Enter Name',
    },
    {
      id: 'countryOfIncorporationOrnationality',
      label: 'd)',
      name: 'Country of Incorporation / Nationality',
      type: 'dropdown',
      placeHolder: 'Select Country',
    },
    {
      id: 'percentageStakeHeld',
      label: 'e)',
      name: 'Percentage stake held in the applicant, if applicable',
      type: 'text',
      placeHolder: 'Enter Percentage',
    },
    {
      id: 'individualOrNonIndividual',
      label: 'f)',
      name: 'Individual /Non-Individual',
      type: 'dropdown',
      placeHolder: 'Select Type',
    },
  ];

  readonly managerFields = [
    { id: 'nameOfEntity', label: 'a)', name: 'Name of Entity' },
    { id: 'typeOfEntity', label: 'b)', name: 'Type of Entity' },
    { id: 'country', label: 'c)', name: 'Country' },
    { id: 'telephoneNumber', label: 'd)', name: 'Telephone Number' },
    { id: 'faxNumber', label: 'e)', name: 'Fax Number' },
    { id: 'emailId', label: 'f)', name: 'Email Id' },
  ];

  readonly beneficialFields = [
    {
      id: 'nameOfBeneficialOwner',
      lable: 'a)',
      name: 'Name of Beneficial owner',
      type: 'text',
      placeHolder: 'Enter Name',
    },
    {
      id: 'methodOfControl',
      lable: 'b)',
      name: 'Method of Control (Give Details including names of the intermediate structures, if any, through which control is exercised )',
      type: 'text',
      placeHolder: 'Enter Name',
    },
    {
      id: 'countryOfIncorporation',
      lable: 'c)',
      name: 'Country of Incorporation / Nationality',
      type: 'dropdown',
      placeHolder: 'Select Country',
    },
    {
      id: 'percentageStakeHeld',
      lable: 'd)',
      name: 'Percentage stake held in the applicant',
      type: 'text',
      placeHolder: 'Enter Percentage',
    },
    {
      id: 'individualOrNonIndividual',
      lable: 'e)',
      name: 'Individual /Non-Individual',
      type: 'dropdown',
      placeHolder: 'Select Type',
    },
  ];

  types = [
    { label: 'Individual', value: 'Individual' },
    { label: 'Non-Individual', value: 'Non-Individual' },
  ];

  private readonly requiredMapping: { [key: string]: any } = {
    seggregatedPortfolio: [
      'seggregatedPortfolioRadio',
      'seggregatedPortfolioText',
    ],
    bankDeclaration: ['bankDeclarationRadio', 'bankDeclarationText'],
    consentIntermediary: [
      'consentIntermediaryRadio',
      'consentIntermediaryName',
      'consentIntermediaryEmail1',
      'consentIntermediaryEmail2',
      'consentIntermediaryEmail3',
      'consentIntermediaryMobile',
    ],
  };

  constructor(
    private readonly commonService: CommonService,
    private readonly saveApplicationService: SaveApplicationService,
    private readonly messageService: MessageService,
    private readonly router: Router,
    private readonly progressService: FormProgressService,
    private readonly fb: FormBuilder
  ) {}

  ngOnInit(): void {
    this.addManager();
    this.addSignatory();
    this.addShareholder();
    this.addBeneficialOwner();
    this.addInformationOfSaSmFvciApplicant();
    // this.loadData();
    this.subscribeToSeggregatedPortfolioRadioChanges();

    const segregatedPortfolioGroup = this.formGroup.get(
      'seggregatedPortfolio'
    ) as FormGroup;

    const spTextControl = segregatedPortfolioGroup.get(
      'seggregatedPortfolioText'
    );
    const bankDeclarationGroup = this.formGroup.get(
      'bankDeclaration'
    ) as FormGroup;
    const bdRadioControl = bankDeclarationGroup.get('bankDeclarationRadio');
    const bdRextControl = bankDeclarationGroup.get('bankDeclarationText');
    const consentGroup = this.formGroup.get('consentIntermediary') as FormGroup;
    const consentRadioControl = consentGroup.get('consentIntermediaryRadio');
    const consentEmail1Control = consentGroup.get('consentIntermediaryEmail1');

    // 1

    // 2
    bdRadioControl?.valueChanges.subscribe((value) => {
      if (value === 'bank_with_office') {
        bdRextControl?.setValidators(Validators.required);
      } else {
        bdRextControl?.clearValidators();
        bdRextControl?.reset();
      }
      bdRextControl?.updateValueAndValidity();
    });

    if (bdRadioControl?.value === 'bank_with_office') {
      bdRextControl?.setValidators(Validators.required);
      bdRextControl?.updateValueAndValidity();
    } else {
      bdRextControl?.clearValidators();
      bdRextControl?.updateValueAndValidity();
    }

    // 3
    consentRadioControl?.valueChanges.subscribe((value) => {
      if (value === true) {
        consentEmail1Control?.setValidators([
          Validators.required,
          Validators.email,
        ]);
      } else {
        consentEmail1Control?.clearValidators();
        consentEmail1Control?.reset();
      }
      consentEmail1Control?.updateValueAndValidity();
    });

    if (consentRadioControl?.value === true) {
      consentEmail1Control?.setValidators([
        Validators.required,
        Validators.email,
      ]);
      consentEmail1Control?.updateValueAndValidity();
    } else {
      consentEmail1Control?.clearValidators();
      consentEmail1Control?.updateValueAndValidity();
    }

    // 5a
    const intermediateMaterialControl = this.formGroup.get(
      'intermediateMaterial'
    );
    const entityHoldingControl = this.formGroup.get('entityHolding');
    const noentityHoldingControl = this.formGroup.get('noentityHolding');
    const materialShareholderRows = this.formGroup.get(
      'materialShareholderRows'
    ) as FormArray;

    intermediateMaterialControl?.valueChanges.subscribe((value) => {
      console.log('materialShareholderRows', materialShareholderRows);
      if (value === false) {
        entityHoldingControl?.enable();
        entityHoldingControl?.setValidators([
          Validators.required,
          Validators.min(0),
          Validators.max(100.0),
        ]);
        noentityHoldingControl?.clearValidators();
        noentityHoldingControl?.reset();
        noentityHoldingControl?.disable();
        for (let i = 0; i < materialShareholderRows.length; i++) {
          const group = materialShareholderRows.at(i) as FormGroup;
          Object.keys(group.controls).forEach((key) => {
            group.get(key)?.setValidators(Validators.required);
            group.get(key)?.updateValueAndValidity();
          });
        }

        if (materialShareholderRows.length === 0) {
          this.createShareholderFormGroup();
        }
      } else if (value === true) {
        entityHoldingControl?.clearValidators();
        entityHoldingControl?.reset();
        noentityHoldingControl?.enable();
        noentityHoldingControl?.setValidators([
          Validators.required,
          Validators.min(0),
          Validators.max(100.0),
        ]);
        entityHoldingControl?.disable();

        for (let i = 0; i < beneficialOwnersArray.length; i++) {
          const group = materialShareholderRows.at(i) as FormGroup;
          Object.keys(group.controls).forEach((key) => {
            group.get(key)?.clearValidators();
            group.get(key)?.updateValueAndValidity();
          });
        }
      } else {
        noentityHoldingControl?.clearValidators();
        noentityHoldingControl?.reset();
        entityHoldingControl?.clearValidators();
        entityHoldingControl?.reset();
      }
      entityHoldingControl?.updateValueAndValidity();
      noentityHoldingControl?.updateValueAndValidity();
    });

    if (intermediateMaterialControl?.value === false) {
      entityHoldingControl?.setValidators([
        Validators.required,
        Validators.min(0),
      ]);
      entityHoldingControl?.updateValueAndValidity();
    } else {
      entityHoldingControl?.clearValidators();
      entityHoldingControl?.updateValueAndValidity();
    }

    // 5b
    const beneficialOwnershipControl = this.formGroup.get(
      'beneficialOwnership'
    );
    const beneficialOwnersArray = this.formGroup.get(
      'beneficialOwners'
    ) as FormArray;

    beneficialOwnershipControl?.valueChanges.subscribe((value) => {
      if (value === true) {
        for (let i = 0; i < beneficialOwnersArray.length; i++) {
          const group = beneficialOwnersArray.at(i) as FormGroup;
          Object.keys(group.controls).forEach((key) => {
            group.get(key)?.setValidators(Validators.required);
            group.get(key)?.updateValueAndValidity();
          });
        }

        if (beneficialOwnersArray.length === 0) {
          this.addBeneficialOwner();
        }
      } else {
        for (let i = 0; i < beneficialOwnersArray.length; i++) {
          const group = beneficialOwnersArray.at(i) as FormGroup;
          Object.keys(group.controls).forEach((key) => {
            group.get(key)?.clearValidators();
            group.get(key)?.updateValueAndValidity();
          });
        }
      }
    });

    if (beneficialOwnershipControl?.value === true) {
      for (let i = 0; i < beneficialOwnersArray.length; i++) {
        const group = beneficialOwnersArray.at(i) as FormGroup;
        Object.keys(group.controls).forEach((key) => {
          group.get(key)?.setValidators(Validators.required);
          group.get(key)?.updateValueAndValidity();
        });
      }

      if (beneficialOwnersArray.length === 0) {
        this.addBeneficialOwner();
      }
    } else {
      for (let i = 0; i < beneficialOwnersArray.length; i++) {
        const group = beneficialOwnersArray.at(i) as FormGroup;
        Object.keys(group.controls).forEach((key) => {
          group.get(key)?.clearValidators();
          group.get(key)?.updateValueAndValidity();
        });
      }
    }
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['masterData'] && changes['masterData'].currentValue) {
      this.initializeMasterData();
    }
    if (changes['applicationData'] && changes['applicationData'].currentValue) {
      console.log('asdasdasdasd');
      this.initialiseForm();
    }
  }

  initialiseForm() {
    const annexureData = this.applicationData.data?.anextureForm;
    if (!annexureData) return;

    this.formGroup.patchValue({
      name: annexureData.name,
      intermediateMaterial: annexureData.intermediateMaterial,
      noentityHolding: annexureData.noentityHolding,
      entityHolding: annexureData.entityHolding,
      beneficialOwnership: annexureData.beneficialOwnership,
    });

    this.patchSegregatedPortfolio(annexureData.seggregatedPortfolio);
    this.patchBankDeclaration(annexureData.bankDeclaration);
    this.patchConsentIntermediary(annexureData.consentIntermediary);
    this.patchInformationOfSaSmApplicant(
      annexureData.informationOfSaSmFvciApplicant
    );
    this.patchMaterialShareholders(annexureData.materialShareholderRows);
    this.patchBeneficialOwners(annexureData.beneficialOwners);
  }

  private patchSegregatedPortfolio(data: any) {
    const segGroup = this.formGroup.get('seggregatedPortfolio') as FormGroup;
    if (!data) return;

    segGroup.patchValue({
      seggregatedPortfolioRadio: data.seggregatedPortfolioRadio,
    });

    if (data.seggregatedPortfolioRadio && data.signatoryRows) {
      const signatoryArray = this.formGroup.get('signatoryRows') as FormArray;
      signatoryArray.clear();
      data.signatoryRows.forEach((row: any) => {
        const group = this.createSignatoryFormGroup();
        group.patchValue({
          details: row.details,
        });
        if (row.ownerDetails) {
          const ownerDetailsArray = group.get('ownerDetails') as FormArray;
          ownerDetailsArray.clear();
          row.ownerDetails.forEach((owner: any) => {
            ownerDetailsArray.push(
              this.fb.group({
                nameAddressOfBo: owner.nameAddressOfBo,
                dateOfBirthOfBo: owner.dateOfBirthOfBo
                  ? new Date(owner.dateOfBirthOfBo)
                  : null,
                taxResidencyJuridiction: owner.taxResidencyJuridiction,
                nationality: this.findCountry(owner.nationality),
                actingAloneOrMoreNaturalPerson:
                  owner.actingAloneOrMoreNaturalPerson,
                boGroupPercentageShareHolding:
                  owner.boGroupPercentageShareHolding,
                identityDocument: owner.identityDocument,
              })
            );
          });
        }
        signatoryArray.push(group);
      });
    }
  }

  private patchBankDeclaration(data: any) {
    const bankGroup = this.formGroup.get('bankDeclaration') as FormGroup;
    if (!data) return;

    bankGroup.patchValue({
      bankDeclarationRadio: data.bankDeclarationRadio,
      bankDeclarationText: data.bankDeclarationText,
    });
  }

  private patchConsentIntermediary(data: any) {
    const consentGroup = this.formGroup.get('consentIntermediary') as FormGroup;
    if (!data) return;

    consentGroup.patchValue({
      consentIntermediaryRadio: data.consentIntermediaryRadio,
      consentIntermediaryName: data.consentIntermediaryName,
      consentIntermediaryEmail1: data.consentIntermediaryEmail1,
      consentIntermediaryEmail2: data.consentIntermediaryEmail2,
      consentIntermediaryEmail3: data.consentIntermediaryEmail3,
      consentIntermediaryMobile: data.consentIntermediaryMobile,
    });
  }

  private patchInformationOfSaSmApplicant(data: any[]) {
    const infoArray = this.formGroup.get(
      'informationOfSaSmFvciApplicant'
    ) as FormArray;
    infoArray.clear();
    data?.forEach((item) => {
      const group = this.createInformationOfSaSmFvciApplicantFormGroup();
      group.patchValue({
        name: item.name,
        relationWithApplicant: item.relationWithApplicant,
        pan: item.pan,
        nationatlity: this.findCountry(item.nationatlity),
        dateOfBirth: item.dateOfBirth ? new Date(item.dateOfBirth) : null,
        residentialAddress: item.residentialAddress,
        identityDocNumber: item.identityDocNumber,
      });
      infoArray.push(group);
    });
  }

  private patchMaterialShareholders(data: any[]) {
    const shareholderArray = this.formGroup.get(
      'materialShareholderRows'
    ) as FormArray;
    shareholderArray.clear();
    data?.forEach((item) => {
      const group = this.createShareholderFormGroup();
      group.patchValue({
        nameOfBeneficialOwner: item.nameOfBeneficialOwner,
        directIndirectStake: item.directIndirectStake,
        nameOfEntities: item.nameOfEntities,
        countryOfIncorporationOrnationality: this.findCountry(
          item.countryOfIncorporationOrnationality
        ),
        percentageStakeHeld: item.percentageStakeHeld,
        individualOrNonIndividual: item.individualOrNonIndividual,
      });
      shareholderArray.push(group);
    });
  }

  private patchBeneficialOwners(data: any[]) {
    const beneficialArray = this.formGroup.get('beneficialOwners') as FormArray;
    beneficialArray.clear();
    data?.forEach((item) => {
      const group = this.createBeneficialOwnerFormGroup();
      group.patchValue({
        nameOfBeneficialOwner: item.nameOfBeneficialOwner,
        methodOfControl: item.methodOfControl,
        countryOfIncorporation: this.findCountry(item.countryOfIncorporation),
        percentageStakeHeld: item.percentageStakeHeld,
        individualOrNonIndividual: item.individualOrNonIndividual,
      });
      beneficialArray.push(group);
    });
  }

  private findCountry(countryValue: any): any {
    if (!countryValue) return null;

    if (countryValue.short_code) {
      return this.countries.find(
        (c) => c.short_code === countryValue.short_code
      );
    }

    return this.countries.find((c) => c.name === countryValue);
  }

  initializeMasterData(): void {
    console.log('masterdata initialise', this.masterData);
    if (Array.isArray(this.masterData.country)) {
      this.countries = this.masterData.country.map((country: any) => ({
        name: country.country_name,
        code: country.country_code,
        short_code: country.country_short_code,
        id: country.country_id,
      }));
      this.countryCodes = this.countries
        .map(({ code }) => ({ code }))
        .filter((item) => item.code != null && item.code !== '');
      this.countryShortCodes = this.countries
        .map(({ short_code }) => ({ short_code }))
        .filter((item) => item.short_code != null && item.short_code !== '');
    }
  }

  subscribeToSeggregatedPortfolioRadioChanges(): void {
    const segGroup = this.formGroup.get('seggregatedPortfolio') as FormGroup;

    segGroup
      .get('seggregatedPortfolioRadio')
      ?.valueChanges.subscribe((value: boolean) => {
        console.log('Segregated Portfolio selection changed:', value);
        const signatoryRowsArray = this.formGroup.get(
          'signatoryRows'
        ) as FormArray;

        if (value === true) {
          signatoryRowsArray.controls.forEach(
            (signatoryGroup: AbstractControl, i: number) => {
              console.log(`\n---- Signatory Row [${i}] ----`);

              const signatoryGroupTyped = signatoryGroup as FormGroup;
              Object.keys(signatoryGroupTyped.controls).forEach((key) => {
                if (key === 'details') {
                  const detailsArray = signatoryGroupTyped.get(
                    key
                  ) as FormArray;

                  detailsArray.controls.forEach(
                    (control: AbstractControl, idx: number) => {
                      if (control instanceof FormControl) {
                        control.setValidators(Validators.required);
                        control.updateValueAndValidity();
                        console.log(
                          `Set validator for details[${idx}] in signatoryGroup[${i}]`
                        );
                      }
                    }
                  );
                }
                if (key === 'ownerDetails') {
                  const detailsArray = signatoryGroupTyped.get(
                    key
                  ) as FormArray;

                  detailsArray.controls.forEach(
                    (control: AbstractControl, idx: number) => {
                      console.log('control row', control);
                      const signatoryGroupOD = control as FormGroup;

                      Object.keys(signatoryGroupOD.controls).forEach((key) => {
                        const formControl = signatoryGroupOD.get(
                          key
                        ) as FormControl;

                        if (
                          formControl &&
                          [
                            'nameAddressOfBo',
                            'dateOfBirthOfBo',
                            'taxResidencyJuridiction',
                            'nationality',
                          ].includes(key)
                        ) {
                          formControl.setValidators(Validators.required);
                          formControl.updateValueAndValidity();
                          console.log(
                            `Set required validator on key: ${key} in details[${idx}]`
                          );
                        }
                      });
                    }
                  );
                }

                const control = signatoryGroupTyped.get(key);
                const value = control?.value;
                console.log(`Key: ${key}, Value:`, value);
              });
            }
          );
        } else {
          signatoryRowsArray.controls.forEach(
            (signatoryGroup: AbstractControl, i: number) => {
              const signatoryGroupTyped = signatoryGroup as FormGroup;

              Object.keys(signatoryGroupTyped.controls).forEach((key) => {
                const control = signatoryGroupTyped.get(key);

                if (key === 'details' && control instanceof FormArray) {
                  control.controls.forEach(
                    (ctrl: AbstractControl, idx: number) => {
                      if (ctrl instanceof FormControl) {
                        ctrl.clearValidators();
                        ctrl.updateValueAndValidity();
                        console.log(
                          `Cleared validators for details[${idx}] in signatoryGroup[${i}]`
                        );
                      }
                    }
                  );
                }
                if (key === 'ownerDetails') {
                  const detailsArray = signatoryGroupTyped.get(
                    key
                  ) as FormArray;

                  detailsArray.controls.forEach(
                    (control: AbstractControl, idx: number) => {
                      console.log('control row', control);
                      const signatoryGroupOD = control as FormGroup;

                      Object.keys(signatoryGroupOD.controls).forEach((key) => {
                        const formControl = signatoryGroupOD.get(
                          key
                        ) as FormControl;

                        if (
                          formControl &&
                          [
                            'nameAddressOfBo',
                            'dateOfBirthOfBo',
                            'taxResidencyJuridiction',
                            'nationality',
                          ].includes(key)
                        ) {
                          formControl.clearValidators();
                          formControl.updateValueAndValidity();
                          console.log(
                            `Set required validator on key: ${key} in details[${idx}]`
                          );
                        }
                      });
                    }
                  );
                }
              });
            }
          );
        }
      });
  }

  ngOnDestroy(): void {
    if (this.saveSubscription) {
      this.saveSubscription.unsubscribe();
    }
  }

  // New method to populate form with application data
  onFormDataChange(): void {
    this.saveApplicationService.setFormData(this.formGroup.value);
    this.progressService.updateComponentProgress(
      'annexureForm',
      this.formGroup.value,
      this.requiredMapping
    );
  }

  handleTabChange(event: any): void {
    this.activePanelIndex = event.index;
  }

  onAccordionTabChange(event: any, rowIndex: number): void {
    this.activeAccordionIndices[rowIndex] = event.index;
  }

  // Methods for Information of SaSmFvci Applicant
  get infoSaSmApplicantRows(): FormArray {
    return this.formGroup.get('informationOfSaSmFvciApplicant') as FormArray;
  }

  getInformationOfSaSmFvciApplicantFormGroup(index: number): FormGroup {
    return this.infoSaSmApplicantRows.at(index) as FormGroup;
  }

  // createInformationOfSaSmFvciApplicantFormGroup(): FormGroup {
  //   const group = new FormGroup({});
  //   this.authorizedSignatoryData.forEach((field) => {
  //     const validators = ['1', '2', '3', '4'].includes(field.id) ? Validators.required : null;
  //     group.addControl(
  //       field.id,
  //       new FormControl('', validators)
  //       // new FormControl('', null)
  //     );
  //   });
  //   return group;
  // }

  createInformationOfSaSmFvciApplicantFormGroup(): FormGroup {
    const group = new FormGroup({});
    this.authorizedSignatoryData.forEach((field) => {
      let validators = [];

      // Fields 1-4 are required
      if (
        ['name', 'relationWithApplicant', 'pan', 'nationatlity'].includes(
          field.id
        )
      ) {
        validators.push(Validators.required);
      }

      // Field 3 (PAN) gets the PAN validator
      if (field.id === 'pan') {
        validators.push(panValidator());
      }

      if (field.id === 'email') {
        validators.push(Validators.email);
      }

      group.addControl(field.id, new FormControl(null, validators));
    });
    return group;
  }

  transformToUppercase(control: AbstractControl | null): void {
    if (control && control.value) {
      control.setValue(control.value.toUpperCase(), { emitEvent: false });
    }
  }

  addInformationOfSaSmFvciApplicant(): void {
    this.infoSaSmApplicantRows.push(
      this.createInformationOfSaSmFvciApplicantFormGroup()
    );
    this.progressService.updateComponentProgress(
      'annexureForm',
      this.formGroup.value,
      this.requiredMapping
    );
    this.formGroup.markAsDirty();
  }

  removeInformationOfSaSmFvciApplicant(index: number): void {
    if (this.infoSaSmApplicantRows.length > 1) {
      this.infoSaSmApplicantRows.removeAt(index);
    }
  }

  // Signatory helper methods
  get signatoryRows(): FormArray<FormGroup> {
    return this.formGroup.get('signatoryRows') as FormArray<FormGroup>;
  }

  getSignatoryFormGroup(index: number): FormGroup {
    return this.signatoryRows.at(index);
  }

  getDetailsFormArray(rowIndex: number): FormArray {
    return this.getSignatoryFormGroup(rowIndex).get('details') as FormArray;
  }

  getDetailControl(rowIndex: number, detailIndex: number): FormControl {
    return this.getDetailsFormArray(rowIndex).at(detailIndex) as FormControl;
  }

  getAccordions(rowIndex: number): any[] {
    return (this.getSignatoryFormGroup(rowIndex).get('accordions') as FormArray)
      .controls;
  }

  addAccordion(rowIndex: number): void {
    const ownerDetails = this.getOwnerDetails(rowIndex);
    ownerDetails.push(
      new FormGroup({
        nameAddressOfBo: new FormControl(null, Validators.required),
        dateOfBirthOfBo: new FormControl(null, Validators.required),
        taxResidencyJuridiction: new FormControl(null, Validators.required),
        nationality: new FormControl(null, Validators.required),
        actingAloneOrMoreNaturalPerson: new FormControl(''),
        boGroupPercentageShareHolding: new FormControl(''),
        identityDocument: new FormControl(null),
      })
    );
    this.formGroup.markAsDirty();
  }

  removeAccordion(rowIndex: number, accordionIndex: number): void {
    const accordions = this.getSignatoryFormGroup(rowIndex).get(
      'accordions'
    ) as FormArray;
    if (accordions.length > 1) {
      accordions.removeAt(accordionIndex);
    }
  }

  removeOwner(signatoryIndex: number, ownerIndex: number): void {
    const ownerDetailsArray = this.getSignatoryFormGroup(signatoryIndex).get(
      'ownerDetails'
    ) as FormArray;
    if (ownerDetailsArray.length > 1) {
      ownerDetailsArray.removeAt(ownerIndex);
    }
  }

  // Added missing methods
  getOwnerDetails(rowIndex: number): FormArray {
    return this.getSignatoryFormGroup(rowIndex).get(
      'ownerDetails'
    ) as FormArray;
  }

  getOwnerGroups(rowIndex: number): FormGroup[] {
    return (
      this.getSignatoryFormGroup(rowIndex).get('ownerDetails') as FormArray
    ).controls as FormGroup[];
  }

  createSignatoryFormGroup(): FormGroup {
    const group = new FormGroup({
      details: new FormArray([
        // new FormControl(''),
        new FormControl(null, Validators.required),
      ]),
      // accordions: new FormArray([new FormGroup({})]),
      ownerDetails: new FormArray([]),
    });

    (group.get('ownerDetails') as FormArray).push(
      new FormGroup({
        nameAddressOfBo: new FormControl(null, Validators.required),
        dateOfBirthOfBo: new FormControl(null, Validators.required),
        taxResidencyJuridiction: new FormControl(null, Validators.required),
        nationality: new FormControl(null, Validators.required),
        actingAloneOrMoreNaturalPerson: new FormControl(null),
        boGroupPercentageShareHolding: new FormControl(null),
        identityDocument: new FormControl(null),
      })
    );

    // this.signatoryData.forEach((field: any) => {
    //   const initialValue = field.type === 'dropdown' ? null : '';
    //   const validators = null;
    //   group.addControl(field.id, new FormControl(initialValue, validators));
    // });
    return group;
  }

  addSignatory(): void {
    this.signatoryRows.push(this.createSignatoryFormGroup());
    // Push a default active index (e.g., -1 means no panel is expanded)
    this.activeAccordionIndices.push(-1);
  }

  removeSignatory(index: number): void {
    if (this.signatoryRows.length > 1) {
      this.signatoryRows.removeAt(index);
    }
  }

  // Material Shareholder (Basic Ownership) methods
  get materialShareholderRows(): FormArray<FormGroup> {
    return this.formGroup.get(
      'materialShareholderRows'
    ) as FormArray<FormGroup>;
  }

  getShareholderFormGroup(index: number): FormGroup {
    return this.materialShareholderRows.at(index);
  }

  createShareholderFormGroup(): FormGroup {
    const group = new FormGroup({});
    this.ownerFields.forEach((field) => {
      let validators = [Validators.required];

      // Add percentage validator only for the percentage field
      if (field.id === 'percentageStakeHeld') {
        validators.push(percentageValidator());
      }

      group.addControl(field.id, new FormControl(null, validators));
    });
    return group;
  }

  preventInvalidPercentageInput(event: KeyboardEvent): void {
    const input = event.target as HTMLInputElement;
    const value = input.value;
    const key = event.key;

    // Prevent typing non-numeric characters (except backspace, delete, tab, etc.)
    if (['e', 'E', '+', '-'].includes(key)) {
      event.preventDefault();
      return;
    }

    // Prevent typing if the new value would exceed 100
    if (
      value &&
      key !== 'Backspace' &&
      key !== 'Delete' &&
      key !== 'Tab' &&
      key !== '.'
    ) {
      const newValue = Number(value + key);
      if (newValue > 100) {
        event.preventDefault();
      }
    }

    // Prevent more than 2 decimal places
    if (key === '.' && value.includes('.')) {
      event.preventDefault();
      return;
    }

    if (value.includes('.')) {
      const decimalParts = value.split('.');
      if (
        decimalParts[1] &&
        decimalParts[1].length >= 2 &&
        key !== 'Backspace' &&
        key !== 'Delete'
      ) {
        event.preventDefault();
      }
    }
  }

  addShareholder(): void {
    this.materialShareholderRows.push(this.createShareholderFormGroup());
    this.formGroup.markAsDirty();
  }

  removeShareholder(index: number): void {
    if (this.materialShareholderRows.length > 1) {
      this.materialShareholderRows.removeAt(index);
    }
  }

  // Beneficial Ownership methods
  get beneficialOwners(): FormArray {
    return this.formGroup.get('beneficialOwners') as FormArray;
  }

  getBeneficialOwnerFormGroup(index: number): FormGroup {
    return this.beneficialOwners.at(index) as FormGroup;
  }

  createBeneficialOwnerFormGroup(): FormGroup {
    const group = new FormGroup({});
    this.beneficialFields.forEach((field) => {
      group.addControl(field.id, new FormControl(null));
    });
    return group;
  }

  addBeneficialOwner(): void {
    this.beneficialOwners.push(this.createBeneficialOwnerFormGroup());
    this.formGroup.markAsDirty();
  }

  removeBeneficialOwner(index: number): void {
    if (this.beneficialOwners.length > 1) {
      this.beneficialOwners.removeAt(index);
    }
  }

  // Manager methods
  get managers(): FormArray {
    return this.formGroup.get('managers') as FormArray;
  }

  getManagerFormGroup(index: number): FormGroup {
    return this.managers.at(index) as FormGroup;
  }

  createManagerFormGroup(): FormGroup {
    const group = new FormGroup({});
    this.managerFields.forEach((field) => {
      group.addControl(field.id, new FormControl(null));
    });
    return group;
  }

  addManager(): void {
    this.managers.push(this.createManagerFormGroup());
  }

  removeManager(index: number): void {
    if (this.managers.length > 1) {
      this.managers.removeAt(index);
    }
  }

  prepareIncomeDataForSave(incomeDetailsData: any): DraftFvciIncomeDetailsDto {
    // Extract selected sources of income (as an array of strings)
    const selectedSources: string[] =
      incomeDetailsData.incomeDetails.sourceOfIncome.split(',');

    // Prepare the single DTO object
    const incomeDetails: DraftFvciIncomeDetailsDto = {
      fvciApplicationId: this.applicationId,
      sourceOfIncome: selectedSources, // Now storing as an array
      codeOfBusiness: incomeDetailsData.incomeDetails.businessCode,
      grossAnnualIncome: Number(incomeDetailsData.incomeDetails.annualIncome),
      netWorth: Number(incomeDetailsData.incomeDetails.assetLess),
    };

    return incomeDetails;
  }

  sanitizePercentageInput(event: any): void {
    const input = event.target as HTMLInputElement;
    const originalValue = input.value;
    let cursor = input.selectionStart || 0;
  
    // Remove non-numeric and non-dot characters
    let cleaned = originalValue.replace(/[^0-9.]/g, '');
  
    // Only allow one decimal point
    const parts = cleaned.split('.');
    if (parts.length > 2) {
      cleaned = parts[0] + '.' + parts[1];
    }
  
    // Limit to 2 decimal places
    if (parts[1]?.length > 2) {
      cleaned = parts[0] + '.' + parts[1].slice(0, 2);
    }
  
    // Prevent value > 100
    const numericValue = parseFloat(cleaned);
    if (!isNaN(numericValue) && numericValue > 100) {
      cleaned = '100';
    }
  
    if (cleaned !== originalValue) {
      input.value = cleaned;
  
      // Recalculate and restore caret position
      const diff = originalValue.length - cleaned.length;
      const newCursor = Math.max(0, cursor - diff);
      setTimeout(() => {
        input.setSelectionRange(newCursor, newCursor);
      });
    }
  }

}
