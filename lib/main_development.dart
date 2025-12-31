import 'package:instagram_clone_app/app/app.dart';
import 'package:instagram_clone_app/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
