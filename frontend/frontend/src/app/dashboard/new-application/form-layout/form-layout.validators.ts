import { AbstractControl, FormArray, ValidationErrors, ValidatorFn, Validators } from "@angular/forms";


export const atLeastTwoFieldsRequiredValidator = (): ValidatorFn => {
  // console.log("atLeastTwoFieldsRequiredValidator")
      return (group: AbstractControl): ValidationErrors | null => {
        const flatNum = group.get('registeredFlatNum')?.value;
        const buildingName = group.get('registeredBuildingName')?.value;
        const roadName = group.get('registeredRoadName')?.value;
        const areaName = group.get('registeredAreaName')?.value;
  
        let filledCount = 0;
  
        if (flatNum && flatNum.trim() !== '') filledCount++;
        if (buildingName && buildingName.trim() !== '') filledCount++;
        if (roadName && roadName.trim() !== '') filledCount++;
        if (areaName && areaName.trim() !== '') filledCount++;
        // const notApplicable = group.get('notApplicableResidence')?.value;
        // const zip = group.get('registeredZipName');

        // if (notApplicable) {
        //   zip?.clearValidators(); // make it optional
        //   zip?.setValue('N/A');
        //   zip?.disable();
          
        // } else {
        //   zip?.setValidators([Validators.required]);
        //   zip?.setValue('');
        // }
        // zip?.updateValueAndValidity({ onlySelf: true });
        
        return filledCount >= 2 ? null : { atLeastTwoFieldsRequired: true };
      };
    }
  
    export const atLeastTwoFieldsRequiredFValidator = (): ValidatorFn => {
      return (group: AbstractControl): ValidationErrors | null => {
        const flatNum = group.get('foreignFlatNum')?.value;
        const buildingName = group.get('foreignBuildingName')?.value;
        const roadName = group.get('foreignRoadName')?.value;
        const areaName = group.get('foreignAreaName')?.value;
  
        let filledCount = 0;
  
        if (flatNum && flatNum.trim() !== '') filledCount++;
        if (buildingName && buildingName.trim() !== '') filledCount++;
        if (roadName && roadName.trim() !== '') filledCount++;
        if (areaName && areaName.trim() !== '') filledCount++;

        // const notApplicable = group.get('notApplicableIndOffice')?.value;
        // const zip = group.get('indianZipName');

        // if (notApplicable) {
        //   zip?.clearValidators(); // make it optional
        //   zip?.setValue('N/A');
        //   zip?.disable();
          
        // } else {
        //   zip?.setValidators([Validators.required]);
        //   zip?.setValue('');
        // }
        // zip?.updateValueAndValidity({ onlySelf: true });
  
        return filledCount >= 2 ? null : { atLeastTwoFieldsRequiredF: true };
      };
    }
  
    export const atLeastTwoFieldsRequiredIValidator = (): ValidatorFn => {
      let filledCount = 0;
      return (group: AbstractControl): ValidationErrors | null => {
        const flatNum = group.get('indianFlatNum')?.value;
        const buildingName = group.get('indianBuildingName')?.value;
        const roadName = group.get('indianRoadName')?.value;
        const areaName = group.get('indianAreaName')?.value;
  
        if (flatNum && flatNum.trim() !== '') filledCount++;
  
        if (buildingName && buildingName.trim() !== '') filledCount++;
  
        if (roadName && roadName.trim() !== '') filledCount++;
  
        if (areaName && areaName.trim() !== '') filledCount++;

        // const notApplicable = group.get('notApplicableForeignOffice')?.value;
        // const zip = group.get('foreignZipName');

        // if (notApplicable) {
        //   zip?.clearValidators(); // make it optional
        //   zip?.setValue('N/A');
        //   zip?.disable();
          
        // } else {
        //   zip?.setValidators([Validators.required]);
        //   zip?.setValue('');
        // }
        // zip?.updateValueAndValidity({ onlySelf: true });
  
        return filledCount >= 2 ? null : { atLeastTwoFieldsRequiredI: true };
      };
    }

export const leiValidator = (): ValidatorFn => {
  return (control: AbstractControl): ValidationErrors | null => {
    const value = control.value;

    if (!value) return null; // Skip if empty, let 'required' handle it

    const alphanumericRegex = /^[a-zA-Z0-9]+$/;

    if (value.length !== 20) {
      return { invalidLength: true };
    }

    if (!alphanumericRegex.test(value)) {
      return { invalidCharacters: true };
    }

    return null; // Valid
  };
}

