import 'package:flutter/material.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  String selectedFilter = 'Todos';
  final List<String> filters = ['Todos', 'Ativos', 'Novos', 'VIPs'];

  final List<Map<String, dynamic>> _clients = [
    {
      'name': 'Ana Silva',
      'phone': '(82) 99999-1111',
      'email': 'ana.silva@email.com',
      'type': 'VIP',
      'totalSpent': 25000.0,
      'servicesCount': 3,
      'joinDate': DateTime.now().subtract(const Duration(days: 180)),
      'lastService': DateTime.now().subtract(const Duration(days: 15)),
      'requests': [
        {
          'title': 'Ornamentação Casamento',
          'status': 'aprovado',
          'date': DateTime.now().subtract(const Duration(days: 15)),
          'value': 15000
        },
        {
          'title': 'Chá de Bebê',
          'status': 'aprovado',
          'date': DateTime.now().subtract(const Duration(days: 45)),
          'value': 5000
        },
        {
          'title': 'Buffet Festa',
          'status': 'pendente',
          'date': DateTime.now().add(const Duration(days: 10)),
          'value': 8000
        },
      ],
    },
    {
      'name': 'Carlos Mendes',
      'phone': '(82) 98888-2222',
      'email': 'carlos.mendes@email.com',
      'type': 'Ativo',
      'totalSpent': 12000.0,
      'servicesCount': 2,
      'joinDate': DateTime.now().subtract(const Duration(days: 90)),
      'lastService': DateTime.now().subtract(const Duration(days: 30)),
      'requests': [
        {
          'title': 'Decoração Baixa',
          'status': 'aprovado',
          'date': DateTime.now().subtract(const Duration(days: 30)),
          'value': 8000
        },
        {
          'title': 'Evento Corporativo',
          'status': 'aprovado',
          'date': DateTime.now().subtract(const Duration(days: 60)),
          'value': 4000
        },
      ],
    },
    {
      'name': 'João Paulo',
      'phone': '(82) 97777-3333',
      'email': 'joao.paulo@email.com',
      'type': 'Novo',
      'totalSpent': 0.0,
      'servicesCount': 0,
      'joinDate': DateTime.now().subtract(const Duration(days: 10)),
      'lastService': null,
      'requests': [
        {
          'title': 'Buffet Festa',
          'status': 'rejeitado',
          'date': DateTime.now().subtract(const Duration(days: 5)),
          'value': 12000
        },
      ],
    },
    {
      'name': 'Maria Santos',
      'phone': '(82) 96666-4444',
      'email': 'maria.santos@email.com',
      'type': 'VIP',
      'totalSpent': 18000.0,
      'servicesCount': 4,
      'joinDate': DateTime.now().subtract(const Duration(days: 300)),
      'lastService': DateTime.now().subtract(const Duration(days: 20)),
      'requests': [
        {
          'title': 'Decoração Aniversário',
          'status': 'aprovado',
          'date': DateTime.now().subtract(const Duration(days: 20)),
          'value': 6000
        },
      ],
    },
  ];

  List<Map<String, dynamic>> get filteredClients {
    switch (selectedFilter) {
      case 'Ativos':
        return _clients.where((c) => c['type'] == 'Ativo').toList();
      case 'Novos':
        return _clients.where((c) => c['type'] == 'Novo').toList();
      case 'VIPs':
        return _clients.where((c) => c['type'] == 'VIP').toList();
      default:
        return _clients;
    }
  }

  double get totalRevenue {
    return _clients.fold(0.0, (sum, client) => sum + client['totalSpent']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            // Header com gradiente
            _buildHeader(context),
            // Conteúdo principal
            Positioned(
              top: 298,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    _buildFilters(),
                    const SizedBox(height: 16),
                    Expanded(child: _buildClientsList()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF6A4C93),
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 320,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6A4C93),
            Color(0xFF8E44AD),
            Color(0xFFA569BD),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.search, color: Colors.white, size: 24),
                  ),
                ],
              ),
              // const SizedBox(height: 24),
              const Text(
                "Meus Clientes",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Gerencie seu relacionamento com clientes",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildStatsRow(),
              const SizedBox(height: 20),
              _buildRevenueCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    final totalClients = _clients.length;
    final vipClients = _clients.where((c) => c['type'] == 'VIP').length;
    final newClients = _clients.where((c) => c['type'] == 'Novo').length;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(
          icon: Icons.people,
          value: totalClients.toString(),
          label: "Total",
          color: const Color(0xFF4ECDC4),
        ),
        _buildStatItem(
          icon: Icons.star,
          value: vipClients.toString(),
          label: "VIPs",
          color: const Color(0xFFFFE66D),
        ),
        _buildStatItem(
          icon: Icons.person_add,
          value: newClients.toString(),
          label: "Novos",
          color: const Color(0xFF95E1D3),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueCard() {
    final avgPerClient = totalRevenue / _clients.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(
          icon: Icons.attach_money,
          value: "MZN ${totalRevenue.toStringAsFixed(0)}",
          label: "Receita Total",
          color: const Color(0xFF4ECDC4),
        ),
        _buildStatItem(
          icon: Icons.bar_chart,
          value: "MZN ${avgPerClient.toStringAsFixed(0)}",
          label: "Média/Cliente",
          color: const Color(0xFFFFE66D),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filters.length,
          itemBuilder: (context, index) {
            final filter = filters[index];
            final isSelected = selectedFilter == filter;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedFilter = filter;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? const Color(0xFF6A4C93) 
                    : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected 
                      ? const Color(0xFF6A4C93) 
                      : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected 
                      ? Colors.white 
                      : Colors.grey[700],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildClientsList() {
    if (filteredClients.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: filteredClients.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final client = filteredClients[index];
        return _buildClientCard(client);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.people_outline,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Nenhum cliente encontrado",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tente alterar o filtro selecionado",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientCard(Map<String, dynamic> client) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header do card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: _getClientTypeGradient(client['type']),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Text(
                    client['name'][0],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              client['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              client['type'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.phone, color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            client['phone'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Corpo do card
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.attach_money,
                        label: "Total Gasto",
                        value: "MZN ${client['totalSpent'].toStringAsFixed(0)}",
                        color: const Color(0xFF6A4C93),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.event,
                        label: "Serviços",
                        value: "${client['servicesCount']}",
                        color: const Color(0xFF4ECDC4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.calendar_today,
                        label: "Cliente desde",
                        value: _formatDate(client['joinDate']),
                        color: const Color(0xFFFFE66D),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.schedule,
                        label: "Último serviço",
                        value: client['lastService'] != null 
                          ? _formatDate(client['lastService']) 
                          : "Nenhum",
                        color: const Color(0xFFFF6B6B),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Histórico de solicitações
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Histórico de Serviços",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...client['requests'].map<Widget>((request) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getStatusColor(request['status']).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getStatusColor(request['status']).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getStatusIcon(request['status']),
                              color: _getStatusColor(request['status']),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request['title'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "MZN ${request['value']} • ${_formatDate(request['date'])}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(request['status']),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                request['status'].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Botões de ação
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          foregroundColor: const Color(0xFF6A4C93),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Ligar',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A4C93),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.message, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Mensagem',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  LinearGradient _getClientTypeGradient(String type) {
    switch (type) {
      case 'VIP':
        return const LinearGradient(
          colors: [Color(0xFFFFE66D), Color(0xFFFFED88)],
        );
      case 'Ativo':
        return const LinearGradient(
          colors: [Color(0xFF4ECDC4), Color(0xFF7BDBD4)],
        );
      case 'Novo':
        return const LinearGradient(
          colors: [Color(0xFF95E1D3), Color(0xFFB8E6D3)],
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF6A4C93), Color(0xFF8E44AD)],
        );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'aprovado':
        return const Color(0xFF4ECDC4);
      case 'pendente':
        return const Color(0xFFFFE66D);
      case 'rejeitado':
        return const Color(0xFFFF6B6B);
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'aprovado':
        return Icons.check_circle;
      case 'pendente':
        return Icons.hourglass_top;
      case 'rejeitado':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return "Hoje";
    } else if (difference == 1) {
      return "Ontem";
    } else if (difference < 30) {
      return "${difference}d atrás";
    } else if (difference < 365) {
      final months = (difference / 30).floor();
      return "${months}m atrás";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }
}