import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'tribes_screen.dart'; // Import to use TribeData

class TribeDetailsScreen extends StatefulWidget {
  final TribeData tribe;

  const TribeDetailsScreen({super.key, required this.tribe});

  @override
  State<TribeDetailsScreen> createState() => _TribeDetailsScreenState();
}

class _TribeDetailsScreenState extends State<TribeDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _rotateController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _rotateController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_rotateController);

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _rotateController.repeat();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              widget.tribe.color.withOpacity(0.3),
              const Color(0xFF1A3D2B),
              const Color(0xFF0F2419),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated tribal pattern background
            _buildTribalPatternBackground(),
            
            // Main content
            CustomScrollView(
              slivers: [
                _buildSliverAppBar(),
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          _buildTribeOverview(),
                          _buildTribeStory(),
                          _buildCategoryButtons(),
                          _buildTribalElements(),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
            painter: DetailedTribalPatternPainter(
              widget.tribe.color,
              _rotateAnimation.value,
            ),
            child: Container(),
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300.0,
      floating: false,
      pinned: true,
      backgroundColor: widget.tribe.color.withOpacity(0.9),
      leading: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.tribe.name.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            shadows: [
              Shadow(
                color: Colors.black54,
                offset: Offset(1, 1),
                blurRadius: 3,
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    widget.tribe.color.withOpacity(0.6),
                    widget.tribe.color.withOpacity(0.8),
                    widget.tribe.color,
                  ],
                ),
              ),
            ),
            Center(
              child: AnimatedBuilder(
                animation: _rotateAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotateAnimation.value * 0.1,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: CustomPaint(
                        painter: TribalSymbolPainter(Colors.white.withOpacity(0.4)),
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

  Widget _buildTribeOverview() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.tribe.accentColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.tribe.color.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: widget.tribe.accentColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'ABOUT THE TRIBE',
                style: TextStyle(
                  color: widget.tribe.accentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            _getTribeOverview(widget.tribe.name),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.6,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTribeStory() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.tribe.color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_stories,
                color: widget.tribe.color,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'CULTURAL HERITAGE',
                style: TextStyle(
                  color: widget.tribe.color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            _getTribeStory(widget.tribe.name),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.7,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.explore,
                color: const Color(0xFFD4AF37),
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'EXPLORE CATEGORIES',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: widget.tribe.categories.asMap().entries.map((entry) {
              int index = entry.key;
              String category = entry.value;
              return _buildCategoryButton(category, index);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category, int index) {
    final colors = [
      const Color(0xFF8B4513),
      const Color(0xFF2E8B57),
      const Color(0xFFB8860B),
      const Color(0xFF4682B4),
    ];

    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _navigateToCategory(category);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200 + (index * 50)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors[index % colors.length].withOpacity(0.8),
              colors[index % colors.length].withOpacity(0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colors[index % colors.length].withOpacity(0.7),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: colors[index % colors.length].withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                _getCategoryIcon(category),
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              category.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(1, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _getCategoryCount(category),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTribalElements() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTribalElement(
            icon: Icons.location_on,
            title: 'ORIGIN',
            subtitle: _getTribeLocation(widget.tribe.name),
            color: widget.tribe.color,
          ),
          _buildTribalElement(
            icon: Icons.groups,
            title: 'POPULATION',
            subtitle: _getTribePopulation(widget.tribe.name),
            color: widget.tribe.accentColor,
          ),
          _buildTribalElement(
            icon: Icons.language,
            title: 'LANGUAGE',
            subtitle: widget.tribe.name,
            color: const Color(0xFFD4AF37),
          ),
        ],
      ),
    );
  }

  Widget _buildTribalElement({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'music': return Icons.music_note;
      case 'video': return Icons.videocam;
      case 'artifacts': return Icons.museum;
      case 'image': return Icons.image;
      default: return Icons.category;
    }
  }

  String _getCategoryCount(String category) {
    final counts = {
      'Music': '12 items',
      'Video': '8 items',
      'Artifacts': '25 items',
      'Image': '45 items',
    };
    return counts[category] ?? '0 items';
  }

  String _getTribeOverview(String tribeName) {
    switch (tribeName) {
      case 'Ata Manobo':
        return 'The Ata Manobo people are indigenous to the mountainous regions of Mindanao. They are known for their rich oral traditions, intricate beadwork, and deep spiritual connection to nature.';
      case 'Mansaka':
        return 'The Mansaka tribe inhabits the eastern part of Davao del Norte and Compostela Valley. They are renowned for their traditional weaving techniques and agricultural practices.';
      case 'Mandaya':
        return 'The Mandaya tribe is one of the major indigenous groups in Mindanao, primarily found in Davao Oriental. They are masters of traditional music and dance ceremonies.';
      default:
        return 'This indigenous tribe has a rich cultural heritage that spans centuries.';
    }
  }

  String _getTribeStory(String tribeName) {
    switch (tribeName) {
      case 'Ata Manobo':
        return 'Legend tells that the Ata Manobo descended from the heavens, guided by spirits to settle in the mountains. Their ancestors were blessed with the knowledge of healing herbs and the ability to commune with nature spirits.';
      case 'Mansaka':
        return 'The Mansaka people trace their origins to ancient settlers who discovered fertile valleys perfect for agriculture. Their ancestors were skilled in metallurgy, creating tools and jewelry.';
      case 'Mandaya':
        return 'The Mandaya origin story speaks of divine beings who taught their ancestors the sacred dances that honor the spirits of nature. These ceremonies ensure good harvests and protect the community.';
      default:
        return 'This tribe carries forward ancient traditions through stories and customs.';
    }
  }

  String _getTribeLocation(String tribeName) {
    switch (tribeName) {
      case 'Ata Manobo': return 'Bukidnon\nMisamis Oriental';
      case 'Mansaka': return 'Davao del Norte\nCompostela Valley';
      case 'Mandaya': return 'Davao Oriental\nSurigao del Sur';
      default: return 'Mindanao';
    }
  }

  String _getTribePopulation(String tribeName) {
    switch (tribeName) {
      case 'Ata Manobo': return '~150,000';
      case 'Mansaka': return '~50,000';
      case 'Mandaya': return '~80,000';
      default: return 'Unknown';
    }
  }

  void _navigateToCategory(String category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.tribe.color.withOpacity(0.9),
        title: Row(
          children: [
            Icon(_getCategoryIcon(category), color: Colors.white),
            const SizedBox(width: 12),
            Text(category, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Opening ${widget.tribe.name} $category collection...',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class DetailedTribalPatternPainter extends CustomPainter {
  final Color color;
  final double rotation;
  
  DetailedTribalPatternPainter(this.color, this.rotation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rotation * 0.1);

    for (int i = 0; i < 8; i++) {
      canvas.save();
      canvas.rotate(i * math.pi / 4);
      
      final path = Path();
      path.moveTo(0, -200);
      path.lineTo(20, -180);
      path.lineTo(0, -160);
      path.lineTo(-20, -180);
      path.close();
      
      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class TribalSymbolPainter extends CustomPainter {
  final Color color;
  
  TribalSymbolPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    for (int i = 0; i < 6; i++) {
      final angle = i * math.pi / 3;
      final start = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      final end = Offset(
        center.dx + (radius * 0.7) * math.cos(angle + math.pi / 6),
        center.dy + (radius * 0.7) * math.sin(angle + math.pi / 6),
      );
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}