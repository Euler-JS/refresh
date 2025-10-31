class LocationDetail {
  String image;
  String name;
  String address;
  int price;
  double rating;
  int temperature;
  int time;
  String description;

  LocationDetail({
    required this.image,
    required this.name,
    required this.address,
    required this.price,
    required this.description,
    required this.rating,
    required this.temperature,
    required this.time,
  });
}

// Novo modelo para pagamentos com suporte a parcelas
class PaymentModel {
  final String id;
  final String client;
  final String service;
  final double totalAmount;
  double paidAmount;
  String status; // 'pendente', 'pago', 'atrasado'
  final DateTime dueDate;
  final DateTime serviceDate;
  final String category;
  final List<PaymentInstallment> installments;

  PaymentModel({
    required this.id,
    required this.client,
    required this.service,
    required this.totalAmount,
    this.paidAmount = 0.0,
    required this.status,
    required this.dueDate,
    required this.serviceDate,
    required this.category,
    List<PaymentInstallment>? installments,
  }) : installments = installments ?? [];

  double get remainingAmount => totalAmount - paidAmount;

  void addPayment(double amount, DateTime date) {
    paidAmount += amount;
    installments.add(PaymentInstallment(amount: amount, date: date));
    if (paidAmount >= totalAmount) {
      status = 'pago';
    }
  }

  PaymentModel copyWith({
    String? id,
    String? client,
    String? service,
    double? totalAmount,
    double? paidAmount,
    String? status,
    DateTime? dueDate,
    DateTime? serviceDate,
    String? category,
    List<PaymentInstallment>? installments,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      client: client ?? this.client,
      service: service ?? this.service,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      serviceDate: serviceDate ?? this.serviceDate,
      category: category ?? this.category,
      installments: installments ?? List.from(this.installments),
    );
  }

  // Método para serialização JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client': client,
      'service': service,
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'status': status,
      'dueDate': dueDate.toIso8601String(),
      'serviceDate': serviceDate.toIso8601String(),
      'category': category,
      'installments': installments.map((i) => {
        'amount': i.amount,
        'date': i.date.toIso8601String(),
      }).toList(),
    };
  }

  // Método para desserialização JSON
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      client: json['client'],
      service: json['service'],
      totalAmount: json['totalAmount'],
      paidAmount: json['paidAmount'] ?? 0.0,
      status: json['status'],
      dueDate: DateTime.parse(json['dueDate']),
      serviceDate: DateTime.parse(json['serviceDate']),
      category: json['category'],
      installments: (json['installments'] as List<dynamic>?)
          ?.map((i) => PaymentInstallment(
                amount: i['amount'],
                date: DateTime.parse(i['date']),
              ))
          .toList() ?? [],
    );
  }
}

class PaymentInstallment {
  final double amount;
  final DateTime date;

  PaymentInstallment({
    required this.amount,
    required this.date,
  });
}

// Dados de exemplo (removidos)
List<PaymentModel> paymentItems = [
];

List<LocationDetail> locationItems = [
];
