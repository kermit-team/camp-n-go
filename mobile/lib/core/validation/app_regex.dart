class AppRegex {
  static RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static RegExp passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[()\[\]{}|\\`~!@#$%^&*_\-+=;:,<>./?]).{9,}$');
  static final numberRegex = RegExp(r'^[0-9]+$');
}
