import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EtokenTestComponent } from './etoken-test.component';

describe('EtokenTestComponent', () => {
  let component: EtokenTestComponent;
  let fixture: ComponentFixture<EtokenTestComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [EtokenTestComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(EtokenTestComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
