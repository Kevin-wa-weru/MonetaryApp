class Misc {
  static String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Email is empty';
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return 'Invalid Email';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value!.isEmpty) {
      return 'phone number is empty';
    } else if (!RegExp(r"(^(?:[+0]9)?[0-9]{10,12}$)").hasMatch(value)) {
      return 'Invalid phone number';
    }
    return null;
  }
  
}