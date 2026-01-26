import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram_clone_app/auth/signup/widgets/widgets.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email
        EmailFormField(),

        SizedBox(height: AppSpacing.md,),

        FullNameFormField(),

        SizedBox(height: AppSpacing.md,),

        UsernameFormField(),

        SizedBox(height: AppSpacing.md,),

        PasswordFormField(),
      ],
    );
  }
}
