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
}

class PaymentInstallment {
  final double amount;
  final DateTime date;

  PaymentInstallment({
    required this.amount,
    required this.date,
  });
}

// Dados mock atualizados
List<PaymentModel> paymentItems = [
  PaymentModel(
    id: '1',
    client: 'Ana Silva',
    service: 'Ornamentação Casamento',
    totalAmount: 15000.0,
    paidAmount: 5000.0, // Exemplo com pagamento parcial
    status: 'pendente',
    dueDate: DateTime.now().add(const Duration(days: 5)),
    serviceDate: DateTime.now().subtract(const Duration(days: 2)),
    category: 'Casamento',
    installments: [
      PaymentInstallment(amount: 5000.0, date: DateTime.now().subtract(const Duration(days: 1))),
    ],
  ),
  PaymentModel(
    id: '2',
    client: 'Carlos Mendes',
    service: 'Decoração Baixa',
    totalAmount: 8000.0,
    status: 'atrasado',
    dueDate: DateTime.now().subtract(const Duration(days: 3)),
    serviceDate: DateTime.now().subtract(const Duration(days: 10)),
    category: 'Evento Corporativo',
  ),
  PaymentModel(
    id: '3',
    client: 'João Paulo',
    service: 'Buffet Festa',
    totalAmount: 12000.0,
    paidAmount: 12000.0,
    status: 'pago',
    dueDate: DateTime.now().subtract(const Duration(days: 1)),
    serviceDate: DateTime.now().subtract(const Duration(days: 8)),
    category: 'Aniversário',
    installments: [
      PaymentInstallment(amount: 12000.0, date: DateTime.now().subtract(const Duration(days: 1))),
    ],
  ),
  PaymentModel(
    id: '4',
    client: 'Maria Santos',
    service: 'Chá de Bebê',
    totalAmount: 5000.0,
    status: 'pendente',
    dueDate: DateTime.now().add(const Duration(days: 7)),
    serviceDate: DateTime.now().subtract(const Duration(days: 1)),
    category: 'Chá de Bebê',
  ),
];

List<LocationDetail> locationItems = [
  LocationDetail(
    image: "Images/thebridge.png",
    name: 'The Way',
    address: 'Spain',
    price: 1350,
    rating: 5.0,
    temperature: 19,
    time:5 ,
    description:
        '"The Way" typically refers to the Camino de Santiago, a network of pilgrimage routes leading to the shrine of the apostle Saint James the Great in the Cathedral of Santiago de Compostela in Galicia, northwest Spain.',
  ),
  LocationDetail(
    image: "Images/thebridge.png",
    name: 'Loygavegur',
    address: 'Iceland',
    price: 2350,
      rating: 4.9,
    temperature: 1,
    time:15 ,
    description:
        "Iceland's nature is renowned for its raw and untamed beauty, characterized by dramatic landscapes shaped by volcanic activity, glaciers, geysers, and cascading waterfalls,if you want to enjoy more then you need to visit this all place.",
  ),
  LocationDetail(
    image: "Images/thebridge.png",
    name: 'Oyo Lakes',
    address: 'Croatia',
    price: 3250,
      rating: 5.0,
    temperature: 22,
    time:9 ,
    description:
        'Oyo Lake, nestled in a picturesque setting, captivates visitors with its tranquil waters and surrounding lush landscapes. It serves as a haven for relaxation and outdoor activities, offering opportunities for boating,and peaceful walks along its shores',
  ),
  LocationDetail(
    image: "Images/sunrises.png",
    name: 'Sun Rise',
    address: 'UK',
    price: 3500,
      rating: 4.0,
    temperature: 12,
    time:6 ,
    description:
        "At dawn, the Eiffel Tower in Paris becomes a spectacle of beauty as the sun rises behind its iconic silhouette, casting a warm glow over the cityscape.If you want to enjoy more then you need to visit this all place.",
  ),
  LocationDetail(
    image: "Images/eiffel_tower.png",
    name: 'Effiel Tower',
    address: 'Paris France',
    price: 3350,
      rating: 4.5,
    temperature: 19,
    time:2 ,
    description:
        ' This enchanting moment draws crowds to witness the breathtaking scene and symbolizes the timeless allure and romantic charm of the French capital, making it an unforgettable experience for visitors from around the world.',
  ),
];
