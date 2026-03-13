import 'package:flutter/material.dart';
import '../../screens/sgin_up_screen.dart';
import '../../operations/auth_operations.dart';
import '../../utils/validate/validate_email.dart';
import '../../utils/validate/validate_password.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../constants/auth_label_texts_constants.dart';
import '../../../../home/presentation/screens/home_screen.dart';
import '../../../../../core/data/models/message_result_model.dart';
import 'package:international_cuisine/core/constants/app_keys.dart';
import 'package:international_cuisine/core/constants/app_states.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import '../../../../../core/presentation/widgets/navigation/navigator.dart';
import '../../../../../core/data/data_sources/local/shared_preferences.dart';
import 'package:international_cuisine/core/presentation/widgets/app_spacing.dart';
import 'package:international_cuisine/core/presentation/widgets/build_input_field.dart';
import 'package:international_cuisine/features/auth/constants/auth_numbers_constants.dart';
import 'package:international_cuisine/features/auth/presentation/widgets/auth_spacing.dart';
import 'package:international_cuisine/features/auth/constants/auth_hint_texts_constants.dart';


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

  static const _primaryAmber = AppColors.primaryAmber;

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
    const _verticalSpacing = AppSpacing.height_16;

    return Scaffold(
      backgroundColor: AppColors.darkGrey,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: RepaintBoundary(
            child: Form(
              key: _formKey,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(context),
                    AppSpacing.height_32,
                    _buildEmailField(),
                    _verticalSpacing,
                    _buildPasswordField(),
                    AppSpacing.height24,
                    _buildLoginButton(context),
                    _verticalSpacing,
                    _buildSignUpButton(),
                  ],
                ),
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
          style: Theme
              .of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(
            color: _primaryAmber,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacing.height_8,
        Text(
          'سجل الان كي تستمتع بأفضل العروض المتاحة',
          style: Theme
              .of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
            color: AppColors.lightGrey400,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return BuildInputField(
      controller: _emailController,
      labelText: AuthLabelTextsConstants.email,
      hintText: AuthHintTextsConstants.email,
      prefixIcon: Icons.email,
      validator: (value) => ValidateEmail.validator(value),
    );
  }

  Widget _buildPasswordField() {
    return BuildInputField(
      controller: _passwordController,
      labelText: AuthLabelTextsConstants.password,
      hintText: AuthHintTextsConstants.password,
      prefixIcon: Icons.lock,
      obscureText: _isObscure,
      validator: (value) => ValidatePassword.validator(value),
      suffixIcon: _buildVisibilityToggle(),
    );
  }

  Widget _buildVisibilityToggle() {
    return IconButton(
      icon: Icon(
        _isObscure ? Icons.visibility_off : Icons.visibility,
        color: _primaryAmber,
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
        ? AuthSpacing.sizedBox
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
    final userId = await CacheHelper.getStringValue(key: AppKeys.uId);
    if (userId != null && mounted) {
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
        text: AppStates.success,
        type: QuickAlertType.success,
        showConfirmBtn: false,
        autoCloseDuration: const Duration(seconds: 3),
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

  ButtonStyle _loginButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: _primaryAmber,
      foregroundColor: AppColors.black,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AuthNumbersConstants.fifty),
      ),
      minimumSize: const Size(double.infinity, 50),
    );
  }

  ButtonStyle _signUpButtonStyle() {
    return TextButton.styleFrom(
      foregroundColor: _primaryAmber,
      padding: const EdgeInsets.symmetric(vertical: 12),
    );
  }
}