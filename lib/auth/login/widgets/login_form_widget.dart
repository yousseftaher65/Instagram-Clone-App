import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/app/app.dart';
import 'package:instagram_clone_app/auth/auth.dart';
import 'package:instagram_clone_app/auth/login/cubit/login_state.dart';
import 'package:instagram_clone_app/l10n/l10n.dart';

class LoginFormWidget extends StatelessWidget {
  const LoginFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isError) {
          openSnackbar(
            SnackbarMessage.error(
              title:
                  loginSubmissionStatusMessage[state.status]?.title ??
                  state.errorMessage ??
                  context.l10n.somethingWentWrongText,
              description:
                  loginSubmissionStatusMessage[state.status]?.description,
            ),
            clearIfQueue: true,
          );
        }
      },
      listenWhen: (previous, current) => previous.status != current.status,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EamilFromField(),
          SizedBox(
            height: AppSpacing.lg,
          ),
          PasswordFormField(),
        ],
      ),
    );
  }
}
