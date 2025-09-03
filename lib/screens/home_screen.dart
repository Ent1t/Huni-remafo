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
            
            // Main content - FIXED OVERFLOW
            SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 
                              MediaQuery.of(context).padding.top - 
                              MediaQuery.of(context).padding.bottom - 70, // Bottom nav height
                  ),
                  child: Column(
                    children: [
                      // App title with tribal styling
                      _buildTribalHeader(),
                      
                      // Main content area
                      Expanded(
                        flex: 0, // Don't expand infinitely
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Main QR scanner button
                            _buildMainQRButton(context),
                            
                            const SizedBox(height: 30), // Reduced spacing
                            
                            // Subtitle with cultural context
                            _buildSubtitle(),
                          ],
                        ),
                      ),
                      
                      // Bottom navigation hint - FIXED POSITIONING
                      _buildBottomHint(),
                      
                      // Add some bottom padding for the bottom nav
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
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
            children: List.generate(6, (index) { // Reduced from 8
              return Positioned(
                left: (index * 60.0) % MediaQuery.of(context).size.width,
                top: 100 + (index * 100.0) + _floatAnimation.value,
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
            width: 120, // Reduced width
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
          
          const SizedBox(height: 16), // Reduced spacing
          
          // App title - RESPONSIVE TEXT SIZE
          FittedBox(
            fit: BoxFit.scaleDown,
            child: ShaderMask(
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
                  fontSize: 28, // Reduced from 32
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 6), // Reduced spacing
          
          const Text(
            'Cultural Heritage Museum',
            style: TextStyle(
              fontSize: 12, // Reduced from 14
              color: Color(0xFFB8B8B8),
              letterSpacing: 1.5,
              fontWeight: FontWeight.w300,
            ),
          ),
          
          const SizedBox(height: 16), // Reduced spacing
          
          // Decorative tribal line
          Container(
            height: 3,
            width: 120, // Reduced width
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
              width: 240, // Reduced from 280
              height: 240, // Reduced from 280
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
                    blurRadius: 25, // Reduced shadow
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(18), // Reduced margin
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
                      size: 70, // Reduced from 80
                      color: Color(0xFFD4AF37),
                    ),
                    SizedBox(height: 16), // Reduced spacing
                    Text(
                      'SCAN',
                      style: TextStyle(
                        color: Color(0xFFD4AF37),
                        fontSize: 24, // Reduced from 28
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                    SizedBox(height: 6), // Reduced spacing
                    Text(
                      'QR CODE',
                      style: TextStyle(
                        color: Color(0xFFB8B8B8),
                        fontSize: 14, // Reduced from 16
                        letterSpacing: 1.5,
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
      padding: const EdgeInsets.symmetric(horizontal: 30), // Reduced padding
      child: Column(
        children: [
          const Text(
            'Discover Indigenous Heritage',
            style: TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 18, // Reduced from 20
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 12), // Reduced spacing
          
          const Text(
            'Scan QR codes on museum exhibits to explore\nthe rich culture of indigenous tribes',
            style: TextStyle(
              color: Color(0xFFB8B8B8),
              fontSize: 14, // Reduced from 16
              height: 1.4,
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 20), // Reduced spacing
          
          // Decorative dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 6, // Reduced size
                height: 6,
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
      padding: const EdgeInsets.symmetric(horizontal: 20), // Removed vertical padding
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Reduced padding
        decoration: BoxDecoration(
          color: const Color(0xFF2D5A3D).withOpacity(0.8),
          borderRadius: BorderRadius.circular(16), // Reduced radius
          border: Border.all(
            color: const Color(0xFFD4AF37).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.swipe_up,
              color: Color(0xFFD4AF37),
              size: 18, // Reduced size
            ),
            SizedBox(width: 6),
            Flexible(
              child: Text(
                'Explore more in Tribes section',
                style: TextStyle(
                  color: Color(0xFFB8B8B8),
                  fontSize: 12, // Reduced from 14
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
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
      ..color = const Color(0xFFD4AF37).withOpacity(0.08) // Reduced opacity
      ..strokeWidth = 1.5 // Reduced stroke width
      ..style = PaintingStyle.stroke;

    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rotation);

    // Draw tribal geometric patterns
    for (int i = 0; i < 6; i++) {
      canvas.save();
      canvas.rotate(i * math.pi / 3);
      
      // Draw diamond shapes
      final path = Path();
      path.moveTo(0, -80); // Reduced size
      path.lineTo(40, -40);
      path.lineTo(0, 0);
      path.lineTo(-40, -40);
      path.close();
      
      canvas.drawPath(path, paint);
      
      // Draw lines extending from diamonds
      canvas.drawLine(
        const Offset(0, -80),
        const Offset(0, -120), // Reduced size
        paint,
      );
      
      canvas.restore();
    }

    // Draw concentric circles
    for (int i = 1; i <= 2; i++) { // Reduced circles
      canvas.drawCircle(
        Offset.zero,
        i * 60.0, // Reduced size
        paint..color = const Color(0xFFD4AF37).withOpacity(0.04),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}