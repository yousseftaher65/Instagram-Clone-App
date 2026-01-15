import 'package:env/env.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_clone_app/app/app.dart';
import 'package:shared/shared.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GoogleSignInButton(),
              SizedBox(height: 16),
              LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  Future<void> signInWithGoogle() async {
    final webClientId = getIt<AppFlavor>().getEnv(Env.webClientId);
    final iOSClientId = getIt<AppFlavor>().getEnv(Env.iOSClientId);

    final instance = GoogleSignIn.instance;
    await instance.initialize(
      clientId: iOSClientId,
      serverClientId: webClientId,
    );

    final googleUser = await instance.authenticate();

    final googleAuth = googleUser.authentication;

    final idToken = googleAuth.idToken;

    if (idToken == null) {
      throw Exception('Id token is null');
    }

    await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        try {
          await signInWithGoogle();
        } catch (error, stackTrace) {
          logE(
            'Failed to sign in with Google',
            error: error,
            stackTrace: stackTrace,
          );
        }
      },
      label: Text(
        'Google Sign In',
        style: Theme.of(
          context,
        ).textTheme.headlineSmall,
      ),
      icon: const Icon(Icons.auto_awesome),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapShot) {
        if (snapShot.hasData) {
          final session = snapShot.data?.session;
          if (session == null) return const SizedBox.shrink();
          return ElevatedButton.icon(
            onPressed: () async {
              try {
                await signOut();
              } catch (error, stackTrace) {
                logE(
                  'Failed to sign out',
                  error: error,
                  stackTrace: stackTrace,
                );
              }
            },
            label: Text(
              'Sign out',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.red),
            ),
            icon: const Icon(Icons.logout),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
