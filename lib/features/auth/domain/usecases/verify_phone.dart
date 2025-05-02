import 'package:flutter_clean_architecture_practise/features/auth/domain/repositories/phone_auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class VerifyPhoneUseCase {
  final PhoneAuthRepository repository;
  VerifyPhoneUseCase(this.repository);

  Future<Either<String, String>> sendOtp(String phoneNumber) {
    return repository.sendOtp(phoneNumber);
  }

  Future<Either<String, void>> verifyOtp(String verificationId, String otp) {
    return repository.verifyOtp(verificationId, otp);
  }
}
