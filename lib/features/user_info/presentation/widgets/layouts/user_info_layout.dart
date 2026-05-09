import 'package:international_cuisine/core/presentation/utils/validate/validator_input.dart';
import 'package:international_cuisine/core/presentation/widgets/icon_button_widget.dart';
import 'package:international_cuisine/core/presentation/widgets/build_input_field.dart';
import '../../../../auth/presentation/screens/change_email_&_password_screen.dart';
import '../../../../../core/presentation/widgets/navigation/navigator.dart';
import 'package:international_cuisine/core/constants/app_label_texts.dart';
import 'package:international_cuisine/core/constants/app_paddings.dart';
import '../../../../../core/presentation/widgets/build_snack_bar.dart';
import 'package:international_cuisine/core/constants/app_borders.dart';
import 'package:international_cuisine/core/constants/app_values.dart';
import 'package:international_cuisine/core/constants/app_spaces.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import '../../../../../core/presentation/widgets/loading_widget.dart';
import 'package:international_cuisine/core/constants/app_sizes.dart';
import '../../../../../core/data/models/message_result.dart';
import '../../../../../core/data/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/user_info_cubit.dart';
import 'package:flutter/material.dart';


class UserInfoLayout extends StatefulWidget {
  final UserModel userModel;
  final MessageResult messageResult;
  final void Function(UserModel) onUpdate;

  const UserInfoLayout({
    required this.onUpdate,
    required this.userModel,
    required this.messageResult,
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

  late UserInfoCubit _cubit;

  static final _borderRadius = AppBorders.borderRadius_12;

  //spaces
  static const _verticalSpacing8 = AppSpaces.verticalSpacing_8;
  static const _verticalSpacing16 = AppSpaces.verticalSpacing_16;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<UserInfoCubit>();
    _initializeControllers(
        firstName: widget.userModel.firstName,
        lastName: widget.userModel.lastName,
        userPhone: widget.userModel.userPhone,
        userLocation: widget.userModel.userLocation
    );
  }

  @override
  void didUpdateWidget(covariant UserInfoLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messageResult.message != null) {
      _showMessageResult(widget.messageResult);
    }
    setState(() {});
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

  void _showMessageResult(MessageResult messageResult) {
    ScaffoldMessenger.of(context).showSnackBar(
        BuildSnackBar.build(messageResult.message!, messageResult.color!)
    );
    navigator(context: context);
  }

  AppBar _buildAppBar() {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: AppValues.none,
        title: const Text(
          'الإعدادات',
          style: TextStyle(color: AppColors.white),
        ),
        leading: const IconButtonWidget()
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
      ignoring: widget.messageResult.isLoading,
      child: SingleChildScrollView(
        padding: AppPaddings.all_large,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              AppSpaces.verticalSpacing_32,
              _buildFirstNameField(),
              _verticalSpacing16,
              _buildSecondNameField(),
              _verticalSpacing16,
              _buildPhoneField(),
              _verticalSpacing16,
              _buildLocationField(),
              AppSpaces.verticalSpacing_24,
              _buildChangePasswordButton(),
              _verticalSpacing16,
              _buildUpdateButton(cubit),
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
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: AppColors.lightAmber,
          ),
        ),
        _verticalSpacing8,
        const Text(
          'قم بتحديث معلوماتك الشخصية',
          style: TextStyle(
            fontSize: AppSizes.fontSize16,
            color: AppColors.lightGrey400,
          ),
        ),
      ],
    );
  }

  Widget _buildFirstNameField() {
    return _buildCustomInputField(
      controller: _firstNameController,
      label: AppLabelTexts.firstName,
      hint: AppLabelTexts.firstName,
      icon: Icons.person,
      validator: (value) => ValidateInput.validator(value, AppLabelTexts.firstName),
    );
  }

  Widget _buildSecondNameField() {
    return _buildCustomInputField(
      controller: _lastNameController,
      label: AppLabelTexts.lastName,
      hint: AppLabelTexts.lastName,
      icon: Icons.person,
      validator: (value) => ValidateInput.validator(value, AppLabelTexts.lastName),
    );
  }

  Widget _buildPhoneField() {
    return _buildCustomInputField(
      controller: _phoneController,
      label: AppLabelTexts.phoneNumber,
      hint: AppLabelTexts.phoneNumber,
      icon: Icons.phone,
      keyboardType: TextInputType.phone,
      validator: (value) => ValidateInput.validator(value, AppLabelTexts.phoneNumber),
    );
  }

  Widget _buildLocationField() {
    return _buildCustomInputField(
      controller: _locationController,
      label: AppLabelTexts.location,
      hint: AppLabelTexts.location,
      icon: Icons.location_on,
      validator: (value) => ValidateInput.validator(value, AppLabelTexts.location),
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
            fontSize: AppSizes.fontSize16,
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
            fontSize: AppSizes.fontSize18,
            color: AppColors.primaryAmber,
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
          onPressed: () {
            widget.onUpdate(
                UserModel(
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  userPhone: _phoneController.text,
                  userLocation: _locationController.text,
                )
            );
            setState(() {});
          },
          child: _buildUpdateButtonContent()
      ),
    );
  }

  Widget _buildUpdateButtonContent() {
    return widget.messageResult.isLoading
        ? const LoadingWidget()
        : const Text(
      'تحديث',
      style: TextStyle(
        fontSize: AppSizes.fontSize18,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
    );
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
      padding: EdgeInsets.symmetric(
          vertical: 16.0),
      side: BorderSide(color: AppColors.primaryAmber),
      shape: RoundedRectangleBorder(
        borderRadius: _borderRadius,
      ),
    );
  }

  ButtonStyle _updateButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryAmber,
      padding: EdgeInsets.symmetric(
          vertical: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: _borderRadius,
      ),
      elevation: 4.0,
    );
  }
}