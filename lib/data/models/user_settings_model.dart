// lib/data/models/user_settings_model.dart
class UserSettings {
  final String userId;
  final String theme;
  final bool notificationsEnabled;
  final bool autoSave;
  final Map<String, dynamic> preferences;

  UserSettings({
    required this.userId,
    this.theme = 'light',
    this.notificationsEnabled = true,
    this.autoSave = true,
    this.preferences = const {},
  });

  factory UserSettings.fromSupabase(Map<String, dynamic> json) {
    return UserSettings(
      userId: json['user_id'],
      theme: json['theme'] ?? 'light',
      notificationsEnabled: json['notifications_enabled'] ?? true,
      autoSave: json['auto_save'] ?? true,
      preferences: json['preferences'] ?? {},
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'user_id': userId,
      'theme': theme,
      'notifications_enabled': notificationsEnabled,
      'auto_save': autoSave,
      'preferences': preferences,
    };
  }

  UserSettings copyWith({
    String? userId,
    String? theme,
    bool? notificationsEnabled,
    bool? autoSave,
    Map<String, dynamic>? preferences,
  }) {
    return UserSettings(
      userId: userId ?? this.userId,
      theme: theme ?? this.theme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      autoSave: autoSave ?? this.autoSave,
      preferences: preferences ?? this.preferences,
    );
  }
}
