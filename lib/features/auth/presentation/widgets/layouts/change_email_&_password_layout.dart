import 'package:international_cuisine/features/auth/presentation/screens/sgin_in_screen.dart';
import 'package:international_cuisine/core/presentation/widgets/back_button_widget.dart';
import 'package:international_cuisine/core/presentation/widgets/build_input_field.dart';
import '../../../../../core/presentation/widgets/navigation/navigator_with_delay.dart';
import 'package:international_cuisine/core/services/session_service.dart';
import 'package:international_cuisine/core/constants/app_paddings.dart';
import 'package:international_cuisine/core/constants/app_spaces.dart';
import 'package:international_cuisine/core/constants/app_values.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import '../../../../../core/data/models/message_result.dart';
import '../../utils/validate/validate_password.dart';
import '../../utils/validate/validate_email.dart';
import 'package:flutter/material.dart';
import '../../mixins/auth_mixin.dart';


class ChangeEmailAndPasswordLayout extends StatefulWidget {
  final void Function({
  required String newEmail,
  required String currentPassword,
  required String newPassword
  }) onUpdate;
  final MessageResult messageResult;
  final SessionService sessionService;
  const ChangeEmailAndPasswordLayout({
    super.key,
    required this.onUpdate,
    required this.messageResult,
    required this.sessionService,
  });

  @override
  State<ChangeEmailAndPasswordLayout> createState() => _ChangeEmailAndPasswordLayoutState();
}

class _ChangeEmailAndPasswordLayoutState extends State<ChangeEmailAndPasswordLayout> with AuthMixin<ChangeEmailAndPasswordLayout> {
  final _formKey = GlobalKey<FormState>();
  final _newEmailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _repeatNewPasswordController = TextEditingController();

  bool _isPressed = true;
  bool _isObscureNew = false;
  bool _isObscureCurrent = false;
  bool _isObscureConfirm = false;

  static const _verticalSpacing = AppSpaces.verticalSpacing_16;
  static const _paddingSymmetric = const EdgeInsets.symmetric(
      horizontal: 16.0);

  @override
  void dispose() {
    _newEmailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _repeatNewPasswordController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ChangeEmailAndPasswordLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    handleMessageResultAndNavigate(
        messageResult: widget.messageResult,
        onClear: () => _clearUserData(),
        onNavigate: () =>
            BuildNavigatorWithDelay.build(
                context: context,
                link: const SignInScreen()
            )
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainContent();
  }

  Widget _buildMainContent() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF212121),
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.transparent,
      elevation: AppValues.none,
      leading: _buildBackButton(),
      title: const Text(
        'تغيير البريد وكلمة المرور',
        style: TextStyle(color: AppColors.white),
      ),
      actions: [_buildSaveButton()],
    );
  }

  Widget _buildBackButton() {
    return BackButtonWidget(
      color: AppColors.white,
      onPressed: widget.messageResult.isLoading
          ? null
          : () => Navigator.pop(context),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: _paddingSymmetric,
      child: ElevatedButton(
        style: buttonStyle(padding: _paddingSymmetric),
        onPressed: _isPressed
            ? () => _onSavePressed()
            : null,
        child: buildButtonContent(
          text: 'حفظ',
          isSaveButton: true,
          isLoading: widget.messageResult.isLoading,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return IgnorePointer(
      ignoring: widget.messageResult.isLoading,
      child: Container(
        decoration: _buildBackgroundDecoration(),
        child: Center(
          child: SingleChildScrollView(
            padding: AppPaddings.all_large,
            child: RepaintBoundary(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildEmailField(),
                    _verticalSpacing,
                    _buildCurrentPasswordField(),
                    _verticalSpacing,
                    _buildNewPasswordField(),
                    _verticalSpacing,
                    _buildConfirmPasswordField(),
                    if (widget.messageResult
                        .isLoading) _buildLoadingIndicator(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.darkGrey,
          AppColors.lightGrey400,
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return BuildInputField(
      controller: _newEmailController,
      hintText: 'يمكنك اضافة بريد إلكتروني الجديد',
      prefixIcon: Icons.email,
      validator: (value) => ValidateEmail.validator(value),
    );
  }

  Widget _buildCurrentPasswordField() {
    return BuildInputField(
      controller: _currentPasswordController,
      hintText: 'كلمة المرور الحالية',
      prefixIcon: Icons.lock,
      obscureText: _isObscureCurrent,
      suffixIcon: buildPasswordVisibilityToggle(
          isObscure: _isObscureCurrent,
          onToggle: () =>
              setState(() => _isObscureCurrent = !_isObscureCurrent)),
      validator: (value) => ValidatePassword.validator(value!),
    );
  }

  Widget _buildNewPasswordField() {
    return BuildInputField(
      controller: _newPasswordController,
      hintText: 'كلمة المرور الجديدة',
      prefixIcon: Icons.lock,
      obscureText: _isObscureNew,
      suffixIcon: buildPasswordVisibilityToggle(
          isObscure: _isObscureNew,
          onToggle: () =>
              setState(() => _isObscureNew = !_isObscureNew)),
      validator: (value) => ValidatePassword.validator(value!),
    );
  }

  Widget _buildConfirmPasswordField() {
    return BuildInputField(
      controller: _repeatNewPasswordController,
      hintText: "تأكيد كلمة المرور الجديدة",
      prefixIcon: Icons.lock_reset,
      obscureText: _isObscureConfirm,
      suffixIcon: buildPasswordVisibilityToggle(
          isObscure: _isObscureConfirm,
          onToggle: () =>
              setState(() => _isObscureConfirm = !_isObscureConfirm)),
      validator: _validatePasswordConfirmation,
    );
  }

  Widget _buildLoadingIndicator() {
    return const Column(
      children: [
        AppSpaces.verticalSpacing_24,
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryAmber),
        ),
      ],
    );
  }

  Future<void> _onSavePressed() async {
    if (!_validateForm()) return;
    _updateLockButton(false);
    hideKeyboard(context);
    await _saveChanges();
  }

  bool _validateForm() {
    if (!validator(_formKey)) return false;

    if (_newPasswordController.text != _repeatNewPasswordController.text) {
      showMessageResult(
          context: context,
          color: AppColors.errorRed,
          message: 'كلمة المرور الجديدة غير متطابقة'
      );
      return false;
    }

    return true;
  }

  void _updateLockButton(bool value) {
    setState(() => _isPressed = value);
  }

  Future<void> _saveChanges() async {
    widget.onUpdate(
        newEmail: _newEmailController.text.trim(),
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text
    );
    _updateLockButton(true);
  }

  void _clearUserData() {
    widget.sessionService.logout();
  }

  String? _validatePasswordConfirmation(dynamic value) {
    if (value == null || value.isEmpty) {
      return 'يرجى تأكيد كلمة المرور';
    }
    if (value != _newPasswordController.text) {
      return 'كلمات المرور غير متطابقة';
    }
    return null;
  }
}