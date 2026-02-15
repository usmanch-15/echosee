import 'package:flutter/foundation.dart';
import '../data/models/payment_method.dart';
import '../data/services/payment_service.dart';

class PaymentProvider with ChangeNotifier {
  final PaymentService _paymentService = PaymentService();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  TransactionResult? _lastResult;
  TransactionResult? get lastResult => _lastResult;

  Future<void> payWithEasyPaisa(String phone, double amount) async {
    _setLoading(true);
    _lastResult = await _paymentService.processEasyPaisa(phone, amount);
    _setLoading(false);
  }

  Future<void> payWithJazzCash(String phone, double amount) async {
    _setLoading(true);
    _lastResult = await _paymentService.processJazzCash(phone, amount);
    _setLoading(false);
  }

  Future<void> payWithCard(String number, String expiry, String cvv, double amount) async {
    _setLoading(true);
    _lastResult = await _paymentService.processBankCard(
      cardNumber: number,
      expiry: expiry,
      cvv: cvv,
      amount: amount,
    );
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearResult() {
    _lastResult = null;
    notifyListeners();
  }
}
