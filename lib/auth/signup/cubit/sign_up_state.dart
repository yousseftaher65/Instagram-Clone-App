part of 'sign_up_cubit.dart';

/// Message that will be shown to user, when he will try to submit signup form,
/// but there is an error occurred. It is used to show user, what exactly went
/// wrong.
typedef SingUpErrorMessage = String;

/// Defines possible signup submission statuses. It is used to manipulate with
/// state, using Bloc, according to state. Therefore, when [success] we
/// can simply navigate user to main page and such.
enum SignUpSubmissionStatus {
  /// [SignUpSubmissionStatus.idle] indicates that user has not yet submitted
  /// signup form.
  idle,

  /// [SignUpSubmissionStatus.inProgress] indicates that user has submitted
  /// signup form and is currently waiting for response from backend.
  inProgress,

  /// [SignUpSubmissionStatus.success] indicates that user has successfully
  /// submitted signup form and is currently waiting for response from backend.
  success,

  /// [SignUpSubmissionStatus.emailAlreadyRegistered] indicates that email,
  /// provided by user, is occupied by another one in database.
  emailAlreadyRegistered,

  /// [SignUpSubmissionStatus.inProgress] indicates that user had no internet
  /// connection during network request.
  networkError,

  /// [SignUpSubmissionStatus.error] indicates something went wrong when user
  /// tried to sign up.
  error;

  bool get isSuccess => this == SignUpSubmissionStatus.success;
  bool get isLoading => this == SignUpSubmissionStatus.inProgress;
  bool get isEmailRegistered =>
      this == SignUpSubmissionStatus.emailAlreadyRegistered;
  bool get isNetworkError => this == SignUpSubmissionStatus.networkError;
  bool get isError =>
      this == SignUpSubmissionStatus.error ||
      isNetworkError ||
      isEmailRegistered;
}

/// {@template signup_state}
/// Defines signup state. It is used to store all the data, that is needed
/// for signup form to work properly. It also stores signup submission status,
/// that is used to manipulate with state, using Bloc, according to state.
/// {@endtemplate}

class SignUpState extends Equatable {
  const SignUpState.initial()
    : this._(
        email: const Email.pure(),
        password: const Password.pure(),
        fullname: const FullName.pure(),
        username: const Username.pure(),
        showPassword: false,
        submissionStatus: SignUpSubmissionStatus.idle,
      );
  const SignUpState._({
    required this.email,
    required this.password,
    required this.fullname,
    required this.username,
    required this.showPassword,
    required this.submissionStatus,
  });
  final Email email;
  final Password password;
  final FullName fullname;
  final Username username;
  final bool showPassword;
  final SignUpSubmissionStatus submissionStatus;

  @override
  List<Object> get props => [
    email,
    password,
    fullname,
    username,
    showPassword,
    submissionStatus,
  ];

  SignUpState copyWith({
    Email? email,
    Password? password,
    FullName? fullname,
    Username? username,
    bool? showPassword,
    SignUpSubmissionStatus? submissionStatus,
  }) {
    return SignUpState._(
      email: email ?? this.email,
      password: password ?? this.password,
      fullname: fullname ?? this.fullname,
      username: username ?? this.username,
      showPassword: showPassword ?? this.showPassword,
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }
}

final signupSubmissionStatusMessage =
    <SignUpSubmissionStatus, SubmissionStatusMessage>{
      SignUpSubmissionStatus.emailAlreadyRegistered:
          const SubmissionStatusMessage(
            title: 'User with this email already exists.',
            description: 'Try another email address.',
          ),
      SignUpSubmissionStatus.error:
          const SubmissionStatusMessage.genericError(),
      SignUpSubmissionStatus.networkError:
          const SubmissionStatusMessage.networkError(),
    };
