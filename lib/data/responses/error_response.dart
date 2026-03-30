class ErrorResponse {
  final bool success;
  final String message;
  final List<String>? errors;

  ErrorResponse({
    required this.success,
    required this.message,
    this.errors,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Erreur inconnue',
      errors: json['errors'] != null
          ? List<String>.from(json['errors'])
          : null,
    );
  }

  String get firstError {
    if (errors != null && errors!.isNotEmpty) {
      return errors!.first;
    }
    return message;
  }

  String get allErrors {
    if (errors != null && errors!.isNotEmpty) {
      return errors!.join('\n');
    }
    return message;
  }
}