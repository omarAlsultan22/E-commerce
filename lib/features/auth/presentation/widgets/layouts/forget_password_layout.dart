import 'package:international_cuisine/features/auth/constants/auth_label_texts_constants.dart';
import 'package:international_cuisine/core/presentation/widgets/back_button_widget.dart';
import 'package:international_cuisine/features/auth/presentation/mixins/auth_mixin.dart';
import '../../../../../core/data/models/message_result.dart';
import '../../../../../core/constants/app_colors.dart';
import 'package:flutter/material.dart';


class ForgetPasswordLayout extends StatefulWidget {
  final void Function({
  required String userEmail,
  }) onUpdate;
  final MessageResult messageResult;
  const ForgetPasswordLayout({
    super.key,
    required this.onUpdate,
    required this.messageResult
  });

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgetPasswordLayout> with AuthMixin<ForgetPasswordLayout> {
  bool _isPressed = true;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ForgetPasswordLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    handleMessageResultAndNavigate(
        messageResult: widget.messageResult,
        onNavigate: () => Navigator.pop(context));
  }

  void _updateLockButton(bool value) {
    setState(() => _isPressed = value);
  }

  Future<void> _sendResetEmail() async {
    if (validator(_formKey)) {
      _updateLockButton(false);
      hideKeyboard(context);
      final email = _emailController.text.trim();
      widget.onUpdate(userEmail: email);
      _updateLockButton(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGrey,
      appBar: AppBar(
        title: const Text('نسيت كلمة المرور'),
        backgroundColor: AppColors.transparent,
        leading: BackButtonWidget(
            onPressed: widget.messageResult.isLoading ? null : () =>
                Navigator.pop(context)),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: AuthLabelTextsConstants.email,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                style: buttonStyle(),
                onPressed: _isPressed
                    ? _sendResetEmail
                    : null,
                child: buildButtonContent(
                    text: 'إرسال رابط إعادة التعيين',
                    isLoading: widget.messageResult.isLoading
                )
            ),
          ],
        ),
      ),
    );
  }
}