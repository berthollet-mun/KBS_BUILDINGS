import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/bien_controller.dart';
import 'package:kbs/controllers/qrcode_controller.dart';
import '../../app/themes/app_theme.dart';
import '../../core/services/api_service.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/status_badge.dart';

class BienDetailPage extends StatelessWidget {
  const BienDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BienController>();
    final apiService = Get.find<ApiService>();
    final int bienId = Get.arguments ?? 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchBienDetails(bienId);
    });

    return Scaffold(
      body: Obx(() {
        if (controller.isDetailLoading.value) {
          return const LoadingWidget(message: 'Chargement du bien...');
        }

        final bien = controller.selectedBien.value;
        if (bien == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    size: 60, color: AppTheme.textSecondary),
                const SizedBox(height: 16),
                const Text('Bien non trouvé'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Retour'),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            // ===== IMAGE HEADER =====
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: AppTheme.primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Photo ou placeholder
                    bien.photoPrincipale != null
                        ? Image.network(
                            apiService
                                .getFileUrl(bien.photoPrincipale),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _buildImagePlaceholder(bien.typeBien),
                          )
                        : _buildImagePlaceholder(bien.typeBien),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                    // Badge statut en haut à droite
                    Positioned(
                      top: 100,
                      right: 16,
                      child: StatusBadge(
                        label:
                            AppTheme.getStatutBienLabel(bien.statut),
                        color:
                            AppTheme.getStatutBienColor(bien.statut),
                        fontSize: 13,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    controller.fillBienForm(bien);
                    Get.toNamed('/bien-edit', arguments: bien.id);
                  },
                  icon: const Icon(Icons.edit),
                  tooltip: 'Modifier',
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'qr':
                        _generateQrCode(bien.id ?? 0);
                        break;
                      case 'delete':
                        controller.confirmDeleteBien(
                            bien.id ?? 0, bien.titre ?? '');
                        break;
                      case 'maintenance':
                        Get.toNamed('/maintenance-create');
                        break;
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                        value: 'qr', child: Text('Générer QR Code')),
                    const PopupMenuItem(
                        value: 'maintenance',
                        child: Text('Signaler une panne')),
                    const PopupMenuItem(
                        value: 'delete',
                        child: Text('Supprimer',
                            style: TextStyle(color: Colors.red))),
                  ],
                ),
              ],
            ),

            // ===== CONTENU =====
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== TITRE & PRIX =====
                    Text(
                      bien.titre ?? 'Sans titre',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${bien.prixLoyer?.toStringAsFixed(0) ?? '0'} USD / mois',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ===== CARACTÉRISTIQUES =====
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                        children: [
                          _buildCharacteristic(
                            icon: AppTheme.getTypeBienIcon(
                                bien.typeBien),
                            label: AppTheme.getTypeBienLabel(
                                bien.typeBien),
                          ),
                          _buildCharacteristic(
                            icon: Icons.square_foot,
                            label:
                                '${bien.surface?.toStringAsFixed(0) ?? '-'} m²',
                          ),
                          _buildCharacteristic(
                            icon: Icons.meeting_room,
                            label:
                                '${bien.nbPieces ?? '-'} pièces',
                          ),
                          if (bien.etage != null)
                            _buildCharacteristic(
                              icon: Icons.stairs,
                              label: 'Étage ${bien.etage}',
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ===== PROPRIÉTAIRE =====
                    if (bien.proprietaireNom != null) ...[
                      const Text('Propriétaire',
                          style: AppTheme.headline3),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppTheme.primaryColor
                                  .withOpacity(0.1),
                              child: Text(
                                bien.proprietaireNom!
                                    .substring(0, 2)
                                    .toUpperCase(),
                                style: const TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bien.proprietaireNom!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (bien.proprietaireTel !=
                                      null)
                                    Text(
                                      bien.proprietaireTel!,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color:
                                            AppTheme.textSecondary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (bien.proprietaireTel != null)
                              IconButton(
                                onPressed: () {},
                                icon: Container(
                                  padding:
                                      const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.successColor
                                        .withOpacity(0.1),
                                    borderRadius:
                                        BorderRadius.circular(
                                            10),
                                  ),
                                  child: const Icon(
                                    Icons.phone,
                                    color:
                                        AppTheme.successColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // ===== QR CODE =====
                    const Text('QR Code du Bien',
                        style: AppTheme.headline3),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor
                                  .withOpacity(0.08),
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.qr_code_2,
                                size: 40,
                                color: AppTheme.primaryColor),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'Scannez pour voir toutes les\ninformations du bien',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            _generateQrCode(bien.id ?? 0),
                        icon: const Icon(Icons.qr_code),
                        label: const Text('Afficher le QR Code'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          side: const BorderSide(
                              color: AppTheme.primaryColor),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ===== DESCRIPTION =====
                    if (bien.description != null &&
                        bien.description!.isNotEmpty) ...[
                      const Text('Description',
                          style: AppTheme.headline3),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          bien.description!,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // ===== LOCALISATION =====
                    const Text('Localisation',
                        style: AppTheme.headline3),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(Icons.location_on,
                              'Adresse', bien.adresse ?? '-'),
                          _buildDetailRow(Icons.location_city,
                              'Commune', bien.commune ?? '-'),
                          _buildDetailRow(Icons.map, 'Quartier',
                              bien.quartier ?? '-'),
                          _buildDetailRow(Icons.public, 'Ville',
                              bien.ville ?? '-'),
                          if (bien.latitude != null &&
                              bien.longitude != null)
                            _buildDetailRow(
                                Icons.gps_fixed,
                                'GPS',
                                '${bien.latitude}, ${bien.longitude}'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ===== BOUTON MAINTENANCE =====
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            Get.toNamed('/maintenance-create'),
                        icon: const Icon(Icons.build),
                        label:
                            const Text('Marquer en Maintenance'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.warningColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildImagePlaceholder(String? typeBien) {
    return Container(
      color: AppTheme.primaryColor.withOpacity(0.15),
      child: Center(
        child: Icon(
          AppTheme.getTypeBienIcon(typeBien),
          size: 80,
          color: AppTheme.primaryColor.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildCharacteristic({
    required IconData icon,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
      IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _generateQrCode(int bienId) {
    final qrCtrl = Get.put(QrCodeController());
    qrCtrl.generateQrCode(bienId);
  }
}