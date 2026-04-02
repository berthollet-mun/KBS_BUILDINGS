// lib/views/public/welcome/welcome_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../app/themes/app_theme.dart';
import '../../../core/services/storage_service.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A3C6E),
              Color(0xFF0F2847),
              Color(0xFF0A1E3D),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // ── LOGO / ICÔNE MAISON ──
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.home_work_rounded,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── TITRE ──
                  const Text(
                    'GESTION IMMO',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'INTELLIGENTE',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Colors.white.withOpacity(0.85),
                      letterSpacing: 4,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Votre plateforme complète\nde gestion immobilière',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.65),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ── GRID ACTIONS RAPIDES ──
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.0,
                    children: [
                      _buildQuickAction(
                        icon: Icons.apartment_rounded,
                        label: 'Mes Biens',
                        color: const Color(0xFF2196F3),
                      ),
                      _buildQuickAction(
                        icon: Icons.payments_rounded,
                        label: 'Loyers',
                        color: const Color(0xFF27AE60),
                      ),
                      _buildQuickAction(
                        icon: Icons.map_rounded,
                        label: 'Carte',
                        color: const Color(0xFF3498DB),
                      ),
                      _buildQuickAction(
                        icon: Icons.qr_code_scanner_rounded,
                        label: 'QR Code',
                        color: const Color(0xFFF39C12),
                      ),
                      _buildQuickAction(
                        icon: Icons.build_rounded,
                        label: 'Maintenance',
                        color: const Color(0xFFE67E22),
                      ),
                      _buildQuickAction(
                        icon: Icons.bar_chart_rounded,
                        label: 'Rapports',
                        color: const Color(0xFF9B59B6),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // ── BOUTON SE CONNECTER ──
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        _markFirstLaunchDone();
                        Get.offAllNamed('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryColor,
                        elevation: 8,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Se Connecter',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── BOUTON CRÉER UN COMPTE ──
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () {
                        _markFirstLaunchDone();
                        Get.offAllNamed('/register');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.5),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Créer un Compte',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.85),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _markFirstLaunchDone() {
    Get.find<StorageService>().setFirstLaunchDone();
  }
}