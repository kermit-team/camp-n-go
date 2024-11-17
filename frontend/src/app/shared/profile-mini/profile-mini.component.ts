import { Component } from '@angular/core';
import {Router, RouterLink} from '@angular/router';

@Component({
  selector: 'app-profile-mini',
  standalone: true,
  imports: [
    RouterLink
  ],
  templateUrl: './profile-mini.component.html',
  styleUrl: './profile-mini.component.scss'
})
export class ProfileMiniComponent {

  constructor( private _router: Router) {}
  showDropdown: boolean = false;
  // ngOnInit() {
  //   const userId: number | null = this._userService.getUserId();
  //   if (userId) {
  //     this._userService.getUser(userId).subscribe(
  //       (response: UserResponse) => {
  //         this.userData = response;
  //         console.log(this.isAdmin)
  //         this.isAdmin = response.groups.some(group => group.name === 'Administratorzy');
  //
  //       },
  //       (error: any) => {
  //         console.error('Error while fetching user data:', error);
  //       }
  //     );
  //   }
  // }
  // logout() {
  //   this._authService.logout();
  //   if (window.location.href === 'http://localhost:4200/') {
  //     location.reload();
  //   }
  // }
  toggleDropdown() {
    this.showDropdown = !this.showDropdown;
  }

}
