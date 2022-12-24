import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { ReportFormComponent } from './report-form/report-form.component';
import { ReportDeleteComponent } from './report-delete/report-delete.component';
import { ReportMoreInfoComponent } from './report-more-info/report-more-info.component';
import { ReportMainComponent } from './report-main/report-main.component';
import { ReportTableComponent } from './report-table/report-table.component';

@NgModule({
  declarations: [
    AppComponent,
    ReportFormComponent,
    ReportDeleteComponent,
    ReportMoreInfoComponent,
    ReportMainComponent,
    ReportTableComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    ReactiveFormsModule,
    HttpClientModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
