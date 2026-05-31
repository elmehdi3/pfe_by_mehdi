import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'services/notification_service.dart';

import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/squad_provider.dart';
import 'providers/friend_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize Push Notifications
  await NotificationService().initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => SquadProvider()..fetchSquads()),
        ChangeNotifierProvider(create: (_) => FriendProvider()),
      ],
      child: const StitchApp(),
    ),
  );
}

class StitchApp extends StatelessWidget {
  const StitchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pfe by mehdi',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
