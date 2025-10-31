class ClientRequest {
  final String title;
  final String status;
  final DateTime date;
  final double value;

  ClientRequest({
    required this.title,
    required this.status,
    required this.date,
    required this.value,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'status': status,
      'date': date.toIso8601String(),
      'value': value,
    };
  }

  factory ClientRequest.fromJson(Map<String, dynamic> json) {
    return ClientRequest(
      title: json['title'],
      status: json['status'],
      date: DateTime.parse(json['date']),
      value: json['value'].toDouble(),
    );
  }
}

class Client {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String type;
  final double totalSpent;
  final int servicesCount;
  final DateTime joinDate;
  final DateTime? lastService;
  final List<ClientRequest> requests;

  Client({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.type,
    required this.totalSpent,
    required this.servicesCount,
    required this.joinDate,
    this.lastService,
    required this.requests,
  });

  // Criar cliente com ID gerado
  factory Client.create({
    required String name,
    required String phone,
    required String email,
    required String type,
    double totalSpent = 0.0,
    int servicesCount = 0,
    DateTime? joinDate,
    DateTime? lastService,
    List<ClientRequest> requests = const [],
  }) {
    return Client(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      phone: phone,
      email: email,
      type: type,
      totalSpent: totalSpent,
      servicesCount: servicesCount,
      joinDate: joinDate ?? DateTime.now(),
      lastService: lastService,
      requests: requests,
    );
  }

  // Copiar cliente com modificações
  Client copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? type,
    double? totalSpent,
    int? servicesCount,
    DateTime? joinDate,
    DateTime? lastService,
    List<ClientRequest>? requests,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      type: type ?? this.type,
      totalSpent: totalSpent ?? this.totalSpent,
      servicesCount: servicesCount ?? this.servicesCount,
      joinDate: joinDate ?? this.joinDate,
      lastService: lastService ?? this.lastService,
      requests: requests ?? this.requests,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'type': type,
      'totalSpent': totalSpent,
      'servicesCount': servicesCount,
      'joinDate': joinDate.toIso8601String(),
      'lastService': lastService?.toIso8601String(),
      'requests': requests.map((r) => r.toJson()).toList(),
    };
  }

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      type: json['type'],
      totalSpent: json['totalSpent'].toDouble(),
      servicesCount: json['servicesCount'],
      joinDate: DateTime.parse(json['joinDate']),
      lastService: json['lastService'] != null ? DateTime.parse(json['lastService']) : null,
      requests: (json['requests'] as List<dynamic>?)
          ?.map((r) => ClientRequest.fromJson(r))
          .toList() ?? [],
    );
  }

  // Para compatibilidade com o código existente
  Map<String, dynamic> toLegacyMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'type': type,
      'totalSpent': totalSpent,
      'servicesCount': servicesCount,
      'joinDate': joinDate,
      'lastService': lastService,
      'requests': requests.map((r) => r.toJson()).toList(),
    };
  }

  factory Client.fromLegacyMap(Map<String, dynamic> map) {
    return Client.create(
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      type: map['type'],
      totalSpent: map['totalSpent'].toDouble(),
      servicesCount: map['servicesCount'],
      joinDate: map['joinDate'],
      lastService: map['lastService'],
      requests: (map['requests'] as List<dynamic>?)
          ?.map((r) => ClientRequest.fromJson(r))
          .toList() ?? [],
    );
  }
}