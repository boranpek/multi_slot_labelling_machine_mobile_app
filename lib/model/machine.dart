import 'productList.dart';
import 'product.dart';
import 'slotList.dart';

class Machine {
  static int slotNumber;
  static int numberOfSlotConfig;
  static SlotList slotList;
  static List countList = new List (numberOfSlotConfig);

  static List getCountList() {
    return countList;
  }

  static int getSlotNumber() {
    return slotNumber;
  }

  static void setSlotNumber(int slotNumber) {
    Machine.slotNumber = slotNumber;
  }

  static int getNumberOfSlotConfig() {
    return numberOfSlotConfig;
  }

  static void setNumberOfSlotConfig(int numberOfSlotConfig) {
    Machine.numberOfSlotConfig = numberOfSlotConfig;
  }

  static SlotList getSlotList() {
    return slotList;
  }

  static void setSlotList(SlotList slotList) {
    Machine.slotList = slotList;
  }

  static int calculateTotalWaste() {
    List waste = List(ProductList.getProductsNumber());
    int totalWaste = 0;
    for (int i = 0; i < ProductList.getProductsNumber(); i++) {
      waste[i] = ProductList.getProducts()[i].getAmountOfProduct() - ProductList.getProducts()[i].getDemandOfProduct();
      totalWaste = totalWaste + waste[i];
    }

    return totalWaste;
  }

  static void run(bool showSteps) {
    for(int i = 0; i < numberOfSlotConfig;i++) {
      countList[i] = 0;
    }
    bool condition1 = true;
    bool condition2 = false;

    List countProducts = new List(ProductList.getProductsNumber());
    List runIndexes = new List(ProductList.getProductsNumber());
    for(int i = 0; i < ProductList.getProductsNumber();i++) {
      countProducts[i] = 0;
    }

    var runIndexesForCondition2 = List.generate(numberOfSlotConfig, (i) => List(ProductList.getProductsNumber()), growable: false);
    for(int i = 0;i < numberOfSlotConfig;i++) {
      for(int j = 0;j < ProductList.getProductsNumber();j++) {
        runIndexesForCondition2[i][j] = 0;
      }
    }
    List max = new List(ProductList.getProductsNumber());
    for (int i = 0;i < ProductList.getProductsNumber();i++) {
      max[i] = 0;
    }
    List runIndexForMax = new List(ProductList.getProductsNumber());

    //1st step
    for(int i = 0; i < Machine.getNumberOfSlotConfig(); i++){
      for (int j = 0; j < Machine.getSlotNumber(); j++){
        for (Product product in ProductList.getProducts()) {
    if (product.getProductId() == slotList.getSlots()[i][j].getProductId()) {
    countProducts[product.getProductId()]++;
    runIndexes[product.getProductId()] = i;
    }
    }
    }
    }

    for (int i = 0; i < ProductList.getProductsNumber(); i++) {
    if (countProducts[i] == 1 && ProductList.getProducts()[i].getAmountOfProduct() < ProductList.getProducts()[i].getDemandOfProduct()) {
    while (ProductList.getProducts()[i].getAmountOfProduct() < ProductList.getProducts()[i].getDemandOfProduct()) {
    for (Product product in slotList.getSlots()[runIndexes[i]]) {
    product.incrementAmountOfProduct();
    }
    countList[runIndexes[i]]++;
    }
    }
    }

    //2nd step
    for(int i = 0; i < numberOfSlotConfig; i++){
    for (int j = 0; j < slotNumber; j++) {
    condition1 = condition1 && slotList.getSlots()[i][j].getAmountOfProduct() < slotList.getSlots()[i][j].getDemandOfProduct();
    }
    while (condition1) {
    for (Product product in slotList.getSlots()[i]){
    product.incrementAmountOfProduct();
    }
    countList[i]++;
    for (int j = 0; j < slotNumber; j++) {
    condition1 = condition1 && slotList.getSlots()[i][j].getAmountOfProduct() < slotList.getSlots()[i][j].getDemandOfProduct();
    }
    }
    condition1 = true;
    }

    //3rd step

    for (int i = 0;i < numberOfSlotConfig; i++) {
    for (int j = 0; j < slotNumber; j++) {
    if(slotList.getSlots()[i][j].getAmountOfProduct() < slotList.getSlots()[i][j].getDemandOfProduct()) {
    runIndexesForCondition2[i][slotList.getSlots()[i][j].getProductId()]++;
    }
    }
    }

    for(int i = 0;i < numberOfSlotConfig;i++) {
    for (int j = 0; j < ProductList.getProductsNumber();j++) {
    if (runIndexesForCondition2[i][j] > max[j]) {
    max[j] = runIndexesForCondition2[i][j];
    runIndexForMax[j] = i;
    }
    }
    }

    for (int i = 0;i < ProductList.getProductsNumber();i++) {
    if (max[i] > 0) {
    while (ProductList.getProducts()[i].getAmountOfProduct() < ProductList.getProducts()[i].getDemandOfProduct()) {
    for (Product product in slotList.getSlots()[runIndexForMax[i]]) {
    product.incrementAmountOfProduct();
    }
    countList[runIndexForMax[i]]++;
    }
    }
    }

    //4th step
    for (int i = numberOfSlotConfig-1; i >= 0; i--){
    for (int j = 0; j < slotNumber; j++) {
    condition2 = condition2 || slotList.getSlots()[i][j].getAmountOfProduct() < slotList.getSlots()[i][j].getDemandOfProduct();
    }
    while (condition2) {
    condition2 = false;
    for (Product product in slotList.getSlots()[i]) {
    product.incrementAmountOfProduct();
    }
    countList[i]++;
    for (int j = 0; j < slotNumber; j++) {
    condition2 = condition2 || slotList.getSlots()[i][j].getAmountOfProduct() < slotList.getSlots()[i][j].getDemandOfProduct();
    }
    }

    }

    if (showSteps) {
    for(int i = 0;i < numberOfSlotConfig;i++) {
    print("At run ${i+1}" + ", ${countList[i]}" + " product produced in each slot.\n");
    print("Slots: ");
    for (Product product in slotList.getSlots()[i]) {
    print("Product ${1 + product.getProductId() }" + ", ");
    }
    print("\n");
    print("-----------------------------------------------------------------------\n");
    }
    }
  }


}
