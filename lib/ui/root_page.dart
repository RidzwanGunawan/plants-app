import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plants_app/constants/constants.dart';
import 'package:plants_app/models/plants.dart';
import 'package:plants_app/ui/chat_bot.dart';
import 'package:plants_app/ui/screens/cart_page.dart';
import 'package:plants_app/ui/screens/favorite_page.dart';
import 'package:plants_app/ui/screens/home_page.dart';
import 'package:plants_app/ui/screens/notification_page.dart';
import 'package:plants_app/ui/screens/profile_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  List<Plant> favorites = [];
  List<Plant> myCart = [];

  int _bottomNavIndex = 0;

  //List of the pages
  List<Widget> _widgetOptions() {
    return [
      const HomePage(),
      FavoritePage(favoritedPlants: favorites),
      CartPage(addedToCartPlants: myCart),
      const ProfilePage(),
    ];
  }

  //List of the pages icons
  List<IconData> iconList = [
    Icons.home,
    Icons.favorite,
    Icons.shopping_cart,
    Icons.person,
  ];

  //List of the pages titles
  List<String> titleList = ['Home', 'Favorite', 'Cart', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              titleList[_bottomNavIndex],
              style: TextStyle(
                color: Constants.blackColor,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              color: Constants.blackColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationPage(),
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
      ),
      body: IndexedStack(index: _bottomNavIndex, children: _widgetOptions()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              child: ChatbotPage(),
              type: PageTransitionType.bottomToTop,
            ),
          );
        },
        backgroundColor: Colors.grey,
        child: Image.asset('assets/images/bot.png', height: 30.0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        splashColor: Constants.primaryColor,
        activeColor: Constants.primaryColor,
        inactiveColor: Colors.black.withOpacity(.5),
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
            final List<Plant> favoritedPlants = Plant.getFavoritedPlants();
            final List<Plant> addedToCartPlants = Plant.addedToCartPlants();

            favorites = favoritedPlants;
            myCart = addedToCartPlants.toSet().toList();
          });
        },
      ),
    );
  }
}
