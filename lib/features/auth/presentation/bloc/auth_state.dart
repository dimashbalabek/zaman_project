abstract class EmailAuthState {
  const EmailAuthState();

  @override
  List<Object?> get props => [];
}

class EmailAuthInitial extends EmailAuthState {}

class EmailAuthLoading extends EmailAuthState {}

class EmailAuthAuthenticated extends EmailAuthState {}

class EmailAuthFailure extends EmailAuthState {
  final String error;

  const EmailAuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}
