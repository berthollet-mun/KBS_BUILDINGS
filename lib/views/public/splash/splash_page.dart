// lib/views/public/splash/splash_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Animation du logo
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;

  // Animation du texte
  late AnimationController _textController;
  late Animation<Offset> _textSlide;
  late Animation<double> _textFade;

  // ═══════════════════════════════════════════
  //  DONNÉES DES 5 SLIDES
  // ═══════════════════════════════════════════
  final List<_SlideData> _slides = [
    _SlideData(
      image: 'assets/images/img1.png',
      title: 'Gestion Immobilière\nIntelligente',
      subtitle:
          'Votre plateforme complète de gestion\ndes biens immobiliers',
      icon: Icons.home_work_rounded,
    ),
    _SlideData(
      image: 'assets/images/img2.png',
      title: 'Gestion des Biens',
      subtitle:
          'Gérez villas, appartements et bureaux\nen toute simplicité',
      icon: Icons.apartment_rounded,
    ),
    _SlideData(
      image: 'assets/images/img3.png',
      title: 'Suivi des Loyers',
      subtitle:
          'Suivez vos paiements et échéances\nen temps réel',
      icon: Icons.payments_rounded,
    ),
    _SlideData(
      image: 'assets/images/img4.png',
      title: 'Maintenance\n& Visites',
      subtitle:
          'Planifiez les visites et gérez\nla maintenance efficacement',
      icon: Icons.build_circle_rounded,
    ),
    _SlideData(
      image: 'assets/images/img5.png',
      title: 'Commencez\nMaintenant',
      subtitle:
          'Rejoignez KBS Building et simplifiez\nvotre gestion immobilière',
      icon: Icons.rocket_launch_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();

    // ── Barre de statut transparente ──
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // ── Animation Logo ──
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    // ── Animation Texte ──
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOut,
      ),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeIn,
      ),
    );

    // ── Lancer les animations ──
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _textController.forward();
    });
  }

  // ═══════════════════════════════════════════
  //  NAVIGATION
  // ═══════════════════════════════════════════
  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    // Rejouer l'animation du texte à chaque slide
    _textController.reset();
    _textController.forward();
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _goToApp();
    }
  }

  void _goToApp() {
    final storage = Get.find<StorageService>();
    if (storage.isLoggedIn && storage.hasToken) {
      Get.offAllNamed('/dashboard');
    } else {
      Get.offAllNamed('/login');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════
  //  BUILD PRINCIPAL
  // ═══════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Stack(
        children: [
          // ━━━ 1. PAGE VIEW (images de fond) ━━━
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) =>
                _buildBackground(_slides[index].image),
          ),

          // ━━━ 2. OVERLAY GRADIENT BLEU ━━━
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF0D47A1).withOpacity(0.55),
                  const Color(0xFF1565C0).withOpacity(0.20),
                  Colors.black.withOpacity(0.25),
                  Colors.black.withOpacity(0.80),
                ],
                stops: const [0.0, 0.30, 0.55, 1.0],
              ),
            ),
          ),

          // ━━━ 3. CONTENU ━━━
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // ── BOUTON PASSER (en haut à droite) ──
                Align(
                  alignment: Alignment.centerRight,
                  child: _currentPage < _slides.length - 1
                      ? Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: TextButton(
                            onPressed: _goToApp,
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  Colors.white.withOpacity(0.15),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Passer',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(height: 40),
                ),

                const SizedBox(height: 10),

                // ── LOGO (img6.png) ──
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoFade.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: child,
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/images/img6.png',
                    width: 130,
                    height: 130,
                  ),
                ),

                const Spacer(),

                // ── ICÔNE DU SLIDE ──
                AnimatedBuilder(
                  animation: _textController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textFade.value,
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      _slides[_currentPage].icon,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── TITRE ──
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textFade,
                    child: Text(
                      _slides[_currentPage].title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.15,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 3),
                            blurRadius: 12,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── SOUS-TITRE ──
                FadeTransition(
                  opacity: _textFade,
                  child: Text(
                    _slides[_currentPage].subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.85),
                      height: 1.6,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // ── INDICATEURS (DOTS) ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slides.length,
                    (i) => _buildDot(i),
                  ),
                ),

                const SizedBox(height: 30),

                // ── BOUTON SUIVANT / COMMENCER ──
                _currentPage == _slides.length - 1
                    ? _buildStartButton()
                    : _buildNextButton(),

                SizedBox(height: bottomPadding + 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  WIDGETS HELPERS
  // ═══════════════════════════════════════════

  /// Image de fond plein écran
  Widget _buildBackground(String imagePath) {
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  /// Point indicateur de page
  Widget _buildDot(int index) {
    final isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 10,
      width: isActive ? 32 : 10,
      decoration: BoxDecoration(
        color: isActive
            ? Colors.white
            : Colors.white.withOpacity(0.35),
        borderRadius: BorderRadius.circular(5),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.white.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }

  /// Bouton flèche "Suivant"
  Widget _buildNextButton() {
    return GestureDetector(
      onTap: _nextPage,
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.25),
              Colors.white.withOpacity(0.10),
            ],
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_forward_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  /// Bouton "Commencer" (dernier slide)
  Widget _buildStartButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          onPressed: _goToApp,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF0D47A1),
            elevation: 10,
            shadowColor: Colors.black38,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Commencer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(width: 10),
              Icon(Icons.arrow_forward_rounded, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
//  MODÈLE DE DONNÉES DU SLIDE
// ═══════════════════════════════════════════
class _SlideData {
  final String image;
  final String title;
  final String subtitle;
  final IconData icon;

  _SlideData({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}