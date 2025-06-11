import 'package:lombard/src/core/database/shared_preferences/typed_preferences_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IAuthDao {
  PreferencesEntry<String> get user;

  PreferencesEntry<String> get iin;

  PreferencesEntry<String> get userId;

  PreferencesEntry<String> get token;

  PreferencesEntry<String> get deviceToken;
}

class AuthDao extends TypedPreferencesDao implements IAuthDao {
  AuthDao({
    required SharedPreferencesWithCache sharedPreferences,
  }) : super(sharedPreferences, name: 'auth');

  @override
  PreferencesEntry<String> get user => stringEntry('user');

  @override
  PreferencesEntry<String> get userId => stringEntry('userId');

  @override
  PreferencesEntry<String> get token => stringEntry('token');

  @override
  PreferencesEntry<String> get iin => stringEntry('iin');

  @override
  PreferencesEntry<String> get deviceToken => stringEntry('deviceToken');
}
