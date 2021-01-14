import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:multi_slot_labelling_machine/mixins/validation_mixin.dart';
import 'package:multi_slot_labelling_machine/model/productList.dart';
import 'package:multi_slot_labelling_machine/screens/productScreen.dart';
import 'package:multi_slot_labelling_machine/model/machine.dart';

class MachineScreen extends StatefulWidget {
  MachineScreen({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MachineScreenState createState() => _MachineScreenState();
}

class _MachineScreenState extends State<MachineScreen> with ValidationMixin, TickerProviderStateMixin {

  int _runNumber;
  int _slotNumber;
  int _productNumber;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: Text(widget.title),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment(-0.116,0.18),
                children: [
                  SizedBox(
                    height: 300.0,
                    width: 400.0,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/machineHand.png"),
                              fit: BoxFit.fill
                          )
                      ),
                    ),
                  ),
                  Hero(
                    tag: 'rotateWheel',
                    child: SizedBox(
                      height: 50.0,
                      width: 50.0,
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
                ],
              ),
              Container(
                margin: EdgeInsets.all(25.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      slotNumberField(),
                      runNumberField(),
                      productNumberField(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          createButton(),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget slotNumberField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Slot Number",
          hintText: "ex: 3"
      ),
      validator: validateSlotNumber,
      onSaved: (String value) {
        _slotNumber = int.parse(value);
      },
    );
  }

  Widget runNumberField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Run Number",
          hintText: "ex:3"
      ),
      validator: validateRunNumber,
      onSaved: (String value) {
        _runNumber = int.parse(value);
      },
    );
  }

  Widget productNumberField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Product Number",
          hintText: "ex:3"
      ),
      validator: validateProductNumber,
      onSaved: (String value) {
        _productNumber = int.parse(value);
      },
    );
  }

  Widget createButton() {
    return RaisedButton(
      child: Text(
        "Create", style: TextStyle(fontSize: 15.0, color: Colors.white),),
      color: Colors.black45,
      onPressed: () {
        createMachine();
      },
    );
  }

  void createMachine() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if((_runNumber*_slotNumber) >= _productNumber) {
        Machine.setNumberOfSlotConfig(_runNumber);
        Machine.setSlotNumber(_slotNumber);
        Fluttertoast.showToast(
            msg: "Machine is Created!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
        );
        ProductList.resetProductList();
        Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) =>
                ProductScreen(productNumber: _productNumber,)
        ));
        sleep(const Duration(seconds: 1));
      }

      else {
        Fluttertoast.showToast(
            msg: "Run Number x Slot Number should be greater then Product Number",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            timeInSecForIosWeb: 5
        );
      }


    }
  }
}