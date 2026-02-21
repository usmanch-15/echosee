# EchoSee App - Complete Prototype Data

## Project Overview
**App Name:** EchoSee (Echo See Companion)  
**Type:** Flutter Mobile App for Smart Glasses  
**Features:** Speech Recognition, Transcription, Translation, Lip Tracking, Sound Recognition  
**Backend:** Supabase (PostgreSQL)  
**State Management:** Provider  

---

## 1. APP STRUCTURE

### Directory Structure
```
lib/
├── main.dart                          # App entry point
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   ├── app_styles.dart
│   │   └── keys.dart
│   ├── theme/
│   └── utils/
│       └── navigation_service.dart
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── transcript_model.dart
│   │   └── user_settings_model.dart
│   └── repositories/
│       ├── user_repository.dart
│       ├── transcript_repository.dart
│       ├── translation_repository.dart
│       ├── settings_repository.dart
│       ├── supabase_user_repository.dart
│       └── supabase_transcript_repository.dart
├── providers/
│   ├── auth_provider.dart             # User authentication
│   ├── transcript_provider.dart        # Transcript management
│   └── app_theme_provider.dart         # Theme switching
├── services/
│   ├── speech_service.dart             # Speech-to-text
│   ├── lip_tracking_service.dart       # Lip detection
│   └── yamnet_service.dart             # Sound classification
└── presentation/
    ├── screens/
    │   ├── splash_screen.dart
    │   ├── login_screen.dart
    │   ├── signup_screen.dart
    │   ├── reset_password_screen.dart
    │   ├── main_screen.dart
    │   ├── transcript_list_screen.dart
    │   ├── transcript_detail_screen.dart
    │   ├── sound_recognition_screen.dart
    │   ├── lip_tracking_screen.dart
    │   ├── history_screen.dart
    │   ├── profile_screen.dart
    │   ├── settings_screen.dart
    │   ├── accounts_screen.dart
    │   ├── features_screen.dart
    │   ├── payment_screen.dart
    │   └── premium_features_screen.dart
    └── widgets/
        └── [Custom widgets & components]
```

---

## 2. DATA MODELS

### User Model
```json
{
  "id": "uuid-123456",
  "name": "John Doe",
  "email": "john.doe@example.com",
  "profileImage": "https://example.com/profile.jpg",
  "createdAt": "2024-01-15T10:30:00Z",
  "isPremium": true,
  "premiumExpiry": "2025-12-31T23:59:59Z",
  "preferences": {
    "language": "en",
    "theme": "dark",
    "notifications": true,
    "autoTranslate": true
  },
  "usageStats": {
    "totalTranscripts": 45,
    "totalMinutes": 320,
    "languagesUsed": 3,
    "lastActive": "2024-02-21T14:30:00Z",
    "languageDistribution": {
      "English": 25,
      "Spanish": 12,
      "French": 8
    },
    "dailyUsage": {
      "2024-02-21": 45,
      "2024-02-20": 52,
      "2024-02-19": 38
    }
  }
}
```

### Transcript Model
```json
{
  "id": "transcript-001",
  "title": "Team Meeting - Project Update",
  "content": "Speaker 1: Good morning everyone. Today we'll discuss the Q1 roadmap. Speaker 2: Thanks for organizing this...",
  "date": "2024-02-21T10:00:00Z",
  "duration": 1800,
  "language": "en",
  "hasTranslation": true,
  "isStarred": true,
  "translatedContent": "Buenos días a todos. Hoy discutiremos...",
  "translatedLanguage": "es",
  "speakerSegments": [
    {
      "speakerId": 1,
      "speakerName": "John",
      "text": "Good morning everyone. Today we'll discuss the Q1 roadmap.",
      "startTime": 0,
      "endTime": 15
    },
    {
      "speakerId": 2,
      "speakerName": "Sarah",
      "text": "Thanks for organizing this meeting.",
      "startTime": 18,
      "endTime": 25
    }
  ]
}
```

