import 'package:flutter/material.dart';
import '../../utils/validate/validate_email.dart';
import '../../utils/validate/validate_password.dart';
import '../../../../../core/data/models/message_result.dart';
import 'package:international_cuisine/core/constants/app_values.dart';
import 'package:international_cuisine/core/constants/app_spaces.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import 'package:international_cuisine/core/constants/app_paddings.dart';
import 'package:international_cuisine/core/constants/app_label_texts.dart';
import '../../../../../core/presentation/utils/validate/validator_input.dart';
import 'package:international_cuisine/core/presentation/widgets/build_input_field.dart';
import 'package:international_cuisine/core/presentation/widgets/back_button_widget.dart';
import 'package:international_cuisine/features/auth/presentation/mixins/auth_mixin.dart';
import 'package:international_cuisine/features/auth/constants/auth_hint_texts_constants.dart';
import 'package:international_cuisine/features/auth/constants/auth_label_texts_constants.dart';


class SignUpLayout extends StatefulWidget {
  final void Function({
  required String firstName,
  required String lastName,
  required String userEmail,
  required String userPassword,
  required String userPhone,
  required String userLocation
  }) onUpdate;
  final MessageResult messageResult;

  const SignUpLayout({
    super.key,
    required this.onUpdate,
    required this.messageResult
  });

  @override
  State<SignUpLayout> createState() => _SignUpLayoutState();
}

class _SignUpLayoutState extends State<SignUpLayout> with AuthMixin<SignUpLayout> {

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();

  bool _isPressed = true;
  bool _isObscure = true;

  static const _spacing16 = AppSpaces.verticalSpacing_16;
  static const _spacing24 = AppSpaces.verticalSpacing_24;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SignUpLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    handleMessageResultAndNavigate(
        messageResult: widget.messageResult,
        onNavigate: () => Navigator.pop(context)
    );
  }

  void _updateLockButton(bool value) {
    setState(() => _isPressed = value);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      hideKeyboard(context);
      _updateLockButton(false);
      await _performRegistration();
    }
  }

  Future<void> _performRegistration() async {
    widget.onUpdate(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        userEmail: _emailController.text.trim(),
        userPassword: _passwordController.text,
        userPhone: _phoneController.text.trim(),
        userLocation: _locationController.text.trim()
    );
    _updateLockButton(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGrey,
      appBar: AppBar(
        leading: BackButtonWidget(
            color: AppColors.white,
            onPressed: widget.messageResult.isLoading ? null : () =>
                Navigator.pop(context)),
        backgroundColor: Colors.transparent,
        elevation: AppValues.none,
        scrolledUnderElevation: AppValues.none,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: AppPaddings.all_large,
          child: RepaintBoundary(
            child: Form(
              key: _formKey,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(context),
                    _spacing24,
                    _buildFirstNameField(),
                    _spacing16,
                    _buildLastNameField(),
                    _spacing16,
                    _buildEmailField(),
                    _spacing16,
                    _buildPasswordField(),
                    _spacing16,
                    _buildPhoneField(),
                    _spacing16,
                    _buildLocationField(),
                    _spacing24,
                    _buildRegisterButton(context),
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
          'انشاء حساب',
          style: Theme
              .of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(
            color: AppColors.primaryAmber,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          'سجل الان كي تنضم إلى عالم السعادة',
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

  Widget _buildFirstNameField() {
    return BuildInputField(
      controller: _firstNameController,
      keyboardType: TextInputType.name,
      labelText: AppLabelTexts.firstName,
      hintText: 'ادخل اسمك الأول',
      prefixIcon: Icons.person,
      validator: (value) =>
          ValidateInput.validator(value!, AppLabelTexts.firstName),
    );
  }

  Widget _buildLastNameField() {
    return BuildInputField(
      controller: _lastNameController,
      keyboardType: TextInputType.name,
      labelText: AppLabelTexts.lastName,
      hintText: 'ادخل اسمك الثاني',
      prefixIcon: Icons.person,
      validator: (value) =>
          ValidateInput.validator(value!, AppLabelTexts.lastName),
    );
  }

  Widget _buildEmailField() {
    return BuildInputField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      labelText: AuthLabelTextsConstants.email,
      hintText: AuthHintTextsConstants.email,
      prefixIcon: Icons.email,
      validator: (value) =>
          ValidateEmail.validator(value!),
    );
  }

  Widget _buildPasswordField() {
    return BuildInputField(
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      labelText: AuthLabelTextsConstants.email,
      hintText: AuthHintTextsConstants.password,
      prefixIcon: Icons.lock,
      obscureText: _isObscure,
      validator: (value) => ValidatePassword.validator(value!),
      suffixIcon: buildPasswordVisibilityToggle(
          isObscure: _isObscure,
          onToggle: () => setState(() => _isObscure = !_isObscure)
      ),
    );
  }

  Widget _buildPhoneField() {
    return BuildInputField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      labelText: AppLabelTexts.phoneNumber,
      hintText: 'ادخل رقم هاتفك',
      prefixIcon: Icons.phone,
      validator: (value) =>
          ValidateInput.validator(value!, AppLabelTexts.phoneNumber),
    );
  }

  Widget _buildLocationField() {
    return BuildInputField(
      controller: _locationController,
      keyboardType: TextInputType.streetAddress,
      labelText: AppLabelTexts.location,
      hintText: 'ادخل عنوانك',
      prefixIcon: Icons.location_on,
      validator: (value) =>
          ValidateInput.validator(value!, AppLabelTexts.location),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return ElevatedButton(
        onPressed: _isPressed ? _submitForm : null,
        style: buttonStyle(),
        child: buildButtonContent(
            text: 'تسجيل',
            isLoading: widget.messageResult.isLoading
        )
    );
  }
}