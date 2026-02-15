enum PaymentType { easyPaisa, jazzCash, bankCard }

class PaymentMethod {
  final String id;
  final String name;
  final String icon;
  final PaymentType type;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
  });
}

class TransactionResult {
  final bool success;
  final String message;
  final String? transactionId;

  TransactionResult({
    required this.success,
    required this.message,
    this.transactionId,
  });
}
