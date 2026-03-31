import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/themes/app_theme.dart';

class QrResultPage extends StatelessWidget {
  const QrResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Résultat QR Code')),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.check_circle, size: 80, color: AppTheme.successColor),
        const SizedBox(height: 16),
        const Text('Bien trouvé !', style: AppTheme.headline2),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: () => Get.toNamed('/bien-detail'), child: const Text('Voir les informations du bien')),
      ])),
    );
  }
}