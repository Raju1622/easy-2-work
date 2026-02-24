import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'core/app_theme.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/bookings_provider.dart';
import 'core/providers/cart_provider.dart';
import 'core/providers/nav_provider.dart';
import 'core/providers/user_address_provider.dart';
import 'core/providers/worker_jobs_provider.dart';
import 'user/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  AppTheme.setSystemUI();
  runApp(const Easy2WorkApp());
}

class Easy2WorkApp extends StatelessWidget {
  const Easy2WorkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => BookingsProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserAddressProvider()),
        ChangeNotifierProvider(create: (_) => WorkerJobsProvider()),
      ],
      child: MaterialApp(
        title: 'Easy 2 Work',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          scaffoldBackgroundColor: AppTheme.bgLight,
          colorScheme: ColorScheme.light(
            primary: AppTheme.primary,
            secondary: AppTheme.accent,
            surface: AppTheme.bgCard,
            onPrimary: Colors.white,
            onSurface: AppTheme.textPrimary,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
