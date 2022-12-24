import { Component, OnInit, Output, EventEmitter} from '@angular/core';
import { ReportService } from '../report.service';
import { ActivatedRoute } from '@angular/router';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-report-delete',
  templateUrl: './report-delete.component.html',
  styleUrls: ['./report-delete.component.css']
})
export class ReportDeleteComponent implements OnInit {
  index;
  reportArr;

  constructor(private rs: ReportService, private ar: ActivatedRoute, private router: Router, private http: HttpClient) { }

  ngOnInit(): void {
    this.index = this.ar.snapshot.paramMap.get('id');
  }

  onDelete(evt){
    this.onDelete_1();
  }
  onDelete_1(){
    this.reportArr = this.rs.get();
    console.log("[].length BEFORE removing: " + this.reportArr.length);
    for(let i in this.reportArr){
      this.http.delete('https://218.selfip.net/apps/x83nib2ddc/collections/myData/documents/'+ i +'/').subscribe(
        (data)=>{
          console.log(data);
        }
      )
    } 
    this.onDelete_2();
  }  
  onDelete_2(){
    this.rs.remove(this.index);
    this.reportArr = this.rs.get();
    console.log("[].length AFTER removing: " + this.reportArr.length)
    console.log(this.reportArr);
    for(let i in this.reportArr){
      this.http.post('https://218.selfip.net/apps/x83nib2ddc/collections/myData/documents/', {
        "key": i,
        "data": this.reportArr[i]
      }).subscribe(data=>{
        console.log(data);
      })
      }
      this.router.navigate(['./', 'main']);  
  }
}
