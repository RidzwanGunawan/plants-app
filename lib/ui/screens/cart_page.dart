import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plants_app/constants/constants.dart';
import 'package:plants_app/models/plants.dart';
import 'package:plants_app/ui/screens/widgets/plant_widget.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:plants_app/ui/screens/purchase_success_page.dart'; // Import the PurchaseSuccessPage

class CartPage extends StatefulWidget {
  final List<Plant> addedToCartPlants;

  const CartPage({super.key, required this.addedToCartPlants});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<void> _showCheckoutConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Checkout'),
          content: const Text(
            'Lanjutkan untuk menyelesaikan pembelian dan menerima konfirmasi?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleCheckout();
              },
              child: const Text('Lanjutkan'),
            ),
          ],
        );
      },
    );
  }

  void _handleCheckout() {
    for (var plant in widget.addedToCartPlants) {
      plant.isSelected = false;
    }

    Flushbar(
      message: "Checkout berhasil! Terima kasih 😊",
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);

    setState(() {
      widget.addedToCartPlants.clear();
    });

    // Pass the selected plant to PurchaseSuccessPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => PurchaseSuccessPage(
              plant:
                  widget.addedToCartPlants.isNotEmpty
                      ? widget.addedToCartPlants[0]
                      : Plant(
                        plantId: 0,
                        plantName: 'Default Plant',
                        price: 0,
                        category: 'Default Category',
                        size: 'Medium',
                        rating: 0.0,
                        humidity: 0,
                        temperature: 'Unknown',
                        imageURL: '',
                        isFavorated: false,
                        decription: 'No description available.',
                        isSelected: false,
                      ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    int totalPrice = widget.addedToCartPlants.fold(
      0,
      (sum, item) => sum + item.price,
    );

    return Scaffold(
      body:
          widget.addedToCartPlants.isEmpty
              ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      child: Image.asset('assets/images/add-cart.png'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your Cart is Empty',
                      style: TextStyle(
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              )
              : Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 30,
                ),
                height: size.height,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.addedToCartPlants.length,
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return PlantWidget(
                            index: index,
                            plantList: widget.addedToCartPlants,
                          );
                        },
                      ),
                    ),
                    Column(
                      children: [
                        const Divider(thickness: 1.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Totals',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              'Rp. ${NumberFormat('#,##0', 'id_ID').format(totalPrice)}',
                              style: TextStyle(
                                fontSize: 24.0,
                                color: Constants.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _showCheckoutConfirmationDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Constants.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                            ),
                            child: const Text(
                              "Checkout",
                              style: TextStyle(
                                fontSize: 18,
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
    );
  }
}
