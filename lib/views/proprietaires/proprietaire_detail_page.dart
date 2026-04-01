import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/proprietaire_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/status_badge.dart';

class ProprietaireDetailPage extends StatelessWidget {
  const ProprietaireDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProprietaireController>();
    final int id = Get.arguments ?? 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrl.fetchProprietaireDetails(id);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail Propriétaire'),
        actions: [
          IconButton(
            onPressed: () {
              final p = ctrl.selectedProprietaire.value;
              if (p != null) {
                ctrl.fillForm(p);
                Get.toNamed('/proprietaire-edit', arguments: p.id);
              }
            },
            icon: const Icon(Icons.edit),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                final p = ctrl.selectedProprietaire.value;
                if (p != null) {
                  ctrl.confirmDelete(p.id ?? 0, p.nomComplet ?? '');
                }
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'delete',
                child: Text('Supprimer', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (ctrl.isDetailLoading.value) {
          return const LoadingWidget(message: 'Chargement...');
        }

        final p = ctrl.selectedProprietaire.value;
        if (p == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: AppTheme.textSecondary),
                const SizedBox(height: 16),
                const Text('Propriétaire non trouvé'),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () => Get.back(), child: const Text('Retour')),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ===== PROFIL CARD =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      child: Text(
                        p.nomComplet.substring(0, 1).toUpperCase() ?? '?',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      p.nomComplet ?? 'Sans nom',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    const StatusBadge(label: 'Propriétaire', color: AppTheme.primaryColor),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===== INFOS DE CONTACT =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Informations de contact',
                        style: AppTheme.headline3),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      context,
                      icon: Icons.phone,
                      label: 'Téléphone',
                      value: p.telephone ?? 'Non renseigné',
                      color: AppTheme.successColor,
                      onTap: p.telephone != null ? () {} : null,
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      context,
                      icon: Icons.email,
                      label: 'Email',
                      value: p.email ?? 'Non renseigné',
                      color: AppTheme.infoColor,
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      context,
                      icon: Icons.location_on,
                      label: 'Adresse',
                      value: p.adresse ?? 'Non renseignée',
                      color: AppTheme.warningColor,
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      context,
                      icon: Icons.badge,
                      label: 'Pièce d\'identité',
                      value: p.pieceIdentite ?? 'Non renseignée',
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===== BIENS DU PROPRIÉTAIRE =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Biens immobiliers', style: AppTheme.headline3),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${p.biens?.length ?? 0} bien(s)',
                            style: const TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (p.biens == null || p.biens!.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.lightBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Column(
                            children: [
                              Icon(Icons.home_outlined,
                                  size: 40, color: AppTheme.textSecondary),
                              SizedBox(height: 8),
                              Text('Aucun bien enregistré',
                                  style: TextStyle(color: AppTheme.textSecondary)),
                            ],
                          ),
                        ),
                      )
                    else
                      ...p.biens!.map((bien) => Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.2)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.primaryColor.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    AppTheme.getTypeBienIcon(bien.typeBien),
                                    color: AppTheme.primaryColor,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bien.titre ?? 'Sans titre',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${bien.codeBien ?? ''} • ${bien.commune ?? ''}',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                StatusBadge(
                                  label: AppTheme.getStatutBienLabel(
                                      bien.statut),
                                  color: AppTheme.getStatutBienColor(
                                      bien.statut),
                                ),
                              ],
                            ),
                          )),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.textSecondary)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          if (onTap != null)
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
        ],
      ),
    );
  }
}