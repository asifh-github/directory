import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ReportMoreInfoComponent } from './report-more-info.component';

describe('ReportMoreInfoComponent', () => {
  let component: ReportMoreInfoComponent;
  let fixture: ComponentFixture<ReportMoreInfoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ReportMoreInfoComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ReportMoreInfoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
