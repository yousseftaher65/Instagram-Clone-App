import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram_clone_app/app/app.dart';
import 'package:powersync_repository/powersync_repository.dart';
import 'package:shared/shared.dart';

typedef AppBuilder =
    FutureOr<Widget> Function(
      PowerSyncRepository powerSyncRepository,
    );

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    logD('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

//
Future<void> bootstrap(
  AppBuilder builder, {
  required AppFlavor appFlavor,
  required FirebaseOptions options,
}) async {
  FlutterError.onError = (details) {
    logE(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      setupDi(appFlavor: appFlavor);

      await Firebase.initializeApp(options: options);

      final powerSyncRepository = PowerSyncRepository(env: appFlavor.getEnv);
      await powerSyncRepository.initialize();

      SystemUiOverlayTheme.setPortraitOrientation();

      if (appFlavor.flavor == Flavor.development) {
        HttpOverrides.global = DevelopmentHttpOverrides();
      }

      runApp(await builder(powerSyncRepository));
    },
    (error, stackTrace) {
      logE(error.toString(), stackTrace: stackTrace);
    },
  );
}

class DevelopmentHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
