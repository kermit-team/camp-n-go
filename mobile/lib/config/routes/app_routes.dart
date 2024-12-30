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
  reservationDetails('/reservationDetails/:reservationId');

  const AppRoutes(this.route);
  final String route;
}
