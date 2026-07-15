// lib/features/payment/presentation/providers/payment_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:international_cuisine/features/cart/presentation/cubits/cart_data_cubit.dart';
import '../../../../core/presentation/widgets/navigation/navigator_with_delay.dart';
import '../../../invoice/presentation/screens/payment_invoice_screen.dart';
import '../../constants/payment_strings.dart';
import '../../services/paymob_service.dart';
import '../../services/fawry_service.dart';
import '../../services/payment_storage_service.dart';
import '../../constants/payment_constants.dart';
import '../../constants/api_json_keys.dart';
import '../../constants/paymob_constants.dart';
import '../../../../core/constants/app_strings.dart';

class PaymentProvider extends ChangeNotifier {
  // Services
  final PaymobService _paymobService = PaymobService();
  final FawryService _fawryService = FawryService();
  final PaymentStorageService _paymentStorage = PaymentStorageService();

  // Controllers (مكشوفة للـ UI)
  final TextEditingController amountController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // State
  bool _isLoading = false;
  int _selectedPaymentMethod = PaymentConstants.paymentMethodCard;
  bool _saveCard = false;
  double _totalAmount = 0.0;

  // Getters
  bool get isLoading => _isLoading;
  int get selectedPaymentMethod => _selectedPaymentMethod;
  bool get saveCard => _saveCard;
  double get totalAmount => _totalAmount;

  // Setters مع notifyListeners
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set selectedPaymentMethod(int value) {
    _selectedPaymentMethod = value;
    notifyListeners();
  }

  set saveCard(bool value) {
    _saveCard = value;
    notifyListeners();
  }

  set totalAmount(double value) {
    _totalAmount = value;
    notifyListeners();
  }

  // ===================== دوال التهيئة =====================

  Future<void> initializePayment(BuildContext context) async {
    totalAmount = _calculateTotalAmount(context);
    amountController.text = totalAmount.toString();
    _loadTestData();
    await _loadUserData();
    await _loadSavedCard();
  }

  double _calculateTotalAmount(BuildContext context) {
    return CartDataCubit
        .get(context)
        .state
        .shoppingList
        .fold(0, (sum, item) => sum + (item.price * item.item));
  }

  void _loadTestData() {
    cardNumberController.text = PaymentConstants.testCardNumber;
    expiryController.text = PaymentConstants.testExpiryDate;
    cardHolderController.text = PaymentConstants.testCardHolder;
    cvvController.text = PaymentConstants.testCvv;
    emailController.text = PaymentConstants.testEmail;
    phoneController.text = PaymentConstants.testPhone;
  }

  Future<void> _loadUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        emailController.text = user.email ?? '';
        phoneController.text = user.phoneNumber ?? '';
        cardHolderController.text = user.displayName ?? '';
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  Future<void> _loadSavedCard() async {
    try {
      final savedCard = await _paymentStorage.getSavedCard();

      if (savedCard['cardNumber'] != null && savedCard['expiry'] != null) {
        cardNumberController.text =
            _paymentStorage.formatCardNumber(savedCard['cardNumber']!);
        expiryController.text =
            _paymentStorage.formatExpiryDate(savedCard['expiry']!);
        cardHolderController.text = savedCard['cardHolder'] ?? '';
        _saveCard = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading saved card: $e');
    }
  }

  // ===================== دوال الدفع =====================

  Future<void> processPayment(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    isLoading = true;

    try {
      if (_selectedPaymentMethod == PaymentConstants.paymentMethodCard) {
        await _payWithPaymobCard();
        await _saveCardDetails();
      } else if (_selectedPaymentMethod == PaymentConstants.paymentMethodFawry) {
        await _payWithFawry();
      } else if (_selectedPaymentMethod == PaymentConstants.paymentMethodVodafone) {
        await _payWithVodafoneCash();
      }

      // إظهار نجاح الدفع
      _showPaymentResult(context, true, AppStrings.payed);

      // التنقل إلى شاشة النجاح
      _navigateToSuccessScreen(context);

    } catch (e) {
      _showPaymentResult(
          context,
          false,
          '${PaymentStrings.paymentError}: ${e.toString()}'
      );
    } finally {
      isLoading = false;
    }
  }

  Future<void> _payWithPaymobCard() async {
    final authToken = await _paymobService.getAuthToken();
    final orderId = await _paymobService.createOrder(authToken, _totalAmount);

    final billingData = {
      ApiJsonKeys.firstName: cardHolderController.text
          .split(' ')
          .isNotEmpty
          ? cardHolderController.text.split(' ').first
          : 'User',
      ApiJsonKeys.lastName: cardHolderController.text
          .split(' ')
          .length > 1
          ? cardHolderController.text.split(' ').last
          : 'Customer',
      ApiJsonKeys.email: emailController.text,
      ApiJsonKeys.phoneNumber: phoneController.text,
      ApiJsonKeys.country: PaymentConstants.defaultCountry,
      ApiJsonKeys.street: 'NA',
      ApiJsonKeys.building: 'NA',
      ApiJsonKeys.floor: 'NA',
      ApiJsonKeys.apartment: 'NA',
      ApiJsonKeys.city: PaymentConstants.defaultCity,
    };

    await _paymobService.getPaymentKey(
      authToken: authToken,
      orderId: orderId,
      amount: double.parse(amountController.text),
      billingData: billingData,
      integrationId: PaymobConstants.cardIntegrationId,
    );
  }

  Future<void> _payWithFawry() async {
    await _fawryService.createFawryPayment(
      phoneNumber: phoneController.text,
      email: emailController.text,
      amount: double.parse(amountController.text),
    );
  }

  Future<void> _payWithVodafoneCash() async {
    final authToken = await _paymobService.getAuthToken();
    final orderId = await _paymobService.createOrder(
      authToken,
      double.parse(amountController.text),
    );

    final billingData = {
      ApiJsonKeys.firstName: 'User',
      ApiJsonKeys.lastName: 'Mobile',
      ApiJsonKeys.email: emailController.text,
      ApiJsonKeys.phoneNumber: phoneController.text,
      ApiJsonKeys.country: PaymentConstants.defaultCountry,
    };

    final paymentToken = await _paymobService.getPaymentKey(
      authToken: authToken,
      orderId: orderId,
      amount: double.parse(amountController.text),
      billingData: billingData,
      integrationId: PaymobConstants.vodafoneIntegrationId,
    );

    await _paymobService.initiateVodafonePayment(
      phoneNumber: phoneController.text,
      paymentToken: paymentToken,
    );
  }

  // ===================== دوال مساعدة =====================

  Future<void> _saveCardDetails() async {
    if (!_saveCard) {
      await _paymentStorage.deleteCardDetails();
      return;
    }

    await _paymentStorage.saveCardDetails(
      cardNumber: cardNumberController.text,
      expiry: expiryController.text,
      cardHolder: cardHolderController.text,
    );
  }

  void _showPaymentResult(BuildContext context, bool success, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          success ? PaymentStrings.paymentSuccess : PaymentStrings.paymentFailed,
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(PaymentStrings.ok),
          ),
        ],
      ),
    );
  }

  void _navigateToSuccessScreen(BuildContext context) {
    BuildNavigatorWithDelay.build(
        context: context,
        link: PaymentInvoiceScreen(isPaid: true)
    );
  }

  // ===================== التخلص من الموارد =====================

  @override
  void dispose() {
    amountController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    cardHolderController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }
}