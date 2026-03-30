import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'core/network/network_info.dart';
import 'core/network/connectivity_cubit.dart';
import 'features/user_directory/data/datasources/user_local_data_source.dart';
import 'features/user_directory/data/datasources/user_remote_data_source.dart';
import 'features/user_directory/data/models/user_model.dart';
import 'features/user_directory/data/repositories/user_repository_impl.dart';
import 'features/user_directory/domain/repositories/user_repository.dart';
import 'features/user_directory/domain/usecases/get_users_usecase.dart';
import 'features/user_directory/presentation/bloc/user_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - User Directory
  // Bloc
  sl.registerFactory(() => UserBloc(getUsersUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetUsersUseCase(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerFactory(() => ConnectivityCubit(networkInfo: sl()));

  //! External
  final dio = Dio(
    BaseOptions(
      headers: {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Accept': 'application/json, text/plain, */*',
        'Accept-Language': 'en-US,en;q=0.9',
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  sl.registerLazySingleton(() => dio);

  final connectivity = Connectivity();
  sl.registerLazySingleton(() => connectivity);

  // Hive
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(UserModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(AddressModelAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(CompanyModelAdapter());
  }
  
  final userBox = await Hive.openBox<UserModel>('userBox');
  sl.registerLazySingleton(() => userBox);
}
