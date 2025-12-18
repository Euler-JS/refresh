import 'package:flutter/material.dart';
import '../services/service_storage_service.dart';
import '../models/service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ServiceStorageService _storageService = ServiceStorageService.instance;
  
  List<Service> _allServices = [];
  List<Service> _filteredServices = [];
  bool _isLoading = true;
  
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedStatus = 'all';
  
  double _totalRevenue = 0;
  int _totalServices = 0;
  Map<String, int> _servicesByCategory = {};
  Map<String, double> _revenueByCategory = {};

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() => _isLoading = true);
    
    try {
      final services = await _storageService.loadServices();
      setState(() {
        _allServices = services;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar serviços: $e');
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    List<Service> filtered = List.from(_allServices);

    // Filtrar por status
    if (_selectedStatus != 'all') {
      filtered = filtered.where((s) => s.status == _selectedStatus).toList();
    }

    // Filtrar por data
    if (_startDate != null) {
      filtered = filtered.where((s) {
        return s.date.isAfter(_startDate!.subtract(const Duration(days: 1)));
      }).toList();
    }

    if (_endDate != null) {
      filtered = filtered.where((s) {
        return s.date.isBefore(_endDate!.add(const Duration(days: 1)));
      }).toList();
    }

    // Calcular estatísticas
    _calculateStatistics(filtered);

    setState(() {
      _filteredServices = filtered;
    });
  }

  void _calculateStatistics(List<Service> services) {
    _totalServices = services.length;
    _totalRevenue = 0;
    _servicesByCategory = {};
    _revenueByCategory = {};

    for (var service in services) {
      // Total de receita
      _totalRevenue += service.price;

      // Serviços por categoria
      _servicesByCategory[service.category] = 
          (_servicesByCategory[service.category] ?? 0) + 1;

      // Receita por categoria
      _revenueByCategory[service.category] = 
          (_revenueByCategory[service.category] ?? 0) + service.price;
    }
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6A4C93),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _applyFilters();
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedStatus = 'all';
      _applyFilters();
    });
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  String _formatCurrency(double value) {
    return "MT ${value.toStringAsFixed(2)}";
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completado':
        return Colors.green;
      case 'em_progresso':
        return Colors.orange;
      case 'pendente':
        return Colors.blue;
      case 'cancelado':
        return Colors.red;
      case 'confirmado':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completado':
        return 'Completado';
      case 'em_progresso':
        return 'Em Progresso';
      case 'pendente':
        return 'Pendente';
      case 'cancelado':
        return 'Cancelado';
      case 'confirmado':
        return 'Confirmado';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          child: Column(
            children: [
              _buildHeader(),
              _buildFilters(),
              _buildStatistics(),
              Expanded(child: _buildServicesList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
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
          const Expanded(
            child: Center(
              child: Text(
                "Relatórios",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 56),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filtros',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C2C2C),
                ),
              ),
              if (_startDate != null || _endDate != null || _selectedStatus != 'all')
                TextButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.clear, size: 16),
                  label: const Text('Limpar'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF6A4C93),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Filtro de data
          InkWell(
            onTap: _selectDateRange,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.date_range, color: Color(0xFF6A4C93)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _startDate != null && _endDate != null
                          ? '${_formatDate(_startDate!)} - ${_formatDate(_endDate!)}'
                          : 'Selecionar período',
                      style: TextStyle(
                        color: _startDate != null ? Colors.black87 : Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Filtro de status
          DropdownButtonFormField<String>(
            value: _selectedStatus,
            decoration: InputDecoration(
              labelText: 'Status',
              prefixIcon: const Icon(Icons.filter_list, color: Color(0xFF6A4C93)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            items: const [
              DropdownMenuItem(value: 'all', child: Text('Todos')),
              DropdownMenuItem(value: 'completado', child: Text('Completados')),
              DropdownMenuItem(value: 'em_progresso', child: Text('Em Progresso')),
              DropdownMenuItem(value: 'pendente', child: Text('Pendentes')),
              DropdownMenuItem(value: 'cancelado', child: Text('Cancelados')),
              DropdownMenuItem(value: 'confirmado', child: Text('Confirmados')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedStatus = value!;
                _applyFilters();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estatísticas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total de Serviços',
                  _totalServices.toString(),
                  Icons.work,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Receita Total',
                  _formatCurrency(_totalRevenue),
                  Icons.attach_money,
                  Colors.green,
                ),
              ),
            ],
          ),
          if (_servicesByCategory.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Por Categoria',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 8),
            ..._servicesByCategory.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        entry.key,
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6A4C93).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${entry.value} • ${_formatCurrency(_revenueByCategory[entry.key] ?? 0)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6A4C93),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_filteredServices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum serviço encontrado',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tente ajustar os filtros',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Serviços (${_filteredServices.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: _filteredServices.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final service = _filteredServices[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(service.status).withOpacity(0.2),
                    child: Icon(
                      Icons.work,
                      color: _getStatusColor(service.status),
                      size: 20,
                    ),
                  ),
                  title: Text(
                    service.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        service.clientName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(service.date),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatCurrency(service.price),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF6A4C93),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getStatusColor(service.status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getStatusText(service.status),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(service.status),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
