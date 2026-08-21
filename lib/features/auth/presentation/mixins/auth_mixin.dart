import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_paddings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/navigation/navigator_with_delay.dart';
import '../../../../core/data/models/message_result.dart';
import '../../../../core/presentation/widgets/loading_widget.dart';
import '../../../../core/presentation/widgets/build_snack_bar.dart';


mixin AuthMixin<T extends StatefulWidget> on State<T> {

  void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  bool validator(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  void handleMessageResultAndNavigate({
    required MessageResult messageResult,
    required VoidCallback onNavigate,
    VoidCallback? onClear,
  }) {
    handleMessageResult(messageResult: messageResult);
    if (messageResult.error == null) {
      onClear?.call();
      onNavigate();
    }
  }

  void handleMessageResult({
    required MessageResult messageResult,
  }) {
    if (messageResult.message != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showMessageResult(
            context: context,
            color: messageResult.color!,
            message: messageResult.message!
        );
      });
      setState(() {});
    }
  }

  void showMessageResult({
    required BuildContext context,
    required String message,
    required Color color,
  }) {
    BuildSnackBar.show(
        context: context,
        message: message,
        backgroundColor: color
    );
  }

  Widget buildPasswordVisibilityToggle({
    required bool isObscure,
    required VoidCallback onToggle,
    Color iconColor = AppColors.primaryAmber,
  }) {
    return IconButton(
      icon: Icon(
        isObscure ? Icons.visibility_off : Icons.visibility,
        color: iconColor,
      ),
      onPressed: onToggle,
    );
  }

  void navigateToScreen(Widget link) {
    NavigatorWithDelay.build(link: link, context: context);
  }

  Widget buildButtonContent({
    required bool isLoading,
    required String text,
    bool isSaveButton = false,
  }) {
    if (isLoading) {
      return isSaveButton
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          color: AppColors.white,
        ),
      )
          : LoadingWidget();
    }

    return Text(
      text,
      style: AppTextStyles.textStyle16,
    );
  }

  ButtonStyle buttonStyle({EdgeInsetsGeometry? padding}) {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryAmber,
      foregroundColor: AppColors.black,
      padding: padding ?? AppPaddings.verticalSymmetric,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 2.0,
      minimumSize: const Size(double.infinity, 50.0),
    );
  }
}