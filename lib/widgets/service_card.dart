import 'package:flutter/material.dart';
import '../Model/service_models.dart';
import '../utils/responsive_text.dart';

class ServiceCard extends StatelessWidget {
  final ServiceItem service;
  
  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.75; // 75% of screen width to match design
    final cardHeight = cardWidth * 1.05; // Lower aspect ratio to match design
    
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/service-detail', arguments: service);
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02), // 2% of screen width for closer cards
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header do card com status
            Container(
              padding: EdgeInsets.all(screenWidth * 0.04), // 4% of screen width
              decoration: BoxDecoration(
                gradient: _getStatusGradient(),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.025,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getStatusText(),
                            style: ResponsiveText.style(
                              context: context,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.015),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.bookmark_border,
                          color: Colors.white,
                          size: screenWidth * 0.045,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: cardHeight * 0.02),
                  Text(
                    service.serviceType,
                    style: ResponsiveText.style(
                      context: context,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: cardHeight * 0.01),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.white,
                        size: screenWidth * 0.04,
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Expanded(
                        child: Text(
                          service.clientName,
                          style: ResponsiveText.style(
                            context: context,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Corpo do card
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: const Color(0xFF6A4C93),
                          size: screenWidth * 0.04,
                        ),
                        SizedBox(width: screenWidth * 0.01),
                        Expanded(
                          child: Text(
                            service.location,
                            style: ResponsiveText.style(
                              context: context,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF6A4C93),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: cardHeight * 0.02),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: const Color(0xFF999999),
                          size: screenWidth * 0.04,
                        ),
                        SizedBox(width: screenWidth * 0.01),
                        Expanded(
                          child: Text(
                            "${_formatDate(service.date)} às ${service.time}",
                            style: ResponsiveText.style(
                              context: context,
                              fontSize: 13,
                              color: const Color(0xFF999999),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: cardHeight * 0.025),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            "MZN ${service.price.toStringAsFixed(0)}",
                            style: ResponsiveText.style(
                              context: context,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6A4C93),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/service-detail', arguments: service);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03,
                              vertical: screenWidth * 0.015,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6A4C93),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "Detalhes",
                              style: ResponsiveText.style(
                                context: context,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _getStatusGradient() {
    switch (service.status) {
      case ServiceStatus.pending:
        return const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ServiceStatus.confirmed:
        return const LinearGradient(
          colors: [Color(0xFF4ECDC4), Color(0xFF7BDBD4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ServiceStatus.inProgress:
        return const LinearGradient(
          colors: [Color(0xFFFFE66D), Color(0xFFFFED88)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ServiceStatus.completed:
        return const LinearGradient(
          colors: [Color(0xFF95E1D3), Color(0xFFB8E6D3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF4ECDC4), Color(0xFF7BDBD4)], // Using teal for default to match screenshot
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  String _getStatusText() {
    switch (service.status) {
      case ServiceStatus.pending:
        return "Pendente";
      case ServiceStatus.confirmed:
        return "Confirmado";
      case ServiceStatus.inProgress:
        return "Em Andamento";
      case ServiceStatus.completed:
        return "Concluído";
      case ServiceStatus.cancelled:
        return "Cancelado";
      case ServiceStatus.overdue:
        return "Atrasado";
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final serviceDate = DateTime(date.year, date.month, date.day);
    
    if (serviceDate == today) {
      return "Hoje";
    } else if (serviceDate == today.add(const Duration(days: 1))) {
      return "Amanhã";
    } else {
      return "${date.day}/${date.month}";
    }
  }
}