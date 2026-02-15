import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/app/app.dart';
import 'package:instagram_clone_app/auth/signup/cubit/sign_up_cubit.dart';
import 'package:instagram_clone_app/auth/signup/widgets/widgets.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.submissionStatus.isError) {
          openSnackbar(
            SnackbarMessage.error(
              title:
                  signupSubmissionStatusMessage[state.submissionStatus]!.title,
              description: signupSubmissionStatusMessage[state.submissionStatus]
                  ?.description,
            ),
            clearIfQueue: true,
          );
        }
      },
      listenWhen: (previous, current) =>
          previous.submissionStatus != current.submissionStatus,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmailFormField(),
          SizedBox(
            height: AppSpacing.md,
          ),
          FullNameFormField(),
          SizedBox(
            height: AppSpacing.md,
          ),
          UsernameFormField(),
          SizedBox(
            height: AppSpacing.md,
          ),
          PasswordFormField(),
        ],
      ),
    );
  }
}
