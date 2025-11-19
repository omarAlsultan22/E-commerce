import 'package:international_cuisine/modules/sgin_in/sgin_in_screen.dart';
import 'package:international_cuisine/modules/update/cubit.dart';
import 'package:international_cuisine/shared/cubit/state.dart';
import '../../shared/local/shared_preferences.dart';
import '../../shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';


class ChangeEmailAndPasswordLayout extends StatefulWidget {
  const ChangeEmailAndPasswordLayout({super.key});

  @override
  State<ChangeEmailAndPasswordLayout> createState() => _ChangeEmailAndPasswordLayoutState();
}

class _ChangeEmailAndPasswordLayoutState extends State<ChangeEmailAndPasswordLayout> {
  final formKey = GlobalKey<FormState>();
  final newEmailController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final repeatNewPasswordController = TextEditingController();

  bool isObscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    newEmailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    repeatNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppModelCubit, CubitStates>(
      builder: (context, state) => _buildMainContent(context, state),
    );
  }

  Widget _buildMainContent(BuildContext context, CubitStates state) {
    final cubit = AppModelCubit.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: _buildAppBar(cubit, state),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar(AppModelCubit cubit, CubitStates state) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: _buildBackButton(),
      title: const Text(
        'تغيير البريد وكلمة المرور',
        style: TextStyle(color: Colors.white),
      ),
      actions: [_buildSaveButton(cubit, state)],
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      color: Colors.white,
      onPressed: _isLoading ? null : () => Navigator.pop(context),
    );
  }

  Widget _buildSaveButton(AppModelCubit cubit, CubitStates state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: _isLoading ? null : () => _onSavePressed(cubit),
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
        color: Colors.white,
      ),
    )
        : const Text(
      'حفظ',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildBody() {
    return IgnorePointer(
      ignoring: _isLoading,
      child: Container(
        decoration: _buildBackgroundDecoration(),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  _buildEmailField(),
                  sizedBox(),
                  _buildCurrentPasswordField(),
                  sizedBox(),
                  _buildNewPasswordField(),
                  sizedBox(),
                  _buildConfirmPasswordField(),
                  if (_isLoading) _buildLoadingIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.grey[900]!,
          Colors.grey[800]!,
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return buildInputField(
      controller: newEmailController,
      hint: "البريد الإلكتروني الجديد",
      icon: Icons.email,
      validator: (value) => _validateInput(value!, 'البريد الإلكتروني'),
    );
  }

  Widget _buildCurrentPasswordField() {
    return buildInputField(
      controller: currentPasswordController,
      hint: "كلمة المرور الحالية",
      icon: Icons.lock,
      obscureText: isObscure,
      suffixIcon: _buildVisibilityToggle(),
      validator: (value) => _validateInput(value!, 'كلمة المرور الحالية'),
    );
  }

  Widget _buildNewPasswordField() {
    return buildInputField(
      controller: newPasswordController,
      hint: "كلمة المرور الجديدة",
      icon: Icons.lock,
      obscureText: isObscure,
      suffixIcon: _buildVisibilityToggle(),
      validator: (value) => _validateInput(value!, 'كلمة المرور الجديدة'),
    );
  }

  Widget _buildConfirmPasswordField() {
    return buildInputField(
      controller: repeatNewPasswordController,
      hint: "تأكيد كلمة المرور الجديدة",
      icon: Icons.lock_reset,
      obscureText: isObscure,
      suffixIcon: _buildVisibilityToggle(),
      validator: _validatePasswordConfirmation,
    );
  }

  Widget _buildLoadingIndicator() {
    return const Column(
      children: [
        SizedBox(height: 24),
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
        ),
      ],
    );
  }

  IconButton _buildVisibilityToggle() {
    return IconButton(
      icon: Icon(
        isObscure ? Icons.visibility_off : Icons.visibility,
        color: Colors.amber[700],
      ),
      onPressed: () => setState(() => isObscure = !isObscure),
    );
  }

  void _onSavePressed(AppModelCubit cubit) {
    if (!_validateForm()) return;
    _saveChanges(cubit);
  }

  bool _validateForm() {
    if (!formKey.currentState!.validate()) return false;

    if (newPasswordController.text != repeatNewPasswordController.text) {
      _showPasswordMismatchError();
      return false;
    }

    return true;
  }

  Future<void> _saveChanges(AppModelCubit cubit) async {
    setState(() => _isLoading = true);

    try {
      await cubit.changeEmailAndPassword(
        newEmail: newEmailController.text,
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
      ).then((_) {
        CacheHelper.remove(key: 'uId');
      }).whenComplete(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      });
    } catch (error) {
      _showError(error.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _validateInput(String value, String fieldName) {
    if (value.isEmpty) {
      return 'يرجى إدخال $fieldName';
    }
    return null;
  }

  String? _validatePasswordConfirmation(String? value) {
    if (value!.isEmpty) return 'يرجى تأكيد كلمة المرور';
    if (value != newPasswordController.text) {
      return 'كلمات المرور غير متطابقة';
    }
    return null;
  }

  void _showPasswordMismatchError() {
    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar('كلمة المرور الجديدة غير متطابقة', Colors.red[800]!),
    );
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar('فشل التحديث: $error', Colors.red[800]!),
    );
  }

  SnackBar _buildSnackBar(String message, Color backgroundColor) {
    return SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      duration: const Duration(seconds: 3),
    );
  }
}