// lib/views/biens/bien_detail_page.dart

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
                            apiService.getFileUrl(bien.photoPrincipale),
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
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
                            Colors.black.withOpacity(0.1),
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
                        label: AppTheme.getStatutBienLabel(bien.statut),
                        color: AppTheme.getStatutBienColor(bien.statut),
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
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.edit, size: 20),
                  ),
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
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${bien.prixLoyer?.toStringAsFixed(0) ?? '0'} USD / mois',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    if (bien.adresse != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: AppTheme.textSecondary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${bien.commune ?? ''}, ${bien.quartier ?? ''}, ${bien.ville ?? ''}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildCharacteristic(
                            icon: AppTheme.getTypeBienIcon(bien.typeBien),
                            label: AppTheme.getTypeBienLabel(bien.typeBien),
                          ),
                          _buildCharacteristic(
                            icon: Icons.square_foot,
                            label: '${bien.surface?.toStringAsFixed(0) ?? '-'} m²',
                          ),
                          _buildCharacteristic(
                            icon: Icons.meeting_room,
                            label: '${bien.nbPieces ?? '-'} pièces',
                          ),
                          _buildCharacteristic(
                            icon: Icons.local_parking,
                            label: 'Parking',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ===== PROPRIÉTAIRE =====
                    if (bien.proprietaireNom != null) ...[
                      const Text('Propriétaire', style: AppTheme.headline3),
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
                            CircleAvatar(
                              radius: 24,
                              backgroundColor:
                                  AppTheme.primaryColor.withOpacity(0.1),
                              child: Text(
                                bien.proprietaireNom!
                                    .substring(0, 2)
                                    .toUpperCase(),
                                style: const TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bien.proprietaireNom!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  if (bien.proprietaireTel != null)
                                    Text(
                                      bien.proprietaireTel!,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // Phone & WhatsApp buttons
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.successColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.phone,
                                  color: AppTheme.successColor, size: 20),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF25D366).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.chat,
                                  color: Color(0xFF25D366), size: 20),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // ===== LOCATAIRE ACTUEL =====
                    if (bien.statut == 'occupe') ...[
                      const Text('Locataire Actuel', style: AppTheme.headline3),
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
                            CircleAvatar(
                              radius: 24,
                              backgroundColor:
                                  AppTheme.successColor.withOpacity(0.1),
                              child: const Icon(Icons.person,
                                  color: AppTheme.successColor),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Locataire',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Depuis ${DateTime.now().year}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            StatusBadge(
                              label: 'A jour (Loyer payé)',
                              color: AppTheme.successColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // ===== QR CODE =====
                    const Text('QR Code du Bien', style: AppTheme.headline3),
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
                              color: AppTheme.primaryColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.qr_code_2,
                                size: 40, color: AppTheme.primaryColor),
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
                        onPressed: () => _generateQrCode(bien.id ?? 0),
                        icon: const Icon(Icons.qr_code),
                        label: const Text('Afficher le QR Code'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          side: const BorderSide(
                              color: AppTheme.primaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ===== PHOTOS DU BIEN =====
                    const Text('Photos du Bien', style: AppTheme.headline3),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 160,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 40,
                                color: AppTheme.primaryColor.withOpacity(0.3),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ===== DESCRIPTION =====
                    if (bien.description != null &&
                        bien.description!.isNotEmpty) ...[
                      const Text('Description', style: AppTheme.headline3),
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

                    // ===== ÉQUIPEMENTS =====
                    const Text('Équipements', style: AppTheme.headline3),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildEquipment(Icons.pool, 'Piscine'),
                        _buildEquipment(Icons.kitchen, 'Cuisine équipée'),
                        _buildEquipment(Icons.yard, 'Jardin'),
                        _buildEquipment(Icons.garage, 'Garage'),
                        _buildEquipment(Icons.ac_unit, 'Climatisation'),
                        _buildEquipment(Icons.balcony, 'Balcon'),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ===== DOCUMENTS =====
                    const Text('Documents', style: AppTheme.headline3),
                    const SizedBox(height: 12),
                    _buildDocumentItem(
                      icon: Icons.picture_as_pdf,
                      name: 'Contrat de bail.pdf',
                      date: '15/03/2024',
                      color: Colors.red,
                    ),
                    const SizedBox(height: 8),
                    _buildDocumentItem(
                      icon: Icons.picture_as_pdf,
                      name: 'État des lieux.pdf',
                      date: '15/01/2024',
                      color: Colors.red,
                    ),
                    const SizedBox(height: 8),
                    _buildDocumentItem(
                      icon: Icons.folder_zip,
                      name: 'Quittances 2024.zip',
                      date: '01/2024',
                      color: Colors.orange,
                    ),

                    const SizedBox(height: 32),

                    // ===== BOUTON MAINTENANCE =====
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () => Get.toNamed('/maintenance-create'),
                        icon: const Icon(Icons.build_rounded),
                        label: const Text(
                          'Marquer en Maintenance',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.errorColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
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

  Widget _buildEquipment(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem({
    required IconData icon,
    required String name,
    required String date,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Ajouté le $date',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.download, color: AppTheme.primaryColor, size: 20),
        ],
      ),
    );
  }

  void _generateQrCode(int bienId) {
    final qrCtrl = Get.put(QrCodeController());
    qrCtrl.generateQrCode(bienId);
  }
}