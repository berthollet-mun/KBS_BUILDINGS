// lib/views/biens/biens_list_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbs/controllers/bien_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/property_card.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/empty_state.dart';

class BiensListPage extends StatelessWidget {
  const BiensListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BienController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Biens'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed('/bien-create'),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── SEARCH BAR ──
          Container(
            color: AppTheme.primaryColor,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) => controller.searchQuery.value = value,
                decoration: InputDecoration(
                  hintText: 'Rechercher un bien, propriétaire...',
                  hintStyle: TextStyle(
                    color: AppTheme.textSecondary.withOpacity(0.6),
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(Icons.search,
                      color: AppTheme.textSecondary),
                  suffixIcon: IconButton(
                    onPressed: () => _showFilters(context, controller),
                    icon: const Icon(Icons.tune,
                        color: AppTheme.primaryColor),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),

          // ── FILTER CHIPS ──
          SizedBox(
            height: 48,
            child: Obx(() => ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4),
                  children: [
                    _buildFilterChip(
                      label: 'Tout (${controller.biensList.length})',
                      isSelected:
                          controller.selectedTypeBien.value == null,
                      onTap: () => controller.filterByType(null),
                    ),
                    const SizedBox(width: 8),
                    ...['maison', 'appartement', 'bureau', 'parcelle']
                        .map((type) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: _buildFilterChip(
                                label: AppTheme.getTypeBienLabel(type),
                                isSelected:
                                    controller.selectedTypeBien.value ==
                                        type,
                                onTap: () =>
                                    controller.filterByType(type),
                                icon: AppTheme.getTypeBienIcon(type),
                              ),
                            )),
                  ],
                )),
          ),

          const SizedBox(height: 4),

          // ── BIENS LIST ──
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.biensList.isEmpty) {
                return const LoadingWidget(
                    message: 'Chargement des biens...');
              }

              if (controller.biensList.isEmpty) {
                return EmptyState(
                  icon: Icons.apartment,
                  title: 'Aucun bien trouvé',
                  subtitle: 'Ajoutez votre premier bien immobilier',
                  buttonText: 'Ajouter un bien',
                  onButtonPressed: () => Get.toNamed('/bien-create'),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchBiens(refresh: true),
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
                        onTap: () => Get.toNamed(
                          '/bien-detail',
                          arguments: bien.id,
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor
              : AppTheme.primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(22),
          border: isSelected
              ? null
              : Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : AppTheme.primaryColor,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilters(BuildContext context, BienController controller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
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
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Filtrer par statut', style: AppTheme.headline3),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.statutsBien
                  .map((s) => Obx(() => ChoiceChip(
                        label: Text(AppTheme.getStatutBienLabel(s)),
                        selected:
                            controller.selectedStatut.value == s,
                        onSelected: (selected) {
                          controller
                              .filterByStatut(selected ? s : null);
                          Get.back();
                        },
                        selectedColor: AppTheme.getStatutBienColor(s)
                            .withOpacity(0.2),
                        labelStyle: TextStyle(
                          color:
                              controller.selectedStatut.value == s
                                  ? AppTheme.getStatutBienColor(s)
                                  : null,
                        ),
                      )))
                  .toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  controller.clearFilters();
                  Get.back();
                },
                child: const Text('Réinitialiser les filtres'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}