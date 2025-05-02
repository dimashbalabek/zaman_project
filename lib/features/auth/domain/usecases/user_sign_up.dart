import 'package:flutter_clean_architecture_practise/core/error/failures.dart';
import 'package:flutter_clean_architecture_practise/core/usecase/usecase.dart';
import 'package:flutter_clean_architecture_practise/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class UserSignUp implements Usecase<String, UserSignUpParams> {
  final AuthRepository authRepository;
  const UserSignUp(this.authRepository);
  @override
  Future<Either<Failure, String>> call(UserSignUpParams Params) async {
    // TODO: implement call
    return await authRepository.signUpWithEmailPassword(
        name: Params.name, email: Params.email, password: Params.password);
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String name;
  UserSignUpParams(
      {required this.email, required this.name, required this.password});
}
