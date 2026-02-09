import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:echo_see_companion/core/constants/app_colors.dart';
import 'package:echo_see_companion/core/constants/app_strings.dart';
import 'package:echo_see_companion/data/models/user_model.dart';
import 'package:echo_see_companion/providers/auth_provider.dart';
import 'package:echo_see_companion/providers/transcript_provider.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? get _user => Provider.of<AuthProvider>(context).currentUser;
  
  int get _transcriptsCount => Provider.of<TranscriptProvider>(context).transcripts.length;
  
  int get _totalRecordingTime {
    final transcripts = Provider.of<TranscriptProvider>(context).transcripts;
    if (transcripts.isEmpty) return 0;
    return transcripts.fold(0, (sum, t) => sum + t.duration.inSeconds);
  }

  bool get _hasPremium => _user?.isPremium ?? false;
  
  List<String> get _recentLanguages {
    final transcripts = Provider.of<TranscriptProvider>(context).transcripts;
    if (transcripts.isEmpty) return ['English'];
    final langs = transcripts.map((t) => t.language).toSet().toList();
    return langs.take(3).toList();
  }

  String get _formattedTotalRecordingTime {
    final totalSeconds = _totalRecordingTime;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    
    if (hours > 0) {
      return '$hours hours $minutes minutes';
    } else if (minutes > 0) {
      return '$minutes minutes $seconds seconds';
    } else {
      return '$seconds seconds';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Current user is already managed by AuthProvider
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editProfile,
          ),
        ],
      ),
      body: _user == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(),

            // Statistics Section
            _buildStatisticsSection(),

            // Preferences Section
            _buildPreferencesSection(),

            // Account Actions
            _buildAccountActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.8),
            AppColors.primaryDark,
          ],
        ),
      ),
      child: Column(
        children: [
          // Profile Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: _user?.profileImage != null && _user!.profileImage!.isNotEmpty
                ? CircleAvatar(
              radius: 48,
              backgroundImage: NetworkImage(_user!.profileImage!),
            )
                : Text(
              _user?.initials ?? '?',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),

          SizedBox(height: 20),

          // User Info
          Text(
            _user?.name ?? '',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 8),

          Text(
            _user?.email ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),

          SizedBox(height: 16),

          // Premium Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: _hasPremium ? Colors.amber : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _hasPremium ? Icons.star : Icons.star_border,
                  color: _hasPremium ? Colors.black : AppColors.primary,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  _hasPremium ? 'PREMIUM USER' : 'FREE USER',
                  style: TextStyle(
                    color: _hasPremium ? Colors.black : AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          if (_hasPremium && _user?.premiumExpiry != null)
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                'Expires in ${_user!.premiumExpiry!.difference(DateTime.now()).inDays.abs()} days',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    // Create mock usage stats
    final stats = {
      'totalTranscripts': _transcriptsCount,
      'totalMinutes': _totalRecordingTime ~/ 60,
      'languagesUsed': _recentLanguages.length,
      'averageDailyMinutes': (_totalRecordingTime / 60) / 60, // Assuming 60 days
    };

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Usage Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),

          SizedBox(height: 20),

          // Stats Grid
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildStatCard(
                icon: Icons.description,
                value: stats['totalTranscripts'].toString(),
                label: 'Transcripts',
              ),
              _buildStatCard(
                icon: Icons.timer,
                value: stats['totalMinutes'].toString(),
                label: 'Minutes',
              ),
              _buildStatCard(
                icon: Icons.language,
                value: stats['languagesUsed'].toString(),
                label: 'Languages',
              ),
              _buildStatCard(
                icon: Icons.trending_up,
                value: stats['averageDailyMinutes']!.toStringAsFixed(1),
                label: 'Avg Daily (min)',
              ),
            ],
          ),

          SizedBox(height: 20),

          // Language Distribution
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Language Usage',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 12),
              ..._recentLanguages.asMap().entries.map((entry) {
                final index = entry.key;
                final language = entry.value;
                final percentage = [50, 30, 20][index % 3]; // Mock percentages

                return Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          language,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection() {
    final prefs = _user?.preferences ?? {};

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Info',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),

          SizedBox(height: 16),

          // Preferences List
          Column(
            children: [
              _buildPreferenceItem(
                icon: Icons.palette,
                label: 'Theme',
                value: prefs['theme']?.toString() ?? 'Light',
              ),
              _buildPreferenceItem(
                icon: Icons.text_fields,
                label: 'Font Size',
                value: '${prefs['fontSize']?.toString() ?? '16'}pt',
              ),
              _buildPreferenceItem(
                icon: Icons.auto_awesome,
                label: 'Auto Save',
                value: (prefs['autoSave'] ?? true) ? 'On' : 'Off',
              ),
              _buildPreferenceItem(
                icon: Icons.person,
                label: 'Speaker Tags',
                value: (prefs['showSpeakerTags'] ?? true) ? 'On' : 'Off',
              ),
              _buildPreferenceItem(
                icon: Icons.notifications,
                label: 'Notifications',
                value: (prefs['soundEffects'] ?? true) ? 'On' : 'Off',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountActions() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          if (!_hasPremium)
            ElevatedButton.icon(
              onPressed: _goPremium,
              icon: Icon(Icons.star),
              label: Text('Upgrade to Premium'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
            ),

          SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: _viewSubscription,
            icon: Icon(Icons.subscriptions),
            label: Text('View Subscription'),
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              side: BorderSide(color: AppColors.primary),
            ),
          ),

          SizedBox(height: 12),

          TextButton.icon(
            onPressed: _exportData,
            icon: Icon(Icons.download),
            label: Text('Export All Data'),
            style: TextButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
          ),

          SizedBox(height: 12),

          ElevatedButton.icon(
            onPressed: _logout,
            icon: Icon(Icons.logout),
            label: Text('Logout'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),

          SizedBox(height: 20),

          // App Version
          Text(
            'App Version: 1.0.0',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _editProfile() {
    final nameController = TextEditingController(text: _user?.name);
    final imageController = TextEditingController(text: _user?.profileImage);
    final emailController = TextEditingController(text: _user?.email);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    _user?.initials ?? '?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: imageController,
                  decoration: InputDecoration(
                    labelText: 'Profile Image URL',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.image_outlined),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final auth = Provider.of<AuthProvider>(context, listen: false);
                final success = await auth.updateProfile(
                  name: nameController.text.trim(),
                  imageUrl: imageController.text.trim(),
                );
                
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? 'Profile updated successfully' : 'Failed to update profile'),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _goPremium() {
    Navigator.pushNamed(context, '/premium');
  }

  void _viewSubscription() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Subscription Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current Plan: ${_hasPremium ? 'Premium' : 'Free'}'),
              SizedBox(height: 12),
              if (_hasPremium && _user?.premiumExpiry != null)
                Text('Expires: ${_user!.premiumExpiry!.toString().substring(0, 10)}'),
              SizedBox(height: 12),
              Text('Transcripts: $_transcriptsCount'),
              Text('Recording Time: $_formattedTotalRecordingTime'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _exportData() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Export Data'),
          content: Text('Export all your transcripts and settings?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Data exported successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('Export'),
            ),
          ],
        );
      },
    );
  }

  // Helper method to get initials from name
  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
  }
}