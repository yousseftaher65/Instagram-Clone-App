import 'package:env/env.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_clone_app/app/app.dart';
import 'package:instagram_clone_app/bootstrap.dart';
import 'package:instagram_clone_app/firebase_options_dev.dart';
import 'package:shared/shared.dart';
import 'package:supabase_authentication_client/supabase_authentication_client.dart';
import 'package:token_storage/token_storage.dart';
import 'package:user_repository/user_repository.dart';

Future<void> main() async {
  await bootstrap(
    (powerSyncRepository) async {
      final iOSClientId = getIt<AppFlavor>().getEnv(Env.iOSClientId);
      final webClientId = getIt<AppFlavor>().getEnv(Env.webClientId);

      final tokenStorage = InMemoryTokenStorage();
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        clientId: iOSClientId,
        serverClientId: webClientId,
      );
      final supabaseAuthenticationClient = SupabaseAuthenticationClient(
        tokenStorage: tokenStorage,
        powerSyncRepository: powerSyncRepository,
        googleSignIn: googleSignIn,
      );

      final userRepository = UserRepository(
        authenticationClient: supabaseAuthenticationClient,
      );
      return App(userRepository: userRepository);
    },
    appFlavor: AppFlavor.development(),
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
