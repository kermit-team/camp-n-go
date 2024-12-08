export enum AppRoutes {
  Base = '',
  Register = 'register',
  Login = 'login',
  ForgotPassword = 'forgot-password',
  AccountVerification = 'accounts/email-verification/:uidb64/:token',
  PasswordReset = 'accounts/password-reset/confirm/:uidb64/:token',
}
