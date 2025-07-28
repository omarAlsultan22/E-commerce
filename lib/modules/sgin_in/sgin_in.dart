import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:international_cuisine/modules/sgin_up/sgin_up.dart';
import 'package:international_cuisine/shared/components/constant.dart';
import 'package:international_cuisine/shared/cubit/state.dart';
import 'package:international_cuisine/shared/local/shared_preferences.dart';
import '../../shared/components/components.dart';
import '../home/home_screen.dart';
import 'cubit.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isLoading = false;

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUp()),
    );
  }

  void checkIsUser()async {
    final value = await CacheHelper.getString(key: 'uId');
    if (value != null) {
      UserDetails.uId = value;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  @override
  void initState() {
    checkIsUser();
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
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, CubitStates>(
        listener: (context, state) {
          if (state is SuccessState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        },
        builder: (context, state) {
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
        },
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
      validator: (value) => validator(value!, 'email'),
    );
  }

  Widget _buildPasswordField() {
    return buildInputField(
      controller: _passwordController,
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

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
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
        "دخول",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return TextButton(
      onPressed: _navigateToSignUp,
      style: TextButton.styleFrom(
        foregroundColor: Colors.amber,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: const Text(
        "ليس لديك حساب؟ أنشئ حساب الآن",
        style: TextStyle(
          fontSize: 16,
          decoration: TextDecoration.underline,
        ),
      ),
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
}