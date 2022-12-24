import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { ReportService } from '../report.service';

@Component({
  selector: 'app-report-table',
  templateUrl: './report-table.component.html',
  styleUrls: ['./report-table.component.css']
})
export class ReportTableComponent implements OnInit {
  reportArr;

  constructor(private rs: ReportService, private ar: ActivatedRoute, private router: Router) { }

  ngOnInit(): void {
    this.reportArr = this.rs.get();
  }

}
