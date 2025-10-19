import 'package:international_cuisine/shared/local/shared_preferences.dart';
import 'package:international_cuisine/shared/components/constant.dart';
import 'package:international_cuisine/shared/cubit/state.dart';
import '../../shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../modules/sgin_up/sgin_up_screen.dart';
import '../modules/home/home_screen.dart';
import '../modules/sgin_in/cubit.dart';
import 'package:flutter/material.dart';


class SignInLayout extends StatefulWidget {
  const SignInLayout({super.key});

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
    return BlocConsumer<LoginCubit, CubitStates>(
      listener: _loginListener,
      builder: (context, state) => _buildScaffold(context),
    );
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
    return buildInputField(
      controller: _emailController,
      label: "البريد الإلكتروني",
      hint: "أدخل بريدك الإلكتروني",
      icon: Icons.email,
      validator: (value) => _validateEmail(value),
    );
  }

  Widget _buildPasswordField() {
    return buildInputField(
      controller: _passwordController,
      label: "كلمة المرور",
      hint: "أدخل كلمة المرور",
      icon: Icons.lock,
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

  void _loginListener(BuildContext context, CubitStates state) {
    if (state is SuccessState) {
      _navigateToHome();
    }
  }

  Future<void> _checkExistingUser() async {
    final value = await CacheHelper.getString(key: 'uId');
    if (value != null && mounted) {
      UserDetails.uId = value;
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await context.read<LoginCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        context: context,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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