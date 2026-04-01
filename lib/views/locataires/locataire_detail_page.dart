import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/locataire_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/status_badge.dart';

class LocataireDetailPage extends StatelessWidget {
  const LocataireDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<LocataireController>();
    final int id = Get.arguments ?? 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrl.fetchLocataireDetails(id);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail Locataire'),
        actions: [
          IconButton(
            onPressed: () {
              final l = ctrl.selectedLocataire.value;
              if (l != null) {
                ctrl.fillForm(l);
                Get.toNamed('/locataire-edit', arguments: l.id);
              }
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Obx(() {
        if (ctrl.isDetailLoading.value) return const LoadingWidget();
        final l = ctrl.selectedLocataire.value;
        if (l == null) return const Center(child: Text('Locataire non trouvé'));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profil
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 4))],
                ),
                child: Column(children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: AppTheme.accentColor.withOpacity(0.1),
                    child: Text(l.nomComplet.substring(0, 1).toUpperCase() ?? '?', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppTheme.accentColor)),
                  ),
                  const SizedBox(height: 16),
                  Text(l.nomComplet ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const StatusBadge(label: 'Locataire', color: AppTheme.accentColor),
                ]),
              ),
              const SizedBox(height: 20),

              // Infos
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Informations de contact', style: AppTheme.headline3),
                  const SizedBox(height: 16),
                  _infoTile(Icons.phone, 'Téléphone', l.telephone ?? 'Non renseigné', AppTheme.successColor),
                  const Divider(height: 24),
                  _infoTile(Icons.email, 'Email', l.email ?? 'Non renseigné', AppTheme.infoColor),
                  const Divider(height: 24),
                  _infoTile(Icons.location_on, 'Adresse', l.adresse ?? 'Non renseignée', AppTheme.warningColor),
                  const Divider(height: 24),
                  _infoTile(Icons.badge, 'Pièce d\'identité', l.pieceIdentite ?? 'Non renseignée', AppTheme.primaryColor),
                ]),
              ),
              const SizedBox(height: 20),

              // Contrats
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Contrats', style: AppTheme.headline3),
                  const SizedBox(height: 16),
                  if (l.contrats == null || l.contrats!.isEmpty)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Aucun contrat', style: TextStyle(color: AppTheme.textSecondary)),
                    ))
                  else
                    ...l.contrats!.map((c) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.description, color: AppTheme.primaryColor, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(c.numeroContrat ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                              Text('${c.dateDebut ?? ''} → ${c.dateFin ?? ''}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                              Text('${c.montantLoyer.toStringAsFixed(0) ?? '0'} USD/mois', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primaryColor)),
                            ])),
                            StatusBadge(label: c.statut ?? '', color: AppTheme.getStatutContratColor(c.statut)),
                          ]),
                        )),
                ]),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _infoTile(IconData icon, String label, String value, Color color) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 20),
      ),
      const SizedBox(width: 16),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      ])),
    ]);
  }
}