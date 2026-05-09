class AppStrings {
  // Payment Methods
  static const String creditCard = 'بطاقة ائتمانية';
  static const String fawry = 'فوري';
  static const String vodafoneCash = 'فودافون كاش';

  // Form Labels
  static const String cardNumber = 'رقم البطاقة';
  static const String expiryDate = 'تاريخ الانتهاء';
  static const String cvv = 'CVV';
  static const String cardHolderName = 'اسم حامل البطاقة';
  static const String phoneNumber = 'رقم الهاتف';
  static const String email = 'البريد الإلكتروني';
  static const String totalAmount = 'المبلغ الإجمالي';
  static const String saveCard = 'حفظ البطاقة للمرة القادمة';

  // Button Texts
  static const String createFawryInvoice = 'إنشاء فاتورة فوري';
  static const String completePayment = 'إتمام الدفع';
  static const String ok = 'موافق';

  // Dialog Messages
  static const String paymentSuccess = 'تمت العملية بنجاح';
  static const String paymentFailed = 'فشلت العملية';
  static const String paymentSuccessMessage = 'تمت عملية الدفع بنجاح';
  static const String paymentErrorMessage = 'حدث خطأ أثناء عملية الدفع';
  static const String vodafonePaymentSent = 'تم إرسال طلب الدفع إلى فودافون كاش الخاص بك';

  // Validation Messages
  static const String pleaseEnterCardNumber = 'يرجى إدخال رقم البطاقة';
  static const String cardNumberMustBe16Digits = 'رقم البطاقة يجب أن يكون 16 رقم';
  static const String pleaseEnterExpiryDate = 'يرجى إدخال تاريخ الانتهاء';
  static const String invalidExpiryFormat = 'الصيغة MM/YY';
  static const String pleaseEnterCvv = 'يرجى إدخال CVV';
  static const String cvvMustBe3Digits = 'CVV يجب أن يكون 3 أرقام';
  static const String pleaseEnterCardHolder = 'يرجى إدخال اسم حامل البطاقة';
  static const String pleaseEnterPhoneNumber = 'يرجى إدخال رقم الهاتف';
  static const String invalidPhoneNumber = 'رقم هاتف غير صحيح';
  static const String pleaseEnterEmail = 'يرجى إدخال البريد الإلكتروني';
  static const String invalidEmail = 'بريد إلكتروني غير صحيح';

  // Error Messages
  static const String paymentTokenError = 'فشل في الحصول على رمز الدفع';
  static const String createOrderError = 'فشل في إنشاء الطلب';
  static const String createPaymentKeyError = 'فشل في إنشاء مفتاح الدفع';
  static const String createFawryInvoiceError = 'فشل في إنشاء فاتورة فوري';
  static const String vodafonePaymentError = 'فشل في بدء دفعة فودافون كاش';
  static const String paymentError = 'خطأ في عملية الدفع';

  // Security Message
  static const String securityMessage = 'بياناتك محمية ولا يتم تخزين معلومات البطاقة على خوادمنا';

  // App Bar Title
  static const String paymentScreenTitle = 'إتمام الدفع';

  // Fawry Success Message
  static const String fawrySuccessMessage = 'رقم المرجع الفوري: \nيمكنك الدفع في أي فرع فوري';
}