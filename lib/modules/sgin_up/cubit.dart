import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:international_cuisine/shared/components/constant.dart';
import 'package:international_cuisine/shared/cubit/state.dart';
import '../../modles/user_model.dart';


class RegisterCubit extends Cubit<CubitStates> {
  RegisterCubit() : super(InitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  Future userRegister({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,

  }) async {
    emit(LoadingState());

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      UserDetails.uId = value.user!.uid;
      storeDate(
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          uId: UserDetails.uId
      );
    }).catchError((error) {
      emit(ErrorState(error.toString()));
    });
  }

  Future storeDate({
    required String firstName,
    required String lastName,
    required String phone,
    required String uId
  }) async {
    UserModel userModel = UserModel(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
    );
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("user").doc(uId).collection('userModel').doc(uId).set(userModel.toMap()).then((value) {
      emit(SuccessState());
    })
        .catchError((error) {
      emit(ErrorState(error.toString()));
    });
  }
}

