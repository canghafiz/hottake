import 'package:hottake/features/data/data.dart';
import 'package:hottake/features/domain/domain.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  ThemeRepositoryImpl({required this.localDataSource});

  // Function
  @override
  ThemeEntity? getTheme(int id) {
    return localDataSource.getTheme(id);
  }
}
