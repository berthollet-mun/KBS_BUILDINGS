class Validators {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est requis';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'L\'email est requis';
    }

    final emailRegex = RegExp(
      r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Adresse email invalide';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le mot de passe est requis';
    }

    if (value.trim().length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }

    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le téléphone est requis';
    }

    if (value.trim().length < 8) {
      return 'Numéro de téléphone invalide';
    }

    return null;
  }

  static String? validateDouble(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    if (parsed == null) {
      return '$fieldName doit être un nombre valide';
    }
    return null;
  }

  static String? validateInt(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = int.tryParse(value);
    if (parsed == null) {
      return '$fieldName doit être un entier valide';
    }
    return null;
  }
}