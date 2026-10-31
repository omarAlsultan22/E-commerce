class ValidateEmail {
  static String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجي أدخال البريد الإلكتروني';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'يرجي أدخال الايميل الصحيح';
    }
    return null;
  }
}