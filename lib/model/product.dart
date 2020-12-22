class Product {

  int amountOfProduct;
  int demandOfProduct;
  int productId;

  Product(int demandOfProduct, int productId) {
    this.demandOfProduct = demandOfProduct;
    this.amountOfProduct = 0;
    this.productId = productId;
  }

  int getAmountOfProduct() {
    return amountOfProduct;
  }

  int getProductId() {
    return productId;
  }

  void setAmountOfProduct(int amountOfProduct) {
    this.amountOfProduct = amountOfProduct;
  }

  int getDemandOfProduct() {
    return demandOfProduct;
  }

  void setDemandOfProduct(int demandOfProduct) {
    this.demandOfProduct = demandOfProduct;
  }

  void incrementAmountOfProduct() {
    this.amountOfProduct = this.amountOfProduct + 1;
  }
}
