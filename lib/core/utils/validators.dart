/// Form validation helpers.
class Validators {
  Validators._();

  static final _emailRegex = RegExp(
    r'^.+@gmail\.com$',
  );

  /// Validates that the field is not empty.
  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    final requiredError = required(value, 'Email');
    if (requiredError != null) return requiredError;
    if (value!.trim().length > 23) {
      return 'Email must not exceed 23 characters';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates a password with minimum length and at least one special character.
  static String? password(String? value, {int minLength = 6}) {
    final requiredError = required(value, 'Password');
    if (requiredError != null) return requiredError;
    if (value!.length < minLength) {
      return 'Min $minLength characters';
    }
    if (value.length > 16) {
      return 'Max 16 characters';
    }
    // Check for at least one special character
    final hasSpecial = value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
    if (!hasSpecial) {
      return 'Requires special character';
    }
    return null;
  }
}
