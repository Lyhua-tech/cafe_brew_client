import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/favorites_viewmodel.dart'; // Added this import
import 'views/splash_view.dart';
import 'utils/colors.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Removed HomeViewModel, kept AuthViewModel, added FavoritesViewModel
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => FavoritesViewModel()),
      ],
      child:
          const MyApp(), // Kept MyApp as per original structure, assuming the CafeBrewApp was a typo in the instruction's example
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cafe Brew Client',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      home: const SplashView(),
    );
  }
}
