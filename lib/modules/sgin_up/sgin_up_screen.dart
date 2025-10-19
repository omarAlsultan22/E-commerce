import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:international_cuisine/modules/sgin_in/sgin_in_screen.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:quickalert/models/quickalert_type.dart';
import '../../layout/sign_up_layout.dart';
import '../../shared/cubit/state.dart';
import 'cubit.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();

  bool _isObscure = true;

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

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<RegisterCubit>();
    cubit.userRegister(
      email: _emailController.text,
      password: _passwordController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phone: _phoneController.text,
      location: _locationController.text,
    );
  }

  void _navigateToSignIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  void _showSuccessDialog() {
    QuickAlert.show(
      context: context,
      text: 'تم إنشاء الحساب بنجاح',
      type: QuickAlertType.success,
      onConfirmBtnTap: _navigateToSignIn,
    );
  }

  void _showErrorDialog(String errorMessage) {
    QuickAlert.show(
      context: context,
      text: errorMessage,
      type: QuickAlertType.error,
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocListener<RegisterCubit, CubitStates>(
        listener: (context, state) {
          if (state is SuccessState) {
            _showSuccessDialog();
          } else if (state is ErrorState) {
            _showErrorDialog(state.error!);
          }
        },
        child: SignUpLayout(
          formKey: _formKey,
          firstNameController: _firstNameController,
          lastNameController: _lastNameController,
          emailController: _emailController,
          passwordController: _passwordController,
          phoneController: _phoneController,
          locationController: _locationController,
          isObscure: _isObscure,
          onRegisterPressed: _handleRegister,
          onTogglePasswordVisibility: _togglePasswordVisibility,
          onBackPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}