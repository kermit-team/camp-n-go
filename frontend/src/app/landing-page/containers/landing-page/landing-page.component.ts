import { Component, inject } from '@angular/core';
import { LandingPageFormComponent } from '../../components/landing-page-form/landing-page-form.component';
import { NgOptimizedImage } from '@angular/common';
import { Router, RouterLink } from '@angular/router';
import { ParcelsFacade } from '../../../parcels/services/parcels.facade';
import { PassedData } from '../../../parcels/models/parcels.interface';
import { OpenStreetMapComponent } from '../../components/open-street-map/open-street-map.component';
import { ContactFormComponent } from '../../components/contact-form/contact-form.component';
import { ContactRequest } from '../../models/contact.interface';

@Component({
  selector: 'app-landing-page',
  standalone: true,
  imports: [
    LandingPageFormComponent,
    NgOptimizedImage,
    OpenStreetMapComponent,
    RouterLink,
    ContactFormComponent,
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

  sendContact(data: ContactRequest) {
    this.parcelsFacade.sendContact(data);
  }
}
