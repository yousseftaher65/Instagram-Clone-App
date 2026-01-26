import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/auth/signup/cubit/sign_up_cubit.dart';
import 'package:instagram_clone_app/l10n/l10n.dart';
import 'package:shared/shared.dart';

class FullNameFormField extends StatefulWidget {
  const FullNameFormField({super.key});

  @override
  State<FullNameFormField> createState() => _FullNameFormFieldState();
}

class _FullNameFormFieldState extends State<FullNameFormField> {
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
      context.read<SignUpCubit>().onFullNameUnfocused();
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
    final fullNameError = context.select(
      (SignUpCubit cubit) => cubit.state.fullname.errorMessage,
    );
    return AppTextField(
      filled: true,
      errorText: fullNameError,
      focusNode: _focusNode,
      hintText: context.l10n.nameText,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.givenName],
      textCapitalization: TextCapitalization.words,
      enabled: !isLoading,
      onChanged: (value) {
        _debouncer.run(() {
          context.read<SignUpCubit>().onFullNameChanged(value);
        });
      },
    );
  }
}
