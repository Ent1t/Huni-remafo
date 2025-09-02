import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class QuickAccessButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const QuickAccessButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.boneChilling,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: AppColors.murmur,
            width: 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32.0,
              color: AppColors.terrestrial,
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.lavaStone,
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
