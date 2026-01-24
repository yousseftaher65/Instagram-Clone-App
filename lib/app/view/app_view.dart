import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/auth/auth.dart';
import 'package:instagram_clone_app/l10n/l10n.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: const AppDarkTheme().theme,
      theme: const AppTheme().theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AuthPage(),
    );
  }
}
