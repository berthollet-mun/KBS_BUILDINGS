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

  late AnimationController _textController;
  late Animation<Offset> _textSlide;
  late Animation<double> _textFade;

  final List<_SlideData> _slides = [
    _SlideData(
      image: 'assets/images/img1.png',
      title: 'Gestion Immobilière',
      subtitle:
          'Votre plateforme de gestion\ndes biens immobiliers',
    ),
    _SlideData(
      image: 'assets/images/img2.png',
      title: 'Gestion des Biens',
      subtitle:
          'Gérez villas, appartements et\nbureaux en toute simplicité',
    ),
    _SlideData(
      image: 'assets/images/img3.png',
      title: 'Suivi des Loyers',
      subtitle:
          'Suivez vos paiements et\néchéances en temps réel',
    ),
    _SlideData(
      image: 'assets/images/img4.png',
      title: 'Commencez\nMaintenant',
      subtitle:
          'Rejoignez KBS Building et\nsimplifiez votre gestion immobilière',
    ),
  ];

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _textController.forward();
    });
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _textController.reset();
    _textController.forward();
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
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ━━━ 1. PAGE VIEW ━━━
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) => Image.asset(
              _slides[index].image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // ━━━ 2. GRADIENT PRINCIPAL ━━━
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0D47A1).withOpacity(0.45),
                    const Color(0xFF1565C0).withOpacity(0.15),
                    Colors.black.withOpacity(0.20),
                    Colors.black.withOpacity(0.75),
                    Colors.black,  // ← NOIR TOTAL en bas
                    Colors.black,  // ← NOIR TOTAL en bas
                  ],
                  stops: const [0.0, 0.25, 0.45, 0.72, 0.88, 1.0],
                ),
              ),
            ),
          ),

          // ━━━ 3. BANDE NOIRE EN BAS (couvre la nav bar) ━━━
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: bottomPadding + 20,
            child: IgnorePointer(
              child: Container(color: Colors.black),
            ),
          ),

          // ━━━ 4. CONTENU ━━━
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(
                top: topPadding,
                bottom: bottomPadding + 10,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // ── BOUTON PASSER ──
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

                  // ── ESPACE ──
                  const Spacer(),

                  // ── TITRE ──
                  IgnorePointer(
                    child: SlideTransition(
                      position: _textSlide,
                      child: FadeTransition(
                        opacity: _textFade,
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 24),
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
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── SOUS-TITRE ──
                  IgnorePointer(
                    child: FadeTransition(
                      opacity: _textFade,
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 32),
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
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ── DOTS ──
                  IgnorePointer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _slides.length,
                        (i) => _buildDot(i),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── BOUTON COMMENCER ──
                  if (_currentPage == _slides.length - 1)
                    _buildStartButton()
                  else
                    const SizedBox(height: 58),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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

class _SlideData {
  final String image;
  final String title;
  final String subtitle;

  _SlideData({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}