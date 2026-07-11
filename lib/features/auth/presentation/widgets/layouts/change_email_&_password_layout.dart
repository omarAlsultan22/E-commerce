import 'package:international_cuisine/core/presentation/widgets/build_input_field.dart';
import 'package:international_cuisine/core/presentation/widgets/loading_widget.dart';
import 'package:international_cuisine/features/auth/presentation/screens/sgin_in_screen.dart';
import '../../../../../core/data/data_sources/local/shared_preferences.dart';
import '../../../../../core/presentation/widgets/navigation/navigator_with_delay.dart';
import 'package:international_cuisine/core/constants/app_text_styles.dart';
import 'package:international_cuisine/core/constants/app_paddings.dart';
import '../../../../../core/presentation/widgets/build_snack_bar.dart';
import 'package:international_cuisine/core/constants/app_spaces.dart';
import 'package:international_cuisine/core/constants/app_values.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import 'package:international_cuisine/core/constants/app_keys.dart';
import '../../../../../core/data/models/message_result.dart';
import '../../utils/validate/validate_password.dart';
import '../../utils/validate/validate_email.dart';
import 'package:flutter/material.dart';


class ChangeEmailAndPasswordLayout extends StatefulWidget {
  final void Function({
  required String newEmail,
  required String currentPassword,
  required String newPassword
  }) onUpdate;
  final CacheHelper cacheHelper;
  final MessageResult messageResult;
  const ChangeEmailAndPasswordLayout({
    super.key,
    required this.onUpdate,
    required this.cacheHelper,
    required this.messageResult
  });

  @override
  State<ChangeEmailAndPasswordLayout> createState() => _ChangeEmailAndPasswordLayoutState();
}

class _ChangeEmailAndPasswordLayoutState extends State<ChangeEmailAndPasswordLayout> {
  final _formKey = GlobalKey<FormState>();
  final _newEmailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _repeatNewPasswordController = TextEditingController();

  bool _isObscureCurrent = false;
  bool _isObscureNew = false;
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
    if (widget.messageResult.message != null) {
      _clearUserData();
      _showMessageResult(widget.messageResult);
    }
    setState(() {});
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
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      color: AppColors.white,
      onPressed: widget.messageResult.isLoading
          ? () => Navigator.pop(context)
          : null,
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: _paddingSymmetric,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryAmber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: _paddingSymmetric,
        ),
        onPressed: widget.messageResult.isLoading
            ? () => _onSavePressed()
            : null,
        child: _buildSaveButtonContent(),
      ),
    );
  }

  Widget _buildSaveButtonContent() {
    return widget.messageResult.isLoading
        ? const LoadingWidget(
        spacing: 20.0,
        strokeWidth: 2.0,
        color: AppColors.white
    )
        : const Text(
      'حفظ',
      style: AppTextStyles.textStyle16,
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
      suffixIcon: _buildVisibilityToggle(
          isObscure: _isObscureCurrent,
          onToggle: (value) =>
              setState(() => _isObscureCurrent = value)),
      validator: (value) => ValidatePassword.validator(value!),
    );
  }

  Widget _buildNewPasswordField() {
    return BuildInputField(
      controller: _newPasswordController,
      hintText: 'كلمة المرور الجديدة',
      prefixIcon: Icons.lock,
      obscureText: _isObscureNew,
      suffixIcon: _buildVisibilityToggle(
          isObscure: _isObscureNew,
          onToggle: (value) =>
              setState(() => _isObscureNew = value)),
      validator: (value) => ValidatePassword.validator(value!),
    );
  }

  Widget _buildConfirmPasswordField() {
    return BuildInputField(
      controller: _repeatNewPasswordController,
      hintText: "تأكيد كلمة المرور الجديدة",
      prefixIcon: Icons.lock_reset,
      obscureText: _isObscureConfirm,
      suffixIcon: _buildVisibilityToggle(
          isObscure: _isObscureConfirm,
          onToggle: (value) =>
              setState(() => _isObscureConfirm = value)),
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

  IconButton _buildVisibilityToggle({
    required bool isObscure,
    required void Function(bool) onToggle
  }) {
    return IconButton(
      icon: Icon(
        isObscure ? Icons.visibility_off : Icons.visibility,
        color: AppColors.primaryAmber,
      ),
      onPressed: () => onToggle(!isObscure),
    );
  }


  Future<void> _onSavePressed() async {
    if (!_validateForm()) return;
    await _saveChanges();
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) return false;

    if (_newPasswordController.text != _repeatNewPasswordController.text) {
      _showPasswordMismatchError();
      return false;
    }

    return true;
  }

  Future<void> _saveChanges() async {
    if (!_validateForm()) return;
    widget.onUpdate(
        newEmail: _newEmailController.text.trim(),
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text
    );
  }

  void _clearUserData() {
    widget.cacheHelper.removeValue(key: AppKeys.uId);
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

  void _showMessageResult(MessageResult messageResult) {
    BuildSnackBar.show(
        context: context,
        message: messageResult.message!,
        backgroundColor: messageResult.color!
    );
    BuildNavigatorWithDelay.build(context: context, link: SignInScreen());
  }

  void _showPasswordMismatchError() {
    BuildSnackBar.show(
        context: context,
        message: 'كلمة المرور الجديدة غير متطابقة',
        backgroundColor: AppColors.errorRed);
  }
}