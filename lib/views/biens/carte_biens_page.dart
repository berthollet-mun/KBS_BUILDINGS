// lib/views/biens/carte_biens_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/bien_controller.dart';
import '../../app/themes/app_theme.dart';

class CarteBiensPage extends StatelessWidget {
  const CarteBiensPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BienController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte des Biens'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // ── PLACEHOLDER MAP ──
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFE8ECEF),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map_outlined,
                  size: 80,
                  color: AppTheme.primaryColor.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Google Maps',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Configurez votre clé API Maps\npour activer la carte',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // ── SEARCH BAR OVERLAY ──
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher une zone, commune...',
                  hintStyle: TextStyle(
                    color: AppTheme.textSecondary.withOpacity(0.6),
                    fontSize: 14,
                  ),
                  prefixIcon:
                      const Icon(Icons.search, color: AppTheme.textSecondary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),

          // ── FILTER CHIPS OVERLAY ──
          Positioned(
            top: 76,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildMapChip('Tout', true),
                  _buildMapChip('Disponible', false),
                  _buildMapChip('Loué', false),
                  _buildMapChip('Prix', false, icon: Icons.arrow_drop_down),
                  _buildMapChip('Plus de filtres', false, icon: Icons.tune),
                ],
              ),
            ),
          ),

          // ── BIENS CARDS OVERLAY (BOTTOM) ──
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 140,
              child: Obx(() => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.biensList.length,
                    itemBuilder: (context, index) {
                      final bien = controller.biensList[index];
                      return GestureDetector(
                        onTap: () => Get.toNamed('/bien-detail',
                            arguments: bien.id),
                        child: Container(
                          width: 260,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Image placeholder
                              ClipRRect(
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(16),
                                ),
                                child: Container(
                                  width: 100,
                                  height: double.infinity,
                                  color: AppTheme.primaryColor
                                      .withOpacity(0.1),
                                  child: Center(
                                    child: Icon(
                                      AppTheme.getTypeBienIcon(
                                          bien.typeBien),
                                      size: 32,
                                      color: AppTheme.primaryColor
                                          .withOpacity(0.4),
                                    ),
                                  ),
                                ),
                              ),
                              // Info
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        bien.titre,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow:
                                            TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      if (bien.commune != null)
                                        Text(
                                          bien.commune!,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color:
                                                AppTheme.textSecondary,
                                          ),
                                        ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${bien.prixLoyer?.toStringAsFixed(0) ?? '0'} USD/mois',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapChip(String label, bool selected, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppTheme.textPrimary,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 2),
              Icon(icon,
                  size: 18,
                  color: selected ? Colors.white : AppTheme.textPrimary),
            ],
          ],
        ),
      ),
    );
  }
}
