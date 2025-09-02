import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class TribeFilterCard extends StatelessWidget {
  final String tribeName;
  final bool isSelected;
  final VoidCallback onTap;

  const TribeFilterCard({
    super.key,
    required this.tribeName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.terrestrial : AppColors.boneChilling,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isSelected ? AppColors.evergreen : AppColors.murmur,
            width: 2.0,
          ),
        ),
        child: Row(
          children: [
            // Image Placeholder
            Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.sparklingSnow : AppColors.candiedSnow,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(
                Icons.groups,
                color: isSelected ? AppColors.terrestrial : AppColors.terrestrial,
                size: 32.0,
              ),
            ),
            
            const SizedBox(width: 16.0),
            
            // Tribe Name
            Expanded(
              child: Text(
                tribeName,
                style: TextStyle(
                  color: isSelected ? AppColors.sparklingSnow : AppColors.lavaStone,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            
            // Selection Indicator
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.sparklingSnow,
                size: 24.0,
              ),
          ],
        ),
      ),
    );
  }
}
