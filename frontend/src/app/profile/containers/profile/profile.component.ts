import { Component, inject } from '@angular/core';
import { ProfileCarsComponent } from '../../components/profile-cars/profile-cars.component';
import { AuthFacade } from '../../../auth/services/auth.facade';
import { AsyncPipe } from '@angular/common';
import { ProfileContentComponent } from '../../components/profile-content/profile-content.component';
import { ProfileFacade } from '../../services/profile.facade';
import { ProfileEdit } from '../../models/profile.interface';

@Component({
  selector: 'app-profile',
  standalone: true,
  imports: [ProfileCarsComponent, AsyncPipe, ProfileContentComponent],
  templateUrl: './profile.component.html',
  styleUrl: './profile.component.scss',
})
export class ProfileComponent {
  private authFacade = inject(AuthFacade);
  private profileFacade = inject(ProfileFacade);

  userData$ = this.authFacade.selectAuthenticated$();

  userChanged(user: ProfileEdit) {
    this.profileFacade.editProfile(user);
  }

  carAdded(plateNumber: string) {
    this.profileFacade.addCar(plateNumber);
  }
}
