import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Useful extensions on BuildContext.
extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  bool get isDark => theme.brightness == Brightness.dark;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

/// Extensions on String.
extension StringExtensions on String {
  /// Returns initials from a name (up to 2 characters).
  String get initials {
    final parts = trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  /// Capitalizes the first letter.
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

/// Extensions on DateTime.
extension DateTimeExtensions on DateTime {
  /// Formats date as 'Jan 15, 2024'.
  String get formatted => DateFormat('MMM d, y').format(this);

  /// Formats time as '2:30 PM'.
  String get formattedTime => DateFormat('h:mm a').format(this);

  /// Formats as 'Jan 15, 2024 at 2:30 PM'.
  String get formattedFull => DateFormat('MMM d, y \'at\' h:mm a').format(this);

  /// Returns a relative time string like '2 hours ago'.
  String get timeAgo {
    final diff = DateTime.now().difference(this);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return formatted;
  }
}

/// Extensions on num for currency formatting.
extension NumExtensions on num {
  /// Formats as compact currency: $1.2K, $3.4M, etc.
  String get compactCurrency {
    if (this >= 1000000) {
      return '\$${(this / 1000000).toStringAsFixed(1)}M';
    }
    if (this >= 1000) {
      return '\$${(this / 1000).toStringAsFixed(1)}K';
    }
    return '\$${toStringAsFixed(0)}';
  }

  /// Formats as compact number: 1.2K, 3.4M, etc.
  String get compact {
    if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    }
    if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toStringAsFixed(0);
  }
}
