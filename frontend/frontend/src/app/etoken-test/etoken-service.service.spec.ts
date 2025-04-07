import { TestBed } from '@angular/core/testing';

import { ETokenServiceService } from './etoken-service.service';

describe('ETokenServiceService', () => {
  let service: ETokenServiceService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ETokenServiceService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
