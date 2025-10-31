import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/service.dart';
import '../Model/model.dart';
import 'payment_storage_service.dart';

class ServiceStorageService {
  static const String _servicesKey = 'services';
  static ServiceStorageService? _instance;

  ServiceStorageService._();

  static ServiceStorageService get instance {
    _instance ??= ServiceStorageService._();
    return _instance!;
  }

  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // Carregar todos os serviços
  Future<List<Service>> loadServices() async {
    try {
      final prefs = await _getPrefs();
      final servicesJson = prefs.getStringList(_servicesKey) ?? [];

      return servicesJson.map((json) {
        final Map<String, dynamic> data = jsonDecode(json);
        return Service.fromJson(data);
      }).toList();
    } catch (e) {
      print('Erro ao carregar serviços: $e');
      return [];
    }
  }

  // Salvar todos os serviços
  Future<void> saveServices(List<Service> services) async {
    try {
      final prefs = await _getPrefs();
      final servicesJson = services.map((service) => jsonEncode(service.toJson())).toList();
      await prefs.setStringList(_servicesKey, servicesJson);
    } catch (e) {
      print('Erro ao salvar serviços: $e');
      throw Exception('Falha ao salvar serviços');
    }
  }

  // Adicionar novo serviço
  Future<void> addService(Service service) async {
    final services = await loadServices();
    services.add(service);
    await saveServices(services);
    
    // Criar pagamento automaticamente se o serviço for confirmado
    if (service.status == 'confirmado') {
      await _createPaymentForService(service);
    }
  }

  // Atualizar serviço existente
  Future<void> updateService(Service updatedService) async {
    final services = await loadServices();
    final index = services.indexWhere((s) => s.id == updatedService.id);

    if (index != -1) {
      final oldService = services[index];
      services[index] = updatedService;
      await saveServices(services);
      
      // Criar pagamento se o status mudou para confirmado
      if (oldService.status != 'confirmado' && updatedService.status == 'confirmado') {
        await _createPaymentForService(updatedService);
      }
    } else {
      throw Exception('Serviço não encontrado');
    }
  }

  // Deletar serviço
  Future<void> deleteService(String serviceId) async {
    final services = await loadServices();
    services.removeWhere((s) => s.id == serviceId);
    await saveServices(services);
  }

  // Buscar serviço por ID
  Future<Service?> getServiceById(String serviceId) async {
    final services = await loadServices();
    try {
      return services.firstWhere((s) => s.id == serviceId);
    } catch (e) {
      return null;
    }
  }

  // Buscar serviços por cliente
  Future<List<Service>> getServicesByClient(String clientName) async {
    final services = await loadServices();
    return services.where((s) => s.clientName == clientName).toList();
  }

  // Buscar serviços por categoria
  Future<List<Service>> getServicesByCategory(String category) async {
    final services = await loadServices();
    return services.where((s) => s.category == category).toList();
  }

  // Buscar serviços por status
  Future<List<Service>> getServicesByStatus(String status) async {
    final services = await loadServices();
    return services.where((s) => s.status == status).toList();
  }

  // Buscar serviços futuros
  Future<List<Service>> getUpcomingServices() async {
    final services = await loadServices();
    final now = DateTime.now();
    return services.where((s) {
      final serviceDateTime = DateTime(s.date.year, s.date.month, s.date.day, s.time.hour, s.time.minute);
      return serviceDateTime.isAfter(now);
    }).toList()
      ..sort((a, b) {
        final aDateTime = DateTime(a.date.year, a.date.month, a.date.day, a.time.hour, a.time.minute);
        final bDateTime = DateTime(b.date.year, b.date.month, b.date.day, b.time.hour, b.time.minute);
        return aDateTime.compareTo(bDateTime);
      });
  }

  // Buscar serviços de hoje
  Future<List<Service>> getTodayServices() async {
    final services = await loadServices();
    final now = DateTime.now();
    return services.where((s) =>
      s.date.year == now.year &&
      s.date.month == now.month &&
      s.date.day == now.day
    ).toList()
      ..sort((a, b) => a.time.hour * 60 + a.time.minute - (b.time.hour * 60 + b.time.minute));
  }

  // Buscar serviços passados
  Future<List<Service>> getPastServices() async {
    final services = await loadServices();
    final now = DateTime.now();
    return services.where((s) {
      final serviceDateTime = DateTime(s.date.year, s.date.month, s.date.day, s.time.hour, s.time.minute);
      return serviceDateTime.isBefore(now);
    }).toList()
      ..sort((a, b) {
        final aDateTime = DateTime(a.date.year, a.date.month, a.date.day, a.time.hour, a.time.minute);
        final bDateTime = DateTime(b.date.year, b.date.month, b.date.day, b.time.hour, b.time.minute);
        return bDateTime.compareTo(aDateTime); // Mais recentes primeiro
      });
  }

  // Limpar todos os dados (para desenvolvimento)
  Future<void> clearAllData() async {
    final prefs = await _getPrefs();
    await prefs.remove(_servicesKey);
  }

  // Criar pagamento automaticamente para um serviço confirmado
  Future<void> _createPaymentForService(Service service) async {
    try {
      final paymentStorage = PaymentStorageService.instance;
      
      // Verificar se já existe um pagamento para este serviço
      final existingPayments = await paymentStorage.loadPayments();
      final existingPayment = existingPayments.where((p) => 
        p.client == service.clientName && 
        p.service == service.title &&
        p.serviceDate.year == service.date.year &&
        p.serviceDate.month == service.date.month &&
        p.serviceDate.day == service.date.day
      ).isNotEmpty;
      
      if (!existingPayment) {
        // Criar novo pagamento
        final payment = PaymentModel(
          id: 'service_${service.id}',
          client: service.clientName,
          service: service.title,
          totalAmount: service.price,
          status: 'pendente',
          dueDate: service.date.add(const Duration(days: 30)), // Vencimento 30 dias após o serviço
          serviceDate: service.date,
          category: service.category,
        );
        
        await paymentStorage.addPayment(payment);
      }
    } catch (e) {
      print('Erro ao criar pagamento para serviço: $e');
      // Não lançar erro para não quebrar o fluxo de criação do serviço
    }
  }
}