### Usage Stats Model
```json
{
  "totalTranscripts": 45,
  "totalMinutes": 320,
  "languagesUsed": 3,
  "lastActive": "2024-02-21T14:30:00Z",
  "languageDistribution": {
    "English": 25,
    "Spanish": 12,
    "French": 8
  },
  "dailyUsage": {
    "2024-02-21": 45,
    "2024-02-20": 52,
    "2024-02-19": 38,
    "2024-02-18": 41
  }
}
```

---

## 3. AUTHENTICATION FLOWS

### Login Request/Response
**Request:**
```json
{
  "email": "john.doe@example.com",
  "password": "securePassword123"
}
```

**Response (Success):**
```json
{
  "user": {
    "id": "uuid-123456",
    "email": "john.doe@example.com",
    "name": "John Doe"
  },
  "session": {
    "access_token": "eyJhbGc...",
    "refresh_token": "eyJhbGc...",
    "expires_in": 3600
  }
}
```

### Signup Request/Response
**Request:**
```json
{
  "name": "Jane Smith",
  "email": "jane.smith@example.com",
  "password": "securePassword456"
}
```

**Response (Success):**
```json
{
  "user": {
    "id": "uuid-789012",
    "email": "jane.smith@example.com",
    "name": "Jane Smith",
    "createdAt": "2024-02-21T15:00:00Z"
  },
  "confirmationRequired": true,
  "message": "Please check your email to confirm your account"
}
```

---

## 4. API ENDPOINTS (SUPABASE RPC FUNCTIONS)

### User Management
- `GET /rest/v1/users/{id}` - Get user profile
- `PUT /rest/v1/users/{id}` - Update user profile
- `DELETE /rest/v1/users/{id}` - Delete account
- `POST /auth/v1/token` - Login
- `POST /auth/v1/signup` - Register
- `POST /auth/v1/recover` - Reset password

### Transcripts
- `GET /rest/v1/transcripts?user_id=eq.{id}` - Get user transcripts
- `POST /rest/v1/transcripts` - Create transcript
- `PUT /rest/v1/transcripts/{id}` - Update transcript
- `DELETE /rest/v1/transcripts/{id}` - Delete transcript
- `PATCH /rest/v1/transcripts/{id}` - Star/Unstar transcript

### Translations
- `POST /rest/v1/translations` - Save translation
- `GET /rest/v1/translations/{transcript_id}` - Get translations

### Speaker Segments
- `POST /rest/v1/speaker_segments` - Create speaker segment
- `PUT /rest/v1/speaker_segments/{id}` - Update speaker name
- `GET /rest/v1/speaker_segments?transcript_id=eq.{id}` - Get segments

---

## 5. APP SCREENS & ROUTES

### Navigation Routes
```dart
class NavigationService {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static Map<String, WidgetBuilder> routes = {
    '/': (context) => SplashScreen(),
    '/login': (context) => LoginScreen(),
    '/signup': (context) => SignupScreen(),
    '/reset-password': (context) => ResetPasswordScreen(),
    '/main': (context) => MainScreen(),
    '/transcript-list': (context) => TranscriptListScreen(),
    '/transcript-detail': (context) => TranscriptDetailScreen(),
    '/sound-recognition': (context) => SoundRecognitionScreen(),
    '/lip-tracking': (context) => LipTrackingScreen(),
    '/history': (context) => HistoryScreen(),
    '/profile': (context) => ProfileScreen(),
    '/settings': (context) => SettingsScreen(),
    '/accounts': (context) => AccountsScreen(),
    '/features': (context) => FeaturesScreen(),
    '/payment': (context) => PaymentScreen(),
    '/premium': (context) => PremiumFeaturesScreen(),
  };
}
```

### Screen Details

#### 1. Splash Screen
- Shows app logo/branding
- Auto-login check
- Routes to Login or MainScreen

