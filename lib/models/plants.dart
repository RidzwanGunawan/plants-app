  class Plant {
    final int plantId;
    final int price;
    final String size;
    final double rating;
    final int humidity;
    final String temperature;
    final String category;
    final String plantName;
    final String imageURL;
    bool isFavorated;
    final String decription;
    bool isSelected;

    Plant({
      required this.plantId,
      required this.price,
      required this.category,
      required this.plantName,
      required this.size,
      required this.rating,
      required this.humidity,
      required this.temperature,
      required this.imageURL,
      required this.isFavorated,
      required this.decription,
      required this.isSelected,
    });

    //List of Plants data
    static List<Plant> plantList = [
      Plant(
        plantId: 0,
        price: 35000,
        category: 'Indoor',
        plantName: 'Calathea',
        size: 'Medium',
        rating: 4.2,
        humidity: 60,
        temperature: '18 - 25',
        imageURL: 'assets/images/plant-image-1.png',
        isFavorated: false,
        decription:
            'Tanaman hias indoor yang populer dengan daun bermotif unik dan menarik. Menyukai tempat teduh dan kelembaban tinggi. Cocok untuk menambah keindahan ruangan Anda.',
        isSelected: false,
      ),
      Plant(
        plantId: 1,
        price: 40000,
        category: 'Indoor',
        plantName: 'Snake Plant',
        size: 'Medium',
        rating: 4.7,
        humidity: 30,
        temperature: '18 - 35',
        imageURL: 'assets/images/plant-image-2.png',
        isFavorated: false,
        decription:
            'Tanaman hias indoor yang sangat populer dan mudah perawatannya. Dikenal juga dengan kemampuannya menyaring udara. Memiliki daun tegak berwarna hijau dengan corak belang.',
        isSelected: false,
      ),
      Plant(
        plantId: 2,
        price: 55000,
        category: 'Indoor',
        plantName: 'Rubber Plant',
        size: 'Medium',
        rating: 4.6,
        humidity: 50,
        temperature: '18 - 29',
        imageURL: 'assets/images/plant-image-3.png',
        isFavorated: false,
        decription:
            'Tanaman hias dengan daun yang lebar, tebal, dan mengkilap. Populer karena daya tarik visualnya dan relatif mudah perawatannya di dalam ruangan.',
        isSelected: false,
      ),
      Plant(
        plantId: 3,
        price: 60000,
        category: 'Indoor',
        plantName: 'Dark Leaf Rubber Plant',
        size: 'Medium',
        rating: 4.7,
        humidity: 50,
        temperature: '18 - 29',
        imageURL: 'assets/images/plant-image-4.png',
        isFavorated: false,
        decription:
            'Variasi tanaman Karet Hias dengan daun berwarna hijau tua yang mengkilap dan tumbuh lebih tegak. Cocok sebagai dekorasi interior yang elegan dan perawatannya relatif mudah.',
        isSelected: false,
      ),
      Plant(
        plantId: 4,
        price: 75000,
        category: 'Indoor & Outdoor',
        plantName: 'Pohon Pisang Hias',
        size: 'Large',
        rating: 4.5,
        humidity: 60,
        temperature: '20 - 30',
        imageURL: 'assets/images/plant-image-5.png',
        isFavorated: false,
        decription:
            'Tanaman tropis dengan daun lebar yang memberikan nuansa segar dan eksotis. Dapat ditanam di dalam maupun luar ruangan dengan perawatan yang tepat.',
        isSelected: false,
      ),
      Plant(
        plantId: 5,
        price: 45000,
        category: 'Indoor',
        plantName: 'Calathea Zebrina',
        size: 'Medium',
        rating: 4.4,
        humidity: 70,
        temperature: '18 - 25',
        imageURL: 'assets/images/plant-image-6.png',
        isFavorated: false,
        decription:
            'Tanaman hias indoor yang menarik dengan daun berwarna hijau cerah dan garis-garis seperti zebra. Membutuhkan perawatan dengan kelembaban tinggi dan cahaya tidak langsung.',
        isSelected: false,
      ),
      Plant(
        plantId: 6,
        price: 85000,
        category: 'Indoor',
        plantName: 'Monstera Deliciosa',
        size: 'Large',
        rating: 4.8,
        humidity: 60,
        temperature: '20 - 30',
        imageURL: 'assets/images/plant-image-7.png',
        isFavorated: false,
        decription:
            'Tanaman hias populer dengan daun besar yang khas, memiliki sobekan dan lubang yang unik. Memberikan kesan tropis dan elegan pada ruangan.',
        isSelected: false,
      ),
      Plant(
        plantId: 7,
        price: 30000,
        category: 'Indoor',
        plantName: 'Peperomia',
        size: 'Small',
        rating: 4.3,
        humidity: 40,
        temperature: '18 - 24',
        imageURL: 'assets/images/plant-image-8.png',
        isFavorated: false,
        decription:
            'Tanaman hias daun dengan berbagai bentuk dan warna daun yang menarik. Perawatannya relatif mudah dan cocok untuk diletakkan di dalam ruangan.',
        isSelected: false,
      ),
      Plant(
        plantId: 8,
        price: 180000,
        category: 'Indoor & Outdoor',
        plantName: 'Bonsai Ficus/Ulmus',
        size: 'Medium',
        rating: 4.8,
        humidity: 50,
        temperature: '15 - 30',
        imageURL: 'assets/images/plant-image-9.png',
        isFavorated: false,
        decription:
            'Seni menanam pohon miniatur dalam pot, menciptakan bentuk yang unik dan artistik. Membutuhkan pemangkasan dan perawatan rutin untuk mempertahankan keindahannya.',
        isSelected: false,
      ),
    ];


    //Get the favorated items
    static List<Plant> getFavoritedPlants() {
      List<Plant> travelList = Plant.plantList;
      return travelList.where((element) => element.isFavorated == true).toList();
    }

    //Get the cart items
    static List<Plant> addedToCartPlants() {
      List<Plant> selectedPlants = Plant.plantList;
      return selectedPlants
          .where((element) => element.isSelected == true)
          .toList();
    }
  }
