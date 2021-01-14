import 'package:flutter/material.dart';
import 'package:multi_slot_labelling_machine/model/machine.dart';
import 'package:multi_slot_labelling_machine/model/product.dart';
import 'package:multi_slot_labelling_machine/model/productList.dart';
import 'package:multi_slot_labelling_machine/model/slotList.dart';

class ResultScreen extends StatefulWidget {
  ResultScreen({Key key, this.totalWaste, this.bestSlotForResult}) : super(key: key);

  final int totalWaste;
  final SlotList bestSlotForResult;

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with TickerProviderStateMixin{
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
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Product ${ProductList.getProducts()[index].getProductId() + 1} --> Demand: ${ProductList.getProducts()[index].getDemandOfProduct()}, Produced: ${ProductList.getProducts()[index].getAmountOfProduct()}"),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 30.0,
                ),
                _buildTabs(),
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

  _buildTabs() {
    TabController tabController = TabController(length: Machine.getNumberOfSlotConfig(), vsync: this);
    List<Widget> tabs = [];
    for(int i = 1;i < Machine.getNumberOfSlotConfig() + 1;i++) {
      tabs.add(Tab(child: Text("Run $i", style: TextStyle(color: Colors.black),),));
    }
    List<Widget> tabBars = new List();
    String runResult = "";
    List countProducedProducts = new List(ProductList.getProductsNumber());
    for(int i = 0; i < ProductList.getProductsNumber();i++) {
      countProducedProducts[i] = 0;
    }

    for(int i = 0;i < Machine.getNumberOfSlotConfig();i++) {
      for (int j = 0; j < Machine.getSlotNumber(); j++) {
        for (Product product in ProductList.getProducts()) {
          if (product.getProductId() ==
              widget.bestSlotForResult.getSlots()[i][j].getProductId()) {
            countProducedProducts[product.getProductId()]++;
          }
        }
      }
      runResult = runResult + "${Machine.getCountList()[i]}" + " product produced in each slot.\n\n--Slots--\n";
      for(int a = 0; a < ProductList.getProductsNumber();a++) {
        if(countProducedProducts[a] != 0) {
          runResult = runResult + "Product ${a + 1} in ${countProducedProducts[a]} ${countProducedProducts[a] > 1 ? "slots." : "slot."}\n";
        }
      }
      tabBars.add(ListView(
        children: [
          Card(elevation: 2,child: Text(runResult)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text("Total waste: ${widget.totalWaste}")),
          ),
        ],
      ));
      runResult = "";
      for(int i = 0; i < ProductList.getProductsNumber();i++) {
        countProducedProducts[i] = 0;
      }
    }

    return Container(
      child: Column(
        children: <Widget>[
          TabBar(
            controller: tabController,
            tabs: tabs
          ),
          Container(
            height: 250.0,
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: TabBarView(
              controller: tabController,
              children: tabBars
            ),
          )
        ],
      ),
    );
  }
}
