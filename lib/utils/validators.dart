class AppValidators {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (value.trim().length < 10) {
      return 'Enter a valid phone number (min 10 digits)';
    }
    return null;
  }

  static String? validateGuestCount(String? value, int maxCapacity) {
    if (value == null || value.trim().isEmpty) {
      return 'Guest count is required';
    }
    final count = int.tryParse(value.trim());
    if (count == null || count <= 0) {
      return 'Enter a valid guest count';
    }
    if (count > maxCapacity) {
      return 'Exceeds maximum venue capacity ($maxCapacity)';
    }
    return null;
  }
}
