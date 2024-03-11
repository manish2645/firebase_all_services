import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigService {
  FirebaseRemoteConfigService._() : _remoteConfig = FirebaseRemoteConfig.instance;

  static FirebaseRemoteConfigService? _instance;
  factory FirebaseRemoteConfigService() => _instance ??= FirebaseRemoteConfigService._();

  final FirebaseRemoteConfig _remoteConfig;

  String getString(String key) => _remoteConfig.getString(key);
  bool getBool(String key) =>_remoteConfig.getBool(key);
  int getInt(String key) =>_remoteConfig.getInt(key);
  double getDouble(String key) =>_remoteConfig.getDouble(key);

  Future<void> initialize() async {
    await _setConfigSettings();
    await _setDefaults();
    await fetchAndActivate();
  }

  Future<void> _setConfigSettings() async => _remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 5),
      minimumFetchInterval: const Duration(seconds: 1),
    ),
  );

  Future<void> _setDefaults() async => _remoteConfig.setDefaults(
    const {
      FirebaseRemoteConfigKeys.welcomeMessage: 'Hey there, this message is coming from local defaults.',
    },
  );

  Future<void> fetchAndActivate() async {
    bool updated = await _remoteConfig.fetchAndActivate();

    if (updated) {
      print('The config has been updated.');
    } else {
      print('The config is not updated..');
    }
  }

}

class FirebaseRemoteConfigKeys {
  static const String welcomeMessage = 'welcome_message';
}

final message = FirebaseRemoteConfigService().getString(FirebaseRemoteConfigKeys.welcomeMessage);
