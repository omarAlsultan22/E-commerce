import 'package:international_cuisine/features/auth/presentation/operations/auth_operations.dart';
import 'package:international_cuisine/features/auth/presentation/screens/sgin_in_screen.dart';
import 'package:international_cuisine/core/presentation/widgets/build_input_field.dart';
import '../../../../../core/data/data_sources/local/shared_preferences.dart';
import '../../../../../core/presentation/widgets/navigation/navigator.dart';
import '../../../../../core/presentation/widgets/build_snack_bar.dart';
import '../../../../../core/data/models/message_result_model.dart';
import '../../../../../core/presentation/widgets/sized_box.dart';
import 'package:flutter/material.dart';


class ChangeEmailAndPasswordLayout extends StatefulWidget {
  final AuthOperations _authOperations;
  const ChangeEmailAndPasswordLayout(this._authOperations, {super.key});

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
    return _buildMainContent();
  }

  Widget _buildMainContent() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: _buildBackButton(),
      title: const Text(
        'تغيير البريد وكلمة المرور',
        style: TextStyle(color: Colors.white),
      ),
      actions: [_buildSaveButton()],
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      color: Colors.white,
      onPressed: _isLoading ? null : () => Navigator.pop(context),
    );
  }

  Widget _buildSaveButton() {
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
    return BuildInputField(
      controller: newEmailController,
      hintText: "البريد الإلكتروني الجديد",
      prefixIcon: Icons.email,
      validator: (value) => _validateInput(value!, 'البريد الإلكتروني'),
    );
  }

  Widget _buildCurrentPasswordField() {
    return BuildInputField(
      controller: currentPasswordController,
      hintText: "كلمة المرور الحالية",
      prefixIcon: Icons.lock,
      obscureText: isObscure,
      suffixIcon: _buildVisibilityToggle(),
      validator: (value) => _validateInput(value!, 'كلمة المرور الحالية'),
    );
  }

  Widget _buildNewPasswordField() {
    return BuildInputField(
      controller: newPasswordController,
      hintText: "كلمة المرور الجديدة",
      prefixIcon: Icons.lock,
      obscureText: isObscure,
      suffixIcon: _buildVisibilityToggle(),
      validator: (value) => _validateInput(value!, 'كلمة المرور الجديدة'),
    );
  }

  Widget _buildConfirmPasswordField() {
    return BuildInputField(
      controller: repeatNewPasswordController,
      hintText: "تأكيد كلمة المرور الجديدة",
      prefixIcon: Icons.lock_reset,
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


  Future<void> _onSavePressed() async {
    if (!_validateForm()) return;
    await _saveChanges();
  }

  bool _validateForm() {
    if (!formKey.currentState!.validate()) return false;

    if (newPasswordController.text != repeatNewPasswordController.text) {
      _showPasswordMismatchError();
      return false;
    }

    return true;
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);

    final message = await widget._authOperations.changeEmailAndPassword(
        newEmail: newEmailController.text,
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text
    );

    _clearUserData();
    setState(() => _isLoading = false);
    _showMessageResult(message);
  }

  void _clearUserData() {
    CacheHelper.removeValue(key: 'uId');
  }

  String? _validateInput(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال $fieldName';
    }
    return null;
  }

  String? _validatePasswordConfirmation(dynamic value) {
    if (value == null || value.isEmpty) {
      return 'يرجى تأكيد كلمة المرور';
    }
    if (value != newPasswordController.text) {
      return 'كلمات المرور غير متطابقة';
    }
    return null;
  }

  void _showMessageResult(MessageResultModel message) {
    if (message.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
          buildSnackBar('تم التحديث بنجاح', Colors.green[800]!)
      );
      navigator(context: context, link: const SignInScreen());
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        buildSnackBar('فشل التحديث: ${message.error}', Colors.red[800]!),
      );
    }
  }

  void _showPasswordMismatchError() {
    ScaffoldMessenger.of(context).showSnackBar(
      buildSnackBar('كلمة المرور الجديدة غير متطابقة', Colors.red[800]!),
    );
  }
}