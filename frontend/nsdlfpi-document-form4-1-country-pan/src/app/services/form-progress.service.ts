import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

interface ProgressData {
  filled: number;
  total: number;
}

@Injectable({
  providedIn: 'root',
})
export class FormProgressService {
  private readonly progressSubject = new BehaviorSubject<number>(0);
  progress$ = this.progressSubject.asObservable();

  private componentProgress: { [componentName: string]: ProgressData } = {};

  updateComponentProgress(
    componentName: string,
    formData: any,
    requiredMapping: { [key: string]: any }
  ): string[] {
    // const missingFields = this.validateRequiredFields(formData, requiredMapping);
    
    // if (missingFields.length > 0) {
    //   console.error('Required fields not filled:', missingFields);
    //   return missingFields; // Return missing fields for validation handling
    // }

    const { filled, total } = this.calculateProgress(formData, requiredMapping);
    this.componentProgress[componentName] = { filled, total };
    this.updateOverallProgress();
    
    return [];
  }

  private calculateProgress(
    formData: any,
    requiredMapping: { [key: string]: any }
  ): { filled: number; total: number } {
    let filled = 0;
    let total = 0;

    Object.keys(requiredMapping).forEach((field) => {
      const mapping = requiredMapping[field];
      
      if (Array.isArray(mapping)) {
        if (mapping.length === 1 && mapping[0] === '') {
          total++;
          if (this.isFilled(formData[field])) filled++;
        } else {
          mapping.forEach((subField: string) => {
            total++;
            if (formData[field] && this.isFilled(formData[field][subField])) filled++;
          });
        }
      } else if (mapping && typeof mapping === 'object') {
        if (mapping.fields && Array.isArray(mapping.fields)) {
          mapping.fields.forEach((subField: string) => {
            total++;
            if (formData[field] && this.isFilled(formData[field][subField])) filled++;
          });
          
          if (
            mapping.conditional &&
            typeof mapping.conditional === 'object' &&
            typeof mapping.conditional.condition === 'function'
          ) {
            const condition = mapping.conditional.condition;
            const conditionalField = mapping.conditional.field;
            const triggerValue = formData[field]?.[mapping.fields[0]] || null;
            if (condition(triggerValue)) {
              total++;
              if (formData[field] && this.isFilled(formData[field][conditionalField])) filled++;
            }
          }
        }
      }
    });

    return { filled, total };
  }

  private validateRequiredFields(formData: any, requiredMapping: { [key: string]: any }): string[] {
    let missingFields: string[] = [];
  
    Object.keys(requiredMapping).forEach((field) => {
      const mapping = requiredMapping[field];
  
      if (Array.isArray(mapping)) {
        if (mapping.length === 1 && mapping[0] === '' && !this.isFilled(formData[field])) {
          missingFields.push(field);
        } else {
          mapping.forEach((subField: string) => {
            if (!formData[field] || !this.isFilled(formData[field][subField])) {
              missingFields.push(`${field}.${subField}`);
            }
          });
        }
      } else if (mapping && typeof mapping === 'object') {
        if (mapping.fields && Array.isArray(mapping.fields)) {
          mapping.fields.forEach((subField: string) => {
            if (!formData[field] || !this.isFilled(formData[field][subField])) {
              missingFields.push(`${field}.${subField}`);
            }
          });
        }
      }
    });
  
    return missingFields;
  }
  

  private isFilled(value: any): boolean {
    if (value === null || value === undefined) return false;
    if (typeof value === 'string' && value.trim().length === 0) return false;
    if (typeof value === 'boolean') return value === true;
    return true;
  }

  updateOverallProgress(reset: boolean = false): void {
    if (reset) {
      this.progressSubject.next(0);
      return;
    }

    let totalFilled = 0;
    let totalRequired = 0;

    Object.values(this.componentProgress).forEach((progress) => {
      totalFilled += progress.filled;
      totalRequired += progress.total;
    });

    const overallPercentage = totalRequired > 0 ? Math.round((totalFilled / totalRequired) * 100) : 100;
    this.progressSubject.next(overallPercentage);
  }

  resetProgress(): void {
    this.componentProgress = {};
    this.updateOverallProgress(true);
  }
}
