import 'package:flutter/material.dart';
import '../../app/themes/app_theme.dart';

class QrScanPage extends StatelessWidget {
  const QrScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner QR Code'), backgroundColor: AppTheme.primaryDark),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(padding: const EdgeInsets.all(32), decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(24)),
          child: const Icon(Icons.qr_code_scanner, size: 100, color: AppTheme.primaryColor)),
        const SizedBox(height: 32),
        const Text('Scanner QR Code', style: AppTheme.headline2),
        const SizedBox(height: 8),
        const Text('Positionnez le QR code dans le cadre\npour voir les informations du bien', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, height: 1.5)),
        const SizedBox(height: 32),
        ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.camera_alt), label: const Text('Ouvrir la caméra')),
      ])),
    );
  }
}