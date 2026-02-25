import 'package:international_cuisine/core/presentation/widgets/build_input_field.dart';
import '../../../../auth/presentation/screens/change_email_&_password_screen.dart';
import '../../../../../core/presentation/widgets/navigation/navigator.dart';
import '../../../../../core/presentation/widgets/build_snack_bar.dart';
import '../../../../../core/data/models/message_result_model.dart';
import '../../../../../core/presentation/widgets/sized_box.dart';
import '../../cubits/update_user_Info_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';


class UpdateAccountLayout extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String userPhone;
  final String userLocation;

  const UpdateAccountLayout({
    required this.firstName,
    required this.lastName,
    required this.userPhone,
    required this.userLocation,
    Key? key}) : super(key: key);

  @override
  State<UpdateAccountLayout> createState() => _UpdateAccountLayoutState();
}

class _UpdateAccountLayoutState extends State<UpdateAccountLayout> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();

  bool _isLoading = false;
  late UpdateUserInfoCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<UpdateUserInfoCubit>();
    _initializeControllers(
        firstName: widget.firstName,
        lastName: widget.lastName,
        userPhone: widget.userPhone,
        userLocation: widget.userLocation
    );
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _initializeControllers({
    required String? firstName,
    required String? lastName,
    required String? userPhone,
    required String? userLocation,
  }) {
    _firstNameController.text = firstName ?? '';
    _lastNameController.text = lastName ?? '';
    _phoneController.text = userPhone ?? '';
    _locationController.text = userLocation ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.brown[900],
        appBar: _buildAppBar(),
        body: _buildBody(context, cubit),
      ),
    );
  }


  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
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
    );
  }

  Widget _buildBody(BuildContext context, UpdateUserInfoCubit cubit) {
    return Container(
      decoration: _buildBackgroundDecoration(),
      child: _buildFormContent(context, cubit),
    );
  }

  Widget _buildFormContent(BuildContext context, UpdateUserInfoCubit cubit) {
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
              _buildNameField(),
              sizedBox(),
              _buildPhoneField(),
              sizedBox(),
              _buildLocationField(),
              const SizedBox(height: 24),
              _buildChangePasswordButton(),
              const SizedBox(height: 16),
              _buildUpdateButton(cubit),
              if (_isLoading) _buildLoadingIndicator(),
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

  Widget _buildNameField() {
    return _buildCustomInputField(
      controller: _lastNameController,
      label: "الاسم",
      hint: "أدخل اسمك",
      icon: Icons.person,
      validator: (value) => _validateInput(value, 'الاسم'),
    );
  }

  Widget _buildPhoneField() {
    return _buildCustomInputField(
      controller: _phoneController,
      label: "الهاتف",
      hint: "أدخل رقم هاتفك",
      icon: Icons.phone,
      keyboardType: TextInputType.phone,
      validator: (value) => _validateInput(value, 'الهاتف'),
    );
  }

  Widget _buildLocationField() {
    return _buildCustomInputField(
      controller: _locationController,
      label: "العنوان",
      hint: "أدخل عنوانك",
      icon: Icons.location_on,
      validator: (value) => _validateInput(value, 'العنوان'),
    );
  }

  Widget _buildCustomInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    required String? Function(dynamic) validator,
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
        BuildInputField(
          controller: controller,
          hintText: hint,
          prefixIcon: icon,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildChangePasswordButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: _changePasswordButtonStyle(),
        onPressed: _navigateToChangePassword,
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

  Widget _buildUpdateButton(UpdateUserInfoCubit cubit) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: _updateButtonStyle(),
        onPressed: () => _onUpdatePressed(cubit),
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

  Widget _buildLoadingIndicator() {
    return const Column(
      children: [
        SizedBox(height: 24),
        Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
          ),
        ),
      ],
    );
  }

  Future<void> _onUpdatePressed(UpdateUserInfoCubit cubit) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final message = await cubit.updateInfo(
        firstName: _lastNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        userPhone: _phoneController.text.trim(),
        userLocation: _locationController.text.trim(),
      );
      setState(() => _isLoading = false);
      _showMessageResult(message);
    }
  }

  void _showMessageResult(MessageResultModel message) {
    if (message.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
          buildSnackBar('تم التحديث بنجاح', Colors.green[800]!)
      );
      navigator(context: context);
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          buildSnackBar('فشل التحديث: ${message.error}', Colors.red[800]!)
      );
    }
  }

  void _navigateToChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangeEmailAndPasswordScreen(),
      ),
    );
  }

  String? _validateInput(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال $fieldName';
    }
    return null;
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

  ButtonStyle _changePasswordButtonStyle() {
    return OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      side: BorderSide(color: Colors.amber[700]!),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  ButtonStyle _updateButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.amber[700],
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
    );
  }
}