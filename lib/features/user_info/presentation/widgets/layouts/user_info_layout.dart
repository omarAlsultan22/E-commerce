import 'package:international_cuisine/core/presentation/utils/validate/validator_input.dart';
import 'package:international_cuisine/core/presentation/widgets/build_input_field.dart';
import '../../../../auth/presentation/screens/change_email_&_password_screen.dart';
import 'package:international_cuisine/core/presentation/widgets/app_spacing.dart';
import '../../../../../core/presentation/widgets/navigation/navigator.dart';
import 'package:international_cuisine/core/constants/app_label_texts.dart';
import '../../../../../core/presentation/widgets/build_snack_bar.dart';
import 'package:international_cuisine/core/constants/app_borders.dart';
import 'package:international_cuisine/core/constants/app_numbers.dart';
import 'package:international_cuisine/core/constants/app_states.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import '../../../../../core/data/models/message_result_model.dart';
import '../../cubits/user_info_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';


class UserInfoLayout extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String userPhone;
  final String userLocation;

  const UserInfoLayout({
    required this.firstName,
    required this.lastName,
    required this.userPhone,
    required this.userLocation,
    Key? key}) : super(key: key);

  @override
  State<UserInfoLayout> createState() => _UserInfoLayoutState();
}

class _UserInfoLayoutState extends State<UserInfoLayout> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();

  bool _isLoading = false;
  late UserInfoCubit _cubit;

  //sizes
  static const _verticalSpacing8 = AppSpacing.height_8;
  static const _verticalSpacing16 = AppSpacing.height_16;
  static const _verticalSpacing24 = AppSpacing.height24;

  //labels
  static const _firstName = AppLabelTexts.firstName;
  static const _lastName = AppLabelTexts.lastName;
  static const _phoneNumber = AppLabelTexts.phoneNumber;
  static const _location = AppLabelTexts.location;

  //colors
  static const _white = AppColors.white;
  static const _primaryAmber = AppColors.primaryAmber;

  //paddings
  static const _paddingSymmetric = EdgeInsets.symmetric(vertical: 16);

  //borders
  static final _borderRadius = AppBorders.borderRadius_12;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<UserInfoCubit>();
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
        backgroundColor: AppColors.primaryBrown,
        appBar: _buildAppBar(),
        body: _buildBody(context, _cubit),
      ),
    );
  }


  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: AppNumbers.zero,
      title: const Text(
        'الإعدادات',
        style: TextStyle(color: _white),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: _white,
        onPressed: _isLoading ? null : () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context, UserInfoCubit cubit) {
    return Container(
      decoration: _buildBackgroundDecoration(),
      child: _buildFormContent(context, cubit),
    );
  }

  Widget _buildFormContent(BuildContext context, UserInfoCubit cubit) {
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
              AppSpacing.height_32,
              _buildFirstNameField(),
              _verticalSpacing16,
              _buildSecondNameField(),
              _verticalSpacing16,
              _buildPhoneField(),
              _verticalSpacing16,
              _buildLocationField(),
              AppSpacing.height24,
              _buildChangePasswordButton(),
              _verticalSpacing16,
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
        const Text(
          'تحديث الملف الشخصي',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.lightAmber,
          ),
        ),
        _verticalSpacing8,
        const Text(
          'قم بتحديث معلوماتك الشخصية',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.lightGrey400,
          ),
        ),
      ],
    );
  }

  Widget _buildFirstNameField() {
    return _buildCustomInputField(
      controller: _firstNameController,
      label: _firstName,
      hint: AppLabelTexts.firstName,
      icon: Icons.person,
      validator: (value) => ValidateInput.validator(value, _firstName),
    );
  }

  Widget _buildSecondNameField() {
    return _buildCustomInputField(
      controller: _lastNameController,
      label: _lastName,
      hint: AppLabelTexts.lastName,
      icon: Icons.person,
      validator: (value) => ValidateInput.validator(value, _lastName),
    );
  }

  Widget _buildPhoneField() {
    return _buildCustomInputField(
      controller: _phoneController,
      label: _phoneNumber,
      hint: AppLabelTexts.phoneNumber,
      icon: Icons.phone,
      keyboardType: TextInputType.phone,
      validator: (value) => ValidateInput.validator(value, _phoneNumber),
    );
  }

  Widget _buildLocationField() {
    return _buildCustomInputField(
      controller: _locationController,
      label: _location,
      hint: AppLabelTexts.location,
      icon: Icons.location_on,
      validator: (value) => ValidateInput.validator(value, _location),
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
          style: const TextStyle(
            color: AppColors.lightGrey300,
            fontSize: 16,
          ),
        ),
        _verticalSpacing8,
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
        child: const Text(
          'تغيير البريد وكلمة المرور',
          style: TextStyle(
            fontSize: 18,
            color: _primaryAmber,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton(UserInfoCubit cubit) {
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
            color: _white,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Column(
      children: [
        _verticalSpacing24,
        Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(_primaryAmber),
          ),
        ),
      ],
    );
  }

  Future<void> _onUpdatePressed(UserInfoCubit cubit) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final message = await cubit.updateInfo(
        firstName: _firstNameController.text.trim(),
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
          buildSnackBar(AppStates.success, AppColors.successGreen)
      );
      navigator(context: context);
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          buildSnackBar(' ${AppStates.failed} ${message.error}',
              AppColors.errorRed)
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


  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const[
          AppColors.darkGrey,
          AppColors.mediumGrey,
        ],
      ),
    );
  }

  ButtonStyle _changePasswordButtonStyle() {
    return OutlinedButton.styleFrom(
      padding: _paddingSymmetric,
      side: BorderSide(color: _primaryAmber),
      shape: RoundedRectangleBorder(
        borderRadius: _borderRadius,
      ),
    );
  }

  ButtonStyle _updateButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: _primaryAmber,
      padding: _paddingSymmetric,
      shape: RoundedRectangleBorder(
        borderRadius: _borderRadius,
      ),
      elevation: 4,
    );
  }
}