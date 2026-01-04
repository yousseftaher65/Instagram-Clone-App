import 'package:instagram_clone_app/app/app.dart';
import 'package:instagram_clone_app/bootstrap.dart';
import 'package:instagram_clone_app/firebase_options_prod.dart';
import 'package:shared/shared.dart';

Future<void> main() async {
  await bootstrap(
    (powerSyncRepository) => const App(),
    appFlavor: AppFlavor.production(),
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
