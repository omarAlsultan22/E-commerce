import 'package:flutter/material.dart';
import '../../screens/sgin_up_screen.dart';
import '../../operations/auth_operations.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../../home/presentation/screens/home_screen.dart';
import '../../../../../core/data/models/message_result_model.dart';
import '../../../../../core/presentation/widgets/navigation/navigator.dart';
import '../../../../../core/data/data_sources/local/shared_preferences.dart';
import 'package:international_cuisine/core/presentation/widgets/build_input_field.dart';


class SignInLayout extends StatefulWidget {
  final AuthOperations _authOperations;
  const SignInLayout(this._authOperations, {super.key});

  @override
  State<SignInLayout> createState() => _SignInLayoutState();
}

class _SignInLayoutState extends State<SignInLayout> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isLoading = false;

  @override
  void initState() {
    _checkExistingUser();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold(context);
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 32),
                  _buildEmailField(),
                  const SizedBox(height: 16),
                  _buildPasswordField(),
                  const SizedBox(height: 24),
                  _buildLoginButton(context),
                  const SizedBox(height: 16),
                  _buildSignUpButton(),
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
          'تسجيل دخول',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'سجل الان كي تستمتع بأفضل العروض المتاحة',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return BuildInputField(
      controller: _emailController,
      labelText: "البريد الإلكتروني",
      hintText: "أدخل بريدك الإلكتروني",
      prefixIcon: Icons.email,
      validator: (value) => _validateEmail(value),
    );
  }

  Widget _buildPasswordField() {
    return BuildInputField(
      controller: _passwordController,
      labelText: "كلمة المرور",
      hintText: "أدخل كلمة المرور",
      prefixIcon: Icons.lock,
      obscureText: _isObscure,
      validator: (value) => _validatePassword(value),
      suffixIcon: _buildVisibilityToggle(),
    );
  }

  Widget _buildVisibilityToggle() {
    return IconButton(
      icon: Icon(
        _isObscure ? Icons.visibility_off : Icons.visibility,
        color: Colors.amber,
      ),
      onPressed: () => setState(() => _isObscure = !_isObscure),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleLogin,
      style: _loginButtonStyle(),
      child: _buildLoginButtonContent(),
    );
  }

  Widget _buildLoginButtonContent() {
    return _isLoading
        ? const SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(
        color: Colors.black,
        strokeWidth: 2,
      ),
    )
        : const Text(
      "دخول",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSignUpButton() {
    return TextButton(
      onPressed: _navigateToSignUp,
      style: _signUpButtonStyle(),
      child: const Text(
        "ليس لديك حساب؟ أنشئ حساب الآن",
        style: TextStyle(
          fontSize: 16,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Future<void> _checkExistingUser() async {
    final value = await CacheHelper.getStringValue(key: 'uId');
    if (value != null && mounted) {
      navigator(link: const HomeScreen(), context: context);
    }
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      _hideKeyboard();
      setState(() => _isLoading = true);
      final message = await widget._authOperations.signIn(
        userEmail: _emailController.text.trim(),
        userPassword: _passwordController.text,
      );
      setState(() => _isLoading = false);
      _showMessageResult(message);
    }
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _showMessageResult(MessageResultModel message) {
    if (message.isSuccess) {
      QuickAlert.show(
        context: context,
        text: 'تم التسجيل بنجاح',
        type: QuickAlertType.success,
        showConfirmBtn: false,
        autoCloseDuration: Duration(seconds: 3),
      ).whenComplete(() =>
          navigator(context: context, link: const HomeScreen())
      );
    }
    else {
      QuickAlert.show(
        context: context,
        text: 'فشل تسجيل الدخول: ${message.error.toString()}',
        type: QuickAlertType.error,
        showConfirmBtn: true,
      );
    }
  }


  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }
    if (!value.contains('@')) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }

  ButtonStyle _loginButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.amber,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      minimumSize: const Size(double.infinity, 50),
    );
  }

  ButtonStyle _signUpButtonStyle() {
    return TextButton.styleFrom(
      foregroundColor: Colors.amber,
      padding: const EdgeInsets.symmetric(vertical: 12),
    );
  }
}