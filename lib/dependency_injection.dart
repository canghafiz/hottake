import 'package:get_it/get_it.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/data/data.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

final dI = GetIt.instance;

void init() {
  // Cubits
  dI.registerFactory(() => ThemeCubit());
  dI.registerFactory(() => BackendCubit());
  dI.registerFactory(() => NavbarCubit());
  dI.registerFactory(() => PostCubit());
  dI.registerFactory(() => CommentCubit());
  dI.registerFactory(() => CreateAccountCubit());
  dI.registerFactory(() => ImageCubit());

  // Cubits Event
  dI.registerLazySingleton(() => ThemeCubitEvent());
  dI.registerLazySingleton(() => BackendCubitEvent());
  dI.registerLazySingleton(() => NavbarCubitEvent());
  dI.registerLazySingleton(() => PostCubitEvent());
  dI.registerLazySingleton(() => CommentCubitEvent());
  dI.registerLazySingleton(() => CreateAccountCubitEvent());
  dI.registerLazySingleton(() => ImageCubitEvent());

  // Usecases
  dI.registerLazySingleton(() => GetTheme(dI()));
  dI.registerLazySingleton(() => UserUpdateData(dI()));
  dI.registerLazySingleton(() => UserUpdatePhoto(dI()));
  dI.registerLazySingleton(() => UserUpdateTheme(dI()));
  dI.registerLazySingleton(() => CreatePost(dI()));
  dI.registerLazySingleton(() => UpdatePost(dI()));
  dI.registerLazySingleton(() => UpdateVotePost(dI()));
  dI.registerLazySingleton(() => UpdateFavoritePost(dI()));
  dI.registerLazySingleton(() => UpdateLikePost(dI()));
  dI.registerLazySingleton(() => UpdateUnLikePost(dI()));
  dI.registerLazySingleton(() => UpdateReadPost(dI()));
  dI.registerLazySingleton(() => DeletePost(dI()));
  dI.registerLazySingleton(() => AddComment(dI()));
  dI.registerLazySingleton(() => AddSubComment(dI()));
  dI.registerLazySingleton(() => UpdateFavoriteComment(dI()));
  dI.registerLazySingleton(() => UpdateFavoriteSubComment(dI()));
  dI.registerLazySingleton(() => CreateNotification(dI()));
  dI.registerLazySingleton(() => UpdateReadNotification(dI()));
  dI.registerLazySingleton(() => DeleteNotification(dI()));
  dI.registerLazySingleton(() => DeleteAllNotification(dI()));

  // Repositories
  dI.registerLazySingleton<ThemeRepository>(
    () => ThemeRepositoryImpl(
      localDataSource: dI(),
    ),
  );

  dI.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: dI(),
    ),
  );

  dI.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      remoteDataSource: dI(),
    ),
  );

  dI.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(
      remoteDataSource: dI(),
    ),
  );

  dI.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      remoteDataSource: dI(),
    ),
  );

  // Data Source
  dI.registerLazySingleton<ThemeLocalDataSource>(
    () => ThemeLocalDataSourceImpl(),
  );

  dI.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceFirebase(),
  );

  dI.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceFirebase(),
  );

  dI.registerLazySingleton<CommentRemoteDataSource>(
    () => CommentRemoteDataSourceFirebase(),
  );

  dI.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceFirebase(),
  );

  // Core
  dI.registerLazySingleton(() => FirebaseAuthImpl());
  dI.registerLazySingleton(() => AuthImpl());
  dI.registerLazySingleton(() => UserFirestore());
  dI.registerLazySingleton(() => PostFirestore());
  dI.registerLazySingleton(() => CommentFirestore());
  dI.registerLazySingleton(() => ImagePickerService());
}
