import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'services/notification_service.dart';
import 'providers/user_provider.dart';
import 'providers/squad_provider.dart';
import 'providers/friend_provider.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => SquadProvider()..fetchSquads()),
          ChangeNotifierProvider(create: (_) => FriendProvider()),
        ],
        child: const ProdexApp(),
      ),
    );

    // Initialize Push Notifications in the background after app starts
    NotificationService().initialize().catchError((e) {
      print('Notification Service failed to initialize: $e');
    });
  } catch (e, stacktrace) {
    print('Failed to initialize: $e');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Text(
                'Failed to start app:\n$e\n\n$stacktrace',
                style: const TextStyle(color: Colors.red),
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProdexApp extends StatelessWidget {
  const ProdexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PRODEX',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
