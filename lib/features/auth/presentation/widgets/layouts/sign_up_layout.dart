import 'package:flutter/material.dart';
import '../../screens/sgin_in_screen.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../../../core/presentation/widgets/validator.dart';
import '../../../../../core/data/models/message_result_model.dart';
import '../../../../../core/presentation/widgets/navigation/navigator.dart';
import 'package:international_cuisine/core/presentation/widgets/build_input_field.dart';
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
          text: 'تم إنشاء الحساب بنجاح',
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
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
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
                  const SizedBox(height: 24),
                  _buildFirstNameField(),
                  const SizedBox(height: 16),
                  _buildLastNameField(),
                  const SizedBox(height: 16),
                  _buildEmailField(),
                  const SizedBox(height: 16),
                  _buildPasswordField(),
                  const SizedBox(height: 16),
                  _buildPhoneField(),
                  const SizedBox(height: 16),
                  _buildLocationField(),
                  const SizedBox(height: 24),
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
            color: Colors.amber,
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
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildFirstNameField() {
    return BuildInputField(
      controller: _firstNameController,
      keyboardType: TextInputType.name,
      labelText: "الاسم الأول",
      hintText: "أدخل اسمك الأول",
      prefixIcon: Icons.person,
      validator: (value) => validator(value!, 'firstName'),
    );
  }

  Widget _buildLastNameField() {
    return BuildInputField(
      controller: _lastNameController,
      keyboardType: TextInputType.name,
      labelText: "الاسم الثاني",
      hintText: "أدخل اسمك الثاني",
      prefixIcon: Icons.person,
      validator: (value) => validator(value!, 'lastName'),
    );
  }

  Widget _buildEmailField() {
    return BuildInputField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      labelText: "البريد الإلكتروني",
      hintText: "أدخل بريدك الإلكتروني",
      prefixIcon: Icons.email,
      validator: (value) => validator(value!, 'email'),
    );
  }

  Widget _buildPasswordField() {
    return BuildInputField(
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      labelText: "كلمة المرور",
      hintText: "أدخل كلمة المرور",
      prefixIcon: Icons.lock,
      obscureText: _isObscure,
      validator: (value) => validator(value!, 'password'),
      suffixIcon: IconButton(
        icon: Icon(
          _isObscure ? Icons.visibility_off : Icons.visibility,
          color: Colors.amber,
        ),
        onPressed: _togglePasswordVisibility,
      ),
    );
  }

  Widget _buildPhoneField() {
    return BuildInputField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      labelText: "رقم الهاتف",
      hintText: "أدخل رقم هاتفك",
      prefixIcon: Icons.phone,
      validator: (value) => validator(value!, 'phone'),
    );
  }

  Widget _buildLocationField() {
    return BuildInputField(
      controller: _locationController,
      keyboardType: TextInputType.streetAddress,
      labelText: "الموقع",
      hintText: "أدخل موقعك",
      prefixIcon: Icons.location_on,
      validator: (value) => validator(value!, 'location'),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleRegister,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: _isLoading
          ? const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          color: Colors.black,
          strokeWidth: 2,
        ),
      )
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