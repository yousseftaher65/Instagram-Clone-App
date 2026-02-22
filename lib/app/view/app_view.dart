import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/app/app.dart';
import 'package:instagram_clone_app/app/routes/routes.dart';
import 'package:instagram_clone_app/l10n/l10n.dart';
import 'package:instagram_clone_app/selector/selector.dart';
import 'package:shared/shared.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final routerConfig = AppRouter.router(context.read<AppBloc>());
    return BlocBuilder<LocaleBloc, Locale>(
      builder: (context, locale) {
        return BlocBuilder<ThemeModeBloc, ThemeMode>(
          builder: (context, themeMode) {
            return AnimatedSwitcher(
              duration: 350.ms,
              child: MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.noScaling),
                child: MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  themeMode: themeMode,
                  darkTheme: const AppDarkTheme().theme,
                  theme: const AppTheme().theme,
                  locale: locale,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        child!,
                        AppSnackbar(
                          key: snackbarKey,
                        ),
                        AppLoadingIndeterminate(
                          key: loadingKey,
                        ),
                      ],
                    );
                  },
                  routerConfig: routerConfig,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
