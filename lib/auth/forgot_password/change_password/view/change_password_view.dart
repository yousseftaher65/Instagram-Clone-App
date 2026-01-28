import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/auth/cubit/manage_password_cubit.dart';
import 'package:instagram_clone_app/auth/forgot_password/change_password/widgets/widgets.dart';
import 'package:instagram_clone_app/l10n/l10n.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  Future<void> _confirmGoBack(BuildContext context) {
    return context.confirmAction(
      fn: () => context.read<ManagePasswordCubit>().changeScreen(
        showForgotPassword: true,
      ),
      title: context.l10n.goBackConfirmationText,
      content: context.l10n.loseAllEditsText,
      noText: context.l10n.cancelText,
      yesText: context.l10n.goBackText,
      yesTextStyle: context.labelLarge?.apply(color: AppColors.blue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await _confirmGoBack(context);
        }
      },
      releaseFocus: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.adaptive.arrow_back),
          onPressed: () => _confirmGoBack(context),
        ),
        title: Text(context.l10n.changePasswordText),
        centerTitle: false,
      ),
      body: const AppConstrainedScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChangePasswordForm(),
            gapH16,
            ChangePasswordButton(),
          ],
        ),
      ),
    );
  }
}