#### 2. Authentication Screens
- **Login**: Email + Password fields
- **Signup**: Name + Email + Password + Confirm Password
- **Reset Password**: Email field + send link

#### 3. Main Screen
- Bottom navigation (Home, Transcripts, History, Profile)
- Floating action button for new recording
- Quick access to features

#### 4. Transcript Management
- **List**: Displays all transcripts with search/filter
- **Detail**: Full transcript view, edit speaker names, translate, export

#### 5. Feature Screens
- **Sound Recognition**: Identifies sounds/music
- **Lip Tracking**: Face detection and lip movement tracking
- **History**: View past activity

#### 6. Settings
- Profile management
- Theme switching (Light/Dark)
- Language preferences
- Notification settings
- Account management
- Premium management

---

## 6. GLOBAL COLORS & THEME

### Color Palette
```dart
class AppColors {
  // Primary
  static const Color primary = Color(0xFF4361EE);           // Blue
  static const Color primaryDark = Color(0xFF3A0CA3);       // Dark Blue
  static const Color primaryLight = Color(0xFF4CC9F0);      // Light Blue

  // Accent
  static const Color accent = Color(0xFFF72585);            // Pink
  static const Color accent2 = Color(0xFF7209B7);           // Purple

  // Background
  static const Color backgroundLight = Color(0xFFF8F9FA);   // Light Gray
  static const Color backgroundDark = Color(0xFF121212);    // Dark
  static const Color cardLight = Color(0xFFFFFFFF);         // White
  static const Color cardDark = Color(0xFF1E1E1E);          // Dark Gray

  // Text
  static const Color textLight = Color(0xFF000000);
  static const Color textDark = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF6C757D);

  // Status
  static const Color success = Color(0xFF4CAF50);           // Green
  static const Color error = Color(0xFFF44336);             // Red
  static const Color warning = Color(0xFFFF9800);           // Orange
  static const Color info = Color(0xFF2196F3);              // Blue

  // Speaker Colors
  static const List<Color> speakerColors = [
    Color(0xFF2196F3),  // Blue
    Color(0xFFE91E63),  // Pink
    Color(0xFF9C27B0),  // Purple
    Color(0xFF009688),  // Teal
  ];

  // Subtitle Colors
  static const List<Color> subtitleColors = [
    Color(0xFFFFFFFF),  // White
    Color(0xFFFFD700),  // Gold
    Color(0xFF00FF00),  // Green
    Color(0xFF00FFFF),  // Cyan
    Color(0xFFFF69B4),  // Pink
  ];
}
```

---

## 7. KEY DEPENDENCIES

```yaml
dependencies:
  flutter: sdk flutter
  
  # State Management
  provider: ^6.0.5
  supabase_flutter: ^2.5.6
  google_sign_in: ^6.2.1

  # UI Components
  lottie: ^2.7.0
  animated_text_kit: ^4.2.2
  flutter_svg: ^2.0.9
  flutter_animate: ^4.1.2
  shimmer: ^3.0.0

  # Storage
  sqflite: ^2.3.0
  shared_preferences: ^2.2.2

  # Audio/Speech
  speech_to_text: ^7.3.0
  audio_session: ^0.1.11
  just_audio: ^0.9.35

  # AI/ML
  tflite_flutter: ^0.12.0
  google_mlkit_face_detection: ^0.11.0

  # Hardware
  camera: ^0.11.0+2
  permission_handler: ^11.3.1
  sound_stream: ^0.4.2

  # Charts
  fl_chart: ^0.66.0

  # Utilities
  intl: ^0.18.1
  uuid: ^4.4.0
  path_provider: ^2.1.0
  url_launcher: ^6.2.0
```

---

## 8. STATE MANAGEMENT (PROVIDERS)

### AuthProvider
```dart
class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Properties
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;
  bool get isPremium => _currentUser?.isPremium ?? false;

  // Methods
  Future<void> login(String email, String password)
  Future<void> signup(String name, String email, String password)
  Future<void> logout()
  Future<void> resetPassword(String email)
  Future<bool> updateProfile({name, imageUrl})
  Future<void> togglePremium()
  Future<void> refreshUser()
}
```

