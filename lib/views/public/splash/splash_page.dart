import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../controllers/auth_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _goNext();
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(seconds: 2));
    final connected = await _authController.checkAuth();

    if (connected) {
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      Get.offAllNamed(AppRoutes.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.business, size: 90),
            SizedBox(height: 16),
            Text(
              'KBS BUILDING',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}