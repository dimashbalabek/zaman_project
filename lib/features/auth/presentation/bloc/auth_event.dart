abstract class EmailAuthEvent {
  const EmailAuthEvent();

  @override
  List<Object?> get props => [];
}

class EmailSignUpSubmitted extends EmailAuthEvent {
  final String email;
  final String password;
  final String name;

  const EmailSignUpSubmitted(
      {required this.email, required this.password, required this.name});

  @override
  List<Object?> get props => [email, password];
}

class EmailSignInSubmitted extends EmailAuthEvent {
  final String email;
  final String password;

  const EmailSignInSubmitted({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
