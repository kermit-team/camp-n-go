import { Component, inject } from '@angular/core';
import { LandingPageFormComponent } from '../../components/landing-page-form/landing-page-form.component';
import { NgOptimizedImage } from '@angular/common';
import { Router, RouterLink } from '@angular/router';
import { ParcelsFacade } from '../../../parcels/services/parcels.facade';
import { PassedData } from '../../../parcels/models/parcels.interface';
import { OpenStreetMapComponent } from '../../components/open-street-map/open-street-map.component';

@Component({
  selector: 'app-landing-page',
  standalone: true,
  imports: [
    LandingPageFormComponent,
    NgOptimizedImage,
    OpenStreetMapComponent,
    RouterLink,
  ],
  templateUrl: './landing-page.component.html',
  styleUrl: './landing-page.component.scss',
})
export class LandingPageComponent {
  private router = inject(Router);
  private parcelsFacade = inject(ParcelsFacade);

  search(data: PassedData) {
    this.parcelsFacade.setPassedData(data);
    this.router.navigate(['/parcels/search']);
  }
}
