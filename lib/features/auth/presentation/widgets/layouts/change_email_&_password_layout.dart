import 'package:international_cuisine/features/auth/presentation/operations/auth_operations.dart';
import 'package:international_cuisine/features/auth/presentation/screens/sgin_in_screen.dart';
import 'package:international_cuisine/core/presentation/widgets/build_input_field.dart';
import 'package:international_cuisine/core/presentation/widgets/app_spacing.dart';
import '../../../../../core/data/data_sources/local/shared_preferences.dart';
import '../../../../../core/presentation/widgets/navigation/navigator.dart';
import '../../../../../core/presentation/widgets/build_snack_bar.dart';
import 'package:international_cuisine/core/constants/app_numbers.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import 'package:international_cuisine/core/constants/app_states.dart';
import 'package:international_cuisine/core/constants/app_keys.dart';
import '../../../../../core/data/models/message_result_model.dart';
import '../../utils/validate/validate_password.dart';
import '../../utils/validate/validate_email.dart';
import 'package:flutter/material.dart';


class ChangeEmailAndPasswordLayout extends StatefulWidget {
  final AuthOperations _authOperations;
  const ChangeEmailAndPasswordLayout(this._authOperations, {super.key});

  @override
  State<ChangeEmailAndPasswordLayout> createState() => _ChangeEmailAndPasswordLayoutState();
}

class _ChangeEmailAndPasswordLayoutState extends State<ChangeEmailAndPasswordLayout> {
  final _formKey = GlobalKey<FormState>();
  final _newEmailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _repeatNewPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isObscureCurrent = false;
  bool _isObscureNew = false;
  bool _isObscureConfirm = false;

  //colors
  static const _white = AppColors.white;
  static const _errorRed = AppColors.errorRed;
  static const _primaryAmber = AppColors.primaryAmber;

  @override
  void dispose() {
    _newEmailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _repeatNewPasswordController.dispose();
    super.dispose();
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
      elevation: AppNumbers.zero,
      leading: _buildBackButton(),
      title: const Text(
        'تغيير البريد وكلمة المرور',
        style: TextStyle(color: _white),
      ),
      actions: [_buildSaveButton()],
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      color: _white,
      onPressed: _isLoading ? null : () => Navigator.pop(context),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryAmber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: _isLoading ? null : () => _onSavePressed(),
        child: _buildSaveButtonContent(),
      ),
    );
  }

  Widget _buildSaveButtonContent() {
    return _isLoading
        ? const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: _white,
      ),
    )
        : const Text(
      'حفظ',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: _white,
      ),
    );
  }

  Widget _buildBody() {
    const _verticalSpacing = AppSpacing.height_16;

    return IgnorePointer(
      ignoring: _isLoading,
      child: Container(
        decoration: _buildBackgroundDecoration(),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
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
                    if (_isLoading) _buildLoadingIndicator(),
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
    const currentPassword = 'كلمة المرور الحالية';
    return BuildInputField(
      controller: _currentPasswordController,
      hintText: currentPassword,
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
    const newPassword = 'كلمة المرور الجديدة';
    return BuildInputField(
      controller: _newPasswordController,
      hintText: newPassword,
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
        AppSpacing.height24,
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(_primaryAmber),
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
        color: _primaryAmber,
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
    setState(() => _isLoading = true);

    final message = await widget._authOperations.changeEmailAndPassword(
        newEmail: _newEmailController.text,
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text
    );

    _clearUserData();
    setState(() => _isLoading = false);
    _showMessageResult(message);
  }

  void _clearUserData() {
    CacheHelper.removeValue(key: AppKeys.uId);
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

  void _showMessageResult(MessageResultModel message) {
    if (message.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
          buildSnackBar(AppStates.success, AppColors.successGreen)
      );
      navigator(context: context, link: const SignInScreen());
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        buildSnackBar(' ${AppStates.failed}${message.error}',
            _errorRed),
      );
    }
  }

  void _showPasswordMismatchError() {
    ScaffoldMessenger.of(context).showSnackBar(
      buildSnackBar('كلمة المرور الجديدة غير متطابقة', _errorRed),
    );
  }
}