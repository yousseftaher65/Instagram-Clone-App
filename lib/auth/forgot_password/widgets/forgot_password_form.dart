import 'package:flutter/material.dart';
import 'package:instagram_clone_app/auth/forgot_password/widgets/widgets.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ForgotPasswordEmailFormField(),
      ],
    );
  }
}
