import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:international_cuisine/modules/sgin_in/sgin_in.dart';
import 'package:international_cuisine/shared/components/constant.dart';
import 'package:international_cuisine/shared/cubit/state.dart';
import 'change_email_&_password.dart';
import '../../shared/components/components.dart';
import 'cubit.dart';

class UpdateAccount extends StatefulWidget {
  const UpdateAccount({super.key});

  @override
  State<UpdateAccount> createState() => _UpdateAccountState();
}

class _UpdateAccountState extends State<UpdateAccount> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  bool _isLoading = false;


  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    AppModelCubit.get(context).getInfo(UserDetails.uId);
    return BlocConsumer<AppModelCubit, CubitStates>(
      listener: (context, state) {
        if (state is SuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildSnackBar('تم التحديث بنجاح', Colors.green[800]!),
          );
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignIn()),
            );
          });
        }
        if (state is ErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildSnackBar('فشل التحديث: ${state.error}', Colors.red[800]!),
          );
        }
      },
      builder: (context, state) {
        final cubit = AppModelCubit.get(context);
        if (state is ErrorState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'حدث خطأ: ${state.error}',
                  style: TextStyle(color: Colors.red[400], fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => cubit.getInfo(UserDetails.uId),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        if (state is SuccessState) {
          _firstNameController.text = state.value.firstName;
          _lastNameController.text = state.value.lastName;
          _phoneNumberController.text = state.value.phone;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Colors.grey[900],
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                scrolledUnderElevation: 0,
                elevation: 0,
                title: const Text(
                  'الإعدادات',
                  style: TextStyle(color: Colors.white),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                ),
              ),
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey[900]!,
                      Colors.grey[800]!,
                    ],
                  ),
                ),
                child: _buildFormContent(context, cubit),
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
          ),
        );
      },
    );
  }

  Widget _buildFormContent(BuildContext context, AppModelCubit cubit) {
    return IgnorePointer(
      ignoring: _isLoading,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 32),
              _buildInputField(
                controller: _firstNameController,
                label: "أسم المستخدم",
                hint: "أسم المستخدم",
                icon: Icons.person,
                validator: (value) => _validateInput(value, 'أسم المستخدم'),
              ),
              sizedBox(),
              _buildInputField(
                controller: _lastNameController,
                label: "أسم العائلة",
                hint: "أسم العائلة",
                icon: Icons.person,
                keyboardType: TextInputType.phone,
                validator: (value) => _validateInput(value, 'أسم العائلة'),
              ),
              sizedBox(),
              _buildInputField(
                controller: _phoneNumberController,
                label: "رقم الهاتف",
                hint: "رقم الهاتف",
                icon: Icons.phone,
                validator: (value) => _validateInput(value, 'رقم الهاتف'),
              ),
              const SizedBox(height: 24),
              _buildChangePasswordButton(),
              const SizedBox(height: 16),
              _buildUpdateButton(cubit),
              if (_isLoading) ...[
                const SizedBox(height: 24),
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تحديث الملف الشخصي',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.amber[400],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'قم بتحديث معلوماتك الشخصية',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[500]),
            prefixIcon: Icon(icon, color: Colors.amber[700]),
            filled: true,
            fillColor: Colors.grey[700]!.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 16, horizontal: 16),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildChangePasswordButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: Colors.amber[700]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChangeEmailAndPassword(),
            ),
          );
        },
        child: Text(
          'تغيير البريد وكلمة المرور',
          style: TextStyle(
            fontSize: 18,
            color: Colors.amber[700],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton(AppModelCubit cubit) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber[700],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            setState(() => _isLoading = true);
            cubit.updateInfo(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              phone: _phoneNumberController.text,
            ).whenComplete(() {
              if (mounted) setState(() => _isLoading = false);
            });
          }
        },
        child: const Text(
          'تحديث',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String? _validateInput(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال $fieldName';
    }
    return null;
  }
}

