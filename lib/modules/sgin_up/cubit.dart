import 'package:international_cuisine/shared/constants/user_details.dart';
import 'package:international_cuisine/shared/cubit/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RegisterCubit extends Cubit<CubitStates> {
  RegisterCubit() : super(InitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> userRegister({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String location,
  }) async {
    emit(LoadingState());

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = userCredential.user;
      if (user != null) {
        UserDetails.uId = user.uid;

        await _storeUserData(
          uId: user.uid,
          email: email,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          location: location,
        );

        await _savePassword(password: password);

        emit(SuccessState());
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'حدث خطأ أثناء التسجيل';

      if (e.code == 'weak-password') {
        errorMessage = 'كلمة المرور ضعيفة جدًا';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'البريد الإلكتروني مستخدم بالفعل';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'البريد الإلكتروني غير صالح';
      }

      emit(ErrorState(error: errorMessage));
    } catch (e) {
      emit(ErrorState(error: 'حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  Future<void> _storeUserData({
    required String uId,
    required String email,
    required String firstName,
    required String lastName,
    required String phone,
    required String location,
  }) async {
    try {
      await _firestore.collection('users').doc(uId).set({
        'email': email.trim(),
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
        'name': '${firstName.trim()} ${lastName.trim()}',
        'phone': phone.trim(),
        'location': location.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('فشل في حفظ بيانات المستخدم: ${e.toString()}');
    }
  }

  Future<void> _savePassword({required String password}) async {
    try {
      await _storage.write(
        key: 'user_password',
        value: password.trim(),
      );
    } catch (e) {
      print('فشل في حفظ كلمة المرور محلياً: ${e.toString()}');
    }
  }
}