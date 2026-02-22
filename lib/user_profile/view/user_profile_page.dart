import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone_app/app/app.dart';
import 'package:instagram_clone_app/l10n/l10n.dart';
import 'package:instagram_clone_app/selector/selector.dart';
import 'package:instagram_clone_app/user_profile/user_profile.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:shared/shared.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:user_repository/user_repository.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({required this.userId, super.key});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserProfileBloc(
              userRepository: context.read<UserRepository>(),
              postsRepository: context.read<PostsRepository>(),
              userId: userId,
            )
            ..add(const UserProfileSubscriptionRequested())
            ..add(const UserProfileFollowingsCountSubscriptionRequested())
            ..add(const UserProfileFollowersCountSubscriptionRequested()),
      child: UserProfileView(userId: userId),
    );
  }
}

class UserProfileView extends StatefulWidget {
  const UserProfileView({required this.userId, super.key});
  final String userId;

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  late ScrollController _nestedScrollViewController;

  @override
  void initState() {
    super.initState();
    _nestedScrollViewController = ScrollController();
  }

  @override
  void dispose() {
    _nestedScrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select(
      (UserProfileBloc bloc) => bloc.state.user,
    );
    return AppScaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          controller: _nestedScrollViewController,
          headerSliverBuilder: (context, innerBoxIsScrollded) {
            return [
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context,
                ),
                sliver: MultiSliver(
                  children: [
                    const UserProfileAppBar(),
                    if (!user.isAnonymous) ...[
                      UserProfileHeader(
                        userId: widget.userId,
                      ),
                      SliverPersistentHeader(
                        pinned: !ModalRoute.of(context)!.isFirst,
                        delegate: const _UserProfileTabBarDelegate(
                          tabBar: TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelPadding: EdgeInsets.zero,
                            indicatorWeight: 1,
                            tabs: [
                              Tab(
                                icon: Icon(
                                  Icons.grid_on,
                                ),
                                iconMargin: EdgeInsets.zero,
                              ),
                              Tab(
                                icon: Icon(Icons.person_outline),
                                iconMargin: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ];
          },
          body: const TabBarView(
            children: [
              UserPostsPage(),
              UserProfileMentionedPostsPage(),
            ],
          ),
        ),
      ),
    );
  }
}

class UserProfileAppBar extends StatelessWidget {
  const UserProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isOwner = context.select(
      (UserProfileBloc bloc) => bloc.isOwner,
    );
    final user = context.select(
      (UserProfileBloc bloc) => bloc.state.user,
    );

    return SliverPadding(
      padding: const EdgeInsets.only(right: AppSpacing.md),
      sliver: SliverAppBar(
        centerTitle: false,
        pinned: !ModalRoute.of(context)!.isFirst,
        floating: ModalRoute.of(context)!.isFirst,
        title: Row(
          children: [
            Flexible(
              flex: 12,
              child: Text(
                user.displayFullName,
                style: context.titleLarge?.copyWith(
                  fontWeight: AppFontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            gapW8,
            Flexible(
              child: Assets.icons.verifiedUser.svg(
                width: AppSize.iconSizeSmall,
                height: AppSize.iconSizeSmall,
              ),
            ),
          ],
        ),
        actions: [
          if (!isOwner)
            const UserProfileActions()
          else ...[
            const UserProfileAddMediaButton(),
            if (ModalRoute.of(context)?.isFirst ?? false) ...const [
              gapW12,
              UserProfileSettingsButton(),
            ],
          ],
        ],
      ),
    );
  }
}

class UserProfileActions extends StatelessWidget {
  const UserProfileActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Tappable.faded(
      onTap: () {},
      child: Icon(Icons.adaptive.more_outlined, size: AppSize.iconSize),
    );
  }
}

class UserProfileSettingsButton extends StatelessWidget {
  const UserProfileSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tappable.faded(
      onTap: () => context
          .showListOptionsModal(
            options: [
              ModalOption(child: const LocaleModalOption()),
              ModalOption(child: const ThemeSelectorModalOption()),
              ModalOption(child: const LogoutModalOption()),
            ],
          )
          .then((option) {
            if (option == null) return;
            void onTap() => option.onTap(context);
            onTap.call();
          }),
      child: Assets.icons.setting.svg(
        height: AppSize.iconSize,
        width: AppSize.iconSize,
        colorFilter: ColorFilter.mode(context.adaptiveColor, BlendMode.srcIn),
      ),
    );
  }
}

class LogoutModalOption extends StatelessWidget {
  const LogoutModalOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Tappable.faded(
      onTap: () => context.confirmAction(
        fn: () {
          context.pop();
          context.read<AppBloc>().add(const AppLogoutRequested());
        },
        title: context.l10n.logOutText,
        content: context.l10n.logOutConfirmationText,
        noText: context.l10n.cancelText,
        yesText: context.l10n.logOutText,
      ),
      child: ListTile(
        title: Text(
          context.l10n.logOutText,
          style: context.bodyLarge?.apply(color: AppColors.red),
        ),
        leading: const Icon(Icons.logout, color: AppColors.red),
      ),
    );
  }
}

class UserProfileAddMediaButton extends StatelessWidget {
  const UserProfileAddMediaButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Tappable.faded(
      onTap: () => context
          .showListOptionsModal(
            title: l10n.createText,
            options: createMediaModalOptions(
              context: context,
              reelLabel: l10n.reelText,
              postLabel: l10n.postText,
              storyLabel: l10n.storyText,
              enableStory: true,
              onStoryCreated: (path) {
                /// TODO: implement story creation
              },
              goTo: (route, {extra}) => context.pushNamed(route, extra: extra),
            ),
          )
          .then((option) {
            if (option == null) return;
            void onTap() => option.onTap(context);
            onTap.call();
          }),
      child: Icon(
        Icons.add_box_outlined,
        color: context.adaptiveColor,
        size: AppSize.iconSize,
      ),
    );
  }
}

class _UserProfileTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _UserProfileTabBarDelegate({required this.tabBar});

  final TabBar tabBar;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: context.theme.scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class UserPostsPage extends StatelessWidget {
  const UserPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class UserProfileMentionedPostsPage extends StatelessWidget {
  const UserProfileMentionedPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
