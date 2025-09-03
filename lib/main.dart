import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'screens/tribes_screen.dart';
import 'screens/translation_screen.dart';
import 'utils/app_colors.dart';
import 'dart:math' as math;

void main() {
  runApp(const HuniSaTribuApp());
}

class HuniSaTribuApp extends StatelessWidget {
  const HuniSaTribuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Huni sa Tribu',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        primaryColor: AppColors.tribalGold,
        scaffoldBackgroundColor: AppColors.deepForest,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.deepForest,
          foregroundColor: AppColors.tribalGold,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.forestGreen,
          selectedItemColor: AppColors.tribalGold,
          unselectedItemColor: AppColors.lightText,
          type: BottomNavigationBarType.fixed,
          elevation: 10,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: AppColors.whiteText,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: AppColors.tribalGold,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            color: AppColors.lightText,
          ),
          bodyMedium: TextStyle(
            color: AppColors.lightText,
          ),
        ),
      ),
      home: const MainNavigationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _navAnimationController;
  late Animation<double> _navAnimation;

  final List<Widget> _screens = [
    const HomeScreen(),
    const TribesScreen(),
    const TranslationScreen(),
  ];

  final List<NavItem> _navItems = [
    NavItem(
      icon: Icons.home_rounded,
      label: 'Scan',
      activeColor: AppColors.tribalGold,
    ),
    NavItem(
      icon: Icons.groups_rounded,
      label: 'Tribes',
      activeColor: AppColors.tribalGold,
    ),
    NavItem(
      icon: Icons.translate_rounded,
      label: 'Translate',
      activeColor: AppColors.tribalGold,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _navAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _navAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _navAnimationController,
      curve: Curves.easeInOut,
    ));
    _navAnimationController.forward();
  }

  @override
  void dispose() {
    _navAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final bottomPadding = mediaQuery.padding.bottom;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF2D5A3D).withOpacity(0.95), // Forest green
            const Color(0xFF1A3D2B), // Darker forest
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 85 + bottomPadding,
          minHeight: 70,
        ),
        padding: EdgeInsets.only(
          top: 8,
          bottom: math.max(8, bottomPadding),
          left: 16,
          right: 16,
        ),
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(_navItems.length, (index) {
              return _buildNavItem(index);
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = _currentIndex == index;
    final navItem = _navItems[index];
    
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (_currentIndex != index) {
              HapticFeedback.lightImpact();
              setState(() {
                _currentIndex = index;
              });
              _navAnimationController.reset();
              _navAnimationController.forward();
            }
          },
          borderRadius: BorderRadius.circular(12),
          splashColor: AppColors.tribalGold.withOpacity(0.2),
          highlightColor: AppColors.tribalGold.withOpacity(0.1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            constraints: const BoxConstraints(
              maxHeight: 54,
              minHeight: 50,
            ),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isSelected 
                ? AppColors.tribalGold.withOpacity(0.15)
                : Colors.transparent,
              border: isSelected
                ? Border.all(
                    color: AppColors.tribalGold.withOpacity(0.3),
                    width: 1,
                  )
                : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppColors.tribalGold.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    navItem.icon,
                    color: isSelected 
                        ? AppColors.tribalGold
                        : AppColors.lightText.withOpacity(0.7),
                    size: 20,
                  ),
                ),
                
                const SizedBox(height: 2),
                
                // Text label with animation
                Flexible(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    style: TextStyle(
                      color: isSelected 
                          ? AppColors.tribalGold
                          : AppColors.lightText.withOpacity(0.7),
                      fontSize: 9,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                    child: Text(
                      navItem.label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                
                // Active indicator dot
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(top: 1),
                  height: 2,
                  width: isSelected ? 16 : 0,
                  decoration: BoxDecoration(
                    color: AppColors.tribalGold,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  final Color activeColor;

  NavItem({
    required this.icon,
    required this.label,
    required this.activeColor,
  });
}