### TranscriptProvider
```dart
class TranscriptProvider extends ChangeNotifier {
  List<Transcript> _transcripts = [];
  bool _isLoading = false;
  String? _error;

  // Methods
  Future<void> loadTranscripts({int limit = 50})
  Future<void> saveTranscript(Transcript transcript)
  Future<void> deleteTranscript(String id)
  Future<void> toggleStar(String id)
  Future<void> translateTranscript(String id, String targetLanguage)
  Future<void> updateSpeakerName(String transcriptId, int speakerId, String name)
}
```

### AppThemeProvider
```dart
class AppThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  
  // Properties
  bool get isDarkMode => _isDarkMode;
  ThemeData get themeData => _isDarkMode ? darkTheme : lightTheme;

  // Methods
  void toggleTheme()
  void setTheme(bool isDark)
}
```

---

## 9. SAMPLE TEST DATA

### Sample User
```json
{
  "id": "user-001",
  "name": "Alex Johnson",
  "email": "alex.johnson@example.com",
  "profileImage": "https://i.pravatar.cc/150?img=1",
  "createdAt": "2023-06-15T08:30:00Z",
  "isPremium": true,
  "premiumExpiry": "2025-06-15T23:59:59Z",
  "preferences": {
    "language": "en",
    "theme": "dark",
    "notifications": true,
    "autoTranslate": true,
    "defaultTranslationLanguage": "es",
    "privateMode": false
  },
  "usageStats": {
    "totalTranscripts": 127,
    "totalMinutes": 1850,
    "languagesUsed": 5,
    "lastActive": "2024-02-21T14:30:00Z",
    "languageDistribution": {
      "English": 60,
      "Spanish": 35,
      "French": 20,
      "German": 8,
      "Portuguese": 4
    },
    "dailyUsage": {
      "2024-02-21": 45,
      "2024-02-20": 52,
      "2024-02-19": 38,
      "2024-02-18": 41,
      "2024-02-17": 55
    }
  }
}
```

### Sample Transcripts List
```json
[
  {
    "id": "trans-001",
    "title": "Weekly Team Standup",
    "content": "John: Good morning team. Let's start with status updates. Sarah: I finished the authentication module yesterday. It's ready for testing. Mike: I'm working on the payment integration. Should be done this week.",
    "date": "2024-02-21T10:00:00Z",
    "duration": 1200,
    "language": "en",
    "hasTranslation": true,
    "isStarred": true,
    "translatedLanguage": "es",
    "speakerSegments": [
      {
        "speakerId": 1,
        "speakerName": "John",
        "text": "Good morning team. Let's start with status updates.",
        "startTime": 0,
        "endTime": 8
      },
      {
        "speakerId": 2,
        "speakerName": "Sarah",
        "text": "I finished the authentication module yesterday. It's ready for testing.",
        "startTime": 10,
        "endTime": 20
      }
    ]
  },
  {
    "id": "trans-002",
    "title": "Client Presentation",
    "content": "Presenter: Today we're showing you the new features. Client: This looks great. When can we deploy? Presenter: Next month.",
    "date": "2024-02-20T14:30:00Z",
    "duration": 1800,
    "language": "en",
    "hasTranslation": false,
    "isStarred": false,
    "speakerSegments": []
  }
]
```

---

## 10. SERVICES OVERVIEW

### SpeechService
**Purpose:** Speech-to-text conversion
```dart
class SpeechService {
  Future<void> initialize()
  Future<void> startListening()
  Future<void> stopListening()
  Stream<String> get textStream
  Stream<SpeechRecognitionState> get stateStream
  Stream<double> get confidenceStream
  Future<bool> checkPermissions()
  Future<void> requestPermissions()
}
```

