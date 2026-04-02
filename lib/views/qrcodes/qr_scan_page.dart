// lib/views/qrcodes/qr_scan_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/themes/app_theme.dart';

class QrScanPage extends StatelessWidget {
  const QrScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        title: const Text('Scanner QR Code'),
        backgroundColor: const Color(0xFF0D1B2A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // ── Zone Scanner ──
          Expanded(
            flex: 3,
            child: Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    // Background simulé
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        color: Colors.white.withOpacity(0.05),
                        child: Center(
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme.primaryColor.withOpacity(0.5),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.qr_code_scanner_rounded,
                                size: 80,
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Coins animés
                    ..._buildCorners(),
                  ],
                ),
              ),
            ),
          ),

          // ── Instruction ──
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.qr_code_2,
                        size: 50,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Positionnez le QR code dans le cadre',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Le scan se fera automatiquement\nlorsque le QR sera détecté',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.5),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Bouton
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implémenter le scan réel
                        Get.snackbar(
                          'Info',
                          'Scanner QR en cours de développement',
                          backgroundColor: AppTheme.infoColor,
                          colorText: Colors.white,
                        );
                      },
                      icon: const Icon(Icons.camera_alt_rounded),
                      label: const Text(
                        'Voir les Informations du Bien',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCorners() {
    const cornerSize = 30.0;
    const cornerWidth = 4.0;
    const color = Colors.white;
    const radius = 22.0;

    return [
      // Top-left
      Positioned(
        top: 0, left: 0,
        child: Container(
          width: cornerSize, height: cornerSize,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: color, width: cornerWidth),
              left: BorderSide(color: color, width: cornerWidth),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
            ),
          ),
        ),
      ),
      // Top-right
      Positioned(
        top: 0, right: 0,
        child: Container(
          width: cornerSize, height: cornerSize,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: color, width: cornerWidth),
              right: BorderSide(color: color, width: cornerWidth),
            ),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(radius),
            ),
          ),
        ),
      ),
      // Bottom-left
      Positioned(
        bottom: 0, left: 0,
        child: Container(
          width: cornerSize, height: cornerSize,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: color, width: cornerWidth),
              left: BorderSide(color: color, width: cornerWidth),
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(radius),
            ),
          ),
        ),
      ),
      // Bottom-right
      Positioned(
        bottom: 0, right: 0,
        child: Container(
          width: cornerSize, height: cornerSize,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: color, width: cornerWidth),
              right: BorderSide(color: color, width: cornerWidth),
            ),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(radius),
            ),
          ),
        ),
      ),
    ];
  }
}