export const urlValidator = (): ValidatorFn => {
  return (control: AbstractControl): ValidationErrors | null => {
    const urlPattern =
      /^(https?:\/\/)?([\w\-]+\.)+[\w\-]{2,}(\/[\w\-._~:/?#[\]@!$&'()*+,;=]*)?$/i;

    if (!control.value) return null; // Let required validator handle empty

    return urlPattern.test(control.value) ? null : { invalidUrl: true };
  };
}

export const taxResidencyRowsRequiredValidator = (): ValidatorFn => {
  return (control: AbstractControl): ValidationErrors | null => {
    const formArray = control as FormArray;
    return formArray && formArray.length > 0 ? null : { required: true };
  };
}

/**
 * Validates that if "otherNameRadio" is true, then "otherNameField" must be filled.
 */
export const otherNameConditionalValidator = (): ValidatorFn => {
  return (group: AbstractControl): ValidationErrors | null => {
    const radioControl = group.get('otherNameRadio');
    const fieldControl = group.get('otherNameField');

    if (radioControl && fieldControl) {
      if (radioControl.value === true && !fieldControl.value) {
        return { otherNameRequired: true }; // Custom error key
      }
    }

    return null;
  }
}


  export const conditionalCountryValidator: ValidatorFn = (group: AbstractControl): ValidationErrors | null => {
    const trcNo = group.get('trcNo')?.value;
    const country = group.get('country')?.value;
  
    if (trcNo && !country) {
      return { countryRequired: true }; // Custom error key
    }
  
    return null; // No errors
  }


  export const assetAndDateValidator = (): ValidatorFn => {
    return (group: AbstractControl): ValidationErrors | null => {
      const assetLess = group.get('assetLess')?.value;
      const asOnDate = group.get('asOnDate')?.value;
  
      const assetFilled = assetLess !== null && assetLess !== '';
      const dateFilled = asOnDate !== null && asOnDate !== '';
  
      if ((assetFilled && !dateFilled) || (!assetFilled && dateFilled)) {
        return { assetDateMismatch: true };
      }
  
      return null;
    };
  };

  export const applicantTypeOtherValidator = (): ValidatorFn => {
    return (group: AbstractControl): ValidationErrors | null => {
      const name = group.get('applicantTypeName')?.value;
      const other = group.get('applicantTypeOtherEntity')?.value;
  
      if (name === 'TA6' && (!other || other.trim() === '')) {
        group.get('applicantTypeOtherEntity')?.setErrors({ required: true });
        return { otherRequired: true };
      }
  
      // Clear any existing error when not TA6 or valid value
      if (name !== 'TA6') {
        group.get('applicantTypeOtherEntity')?.setErrors(null);
      }
  
      return null;
    };
  }

  export function priorAssociationRowsRequiredValidator(): (control: AbstractControl) => ValidationErrors | null {
    return (control: AbstractControl): ValidationErrors | null => {
      const parent = control.parent;
      const priorRadio = parent?.get('priorAssociationRadio')?.value;
  
      if (priorRadio === true && control instanceof Array && control.length === 0) {
        return { priorAssociationRowsRequired: true };
      }
  
      return null;
    };
  }

  export const hasPanConditionalValidator = (): ValidatorFn => {
    return (group: AbstractControl): ValidationErrors | null => {
      const hasPan = group.get('hasPanRadio')?.value;
      const panNumber = group.get('hasPanNumber')?.value;
  
      if (hasPan === true && (!panNumber || panNumber.trim() === '')) {
        return { panNumberRequired: true };
      }
      return null;
    };
  };

  export const disciplinaryHistoryConditionalValidator = (): ValidatorFn => {
    return (group: AbstractControl): ValidationErrors | null => {
      const hasHistory = group.get('disciplinaryHistoryRadio')?.value;
      const text = group.get('disciplinaryHistoryText')?.value;
  
      if (hasHistory === true && (!text || text.trim() === '')) {
        return { disciplinaryTextRequired: true };
      }
  
      return null;
    };
  }


/**
 * Helper to check if a control has the 'required' validator.
 */
export const hasRequiredValidator = (
  control: AbstractControl | null
): boolean => {
  if (!control?.validator) return false;
  const validatorResult = control.validator({} as AbstractControl);
  return validatorResult !== null && validatorResult['required'] !== undefined;
};

export const dateCommencementValidator: ValidatorFn = (
  control: AbstractControl
): ValidationErrors | null => {
  const dateOfIncorporation = control.get('dateOfIncorporation')?.value;
  const dateOfCommencement = control.get('dateOfCommencement')?.value;

  if (
    dateOfIncorporation &&
    dateOfCommencement &&
    new Date(dateOfCommencement) > new Date(dateOfIncorporation)
  ) {
    return { commencementAfterIncorporation: true };
  }

  return null;
};

export const panValidator = (): ValidatorFn => {
  return (control: AbstractControl): ValidationErrors | null => {
    const value = control.value;
    if (!value) return null; 

    // PAN regex: 10 alphanumeric characters
    const panRegex = /^[A-Z]{5}[0-9]{4}[A-Z]$/;

    if (!panRegex.test(value)) {
      return { invalidPan: true };
    }

    return null; 
  };
};

export const percentageValidator = (): ValidatorFn => {
  return (control: AbstractControl): ValidationErrors | null => {
    const value = control.value;
    if (value === null || value === undefined || value === '') {
      return null; 
    }

    // Check if it's a valid number
    if (isNaN(value)) {
      return { invalidNumber: true };
    }

    const numValue = Number(value);
    
    // Check range
    if (numValue < 0 || numValue > 100) {
      return { invalidPercentage: true };
    }
    
    // Check decimal places
    const decimalParts = value.toString().split('.');
    if (decimalParts.length > 1 && decimalParts[1].length > 2) {
      return { invalidDecimalPlaces: true };
    }

    return null;
  };

};

export function allowPANEntry(event: KeyboardEvent, inputValue: string) {
  const key = event.key;

  // Allow backspace, delete, arrow keys, and tab for usability
  if (
    ['Backspace', 'Delete', 'ArrowLeft', 'ArrowRight', 'Tab'].includes(key)
  ) {
    return;
  }

  // Enforce PAN format structure: AAAAA9999A
  if (inputValue.length < 5) {
    // First 5 characters must be uppercase letters
    if (!/^[A-Z]$/.test(key)) {
      event.preventDefault();
    }
  } else if (inputValue.length < 9) {
    // Next 4 characters must be numbers
    if (!/^[0-9]$/.test(key)) {
      event.preventDefault();
    }
  } else if (inputValue.length === 9) {
    // Last character must be an uppercase letter
    if (!/^[A-Z]$/.test(key)) {
      event.preventDefault();
    }
  } else {
    // Prevent input if length exceeds 10
    event.preventDefault();
  }
};


