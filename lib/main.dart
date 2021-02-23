import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'musicinfo.dart';

double price = 0.0;
List<int> productcount = [0,0,0,0,0,0,0,0,0,0,0];

void main() {
  runApp(MyApp());
}

double roundDouble(double value, int places){
  double mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Hub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  List<Widget> itemsData = [];

  void getPostsData() {
    List<dynamic> responseList =  MUSIC_INFO;
    List<Widget> listItems = [];
    responseList.forEach((post) {
      void _addValue(){
        setState(() {

        });
      }
      listItems.add(Container(
          height: 198,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
          ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      post["name"],
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      post["brand"],
                      style: const TextStyle(fontSize: 17, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "\$ ${post["price"]}",
                      style: const TextStyle(fontSize: 36, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailPage(
                              MUSIC_INFO[responseList.indexOf(post)],
                              responseList.indexOf(post)))
                        );
                      },
                      child: Text("View Detail", style: TextStyle(fontSize: 15, color: Colors.white)),
                      color: Colors.black,
                    ),
                  ],
                ),
                Image.asset(
                  "assets/images/${post["image"]}",
                  height: 150,
                )
              ],
            ),
          )));
    });
    setState(() {
      itemsData = listItems;
    });
  }


  @override
  void initState() {
    super.initState();
    getPostsData();
    controller.addListener(() {

      double value = controller.offset/119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height*0.30;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.black,
          title: Text('MUSICHUB', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.only(right: 45),
              icon: Icon(Icons.shopping_cart, color: Colors.white, size: 40,),
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Purchase()));
              },
            ),
          ],
    ),
        body: Container(
          height: size.height,
          child: Column(
            children: <Widget>[
              Row(
              ),
              const SizedBox(
                height: 10,
              ),

              Expanded(
                  child: ListView.builder(
                      controller: controller,
                      itemCount: itemsData.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        double scale = 1.0;
                        if (topContainer > 0.5) {
                          if (scale < 0) {
                            scale = 0;
                          } else if (scale > 1) {
                            scale = 1;
                          }
                        }
                        return Opacity(
                          opacity: scale,
                          child: Transform(
                            transform:  Matrix4.identity()..scale(scale,scale),
                            alignment: Alignment.bottomCenter,
                            child: Align(
                                heightFactor: 1,
                                alignment: Alignment.topCenter,
                                child: itemsData[index]),
                          ),
                        );
                      })),
            ],
          ),
        ),

      ),
    );
  }
}


class DetailPage extends StatefulWidget {
  final Map<String, Object> detail;
  final int index;
  DetailPage(this.detail, this.index);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          backgroundColor: Colors.black,
          title: Text("ALBUM DETAIL", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        ),
        body: Container(
        padding: EdgeInsets.only(top: 50),
    width: double.infinity,
    child: Column(children: <Widget>[
    Image.asset(
    "assets/images/${widget.detail["image"]}",
    width: 225,
    height: 225,
    ),
    SizedBox(
    height: 10,
    ),
    Text(
    "${widget.detail["name"]}",
    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
    textAlign: TextAlign.center,
    ),
      Text("${widget.detail["brand"]}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold, color: Colors.grey
          ),
          textAlign: TextAlign.center),
      SizedBox(
        height: 10,
      ),
      Text("\$ ${widget.detail["price"]}",
          style:
          const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center),
      SizedBox(
        height: 10,
      ),
      SizedBox(
        width: 200,
        height: 55,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: () {
            setState(() {
              price += widget.detail["price"];
              price = roundDouble(price, 2);
              productcount[widget.index]++;
            });
          },
          child: Text("Add to cart",
            style: TextStyle(fontSize: 20, color: Colors.white)),
        color: Colors.blue,
      ),
      ),
    ])),
    );
  }
}

class Purchase extends StatefulWidget {
  @override
  _PurchaseState createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List<dynamic> OrderList = MUSIC_INFO;
    int listcount = 1;
    final children = <Widget>[];
    OrderList.forEach((count) {
      if (productcount[OrderList.indexOf(count)] > 0) {
        children.add(Container(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
          ]),
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "$listcount.  ${count["name"]}\n  \b\b Total Unit:   ${productcount[OrderList.indexOf(count)]}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "\$ ${count["price"] * productcount[OrderList.indexOf(count)]}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue),
                          textAlign: TextAlign.right,
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                price -= count["price"];
                                price = roundDouble(price, 2);
                                if(price <= 0){
                                  price = 0;
                                }
                                productcount[OrderList.indexOf(count)]--;
                              });
                              print(OrderList.indexOf(count));
                              print('Canceled Total price = $price');
                            },
                            icon: Icon(Icons.delete, color: Colors.red)
                        ),
                      ],
                  ),
                ),
            ],
          ),
        ));
        listcount++;
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("ORDERED LISTS", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 30),
        child: Column(
          children: children,
        ),

      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 20, top: 20, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
           new Text("TOTAL PRICE       |", style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold, color: Colors.white),),
            Text("\$ $price",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        color: Colors.blue,),
    );
  }
}
