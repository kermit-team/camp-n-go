enum AppRoutes {
  home('/'),
  login('/login'),
  register('/register'),
  forgotPassword('/forgotPassword'),
  confirmAccount('/confirmAccount'),
  resetPasswordInfo('/resetPasswordInfo'),
  accountSettings('/accountSettings'),
  searchParcel('/searchParcel'),
  parcelList('/parcelList'),
  reservationSummary('/reservationSummary'),
  contactForm('/contactForm'),
  reservationList('/reservationList'),
  reservationPreview('/reservationPreview');

  const AppRoutes(this.route);
  final String route;
}
