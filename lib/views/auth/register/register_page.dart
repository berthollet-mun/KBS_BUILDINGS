import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../controllers/auth_controller.dart';
import '../../../core/utils/validators.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController _controller = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _postnomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool obscure = true;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _controller.register(
      nom: _nomController.text.trim(),
      postnom: _postnomController.text.trim().isEmpty
          ? null
          : _postnomController.text.trim(),
      prenom: _prenomController.text.trim(),
      email: _emailController.text.trim(),
      telephone: _telephoneController.text.trim(),
      motDePasse: _passwordController.text.trim(),
    );

    if (success) {
      Get.offAllNamed(AppRoutes.dashboard);
      Get.snackbar(
        'Succès',
        'Inscription réussie',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Erreur',
        _controller.error.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(Icons.person_add_alt_1, size: 80),
                const SizedBox(height: 16),
                const Text(
                  'Créer un compte',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nomController,
                  validator: (v) => Validators.validateRequired(v, 'Le nom'),
                  decoration: const InputDecoration(labelText: 'Nom'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _postnomController,
                  decoration: const InputDecoration(labelText: 'Postnom'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _prenomController,
                  validator: (v) => Validators.validateRequired(v, 'Le prénom'),
                  decoration: const InputDecoration(labelText: 'Prénom'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  validator: Validators.validateEmail,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _telephoneController,
                  validator: Validators.validatePhone,
                  decoration: const InputDecoration(labelText: 'Téléphone'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  obscureText: obscure,
                  validator: Validators.validatePassword,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => obscure = !obscure),
                      icon: Icon(
                        obscure ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _controller.isLoading.value ? null : _submit,
                    child: _controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : const Text('Créer le compte'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}