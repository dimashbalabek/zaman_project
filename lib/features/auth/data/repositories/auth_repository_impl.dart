import 'package:flutter_clean_architecture_practise/core/error/exception.dart';
import 'package:flutter_clean_architecture_practise/core/error/failures.dart';
import 'package:flutter_clean_architecture_practise/features/auth/data/auth_remote_data_sources.dart';
import 'package:flutter_clean_architecture_practise/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // final userId = await remoteDataSource.signUpWithEmailPassword(
      //   name: name,
      //   email: email,
      //   password: password,
      // );
      return Right("");
    } on ServerException catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, String>> logInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userId = await remoteDataSource.logInWithEmailPassword(
        email: email,
        password: password,
      );
      return Right(userId.user!.uid);
    } on ServerException catch (e) {
      return Left(Failure());
    }
  }
}
