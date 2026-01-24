import 'dart:io';

import 'package:authentication_client/authentication_client.dart';
import 'package:bloc/bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:instagram_clone_app/auth/login/cubit/login_state.dart';
import 'package:shared/shared.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;
import 'package:user_repository/user_repository.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(const LoginState.initial());

  final UserRepository _userRepository;

  void changePasswordVisibility() =>
      emit(state.copyWith(showPassword: !state.showPassword));

  /// Emits initial state of login screen.
  void resetState() => emit(const LoginState.initial());

  /// Email value was changed, triggering new changes in state.
  void onEmailChanged(String newValue) {
    final newEmailState = Email.dirty(newValue);
    final newScreenState = state.copyWith(email: newEmailState);
    emit(newScreenState);
  }

  /// Email field was unfocused, here is checking if previous state with email
  /// was valid, in order to indicate it in state after unfocus.
  void onEmailUnfocused() {
    final previousScreenState = state;
    final previousEmailState = previousScreenState.email;
    final previousEmailValue = previousEmailState.value;

    final newEmailState = Email.dirty(previousEmailValue);
    final newScreenState = previousScreenState.copyWith(email: newEmailState);
    emit(newScreenState);
  }

  /// Password value was changed, triggering new changes in state.
  /// Checking whether or not value is valid in [Password] and emmiting new
  /// [Password] validation state.
  void onPasswordChanged(String newValue) {
    final newPasswordState = Password.dirty(newValue);
    final newScreenState = state.copyWith(password: newPasswordState);
    emit(newScreenState);
  }

  void onPasswordUnfocused() {
    final previousScreenState = state;
    final previousPasswordState = previousScreenState.password;
    final previousPasswordValue = previousPasswordState.value;

    final newPasswordState = Password.dirty(previousPasswordValue);
    final newScreenState = previousScreenState.copyWith(
      password: newPasswordState,
    );
    emit(newScreenState);
  }

  /// Makes whole login state initial, as [Email] and [Password] becomes invalid
  /// and [LogInSubmissionStatus] becomes idle. Solely used if during login
  /// user switched on sign up, therefore login state does not persists and
  /// becomes initial again.
  void idle() {
    const initialState = LoginState.initial();
    emit(initialState);
  }

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(status: LogInSubmissionStatus.googleAuthInProgress));
    try {
      await _userRepository.logInWithGoogle();
      emit(state.copyWith(status: LogInSubmissionStatus.success));
    } on LogInWithGoogleCanceled {
      emit(state.copyWith(status: LogInSubmissionStatus.idle));
    } catch (error, stackTrace) {
      _errorFormatter(error, stackTrace);
    }
  }

  Future<void> loginWithGithub() async {
    emit(state.copyWith(status: LogInSubmissionStatus.githubAuthInProgress));
    try {
      await _userRepository.logInWithGithub();
      emit(state.copyWith(status: LogInSubmissionStatus.success));
    } on LogInWithGithubCanceled {
      emit(state.copyWith(status: LogInSubmissionStatus.idle));
    } catch (error, stackTrace) {
      _errorFormatter(error, stackTrace);
    }
  }

  Future<void> onSubmit() async {
    final email = Email.pure(state.email.value);
    final password = Password.pure(state.password.value);
    final isFormValid = FormzValid([email, password]).isFormValid;

    final newState = state.copyWith(
      email: email,
      password: password,
      status: isFormValid ? LogInSubmissionStatus.loading : null,
    );

    emit(newState);

    if (!isFormValid) return;

    try {
      await _userRepository.logInWithPassword(
        email: email.value,
        password: password.value,
      );
    } catch (e, stackTrace) {
      _errorFormatter(e, stackTrace);
    }
  }

  /// Formats error, that occurred during login process.
  void _errorFormatter(Object e, StackTrace stackTrace) {
    addError(e, stackTrace);
    final status = switch (e) {
      LogInWithPasswordFailure(:final AuthException error) =>
        switch (error.statusCode?.parse) {
          HttpStatus.badRequest => LogInSubmissionStatus.invalidCredentials,
          _ => LogInSubmissionStatus.error,
        },
      LogInWithGoogleFailure() => LogInSubmissionStatus.googleLogInFailure,
      _ => LogInSubmissionStatus.idle,
    };

    final newState = state.copyWith(status: status, errorMessage: e.toString());
    emit(newState);
  }
}
