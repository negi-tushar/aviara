import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../../../core/error/failures.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl(this.dio);

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await dio.get(
        'https://jsonplaceholder.typicode.com/users',
      );
      if (response.statusCode == 200) {
        final List jsonList = response.data;
        return jsonList.map((e) => UserModel.fromJson(e)).toList();
      } else {
        throw const ServerFailure();
      }
    } on DioException {
      throw const ServerFailure();
    } catch (e) {
      throw const ServerFailure();
    }
  }
}
