import { ChangeDetectionStrategy, Component, OnInit } from '@angular/core';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { ReactiveFormsModule } from '@angular/forms';
import * as L from 'leaflet';

@Component({
  selector: 'app-open-street-map',
  standalone: true,
  imports: [ReactiveFormsModule, MatDatepickerModule],
  templateUrl: './open-street-map.component.html',
  styleUrl: './open-street-map.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class OpenStreetMapComponent implements OnInit {
  private map: L.Map | undefined;
  private readonly defaultCoordinates: L.LatLngExpression = [
    50.288544, 18.677176,
  ];
  private readonly zoomLevel: number = 13;

  ngOnInit(): void {
    this.initMap();
  }

  private initMap(): void {
    this.map = L.map('map', {
      center: this.defaultCoordinates,
      zoom: this.zoomLevel,
    });

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19,
    }).addTo(this.map);

    L.marker(this.defaultCoordinates)
      .addTo(this.map)
      .bindPopup('Kemping')
      .openPopup();
  }
}
