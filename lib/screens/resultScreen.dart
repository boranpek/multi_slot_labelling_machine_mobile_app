import 'package:flutter/material.dart';
import 'package:multi_slot_labelling_machine/model/machine.dart';
import 'package:multi_slot_labelling_machine/model/productList.dart';
import 'package:multi_slot_labelling_machine/model/slotList.dart';

class ResultScreen extends StatefulWidget {
  ResultScreen({Key key, this.totalWaste, this.bestSlotForResult}) : super(key: key);

  final int totalWaste;
  final SlotList bestSlotForResult;

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black26,
          title: Text("Results"),
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 200.0,
                  width: 200.0,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/result.png"),
                            fit: BoxFit.fill
                        )
                    ),
                  ),
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: ProductList.getProductsNumber(),
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Product ${ProductList.getProducts()[index].getProductId() + 1} --> Demand: ${ProductList.getProducts()[index].getDemandOfProduct()}, Produced: ${ProductList.getProducts()[index].getAmountOfProduct()}"),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 50.0,
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: Machine.getNumberOfSlotConfig(),
                  itemBuilder: (BuildContext context, int runIndex) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: Machine.getSlotNumber(),
                      itemBuilder: (BuildContext context, int slotIndex) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("At run ${runIndex + 1}, slot ${slotIndex + 1}: Product ${widget.bestSlotForResult.getSlots()[runIndex][slotIndex].getProductId() + 1}"),
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Total waste: ${widget.totalWaste}")
              ],
            )
          ],
        )
    );
  }

  int calculateTotalWaste() {
    List waste = new List(ProductList.getProductsNumber());
    int totalWaste = 0;
    for (int i = 0; i < ProductList.getProductsNumber(); i++) {
      waste[i] = ProductList.getProducts()[i].getAmountOfProduct() -
          ProductList.getProducts()[i].getDemandOfProduct();
      print("Product ${i + 1}" + " demand: " +
          ProductList.getProducts()[i].getDemandOfProduct() + " ,produced: " +
          ProductList.getProducts()[i].getAmountOfProduct() + " waste: " +
          waste[i] + "\n");
      totalWaste = totalWaste + waste[i];
    }

    print("Total waste: $totalWaste" + "\n");
    return totalWaste;
  }
}
