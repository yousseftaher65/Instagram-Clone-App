import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/auth/signup/cubit/sign_up_cubit.dart';
import 'package:instagram_clone_app/l10n/l10n.dart';
import 'package:shared/shared.dart';

class UsernameFormField extends StatefulWidget {
  const UsernameFormField({super.key});

  @override
  State<UsernameFormField> createState() => _UsernameFormFieldState();
}

class _UsernameFormFieldState extends State<UsernameFormField> {
  late FocusNode _focusNode;
  late Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_focusNodeListener);
    _debouncer = Debouncer();
  }

  void _focusNodeListener() {
    if (!_focusNode.hasFocus) {
      context.read<SignUpCubit>().onUsernameUnfocused();
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_focusNodeListener)
      ..dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (SignUpCubit cubit) =>
          cubit.state.submissionStatus == SignUpSubmissionStatus.inProgress,
    );
    final usernameError = context.select(
      (SignUpCubit cubit) => cubit.state.username.errorMessage,
    );
    return AppTextField(
      filled: true,
      errorText: usernameError,
      focusNode: _focusNode,
      hintText: context.l10n.usernameText,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.name],
      errorMaxLines: 3,
      enabled: !isLoading,
      onChanged: (value) {
        _debouncer.run(() {
          context.read<SignUpCubit>().onUsernameChanged(value);
        });
      },
    );
  }
}
