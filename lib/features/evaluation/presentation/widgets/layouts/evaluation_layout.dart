import 'package:flutter/material.dart';
import 'package:international_cuisine/core/constants/app_assets.dart';
import '../../../../../core/presentation/widgets/loading_widget.dart';
import 'package:international_cuisine/core/constants/app_values.dart';
import 'package:international_cuisine/core/constants/app_paddings.dart';
import '../../../../../core/presentation/utils/helpers/image_helpers.dart';


class EvaluationLayout extends StatefulWidget {
  final void Function(String) onUpdate;
  const EvaluationLayout({
    super.key,
    required this.onUpdate,
  });

  @override
  State<EvaluationLayout> createState() => _EvaluationLayoutState();
}

class _EvaluationLayoutState extends State<EvaluationLayout> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  Future<void> _onSendPressed() async {
    if (_formKey.currentState!.validate()) {
      _hideKeyboard();
      await _performRegistration();
    }
  }

  Future<void> _performRegistration() async {
    widget.onUpdate(
      _textController.text,
    );
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        AppAssets.originalLogo,
        fit: BoxFit.fill,
        height: double.infinity,
        width: double.infinity,
        cacheHeight: ImageHelpers.calculateOptimalCacheHeight(
            context,
            targetHeight: double.infinity,
            qualityFactor: AppValues.qualityFactor
        ),
        cacheWidth: ImageHelpers.calculateOptimalCacheWidth(
            context,
            targetWidth: double.infinity
        ),
      ),
      bottomNavigationBar:
      Row(
          children: [
            Expanded(
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
                style: TextStyle(backgroundColor: Color(0xFF616161)),
              ),
            ),
            IconButton(onPressed: () {}, icon: _isLoading ? const Padding(
              padding: AppPaddings.all_Small,
              child: const LoadingWidget(
                spacing: 20.0,
                strokeWidth: 2.0,
              ),
            )
                : GestureDetector(
              onTap: _onSendPressed,
              child: const Padding(
                padding: AppPaddings.all_Small,
                child: Icon(Icons.send, color: Colors.blue),
              ),
            )
            )
          ]
      ),
    );
  }
}
