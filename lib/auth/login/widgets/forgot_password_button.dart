import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_app/auth/forgot_password/forgot_passowrd.dart';
import 'package:instagram_clone_app/l10n/l10n.dart';
import 'package:shared/shared.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tappable(
      throttle: true,
      throttleDuration: 650.ms,
      onTap: () async {
        await Navigator.pushAndRemoveUntil(
          context,
          ManageForgotPasswordPage.route(),
          (_) => true,
        );
      },
      child: Text(
        context.l10n.forgotPasswordText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.titleSmall?.copyWith(
          color: AppColors.blue,
        ),
      ),
    );
  }
}
