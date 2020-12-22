import 'package:flutter/material.dart';
import 'model/productList.dart';
import 'model/product.dart';
import 'model/machine.dart';
import 'model/geneticAlgorithm.dart';
import 'model/slotList.dart';
import 'model/population.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  
  static void run() {
    Product product1 = new Product(200, 0);
    Product product2 = new Product(150, 1);
    Product product3 = new Product(80, 2);
    Product product4 = new Product(60, 3);
    ProductList.addProduct(product1);
    ProductList.addProduct(product2);
    ProductList.addProduct(product3);
    ProductList.addProduct(product4);
    
    Machine.setNumberOfSlotConfig(2);
    Machine.setSlotNumber(3);

    Population slotLists = new Population(true, 10);
    List geneticSlotLists = new List(2000);//if u want to try bigger population change 2000
    SlotList bestSlotList = new SlotList();
    int temp = 0;
    for (int i = 0; i < 2000; i++) {//also change here if u change above
      slotLists = GeneticAlgorithm.evolveSlotLists(slotLists);
      geneticSlotLists[i] = slotLists.getBestSlotList();

      if ((i % 200) == 0 && i != 0) {//u can change the printing interval
        int minWaste = 999999;
        for (int j = 0; j < (200 + (temp * 200));j++) {//also change here if u change above
          if (geneticSlotLists[j].getWaste() < minWaste) {
            minWaste = geneticSlotLists[j].getWaste();
            bestSlotList = geneticSlotLists[j];
          }
        }

        Machine.setSlotList(bestSlotList);

        Machine.run(true);

      }
    }
    


    List products1 = new List();
    List products2 = new List();




    products1.add(ProductList.getProducts()[0]);
    products1.add(ProductList.getProducts()[0]);
    products1.add(ProductList.getProducts()[1]);


    products2.add(ProductList.getProducts()[1]);
    products2.add(ProductList.getProducts()[2]);
    products2.add(ProductList.getProducts()[3]);




    SlotList testSlotList = new SlotList();

    testSlotList.addProductsToSlot(products1);
    testSlotList.addProductsToSlot(products2);

    Machine.setSlotList(testSlotList);
    Machine.run(true);

  }


  int calculateTotalWaste() {
    List waste = new List(ProductList.getProductsNumber());
    int totalWaste = 0;
    int producedProduct = 0;
    for (int i = 0; i < ProductList.getProductsNumber(); i++) {
      waste[i] = ProductList.getProducts()[i].getAmountOfProduct() - ProductList.getProducts()[i].getDemandOfProduct();
      print("Product ${i+1}" + " demand: " + ProductList.getProducts()[i].getDemandOfProduct() + " ,produced: " + ProductList.getProducts()[i].getAmountOfProduct() + " waste: " + waste[i] + "\n");
      totalWaste = totalWaste + waste[i];
    }

    print("Total waste: $totalWaste" + "\n");
    return totalWaste;
  }

  void _incrementCounter() {
    setState(() {
      run();
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
