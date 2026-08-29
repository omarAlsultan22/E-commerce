import 'package:flutter/material.dart';
import '../../screens/sgin_up_screen.dart';
import '../../utils/validate/validate_email.dart';
import '../../screens/forget_password_screen.dart';
import '../../utils/validate/validate_password.dart';
import '../../../constants/auth_label_texts_constants.dart';
import '../../../../../core/data/models/message_result.dart';
import '../../../../home/presentation/screens/home_screen.dart';
import 'package:international_cuisine/core/constants/app_keys.dart';
import 'package:international_cuisine/core/constants/app_sizes.dart';
import 'package:international_cuisine/core/constants/app_spaces.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import 'package:international_cuisine/core/constants/app_paddings.dart';
import '../../../../../core/data/data_sources/local/cache_helper.dart';
import 'package:international_cuisine/core/presentation/widgets/build_input_field.dart';
import 'package:international_cuisine/features/auth/presentation/mixins/auth_mixin.dart';
import 'package:international_cuisine/features/auth/constants/auth_hint_texts_constants.dart';
import 'package:international_cuisine/core/presentation/widgets/navigation/navigator_push.dart';


class SignInLayout extends StatefulWidget {
  final void Function({
  required String userEmail,
  required String userPassword
  }) onUpdate;
  final CacheHelper cacheHelper;
  final MessageResult messageResult;
  const SignInLayout({
    super.key,
    required this.onUpdate,
    required this.cacheHelper,
    required this.messageResult
  });

  @override
  State<SignInLayout> createState() => _SignInLayoutState();
}

class _SignInLayoutState extends State<SignInLayout> with AuthMixin<SignInLayout> {
  bool _isPressed = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isObscure = true;

  static const _verticalSpacing = AppSpaces.verticalSpacing_16;

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
  void didUpdateWidget(covariant SignInLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    handleMessageResultAndNavigate(
        messageResult: widget.messageResult,
        onNavigate: _navigateToHome
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold(context);
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGrey,
      body: Center(
        child: SingleChildScrollView(
          padding: AppPaddings.all_large,
          child: RepaintBoundary(
            child: Form(
              key: _formKey,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(context),
                    AppSpaces.verticalSpacing_32,
                    _buildEmailField(),
                    _verticalSpacing,
                    _buildPasswordField(),
                    AppSpaces.verticalSpacing_24,
                    _buildLoginButton(context),
                    _verticalSpacing,
                    _buildSignUpButton(),
                    _buildForgetPasswordLink()
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
            color: AppColors.primaryAmber,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpaces.verticalSpacing_8,
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
      suffixIcon: buildPasswordVisibilityToggle(
          isObscure: _isObscure,
          onToggle: () => setState(() => _isObscure = !_isObscure)
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _isPressed ? _submitForm : null,
      style: buttonStyle(),
      child: buildButtonContent(
          text: 'دخول',
          isLoading: widget.messageResult.isLoading),
    );
  }

  Widget _buildSignUpButton() {
    return TextButton(
      onPressed: _navigateToSignUp,
      style: _signUpButtonStyle(),
      child: const Text(
        "ليس لديك حساب؟ أنشئ حساب الآن",
        style: TextStyle(
          fontSize: AppSizes.fontSize16,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildForgetPasswordLink() {
    return Center(
      child: TextButton(
        onPressed: () {
          BuildNavigatorPush.build(
            context: context,
            link: const ForgetPasswordScreen(),
          );
        },
        child: const Text(
          'نسيت كلمة المرور؟',
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Future<void> _checkExistingUser() async {
    final userId = await widget.cacheHelper.getStringValue(key: AppKeys.uId);
    if (userId != null && mounted) {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    BuildNavigatorPush.build(context: context, link: const HomeScreen());
  }

  void _navigateToSignUp() {
    BuildNavigatorPush.build(context: context, link: const SignUpScreen());
  }

  void _updateLockButton(bool value) {
    setState(() => _isPressed = value);
  }

  Future<void> _submitForm() async {
    if (validator(_formKey)) {
      _updateLockButton(false);
      hideKeyboard(context);
      widget.onUpdate(
          userEmail: _emailController.text.trim(),
          userPassword: _passwordController.text
      );
      _updateLockButton(false);
    }
  }

  ButtonStyle _signUpButtonStyle() {
    return TextButton.styleFrom(
      foregroundColor: AppColors.primaryAmber,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
    );
  }
}