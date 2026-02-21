import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_blocks_ui/instagram_blocks_ui.dart';
import 'package:instagram_clone_app/app/routes/routes.dart';
import 'package:instagram_clone_app/l10n/l10n.dart';
import 'package:instagram_clone_app/user_profile/user_profile.dart';
import 'package:shared/shared.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({required this.userId, super.key});
  final String userId;

  void _pushToUserStatisticsInfo(
    BuildContext context, {
    required int tabIndex,
  }) => context.pushNamed(
    PageRouteName.userStatistics,
    queryParameters: {'user_id': userId, 'tab_index': tabIndex.toString()},
  );

  @override
  Widget build(BuildContext context) {
    final isOwner = context.select((UserProfileBloc b) => b.isOwner);
    final user = context.select(
      (UserProfileBloc bloc) => bloc.state.user,
    );
    return SliverPadding(
      padding: const EdgeInsetsGeometry.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  foregroundImage: NetworkImage(user.avatarUrl ?? ''),
                  radius: 32,
                ),
                gapW12,
                Expanded(
                  child: UserProfileStatisticsCounts(
                    onStatisticTap: (value) =>
                        _pushToUserStatisticsInfo(context, tabIndex: value),
                  ),
                ),
              ],
            ),
            gapH16,
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Text(
                user.displayFullName,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: context.titleMedium?.copyWith(
                  fontWeight: AppFontWeight.semiBold,
                ),
              ),
            ),
            gapH16,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.sm,
              children: [
                if (isOwner) ...[
                  const Flexible(flex: 3, child: EditProfileButton()),
                  const Flexible(flex: 3, child: ShareProfileButton()),
                  const Flexible(child: ShowSuggestedPeopleButton()),
                ] else ...[
                  const Expanded(flex: 3, child: UserProfileFollowUserButton()),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfileStatisticsCounts extends StatelessWidget {
  const UserProfileStatisticsCounts({
    required this.onStatisticTap,
    super.key,
  });

  final ValueSetter<int> onStatisticTap;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final state = context.select(
      (UserProfileBloc bloc) => bloc.state,
    );

    final postsCount = state.postsCount;
    final followersCount = state.followersCount;
    final followingsCount = state.followingsCount;

    return Row(
      children: [
        Expanded(
          child: UserProfileStatistic(
            name: l10n.postsCount(postsCount),
            value: postsCount,
          ),
        ),
        Expanded(
          child: UserProfileStatistic(
            name: l10n.followersCount(followersCount),
            value: followersCount,
          ),
        ),
        Expanded(
          child: UserProfileStatistic(
            name: l10n.followingsCount(followingsCount),
            value: followingsCount,
          ),
        ),
      ],
    );
  }
}

class EditProfileButton extends StatelessWidget {
  const EditProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return UserProfileButton(
      label: context.l10n.editProfileText,
      onTap: () => context.pushNamed(AppRoutes.editProfile.name),
    );
  }
}

class ShareProfileButton extends StatelessWidget {
  const ShareProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return UserProfileButton(
      label: context.l10n.shareProfileText,
      onTap: () {},
    );
  }
}

class ShowSuggestedPeopleButton extends StatefulWidget {
  const ShowSuggestedPeopleButton({super.key});

  @override
  State<ShowSuggestedPeopleButton> createState() =>
      _ShowSuggestedPeopleButtonState();
}

class _ShowSuggestedPeopleButtonState extends State<ShowSuggestedPeopleButton> {
  var _showPeople = false;

  @override
  Widget build(BuildContext context) {
    return UserProfileButton(
      onTap: () => setState(() => _showPeople = !_showPeople),
      child: Icon(
        _showPeople ? Icons.person_add_rounded : Icons.person_add_outlined,
        size: 20,
      ),
    );
  }
}

class UserProfileFollowUserButton extends StatelessWidget {
  const UserProfileFollowUserButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UserProfileBloc>();
    final user = context.select((UserProfileBloc bloc) => bloc.state.user);

    final l10n = context.l10n;

    return BetterStreamBuilder<bool>(
      stream: bloc.followingStatus(),
      builder: (context, isFollowed) {
        return UserProfileButton(
          label: isFollowed ? '${l10n.followingUser} ▼' : l10n.followUser,
          color: isFollowed
              ? null
              : context.customReversedAdaptiveColor(
                  light: AppColors.lightBlue,
                  dark: AppColors.blue,
                ),
          onTap: isFollowed
              ? () async {
                  void callback(ModalOption option) =>
                      option.onTap.call(context);

                  final option = await context.showListOptionsModal(
                    title: user.username,
                    options: followerModalOptions(
                      unfollowLabel: context.l10n.cancelFollowingText,
                      onUnfollowTap: () =>
                          bloc.add(const UserProfileFollowUserRequested()),
                    ),
                  );
                  if (option == null) return;
                  callback.call(option);
                }
              : () => bloc.add(const UserProfileFollowUserRequested()),
        );
      },
    );
  }
}
