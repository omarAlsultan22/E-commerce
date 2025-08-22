import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:international_cuisine/shared/local/shared_preferences.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../shared/components/components.dart';
import '../../shared/cubit/state.dart';

class LoginCubit extends Cubit<CubitStates> {
  LoginCubit() : super(InitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  Future login({
    required String email,
    required String password,
    required BuildContext context
  }) async
  {
    emit(LoadingState());
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password).then((value) async {
          emit(LoadingState());
      try {
        // Attempt to sign in with email and password
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: email,
            password: password);
        CacheHelper.setString(key: 'uId', value: userCredential.user!.uid);
        QuickAlert.show(
          context: context,
          text: 'تم التسجيل بنجاح',
          type: QuickAlertType.success,
          showConfirmBtn: false,
          autoCloseDuration: Duration(seconds: 3),
        );
        emit(SuccessState<String>(value: userCredential.user!.uid));
        startTimer(context);
      } catch (error) {
        emit(ErrorState(error: error.toString()));
        QuickAlert.show(
          context: context,
          text: 'فشل تسجيل الدخول: ${error.toString()}',
          type: QuickAlertType.error,
          showConfirmBtn: true,
        );
      }
    });
  }
}








