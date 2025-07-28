import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:international_cuisine/layout/delivery_layout.dart';
import 'dart:convert';
import '../../shared/cubit/cubit.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Controllers
  late double totalAmount;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _phoneController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();

  // Payment State
  bool _isLoading = false;
  int _selectedPaymentMethod = 0; // 0=Card, 1=Fawry, 2=Vodafone Cash
  String? _fawryRefNumber;
  bool _saveCard = false;
  final _secureStorage = const FlutterSecureStorage();


  //رابط الدفع https://paymob.xyz/SmeU4AVK/

  // Paymob Configuration
  final String _paymobApiKey = 'ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2T1Rrd01qZ3lMQ0p1WVcxbElqb2lNVGMwTlRFd01qSXpNQzQ1T1RNNE5EVWlmUS53M2M2N1h0aWVOOExLSjc4YmlyWmZNRE5CRVFsdUIxU21jOXJZUXZuZ0pCV3FLTURvRnIxaGJ5LVBQZzQwa2RUVWhSaU1USG5kbG5kOExDYV9IeFg2QQ==';
  final String _cardIntegrationId = '4629565';
  final String _vodafoneIntegrationId = '4629565';
  String _paymentToken = '';

  @override
  void initState() {
    super.initState();
    totalPrice();
    _amountController = TextEditingController(text: '${totalAmount}');
    _cardNumberController.text = '4242424242424242';
    _expiryController.text = '12/30';
    _cardHolderController.text = 'payment test';
    _cvvController.text = '123';
    _emailController.text = 'test+paymob@example.com';
    _phoneController.text = '01126487652';
    _loadUserData();
    _loadSavedCard();
  }


  void totalPrice() {
    totalAmount = CartCubit.get(context).shoppingList
        .fold(0, (sum, item) => sum + (item.price * item.item));
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
      final cardNumber = await _secureStorage.read(key: 'cardNumber');
      final expiry = await _secureStorage.read(key: 'cardExpiry');
      final cardHolder = await _secureStorage.read(key: 'cardHolder');

      if (cardNumber != null && expiry != null) {
        setState(() {
          _cardNumberController.text = _formatCardNumber(cardNumber);
          _expiryController.text = _formatExpiryDate(expiry);
          _cardHolderController.text = cardHolder ?? '';
          _saveCard = true;
        });
      }
    } catch (e) {
      debugPrint('Error loading saved card: $e');
    }
  }

  String _formatCardNumber(String number) {
    var buffer = StringBuffer();
    for (int i = 0; i < number.length; i++) {
      buffer.write(number[i]);
      if ((i + 1) % 4 == 0 && i != number.length - 1) buffer.write(' ');
    }
    return buffer.toString();
  }

  String _formatExpiryDate(String expiry) {
    if (expiry.length >= 2) {
      return '${expiry.substring(0, 2)}/${expiry.length > 2 ? expiry.substring(2) : ''}';
    }
    return expiry;
  }

  Future<void> _saveCardDetails() async {
    if (!_saveCard) {
      await _secureStorage.delete(key: 'cardNumber');
      await _secureStorage.delete(key: 'cardExpiry');
      await _secureStorage.delete(key: 'cardHolder');
      return;
    }

    await _secureStorage.write(
      key: 'cardNumber',
      value: _cardNumberController.text.replaceAll(' ', ''),
    );
    await _secureStorage.write(
      key: 'cardExpiry',
      value: _expiryController.text.replaceAll('/', ''),
    );
    await _secureStorage.write(
      key: 'cardHolder',
      value: _cardHolderController.text,
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

    Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentInvoice()));
    setState(() => _isLoading = true);

    try {
      if (_selectedPaymentMethod == 0) {
        await _payWithPaymobCard();
        await _saveCardDetails();
      } else if (_selectedPaymentMethod == 1) {
        await _payWithFawry();
      } else if (_selectedPaymentMethod == 2) {
        await _payWithVodafoneCash();
      }
    } catch (e) {
      _showPaymentResult(false, 'خطأ في عملية الدفع: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _payWithPaymobCard() async {
    // Step 1: Get Auth Token
    final authResponse = await http.post(
      Uri.parse('https://accept.paymob.com/api/auth/tokens'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'api_key': _paymobApiKey}),
    );

    if (authResponse.statusCode != 201) throw Exception('فشل في الحصول على رمز الدفع');
    final authToken = json.decode(authResponse.body)['token'];
    print(authToken);

    // Step 2: Create Order
    final orderResponse = await http.post(
      Uri.parse('https://accept.paymob.com/api/ecommerce/orders'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'auth_token': authToken,
        'delivery_needed': 'false',
        'amount_cents': (totalAmount * 100).round().toString(),
        'currency': 'EGP',
        'items': [{
          'name': 'International Cuisine Order',
          'amount_cents': (totalAmount * 100).round().toString(),
          'quantity': '1'
        }],
      }),
    );

    if (orderResponse.statusCode != 201) throw Exception('فشل في إنشاء الطلب');
    final orderId = json.decode(orderResponse.body)['id'];

    print('$orderId...................');

    // Step 3: Get Payment Key
    // Step 3: Get Payment Key
    final paymentKeyResponse = await http.post(
      Uri.parse('https://accept.paymob.com/api/acceptance/payment_keys'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'auth_token': authToken,
        'amount_cents': (double.parse(_amountController.text) * 100).round().toString(),
        'expiration': 3600,
        'order_id': orderId,
        'billing_data': {
          'first_name': _cardHolderController.text.split(' ').isNotEmpty
              ? _cardHolderController.text.split(' ').first
              : 'User',
          'last_name': _cardHolderController.text.split(' ').length > 1
              ? _cardHolderController.text.split(' ').last
              : 'Customer',
          'email': _emailController.text,
          'phone_number': _phoneController.text,
          'country': 'EG',
          'street': 'NA',
          'building': 'NA',
          'floor': 'NA',
          'apartment': 'NA',
          'city': 'Cairo', // أو أي مدينة افتراضية
        },
        'currency': 'EGP',
        'integration_id': _cardIntegrationId,
      }),
    );


    if (paymentKeyResponse.statusCode != 201) {
      throw Exception('فشل في إنشاء مفتاح الدفع');
    }
    _paymentToken = json.decode(paymentKeyResponse.body)['token'];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentInvoice(),
      ),
    );
  }

  Future<void> _payWithFawry() async {
    final response = await http.post(
      Uri.parse('https://atfawry.fawrystaging.com/ECommerceWeb/Fawry/payments/charge'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'merchantCode': 'YOUR_FAWRY_MERCHANT_CODE',
        'merchantRefNum': 'REF-${DateTime.now().millisecondsSinceEpoch}',
        'customerMobile': _phoneController.text,
        'customerEmail': _emailController.text,
        'paymentMethod': 'PayAtFawry',
        'amount': _amountController.text,
        'description': 'Payment for Order',
        'paymentExpiry': DateTime.now().add(const Duration(days: 3)).millisecondsSinceEpoch,
      }),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      _fawryRefNumber = result['referenceNumber'];
      _showPaymentResult(true, 'رقم المرجع الفوري: $_fawryRefNumber\nيمكنك الدفع في أي فرع فوري');
    } else {
      throw Exception('فشل في إنشاء فاتورة فوري');
    }
  }

  Future<void> _payWithVodafoneCash() async {
    // Step 1: Get Auth Token (same as card payment)
    final authResponse = await http.post(
      Uri.parse('https://accept.paymob.com/api/auth/tokens'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'api_key': _paymobApiKey}),
    );
    final authToken = json.decode(authResponse.body)['token'];

    // Step 2: Create Order (same as card payment)
    final orderResponse = await http.post(
      Uri.parse('https://accept.paymob.com/api/ecommerce/orders'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'auth_token': authToken,
        'delivery_needed': 'false',
        'amount_cents': (double.parse(_amountController.text) * 100).toString(),
        'currency': 'EGP',
        'items': [],
      }),
    );
    final orderId = json.decode(orderResponse.body)['id'];

    // Step 3: Get Payment Key for Vodafone
    final paymentKeyResponse = await http.post(
      Uri.parse('https://accept.paymob.com/api/acceptance/payment_keys'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'auth_token': authToken,
        'amount_cents': (double.parse(_amountController.text) * 100).toString(),
        'expiration': 3600,
        'order_id': orderId,
        'billing_data': {
          'first_name': 'User',
          'last_name': 'Mobile',
          'email': _emailController.text,
          'phone_number': _phoneController.text,
          'country': 'EG',
        },
        'currency': 'EGP',
        'integration_id': _vodafoneIntegrationId,
      }),
    );
    _paymentToken = json.decode(paymentKeyResponse.body)['token'];

    // Step 4: Initiate Vodafone Cash Payment
    final vodafoneResponse = await http.post(
      Uri.parse('https://accept.paymob.com/api/acceptance/payments/pay'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'source': {'identifier': _phoneController.text, 'subtype': 'WALLET'},
        'payment_token': _paymentToken,
      }),
    );

    if (vodafoneResponse.statusCode != 200) {
      throw Exception('فشل في بدء دفعة فودافون كاش');
    }

    _showPaymentResult(true, 'تم إرسال طلب الدفع إلى فودافون كاش الخاص بك');
  }

  void _showPaymentResult(bool success, [String? message]) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(success ? 'تمت العملية بنجاح' : 'فشلت العملية'),
        content: Text(message ?? (success ? 'تمت عملية الدفع بنجاح' : 'حدث خطأ أثناء عملية الدفع')),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (success) {
                Navigator.pop(context);
              }
            },
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      children: [
        const Text('طريقة الدفع', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: const Text('بطاقة ائتمانية'),
                selected: _selectedPaymentMethod == 0,
                onSelected: (selected) => setState(() => _selectedPaymentMethod = 0),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ChoiceChip(
                label: const Text('فوري'),
                selected: _selectedPaymentMethod == 1,
                onSelected: (selected) => setState(() => _selectedPaymentMethod = 1),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ChoiceChip(
                label: const Text('فودافون كاش'),
                selected: _selectedPaymentMethod == 2,
                onSelected: (selected) => setState(() => _selectedPaymentMethod = 2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardForm() {
    if (_selectedPaymentMethod != 0) return const SizedBox();

    return Column(
      children: [
        const SizedBox(height: 20),
        TextFormField(
          controller: _cardNumberController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
            CardNumberFormatter(),
          ],
          decoration: const InputDecoration(
            labelText: 'رقم البطاقة',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.credit_card),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'يرجى إدخال رقم البطاقة';
            if (value.replaceAll(' ', '').length != 16) return 'رقم البطاقة يجب أن يكون 16 رقم';
            return null;
          },
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _expiryController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  CardExpiryFormatter(),
                ],
                decoration: const InputDecoration(
                  labelText: 'تاريخ الانتهاء',
                  border: OutlineInputBorder(),
                  hintText: 'MM/YY',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'يرجى إدخال تاريخ الانتهاء';
                  if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) return 'الصيغة MM/YY';
                  return null;
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: TextFormField(
                controller: _cvvController,
                keyboardType: TextInputType.number,
                obscureText: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'يرجى إدخال CVV';
                  if (value.length != 3) return 'CVV يجب أن يكون 3 أرقام';
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: _cardHolderController,
          decoration: const InputDecoration(
            labelText: 'اسم حامل البطاقة',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'يرجى إدخال اسم حامل البطاقة';
            return null;
          },
        ),
        const SizedBox(height: 10),
        CheckboxListTile(
          title: const Text('حفظ البطاقة للمرة القادمة'),
          value: _saveCard,
          onChanged: (value) => setState(() => _saveCard = value!),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildMobileForm() {
    if (_selectedPaymentMethod == 0) return const SizedBox();

    return Column(
      children: [
        const SizedBox(height: 20),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'رقم الهاتف',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
            hintText: '01012345678',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'يرجى إدخال رقم الهاتف';
            if (!RegExp(r'^01[0-2,5]{1}[0-9]{8}$').hasMatch(value)) {
              return 'رقم هاتف غير صحيح';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'البريد الإلكتروني',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'يرجى إدخال البريد الإلكتروني';
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'بريد إلكتروني غير صحيح';
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إتمام الدفع'),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'المبلغ الإجمالي',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  '${totalAmount.toStringAsFixed(2)} جنيهاً',
                  style: const TextStyle(fontSize: 24, color: Colors.amber),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                _buildPaymentMethodSelector(),
                _buildCardForm(),
                _buildMobileForm(),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isLoading ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    _selectedPaymentMethod == 1 ? 'إنشاء فاتورة فوري' : 'إتمام الدفع',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'بياناتك محمية ولا يتم تخزين معلومات البطاقة على خوادمنا',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
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

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(' ', '');
    if (text.length > 16) text = text.substring(0, 16);

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i != text.length - 1) buffer.write(' ');
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class CardExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll('/', '');
    if (text.length > 4) text = text.substring(0, 4);

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && i != text.length - 1) buffer.write('/');
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}