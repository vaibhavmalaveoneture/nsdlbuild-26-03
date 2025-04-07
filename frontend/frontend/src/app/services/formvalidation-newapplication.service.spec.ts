import { TestBed } from '@angular/core/testing';

import { FormvalidationNewapplicationService } from './formvalidation-newapplication.service';

describe('FormvalidationNewapplicationService', () => {
  let service: FormvalidationNewapplicationService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(FormvalidationNewapplicationService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
