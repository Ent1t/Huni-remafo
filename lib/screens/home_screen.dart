import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'qr_scanner_screen.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _floatController;
  late AnimationController _rotateController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation for QR scanner button
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Float animation for decorative elements
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _floatAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));
    
    // Rotation animation for tribal patterns
    _rotateController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_rotateController);

    // Start animations
    _pulseController.repeat(reverse: true);
    _floatController.repeat(reverse: true);
    _rotateController.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2D5A3D), // Deep forest green
              Color(0xFF1A3D2B), // Darker forest
              Color(0xFF0F2419), // Very dark green
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated tribal pattern background
            _buildTribalPatternBackground(),
            
            // Floating particles effect
            _buildFloatingParticles(),
            
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // App title with tribal styling
                  _buildTribalHeader(),
                  
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Main QR scanner button
                        _buildMainQRButton(context),
                        
                        const SizedBox(height: 40),
                        
                        // Subtitle with cultural context
                        _buildSubtitle(),
                      ],
                    ),
                  ),
                  
                  // Bottom navigation hint
                  _buildBottomHint(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTribalPatternBackground() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _rotateAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: TribalPatternPainter(_rotateAnimation.value),
            child: Container(),
          );
        },
      ),
    );
  }

  Widget _buildFloatingParticles() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _floatAnimation,
        builder: (context, child) {
          return Stack(
            children: List.generate(8, (index) {
              return Positioned(
                left: (index * 50.0) % MediaQuery.of(context).size.width,
                top: 100 + (index * 80.0) + _floatAnimation.value,
                child: Opacity(
                  opacity: 0.3,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD4AF37), // Golden color
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildTribalHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Decorative tribal line
          Container(
            height: 3,
            width: 150,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFD4AF37), // Gold
                  Color(0xFFB8860B), // Dark gold
                  Color(0xFFD4AF37),
                ],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // App title
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFFD4AF37),
                Color(0xFFFFD700),
                Color(0xFFB8860B),
              ],
            ).createShader(bounds),
            child: const Text(
              'HUNI SA TRIBU',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
                color: Colors.white,
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          const Text(
            'Cultural Heritage Museum',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFB8B8B8),
              letterSpacing: 2,
              fontWeight: FontWeight.w300,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Decorative tribal line
          Container(
            height: 3,
            width: 150,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFD4AF37),
                  Color(0xFFB8860B),
                  Color(0xFFD4AF37),
                ],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainQRButton(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const QRScannerScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 1.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      )),
                      child: child,
                    );
                  },
                ),
              );
            },
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFD4AF37).withOpacity(0.8),
                    const Color(0xFFB8860B).withOpacity(0.6),
                    const Color(0xFF8B7355).withOpacity(0.4),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF2D5A3D).withOpacity(0.9),
                  border: Border.all(
                    color: const Color(0xFFD4AF37),
                    width: 3,
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      size: 80,
                      color: Color(0xFFD4AF37),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'SCAN',
                      style: TextStyle(
                        color: Color(0xFFD4AF37),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'QR CODE',
                      style: TextStyle(
                        color: Color(0xFFB8B8B8),
                        fontSize: 16,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubtitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const Text(
            'Discover Indigenous Heritage',
            style: TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          const Text(
            'Scan QR codes on museum exhibits to explore\nthe rich culture of indigenous tribes',
            style: TextStyle(
              color: Color(0xFFB8B8B8),
              fontSize: 16,
              height: 1.5,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 30),
          
          // Decorative dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomHint() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2D5A3D).withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFD4AF37).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.swipe_up,
                  color: Color(0xFFD4AF37),
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Explore more in Tribes section',
                  style: TextStyle(
                    color: Color(0xFFB8B8B8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for tribal patterns
class TribalPatternPainter extends CustomPainter {
  final double rotation;
  
  TribalPatternPainter(this.rotation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4AF37).withOpacity(0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rotation);

    // Draw tribal geometric patterns
    for (int i = 0; i < 6; i++) {
      canvas.save();
      canvas.rotate(i * math.pi / 3);
      
      // Draw diamond shapes
      final path = Path();
      path.moveTo(0, -100);
      path.lineTo(50, -50);
      path.lineTo(0, 0);
      path.lineTo(-50, -50);
      path.close();
      
      canvas.drawPath(path, paint);
      
      // Draw lines extending from diamonds
      canvas.drawLine(
        const Offset(0, -100),
        const Offset(0, -150),
        paint,
      );
      
      canvas.restore();
    }

    // Draw concentric circles
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(
        Offset.zero,
        i * 80.0,
        paint..color = const Color(0xFFD4AF37).withOpacity(0.05),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}