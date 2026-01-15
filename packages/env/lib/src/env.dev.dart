import 'package:envied/envied.dart';

part 'env.dev.g.dart';

@Envied(path: '.env.dev', obfuscate: true)
/// Development environment configuration.
abstract class EnvDev {
  ///Supabase url secret.
  @EnviedField(varName: 'SUPABASE_URL', obfuscate: true)
  static final String supabaseUrl = _EnvDev.supabaseUrl;

  ///Supabase anon secret key.
  @EnviedField(varName: 'SUPABASE_ANON_KEY', obfuscate: true)
  static final String supabaseAnonKey = _EnvDev.supabaseAnonKey;

  ///Powersync url secret.
  @EnviedField(varName: 'POWER_SYNC_URL', obfuscate: true)
  static final String powerSyncUrl = _EnvDev.powerSyncUrl;

  ///Google ios client id.
  @EnviedField(varName: 'IOS_CLIENT_ID', obfuscate: true)
  static final String iOSClientId = _EnvDev.iOSClientId;

  ///Google web client id.
  @EnviedField(varName: 'WEB_CLIENT_ID', obfuscate: true)
  static final String webClientId = _EnvDev.webClientId;
}
