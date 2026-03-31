import 'package:flutter/material.dart';

class Helpers {
  static void showSuccess(String title, String message) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.green,
    );
  }

  static void showError(String title, String message) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.red,
    );
  }

  static void showInfo(String title, String message) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.blue,
    );
  }

  static void _showSnackbar({
    required String title,
    required String message,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(
      navigatorKey.currentContext!,
    ).showSnackBar(
      SnackBar(
        content: Text('$title - $message'),
        backgroundColor: backgroundColor,
      ),
    );
  }

  static String safeText(dynamic value, {String fallback = '-'}) {
    if (value == null) return fallback;
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  static String formatMoney(dynamic value, {String devise = 'USD'}) {
    if (value == null) return '0 $devise';
    return '${value.toString()} $devise';
  }

  static String formatDate(dynamic value) {
    if (value == null) return '-';
    return value.toString();
  }

  static String statusLabel(String? value) {
    if (value == null || value.isEmpty) return 'Inconnu';

    switch (value.toLowerCase()) {
      case 'disponible':
        return 'Disponible';
      case 'occupe':
        return 'Occupé';
      case 'maintenance':
        return 'Maintenance';
      case 'actif':
        return 'Actif';
      case 'inactif':
        return 'Inactif';
      case 'en_attente':
        return 'En attente';
      case 'envoye':
        return 'Envoyée';
      default:
        return value;
    }
  }

  static Color statusColor(String? value) {
    if (value == null || value.isEmpty) return Colors.grey;

    switch (value.toLowerCase()) {
      case 'disponible':
      case 'actif':
      case 'payee':
      case 'envoye':
        return Colors.green;
      case 'occupe':
      case 'en_cours':
        return Colors.orange;
      case 'maintenance':
      case 'en_retard':
      case 'inactif':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();