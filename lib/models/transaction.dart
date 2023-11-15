// lib/models/transaction.dart

class Transaction {
  final String accountId;
  final double amount;
  final String date;
  final String name;
  final String paymentChannel;
  final bool pending;
  final String transactionId;
  final String transactionType;
  final String? website;

  Transaction({
    required this.accountId,
    required this.amount,
    required this.date,
    required this.name,
    required this.paymentChannel,
    required this.pending,
    required this.transactionId,
    required this.transactionType,
    required this.website,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      accountId: json['account_id'],
      amount: json['amount'],
      date: json['date'],
      name: json['name'],
      paymentChannel: json['payment_channel'],
      pending: json['pending'],
      transactionId: json['transaction_id'],
      transactionType: json['transaction_type'],
      website: json['website'] ?? 'No website',
    );
  }
}
