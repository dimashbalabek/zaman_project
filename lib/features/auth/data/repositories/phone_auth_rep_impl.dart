import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_clean_architecture_practise/features/auth/domain/repositories/phone_auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class PhoneAuthRepImpl implements PhoneAuthRepository {
  final FirebaseAuth auth;
  PhoneAuthRepImpl(this.auth);

  @override
  Future<Either<String, String>> sendOtp(String phoneNumber) async {
    try {
      final completer = Completer<Either<String, String>>();
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          await auth.signInWithCredential(credential);
          completer.complete(Right('Authenticated'));
        },
        verificationFailed: (e) =>
            completer.complete(Left(e.message ?? 'Error')),
        codeSent: (verificationId, resendToken) =>
            completer.complete(Right(verificationId)),
        codeAutoRetrievalTimeout: (verificationId) {},
      );
      return completer.future;
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> verifyOtp(
      String verificationId, String otp) async {
    try {
      final credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      await auth.signInWithCredential(credential);
      return Right(null);
    } catch (e) {
      return Left('Invalid OTP');
    }
  }
}
