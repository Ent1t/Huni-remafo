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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    
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
            
            // Main content - COMPLETELY FIXED OVERFLOW
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate available space more precisely
                  final availableHeight = constraints.maxHeight;
                  const bottomNavSpace = 50.0; // Compact nav height
                  final workingHeight = availableHeight - bottomNavSpace;
                  
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: workingHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            // App title with tribal styling - RESPONSIVE
                            _buildTribalHeader(screenWidth),
                            
                            // Main content area - FLEXIBLE SPACING
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Main QR scanner button - RESPONSIVE SIZE
                                    _buildMainQRButton(context, screenWidth, screenHeight),
                                    
                                    // Flexible spacing
                                    SizedBox(height: screenHeight * 0.03), // 3% of screen height
                                    
                                    // Subtitle with cultural context - COMPACT
                                    _buildSubtitle(screenWidth),
                                  ],
                                ),
                              ),
                            ),
                            
                            // Bottom hint - FIXED AT BOTTOM
                            _buildBottomHint(screenWidth),
                            
                            // Safe bottom padding
                            SizedBox(height: math.max(20, safeAreaBottom + 10)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
            children: List.generate(6, (index) {
              return Positioned(
                left: (index * 60.0) % MediaQuery.of(context).size.width,
                top: 100 + (index * 80.0) + _floatAnimation.value, // Reduced spacing
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

  Widget _buildTribalHeader(double screenWidth) {
    // Make header size responsive to screen width
    final isSmallScreen = screenWidth < 360;
    final titleFontSize = isSmallScreen ? 24.0 : 28.0;
    final subtitleFontSize = isSmallScreen ? 10.0 : 12.0;
    final lineWidth = isSmallScreen ? 100.0 : 120.0;
    final verticalSpacing = isSmallScreen ? 12.0 : 16.0;
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05, // 5% of screen width
        vertical: 15.0, // Reduced vertical padding
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decorative tribal line
          Container(
            height: 3,
            width: lineWidth,
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
          
          SizedBox(height: verticalSpacing * 0.75),
          
          // App title - FULLY RESPONSIVE
          FittedBox(
            fit: BoxFit.scaleDown,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: screenWidth * 0.9, // Max 90% of screen width
              ),
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFFD4AF37),
                    Color(0xFFFFD700),
                    Color(0xFFB8860B),
                  ],
                ).createShader(bounds),
                child: Text(
                  'HUNI SA TRIBU',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: isSmallScreen ? 1.5 : 2,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          
          SizedBox(height: verticalSpacing * 0.4),
          
          Text(
            'Cultural Heritage Museum',
            style: TextStyle(
              fontSize: subtitleFontSize,
              color: const Color(0xFFB8B8B8),
              letterSpacing: isSmallScreen ? 1.0 : 1.5,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: verticalSpacing * 0.75),
          
          // Decorative tribal line
          Container(
            height: 3,
            width: lineWidth,
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

  Widget _buildMainQRButton(BuildContext context, double screenWidth, double screenHeight) {
    // Make button size responsive to screen size
    final isSmallScreen = screenWidth < 360 || screenHeight < 650;
    final buttonSize = isSmallScreen ? 200.0 : 240.0;
    final iconSize = isSmallScreen ? 60.0 : 70.0;
    final scanFontSize = isSmallScreen ? 20.0 : 24.0;
    final qrFontSize = isSmallScreen ? 12.0 : 14.0;
    final marginSize = isSmallScreen ? 15.0 : 18.0;
    
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
              width: buttonSize,
              height: buttonSize,
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
                    blurRadius: isSmallScreen ? 20 : 25,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Container(
                margin: EdgeInsets.all(marginSize),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF2D5A3D).withOpacity(0.9),
                  border: Border.all(
                    color: const Color(0xFFD4AF37),
                    width: 3,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      size: iconSize,
                      color: const Color(0xFFD4AF37),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    Text(
                      'SCAN',
                      style: TextStyle(
                        color: const Color(0xFFD4AF37),
                        fontSize: scanFontSize,
                        fontWeight: FontWeight.bold,
                        letterSpacing: isSmallScreen ? 2 : 3,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 4 : 6),
                    Text(
                      'QR CODE',
                      style: TextStyle(
                        color: const Color(0xFFB8B8B8),
                        fontSize: qrFontSize,
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

  Widget _buildSubtitle(double screenWidth) {
    final isSmallScreen = screenWidth < 360;
    final titleFontSize = isSmallScreen ? 16.0 : 18.0;
    final bodyFontSize = isSmallScreen ? 12.0 : 14.0;
    final horizontalPadding = screenWidth * 0.08; // 8% of screen width
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Discover Indigenous Heritage',
            style: TextStyle(
              color: const Color(0xFFD4AF37),
              fontSize: titleFontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: isSmallScreen ? 10 : 12),
          
          Text(
            'Scan QR codes on museum exhibits to explore\nthe rich culture of indigenous tribes',
            style: TextStyle(
              color: const Color(0xFFB8B8B8),
              fontSize: bodyFontSize,
              height: 1.4,
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: isSmallScreen ? 16 : 20),
          
          // Decorative dots - RESPONSIVE
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isSmallScreen ? 5 : 6,
                height: isSmallScreen ? 5 : 6,
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

  Widget _buildBottomHint(double screenWidth) {
    final isSmallScreen = screenWidth < 360;
    final fontSize = isSmallScreen ? 11.0 : 12.0;
    final iconSize = isSmallScreen ? 16.0 : 18.0;
    final horizontalPadding = screenWidth * 0.05; // 5% of screen width
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16, 
          vertical: isSmallScreen ? 8 : 10,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF2D5A3D).withOpacity(0.8),
          borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
          border: Border.all(
            color: const Color(0xFFD4AF37).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.swipe_up,
              color: const Color(0xFFD4AF37),
              size: iconSize,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                'Explore more in Tribes section',
                style: TextStyle(
                  color: const Color(0xFFB8B8B8),
                  fontSize: fontSize,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for tribal patterns - OPTIMIZED
class TribalPatternPainter extends CustomPainter {
  final double rotation;
  
  TribalPatternPainter(this.rotation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4AF37).withOpacity(0.06) // Reduced opacity
      ..strokeWidth = 1.2 // Slightly reduced stroke
      ..style = PaintingStyle.stroke;

    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rotation);

    // Draw fewer, smaller tribal geometric patterns
    for (int i = 0; i < 6; i++) {
      canvas.save();
      canvas.rotate(i * math.pi / 3);
      
      // Draw diamond shapes - SMALLER
      final path = Path();
      path.moveTo(0, -60); // Reduced from -80
      path.lineTo(30, -30); // Reduced from 40, -40
      path.lineTo(0, 0);
      path.lineTo(-30, -30); // Reduced from -40, -40
      path.close();
      
      canvas.drawPath(path, paint);
      
      // Draw shorter lines extending from diamonds
      canvas.drawLine(
        const Offset(0, -60),
        const Offset(0, -90), // Reduced from -120
        paint,
      );
      
      canvas.restore();
    }

    // Draw fewer concentric circles
    for (int i = 1; i <= 2; i++) {
      canvas.drawCircle(
        Offset.zero,
        i * 50.0, // Reduced from 60
        paint..color = const Color(0xFFD4AF37).withOpacity(0.03),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}