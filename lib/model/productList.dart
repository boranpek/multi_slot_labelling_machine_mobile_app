import 'product.dart';

class ProductList {
  static List products = new List();

  static List getProducts() {
    return products;
  }

  static void addProduct(Product product) {
    products.add(product);
  }

  static int getProductsNumber() {
    return products.length;
  }
}
