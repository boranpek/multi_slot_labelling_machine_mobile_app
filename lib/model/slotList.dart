import 'dart:math';

import 'product.dart';
import 'productList.dart';
import 'machine.dart';

class SlotList {

  List slots;
  int waste;

  void setSlots(List slots) {
    this.slots = slots;
  }


  SlotList() {
    this.slots = new List();
    this.waste = 0;
  }

  int getWaste() {
    return waste;
  }

  void setWaste(int waste) {
    this.waste = waste;
  }

  void addProductsToSlot(List products) {
    this.slots.add(products);
  }

  List getSlots() {
    return slots;
  }

  void createSlotList() {
    var random = new Random();
    int randomProductId;

    while (this.slots.length < Machine.getNumberOfSlotConfig()) {
      for (int i  = 0; i < Machine.getNumberOfSlotConfig(); i++) {
        List slotForEachRun = new List();
        for (int j = 0; j < Machine.getSlotNumber(); j++) {
          randomProductId = random.nextInt(ProductList.getProductsNumber());
          for(Product product in ProductList.getProducts()) {
    if (product.getProductId() == randomProductId) {
    slotForEachRun.add(product);
    }
    }
    }
    this.slots.add(slotForEachRun);
    }
    List countProducts = new List(ProductList.getProductsNumber());
      for(int i = 0; i < ProductList.getProductsNumber();i++) {
        countProducts[i] = 0;
      }

    for(int i = 0; i < Machine.getNumberOfSlotConfig(); i++){
    for (int j = 0; j < Machine.getSlotNumber(); j++){
    for (Product product in ProductList.getProducts()) {
    if (product.getProductId() == this.slots[i][j].getProductId()) {
    countProducts[product.getProductId()]++;
    }
    }
    }
    }

    for (int i = 0; i < ProductList.getProductsNumber(); i++) {
    if (countProducts[i] == 0) {
    this.slots.clear();
    break;
    }
    }
  }


  }
}
