import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:international_cuisine/modules/sgin_in/sgin_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../shared/components/components.dart';
import 'package:flutter/material.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  bool _isObscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _storeUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'email': _emailController.text.trim(),
        'name': _lastNameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'location': _locationController.text.trim(),
      });
    }
  }

  Future<void> _savePassword() async {
    await _storage.write(
        key: 'user_password',
        value: _passwordController.text
    );
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _storeUserData();
      await _savePassword();

      if (!mounted) return;

      await QuickAlert.show(
        context: context,
        text: 'تم إنشاء الحساب بنجاح',
        type: QuickAlertType.success,
        onConfirmBtnTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignIn())
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String errorMessage = 'حدث خطأ أثناء التسجيل';
      if (e.code == 'weak-password') {
        errorMessage = 'كلمة المرور ضعيفة جدًا';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'البريد الإلكتروني مستخدم بالفعل';
      }

      await QuickAlert.show(
        context: context,
        text: errorMessage,
        type: QuickAlertType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildFirstNameField(),
                  const SizedBox(height: 16),
                  _buildLastNameField(),
                  const SizedBox(height: 16),
                  _buildEmailField(),
                  const SizedBox(height: 16),
                  _buildPasswordField(),
                  const SizedBox(height: 16),
                  _buildPhoneField(),
                  const SizedBox(height: 24),
                  _buildRegisterButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'انشاء حساب',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'سجل الان كي تنضم إلى عالم السعادة',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildLastNameField() {
    return buildInputField(
      controller: _firstNameController,
      keyboardType: TextInputType.name,
      label: "الاسم الأول",
      hint: "أدخل اسمك الأول",
      icon: Icons.person,
      validator: (value) => validator(value!, 'firstName'),
    );
  }

  Widget _buildFirstNameField() {
    return buildInputField(
      controller: _lastNameController,
      keyboardType: TextInputType.name,
      label: "الاسم الثاني",
      hint: "أدخل اسمك الثاني",
      icon: Icons.person,
      validator: (value) => validator(value!, 'lastName'),
    );
  }

  Widget _buildEmailField() {
    return buildInputField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      label: "البريد الإلكتروني",
      hint: "أدخل بريدك الإلكتروني",
      icon: Icons.email,
      validator: (value) => validator(value!, 'email'),
    );
  }

  Widget _buildPasswordField() {
    return buildInputField(
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      label: "كلمة المرور",
      hint: "أدخل كلمة المرور",
      icon: Icons.lock,
      obscureText: _isObscure,
      validator: (value) => validator(value!, 'password'),
      suffixIcon: IconButton(
        icon: Icon(
          _isObscure ? Icons.visibility_off : Icons.visibility,
          color: Colors.amber,
        ),
        onPressed: () => setState(() => _isObscure = !_isObscure),
      ),
    );
  }

  Widget _buildPhoneField() {
    return buildInputField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      label: "رقم الهاتف",
      hint: "أدخل رقم هاتفك",
      icon: Icons.phone,
      validator: (value) => validator(value!, 'phone'),
    );
  }


  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _registerUser,
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          minimumSize: const Size(double.infinity, 50)),
      child: _isLoading
          ? const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          color: Colors.black,
          strokeWidth: 2,
        ),
      )
          : const Text(
        "تسجيل",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}