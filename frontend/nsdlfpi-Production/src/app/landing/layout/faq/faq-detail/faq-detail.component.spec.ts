import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FaqDetailComponent } from './faq-detail.component';

describe('FaqDetailComponent', () => {
  let component: FaqDetailComponent;
  let fixture: ComponentFixture<FaqDetailComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [FaqDetailComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(FaqDetailComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
