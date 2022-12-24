/// <reference types="@types/googlemaps" />
import { Component, OnInit, ViewChild, AfterViewInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Router } from '@angular/router';
import { ReportService } from '../report.service';

@Component({
  selector: 'app-report-main',
  templateUrl: './report-main.component.html',
  styleUrls: ['./report-main.component.css']
})
export class ReportMainComponent implements OnInit, AfterViewInit {
  reportArr;
  loc;
  long;
  lat;

  constructor(private rs: ReportService, private ar: ActivatedRoute, private router: Router){ }
  
  ngOnInit(){
    this.reportArr = this.rs.get();
    for(let i in this.reportArr){
      this.loc[i] = this.reportArr[i].location;
      this.long[i] = this.reportArr[i].location_long;
      this.lat[i] = this.reportArr[i].location_lat;
    }
    console.log(this.loc);
  }

  @ViewChild('gmap') gmapElement;
  map: google.maps.Map;

  ngAfterViewInit() {
    var mapProp = {
      center: new google.maps.LatLng(49.2, -123),
      zoom: 10,
      
    };
    this.map = new google.maps.Map(this.gmapElement.nativeElement, mapProp);

    // for(let i in this.reportArr){
    //   var marker = new google.maps.Marker({
    //     position: { lat: this.lat[i], lng: this.long[i]},
    //     map: this.map,
    //     title: this.loc[i]
    //   });
    // } 
  }
}
