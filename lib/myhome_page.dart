import 'package:flutter/material.dart';
import 'package:travel_app_ui/Model/model.dart';
import 'package:travel_app_ui/more_detail.dart';
import 'package:travel_app_ui/popular_cate.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

int seletedIndex = 0;
List<String> categoryList = [
  "Best nature",
  "Most viewed",
  "Recommend",
  "Newly discover",
  "Peace",
];

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFFFBFB), Color(0XFFF3ECEE)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(70),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset("Images/grid.png", height: 30),
                          Image.asset("Images/search.png", height: 30),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        "Descover",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      natureSelection(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 410,
                child: ListView.builder(
                  itemCount: locationItems.length,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    LocationDetail location = locationItems[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoreDetail(location: location),
                          ),
                        );
                      },
                      child: Container(
                        width: 260,
                        margin: EdgeInsets.only(right: index == locationItems.length - 1 ? 0 : 18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          image: DecorationImage(
                            image: AssetImage(location.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 24,
                              left: 20,
                              right: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    location.name,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 18, color: Colors.white),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          location.address,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black26,
                                                blurRadius: 6,
                                              ),
                                            ],
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
                            Positioned(
                              top: 24,
                              right: 20,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white38,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(Icons.bookmark, size: 22, color: Colors.white),
                              ),
                            ),
                            // Adicione mais elementos visuais conforme necessário
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0XFFF3ECEE), Color(0xFFFFFBFB)],
                  ),
                ),
                child: const PopularCategories(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Positioned bestNatureSlider(LocationDetail location) {
    return Positioned(
      top: 320,
      left: 100,
      child: Column(
        children: [
          Text(
            location.name,
            style: const TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 30,
                color: Colors.white,
              ),
              Text(
                location.address,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ],
          )
        ],
      ),
    );
  }

  Stack natureSelection() {
    return Stack(
      children: [
        const Positioned(
            bottom: -10,
            left: 45,
            child: Text(
              ".",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Color(0xFFA36C88)),
            )),
        SizedBox(
          height: 40,
          child: ListView.builder(
            itemCount: categoryList.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  categoryList[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: seletedIndex == index
                        ? const Color(0xFFA36C88)
                        : const Color(0xFFE2CBD4),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
