import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc({
    required UserRepository userRepository,
    required PostsRepository postsRepository,
    String? userId,
  }) : _userRepository = userRepository,
       _userId = userId ?? userRepository.currentUserId ?? '',
       _postsRepository = postsRepository,
       super(const UserProfileState.initial()) {
    on<UserProfileSubscriptionRequested>(_onUserProfileSubscriptionRequested);
    on<UserProfilePostsCountSubscriptionRequested>(
      _onUserProfilePostsCountSubscriptionRequested,
    );
    on<UserProfileFollowingsCountSubscriptionRequested>(
      _onUserProfileFollowingsCountSubscriptionRequested,
    );
    on<UserProfileFollowersCountSubscriptionRequested>(
      _onUserProfileFollowersCountSubscriptionRequested,
    );
    on<UserProfileFollowUserRequested>(
      _onUserProfileFollowUserRequested,
    );
  }

  final PostsRepository _postsRepository;
  final UserRepository _userRepository;
  final String _userId;

  bool get isOwner => _userId == _userRepository.currentUserId;

  Future<void> _onUserProfileSubscriptionRequested(
    UserProfileSubscriptionRequested event,
    Emitter<UserProfileState> emit,
  ) async {
    await emit.forEach(
      isOwner ? _userRepository.user : _userRepository.profile(userId: _userId),
      onData: (user) => state.copyWith(user: user),
    );
  }

  Future<void> _onUserProfilePostsCountSubscriptionRequested(
    UserProfilePostsCountSubscriptionRequested event,
    Emitter<UserProfileState> emit,
  ) async {
    await emit.forEach(
      _postsRepository.postsAmountOf(userId: _userId),
      onData: (postsCount) => state.copyWith(postsCount: postsCount),
    );
  }

  Future<void> _onUserProfileFollowingsCountSubscriptionRequested(
    UserProfileFollowingsCountSubscriptionRequested event,
    Emitter<UserProfileState> emit,
  ) async {
    await emit.forEach(
      _userRepository.followingsCountOf(userId: _userId),
      onData: (followingsCount) =>
          state.copyWith(followingsCount: followingsCount),
    );
  }

  Future<void> _onUserProfileFollowersCountSubscriptionRequested(
    UserProfileFollowersCountSubscriptionRequested event,
    Emitter<UserProfileState> emit,
  ) async {
    await emit.forEach(
      _userRepository.followersCountOf(userId: _userId),
      onData: (followersCount) =>
          state.copyWith(followersCount: followersCount),
    );
  }

  Future<void> _onUserProfileFollowUserRequested(
    UserProfileFollowUserRequested event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      await _userRepository.follow(followToId: event.userId ?? _userId);
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Stream<bool> followingStatus({String? followerId}) =>
      _userRepository.followingStatus(userId: _userId).asBroadcastStream();

  Future<void> follow({required String followToId, String? followerId}) {
    return _userRepository.follow(
      followToId: followToId,
      followerId: followerId,
    );
  }

  Future<bool> isFollowed({
    required String followerId,
    required String userId,
  }) async {
    return _userRepository.isFollowed(followerId: followerId, userId: userId);
  }
}
