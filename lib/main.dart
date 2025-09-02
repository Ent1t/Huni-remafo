import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'screens/tribes_screen.dart';
import 'screens/translation_screen.dart';
import 'utils/app_colors.dart';

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
      activeColor: AppColors.orangeBrown,
    ),
    NavItem(
      icon: Icons.translate_rounded,
      label: 'Translate',
      activeColor: AppColors.lightBrown,
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.forestGreen.withOpacity(0.9),
              AppColors.deepForest,
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
        child: SafeArea(
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (index) {
                return _buildNavItem(index);
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = _currentIndex == index;
    final navItem = _navItems[index];

    return GestureDetector(
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? navItem.activeColor.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(
                  color: navItem.activeColor.withOpacity(0.3),
                  width: 1,
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected
                    ? navItem.activeColor.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                navItem.icon,
                color: isSelected 
                    ? navItem.activeColor
                    : AppColors.lightText.withOpacity(0.7),
                size: isSelected ? 26 : 24,
              ),
            ),
            
            const SizedBox(height: 4),
            
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: isSelected 
                    ? navItem.activeColor
                    : AppColors.lightText.withOpacity(0.7),
                fontSize: isSelected ? 12 : 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                letterSpacing: 0.5,
              ),
              child: Text(navItem.label),
            ),
          ],
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