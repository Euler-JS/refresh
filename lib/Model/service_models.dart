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