### LipTrackingService
**Purpose:** Detect and track lip movements
```dart
class LipTrackingService {
  Future<void> initialize()
  Future<void> startTracking()
  Future<void> stopTracking()
  Stream<LipTrackingData> get trackingStream
  Future<List<FaceDetection>> detectFaces(CameraImage image)
}
```

### YamNetService
**Purpose:** Audio sound classification
```dart
class YamNetService {
  Future<void> initialize()
  Future<SoundClassification> classifyAudio(List<int> audioBytes)
  Stream<SoundClassification> get classificationStream
}
```

---

## 11. DATABASE SCHEMA (SUPABASE)

### Users Table
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR UNIQUE NOT NULL,
  name VARCHAR NOT NULL,
  profile_image_url VARCHAR,
  created_at TIMESTAMP DEFAULT NOW(),
  is_premium BOOLEAN DEFAULT false,
  premium_expiry TIMESTAMP,
  preferences JSONB DEFAULT '{}',
  usage_stats JSONB DEFAULT '{}',
  deleted_at TIMESTAMP
);
```

### Transcripts Table
```sql
CREATE TABLE transcripts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR NOT NULL,
  content TEXT NOT NULL,
  date TIMESTAMP NOT NULL,
  duration INTEGER,
  language VARCHAR DEFAULT 'en',
  has_translation BOOLEAN DEFAULT false,
  is_starred BOOLEAN DEFAULT false,
  translated_content TEXT,
  translated_language VARCHAR,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  deleted_at TIMESTAMP
);
```

### Speaker Segments Table
```sql
CREATE TABLE speaker_segments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  transcript_id UUID REFERENCES transcripts(id) ON DELETE CASCADE,
  speaker_id INTEGER NOT NULL,
  speaker_name VARCHAR,
  text TEXT NOT NULL,
  start_time INTEGER,
  end_time INTEGER,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### Translations Table
```sql
CREATE TABLE translations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  transcript_id UUID REFERENCES transcripts(id) ON DELETE CASCADE,
  translated_text TEXT NOT NULL,
  target_language VARCHAR NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(transcript_id, target_language)
);
```

---

## 12. ENVIRONMENT CONFIGURATION

### Supabase Config
```dart
// In main.dart
const String SUPABASE_URL = 'https://bzsqhbyotxouppzwyift.supabase.co';
const String SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

### Google Sign-In Config
- Project ID: `echo-see-companion`
- Client ID: Located in `client_secret_*.json`

---

## 13. KEY FEATURES MATRIX

| Feature | Free | Premium |
|---------|------|---------|
| Speech-to-Text | ✓ | ✓ |
| Basic Transcription | ✓ | ✓ |
| Translation | 1 lang | All |
| Speaker Identification | Limited | ✓ |
| Lip Tracking | Limited | ✓ |
| Sound Recognition | Limited | ✓ |
| Export Transcripts | - | ✓ |
| Cloud Sync | ✓ | ✓ |
| Offline Mode | - | ✓ |

---

## 14. QUICK START FOR PROTOTYPE

1. **Clone the project**
   ```bash
   cd Echosee
   flutter pub get
   ```

2. **Set up Supabase**
   - Create account at supabase.com
   - Create new project
   - Copy URL and anon key to main.dart

3. **Install dependencies**
   ```bash
   flutter pub get
   flutter pub upgrade
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

5. **Test Account**
   - Email: demo@echosee.app
   - Password: DemoPassword123

---

## 15. COMMON ERROR SOLUTIONS

### Speech Service Issues
- Check microphone permissions
- Ensure audio files are in `assets/models/`
- Verify internet connection for cloud services

### Translation Issues
- API key must be valid
- Check language code format (e.g., 'es' for Spanish)
- Ensure premium status for multi-language

### Supabase Connection
- Verify URL and anon key in main.dart
- Check internet connectivity
- Review Supabase project settings

---

This comprehensive prototype data covers all aspects of the EchoSee app structure, providing everything needed to build, test, and deploy the application.
