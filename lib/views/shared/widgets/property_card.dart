// lib/views/shared/widgets/property_card.dart

import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';
import '../../../core/services/api_service.dart';
import '../../../data/models/bien_model.dart';
import 'status_badge.dart';
import 'package:get/get.dart';

class PropertyCard extends StatelessWidget {
  final BienModel bien;
  final VoidCallback? onTap;

  const PropertyCard({
    super.key,
    required this.bien,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final apiService = Get.find<ApiService>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image du bien
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
              child: Container(
                width: 110,
                height: 110,
                color: AppTheme.primaryColor.withOpacity(0.1),
                child: bien.photoPrincipale != null
                    ? Image.network(
                        apiService.getFileUrl(bien.photoPrincipale),
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
            ),

            // Infos du bien
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre + Badge statut
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            bien.titre ?? 'Sans titre',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        StatusBadge(
                          label: AppTheme.getStatutBienLabel(
                              bien.statut),
                          color: AppTheme.getStatutBienColor(
                              bien.statut),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Type + infos
                    Row(
                      children: [
                        Icon(
                          AppTheme.getTypeBienIcon(bien.typeBien),
                          size: 14,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppTheme.getTypeBienLabel(bien.typeBien),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        if (bien.nbPieces != null) ...[
                          const Text(' • ',
                              style: TextStyle(
                                  color: AppTheme.textSecondary)),
                          Text(
                            '${bien.nbPieces} pièces',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                        if (bien.surface != null) ...[
                          const Text(' • ',
                              style: TextStyle(
                                  color: AppTheme.textSecondary)),
                          Text(
                            '${bien.surface?.toStringAsFixed(0)} m²',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Adresse
                    if (bien.commune != null || bien.ville != null)
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 14,
                              color: AppTheme.textSecondary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              [bien.commune, bien.ville]
                                  .where((e) => e != null)
                                  .join(', '),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 8),

                    // Prix
                    if (bien.prixLoyer != null)
                      Text(
                        '${_formatPrice(bien.prixLoyer!)} USD/mois',
                        style: const TextStyle(
                          fontSize: 16,
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
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        AppTheme.getTypeBienIcon(bien.typeBien),
        size: 40,
        color: AppTheme.primaryColor.withOpacity(0.3),
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)},000';
    }
    return price.toStringAsFixed(0);
  }
}