import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  String selectedFilter = 'Todos';
  final List<String> filters = ['Todos', 'Pendentes', 'Confirmados', 'Rejeitados'];

  final List<Map<String, dynamic>> _events = [
    {
      'title': 'Ornamentação Casamento',
      'client': 'Ana Silva',
      'date': DateTime.now().add(const Duration(days: 1)),
      'time': '18:00',
      'location': 'Quinta da Boa Vista',
      'price': 15000,
      'status': 'confirmado',
      'category': 'Casamento',
      'duration': '6 horas',
    },
    {
      'title': 'Decoração Baixa',
      'client': 'Carlos Mendes',
      'date': DateTime.now().add(const Duration(days: 2)),
      'time': '14:00',
      'location': 'Centro da Cidade',
      'price': 8000,
      'status': 'pendente',
      'category': 'Evento Corporativo',
      'duration': '4 horas',
    },
    {
      'title': 'Buffet Festa',
      'client': 'João Paulo',
      'date': DateTime.now().add(const Duration(days: 3)),
      'time': '20:00',
      'location': 'Salão de Festas',
      'price': 12000,
      'status': 'pendente',
      'category': 'Aniversário',
      'duration': '5 horas',
    },
    {
      'title': 'Chá de Bebê',
      'client': 'Maria Santos',
      'date': DateTime.now().add(const Duration(days: 5)),
      'time': '16:00',
      'location': 'Casa da Maria',
      'price': 5000,
      'status': 'rejeitado',
      'category': 'Chá de Bebê',
      'duration': '3 horas',
    },
  ];

  List<Map<String, dynamic>> get filteredEvents {
    switch (selectedFilter) {
      case 'Pendentes':
        return _events.where((e) => e['status'] == 'pendente').toList();
      case 'Confirmados':
        return _events.where((e) => e['status'] == 'confirmado').toList();
      case 'Rejeitados':
        return _events.where((e) => e['status'] == 'rejeitado').toList();
      default:
        return _events;
    }
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
              top: 240,
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
                    Expanded(child: _buildEventsList()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 280,
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
                    child: const Icon(Icons.calendar_month, color: Colors.white, size: 24),
                  ),
                ],
              ),
              // const SizedBox(height: 24),
              const Text(
                "Minha Agenda",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Gerencie seus atendimentos e solicitações",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildStatsRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    final pendingCount = _events.where((e) => e['status'] == 'pendente').length;
    final confirmedCount = _events.where((e) => e['status'] == 'confirmado').length;
    final totalEvents = _events.length;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(
          icon: Icons.event,
          value: totalEvents.toString(),
          label: "Total",
          color: const Color(0xFF4ECDC4),
        ),
        _buildStatItem(
          icon: Icons.hourglass_top,
          value: pendingCount.toString(),
          label: "Pendentes",
          color: const Color(0xFFFFE66D),
        ),
        _buildStatItem(
          icon: Icons.check_circle,
          value: confirmedCount.toString(),
          label: "Confirmados",
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

  Widget _buildEventsList() {
    if (filteredEvents.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: filteredEvents.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final event = filteredEvents[index];
        return _buildEventCard(event, index);
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
              Icons.event_busy,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Nenhum evento encontrado",
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

  Widget _buildEventCard(Map<String, dynamic> event, int index) {
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
              gradient: _getStatusGradient(event['status']),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Text(
                    event['client'][0],
                    style: const TextStyle(
                      fontSize: 18,
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          event['category'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event['client'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _statusIcon(event['status']),
                    color: Colors.white,
                    size: 24,
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
                        icon: Icons.calendar_today,
                        label: "Data",
                        value: _formatDate(event['date']),
                        color: const Color(0xFF6A4C93),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.access_time,
                        label: "Horário",
                        value: event['time'],
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
                        icon: Icons.location_on,
                        label: "Local",
                        value: event['location'],
                        color: const Color(0xFFFFE66D),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.attach_money,
                        label: "Valor",
                        value: "MZN ${event['price']}",
                        color: const Color(0xFF6A4C93),
                      ),
                    ),
                  ],
                ),
                
                // Botões de ação para eventos pendentes
                if (event['status'] == 'pendente') ...[
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                            foregroundColor: const Color(0xFFFF6B6B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                          ),
                          onPressed: () => _reject(index),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.close, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Rejeitar',
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
                            backgroundColor: const Color(0xFF4ECDC4),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                          ),
                          onPressed: () => _approve(index),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Aprovar',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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

  LinearGradient _getStatusGradient(String status) {
    switch (status) {
      case 'confirmado':
        return const LinearGradient(
          colors: [Color(0xFF4ECDC4), Color(0xFF7BDBD4)],
        );
      case 'pendente':
        return const LinearGradient(
          colors: [Color(0xFFFFE66D), Color(0xFFFFED88)],
        );
      case 'rejeitado':
        return const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF6A4C93), Color(0xFF8E44AD)],
        );
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'confirmado':
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
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(date.year, date.month, date.day);
    
    if (eventDate == today) {
      return "Hoje";
    } else if (eventDate == today.add(const Duration(days: 1))) {
      return "Amanhã";
    } else {
      return "${date.day}/${date.month}";
    }
  }

  void _approve(int index) {
    setState(() {
      final eventIndex = _events.indexWhere((e) => e == filteredEvents[index]);
      _events[eventIndex]['status'] = 'confirmado';
    });
    _showSuccessMessage('Evento aprovado com sucesso!');
  }

  void _reject(int index) {
    setState(() {
      final eventIndex = _events.indexWhere((e) => e == filteredEvents[index]);
      _events[eventIndex]['status'] = 'rejeitado';
    });
    _showSuccessMessage('Evento rejeitado!');
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xFF4ECDC4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}