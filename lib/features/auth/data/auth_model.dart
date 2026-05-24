import 'package:equatable/equatable.dart';

/// Domain model representing an authenticated user.
class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
  });

  /// Returns up to two-character initials from the user's name.
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  List<Object?> get props => [id, name, email, role, avatarUrl];
}
