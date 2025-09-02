import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tribe_details_screen.dart';

class TribesScreen extends StatefulWidget {
  const TribesScreen({super.key});

  @override
  State<TribesScreen> createState() => _TribesScreenState();
}
  
class _TribesScreenState extends State<TribesScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String? selectedTribe;
  
  final List<TribeData> tribes = [
    TribeData(
      name: 'Ata Manobo',
      description: 'Known for their rich oral traditions and intricate beadwork',
      color: const Color(0xFFD2691E), // Saddle brown
      accentColor: const Color(0xFFFF8C00), // Dark orange
      pattern: 'assets/patterns/manobo_pattern.png',
      categories: ['Music', 'Video', 'Artifacts', 'Image'],
    ),
    TribeData(
      name: 'Mansaka',
      description: 'Renowned for their traditional weaving and agricultural practices',
      color: const Color(0xFF8B4513), // Saddle brown
      accentColor: const Color(0xFFCD853F), // Peru
      pattern: 'assets/patterns/mansaka_pattern.png',
      categories: ['Music', 'Video', 'Artifacts', 'Image'],
    ),
    TribeData(
      name: 'Mandaya',
      description: 'Masters of traditional music and dance ceremonies',
      color: const Color(0xFFA0522D), // Sienna
      accentColor: const Color(0xFFDEB887), // Burlywood
      pattern: 'assets/patterns/mandaya_pattern.png',
      categories: ['Music', 'Video', 'Artifacts', 'Image'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
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

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
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
              Color(0xFF1A3D2B), // Dark forest
              Color(0xFF0F2419), // Very dark green
              Color(0xFF051008), // Almost black
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTribalHeader(),
              Expanded(
                child: selectedTribe == null
                    ? _buildTribesGrid()
                    : _buildTribeDetails(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTribalHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              if (selectedTribe != null)
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      selectedTribe = null;
                    });
                    _fadeController.reset();
                    _slideController.reset();
                    _fadeController.forward();
                    _slideController.forward();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFFD4AF37),
                      size: 24,
                    ),
                  ),
                ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFFD4AF37),
                      Color(0xFFFFD700),
                      Color(0xFFB8860B),
                    ],
                  ).createShader(bounds),
                  child: Text(
                    selectedTribe ?? 'INDIGENOUS TRIBES',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.transparent,
                  Color(0xFFD4AF37),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTribesGrid() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Explore Cultural Heritage',
                style: TextStyle(
                  color: Color(0xFFB8B8B8),
                  fontSize: 16,
                  letterSpacing: 1,
                ),
              ),
              
              const SizedBox(height: 30),
              
              Expanded(
                child: ListView.builder(
                  itemCount: tribes.length,
                  itemBuilder: (context, index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300 + (index * 100)),
                      curve: Curves.easeOutBack,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: _buildTribeCard(tribes[index], index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildTribeCard(TribeData tribe, int index) {
  return GestureDetector(
    onTap: () {                           
      HapticFeedback.mediumImpact();
      Navigator.push(                     
        context,
        MaterialPageRoute(
          builder: (context) => TribeDetailsScreen(tribe: tribe),
        ),
      );
    },          
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              tribe.color.withOpacity(0.8),
              tribe.color.withOpacity(0.6),
              tribe.accentColor.withOpacity(0.4),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: tribe.color.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Tribal pattern overlay
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CustomPaint(
                  painter: TribalCardPatternPainter(
                    tribe.color,
                    index.toDouble(),
                  ),
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tribe.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(1, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        tribe.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${tribe.categories.length} Categories',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                      
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTribeDetails() {
    final tribe = tribes.firstWhere((t) => t.name == selectedTribe);
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tribe.description,
                style: const TextStyle(
                  color: Color(0xFFB8B8B8),
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 30),
              
              const Text(
                'CULTURAL CATEGORIES',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              
              const SizedBox(height: 20),
              
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: tribe.categories.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryCard(
                      tribe.categories[index],
                      tribe,
                      index,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String category, TribeData tribe, int index) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // Navigate to category details
        _showCategoryDetails(category, tribe);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              tribe.color.withOpacity(0.3),
              tribe.accentColor.withOpacity(0.2),
            ],
          ),
          border: Border.all(
            color: tribe.color.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getCategoryIcon(category),
              color: tribe.accentColor,
              size: 40,
            ),
            
            const SizedBox(height: 12),
            
            Text(
              category.toUpperCase(),
              style: TextStyle(
                color: tribe.accentColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'music':
        return Icons.music_note;
      case 'video':
        return Icons.videocam;
      case 'artifacts':
        return Icons.museum;
      case 'image':
        return Icons.image;
      default:
        return Icons.category;
    }
  }

  void _showCategoryDetails(String category, TribeData tribe) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              tribe.color.withOpacity(0.9),
              tribe.color,
            ],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Icon(
              _getCategoryIcon(category),
              color: Colors.white,
              size: 50,
            ),
            
            const SizedBox(height: 16),
            
            Text(
              '${tribe.name} - $category',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'Explore the rich $category collection of the ${tribe.name} tribe. Discover traditional practices, cultural heritage, and historical significance.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 30),
            
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Navigate to detailed category screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: tribe.color,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'EXPLORE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data class for tribe information
class TribeData {
  final String name;
  final String description;
  final Color color;
  final Color accentColor;
  final String pattern;
  final List<String> categories;

  TribeData({
    required this.name,
    required this.description,
    required this.color,
    required this.accentColor,
    required this.pattern,
    required this.categories,
  });
}

// Custom painter for tribal card patterns
class TribalCardPatternPainter extends CustomPainter {
  final Color color;
  final double seed;
  
  TribalCardPatternPainter(this.color, this.seed);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw tribal geometric patterns based on seed
    for (int i = 0; i < 3; i++) {
      final offset = seed * 50 + i * 60;
      
      // Draw diamond pattern
      final path = Path();
      path.moveTo(size.width * 0.8, offset);
      path.lineTo(size.width * 0.9, offset + 20);
      path.lineTo(size.width * 0.8, offset + 40);
      path.lineTo(size.width * 0.7, offset + 20);
      path.close();
      
      canvas.drawPath(path, paint);
      
      // Draw connecting lines
      canvas.drawLine(
        Offset(size.width * 0.8, offset - 10),
        Offset(size.width * 0.8, offset),
        paint,
      );
    }

    // Draw corner decorations
    final cornerPaint = Paint()
      ..color = color.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.1),
      30,
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}