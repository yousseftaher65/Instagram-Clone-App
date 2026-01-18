import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/l10n/l10n.dart';
import 'package:instagram_clone_app/login/login.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      darkTheme: const AppDarkTheme().theme,
      theme: const AppTheme().theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const LoginPage(),
    );
  }
}
