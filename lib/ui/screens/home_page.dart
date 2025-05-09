import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plants_app/constants/constants.dart';
import 'package:plants_app/models/plants.dart';
import 'package:plants_app/ui/screens/detail_page.dart';
import 'package:plants_app/ui/screens/widgets/plant_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  List<Plant> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = Plant.plantList;
  }

  void _filterPlants(String query) {
    final List<Plant> results =
        Plant.plantList.where((plant) {
          final plantName = plant.plantName.toLowerCase();
          final input = query.toLowerCase();
          return plantName.contains(input);
        }).toList();

    setState(() {
      filteredList = results;
    });
  }

  bool toggleIsFavorated(bool isFavorited) {
    return !isFavorited;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    width: size.width * .9,
                    decoration: BoxDecoration(
                      color: Constants.primaryColor.withOpacity(.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.black54.withOpacity(.6),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: _filterPlants,
                            showCursor: false,
                            decoration: const InputDecoration(
                              hintText: 'Search Plant',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Spacer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 50.0,
              width: size.width,
            ),
            // Horizontal plant list with animation
            SizedBox(
              height: size.height * .32,
              child: AnimationLimiter(
                child: ListView.builder(
                  itemCount: filteredList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: DetailPage(
                                    plantId: filteredList[index].plantId,
                                  ),
                                  type: PageTransitionType.bottomToTop,
                                ),
                              );
                            },
                            child: Container(
                              width: 200,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Constants.primaryColor.withOpacity(.8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 10,
                                    right: 20,
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            bool isFavorited =
                                                toggleIsFavorated(
                                                  filteredList[index]
                                                      .isFavorated,
                                                );
                                            filteredList[index].isFavorated =
                                                isFavorited;
                                          });
                                        },
                                        icon: Icon(
                                          filteredList[index].isFavorated
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Constants.primaryColor,
                                        ),
                                        iconSize: 30,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: 200,
                                      height: 200,
                                      child: Image.asset(
                                        filteredList[index].imageURL,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 15,
                                    left: 20,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          filteredList[index].category,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          filteredList[index].plantName,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // New Plants title
            Container(
              padding: const EdgeInsets.only(left: 16, bottom: 20, top: 20),
              child: const Text(
                'New Plants',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
            // Vertical plant list with animation
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: size.height * .5,
              child: AnimationLimiter(
                child: ListView.builder(
                  itemCount: filteredList.length,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 400),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: DetailPage(
                                    plantId: filteredList[index].plantId,
                                  ),
                                  type: PageTransitionType.bottomToTop,
                                ),
                              );
                            },
                            child: PlantWidget(
                              index: index,
                              plantList: filteredList,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
