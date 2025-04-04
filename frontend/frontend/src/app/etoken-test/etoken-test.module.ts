import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';
import { EtokenTestComponent } from './etoken-test.component';

const routes: Routes = [
  { path: '', component: EtokenTestComponent },
];

@NgModule({
  declarations: [EtokenTestComponent],
  imports: [CommonModule, RouterModule.forChild(routes)],
})
export class EtokenTestModule {}
