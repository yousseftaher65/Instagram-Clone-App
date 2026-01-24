import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/auth/login/widgets/widgets.dart';

class LoginFormWidget extends StatelessWidget {
  const LoginFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EamilFromField(),
        SizedBox(
          height: AppSpacing.lg,
        ),
        PasswordFormField(),
      ],
    );
  }
}
