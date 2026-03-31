import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/bien_controller.dart';

class BienDetailPage extends StatefulWidget {
  const BienDetailPage({super.key});

  @override
  State<BienDetailPage> createState() => _BienDetailPageState();
}

class _BienDetailPageState extends State<BienDetailPage> {
  final BienController controller = Get.find<BienController>();

  @override
  void initState() {
    super.initState();
    final int? id = Get.arguments;
    if (id != null) {
      controller.loadBienDetail(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail du bien'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.currentBien.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty &&
            controller.currentBien.isEmpty) {
          return Center(child: Text(controller.error.value));
        }

        final bien = controller.currentBien;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${bien['titre'] ?? '-'}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Code: ${bien['code_bien'] ?? '-'}'),
                    Text('Type: ${bien['type_bien'] ?? '-'}'),
                    Text('Statut: ${bien['statut'] ?? '-'}'),
                    Text('Adresse: ${bien['adresse'] ?? '-'}'),
                    Text('Commune: ${bien['commune'] ?? '-'}'),
                    Text('Quartier: ${bien['quartier'] ?? '-'}'),
                    Text('Ville: ${bien['ville'] ?? '-'}'),
                    Text('Surface: ${bien['surface'] ?? '-'}'),
                    Text('Pièces: ${bien['nb_pieces'] ?? '-'}'),
                    Text('Loyer: ${bien['prix_loyer'] ?? 0} USD'),
                    Text('Vente: ${bien['prix_vente'] ?? 0} USD'),
                    Text('Propriétaire: ${bien['proprietaire_nom'] ?? '-'}'),
                    const SizedBox(height: 12),
                    const Text(
                      'Description',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text('${bien['description'] ?? '-'}'),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}