import { Component, Input } from '@angular/core';
import { RouterLink } from '@angular/router';
import { ProfileMiniComponent } from '../profile-mini/profile-mini.component';
import { AuthUser } from '../../auth/models/auth.interface';

@Component({
  selector: 'app-navbar',
  standalone: true,
  imports: [RouterLink, ProfileMiniComponent],
  templateUrl: './navbar.component.html',
  styleUrl: './navbar.component.scss',
})
export class NavbarComponent {
  @Input() authUser: AuthUser;
}
