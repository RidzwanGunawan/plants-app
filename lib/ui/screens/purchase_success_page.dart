import 'package:flutter/material.dart';
import 'package:plants_app/constants/constants.dart';
import 'package:plants_app/models/plants.dart';

class PurchaseSuccessPage extends StatefulWidget {
  final Plant plant;

  const PurchaseSuccessPage({super.key, required this.plant});

  @override
  State<PurchaseSuccessPage> createState() => _PurchaseSuccessPageState();
}

class _PurchaseSuccessPageState extends State<PurchaseSuccessPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _animationController.forward();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: const BoxDecoration(),
        child: Center(
          child:
              _isLoading
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(color: Colors.green),
                      SizedBox(height: 20),
                      Text(
                        'Memproses pembayaran...',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  )
                  : FadeTransition(
                    opacity: _scaleAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.green,
                            size: 100,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Pembelian Berhasil!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.plant.plantName.isNotEmpty
                                ? '${widget.plant.plantName} berhasil dibeli.'
                                : 'Plant tidak ditemukan.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed:
                                () => Navigator.popUntil(
                                  context,
                                  (route) => route.isFirst,
                                ),
                            style: ElevatedButton.styleFrom(
                              elevation: 6,
                              backgroundColor: Constants.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 14,
                              ),
                            ),
                            child: const Text(
                              'Kembali ke Beranda',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
