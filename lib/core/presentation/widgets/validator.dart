String? validator(String value, String fieldName, {String? newPassword}) {
  if (value.isEmpty) {
    return 'يرجي أدخال $fieldName';
  }
  if (fieldName == 'email' && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'يرجي أدخال الايميل الصحيح';
  }
  if (fieldName == 'new password again' && value != newPassword) {
    return 'كلمتان المرور غير متطابقتان';
  }
  return null;
}