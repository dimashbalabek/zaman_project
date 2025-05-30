import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_clean_architecture_practise/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_clean_architecture_practise/features/auth/presentation/bloc/auth_state.dart';

class EmailAuthBloc extends Bloc<EmailAuthEvent, EmailAuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  EmailAuthBloc() : super(EmailAuthInitial()) {
    on<EmailSignUpSubmitted>(_onSignUpSubmitted);
    on<EmailSignInSubmitted>(_onSignInSubmitted);
  }

  Future<void> _onSignUpSubmitted(
    EmailSignUpSubmitted event,
    Emitter<EmailAuthState> emit,
  ) async {
    emit(EmailAuthLoading());
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      final user = userCredential.user;
      if (user != null) {
        await _createUserInFirestore(user.uid, event.name, event.email);
      }

      emit(EmailAuthAuthenticated());
    } on FirebaseAuthException catch (e) {
      emit(EmailAuthFailure(e.message ?? 'Неизвестная ошибка при регистрации'));
    } catch (e) {
      emit(EmailAuthFailure(e.toString()));
    }
  }

  Future<void> _onSignInSubmitted(
    EmailSignInSubmitted event,
    Emitter<EmailAuthState> emit,
  ) async {
    emit(EmailAuthLoading());
    try {
      await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(EmailAuthAuthenticated());
    } on FirebaseAuthException catch (e) {
      emit(EmailAuthFailure(e.message ?? 'Неизвестная ошибка при входе'));
    } catch (e) {
      emit(EmailAuthFailure(e.toString()));
    }
  }
}

Future<void> _createUserInFirestore(
    String userId, String name, String email) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'id': userId,
      'name': name,
      'email': email,
      'status': 'user',
      'createdAt': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print('Ошибка при создании пользователя в Firestore: $e');
    rethrow;
  }
}
