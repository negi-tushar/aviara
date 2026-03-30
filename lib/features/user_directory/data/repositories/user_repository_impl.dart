import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_data_source.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<User>> getUsers() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUsers = await remoteDataSource.getUsers();
        await localDataSource.cacheUsers(remoteUsers);
        return remoteUsers;
      } catch (e) {
        try {
          return await localDataSource.getLastUsers();
        } on CacheFailure {
          throw const ServerFailure(
            'Failed to fetch from server and no local cache available',
          );
        }
      }
    } else {
      try {
        return await localDataSource.getLastUsers();
      } on CacheFailure {
        throw const NetworkFailure(
          'No internet connection and no cached data found.',
        );
      }
    }
  }
}
