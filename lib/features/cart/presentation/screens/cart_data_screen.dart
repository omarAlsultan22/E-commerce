import 'package:flutter/material.dart';
import '../cubits/cart_data_cubit.dart';
import '../states/cart_data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/widgets/states/error_state_widget.dart';
import '../../../../core/presentation/screens/connectivity_aware_screen.dart';
import '../../../../core/presentation/widgets/states/loading_state_widget.dart';
import 'package:international_cuisine/features/cart/presentation/widgets/layouts/cart_data_layout.dart';


class CartDataScreen extends StatefulWidget {
  const CartDataScreen({super.key});

  @override
  State<CartDataScreen> createState() => _CartDataScreenState();
}

class _CartDataScreenState extends State<CartDataScreen> with WidgetsBindingObserver {

  @override
  Widget build(BuildContext context) {
    return ConnectivityAwareService(
        child: BlocBuilder<CartDataCubit, CartDataState>(
            builder: (context, state) {
              final cubit = CartDataCubit.get(context);
              return state.when(
                  onInitial: () =>
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 60,
                            color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'عربة التسوق فارغة',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  onLoading: () => const LoadingStateWidget(),
                  onLoaded: (shoppingList) =>
                      CartDataLayout(shoppingList),
                  onError: (error) =>
                      ErrorStateWidget(
                          error: error.message,
                          onRetry: () => cubit.getCartData())
              );
            }
        )
    );
  }
}