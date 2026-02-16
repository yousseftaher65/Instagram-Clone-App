import 'dart:async';

import 'package:animations/animations.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone_app/app/app.dart';
import 'package:instagram_clone_app/app/home/view/home.dart';
import 'package:instagram_clone_app/app/routes/routes.dart';
import 'package:instagram_clone_app/auth/auth.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  static GoRouter router(AppBloc appBloc) => _router(appBloc);

  static GoRouter _router(AppBloc appBloc) => GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: PageRouteName.feed,
    routes: [
      GoRoute(
        path: PageRouteName.auth,
        builder: (context, state) => const AuthPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomePage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: PageRouteName.feed,
                pageBuilder: (context, state) => getSharedAxisTranistionPage(
                  state: state,
                  child: AppScaffold(
                    body: Center(
                      child: Text(
                        'Feed',
                        style: context.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: PageRouteName.timeline,
                pageBuilder: (context, state) => getFadeTransitionPage(
                  state: state,
                  child: AppScaffold(
                    body: Center(
                      child: Text(
                        'Timeline',
                        style: context.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: PageRouteName.createMedia,
                redirect: (context, state) => null,
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: PageRouteName.reels,
                pageBuilder: (context, state) => getFadeTransitionPage(
                  state: state,
                  child: AppScaffold(
                    body: Center(
                      child: Text(
                        'Reels',
                        style: context.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: PageRouteName.userProfile,
                pageBuilder: (context, state) => getSharedAxisTranistionPage(
                  state: state,
                  child: AppScaffold(
                    body: Center(
                      child: Text(
                        'User Profile',
                        style: context.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final authenticated = appBloc.state.status == AppStatus.authenticated;
      final authenticating = state.matchedLocation == AppRoutes.auth.route;
      final isInFeed = state.matchedLocation == AppRoutes.feed.route;

      if (isInFeed && !authenticated) return AppRoutes.auth.route;
      if (!authenticated) return AppRoutes.auth.route;
      if (authenticating && authenticated) return AppRoutes.feed.route;

      return null;
    },
    refreshListenable: GoRouterAppBlocRefreshStream(appBloc.stream),
  );

  static CustomTransitionPage<dynamic> getFadeTransitionPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
    );
  }

  static CustomTransitionPage<dynamic> getSlideTransitionPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  static CustomTransitionPage<dynamic> getScaleTransitionPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
          child: child,
        );
      },
    );
  }

  static CustomTransitionPage<dynamic> getRotationTransitionPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return RotationTransition(
          turns: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
          child: child,
        );
      },
    );
  }

  static CustomTransitionPage<dynamic> getRotationScaleTransitionPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return RotationTransition(
          turns: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
          child: ScaleTransition(
            scale: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  static CustomTransitionPage<dynamic> getSharedAxisTranistionPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          transitionType: SharedAxisTransitionType.horizontal,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }
}

/// {@template go_router_refresh_stream}
/// A [ChangeNotifier] that notifies listeners when a [Stream] emits a value.
/// This is used to rebuild the UI when the [AppBloc] emits a new state.
/// {@endtemplate}
class GoRouterAppBlocRefreshStream extends ChangeNotifier {
  /// {@macro go_router_refresh_stream}
  GoRouterAppBlocRefreshStream(Stream<AppState> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((appState) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  Future<void> dispose() async {
    await _subscription.cancel();
    super.dispose();
  }
}
