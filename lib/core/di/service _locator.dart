import 'core/di_core.dart';
import 'domains/di_home.dart';
import 'domains/di_cart.dart';
import 'domains/di_auth.dart';
import 'domains/di_cuisine.dart';
import 'package:get_it/get_it.dart';
import 'package:international_cuisine/core/di/domains/di_invoice.dart';
import 'package:international_cuisine/core/di/domains/di_user_Info.dart';
import 'package:international_cuisine/core/di/domains/di_evaluation.dart';


final sl = GetIt.instance;

void setupServiceLocator() {
  // ============ Core ============
  CoreDependencies.register();

  // ============ Domains ============
  AuthDependencies.register();
  HomeDependencies.register();
  CartDependencies.register();
  CuisineDependencies.register();
  InvoiceDependencies.register();
  UserInfoDependencies.register();
  EvaluationDependencies.register();
}