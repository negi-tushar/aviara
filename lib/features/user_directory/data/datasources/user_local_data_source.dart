import 'package:hive/hive.dart';
import '../models/user_model.dart';
import '../../../../core/error/failures.dart';

abstract class UserLocalDataSource {
  Future<List<UserModel>> getLastUsers();
  Future<void> cacheUsers(List<UserModel> usersToCache);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Box<UserModel> userBox;

  UserLocalDataSourceImpl(this.userBox);

  @override
  Future<void> cacheUsers(List<UserModel> usersToCache) async {
    await userBox.clear();
    await userBox.addAll(usersToCache);
  }

  @override
  Future<List<UserModel>> getLastUsers() async {
    if (userBox.isNotEmpty) {
      return userBox.values.toList();
    } else {
      throw const CacheFailure();
    }
  }
}
