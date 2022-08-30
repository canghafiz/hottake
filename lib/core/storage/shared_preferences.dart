import 'package:hottake/core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  // Set
  Future<void> setLocationPermission(bool value) async {
    final SharedPreferences prefs = await _prefs;

    prefs.setBool(locationPermissionKey, value);
  }

  // Get
  Future<bool> getLocationPermission() async {
    return await _prefs.then(
      (shared) {
        return shared.getBool(locationPermissionKey) ?? false;
      },
    );
  }
}
