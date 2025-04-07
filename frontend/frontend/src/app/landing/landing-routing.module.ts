import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LayoutComponent } from './layout/layout.component';
import { FaqComponent } from './layout/faq/faq.component';
import { FaqDetailComponent } from './layout/faq/faq-detail/faq-detail.component';
import { CircularComponent } from './layout/circular/circular.component';
import { AnnouncementsComponent } from './layout/announcements/announcements.component';

const routes: Routes = [
  {
    path: '',
    component: LayoutComponent,
  },
  {
    path: 'faq',
    component: FaqComponent,
  },
  {
    path: 'faq/:slug',
    component: FaqDetailComponent,
  },
  {
    path: 'circular',
    component: CircularComponent,
  },
  {
    path: 'announcements',
    component: AnnouncementsComponent,
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class LandingRoutingModule {}
