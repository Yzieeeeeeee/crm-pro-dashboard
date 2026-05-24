import 'package:flutter/material.dart';

/// Centralized color palette for the CRM Dashboard.
/// Inspired by Linear, Stripe, and modern SaaS design systems.
class AppColors {
  AppColors._();

  // ── Brand Primary (Indigo) ──────────────────────────────
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF3730A3);
  static const Color primarySurface = Color(0xFFEEF2FF);
  static const Color primarySurfaceDark = Color(0xFF1E1B4B);

  // ── Accent (Teal / Emerald) ─────────────────────────────
  static const Color accent = Color(0xFF0D9488);
  static const Color accentLight = Color(0xFF5EEAD4);
  static const Color accentDark = Color(0xFF115E59);

  // ── Semantic ────────────────────────────────────────────
  static const Color success = Color(0xFF059669);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF2563EB);
  static const Color infoLight = Color(0xFFDBEAFE);

  // ── Neutral (Light Mode) ────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // ── Dark Mode Surfaces ──────────────────────────────────
  static const Color darkBg = Color(0xFF0F1117);
  static const Color darkSurface = Color(0xFF1A1D2E);
  static const Color darkCard = Color(0xFF222539);
  static const Color darkBorder = Color(0xFF2E3148);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // ── Light Mode Surfaces ─────────────────────────────────
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // ── Gradients ───────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D9488), Color(0xFF06B6D4)],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F1117), Color(0xFF1A1D2E)],
  );

  static const LinearGradient loginGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1E1B4B), Color(0xFF0F1117)],
  );

  // ── Avatar Gradient Palette ─────────────────────────────
  static const List<LinearGradient> avatarGradients = [
    LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)]),
    LinearGradient(colors: [Color(0xFF0D9488), Color(0xFF06B6D4)]),
    LinearGradient(colors: [Color(0xFFDB2777), Color(0xFFF43F5E)]),
    LinearGradient(colors: [Color(0xFFEA580C), Color(0xFFF59E0B)]),
    LinearGradient(colors: [Color(0xFF059669), Color(0xFF34D399)]),
    LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF38BDF8)]),
    LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)]),
    LinearGradient(colors: [Color(0xFFDC2626), Color(0xFFF87171)]),
  ];
}
