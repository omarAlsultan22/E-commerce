import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/components.dart';
import 'package:flutter/material.dart';
import '../../shared/cubit/state.dart';
import '../modules/sgin_up/cubit.dart';


class SignUpLayout extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;
  final TextEditingController locationController;
  final bool isObscure;
  final VoidCallback onRegisterPressed;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onBackPressed;

  const SignUpLayout({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.phoneController,
    required this.locationController,
    required this.isObscure,
    required this.onRegisterPressed,
    required this.onTogglePasswordVisibility,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: InkWell(
          onTap: onBackPressed,
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
            key: formKey,
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
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'سجل الان كي تنضم إلى عالم السعادة',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildFirstNameField() {
    return buildInputField(
      controller: firstNameController,
      keyboardType: TextInputType.name,
      label: "الاسم الأول",
      hint: "أدخل اسمك الأول",
      icon: Icons.person,
      validator: (value) => validator(value!, 'firstName'),
    );
  }

  Widget _buildLastNameField() {
    return buildInputField(
      controller: lastNameController,
      keyboardType: TextInputType.name,
      label: "الاسم الثاني",
      hint: "أدخل اسمك الثاني",
      icon: Icons.person,
      validator: (value) => validator(value!, 'lastName'),
    );
  }

  Widget _buildEmailField() {
    return buildInputField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      label: "البريد الإلكتروني",
      hint: "أدخل بريدك الإلكتروني",
      icon: Icons.email,
      validator: (value) => validator(value!, 'email'),
    );
  }

  Widget _buildPasswordField() {
    return buildInputField(
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      label: "كلمة المرور",
      hint: "أدخل كلمة المرور",
      icon: Icons.lock,
      obscureText: isObscure,
      validator: (value) => validator(value!, 'password'),
      suffixIcon: IconButton(
        icon: Icon(
          isObscure ? Icons.visibility_off : Icons.visibility,
          color: Colors.amber,
        ),
        onPressed: onTogglePasswordVisibility,
      ),
    );
  }

  Widget _buildPhoneField() {
    return buildInputField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      label: "رقم الهاتف",
      hint: "أدخل رقم هاتفك",
      icon: Icons.phone,
      validator: (value) => validator(value!, 'phone'),
    );
  }

  Widget _buildLocationField() {
    return buildInputField(
      controller: locationController,
      keyboardType: TextInputType.streetAddress,
      label: "الموقع",
      hint: "أدخل موقعك",
      icon: Icons.location_on,
      validator: (value) => validator(value!, 'location'),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return BlocBuilder<RegisterCubit, CubitStates>(
      builder: (context, state) {
        final isLoading = state is LoadingState;

        return ElevatedButton(
          onPressed: isLoading ? null : onRegisterPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: isLoading
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
      },
    );
  }
}