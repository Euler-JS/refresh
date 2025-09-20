class ServiceItem {
  final String id;
  final String clientName;
  final String serviceType;
  final String location;
  final DateTime date;
  final String time;
  final double price;
  final ServiceStatus status;
  final String? imageUrl;
  final String description;

  ServiceItem({
    required this.id,
    required this.clientName,
    required this.serviceType,
    required this.location,
    required this.date,
    required this.time,
    required this.price,
    required this.status,
    this.imageUrl,
    required this.description,
  });
}

enum ServiceStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
  overdue
}

// Mock data
List<ServiceItem> serviceItems = [
  ServiceItem(
    id: '1',
    clientName: 'Ana Silva',
    serviceType: 'Ornamentação Casamento',
    location: 'Quinta da Boa Vista',
    date: DateTime.now(),
    time: '14:00',
    price: 15000,
    status: ServiceStatus.confirmed,
    description: 'Decoração completa para cerimônia e recepção de casamento com 150 convidados.',
  ),
  ServiceItem(
    id: '2', 
    clientName: 'João Santos',
    serviceType: 'Evento Corporativo',
    location: 'Hotel Polana',
    date: DateTime.now().add(const Duration(days: 2)),
    time: '18:00',
    price: 8500,
    status: ServiceStatus.pending,
    description: 'Decoração para evento de fim de ano da empresa com tema elegante.',
  ),
  ServiceItem(
    id: '3',
    clientName: 'Maria Costa',
    serviceType: 'Festa de Aniversário',
    location: 'Restaurante Zambi',
    date: DateTime.now().add(const Duration(days: 5)),
    time: '19:00', 
    price: 5000,
    status: ServiceStatus.inProgress,
    description: 'Festa de 50 anos com decoração temática vintage.',
  ),
];
