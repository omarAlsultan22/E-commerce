import 'package:flutter/material.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import 'package:international_cuisine/core/constants/app_paddings.dart';
import 'package:international_cuisine/core/presentation/widgets/build_snack_bar.dart';
import 'package:international_cuisine/features/evaluation/presentation/operations/evaluation_operations.dart';


class EvaluationLayout extends StatefulWidget {
  final EvaluationOperations _operations;
  const EvaluationLayout(this._operations, {super.key});

  @override
  State<EvaluationLayout> createState() => _EvaluationLayoutState();
}

class _EvaluationLayoutState extends State<EvaluationLayout> {
  bool _isLoading = false;
  final _textController = TextEditingController();

  Future<void> _onSendPressed() async {
    setState(() => _isLoading = true);

    final result = await widget._operations.sendEvaluation(
        evaluationText: _textController.text
    );

    setState(() => _isLoading = false);

    if (result.isSuccess) {
      buildSnackBar('Sent successfully', AppColors.successGreen);
    }
    else {
      buildSnackBar(result.error!, AppColors.errorRed);
    }
  }

  @override
  Widget build(BuildContext context) {
    const _paddingAll12 = AppPaddings.paddingAll_12;
    return Scaffold(
      body: Image.asset(
        fit: BoxFit.fill,
        height: double.infinity,
        'assets/images/original_logo.png',
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
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                style: TextStyle(backgroundColor: Color(0xFF616161)),
              ),
            ),
            IconButton(onPressed: () {}, icon: _isLoading ? const Padding(
              padding: _paddingAll12,
              child: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
                : GestureDetector(
              onTap: _onSendPressed,
              child: const Padding(
                padding: _paddingAll12,
                child: Icon(Icons.send, color: Colors.blue),
              ),
            )
            )
          ]
      ),
    );
  }
}
