import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/app/app.dart';
import 'package:instagram_clone_app/app/routes/routes.dart';
import 'package:instagram_clone_app/l10n/l10n.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final routerConfig = AppRouter.router(context.read<AppBloc>());
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: const AppDarkTheme().theme,
      theme: const AppTheme().theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            AppSnackbar(
              key: snackbarKey,
            ),
          ],
        );
      },
      routerConfig: routerConfig,
    );
  }
}
