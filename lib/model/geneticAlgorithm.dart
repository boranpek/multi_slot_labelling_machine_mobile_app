import 'dart:math';

import 'product.dart';
import 'population.dart';
import 'slotList.dart';
import 'machine.dart';
import 'productList.dart';

class GeneticAlgorithm {
  static int tournamentSize = 5;
  static int popSize = 10;

  static Population evolveSlotLists(Population slotLists) {
    Population evolvedSlotLists = new Population(false,popSize);
    for (int i = 0; i < popSize; i++){
      SlotList parent1 =  tournamentSelection(slotLists);//this selects randomly slotList from slotLists(population) by the tournamentSize then return the best one(slotList which has lowest waste)
      SlotList parent2 =  tournamentSelection(slotLists);
      SlotList child = crossingOver(parent1, parent2); // this creates new slotList which is combination of 2 parents
      mutation(child) ;// one gen changes in child randomly under mutationRate condition
      evolvedSlotLists.addSlotList(i, child); // child is added to evolvedSlotLists
    }
    return evolvedSlotLists;
  }

  static SlotList tournamentSelection(Population slotLists) {

    Population selectedSlotLists = new Population(false, tournamentSize);
    var rand = new Random();
    for (int i = 0; i < tournamentSize; i++) {
      selectedSlotLists.addSlotList(i,slotLists.getSlotLists()[rand.nextInt(popSize)]);
    }

    return selectedSlotLists.getBestSlotList();

  }

  static SlotList crossingOver(SlotList parent1, SlotList parent2) {
    SlotList crossedSlotList = new SlotList();
    var rand = new Random();

    while (crossedSlotList.getSlots().length < Machine.getNumberOfSlotConfig()) {
      crossedSlotList.createSlotList();
      for (int i = 0; i < Machine.getNumberOfSlotConfig(); i++) {
        crossedSlotList.getSlots()[i].clear();
      }

      int randomRunNumber1 = rand.nextInt(Machine.getNumberOfSlotConfig());
      int randomSlotNumber1 = rand.nextInt(Machine.getSlotNumber());
      int randomRunNumber2 = rand.nextInt(Machine.getNumberOfSlotConfig());
      int randomSlotNumber2 = rand.nextInt(Machine.getSlotNumber());

      int lowerRunNumber = randomRunNumber1;
      int upperRunNumber = randomRunNumber2;
      int lowerSlotNumber = randomSlotNumber1;
      int upperSlotNumber = randomSlotNumber2;

      if (randomRunNumber2 < lowerRunNumber){
        lowerRunNumber = randomRunNumber2;
        upperRunNumber = randomRunNumber1;
      }

      if (randomSlotNumber2 < lowerSlotNumber) {
        lowerSlotNumber = randomSlotNumber2;
        upperSlotNumber = randomSlotNumber1;
      }
      for (int i = 0; i < Machine.getNumberOfSlotConfig(); i++) {
        for (Product product in parent2.getSlots()[i]) {
    crossedSlotList.getSlots()[i].add(product);
    }
    }

    for (int i = lowerRunNumber; i < (1 + upperRunNumber); i++ ) {
    for (int j = lowerSlotNumber; j < (1 + upperSlotNumber); j++) {
    crossedSlotList.getSlots()[i][j] = parent1.getSlots()[i][j];
    }
    }

    List countProducts = new List(ProductList.getProductsNumber());
      for(int i = 0; i < ProductList.getProductsNumber();i++) {
        countProducts[i] = 0;
      }

    for(int i = 0; i < Machine.getNumberOfSlotConfig(); i++){
    for (int j = 0; j < Machine.getSlotNumber(); j++){
    for (Product product in ProductList.getProducts()) {
    if (product.getProductId() == crossedSlotList.getSlots()[i][j].getProductId()) {
    countProducts[product.getProductId()]++;
    }
    }
    }
    }

    for (int i = 0; i < ProductList.getProductsNumber(); i++) {
    if (countProducts[i] == 0) {
    crossedSlotList.getSlots().clear();
    break;
    }
    }
  }
    return crossedSlotList;
  }

  static void mutation(SlotList child) {
    var rand = new Random();
    int randomRunNumber = rand.nextInt(Machine.getNumberOfSlotConfig());
    int randomSlotNumber = rand.nextInt(Machine.getSlotNumber());
    int randomRunNumber2 = rand.nextInt(Machine.getNumberOfSlotConfig());
    int randomSlotNumber2 = rand.nextInt(Machine.getSlotNumber());

    Product product1 = child.getSlots()[randomRunNumber][randomSlotNumber];
    Product product2 = child.getSlots()[randomRunNumber2][randomSlotNumber2];

    child.getSlots()[randomRunNumber2][randomSlotNumber2] = product1;
    child.getSlots()[randomRunNumber][randomSlotNumber] = product2;


  }
}
