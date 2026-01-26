import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/auth/signup/cubit/sign_up_cubit.dart';
import 'package:instagram_clone_app/l10n/l10n.dart';
import 'package:shared/shared.dart';

class PasswordFormField extends StatefulWidget {
  const PasswordFormField({super.key});

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode()..addListener(_focusNodeListener);
    _debouncer = Debouncer();
  }

  void _focusNodeListener() {
    if (!_focusNode.hasFocus) {
      context.read<SignUpCubit>().onPasswordUnfocused();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode
      ..removeListener(_focusNodeListener)
      ..dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final passwordError = context.select(
      (SignUpCubit cubit) => cubit.state.password.errorMessage,
    );

    final showPassword = context.select(
      (SignUpCubit cubit) => cubit.state.showPassword,
    );

    return AppTextField(
      filled: true,
      errorText: passwordError,
      textController: _controller,
      focusNode: _focusNode,
      hintText: context.l10n.passwordText,
      textInputType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      onChanged: (value) {
        _debouncer.run(() {
          context.read<SignUpCubit>().onPasswordChanged(value);
        });
      },
      obscureText: !showPassword,
      suffixIcon: Tappable(
        onTap: context.read<SignUpCubit>().changePasswordVisibility,
        child: Icon(
          !showPassword ? Icons.visibility : Icons.visibility_off,
          color: context.customAdaptiveColor(light: AppColors.grey),
        ),
      ),
    );
  }
}
