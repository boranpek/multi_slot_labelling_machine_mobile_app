import 'slotList.dart';
import 'product.dart';
import 'productList.dart';
import 'machine.dart';

class Population {
  List  slotLists;
  Population(bool initialization, int popSize) {
    if(!initialization) {
      slotLists = new List(popSize);
    }
    else {
      slotLists = new List(popSize);
      for (int i = 0; i < popSize; i++) {
        SlotList slotList = new SlotList();
        slotList.createSlotList();
        setSlotList(slotList,i);
      }
    }
  }

  List getSlotLists() {
    return slotLists;
  }

  void setSlotList(SlotList slotList, int index) {
    slotLists[index] = slotList;
  }

  SlotList getBestSlotList() {
    for (SlotList slotList in slotLists) {
      Machine.setSlotList(slotList);
      Machine.run(false);
      slotList.setWaste(Machine.calculateTotalWaste());
      resetAmountOfProducts();
    }
    int min = 999999;
    SlotList bestSlotList = new SlotList();
    for (SlotList slotList in slotLists) {
      if (slotList.getWaste() < min) {
        min = slotList.getWaste();
        bestSlotList = slotList;
      }
    }
    return  bestSlotList;
  }

  void addSlotList(int index, SlotList slotList) {
    slotLists[index] = slotList;
  }

  void resetAmountOfProducts() {
    for (Product product in ProductList.getProducts()) {
    product.setAmountOfProduct(0);
    }
  }
}
