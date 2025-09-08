import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'tribes_screen.dart'; // Import to use TribeData

class CategoryDetailScreen extends StatefulWidget {
  final TribeData tribe;
  final String category;

  const CategoryDetailScreen({
    super.key,
    required this.tribe,
    required this.category,
  });

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _rotateController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotateAnimation;

  String selectedFilter = 'All'; // Filter for content type

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

    _rotateController = AnimationController(
      duration: const Duration(seconds: 20),
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
              widget.tribe.color.withOpacity(0.2),
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
                          // Category info and filters
                          _buildCategoryHeader(),
                          
                          // Content based on category type
                          _buildCategoryContent(),
                          
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
      expandedHeight: 200.0,
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
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              _showCategoryInfo();
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          '${widget.tribe.name} - ${widget.category.toUpperCase()}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
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
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(
                        _getCategoryIcon(widget.category),
                        color: Colors.white.withOpacity(0.4),
                        size: 40,
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

  Widget _buildCategoryHeader() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category description
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.tribe.color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getCategoryIcon(widget.category),
                      color: widget.tribe.accentColor,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'ABOUT ${widget.category.toUpperCase()}',
                      style: TextStyle(
                        color: widget.tribe.accentColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _getCategoryDescription(widget.category, widget.tribe.name),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Filter tabs
          _buildFilterTabs(),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = _getFiltersForCategory(widget.category);
    
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;
          
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                selectedFilter = filter;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(right: index < filters.length - 1 ? 10 : 0),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          widget.tribe.color,
                          widget.tribe.accentColor,
                        ],
                      )
                    : null,
                color: isSelected ? null : Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected 
                      ? Colors.white.withOpacity(0.5)
                      : widget.tribe.color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected 
                      ? Colors.white
                      : widget.tribe.color,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryContent() {
    switch (widget.category.toLowerCase()) {
      case 'image':
        return _buildImageGallery();
      case 'video':
        return _buildVideoList();
      case 'music':
        return _buildMusicList();
      case 'artifacts':
        return _buildArtifactsList();
      default:
        return _buildGenericContent();
    }
  }

  Widget _buildImageGallery() {
    // Sample image data structure - Replace with your actual data
    final sampleImages = _getSampleImageData();
    final filteredImages = selectedFilter == 'All' 
        ? sampleImages 
        : sampleImages.where((img) => img['type'] == selectedFilter).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${filteredImages.length} Images Found',
                style: TextStyle(
                  color: widget.tribe.accentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Filter: $selectedFilter',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Grid of images
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: filteredImages.length,
            itemBuilder: (context, index) {
              final imageData = filteredImages[index];
              return _buildImageCard(imageData);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(Map<String, dynamic> imageData) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _showImageDetail(imageData);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.tribe.color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image placeholder - REPLACE WITH ACTUAL IMAGE
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.tribe.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: widget.tribe.color.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      color: widget.tribe.color.withOpacity(0.5),
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'IMAGE\nPLACEHOLDER',
                      style: TextStyle(
                        color: widget.tribe.color.withOpacity(0.5),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            // Image info
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      imageData['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: widget.tribe.accentColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            imageData['type'],
                            style: TextStyle(
                              color: widget.tribe.accentColor,
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          imageData['year'].toString(),
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoList() {
    final sampleVideos = _getSampleVideoData();
    final filteredVideos = selectedFilter == 'All' 
        ? sampleVideos 
        : sampleVideos.where((vid) => vid['type'] == selectedFilter).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: filteredVideos.map((videoData) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.tribe.color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Video thumbnail placeholder
                Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.tribe.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.play_circle_fill,
                    color: widget.tribe.color,
                    size: 40,
                  ),
                ),
                
                // Video info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          videoData['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          videoData['description'],
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: widget.tribe.accentColor,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              videoData['duration'],
                              style: TextStyle(
                                color: widget.tribe.accentColor,
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: widget.tribe.accentColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                videoData['type'],
                                style: TextStyle(
                                  color: widget.tribe.accentColor,
                                  fontSize: 8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Play button
                Container(
                  margin: const EdgeInsets.all(12),
                  child: IconButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      _playVideo(videoData);
                    },
                    icon: Icon(
                      Icons.play_arrow,
                      color: widget.tribe.color,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMusicList() {
    final sampleMusic = _getSampleMusicData();
    final filteredMusic = selectedFilter == 'All' 
        ? sampleMusic 
        : sampleMusic.where((music) => music['type'] == selectedFilter).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: filteredMusic.map((musicData) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.tribe.color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: widget.tribe.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.music_note,
                  color: widget.tribe.color,
                  size: 24,
                ),
              ),
              title: Text(
                musicData['title'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    musicData['description'],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: widget.tribe.accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          musicData['type'],
                          style: TextStyle(
                            color: widget.tribe.accentColor,
                            fontSize: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        musicData['duration'],
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _playMusic(musicData);
                },
                icon: Icon(
                  Icons.play_circle_fill,
                  color: widget.tribe.accentColor,
                  size: 28,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildArtifactsList() {
    final sampleArtifacts = _getSampleArtifactsData();
    final filteredArtifacts = selectedFilter == 'All' 
        ? sampleArtifacts 
        : sampleArtifacts.where((art) => art['type'] == selectedFilter).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.5,
        ),
        itemCount: filteredArtifacts.length,
        itemBuilder: (context, index) {
          final artifactData = filteredArtifacts[index];
          return _buildArtifactCard(artifactData);
        },
      ),
    );
  }

  Widget _buildArtifactCard(Map<String, dynamic> artifactData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.tribe.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Artifact image placeholder
          Container(
            width: 100,
            height: double.infinity,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.tribe.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.museum,
                  color: widget.tribe.color,
                  size: 30,
                ),
                const SizedBox(height: 4),
                Text(
                  'ARTIFACT',
                  style: TextStyle(
                    color: widget.tribe.color.withOpacity(0.7),
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Artifact info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    artifactData['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    artifactData['description'],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: widget.tribe.accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          artifactData['type'],
                          style: TextStyle(
                            color: widget.tribe.accentColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Era: ${artifactData['era']}',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // More info button
          Container(
            margin: const EdgeInsets.all(12),
            child: IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                _showArtifactDetail(artifactData);
              },
              icon: Icon(
                Icons.info_outline,
                color: widget.tribe.accentColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenericContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: const Text(
        'Content for this category is being prepared...',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Sample data methods - REPLACE WITH YOUR ACTUAL DATA
  List<Map<String, dynamic>> _getSampleImageData() {
    return [
      {
        'title': 'Traditional Ceremony',
        'type': 'Ceremony',
        'year': 1985,
        'description': 'Ancient ritual ceremony of the ${widget.tribe.name} people',
        // TO ADD YOUR IMAGE:
        // 'imagePath': 'assets/images/${widget.tribe.name.toLowerCase()}/ceremony_1.jpg',
        // OR for network images:
        // 'imageUrl': 'https://your-domain.com/images/ceremony_1.jpg',
      },
      {
        'title': 'Traditional Clothing',
        'type': 'Clothing',
        'year': 1992,
        'description': 'Traditional garments worn during festivals',
        // 'imagePath': 'assets/images/${widget.tribe.name.toLowerCase()}/clothing_1.jpg',
      },
      {
        'title': 'Ancient Tools',
        'type': 'Tools',
        'year': 1978,
        'description': 'Tools used for daily activities',
        // 'imagePath': 'assets/images/${widget.tribe.name.toLowerCase()}/tools_1.jpg',
      },
      {
        'title': 'Village Life',
        'type': 'Lifestyle',
        'year': 2001,
        'description': 'Daily life in the tribal community',
        // 'imagePath': 'assets/images/${widget.tribe.name.toLowerCase()}/village_1.jpg',
      },
    ];
  }

  List<Map<String, dynamic>> _getSampleVideoData() {
    return [
      {
        'title': 'Sacred Dance Ritual',
        'type': 'Ceremony',
        'duration': '12:34',
        'description': 'Traditional dance performed during harvest season',
        // TO ADD YOUR VIDEO:
        // 'videoPath': 'assets/videos/${widget.tribe.name.toLowerCase()}/dance_ritual.mp4',
        // OR for network videos:
        // 'videoUrl': 'https://your-domain.com/videos/dance_ritual.mp4',
      },
      {
        'title': 'Weaving Demonstration',
        'type': 'Crafts',
        'duration': '8:45',
        'description': 'How traditional textiles are made',
        // 'videoPath': 'assets/videos/${widget.tribe.name.toLowerCase()}/weaving.mp4',
      },
      {
        'title': 'Oral History',
        'type': 'History',
        'duration': '15:20',
        'description': 'Elder sharing tribal legends and stories',
        // 'videoPath': 'assets/videos/${widget.tribe.name.toLowerCase()}/oral_history.mp4',
      },
    ];
  }

  List<Map<String, dynamic>> _getSampleMusicData() {
    return [
      {
        'title': 'Harvest Song',
        'type': 'Traditional',
        'duration': '3:45',
        'description': 'Song sung during rice harvest celebrations',
        // TO ADD YOUR AUDIO:
        // 'audioPath': 'assets/audio/${widget.tribe.name.toLowerCase()}/harvest_song.mp3',
        // OR for network audio:
        // 'audioUrl': 'https://your-domain.com/audio/harvest_song.mp3',
      },
      {
        'title': 'War Chant',
        'type': 'Ceremonial',
        'duration': '5:12',
        'description': 'Ancient chant performed before battles',
        // 'audioPath': 'assets/audio/${widget.tribe.name.toLowerCase()}/war_chant.mp3',
      },
      {
        'title': 'Lullaby',
        'type': 'Folk',
        'duration': '2:30',
        'description': 'Traditional song for children',
        // 'audioPath': 'assets/audio/${widget.tribe.name.toLowerCase()}/lullaby.mp3',
      },
      {
        'title': 'Healing Song',
        'type': 'Spiritual',
        'duration': '7:18',
        'description': 'Chant used in healing rituals',
        // 'audioPath': 'assets/audio/${widget.tribe.name.toLowerCase()}/healing_song.mp3',
      },
    ];
  }

  List<Map<String, dynamic>> _getSampleArtifactsData() {
    return [
      {
        'title': 'Sacred Beadwork',
        'type': 'Jewelry',
        'era': 'Pre-colonial',
        'description': 'Intricate beadwork used in ceremonial attire. Made from natural materials and passed down through generations.',
        // TO ADD ARTIFACT IMAGES:
        // 'imagePath': 'assets/images/artifacts/${widget.tribe.name.toLowerCase()}/beadwork_1.jpg',
      },
      {
        'title': 'Hunting Spear',
        'type': 'Weapon',
        'era': '19th Century',
        'description': 'Traditional spear crafted from bamboo and metal tips, used for hunting wild boar.',
        // 'imagePath': 'assets/images/artifacts/${widget.tribe.name.toLowerCase()}/spear_1.jpg',
      },
      {
        'title': 'Ceremonial Mask',
        'type': 'Ritual',
        'era': 'Ancient',
        'description': 'Wooden mask carved for spiritual ceremonies, believed to channel ancestral spirits.',
        // 'imagePath': 'assets/images/artifacts/${widget.tribe.name.toLowerCase()}/mask_1.jpg',
      },
      {
        'title': 'Weaving Loom',
        'type': 'Tool',
        'era': '18th Century',
        'description': 'Traditional loom used to create textiles and clothing from natural fibers.',
        // 'imagePath': 'assets/images/artifacts/${widget.tribe.name.toLowerCase()}/loom_1.jpg',
      },
    ];
  }

  List<String> _getFiltersForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'image':
        return ['All', 'Ceremony', 'Clothing', 'Tools', 'Lifestyle'];
      case 'video':
        return ['All', 'Ceremony', 'Crafts', 'History'];
      case 'music':
        return ['All', 'Traditional', 'Ceremonial', 'Folk', 'Spiritual'];
      case 'artifacts':
        return ['All', 'Jewelry', 'Weapon', 'Ritual', 'Tool'];
      default:
        return ['All'];
    }
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

  String _getCategoryDescription(String category, String tribeName) {
    switch (category.toLowerCase()) {
      case 'music':
        return 'Discover the traditional musical heritage of the $tribeName people. Each song carries deep cultural meaning and connects the community to their ancestors through rhythm and melody.';
      case 'video':
        return 'Watch authentic recordings of $tribeName ceremonies, crafts, and cultural practices. These visual documentations preserve living traditions for future generations.';
      case 'artifacts':
        return 'Explore the material culture of the $tribeName tribe through their handcrafted tools, ceremonial objects, and daily-use items that tell stories of their way of life.';
      case 'image':
        return 'Browse through a collection of historical and contemporary photographs showcasing the $tribeName people, their customs, and cultural expressions through time.';
      default:
        return 'Explore this aspect of $tribeName culture and heritage.';
    }
  }

  void _showCategoryInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A3D2B),
        title: Row(
          children: [
            Icon(
              _getCategoryIcon(widget.category),
              color: const Color(0xFFD4AF37),
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              '${widget.category} Collection',
              style: const TextStyle(
                color: Color(0xFFD4AF37),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getCategoryDescription(widget.category, widget.tribe.name),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'How to add your own content:',
              style: TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildDataInstructions(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'GOT IT',
              style: TextStyle(
                color: Color(0xFFD4AF37),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataInstructions() {
    String instructions = '';
    switch (widget.category.toLowerCase()) {
      case 'image':
        instructions = '''1. Add images to: assets/images/tribes/${widget.tribe.name.toLowerCase()}/
2. Update _getSampleImageData() method
3. Add 'imagePath': 'assets/images/...' to each item
4. Update pubspec.yaml to include new assets''';
        break;
      case 'video':
        instructions = '''1. Add videos to: assets/videos/${widget.tribe.name.toLowerCase()}/
2. Update _getSampleVideoData() method  
3. Add 'videoPath': 'assets/videos/...' to each item
4. Install video_player package for playback''';
        break;
      case 'music':
        instructions = '''1. Add audio to: assets/audio/${widget.tribe.name.toLowerCase()}/
2. Update _getSampleMusicData() method
3. Add 'audioPath': 'assets/audio/...' to each item
4. Use audioplayers package (already included)''';
        break;
      case 'artifacts':
        instructions = '''1. Add artifact images to: assets/images/artifacts/${widget.tribe.name.toLowerCase()}/
2. Update _getSampleArtifactsData() method
3. Add 'imagePath': 'assets/images/artifacts/...' to each item
4. Include detailed descriptions and historical context''';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        instructions,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
          height: 1.4,
        ),
      ),
    );
  }

  void _showImageDetail(Map<String, dynamic> imageData) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A3D2B),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image placeholder
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: widget.tribe.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      color: widget.tribe.color,
                      size: 60,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'IMAGE PLACEHOLDER',
                      style: TextStyle(
                        color: widget.tribe.color,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              Text(
                imageData['title'],
                style: const TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              Text(
                imageData['description'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Type: ${imageData['type']}',
                    style: TextStyle(
                      color: widget.tribe.accentColor,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Year: ${imageData['year']}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'CLOSE',
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _playVideo(Map<String, dynamic> videoData) {
    // TODO: Implement video playback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing: ${videoData['title']}'),
        backgroundColor: widget.tribe.color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _playMusic(Map<String, dynamic> musicData) {
    // TODO: Implement audio playback using audioplayers package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing: ${musicData['title']}'),
        backgroundColor: widget.tribe.color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showArtifactDetail(Map<String, dynamic> artifactData) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A3D2B),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Artifact image placeholder
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: widget.tribe.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.museum,
                      color: widget.tribe.color,
                      size: 50,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ARTIFACT PLACEHOLDER',
                      style: TextStyle(
                        color: widget.tribe.color,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              Text(
                artifactData['title'],
                style: const TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: widget.tribe.accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      artifactData['type'],
                      style: TextStyle(
                        color: widget.tribe.accentColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Era: ${artifactData['era']}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Text(
                artifactData['description'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 20),
              
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'CLOSE',
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for detailed tribal patterns
class DetailedTribalPatternPainter extends CustomPainter {
  final Color color;
  final double rotation;
  
  DetailedTribalPatternPainter(this.color, this.rotation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.03)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rotation * 0.1);

    // Draw subtle tribal patterns
    for (int i = 0; i < 8; i++) {
      canvas.save();
      canvas.rotate(i * math.pi / 4);
      
      final path = Path();
      path.moveTo(0, -150);
      path.lineTo(15, -130);
      path.lineTo(0, -110);
      path.lineTo(-15, -130);
      path.close();
      
      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}