import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

abstract interface class AuthRemoteDataSource {
  // Future<UserCredential> signUpWithEmailPassword({
  //   required String name,
  //   required String email,
  //   required String password,
  // }) async {
  //   final serviceId = "";
  //   final templateId = "";
  //   final userId = "";

  //   final url = Uri.parse("");
  //   final response = await http.post(url, body: {
  //     "service_id": serviceId,
  //     "template_id": templateId,
  //     "user_id": userId
  //   });
  // }

  // Future sendEmail(
  //     {required String name,
  //     required String email,
  //     required String subject,
  //     required String message});

  Future<UserCredential> logInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<void> sendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //       content: Text("Verification email sent! Check your inbox.")),
      // );
    }
  }
}

class AuthRemoteDataSourcesImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserCredential> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'userName': name,
        'createdAt': Timestamp.now(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message,
      );
    }
  }

  @override
  Future<UserCredential> logInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message,
      );
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  @override
  Future sendEmail(
      {required String name,
      required String email,
      required String subject,
      required String message}) {
    // TODO: implement sendEmail
    throw UnimplementedError();
  }
}
