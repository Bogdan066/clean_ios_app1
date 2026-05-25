class Product {
  final String name;
  bool isAdded;

  Product({required this.name, this.isAdded = false});
}

class CartState {
  static final CartState _instance = CartState._internal();
  factory CartState() => _instance;
  CartState._internal();

  List<Product> addedProducts = [];

  void toggleProduct(String name) {
    int index = addedProducts.indexWhere((p) => p.name == name);

    if (index != -1) {
      addedProducts.removeAt(index);
    } else {
      addedProducts.add(Product(name: name, isAdded: true));
    }
  }
}
