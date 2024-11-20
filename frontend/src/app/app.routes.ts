import { Routes } from '@angular/router';
import {AppComponent} from './app.component';
import {LandingPageComponent} from './landing-page/containers/landing-page/landing-page.component';

export const routes: Routes = [
  {
    path: '',
    component: LandingPageComponent,
  }
];
