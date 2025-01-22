import { Routes } from '@angular/router';
import { AppRoutes } from './shared/routes.enum';
import { RegisterComponent } from './auth/containers/register/register.component';
import { LandingPageComponent } from './landing-page/containers/landing-page/landing-page.component';
import { LoginComponent } from './auth/containers/login/login.component';
import { ForgotPasswordComponent } from './auth/containers/forgot-password/forgot-password.component';
import { EmailVerificationComponent } from './auth/containers/email-verifivation/email-verification.component';
import { emailVerificationResolver } from './auth/resolvers/email-verification.resolver';
import { PasswordResetComponent } from './auth/containers/password-reset/password-reset.component';
import { ProfileComponent } from './profile/containers/profile/profile.component';
import { ParcelSearchComponent } from './parcels/containers/parcel-search/parcel-search.component';
import { ReservationCreateComponent } from './parcels/containers/reservation-create/reservation-create.component';
import { PaymentComponent } from './payment/containers/payment/payment.component';
import { ReservationsComponent } from './reservations/containers/reservations/reservations.component';
import { ReservationEditComponent } from './reservations/containers/reservation-edit/reservation-edit.component';
import { reservationDetailsResolver } from './reservations/resolvers/reservation-details.resolver';

export const routes: Routes = [
  {
    path: AppRoutes.Register,
    component: RegisterComponent,
  },
  {
    path: AppRoutes.Login,
    component: LoginComponent,
  },
  {
    path: AppRoutes.ForgotPassword,
    component: ForgotPasswordComponent,
  },
  {
    path: AppRoutes.AccountVerification,
    component: EmailVerificationComponent,
    resolve: {
      emailVerification: emailVerificationResolver,
    },
  },
  {
    path: AppRoutes.PasswordReset,
    component: PasswordResetComponent,
  },
  {
    path: AppRoutes.Profile,
    component: ProfileComponent,
  },
  {
    path: AppRoutes.ParcelSearch,
    component: ParcelSearchComponent,
  },
  {
    path: AppRoutes.ReservationCreate,
    component: ReservationCreateComponent,
  },
  {
    path: AppRoutes.Reservations,
    component: ReservationsComponent,
  },
  {
    path: AppRoutes.ReservationsEdit,
    component: ReservationEditComponent,
    resolve: {
      reservationDetails: reservationDetailsResolver,
    },
  },
  {
    path: AppRoutes.Payment,
    children: [
      {
        path: AppRoutes.Success,
        component: PaymentComponent,
      },
      {
        path: AppRoutes.Cancel,
        component: PaymentComponent,
      },
    ],
  },
  {
    path: '',
    component: LandingPageComponent,
  },
  {
    path: '**',
    redirectTo: '/',
  },
];
