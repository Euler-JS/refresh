import 'package:flutter/material.dart';
import 'package:travel_app_ui/Model/service_models.dart';
import 'package:travel_app_ui/screens/payments_page.dart';
import 'package:travel_app_ui/screens/schedule_page.dart';
import 'widgets/service_card.dart';
import 'widgets/stats_section.dart';
import 'widgets/quick_actions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  List<String> categoryList = [
    "Hoje",
    "Esta Semana", 
    "Próximos",
    "Atrasados",
    "Concluídos",
  ];

  List<ServiceItem> get filteredServices {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    switch (selectedIndex) {
      case 0: // Hoje
        return serviceItems.where((service) {
          final serviceDate = DateTime(service.date.year, service.date.month, service.date.day);
          return serviceDate == today;
        }).toList();
        
      case 1: // Esta Semana
        return serviceItems.where((service) {
          final serviceDate = DateTime(service.date.year, service.date.month, service.date.day);
          return serviceDate.isAfter(weekStart.subtract(const Duration(days: 1))) && 
                 serviceDate.isBefore(weekEnd.add(const Duration(days: 1)));
        }).toList();
        
      case 2: // Próximos
        return serviceItems.where((service) {
          final serviceDate = DateTime(service.date.year, service.date.month, service.date.day);
          return serviceDate.isAfter(today);
        }).toList();
        
      case 3: // Atrasados
        return serviceItems.where((service) {
          final serviceDate = DateTime(service.date.year, service.date.month, service.date.day);
          return serviceDate.isBefore(today) && 
                 service.status != ServiceStatus.completed;
        }).toList();
        
      case 4: // Concluídos
        return serviceItems.where((service) {
          return service.status == ServiceStatus.completed;
        }).toList();
        
      default:
        return serviceItems;
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
            // Fundo superior com gradiente
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 1.35,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF6A4C93),
                        Color(0xFF8E44AD),
                        Color(0xFFA569BD),
                      ]
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40)
                    )
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          
                          // Header
                          _buildHeader(),
                          const SizedBox(height: 16),
                          
                          // Greeting e Status
                          _buildGreetingSection(),
                          const SizedBox(height: 20),
                          
                          // Estatísticas rápidas
                          _buildStatsSection(),
                          const SizedBox(height: 20),
                          
                          // Filtros de categoria
                          _buildCategoryFilter(),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Cards de serviços (posição ajustada)
                Positioned(
                  top: 390,
                  child: SizedBox(
                    height: 280,
                    width: MediaQuery.of(context).size.width,
                    child: filteredServices.isEmpty 
                      ? _buildEmptyState()
                      : ListView.builder(
                          itemCount: filteredServices.length,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemBuilder: (context, index) {
                            ServiceItem service = filteredServices[index];
                            return ServiceCard(service: service);
                          },
                        ),
                  ),
                ),
              ],
            ),
            
            // Seção inferior (altura ajustada)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height / 3.8,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: const QuickActions(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    String message = _getEmptyMessage();
    
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                _getEmptyIcon(),
                size: 48,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Experimente outro filtro",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getEmptyMessage() {
    switch (selectedIndex) {
      case 0:
        return "Nenhum atendimento hoje";
      case 1:
        return "Nenhum atendimento esta semana";
      case 2:
        return "Nenhum atendimento próximo";
      case 3:
        return "Nenhum atendimento atrasado";
      case 4:
        return "Nenhum atendimento concluído";
      default:
        return "Nenhum atendimento encontrado";
    }
  }

  IconData _getEmptyIcon() {
    switch (selectedIndex) {
      case 0:
        return Icons.today;
      case 1:
        return Icons.date_range;
      case 2:
        return Icons.schedule;
      case 3:
        return Icons.warning_amber;
      case 4:
        return Icons.check_circle_outline;
      default:
        return Icons.event_busy;
    }
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            // Navegar para perfil/configurações
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: const Text(
                  "M",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Perfil",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 24,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF6B6B),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGreetingSection() {
    String greeting = _getGreetingText();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Olá, Maria! 👋",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          greeting,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  String _getGreetingText() {
    final count = filteredServices.length;
    
    switch (selectedIndex) {
      case 0:
        return count == 0 
          ? "Nenhum atendimento hoje"
          : "Você tem $count ${count == 1 ? 'atendimento' : 'atendimentos'} hoje";
      case 1:
        return count == 0 
          ? "Nenhum atendimento esta semana"
          : "$count ${count == 1 ? 'atendimento' : 'atendimentos'} esta semana";
      case 2:
        return count == 0 
          ? "Nenhum atendimento próximo"
          : "$count ${count == 1 ? 'atendimento próximo' : 'atendimentos próximos'}";
      case 3:
        return count == 0 
          ? "Nenhum atendimento atrasado"
          : "$count ${count == 1 ? 'atendimento atrasado' : 'atendimentos atrasados'}";
      case 4:
        return count == 0 
          ? "Nenhum atendimento concluído"
          : "$count ${count == 1 ? 'atendimento concluído' : 'atendimentos concluídos'}";
      default:
        return "Você tem $count ${count == 1 ? 'atendimento' : 'atendimentos'}";
    }
  }

  Widget _buildStatsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SchedulePage(),
              ),
            );
          },
          child: _buildStatCard(
            icon: Icons.schedule,
            title: "Pendentes",
            value: "5",
            color: const Color(0xFFFF6B6B),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SchedulePage(),
              ),
            );
          },
          child: _buildStatCard(
            icon: Icons.check_circle,
            title: "Concluídos",
            value: "23",
            color: const Color(0xFF4ECDC4),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PaymentsPage(),
              ),
            );
          },
          child: _buildStatCard(
            icon: Icons.payments,
            title: "Receber",
            value: "12k",
            color: const Color(0xFFFFE66D),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        itemCount: categoryList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected 
                  ? Colors.white 
                  : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    categoryList[index],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: isSelected 
                        ? const Color(0xFF6A4C93) 
                        : Colors.white,
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6A4C93),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        filteredServices.length.toString(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}