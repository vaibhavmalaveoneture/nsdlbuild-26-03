import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ApplicationEsignComponent } from './application-esign.component';

describe('ApplicationEsignComponent', () => {
  let component: ApplicationEsignComponent;
  let fixture: ComponentFixture<ApplicationEsignComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ApplicationEsignComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ApplicationEsignComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
