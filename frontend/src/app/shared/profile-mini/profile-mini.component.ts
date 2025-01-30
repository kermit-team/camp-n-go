import { Component, inject, Input } from '@angular/core';
import { RouterLink } from '@angular/router';
import { AuthUser } from '../../auth/models/auth.interface';
import { NgClass } from '@angular/common';
import { AuthFacade } from '../../auth/services/auth.facade';
import { MatMenu, MatMenuItem, MatMenuTrigger } from '@angular/material/menu';

@Component({
  selector: 'app-profile-mini',
  standalone: true,
  imports: [RouterLink, NgClass, MatMenuTrigger, MatMenu, MatMenuItem],
  templateUrl: './profile-mini.component.html',
  styleUrl: './profile-mini.component.scss',
})
export class ProfileMiniComponent {
  @Input() user: AuthUser;
  @Input() isBlack: boolean;
  private authFacade = inject(AuthFacade);

  showDropdown: boolean = false;
  toggleDropdown() {
    this.showDropdown = !this.showDropdown;
  }

  logout() {
    this.authFacade.logout();
  }

  get isOwner() {
    return (
      this.user.groups.some((group) => group.name === 'Właściciel') ||
      this.user.is_superuser
    );
  }
}
