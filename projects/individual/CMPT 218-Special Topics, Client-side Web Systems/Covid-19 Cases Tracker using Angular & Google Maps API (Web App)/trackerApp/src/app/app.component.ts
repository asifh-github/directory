import { Component, OnInit} from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { ReportService } from './report.service';

@Component({
  selector: 'app-root-tracker',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit{
  title = 'trackerApp';

  constructor(private rs: ReportService, private http: HttpClient, private router: Router){ 
  }

  ngOnInit(){
    this.http.get<Object>('https://218.selfip.net/apps/x83nib2ddc/collections/myData/documents/').subscribe(
      (dataStore)=>{
        console.log(dataStore);
        for(let i in dataStore){
          this.rs.add(dataStore[i].data);
        }
        console.log(this.rs.get());
      }
    )
    this.router.navigate(['/main']);
  }
}
