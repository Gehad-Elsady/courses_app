import 'package:courses_app/backend/bloc/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitState());

  Future<void> Login(
    String emailAddress,
    String password, {
    required Function onSuccess,
    required Function onError,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message);
    }
  }
}
