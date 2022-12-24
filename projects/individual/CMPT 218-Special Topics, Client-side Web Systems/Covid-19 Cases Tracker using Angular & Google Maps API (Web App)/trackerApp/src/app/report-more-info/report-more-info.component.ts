import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { ReportService } from '../report.service';

@Component({
  selector: 'app-report-more-info',
  templateUrl: './report-more-info.component.html',
  styleUrls: ['./report-more-info.component.css']
})
export class ReportMoreInfoComponent implements OnInit {
  index;
  report;

  constructor(private rs: ReportService, private ar: ActivatedRoute) { }

  ngOnInit(): void {
    this.index = this.ar.snapshot.paramMap.get('id');
    this.report = this.rs.info(this.index);
  } 
}
