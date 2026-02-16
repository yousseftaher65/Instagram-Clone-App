import 'package:instagram_clone_app/app/routes/routes.dart';

enum AppRoutes {
  auth(PageRouteName.auth),
  home(PageRouteName.home),
  feed(PageRouteName.feed),
  userProfile(PageRouteName.userProfile),
  reels(PageRouteName.reels),
  createMedia(PageRouteName.createMedia),
  search(PageRouteName.search),
  timeline(PageRouteName.timeline);

  //
  // ignore: unused_element_parameter
  const AppRoutes(this.route, {this.path});
  final String route;
  final String? path;

  String get name => route.replaceAll('/', '');
}
