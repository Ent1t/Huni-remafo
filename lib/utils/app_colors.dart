import 'package:flutter/material.dart';

class AppColors {
  // Tribal theme color palette
  static const Color deepForest = Color(0xFF1A3D2B);        // Primary dark background
  static const Color forestGreen = Color(0xFF2D5A3D);       // Secondary background
  static const Color darkestGreen = Color(0xFF0F2419);      // Darkest background
  
  // Gold/Bronze accents (tribal metals)
  static const Color tribalGold = Color(0xFFD4AF37);        // Primary gold
  static const Color lightGold = Color(0xFFFFD700);         // Bright gold
  static const Color darkGold = Color(0xFFB8860B);          // Dark gold
  
  // Earth tones (tribal colors)
  static const Color earthBrown = Color(0xFF8B4513);        // Saddle brown
  static const Color warmBrown = Color(0xFFA0522D);         // Sienna
  static const Color lightBrown = Color(0xFFDEB887);        // Burlywood
  static const Color orangeBrown = Color(0xFFD2691E);       // Chocolate
  
  // Text colors
  static const Color lightText = Color(0xFFB8B8B8);         // Light gray text
  static const Color whiteText = Color(0xFFF5F5F5);         // Off-white text
  static const Color darkText = Color(0xFF2C2C2C);          // Dark text
  
  // Functional colors
  static const Color success = Color(0xFF4CAF50);           // Success green
  static const Color warning = Color(0xFFFF9800);           // Warning orange
  static const Color error = Color(0xFFE53E3E);             // Error red
  
  // Legacy colors (for backward compatibility)
  static const Color sparklingSnow = Color(0xFFF3FFFF);
  static const Color candiedSnow = Color(0xFFDDFCF3);
  static const Color terrestrial = tribalGold;              // Updated to tribal gold
  static const Color evergreen = deepForest;                // Updated to deep forest
  static const Color murmur = lightText;                    // Updated to light text
  static const Color boneChilling = Color(0xFFDBF7F1);
  static const Color lavaStone = darkText;                  // Updated to dark text
  
  // Gradient combinations for tribal effects
  static List<Color> forestGradient = [
    deepForest,
    forestGreen,
    darkestGreen,
  ];
  
  static List<Color> goldGradient = [
    tribalGold,
    lightGold,
    darkGold,
  ];
  
  static List<Color> earthGradient = [
    earthBrown,
    warmBrown,
    lightBrown,
  ];
}