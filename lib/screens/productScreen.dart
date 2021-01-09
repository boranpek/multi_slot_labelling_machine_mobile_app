import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_slot_labelling_machine/mixins/validation_mixin.dart';
import 'package:multi_slot_labelling_machine/model/geneticAlgorithm.dart';
import 'package:multi_slot_labelling_machine/model/machine.dart';
import 'package:multi_slot_labelling_machine/model/population.dart';
import 'package:multi_slot_labelling_machine/model/product.dart';
import 'package:multi_slot_labelling_machine/model/productList.dart';
import 'package:multi_slot_labelling_machine/model/slotList.dart';
import 'package:multi_slot_labelling_machine/screens/resultScreen.dart';


class ProductScreen extends StatefulWidget {
  ProductScreen({Key key, this.productNumber}) : super(key: key);

  final int productNumber;

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> with ValidationMixin, TickerProviderStateMixin{
  AnimationController _controller;
  Animation<double> _animation;
  final formKey = GlobalKey<FormState>();
  int _productDemand;
  int _productId = 0;
  int _totalWaste = 0;
  SlotList _bestSlotForResult = new SlotList();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: Text("Products"),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Column(
            children: [
              SizedBox(height: 100.0,),
              Stack(
                alignment: Alignment(0.09,0.08),
                children: [
                  SizedBox(
                    height: 300.0,
                    width: 400.0,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/throw.png"),
                              fit: BoxFit.fill
                          )
                      ),
                    ),
                  ),
                  Hero(
                    tag: 'rotateWheel',
                    child: RotationTransition(
                      turns: _animation,
                      child: SizedBox(
                        height: 30.0,
                        width: 30.0,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/wheel.png"),
                                  fit: BoxFit.fill
                              )
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(25.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      productDemandField(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          addProductButton(),
                          runButton()
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 100.0,),
            ],
          )
        ],
      ),
    );
  }

  Widget productDemandField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Product ${_productId + 1} Demand",
          hintText: "ex:200"
      ),
      validator: validateProductDemand,
      onSaved: (String value) {
        _productDemand = int.parse(value);
      },
    );
  }

  void addProduct() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (_productId < widget.productNumber) {
        Product product = new Product(_productDemand, _productId);
        ProductList.addProduct(product);
        setState(() {
          _productId++;
        });
        Fluttertoast.showToast(
          msg: "Product $_productId is Added!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      }

      else {
        print(ProductList.getProducts());
        Fluttertoast.showToast(
            msg: "You entered the Product Number: ${widget.productNumber}, so you cannot add more!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            timeInSecForIosWeb: 2
        );
      }
    }
  }

  Widget addProductButton() {
    return RaisedButton(
      child: Text(
        "Add", style: TextStyle(fontSize: 15.0, color: Colors.white),),
      color: Colors.black45,
      onPressed: () {
        addProduct();
      },
    );
  }

  Widget runButton() {
    return RaisedButton(
      child: Text(
        "Run", style: TextStyle(fontSize: 15.0, color: Colors.white),),
      color: Colors.green,
      onPressed: () {
        if(ProductList.getProductsNumber() == widget.productNumber) {
          Fluttertoast.showToast(
            msg: "Machine is running!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          run();
          Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) =>
                  ResultScreen(totalWaste: _totalWaste, bestSlotForResult: _bestSlotForResult,)
          ));
        }
        else {
          Fluttertoast.showToast(
              msg: "You should add ${widget.productNumber} products!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              timeInSecForIosWeb: 2
          );
        }

      },
    );
  }

  void run() {
    Population slotLists = new Population(true, 10);
    List geneticSlotLists = new List(
        2000); //if u want to try bigger population change 2000
    SlotList bestSlotList = new SlotList();

    for (int i = 0; i < 2000; i++) { //also change here if u change above
      slotLists = GeneticAlgorithm.evolveSlotLists(slotLists);
      geneticSlotLists[i] = slotLists.getBestSlotList();
    }

    int minWaste = 999999;
    for (int i = 0; i < 2000;i++) {//also change here if u change above
      if (geneticSlotLists[i].getWaste() < minWaste) {
        minWaste = geneticSlotLists[i].getWaste();
        bestSlotList = geneticSlotLists[i];
      }
    }

    Machine.setSlotList(bestSlotList);

    Machine.run(true);

    _totalWaste = calculateTotalWaste();
    _bestSlotForResult = bestSlotList;

  }


  int calculateTotalWaste() {
    List waste = new List(ProductList.getProductsNumber());
    int totalWaste = 0;
    for (int i = 0; i < ProductList.getProductsNumber(); i++) {
      waste[i] = ProductList.getProducts()[i].getAmountOfProduct() -
          ProductList.getProducts()[i].getDemandOfProduct();

      totalWaste = totalWaste + waste[i];
    }
    print("Total waste: $totalWaste" + "\n");
    return totalWaste;
  }
}
