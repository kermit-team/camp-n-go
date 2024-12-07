import { Component } from '@angular/core';
import { LandingPageFormComponent } from '../../components/landing-page-form/landing-page-form.component';
import { NgOptimizedImage } from '@angular/common';

@Component({
  selector: 'app-landing-page',
  standalone: true,
  imports: [LandingPageFormComponent, NgOptimizedImage],
  templateUrl: './landing-page.component.html',
  styleUrl: './landing-page.component.scss',
})
export class LandingPageComponent {}
