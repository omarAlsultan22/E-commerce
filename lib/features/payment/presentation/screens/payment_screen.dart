import 'package:flutter/material.dart';
import '../../constants/app_strings.dart';
import '../widgets/card_form_widget.dart';
import '../../services/fawry_service.dart';
import '../../services/paymob_service.dart';
import '../widgets/mobile_form_widget.dart';
import '../../constants/api_json_keys.dart';
import '../../constants/app_dimensions.dart';
import '../../constants/paymob_constants.dart';
import '../../constants/payment_constants.dart';
import '../widgets/payment_method_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/payment_text_styles.dart';
import '../../services/payment_storage_service.dart';
import 'package:international_cuisine/core/constants/app_colors.dart';
import 'package:international_cuisine/features/cart/presentation/cubits/cart_data_cubit.dart';
import 'package:international_cuisine/features/invoice/presentation/screens/payment_invoice_screen.dart';


class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Controllers
  late double _totalAmount;
  late TextEditingController _amountController;
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _phoneController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();

  // Payment State
  bool _isLoading = false;
  int _selectedPaymentMethod = PaymentConstants.paymentMethodCard;
  bool _saveCard = false;

  // Services
  final _paymobService = PaymobService();
  final _fawryService = FawryService();
  final _paymentStorage = PaymentStorageService();

  @override
  void initState() {
    super.initState();
    _totalAmount = _calculateTotalAmount();
    _amountController = TextEditingController(text: '${_totalAmount}');
    _loadTestData();
    _loadUserData();
    _loadSavedCard();
  }

  double _calculateTotalAmount() {
    return CartDataCubit
        .get(context)
        .state
        .getShoppingList
        .fold(0, (sum, item) => sum + (item.price * item.item));
  }

  void _loadTestData() {
    _cardNumberController.text = PaymentConstants.testCardNumber;
    _expiryController.text = PaymentConstants.testExpiryDate;
    _cardHolderController.text = PaymentConstants.testCardHolder;
    _cvvController.text = PaymentConstants.testCvv;
    _emailController.text = PaymentConstants.testEmail;
    _phoneController.text = PaymentConstants.testPhone;
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _emailController.text = user.email ?? '';
        _phoneController.text = user.phoneNumber ?? '';
        _cardHolderController.text = user.displayName ?? '';
      });
    }
  }

  Future<void> _loadSavedCard() async {
    try {
      final savedCard = await _paymentStorage.getSavedCard();

      if (savedCard['cardNumber'] != null && savedCard['expiry'] != null) {
        setState(() {
          _cardNumberController.text =
              _paymentStorage.formatCardNumber(savedCard['cardNumber']!);
          _expiryController.text =
              _paymentStorage.formatExpiryDate(savedCard['expiry']!);
          _cardHolderController.text = savedCard['cardHolder'] ?? '';
          _saveCard = true;
        });
      }
    } catch (e) {
      debugPrint('Error loading saved card: $e');
    }
  }

  Future<void> _saveCardDetails() async {
    if (!_saveCard) {
      await _paymentStorage.deleteCardDetails();
      return;
    }

    await _paymentStorage.saveCardDetails(
      cardNumber: _cardNumberController.text,
      expiry: _expiryController.text,
      cardHolder: _cardHolderController.text,
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_selectedPaymentMethod == PaymentConstants.paymentMethodCard) {
        await _payWithPaymobCard();
        await _saveCardDetails();
      } else
      if (_selectedPaymentMethod == PaymentConstants.paymentMethodFawry) {
        await _payWithFawry();
      } else
      if (_selectedPaymentMethod == PaymentConstants.paymentMethodVodafone) {
        await _payWithVodafoneCash();
      }

      _navigateToSuccessScreen();
    } catch (e) {
      _showPaymentResult(false, '${AppStrings.paymentError}: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _payWithPaymobCard() async {
    final authToken = await _paymobService.getAuthToken();
    final orderId = await _paymobService.createOrder(authToken, _totalAmount);

    final billingData = {
      ApiJsonKeys.firstName: _cardHolderController.text
          .split(' ')
          .isNotEmpty
          ? _cardHolderController.text
          .split(' ')
          .first
          : 'User',
      ApiJsonKeys.lastName: _cardHolderController.text
          .split(' ')
          .length > 1
          ? _cardHolderController.text
          .split(' ')
          .last
          : 'Customer',
      ApiJsonKeys.email: _emailController.text,
      ApiJsonKeys.phoneNumber: _phoneController.text,
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
      amount: double.parse(_amountController.text),
      billingData: billingData,
      integrationId: PaymobConstants.cardIntegrationId,
    );
  }

  Future<void> _payWithFawry() async {
    await _fawryService.createFawryPayment(
      phoneNumber: _phoneController.text,
      email: _emailController.text,
      amount: double.parse(_amountController.text),
    );
  }

  Future<void> _payWithVodafoneCash() async {
    final authToken = await _paymobService.getAuthToken();
    final orderId = await _paymobService.createOrder(
      authToken,
      double.parse(_amountController.text),
    );

    final billingData = {
      ApiJsonKeys.firstName: 'User',
      ApiJsonKeys.lastName: 'Mobile',
      ApiJsonKeys.email: _emailController.text,
      ApiJsonKeys.phoneNumber: _phoneController.text,
      ApiJsonKeys.country: PaymentConstants.defaultCountry,
    };

    final paymentToken = await _paymobService.getPaymentKey(
      authToken: authToken,
      orderId: orderId,
      amount: double.parse(_amountController.text),
      billingData: billingData,
      integrationId: PaymobConstants.vodafoneIntegrationId,
    );

    await _paymobService.initiateVodafonePayment(
      phoneNumber: _phoneController.text,
      paymentToken: paymentToken,
    );
  }

  void _navigateToSuccessScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentInvoiceScreen(isPaid: true),
      ),
    );
  }

  void _showPaymentResult(bool success, String message) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text(
                success ? AppStrings.paymentSuccess : AppStrings.paymentFailed),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (success) {
                    Navigator.pop(context);
                  }
                },
                child: const Text(AppStrings.ok),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.paymentScreenTitle),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: AppDimensions.defaultPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppDimensions.verticalSpacing20,
                const Text(
                  AppStrings.totalAmount,
                  style: PaymentTextStyles.titleBold,
                  textAlign: TextAlign.center,
                ),
                AppDimensions.verticalSpacing10,
                Text(
                  '${_totalAmount.toStringAsFixed(2)} جنيهاً',
                  style: PaymentTextStyles.amountStyle,
                  textAlign: TextAlign.center,
                ),
                AppDimensions.verticalSpacing30,

                PaymentMethodSelector(
                  selectedPaymentMethod: _selectedPaymentMethod,
                  onMethodSelected: (method) =>
                      setState(() => _selectedPaymentMethod = method),
                ),

                if (_selectedPaymentMethod ==
                    PaymentConstants.paymentMethodCard)
                  CardFormWidget(
                    cardNumberController: _cardNumberController,
                    expiryController: _expiryController,
                    cvvController: _cvvController,
                    cardHolderController: _cardHolderController,
                    saveCard: _saveCard,
                    onSaveCardChanged: (value) =>
                        setState(() => _saveCard = value),
                  ),

                if (_selectedPaymentMethod !=
                    PaymentConstants.paymentMethodCard)
                  MobileFormWidget(
                    phoneController: _phoneController,
                    emailController: _emailController,
                  ),

                AppDimensions.verticalSpacing30,

                ElevatedButton(
                  onPressed: _isLoading ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    padding: AppDimensions.buttonPadding,
                    backgroundColor: Colors.blue,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: AppColors.white)
                      : Text(
                    _selectedPaymentMethod ==
                        PaymentConstants.paymentMethodFawry
                        ? AppStrings.createFawryInvoice
                        : AppStrings.completePayment,
                    style: PaymentTextStyles.buttonText,
                  ),
                ),

                AppDimensions.verticalSpacing20,

                const Text(
                  AppStrings.securityMessage,
                  style: PaymentTextStyles.securityText,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}