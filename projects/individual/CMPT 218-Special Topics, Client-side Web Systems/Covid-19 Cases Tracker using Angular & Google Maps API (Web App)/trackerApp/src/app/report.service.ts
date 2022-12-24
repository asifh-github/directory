import { Injectable } from '@angular/core';
import { ReportMoreInfoComponent } from './report-more-info/report-more-info.component';

@Injectable({
  providedIn: 'root'
})
export class ReportService{
  private reportArray;
  private static uniqueID = 0;

  constructor(){
    
    this.reportArray = [];
  }
  public getId(){
    return ReportService.uniqueID;
  }
  public get(){
    return this.reportArray;
  }
  public add(report){
    report.id = ReportService.uniqueID;
    ReportService.uniqueID++;
    this.reportArray.push(report);
  }
  public remove(index){
    this.reportArray.splice(index, 1);
  }
  public info(index){
    return this.reportArray[index];
  }
}
