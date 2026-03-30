import '../../../../core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUsersUseCase implements UseCase<List<User>, NoParams> {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  @override
  Future<List<User>> call(NoParams params) async {
    return await repository.getUsers();
  }
}
