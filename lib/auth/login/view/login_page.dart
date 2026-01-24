import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/auth/login/cubit/login_cubit.dart';
import 'package:instagram_clone_app/auth/login/widgets/widgets.dart';
import 'package:instagram_clone_app/l10n/l10n.dart';
import 'package:user_repository/user_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        userRepository: context.read<UserRepository>(),
      ),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      releaseFocus: true,
      resizeToAvoidBottomInset: true,
      body: AppConstrainedScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Gap.v(AppSpacing.xxxlg + AppSpacing.xxxlg),
              const AppLogo(
                height: AppSpacing.xxxlg,
                fit: BoxFit.fitHeight,
                width: double.infinity,
              ),
              const SizedBox(
                height: AppSpacing.md,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Login form
                    const LoginFormWidget(),
                    // Forgot password button
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: ForgotPasswordButton(),
                    ),
                    // Sign in button
                    const SizedBox(
                      height: AppSpacing.md,
                    ),
                    const Align(
                      child: SignInButton(),
                    ),
                    // Divider
                    Row(
                      children: [
                        const Expanded(
                          child: AppDivider(
                            endIndent: AppSpacing.sm,
                            indent: AppSpacing.md,
                            color: AppColors.white,
                            height: 36,
                          ),
                        ),
                        Text(
                          context.l10n.orText,
                          style: context.titleSmall?.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        const Expanded(
                          child: AppDivider(
                            color: AppColors.white,
                            indent: AppSpacing.sm,
                            endIndent: AppSpacing.md,
                            height: 36,
                          ),
                        ),
                      ],
                    ),
                    Align(
                      child: AuthProviderSignInButton(
                        provider: AuthProvider.google,
                        onPressed: context.read<LoginCubit>().loginWithGoogle,
                      ),
                    ),
                    Align(
                      child: AuthProviderSignInButton(
                        provider: AuthProvider.github,
                        onPressed: context.read<LoginCubit>().loginWithGithub,
                      ),
                    ),
                  ],
                ),
              ),
              const SignUpNewAccountButton(),
            ],
          ),
        ),
      ),
    );
  }
}
