class ValidateInput {
  static String? validator(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'يرجي أدخال $fieldName';
    }
    return null;
  }
}