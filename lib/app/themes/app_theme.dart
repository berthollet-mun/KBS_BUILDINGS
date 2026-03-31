// lib/app/themes/app_theme.dart

import 'package:flutter/material.dart';
import 'dark_theme.dart';
import 'light_theme.dart';

class AppTheme {
  static ThemeData get lightTheme => lightThemeData;
  static ThemeData get darkTheme => darkThemeData;

  // ==================== COULEURS PRINCIPALES (basées sur ton design) ====================

  // Bleu foncé principal (header, appbar, boutons principaux)
  static const Color primaryColor = Color(0xFF1A3C6E);
  // Bleu moyen (accents, liens)
  static const Color primaryLight = Color(0xFF2B5EA7);
  // Bleu très foncé (textes importants)
  static const Color primaryDark = Color(0xFF0F2847);

  // Couleur d'accent (boutons d'action, FAB)
  static const Color accentColor = Color(0xFF2196F3);

  // Couleurs de statut
  static const Color successColor = Color(0xFF27AE60);
  static const Color warningColor = Color(0xFFF39C12);
  static const Color errorColor = Color(0xFFE74C3C);
  static const Color infoColor = Color(0xFF3498DB);

  // Backgrounds
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color darkBackground = Color(0xFF0D1B2A);
  static const Color cardBackground = Colors.white;

  // Textes
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textLight = Color(0xFFBDC3C7);

  // ==================== COULEURS SPÉCIFIQUES IMMO ====================

  // Statuts des biens
  static const Color disponibleColor = Color(0xFF27AE60);
  static const Color occupeColor = Color(0xFFF39C12);
  static const Color loueColor = Color(0xFFE74C3C);
  static const Color maintenanceColor = Color(0xFFE67E22);
  static const Color venduColor = Color(0xFF95A5A6);
  static const Color reserveColor = Color(0xFF3498DB);

  // Bottom nav
  static const Color bottomNavActive = Color(0xFF1A3C6E);
  static const Color bottomNavInactive = Color(0xFF95A5A6);
  static const Color fabColor = Color(0xFF1A3C6E);

  // Cards stats dashboard
  static const Color statCardBlue = Color(0xFF1A3C6E);
  static const Color statCardGreen = Color(0xFF27AE60);
  static const Color statCardOrange = Color(0xFFF39C12);
  static const Color statCardRed = Color(0xFFE74C3C);

  // ==================== STYLES DE TEXTE ====================

