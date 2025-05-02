import 'package:fpdart/fpdart.dart';

abstract class PhoneAuthRepository {
  Future<Either<String, String>> sendOtp(String phoneNumber);
  Future<Either<String, void>> verifyOtp(String verificationId, String otp);
}
