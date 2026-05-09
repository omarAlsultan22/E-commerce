import 'package:flutter/material.dart';
import 'package:international_cuisine/core/constants/app_paddings.dart';
import 'package:international_cuisine/core/constants/app_text_styles.dart';
import '../../screens/sgin_up_screen.dart';
import '../../utils/validate/validate_email.dart';
import '../../utils/validate/validate_password.dart';
import '../../../constants/auth_label_texts_constants.dart';
import '../../../../../core/data/models/message_result.dart';
import '../../../../home/presentation/screens/home_screen.dart';
import 'package:international_cuisine/core/constants/app_keys.dart';
import 'package:international_cuisine/core/constants/app_sizes.dart';
import 'package:international_cuisine/core/constants/app_spaces.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import '../../../../../core/presentation/widgets/build_snack_bar.dart';
import '../../../../../core/presentation/widgets/navigation/navigator.dart';
import '../../../../../core/data/data_sources/local/shared_preferences.dart';
import 'package:international_cuisine/core/presentation/widgets/loading_widget.dart';
import 'package:international_cuisine/core/presentation/widgets/build_input_field.dart';
import 'package:international_cuisine/features/auth/constants/auth_hint_texts_constants.dart';


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

class _SignInLayoutState extends State<SignInLayout> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isObscure = true;

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
    if (widget.messageResult.message != null) {
      _showMessageResult(widget.messageResult);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold(context);
  }

  Widget _buildScaffold(BuildContext context) {
    const _verticalSpacing = AppSpaces.verticalSpacing_16;

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
      suffixIcon: _buildVisibilityToggle(),
    );
  }

  Widget _buildVisibilityToggle() {
    return IconButton(
      icon: Icon(
        _isObscure ? Icons.visibility_off : Icons.visibility,
        color: AppColors.primaryAmber,
      ),
      onPressed: () => setState(() => _isObscure = !_isObscure),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.messageResult.isLoading ? _submitForm : null,
      style: _loginButtonStyle(),
      child: _buildLoginButtonContent(),
    );
  }

  Widget _buildLoginButtonContent() {
    return widget.messageResult.isLoading
        ? const LoadingWidget()
        : const Text(
      "دخول",
      style: AppTextStyles.textStyle18,
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

  Future<void> _checkExistingUser() async {
    final userId = await widget.cacheHelper.getStringValue(key: AppKeys.uId);
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _hideKeyboard();
      widget.onUpdate(
          userEmail: _emailController.text.trim(),
          userPassword: _passwordController.text
      );
    }
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _showMessageResult(MessageResult messageResult) {
    ScaffoldMessenger.of(context).showSnackBar(
        BuildSnackBar.build(messageResult.message!, messageResult.color!)
    );
    navigator(context: context);
  }

  ButtonStyle _loginButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryAmber,
      foregroundColor: AppColors.black,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      minimumSize: const Size(double.infinity, 50.0),
    );
  }

  ButtonStyle _signUpButtonStyle() {
    return TextButton.styleFrom(
      foregroundColor: AppColors.primaryAmber,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
    );
  }
}