import 'package:hottake/core/core.dart';
import 'package:hottake/features/data/data.dart';

abstract class ThemeLocalDataSource {
  ThemeModel getTheme(int id);
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  @override
  ThemeModel getTheme(int id) {
    return themes[id];
  }
}
