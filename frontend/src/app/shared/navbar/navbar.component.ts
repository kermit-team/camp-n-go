import { Component } from '@angular/core';
import {RouterLink} from '@angular/router';
import {ProfileMiniComponent} from '../profile-mini/profile-mini.component';

@Component({
  selector: 'app-navbar',
  standalone: true,
  imports: [
    RouterLink,
    ProfileMiniComponent
  ],
  templateUrl: './navbar.component.html',
  styleUrl: './navbar.component.scss'
})
export class NavbarComponent {

}
