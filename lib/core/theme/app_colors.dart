import 'package:flutter/material.dart';

/// AppColors defines the exact palette specified in the Cooperative Services Master Spec
class AppColors {
  AppColors._();

  // Primary Palette (exact hex values from Section 2.1)
  static const frostedMint = Color(0xFFD8F3DC); // lightest background tint
  static const celadon = Color(0xFFB7E4C7); // secondary background / chip fills
  static const celadon2 = Color(0xFF95D5B2); // hover/pressed states, disabled-accent
  static const mintLeaf = Color(0xFF74C69D); // secondary buttons, tags, success accents
  static const mintLeaf2 = Color(0xFF52B788); // primary accent (links, active nav icon)
  static const seaGreen = Color(0xFF40916C); // primary buttons, CTAs
  static const darkEmerald = Color(0xFF2D6A4F); // headers, primary text on light bg, app bar
  static const pineTeal = Color(0xFF1B4332); // dark mode surface / deep headers
  static const evergreen = Color(0xFF081C15); // near-black text, dark mode background

  // Secondary & Functional Accents
  static const amberWarning = Color(0xFFF4A300);
  static const redDestructive = Color(0xFFD64545);
  static const white = Color(0xFFFFFFFF);
  static const cardBackground = Color(0xFFFFFFFF);
  static const lightSurfaceContainer = Color(0xFFE2F9ED);
  static const lightSurfaceVariant = Color(0xFFDCF3E7);
  static const textPrimary = Color(0xFF081C15);
  static const textSecondary = Color(0xFF3F4943);
  static const subtleBorder = Color(0xFFBEC9C0);
}
