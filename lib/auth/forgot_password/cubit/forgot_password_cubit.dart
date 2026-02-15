import 'dart:io';
import 'dart:ui';

import 'package:authentication_client/authentication_client.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_fields/form_fields.dart';
import 'package:shared/shared.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_repository/user_repository.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(const ForgotPasswordState.initial());

  final UserRepository _userRepository;

  void onEmailChanged(String value) {
    final newEmailState = Email.dirty(value);
    final newScreenState = state.copyWith(email: newEmailState);
    emit(newScreenState);
  }

  void onEmailUnfocused() {
    final previousScreenState = state;
    final previousEmailState = previousScreenState.email;
    final previousEmailValue = previousEmailState.value;

    final newEmailState = Email.dirty(previousEmailValue);
    final newScreenState = previousScreenState.copyWith(email: newEmailState);
    emit(newScreenState);
  }

  Future<void> onSubmit({
    VoidCallback? onSuccess,
  }) async {
    final email = Email.dirty(state.email.value);
    final isFormValid = FormzValid([email]).isFormValid;

    final newState = state.copyWith(
      email: email,
      status: isFormValid ? ForgotPasswordStatus.loading : null,
    );

    emit(newState);

    if (!isFormValid) return;

    try {
      await _userRepository.sendPasswordResetEmail(email: state.email.value);
      final newState = state.copyWith(status: ForgotPasswordStatus.success);
      if (isClosed) return;
      emit(newState);
      onSuccess?.call();
    } catch (error, stackTrace) {
      _errorFormatter(error, stackTrace);
    }
  }

  void _errorFormatter(Object error, StackTrace stackTrace) {
    addError(error, stackTrace);
    final status = switch (error) {
      SendPasswordResetEmailFailure(:final AuthException error) =>
        switch (error.statusCode?.parse) {
          HttpStatus.tooManyRequests => ForgotPasswordStatus.tooManyRequests,
          _ => ForgotPasswordStatus.failure,
        },
      _ => ForgotPasswordStatus.failure,
    };

    emit(state.copyWith(status: status));
  }
}
