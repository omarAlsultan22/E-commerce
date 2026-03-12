import 'package:flutter/material.dart';
import '../../screens/sgin_in_screen.dart';
import '../../utils/validate/validate_email.dart';
import '../../utils/validate/validate_password.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../../../core/data/models/message_result_model.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import 'package:international_cuisine/core/constants/app_numbers.dart';
import 'package:international_cuisine/core/constants/app_hint_texts.dart';
import 'package:international_cuisine/core/constants/app_label_texts.dart';
import '../../../../../core/presentation/widgets/navigation/navigator.dart';
import '../../../../../core/presentation/utils/validate/validator_input.dart';
import 'package:international_cuisine/core/presentation/widgets/app_spacing.dart';
import 'package:international_cuisine/core/presentation/widgets/build_input_field.dart';
import 'package:international_cuisine/features/auth/constants/auth_numbers_constants.dart';
import 'package:international_cuisine/features/auth/presentation/widgets/auth_spacing.dart';
import 'package:international_cuisine/features/auth/constants/auth_hint_texts_constants.dart';
import 'package:international_cuisine/features/auth/constants/auth_label_texts_constants.dart';
import 'package:international_cuisine/features/auth/presentation/operations/auth_operations.dart';


class SignUpLayout extends StatefulWidget {
  final AuthOperations _authOperations;
  const SignUpLayout(this._authOperations,{super.key});

  @override
  State<SignUpLayout> createState() => _SignUpLayoutState();
}

class _SignUpLayoutState extends State<SignUpLayout> {

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();

  bool _isObscure = true;
  bool _isLoading = false;

  static const _primaryAmber = AppColors.primaryAmber;

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

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final message = await widget._authOperations.signUp(
      userEmail: _emailController.text,
      userPassword: _passwordController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      userPhone: _phoneController.text,
      userLocation: _locationController.text,
    );
    setState(() => _isLoading = false);
    _showMessageResult(message);
  }

  void _showMessageResult(MessageResultModel message) {
    if (message.isSuccess) {
      QuickAlert.show(
          context: context,
          text: 'تم انشاء الحساب بنجاح',
          type: QuickAlertType.success,
          showConfirmBtn: true,
          onConfirmBtnTap: () =>
              navigator(link: const SignInScreen(), context: context)
      );
    }
    else {
      QuickAlert.show(
        context: context,
        text: 'فشل انشاء الحساب: ${message.error.toString()}',
        type: QuickAlertType.error,
        showCancelBtn: true,
      );
    }
  }


  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    const _zero = AppNumbers.zero;
    const _height16 = AppSpacing.height_16;
    const _height24 = AppSpacing.height24;

    return Scaffold(
      backgroundColor: AppColors.darkGrey,
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: AppColors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: _zero,
        scrolledUnderElevation: _zero,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context),
                  _height24,
                  _buildFirstNameField(),
                  _height16,
                  _buildLastNameField(),
                  _height16,
                  _buildEmailField(),
                  _height16,
                  _buildPasswordField(),
                  _height16,
                  _buildPhoneField(),
                  _height16,
                  _buildLocationField(),
                  _height24,
                  _buildRegisterButton(context),
                ],
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
            color: _primaryAmber,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
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
    const _firstName = AppLabelTexts.firstName;

    return BuildInputField(
      controller: _firstNameController,
      keyboardType: TextInputType.name,
      labelText: _firstName,
      hintText: AppHintTexts.firstName,
      prefixIcon: Icons.person,
      validator: (value) => ValidateInput.validator(value!, _firstName),
    );
  }

  Widget _buildLastNameField() {
    const _lastName = AppLabelTexts.lastName;

    return BuildInputField(
      controller: _lastNameController,
      keyboardType: TextInputType.name,
      labelText: _lastName,
      hintText: AppHintTexts.lastName,
      prefixIcon: Icons.person,
      validator: (value) => ValidateInput.validator(value!, _lastName),
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
      suffixIcon: IconButton(
        icon: Icon(
          _isObscure ? Icons.visibility_off : Icons.visibility,
          color: _primaryAmber,
        ),
        onPressed: _togglePasswordVisibility,
      ),
    );
  }

  Widget _buildPhoneField() {
    const _phoneNumber = AppLabelTexts.phoneNumber;

    return BuildInputField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      labelText: _phoneNumber,
      hintText: AppHintTexts.phoneNumber,
      prefixIcon: Icons.phone,
      validator: (value) => ValidateInput.validator(value!, _phoneNumber),
    );
  }

  Widget _buildLocationField() {
    const _location = AppLabelTexts.location;

    return BuildInputField(
      controller: _locationController,
      keyboardType: TextInputType.streetAddress,
      labelText: _location,
      hintText: AppHintTexts.location,
      prefixIcon: Icons.location_on,
      validator: (value) => ValidateInput.validator(value!, _location),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleRegister,
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryAmber,
        foregroundColor: AppColors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AuthNumbersConstants.fifty),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: _isLoading
          ? AuthSpacing.sizedBox
          : const Text(
        "تسجيل",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}