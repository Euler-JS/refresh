import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/client.dart';

class ClientStorageService {
  static const String _clientsKey = 'clients_data';

  // Singleton pattern
  static final ClientStorageService _instance = ClientStorageService._internal();
  factory ClientStorageService() => _instance;
  ClientStorageService._internal();

  SharedPreferences? _prefs;

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Salvar lista de clientes
  Future<void> saveClients(List<Client> clients) async {
    await _initPrefs();
    final clientsJson = clients.map((client) => client.toJson()).toList();
    final clientsString = jsonEncode(clientsJson);
    await _prefs!.setString(_clientsKey, clientsString);
  }

  // Carregar lista de clientes
  Future<List<Client>> loadClients() async {
    await _initPrefs();
    final clientsString = _prefs!.getString(_clientsKey);
    if (clientsString == null) {
      return [];
    }

    try {
      final clientsJson = jsonDecode(clientsString) as List<dynamic>;
      return clientsJson.map((json) => Client.fromJson(json)).toList();
    } catch (e) {
      // Se houver erro na desserialização, retorna lista vazia
      return [];
    }
  }

  // Adicionar novo cliente
  Future<void> addClient(Client client) async {
    final clients = await loadClients();
    clients.add(client);
    await saveClients(clients);
  }

  // Atualizar cliente existente
  Future<void> updateClient(Client updatedClient) async {
    final clients = await loadClients();
    final index = clients.indexWhere((client) => client.id == updatedClient.id);
    if (index != -1) {
      clients[index] = updatedClient;
      await saveClients(clients);
    }
  }

  // Deletar cliente
  Future<void> deleteClient(String clientId) async {
    final clients = await loadClients();
    clients.removeWhere((client) => client.id == clientId);
    await saveClients(clients);
  }

  // Buscar cliente por ID
  Future<Client?> getClientById(String clientId) async {
    final clients = await loadClients();
    return clients.where((client) => client.id == clientId).firstOrNull;
  }

  // Buscar clientes por tipo
  Future<List<Client>> getClientsByType(String type) async {
    final clients = await loadClients();
    return clients.where((client) => client.type == type).toList();
  }

  // Verificar se existem dados salvos
  Future<bool> hasData() async {
    await _initPrefs();
    return _prefs!.containsKey(_clientsKey);
  }

  // Obter estatísticas
  Future<Map<String, dynamic>> getStatistics() async {
    final clients = await loadClients();

    final totalClients = clients.length;
    final vipClients = clients.where((c) => c.type == 'VIP').length;
    final activeClients = clients.where((c) => c.type == 'Ativo').length;
    final newClients = clients.where((c) => c.type == 'Novo').length;
    final totalRevenue = clients.fold<double>(0.0, (sum, client) => sum + client.totalSpent);

    return {
      'totalClients': totalClients,
      'vipClients': vipClients,
      'activeClients': activeClients,
      'newClients': newClients,
      'totalRevenue': totalRevenue,
      'averagePerClient': totalClients > 0 ? totalRevenue / totalClients : 0.0,
    };
  }
}