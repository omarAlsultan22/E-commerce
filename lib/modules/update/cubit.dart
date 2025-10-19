import 'package:international_cuisine/shared/cubit/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/constant.dart';
import '../../modles/user_model.dart';


class AppModelCubit extends Cubit<CubitStates> {
  AppModelCubit() : super((InitialState()));

  static AppModelCubit get(context) => BlocProvider.of(context);

  Future<void> getInfo(String uId) async {
    emit(LoadingState());
    DocumentReference docRef = FirebaseFirestore.instance.collection(
        'user').doc(uId).collection('userModel').doc(uId);
    try {
      DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        UserModel userModel = UserModel.fromJson(data);
        print('Document data: $data');
        emit(SuccessState<UserModel>(value: userModel, stateKey: StatesKeys.getInfo));
      } else {
        print('Document does not exist');
      }
    } catch (error) {
      print('Error fetching document: $error');
      emit(ErrorState(error: error.toString()));
    }
  }

  Future updateInfo({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    emit(LoadingState());
    try {
      UserModel userModel = UserModel(
        firstName: firstName,
        lastName: firstName,
        phone: phone,
      );
      await FirebaseFirestore.instance.collection('users').doc(UserDetails.uId).update(
          userModel.toJson());
      emit(SuccessState(stateKey: StatesKeys.updateInfo));
    }
    catch (error) {
      emit(ErrorState(error: error.toString(), stateKey: StatesKeys.updateInfo));
    }
  }

  Future<void> changeEmailAndPassword({
    required String newEmail,
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(LoadingState());
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      try {
        await user.reauthenticateWithCredential(credential);
        await user.updateEmail(newEmail).then((_) {
          user.updatePassword(newPassword).then((_) {
            emit(SuccessState());
          });
        });
      } on FirebaseAuthException catch (e) {
        emit(ErrorState(error: e.toString()));
      }
    } else {
      emit(ErrorState(error: 'No user is currently logged in'));
    }
  }
}
