import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl, Validators} from '@angular/forms';
import { ActivatedRoute } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { ReportService } from '../report.service';

@Component({
  selector: 'app-report-form',
  templateUrl: './report-form.component.html',
  styleUrls: ['./report-form.component.css']
})
export class ReportFormComponent implements OnInit {
  form: FormGroup;
  locationOptionSelected: string;
  locationSelected: string;


  constructor(private ar: ActivatedRoute, private http: HttpClient, private router: Router, private rs: ReportService) { }

  ngOnInit(): void {
    this.form = new FormGroup({
      location: new FormControl(''),
      location_long: new FormControl(''),
      location_lat: new FormControl(''),
      date: new FormControl(''),
      name: new FormControl('', Validators.required),
      phone: new FormControl(''),
      notes: new FormControl('')
    })
  }
  locationOptions(s: string): void{
    this.locationOptionSelected = s;
  }
  locationIsNew(s: string): boolean{
    if(!this.locationOptionSelected){
      return false;
    }
    return (this.locationOptionSelected === s);
  }
  onCreate(report: any): void{
    this.rs.add(report);
    console.log(this.rs);
    this.http.post('https://218.selfip.net/apps/x83nib2ddc/collections/myData/documents/', {
      "key": this.rs.getId()-1,
      "data": report
    }).subscribe(data=>{
      console.log(data);
    })
    this.router.navigate(['./main']);
  }
  location(s: string){
    this.locationSelected = s;

    }
  isMetrotown(s: string){
    if(!this.locationSelected){
      return false;
    }
    return (this.locationOptionSelected === s);
  }
  isUBC(s: string){
    if(!this.locationSelected){
      return false;
    }
    return (this.locationOptionSelected === s);
  }
  isBurnaby(s: string){
    if(!this.locationSelected){
      return false;
    }
    return (this.locationOptionSelected === s);
  }
  isSurrey(s: string){
    if(!this.locationSelected){
      return false;
    }
    return (this.locationOptionSelected === s);
  }
  isDowntown(s: string){
    if(!this.locationSelected){
      return false;
    }
    return (this.locationOptionSelected === s);
  }
}
