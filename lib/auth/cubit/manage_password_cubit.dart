import 'package:flutter_bloc/flutter_bloc.dart';

class ManagePasswordCubit extends Cubit<bool> {
  ManagePasswordCubit() : super(true);

  /// Defines method to change screen from forgot to reset password or reversed.
  void changeScreen({required bool showForgotPassword}) =>
      emit(showForgotPassword);
}
