// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// // ✅ Supabase import
// import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/app_theme_provider.dart';
import 'core/utils/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppThemeProvider(),
      child: Consumer<AppThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Echo See',
            debugShowCheckedModeBanner: false,

            // 🔥 VERY IMPORTANT
            navigatorKey: NavigationService.navigatorKey,
            initialRoute: '/', // Splash se start
            onGenerateRoute: NavigationService.onGenerateRoute,

            theme: themeProvider.themeData,
          );
        },
      ),
    );
  }
}
