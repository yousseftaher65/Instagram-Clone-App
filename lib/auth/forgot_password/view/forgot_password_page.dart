import 'package:animations/animations.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/auth/cubit/manage_password_cubit.dart';
import 'package:instagram_clone_app/auth/forgot_password/change_password/change_password.dart';
import 'package:instagram_clone_app/auth/forgot_password/change_password/cubit/change_password_cubit.dart';
import 'package:instagram_clone_app/auth/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:instagram_clone_app/auth/forgot_password/widgets/widgets.dart';
import 'package:instagram_clone_app/l10n/l10n.dart';
import 'package:user_repository/user_repository.dart';

class ManageForgotPasswordPage extends StatelessWidget {
  const ManageForgotPasswordPage({super.key});

  static Route<void> route() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return const ManageForgotPasswordPage();
      },
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ManagePasswordCubit(),
        ),
        BlocProvider(
          create: (context) => ForgotPasswordCubit(
            userRepository: context.read<UserRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => ChangePasswordCubit(
            userRepository: context.read<UserRepository>(),
          ),
        ),
      ],
      child: const ForgotPasswordPage(),
    );
  }
}

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final showForgotPassword = context.select(
      (ManagePasswordCubit b) => b.state,
    );

    return PageTransitionSwitcher(
      reverse: showForgotPassword,
      transitionBuilder: (child, animation, secondaryAnimation) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
      child: showForgotPassword
          ? const ForgotPasswordView()
          : const ChangePasswordView(),
    );
  }
}

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      releaseFocus: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(context.l10n.recoveryPasswordText),
        centerTitle: false,
      ),
      body: const AppConstrainedScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ForgotPasswordEmailConfirmationLable(),
            ),
            Gap.v(AppSpacing.md),
            ForgotPasswordForm(),
            Gap.v(AppSpacing.md),
            ForgotPasswordSendEmailButton(),
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordEmailConfirmationLable extends StatelessWidget {
  const ForgotPasswordEmailConfirmationLable({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.forgotPasswordEmailConfirmationText,
      style: context.headlineSmall,
    );
  }
}
