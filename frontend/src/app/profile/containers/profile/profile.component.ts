import { Component, inject, OnDestroy } from '@angular/core';
import { ProfileCarsComponent } from '../../components/profile-cars/profile-cars.component';
import { AuthFacade } from '../../../auth/services/auth.facade';
import { AsyncPipe } from '@angular/common';
import { ProfileContentComponent } from '../../components/profile-content/profile-content.component';
import { ProfileFacade } from '../../services/profile.facade';
import { ProfileEdit } from '../../models/profile.interface';
import { ButtonComponent } from '../../../shared/components/button/button.component';
import { Subscription } from 'rxjs';
import { MatDialog } from '@angular/material/dialog';
import { ConfirmationDialogComponent } from '../../../shared/components/confirmation-dialog/confirmation-dialog.component';

@Component({
  selector: 'app-profile',
  standalone: true,
  imports: [
    ProfileCarsComponent,
    AsyncPipe,
    ProfileContentComponent,
    ButtonComponent,
  ],
  templateUrl: './profile.component.html',
  styleUrl: './profile.component.scss',
})
export class ProfileComponent implements OnDestroy {
  private authFacade = inject(AuthFacade);
  private profileFacade = inject(ProfileFacade);
  private dialog = inject(MatDialog);

  subscription: Subscription;

  userData$ = this.authFacade.selectAuthenticated$();

  userChanged(user: ProfileEdit) {
    this.profileFacade.editProfile(user);
  }

  carAdded(plateNumber: string) {
    this.profileFacade.addCar(plateNumber);
  }

  anonimise() {
    const dialogRef = this.dialog.open(ConfirmationDialogComponent, {
      width: '350px',
    });

    this.subscription = dialogRef.componentInstance.accepted.subscribe(() => {
      this.profileFacade.anonimise();
    });
  }

  ngOnDestroy() {
    this.subscription.unsubscribe();
  }
}
