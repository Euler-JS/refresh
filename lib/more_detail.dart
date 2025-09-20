import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_app_ui/Model/model.dart';

class MoreDetail extends StatelessWidget {
  const MoreDetail({super.key, required this.location});
  final LocationDetail location;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: location.image,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.38,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(location.image),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(70),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 40,
                            left: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  location.name,
                                  style: const TextStyle(
                                    fontSize: 26,
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
                                    const Icon(Icons.location_on, size: 20, color: Colors.white),
                                    const SizedBox(width: 4),
                                    Text(
                                      location.address,
                                      style: const TextStyle(
                                        fontSize: 16,
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 40,
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
                          Positioned(
                            top: 40,
                            left: 0,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ratingandMore(),
                    const SizedBox(height: 32),
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      location.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 231, 178, 200),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Text(
                          "\$ ${location.price}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD38CAB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                            elevation: 0,
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Book Now",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: const AssetImage("Images/as.jpeg"),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: const AssetImage("Images/aa.png"),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: const AssetImage("Images/ab.jpeg"),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(0xFFD38CAB),
                          child: const Text(
                            "28+",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Recommended",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding ratingandMore() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star,
            color: Colors.amber[900],
            size: 30,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            location.rating.toString(),
            style: const TextStyle(fontSize: 20, color: Color(0xFFB07C97)),
          ),
          const SizedBox(
            width: 30,
          ),
          const Icon(
            Icons.cloud,
            color: Colors.blue,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            "${location.temperature}°C",
            style: const TextStyle(fontSize: 20, color: Colors.blue),
          ),
          const SizedBox(
            width: 30,
          ),
          const Icon(Icons.watch_later_rounded, color: Color(0xFFB07C97)),
          const SizedBox(
            width: 7,
          ),
          Text(
            "${location.time} Day",
            style: const TextStyle(fontSize: 20, color: Color(0xFFB07C97)),
          )
        ],
      ),
    );
  }
}
