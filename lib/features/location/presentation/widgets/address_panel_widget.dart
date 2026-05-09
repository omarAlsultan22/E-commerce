import 'package:international_cuisine/core/constants/app_colors.dart';
import '../../../../../core/constants/app_paddings.dart';
import '../../../../../core/constants/app_spaces.dart';
import '../../../../../core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'action_button_widget.dart';


class AddressPanelWidget extends StatelessWidget {
  final bool isLoading;
  final String address;
  final VoidCallback onRefresh;
  final VoidCallback onSave;
  final bool isSaveEnabled;

  const AddressPanelWidget({
    super.key,
    required this.isLoading,
    required this.address,
    required this.onRefresh,
    required this.onSave,
    required this.isSaveEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.all_medium,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: const Offset(0.0, 5.0),
          )
        ],
      ),
      child: Column(
        children: [
          if (isLoading) const LinearProgressIndicator(),
          AppSpaces.verticalSpacing_12,
          const Text(
            "العنوان المحدد:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppSizes.fontSize16,
            ),
          ),
          AppSpaces.verticalSpacing_8,
          Text(
            address,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: AppSizes.fontSize16),
          ),
          AppSpaces.verticalSpacing_16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ActionButtonWidget(
                icon: Icons.refresh,
                label: "تحديث",
                onPressed: onRefresh,
              ),
              ActionButtonWidget(
                icon: Icons.save,
                label: "حفظ",
                onPressed: isSaveEnabled ? onSave : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}