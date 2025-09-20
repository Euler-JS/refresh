import 'package:flutter/material.dart';

class PopularCategories extends StatelessWidget {
  const PopularCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Popular Categories",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                "See All",
                style: TextStyle(fontSize: 14, color: Color(0xFFA36C88)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _categoryCard("Images/beatch.png", "Beach", const Color(0xFFF8CDEC)),
                _categoryCard("Images/camping.png", "Camping", const Color(0xFF9ED2F7)),
                _categoryCard("Images/car.png", "Car", const Color(0xFfcbb8ef)),
                _categoryCard("Images/food.png", "Food", const Color(0xFFFacdcc)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryCard(String image, String label, Color color) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.25),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Image.asset(image, height: 36),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFFB07C97),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
