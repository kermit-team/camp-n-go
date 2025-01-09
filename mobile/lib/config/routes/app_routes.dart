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
  reservationDetails('/reservationDetails/:reservationId'),
  contactForm('/contactForm'),
  reservationList('/reservationList');

  const AppRoutes(this.route);
  final String route;
}
