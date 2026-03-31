import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/bien_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/property_card.dart';
import '../shared/widgets/custom_search_bar.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/empty_state.dart';

class BiensDisponiblesPage extends StatelessWidget {
  const BiensDisponiblesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BienController());

    // Charger les biens disponibles dès l'ouverture
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchBiensDisponibles(refresh: true);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Biens Disponibles'),
        actions: [
          IconButton(
            onPressed: () => _showSortOptions(context, controller),
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: Column(
        children: [
          // ===== BARRE DE RECHERCHE =====
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: CustomSearchBar(
              hint: 'Rechercher un bien disponible...',
              onChanged: (value) {
                controller.searchQuery.value = value;
                controller.fetchBiensDisponibles(refresh: true);
              },
              onFilterTap: () =>
                  _showFilterBottomSheet(context, controller),
            ),
          ),

          // ===== CHIPS TYPE BIEN =====
          SizedBox(
            height: 44,
            child: Obx(() => ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildTypeChip(
                      label: 'Tous',
                      icon: Icons.grid_view,
                      isSelected:
                          controller.selectedTypeBien.value == null,
                      onTap: () {
                        controller.selectedTypeBien.value = null;
                        controller.fetchBiensDisponibles(
                            refresh: true);
                      },
                    ),
                    _buildTypeChip(
                      label: 'Maison',
                      icon: Icons.home,
                      isSelected:
                          controller.selectedTypeBien.value ==
                              'maison',
                      onTap: () {
                        controller.selectedTypeBien.value = 'maison';
                        controller.fetchBiensDisponibles(
                            refresh: true);
                      },
                    ),
                    _buildTypeChip(
                      label: 'Appartement',
                      icon: Icons.apartment,
                      isSelected:
                          controller.selectedTypeBien.value ==
                              'appartement',
                      onTap: () {
                        controller.selectedTypeBien.value =
                            'appartement';
                        controller.fetchBiensDisponibles(
                            refresh: true);
                      },
                    ),
                    _buildTypeChip(
                      label: 'Bureau',
                      icon: Icons.business,
                      isSelected:
                          controller.selectedTypeBien.value ==
                              'bureau',
                      onTap: () {
                        controller.selectedTypeBien.value = 'bureau';
                        controller.fetchBiensDisponibles(
                            refresh: true);
                      },
                    ),
                    _buildTypeChip(
                      label: 'Parcelle',
                      icon: Icons.landscape,
                      isSelected:
                          controller.selectedTypeBien.value ==
                              'parcelle',
                      onTap: () {
                        controller.selectedTypeBien.value =
                            'parcelle';
                        controller.fetchBiensDisponibles(
                            refresh: true);
                      },
                    ),
                  ],
                )),
          ),

          const SizedBox(height: 8),

          // ===== RÉSULTAT + COMPTEUR =====
          Obx(() => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${controller.biensList.length} bien(s) disponible(s)',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (controller.selectedTypeBien.value != null ||
                        controller.searchQuery.value.isNotEmpty)
                      TextButton.icon(
                        onPressed: () {
                          controller.searchQuery.value = '';
                          controller.selectedTypeBien.value = null;
                          controller.prixMin.value = null;
                          controller.prixMax.value = null;
                          controller.fetchBiensDisponibles(
                              refresh: true);
                        },
                        icon: const Icon(Icons.clear, size: 16),
                        label: const Text('Effacer filtres',
                            style: TextStyle(fontSize: 12)),
                      ),
                  ],
                ),
              )),

          // ===== LISTE DES BIENS =====
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.biensList.isEmpty) {
                return const LoadingWidget(
                    message: 'Recherche des biens disponibles...');
              }

              if (controller.biensList.isEmpty) {
                return EmptyState(
                  icon: Icons.search_off,
                  title: 'Aucun bien disponible',
                  subtitle:
                      'Essayez de modifier vos critères de recherche',
                  buttonText: 'Réinitialiser',
                  onButtonPressed: () {
                    controller.clearFilters();
                    controller.fetchBiensDisponibles(refresh: true);
                  },
                );
              }

              return RefreshIndicator(
                onRefresh: () =>
                    controller.fetchBiensDisponibles(refresh: true),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollEndNotification &&
                        notification.metrics.extentAfter < 200) {
                      controller.fetchMoreBiens();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.biensList.length +
                        (controller.isFetchingMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.biensList.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                              child: CircularProgressIndicator()),
                        );
                      }
                      final bien = controller.biensList[index];
                      return PropertyCard(
                        bien: bien,
                        onTap: () => Get.toNamed('/bien-detail',
                            arguments: bien.id),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),

      // ===== BOUTON RÉSERVER VISITE =====
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/visite-reserver'),
        icon: const Icon(Icons.calendar_today),
        label: const Text('Réserver une visite'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  // ===== WIDGETS HELPERS =====

  Widget _buildTypeChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryColor
                : AppTheme.primaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? Colors.white
                    : AppTheme.primaryColor,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(
      BuildContext context, BienController controller) {
    final minCtrl =
        TextEditingController(text: controller.prixMin.value?.toString() ?? '');
    final maxCtrl =
        TextEditingController(text: controller.prixMax.value?.toString() ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Filtrer par prix',
                style: AppTheme.headline3),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Prix min (USD)',
                      prefixIcon: Icon(Icons.arrow_downward),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: maxCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Prix max (USD)',
                      prefixIcon: Icon(Icons.arrow_upward),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Filtrer par commune',
                style: AppTheme.headline3),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Commune',
                prefixIcon: Icon(Icons.location_city),
              ),
              onChanged: (v) =>
                  controller.selectedCommune.value = v,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  controller.prixMin.value =
                      double.tryParse(minCtrl.text);
                  controller.prixMax.value =
                      double.tryParse(maxCtrl.text);
                  controller.fetchBiensDisponibles(refresh: true);
                  Get.back();
                },
                child: const Text('Appliquer les filtres'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  controller.prixMin.value = null;
                  controller.prixMax.value = null;
                  controller.selectedCommune.value = '';
                  controller.fetchBiensDisponibles(refresh: true);
                  Get.back();
                },
                child: const Text('Réinitialiser'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortOptions(
      BuildContext context, BienController controller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            const Text('Trier par', style: AppTheme.headline3),
            const SizedBox(height: 16),
            ListTile(
              leading:
                  const Icon(Icons.arrow_upward, color: Colors.green),
              title: const Text('Prix croissant'),
              onTap: () {
                Get.back();
                // Tri local
                controller.biensList.sort((a, b) =>
                    (a.prixLoyer ?? 0).compareTo(b.prixLoyer ?? 0));
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.arrow_downward, color: Colors.red),
              title: const Text('Prix décroissant'),
              onTap: () {
                Get.back();
                controller.biensList.sort((a, b) =>
                    (b.prixLoyer ?? 0).compareTo(a.prixLoyer ?? 0));
              },
            ),
            ListTile(
              leading: const Icon(Icons.sort_by_alpha),
              title: const Text('Nom A-Z'),
              onTap: () {
                Get.back();
                controller.biensList.sort((a, b) =>
                    (a.titre ?? '').compareTo(b.titre ?? ''));
              },
            ),
          ],
        ),
      ),
    );
  }
}