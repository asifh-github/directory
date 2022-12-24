import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ReportMainComponent } from './report-main/report-main.component';
import { ReportFormComponent } from './report-form/report-form.component';
import { ReportDeleteComponent } from './report-delete/report-delete.component';
import { ReportMoreInfoComponent } from './report-more-info/report-more-info.component';

const routes: Routes = [
  { path: "main", component: ReportMainComponent },
  { path: "create", component: ReportFormComponent },
  { path: "delete/:id", component: ReportDeleteComponent },
  { path: "moreinfo/:id", component: ReportMoreInfoComponent } 
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