  static const TextStyle headline1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: textPrimary,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle subtitle1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textPrimary,
  );

  static const TextStyle subtitle2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textSecondary,
  );

  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16,
    color: textPrimary,
  );

  static const TextStyle bodyText2 = TextStyle(
    fontSize: 14,
    color: textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: textSecondary,
  );

  static const TextStyle priceText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  static const TextStyle statNumber = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // ==================== DÉCORATIONS ====================

  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 10,
    offset: Offset(0, 2),
  );

  static const BoxShadow bottomNavShadow = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 20,
    offset: Offset(0, -5),
  );

  static BorderRadius cardBorderRadius = BorderRadius.circular(16);
  static BorderRadius buttonBorderRadius = BorderRadius.circular(12);
  static BorderRadius chipBorderRadius = BorderRadius.circular(20);
  static BorderRadius inputBorderRadius = BorderRadius.circular(12);
  static BorderRadius bottomSheetRadius = const BorderRadius.vertical(
    top: Radius.circular(24),
  );

  // Padding standard
  static const EdgeInsets screenPadding = EdgeInsets.all(16);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(vertical: 12);

  // ==================== HELPERS STATUTS BIENS ====================

  static Color getStatutBienColor(String? statut) {
    switch (statut) {
      case 'disponible':
        return disponibleColor;
      case 'occupe':
        return loueColor;
      case 'maintenance':
        return maintenanceColor;
      case 'vendu':
        return venduColor;
      case 'reserve':
        return reserveColor;
      default:
        return Colors.grey;
    }
  }

  static String getStatutBienLabel(String? statut) {
    switch (statut) {
      case 'disponible':
        return 'Disponible';
      case 'occupe':
        return 'Loué';
      case 'maintenance':
        return 'En maintenance';
      case 'vendu':
        return 'Vendu';
      case 'reserve':
        return 'Réservé';
      default:
        return 'Inconnu';
    }
  }

  static IconData getStatutBienIcon(String? statut) {
    switch (statut) {
      case 'disponible':
        return Icons.check_circle;
      case 'occupe':
        return Icons.vpn_key;
      case 'maintenance':
        return Icons.build_circle;
      case 'vendu':
        return Icons.sell;
      case 'reserve':
        return Icons.bookmark;
      default:
        return Icons.help_outline;
    }
  }

  // ==================== HELPERS TYPES DE BIEN ====================

  static IconData getTypeBienIcon(String? type) {
    switch (type) {
      case 'maison':
        return Icons.home;
      case 'appartement':
        return Icons.apartment;
      case 'parcelle':
        return Icons.landscape;
      case 'bureau':
        return Icons.business;
      default:
        return Icons.domain;
    }
  }

  static String getTypeBienLabel(String? type) {
    switch (type) {
      case 'maison':
        return 'Maison';
      case 'appartement':
        return 'Appartement';
      case 'parcelle':
        return 'Parcelle';
      case 'bureau':
        return 'Bureau';
      default:
        return 'Autre';
    }
  }

  // ==================== HELPERS PAIEMENT ====================

  static IconData getModePaiementIcon(String? mode) {
    switch (mode) {
      case 'cash':
        return Icons.payments;
      case 'mobile_money':
        return Icons.phone_android;
      case 'banque':
        return Icons.account_balance;
      default:
        return Icons.payment;
    }
  }

  static String getModePaiementLabel(String? mode) {
    switch (mode) {
      case 'cash':
        return 'Espèces';
      case 'mobile_money':
        return 'Mobile Money';
      case 'banque':
        return 'Virement bancaire';
      default:
        return 'Autre';
    }
  }

  // ==================== HELPERS PRIORITÉ MAINTENANCE ====================

  static Color getPrioriteColor(String? priorite) {
    switch (priorite) {
      case 'urgente':
        return errorColor;
      case 'haute':
        return warningColor;
      case 'moyenne':
        return infoColor;
      case 'faible':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  static String getPrioriteLabel(String? priorite) {
    switch (priorite) {
      case 'urgente':
        return 'Urgente';
      case 'haute':
        return 'Haute';
      case 'moyenne':
        return 'Normale';
      case 'faible':
        return 'Faible';
      default:
        return 'Inconnu';
    }
  }

  // ==================== HELPERS STATUT MAINTENANCE ====================

  static Color getStatutMaintenanceColor(String? statut) {
    switch (statut) {
      case 'en_attente':
        return warningColor;
      case 'assignee':
        return infoColor;
      case 'en_cours':
        return primaryLight;
      case 'terminee':
        return successColor;
      case 'annulee':
        return errorColor;
      default:
        return Colors.grey;
    }
  }

  static String getStatutMaintenanceLabel(String? statut) {
    switch (statut) {
      case 'en_attente':
        return 'En attente';
      case 'assignee':
        return 'Assignée';
      case 'en_cours':
        return 'En cours';
      case 'terminee':
        return 'Terminée';
      case 'annulee':
        return 'Annulée';
      default:
        return 'Inconnu';
    }
  }

  // ==================== HELPERS ÉCHÉANCES ====================

  static Color getStatutEcheanceColor(String? statut) {
    switch (statut) {
      case 'payee':
        return successColor;
      case 'partielle':
        return warningColor;
      case 'en_retard':
        return errorColor;
      case 'a_venir':
        return infoColor;
      default:
        return Colors.grey;
    }
  }

  static String getStatutEcheanceLabel(String? statut) {
    switch (statut) {
      case 'payee':
        return 'Payée';
      case 'partielle':
        return 'Payé partiellement';
      case 'en_retard':
        return 'En retard';
      case 'a_venir':
        return 'À venir';
      default:
        return 'Inconnu';
    }
  }

  // ==================== HELPERS CONTRAT ====================

  static Color getStatutContratColor(String? statut) {
    switch (statut) {
      case 'actif':
        return successColor;
      case 'expire':
        return warningColor;
      case 'resilie':
        return errorColor;
      default:
        return Colors.grey;
    }
  }

  // ==================== HELPERS TYPE PANNE MAINTENANCE ====================

  static IconData getTypePanneIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'plomberie':
      case 'fuite d\'eau':
        return Icons.water_drop;
      case 'electricité':
      case 'électricité':
        return Icons.electrical_services;
      case 'climatisation':
        return Icons.ac_unit;
      case 'serrure':
      case 'serrurerie':
        return Icons.lock;
      case 'peinture':
        return Icons.format_paint;
      default:
        return Icons.build;
    }
  }

  // ==================== DÉCORATION STAT CARD (Dashboard) ====================

  static BoxDecoration statCardDecoration(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}