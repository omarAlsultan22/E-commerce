import 'app/my_app.dart';
import 'package:flutter/material.dart';
import 'core/config/bloc_observer.dart';
import 'core/constants/app_colors.dart';
import 'core/errors/mappers/error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/initialization_controller.dart';
import 'core/presentation/widgets/build_snack_bar.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  final initializationController = InitializationController();

  try {
    await initializationController.init();
    runApp(const MyApp());
  }
  catch (e, stackTrace) {
    final errorHandler = ErrorHandler(
      error: e,
      stackTrace: stackTrace,
    );
    final exception = errorHandler.handleException();
    runApp(
        MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Builder(
              builder: (context) =>
                  Scaffold(
                    body: exception.buildErrorWidget(
                      appBar: null,
                      onRetry: () async {
                        try {
                          await initializationController.retryInit();
                          runApp(const MyApp());
                        } catch (e) {
                          BuildSnackBar.show(
                              message: 'Initialization failed',
                              context: context,
                              backgroundColor: AppColors.errorRed
                          );
                        }
                      },
                    ),
                  ),
            )
        )
    );
  }
}

