import 'package:flutter/material.dart';
import '../models/service.dart';
import '../services/service_storage_service.dart';
import '../services/subscription_service.dart';
import 'add_service_page.dart';
import 'edit_service_page.dart';
import 'subscription_screen.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  String selectedFilter = 'Todos';
  final List<String> filters = ['Todos', 'Hoje', 'Próximos', 'Pendentes', 'Em Andamento', 'Concluídos'];

  final ServiceStorageService _storageService = ServiceStorageService.instance;
  List<Service> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _addNewService() async {
    // Verificar se tem subscrição ativa
    final hasSubscription = await SubscriptionService.instance.hasActiveSubscription();
    
    // Se não tem subscrição e já tem 5 ou mais serviços, bloquear
    if (!hasSubscription && _services.length >= 5) {
      _showSubscriptionRequiredDialog();
      return;
    }
    
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddServicePage()),
    );

    if (result == true) {
      await _loadServices();
    }
  }

  Future<void> _editService(Service service) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditServicePage(service: service)),
    );

    if (result == true) {
      await _loadServices();
    }
  }

  Future<void> _loadServices() async {
    setState(() => _isLoading = true);
    try {
      final services = await _storageService.loadServices();
      setState(() {
        _services = services;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // TODO: Mostrar erro para o usuário
    }
  }

  List<Service> get filteredServices {
    switch (selectedFilter) {
      case 'Hoje':
        return _services.where((s) => s.isToday).toList();
      case 'Próximos':
        return _services.where((s) => s.isFuture).toList();
      case 'Pendentes':
        return _services.where((s) => s.status == 'pendente').toList();
      case 'Em Andamento':
        return _services.where((s) => s.status == 'em_andamento').toList();
      case 'Concluídos':
        return _services.where((s) => s.status == 'concluido').toList();
      default:
        return _services;
    }
  }

  double get totalRevenue {
    return _services.where((s) => s.status == 'concluido').fold(0.0, (sum, service) => sum + service.price);
  }

  double get pendingRevenue {
    return _services.where((s) => s.status == 'confirmado' || s.status == 'em_andamento').fold(0.0, (sum, service) => sum + service.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            _buildHeader(context),
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
                    Expanded(child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildServicesList()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewService,
        backgroundColor: const Color(0xFF6A4C93),
        child: const Icon(Icons.add, color: Colors.white),
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
              const SizedBox(height: 8),
              Text(
                "Gerencie seus serviços",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              _buildServiceLimitBadge(),
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
    final totalServices = _services.length;
    final todayServices = _services.where((s) => s.isToday).length;
    final upcomingServices = _services.where((s) => s.isFuture).length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(
          icon: Icons.event,
          value: totalServices.toString(),
          label: "Total",
          color: const Color(0xFF4ECDC4),
        ),
        _buildStatItem(
          icon: Icons.today,
          value: todayServices.toString(),
          label: "Hoje",
          color: const Color(0xFFFFE66D),
        ),
        _buildStatItem(
          icon: Icons.schedule,
          value: upcomingServices.toString(),
          label: "Próximos",
          color: const Color(0xFF95E1D3),
        ),
      ],
    );
  }

  Widget _buildServiceLimitBadge() {
    return FutureBuilder<bool>(
      future: SubscriptionService.instance.hasActiveSubscription(),
      builder: (context, snapshot) {
        // Se tem subscrição ativa, não mostra nada
        if (snapshot.data == true) {
          return const SizedBox.shrink();
        }

        final servicesUsed = _services.length;
        final servicesRemaining = 5 - servicesUsed;
        final isNearLimit = servicesRemaining <= 2;
        final isAtLimit = servicesRemaining <= 0;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isAtLimit 
              ? Colors.red.withOpacity(0.2)
              : isNearLimit 
                ? Colors.orange.withOpacity(0.2)
                : Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isAtLimit 
                ? Colors.red
                : isNearLimit 
                  ? Colors.orange
                  : Colors.white.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isAtLimit ? Icons.block : Icons.info_outline,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                isAtLimit
                  ? 'Limite atingido • Faça assinatura para continuar'
                  : 'Plano Gratuito: $servicesUsed/5 serviços usados',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(
          icon: Icons.attach_money,
          value: "MZN ${totalRevenue.toStringAsFixed(0)}",
          label: "Recebido",
          color: const Color(0xFF4ECDC4),
        ),
        _buildStatItem(
          icon: Icons.pending,
          value: "MZN ${pendingRevenue.toStringAsFixed(0)}",
          label: "Pendente",
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

  Widget _buildServicesList() {
    if (filteredServices.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: filteredServices.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final service = filteredServices[index];
        return _buildServiceCard(service);
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
              Icons.event_note,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Nenhum serviço encontrado",
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

  Widget _buildServiceCard(Service service) {
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
              gradient: _getStatusGradient(service.status),
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
                  child: Icon(
                    Service.getStatusIcon(service.status),
                    color: Colors.white,
                    size: 28,
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
                              service.title,
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
                              service.status.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.person, color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              service.clientName,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white, size: 24),
                  onPressed: () => _editService(service),
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
                        label: "Valor",
                        value: "MZN ${service.price.toStringAsFixed(0)}",
                        color: const Color(0xFF6A4C93),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.category,
                        label: "Categoria",
                        value: service.category,
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
                        label: "Data",
                        value: _formatDate(service.date),
                        color: const Color(0xFFFFE66D),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.schedule,
                        label: "Horário",
                        value: "${service.time.hour.toString().padLeft(2, '0')}:${service.time.minute.toString().padLeft(2, '0')}",
                        color: const Color(0xFFFF6B6B),
                      ),
                    ),
                  ],
                ),

                if (service.description != null && service.description!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Descrição",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C2C2C),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          service.description!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Localização
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6A4C93).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF6A4C93),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          service.location,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6A4C93),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                              'Contato',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // const SizedBox(width: 12),
                    // Expanded(
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: const Color(0xFF6A4C93),
                    //       foregroundColor: Colors.white,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(15),
                    //       ),
                    //       padding: const EdgeInsets.symmetric(vertical: 12),
                    //       elevation: 0,
                    //     ),
                    //     onPressed: () {},
                    //     child: const Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Icon(Icons.check_circle, size: 20),
                    //         SizedBox(width: 8),
                    //         Text(
                    //           'Concluir',
                    //           style: TextStyle(fontWeight: FontWeight.bold),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
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

  LinearGradient _getStatusGradient(String status) {
    switch (status) {
      case 'pendente':
        return const LinearGradient(
          colors: [Color(0xFFFFE66D), Color(0xFFFFED88)],
        );
      case 'confirmado':
        return const LinearGradient(
          colors: [Color(0xFF4ECDC4), Color(0xFF7BDBD4)],
        );
      case 'em_andamento':
        return const LinearGradient(
          colors: [Color(0xFF6A4C93), Color(0xFF8E44AD)],
        );
      case 'concluido':
        return const LinearGradient(
          colors: [Color(0xFF95E1D3), Color(0xFFB8E6D3)],
        );
      case 'cancelado':
        return const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8A8A)],
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF6A4C93), Color(0xFF8E44AD)],
        );
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return "Hoje";
    } else if (difference == 1) {
      return "Ontem";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }

  void _showSubscriptionRequiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE66D).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline,
                color: Color(0xFF6A4C93),
                size: 32,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Limite Atingido',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Você atingiu o limite de 5 serviços do plano gratuito.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6A4C93), Color(0xFF8E44AD)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Com a assinatura, você terá:',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBenefitItem('✓ Serviços ilimitados'),
                  _buildBenefitItem('✓ Gestão completa de clientes'),
                  _buildBenefitItem('✓ Relatórios avançados'),
                  _buildBenefitItem('✓ Suporte prioritário'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Voltar',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navegar para tela de subscrição
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SubscriptionScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6A4C93),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Fazer Assinatura',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
        ),
      ),
    );
  }
}