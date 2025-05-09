import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plants_app/constants/constants.dart';
import 'package:plants_app/models/plants.dart';
import 'purchase_success_page.dart'; // Tambahkan ini

class DetailPage extends StatefulWidget {
  final int plantId;

  const DetailPage({Key? key, required this.plantId}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  List<Plant> cartItems = [];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final plant = Plant.plantList[widget.plantId];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildTopBar(context, plant),
          _buildDetailBottom(size, plant),
          _buildPlantImage(size, plant),
        ],
      ),
      floatingActionButton: _buildBottomBar(size, plant),
    );
  }

  Widget _buildTopBar(BuildContext context, Plant plant) {
    return Positioned(
      top: 70,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(
            Icons.arrow_back_ios_new,
            () => Navigator.pop(context),
          ),
          _buildIconButton(
            plant.isFavorated ? Icons.favorite : Icons.favorite_border,
            () {
              setState(() {
                plant.isFavorated = !plant.isFavorated;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlantImage(Size size, Plant plant) {
    return Positioned(
      top: 150,
      left: 20,
      right: 20,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width * 0.6,
                height: 380,
                child: Image.asset(
                  plant.imageURL,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeatureCard(Icons.straighten, "Size", plant.size),
                  _buildFeatureCard(
                    Icons.water_drop,
                    "Humidity",
                    '${plant.humidity}%',
                  ),
                  _buildFeatureCard(
                    Icons.thermostat,
                    "Temp",
                    plant.temperature,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Constants.primaryColor.withOpacity(.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Constants.primaryColor, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailBottom(Size size, Plant plant) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            height: size.height * .45,
            decoration: BoxDecoration(
              color: Constants.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopInfo(plant),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      plant.decription,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        height: 2,
                        fontSize: 16,
                        color: Color.fromARGB(255, 1, 0, 0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopInfo(Plant plant) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Tooltip(
                message: plant.plantName,
                child: Text(
                  plant.plantName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'Rp. ${NumberFormat('#,##0', 'id_ID').format(plant.price)}',
                style: const TextStyle(fontSize: 20, color: Colors.black54),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Text('${plant.rating}', style: const TextStyle(fontSize: 22)),
            const Icon(Icons.star, color: Colors.amber),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomBar(Size size, Plant plant) {
    return Container(
      width: size.width * 0.9,
      height: 50,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                plant.isSelected = !plant.isSelected;
              });
            },
            child: Container(
              width: 50,
              decoration: BoxDecoration(
                color: plant.isSelected ? Constants.primaryColor : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Constants.primaryColor, width: 2),
              ),
              child: Icon(
                Icons.shopping_cart,
                color: plant.isSelected ? Colors.white : Constants.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Konfirmasi Pembelian'),
                    content: Text(
                        'Apakah kamu yakin ingin membeli ${plant.plantName}?'),
                    actions: [
                      TextButton(
                        child: const Text('Batal'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text('Iya'),
                        onPressed: () {
                          Navigator.of(context).pop();

                          setState(() {
                            cartItems.add(plant);
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PurchaseSuccessPage(plant: plant),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                'BUY NOW',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Constants.primaryColor.withOpacity(.15),
      ),
      child: IconButton(
        icon: Icon(icon, color: Constants.primaryColor, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}
