import 'package:flutter/material.dart';
import '../utils/responsive_text.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.045, 
        vertical: screenHeight * 0.02
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Ações Rápidas",
            style: ResponsiveText.style(
              context: context,
              fontSize: 22, // Larger font size to match design
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2C2C2C),
              letterSpacing: 0.1, // Slight letter spacing for better readability
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          SizedBox(
            height: screenHeight * 0.11, // 11% of screen height
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildActionCard(
                  context: context,
                  icon: Icons.event_note,
                  title: "Serviços",
                  color: const Color(0xFF6A4C93),
                  onTap: () {
                    Navigator.pushNamed(context, '/services');
                  },
                ),
                _buildActionCard(
                  context: context,
                  icon: Icons.calendar_today,
                  title: "Minha Agenda",
                  color: const Color(0xFF4ECDC4),
                  onTap: () {
                    Navigator.pushNamed(context, '/schedule');
                  },
                ),
                _buildActionCard(
                  context: context,
                  icon: Icons.attach_money,
                  title: "Receber",
                  color: const Color(0xFFFFE66D),
                  onTap: () {
                    Navigator.pushNamed(context, '/payments');
                  },
                ),
                _buildActionCard(
                  context: context,
                  icon: Icons.people,
                  title: "Clientes",
                  color: const Color(0xFFFF6B6B),
                  onTap: () {
                    Navigator.pushNamed(context, '/clients');
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.018),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/public-schedule');
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04, 
                vertical: screenHeight * 0.015
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6A4C93), Color(0xFF8E44AD)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.visibility,
                      color: Colors.white,
                      size: screenWidth * 0.055,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Link da Agenda Pública",
                          style: ResponsiveText.style(
                            context: context,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: screenHeight * 0.003),
                        Text(
                          "Compartilhe com seus clientes",
                          style: ResponsiveText.style(
                            context: context,
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.018),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.share,
                      color: Colors.white,
                      size: screenWidth * 0.045,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardWidth = screenWidth * 0.2; // 20% of screen width to fit more closely
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        margin: EdgeInsets.only(right: screenWidth * 0.025),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // Rounder corners to match design
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08), // Lighter shadow
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: cardWidth * 0.5,
              height: cardWidth * 0.5,
              margin: EdgeInsets.only(
                top: screenHeight * 0.014, 
                bottom: screenHeight * 0.006
              ),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12), // Lighter background to match design
                borderRadius: BorderRadius.circular(15), // Rounder corners
              ),
              child: Icon(
                icon,
                color: color,
                size: cardWidth * 0.28, // Slightly larger icon
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.015),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: ResponsiveText.style(
                    context: context,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color,
                    height: 1.2,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
          ],
        ),
      ),
    );
  }
}