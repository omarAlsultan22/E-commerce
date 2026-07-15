import 'package:flutter/material.dart';
import 'package:international_cuisine/core/presentation/widgets/back_button_widget.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../../core/constants/app_paddings.dart';
import '../../../../../core/data/models/message_result.dart';
import '../../../../../core/presentation/widgets/loading_widget.dart';
import '../../../../../core/presentation/widgets/build_snack_bar.dart';
import '../../../../../core/presentation/utils/helpers/image_helpers.dart';


class EvaluationLayout extends StatefulWidget {
  final void Function(String) onUpdate;
  final MessageResult messageResult;
  const EvaluationLayout({
    super.key,
    required this.onUpdate,
    required this.messageResult
  });

  @override
  State<EvaluationLayout> createState() => _EvaluationLayoutState();
}

class _EvaluationLayoutState extends State<EvaluationLayout> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  @override
  void didUpdateWidget(covariant EvaluationLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messageResult.message != null) {
      _showMessageResult(widget.messageResult);
    }
    setState(() {});
  }

  void _showMessageResult(MessageResult messageResult) {
    BuildSnackBar.show(
        context: context,
        message: messageResult.message!,
        backgroundColor: messageResult.color!
    );
  }

  Future<void> _onSendPressed() async {
    if (_formKey.currentState!.validate()) {
      _hideKeyboard();
      await _performRegistration();
    }
  }

  Future<void> _performRegistration() async {
    widget.onUpdate(_textController.text);
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      appBar: AppBar(
          leading: BackButtonWidget(
              onPressed: widget.messageResult.isLoading ? null : () =>
                  Navigator.pop(context)
          )
      ),
      body: Stack(
        children: [
          // صورة الخلفية
          Image.asset(
            AppAssets.originalLogo,
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
            cacheHeight: ImageHelpers.calculateOptimalCacheHeight(
              context,
              targetHeight: screenSize.height,
              qualityFactor: AppValues.qualityFactor,
            ),
            cacheWidth: ImageHelpers.calculateOptimalCacheWidth(
              context,
              targetWidth: screenSize.width,
            ),
          ),

          // حقل الإدخال في الأسفل
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالة...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0),
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: widget.messageResult.isLoading
                      ? null
                      : _onSendPressed,
                  icon: widget.messageResult.isLoading
                      ? Padding(
                    padding: AppPaddings.all_Small,
                    child: LoadingWidget(
                      spacing: 20.0,
                      strokeWidth: 2.0,
                    ),
                  )
                      : Padding(
                    padding: AppPaddings.all_Small,
                    child: CircleAvatar(
                        backgroundColor: Colors.blue, child: Icon(Icons.send)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}