import 'package:flutter/material.dart';

class Service {
  final String id;
  final String title;
  final String clientName;
  final String category;
  final DateTime date;
  final TimeOfDay time;
  final String location;
  final double price;
  final String? description;
  final String status;
  final DateTime createdAt;

  Service({
    required this.id,
    required this.title,
    required this.clientName,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.price,
    this.description,
    this.status = 'pendente',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Criar serviço com ID gerado
  factory Service.create({
    required String title,
    required String clientName,
    required String category,
    required DateTime date,
    required TimeOfDay time,
    required String location,
    required double price,
    String? description,
    String status = 'pendente',
  }) {
    return Service(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      clientName: clientName,
      category: category,
      date: date,
      time: time,
      location: location,
      price: price,
      description: description,
      status: status,
      createdAt: DateTime.now(),
    );
  }

  // Copiar serviço com modificações
  Service copyWith({
    String? id,
    String? title,
    String? clientName,
    String? category,
    DateTime? date,
    TimeOfDay? time,
    String? location,
    double? price,
    String? description,
    String? status,
    DateTime? createdAt,
  }) {
    return Service(
      id: id ?? this.id,
      title: title ?? this.title,
      clientName: clientName ?? this.clientName,
      category: category ?? this.category,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      price: price ?? this.price,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'clientName': clientName,
      'category': category,
      'date': date.toIso8601String(),
      'time': {'hour': time.hour, 'minute': time.minute},
      'location': location,
      'price': price,
      'description': description,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      title: json['title'],
      clientName: json['clientName'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      time: TimeOfDay(
        hour: json['time']['hour'],
        minute: json['time']['minute'],
      ),
      location: json['location'],
      price: json['price'].toDouble(),
      description: json['description'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Para compatibilidade com código existente
  Map<String, dynamic> toLegacyMap() {
    return {
      'title': title,
      'clientName': clientName,
      'category': category,
      'date': date,
      'time': time,
      'location': location,
      'price': price,
      'description': description,
      'status': status,
      'createdAt': createdAt,
    };
  }

  // Status possíveis
  static const List<String> statusOptions = [
    'pendente',
    'confirmado',
    'em_andamento',
    'concluido',
    'cancelado'
  ];

  // Categorias possíveis
  static const List<String> categoryOptions = [
    'Ornamentação',
    'Evento Corporativo',
    'Festa de Aniversário',
    'Casamento',
    'Formatura',
    'Outros'
  ];

  // Cores para status
  static Color getStatusColor(String status) {
    switch (status) {
      case 'pendente':
        return const Color(0xFFFFE66D);
      case 'confirmado':
        return const Color(0xFF4ECDC4);
      case 'em_andamento':
        return const Color(0xFF6A4C93);
      case 'concluido':
        return const Color(0xFF95E1D3);
      case 'cancelado':
        return const Color(0xFFFF6B6B);
      default:
        return Colors.grey;
    }
  }

  // Ícones para status
  static IconData getStatusIcon(String status) {
    switch (status) {
      case 'pendente':
        return Icons.hourglass_top;
      case 'confirmado':
        return Icons.check_circle;
      case 'em_andamento':
        return Icons.play_circle;
      case 'concluido':
        return Icons.done_all;
      case 'cancelado':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  // Formatar data e hora
  String get formattedDateTime {
    final timeStr = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} às $timeStr';
  }

  // Verificar se o serviço é hoje
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  // Verificar se o serviço já passou
  bool get isPast {
    final now = DateTime.now();
    final serviceDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return serviceDateTime.isBefore(now);
  }

  // Verificar se o serviço é futuro
  bool get isFuture => !isToday && !isPast;
}