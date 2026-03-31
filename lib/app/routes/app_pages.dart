import 'package:get/get.dart';
import '../../views/public/splash/splash_page.dart';
import '../../views/public/welcome/welcome_page.dart';
import '../../views/auth/login/login_page.dart';
import '../../views/auth/register/register_page.dart';
import '../../views/dashboard/dashboard_page.dart';
import '../../views/biens/biens_list_page.dart';
import '../../views/biens/bien_detail_page.dart';
import '../../views/profile/profile_page.dart';
import '../../views/notifications/notifications_page.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashPage()),
    GetPage(name: AppRoutes.welcome, page: () => const WelcomePage()),
    GetPage(name: AppRoutes.login, page: () => const LoginPage()),
    GetPage(name: AppRoutes.register, page: () => const RegisterPage()),
    GetPage(name: AppRoutes.dashboard, page: () => const DashboardPage()),
    GetPage(name: AppRoutes.biens, page: () => const BiensListPage()),
    GetPage(name: AppRoutes.bienDetail, page: () => const BienDetailPage()),
    GetPage(name: AppRoutes.profile, page: () => const ProfilePage()),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsPage(),
    ),
  ];
}