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
  reservationPreview('/reservationPreview'),
  searchParcelUnauthenticated('/searchParcelUnauthenticated');

  const AppRoutes(this.route);
  final String route;
}

enum AccessLevel {
  authenticationRequired,
  noAuthenticationRequired,
  unknownRoute
}

AccessLevel getAccessLevel(AppRoutes route) {
  switch (route) {
    case AppRoutes.accountSettings:
    case AppRoutes.searchParcel:
    case AppRoutes.reservationSummary:
    case AppRoutes.reservationList:
    case AppRoutes.reservationPreview:
      return AccessLevel
          .authenticationRequired; // Requires authentication (logged in)
    case AppRoutes.home:
    case AppRoutes.parcelList:
    case AppRoutes.login:
    case AppRoutes.register:
    case AppRoutes.forgotPassword:
    case AppRoutes.confirmAccount:
    case AppRoutes.resetPasswordInfo:
    case AppRoutes.contactForm:
    case AppRoutes.searchParcelUnauthenticated:
      return AccessLevel
          .noAuthenticationRequired; // Does not require authentication (public)
    default:
      return AccessLevel.unknownRoute; // Unknown route (error)
  }
}
