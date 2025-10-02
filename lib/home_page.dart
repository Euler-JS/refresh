import 'package:flutter/material.dart';
import 'Model/service_models.dart';
import 'screens/payments_page.dart';
import 'screens/schedule_page.dart';
import 'widgets/service_card.dart';
import 'widgets/stats_section.dart';
import 'widgets/quick_actions.dart';
import 'utils/responsive_text.dart';

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
    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    
    // Calculate responsive heights - adjusted for filters
    final topSectionHeight = screenHeight * 0.65;  // 65% of screen height
    final bottomSectionHeight = screenHeight * 0.35; // 35% of screen height
    final serviceCardsTop = topSectionHeight * 0.50; // Position cards higher on the screen
    
    return Scaffold(
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Stack(
          children: [
            // Top background with gradient
            Container(
              height: topSectionHeight,
              width: screenWidth,
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
                  bottomLeft: Radius.circular(36), // More subtle curve
                  bottomRight: Radius.circular(36)
                )
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      
                      // Header
                      _buildHeader(),
                      SizedBox(height: screenHeight * 0.015), // 1.5% of screen height - reduced
                      
                      // Greeting and Status
                      // _buildGreetingSection(),
                      SizedBox(height: screenHeight * 0.02), // 2% of screen height - reduced
                      
                      // Stats section
                      _buildStatsSection(),
                      SizedBox(height: screenHeight * 0.02), // Space between stats and filters
                      
                      // Category filters
                      _buildFilterChips(),
                    ],
                  ),
                ),
              ),
            ),
            
            // Service cards section (responsive positioning)
            Positioned(
              top: serviceCardsTop,
              left: 0,
              right: 0,
              bottom: bottomSectionHeight, // Anchor to the bottom section to avoid overlap
              child: filteredServices.isEmpty 
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: filteredServices.length,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03), // Responsive padding
                    clipBehavior: Clip.none, // Allow cards to overflow if needed
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      ServiceItem service = filteredServices[index];
                      return ServiceCard(service: service);
                    },
                  ),
            ),
            
            // Bottom section (quick actions) - adjusted 20% lower
            Positioned(
              bottom: -(screenHeight * 0.06), // Push down by 20% of the original height (35% * 0.2 = 7%)
              left: 0,
              right: 0,
              height: (bottomSectionHeight * 1.2) + (safeAreaBottom > 0 ? safeAreaBottom : 0), // Increase height by 20%
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(36), // Match top section curve
                    topRight: Radius.circular(36),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, -2),
                      blurRadius: 6,
                    )
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.07), // Add padding at the top to compensate for the shift
                  child: const QuickActions(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    String message = _getEmptyMessage();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.08), // 8% of screen width
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth * 0.05), // 5% of screen width
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                _getEmptyIcon(),
                size: screenWidth * 0.12, // 12% of screen width
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // 2% of screen height
            Text(
              message,
              style: ResponsiveText.style(
                context: context,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.01), // 1% of screen height
            Text(
              "Experimente outro filtro",
              style: ResponsiveText.style(
                context: context,
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
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final avatarSize = screenWidth * 0.1; // 10% of screen width for avatar
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            // Navigate to profile/settings
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: avatarSize / 2,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Text(
                  "M",
                  style: ResponsiveText.style(
                    context: context,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.02), // 2% of screen width
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02, // 2% of screen width
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Perfil",
                  style: ResponsiveText.style(
                    context: context,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(screenWidth * 0.02), // 2% of screen width
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: screenWidth * 0.06, // 6% of screen width
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: screenWidth * 0.02, // 2% of screen width
                  height: screenWidth * 0.02, // 2% of screen width
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
        Text(
          "Olá, Maria! 👋",
          style: ResponsiveText.style(
            context: context,
            fontSize: 28, // Larger font size to match design
            fontWeight: FontWeight.w700, // Slightly lighter weight to match design
            color: Colors.white,
            letterSpacing: 0.2, // Add slight letter spacing for better readability
          ),
        ),
        const SizedBox(height: 6),
        Text(
          greeting,
          style: ResponsiveText.style(
            context: context,
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
    // Get screen width to make the cards appropriately sized
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 50) / 3; // Account for margins
    
    return Container(
      width: cardWidth,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.02, // Further reduced horizontal padding
        vertical: 6, // Half the vertical padding
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14), // Slightly smaller radius
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4, // Smaller blur
            offset: const Offset(0, 1), // Smaller offset
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon on left side
          Container(
            padding: const EdgeInsets.all(4), // Smaller padding
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 16), // Smaller icon
          ),
          // Text on right side
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: ResponsiveText.style(
                    context: context,
                    fontSize: 16, // Smaller font
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      const Shadow(
                        color: Colors.black26,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                Text(
                  title,
                  style: ResponsiveText.style(
                    context: context,
                    fontSize: 10, // Smaller font
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    shadows: [
                      const Shadow(
                        color: Colors.black26,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filters label
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Filtrar por:",
              style: ResponsiveText.style(
                context: context,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            if (selectedIndex != 0) // Show "Ver todos" button if not on default filter
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                },
                child: Text(
                  "Ver todos",
                  style: ResponsiveText.style(
                    context: context,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        
        // Filter chips - horizontal scrolling row
        SizedBox(
          height: 34, // Fixed height for filters
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoryList.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              bool isSelected = selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        categoryList[index],
                        style: ResponsiveText.style(
                          context: context,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? const Color(0xFF6A4C93) : Colors.white,
                        ),
                      ),
                      if (isSelected && filteredServices.isNotEmpty) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6A4C93),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            filteredServices.length.toString(),
                            style: ResponsiveText.style(
                              context: context,
                              fontSize: 10,
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
        ),
      ],
    );
  }

  // End of the class
}