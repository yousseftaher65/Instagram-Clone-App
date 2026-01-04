import 'package:envied/envied.dart';

part 'env.prod.g.dart';

@Envied(path: '.env.prod', obfuscate: true)
/// Production environment configuration.
abstract class EnvProd {
  ///Supabase url secret.
  @EnviedField(varName: 'SUPABASE_URL', obfuscate: true)
  static final String supabaseUrl = _EnvProd.supabaseUrl;

  ///Supabase anon secret key.
  @EnviedField(varName: 'SUPABASE_ANON_KEY', obfuscate: true)
  static final String supabaseAnonKey = _EnvProd.supabaseAnonKey;

  ///Powersync url secret.
  @EnviedField(varName: 'POWER_SYNC_URL', obfuscate: true)
  static final String powerSyncUrl = _EnvProd.powerSyncUrl;
}
