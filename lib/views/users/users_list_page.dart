import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/user_controller.dart';
import '../../app/themes/app_theme.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/empty_state.dart';
import '../shared/widgets/custom_search_bar.dart';
import '../shared/widgets/status_badge.dart';

class UsersListPage extends StatelessWidget {
  const UsersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(UserController());
    return Scaffold(
      appBar: AppBar(title: const Text('Utilisateurs'), actions: [IconButton(onPressed: () => Get.toNamed('/user-create'), icon: const Icon(Icons.person_add))]),
      body: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 8), child: CustomSearchBar(hint: 'Rechercher un utilisateur...', onChanged: (v) => ctrl.searchQuery.value = v)),
        Expanded(child: Obx(() {
          if (ctrl.isLoading.value && ctrl.usersList.isEmpty) return const LoadingWidget();
          if (ctrl.usersList.isEmpty) return const EmptyState(icon: Icons.people_outline, title: 'Aucun utilisateur');
          return RefreshIndicator(onRefresh: () => ctrl.fetchUsers(refresh: true), child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: ctrl.usersList.length, itemBuilder: (_, i) {
            final u = ctrl.usersList[i];
            return Container(margin: const EdgeInsets.only(bottom: 10), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(backgroundColor: AppTheme.primaryColor.withOpacity(0.1), child: Text('${u.prenom?.substring(0, 1) ?? ''}${u.nom.substring(0, 1)}', style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold))),
                title: Text('${u.prenom ?? ''} ${u.nom}', style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(u.email, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                  const SizedBox(height: 4),
                  Row(children: [
                    StatusBadge(label: u.roleNom ?? '', color: AppTheme.primaryColor),
                    const SizedBox(width: 6),
                    StatusBadge(label: u.statut, color: u.isActif ? AppTheme.successColor : AppTheme.errorColor),
                  ]),
                ]),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Get.toNamed('/user-detail', arguments: u.id),
              ));
          }));
        })),
      ]),
    );
  }
}