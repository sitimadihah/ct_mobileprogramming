import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fastinghealth/adminproduct.dart';
import 'package:fastinghealth/cartscreen.dart';
import 'package:fastinghealth/paymenthistoryscreen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fastinghealth/user.dart';
import 'package:fastinghealth/product.dart';
import 'profilescreen.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List productdata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = true;
  String curcategory = "All Menus";
  String titlecenter = "Loading Products..";
  String cartquantity = "0";
  int quantity = 1;
  bool _isadmin = false;
  String server = "https://saujanaeclipse.com/fastingHealth";

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadCartQuantity();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    if (widget.user.email == "admin@fastinghealth.com") {
      _isadmin = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          backgroundColor: Colors.red,
          drawer: mainDrawer(context),
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              'YOUR MENUS!',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            iconTheme: new IconThemeData(color: Colors.red),
          ),
          body: RefreshIndicator(
              key: refreshKey,
              color: Color.fromRGBO(101, 255, 218, 50),
              onRefresh: () async {
                await refreshList();
              },
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Visibility(
                      visible: _visible,
                      child: Card(
                          elevation: 10,
                          child: Padding(
                              padding: EdgeInsets.all(5),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        FlatButton(
                                            onPressed: () =>
                                                _sortItem("Vegetable"),
                                            color: Colors.white,
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: <Widget>[
                                                Icon(MdiIcons.foodApple,
                                                    color: Colors.black),
                                                Text(
                                                  "Vegetable",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )
                                              ],
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Column(
                                      children: <Widget>[
                                        FlatButton(
                                            onPressed: () =>
                                                _sortItem("Chicken"),
                                            color: Colors.white,
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: <Widget>[
                                                Icon(
                                                  MdiIcons.foodVariant,
                                                  color: Colors.black,
                                                ),
                                                Text(
                                                  "Chicken",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )
                                              ],
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Column(
                                      children: <Widget>[
                                        FlatButton(
                                            onPressed: () => _sortItem("Beef"),
                                            color: Colors.white,
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: <Widget>[
                                                Icon(
                                                  MdiIcons.cow,
                                                  color: Colors.black,
                                                ),
                                                Text(
                                                  "Beef",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )
                                              ],
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Column(
                                      children: <Widget>[
                                        FlatButton(
                                            onPressed: () => _sortItem("Fish"),
                                            color: Colors.white,
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: <Widget>[
                                                Icon(
                                                  MdiIcons.fish,
                                                  color: Colors.black,
                                                ),
                                                Text(
                                                  "Fish",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )
                                              ],
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ))),
                    ),
                    Text(curcategory,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    productdata == null
                        ? Flexible(
                            child: Container(
                                child: Center(
                                    child: Text(
                            titlecenter,
                            style: TextStyle(
                                color: Color.fromRGBO(101, 255, 218, 50),
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ))))
                        : Expanded(
                            child: GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio:
                                    (screenWidth / screenHeight) / 0.8,
                                children:
                                    List.generate(productdata.length, (index) {
                                  return Container(
                                      child: Card(
                                          elevation: 10,
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () =>
                                                      _onImageDisplay(index),
                                                  child: Container(
                                                    height: screenHeight / 5,
                                                    width: screenWidth / 3,
                                                    child: ClipRRect(
                                                        child:
                                                            CachedNetworkImage(
                                                      fit: BoxFit.fill,
                                                      imageUrl: server +
                                                          "/productImage/${productdata[index]['id']}.jpg",
                                                      placeholder: (context,
                                                              url) =>
                                                          new CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          new Icon(Icons.error),
                                                    )),
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(productdata[index]['name'],
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: 17.0)),
                                                SizedBox(height: 5),
                                                Text(
                                                  "Price: RM" +
                                                      productdata[index]
                                                          ['price'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 17.0),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  "<<Tap image to view details>>",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13.0),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          )));
                                })))
                  ],
                ),
              )),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              if (widget.user.email == "admin@fastinghealth.com") {
                Toast.show("You are in ADMIN mode", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
              } else if (widget.user.quantity == "0") {
                Toast.show("Cart empty", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
              } else {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CartScreen(
                              user: widget.user,
                            )));
                _loadData();
                _loadCartQuantity();
              }
            },
            icon: Icon(
              Icons.add_shopping_cart,
              color: Colors.black,
            ),
            label: Text(cartquantity, style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.blue[200],
          ),
        ));
  }

  _onImageDisplay(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0.0))),
            content: new Container(
              color: Colors.black,
              height: screenHeight / 1.5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: screenWidth / 2,
                      width: screenWidth / 2,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.scaleDown,
                              image: NetworkImage(
                                  "http://saujanaeclipse.com/fastingHealth/productImage/${productdata[index]['id']}.jpg")))),
                  Text(productdata[index]['name'],
                      maxLines: 1,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 5),
                  Text(
                    "Price: RM" + productdata[index]['price'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Calories: " + productdata[index]['calories'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text("Ingredients: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center),
                  Text(productdata[index]['ingredient'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center),
                  SizedBox(height: 5),
                  MaterialButton(
                      shape: RoundedRectangleBorder(),
                      minWidth: 100,
                      height: 42,
                      child: Text(
                        'Add to Cart',
                      ),
                      color: Colors.redAccent[200],
                      textColor: Colors.black,
                      elevation: 10,
                      onPressed: () => _addtocartdialog(index)),
                ],
              ),
            ));
      },
    );
  }

  void _loadData() async {
    String urlLoadJobs =
        "http://saujanaeclipse.com/fastingHealth/php/load_products.php";

    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body == "nodata") {
        cartquantity = "0";
        titlecenter = "No product found";
        setState(() {
          productdata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          productdata = extractdata["products"];
          cartquantity = widget.user.quantity;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadCartQuantity() async {
    String urlLoadJobs = server + "/php/load_cartquantity.php";
    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
      } else {
        widget.user.quantity = res.body;
      }
    }).catchError((err) {
      print(err);
    });
  }

  Widget mainDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.name),
            accountEmail: Text(widget.user.email),
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor:
                  Theme.of(context).platform == TargetPlatform.android
                      ? Colors.black
                      : Colors.black,
              child: Text(
                widget.user.name.toString().substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 40.0),
              ),
              backgroundImage: NetworkImage(
                  server + "/profileimages/${widget.user.email}.jpg?"),
            ),
            onDetailsPressed: () => {
              Navigator.pop(context),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ProfileScreen(
                            user: widget.user,
                          )))
            },
          ),
          ListTile(
              title: Text(
                "Product List",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.pop(context);
                _loadData();
              }),
          ListTile(
              title: Text(
                "Shopping Cart",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                gotoCart();
              }),
          ListTile(
              title: Text(
                "Payment History",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => PaymentHistoryScreen(
                              user: widget.user,
                            )));
              }),
          ListTile(
              title: Text(
                "User Profile",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ProfileScreen(
                                  user: widget.user,
                                )))
                  }),
          Visibility(
            visible: _isadmin,
            child: Column(
              children: <Widget>[
                Divider(
                  height: 2,
                  color: Colors.white,
                ),
                Center(
                  child: Text(
                    "Admin Menu",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                    title: Text(
                      "My Products",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () => {
                          Navigator.pop(context),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AdminProduct(
                                        user: widget.user,
                                      )))
                        }),
              ],
            ),
          )
        ],
      ),
    );
  }

  _productInfo(int index) async {
    Product product = new Product(
      name: productdata[index]['NAME'],
      pid: productdata[index]['ID'],
      price: productdata[index]['PRICE'],
      calories: productdata[index]['CALORIES'],
      ingredient: productdata[index]['INGREDIENT'],
      quantity: productdata[index]['QUANTITY'],
    );
  }

  Widget productList() {
    return Flexible(
        child: GridView.count(
            childAspectRatio: (screenWidth / screenHeight) / 0.8,
            crossAxisCount: 2,
            children: List.generate(
              productdata.length,
              (index) {
                return GestureDetector(
                  onTap: () => _productInfo(index),
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    color: Colors.grey[100],
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: <Widget>[
                          //to display image of product
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            height: screenHeight / 5,
                            width: screenWidth / 2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        "http://saujanaeclipse.com/fastingHealth/php/productImage/${productdata[index]['name']}.jpg"))),
                          ),
                          Container(
                              child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 5.0),
                                child: Text(
                                  productdata[index][
                                      'name'], //display the name of the product
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, height: 1.5),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Text(
                                "RM " + productdata[index]['price'],
                                style: TextStyle(
                                    color: Colors.greenAccent.shade700),
                              ),
                              Text(
                                  "In Stock:" + productdata[index]['quantity']),
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                );
              },
            )));
  }

  _addtocartdialog(int index) {
    if (widget.user.email == "admin@fastinghealth.com") {
      Toast.show("You are in ADMIN mode", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    quantity = 1;

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Add " + productdata[index]['name'] + " to Cart?",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Select quantity of product",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              newSetState(() {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              });
                            },
                            child: Icon(
                              MdiIcons.minus,
                              color: Colors.blue[500],
                            ),
                          ),
                          Text(
                            quantity.toString(),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              newSetState(() {
                                if (quantity <
                                    (int.parse(productdata[index]['quantity']) -
                                        2)) {
                                  quantity++;
                                } else {
                                  Toast.show("Quantity not available", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                }
                              });
                            },
                            child: Icon(
                              MdiIcons.plus,
                              color: Colors.blue[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      _addtoCart(index);
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    )),
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.black),
                    )),
              ],
            );
          });
        });
  }

  void _addtoCart(int index) {
    if (widget.user.email == "admin@fastinghealth.com") {
      Toast.show("You are in ADMIN mode", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    try {
      int cquantity = int.parse(productdata[index]["quantity"]);
      print(cquantity);
      print(productdata[index]["prodid"]);
      print(widget.user.email);
      if (cquantity > 0) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: true);
        pr.style(
          message: "Add to cart...",
        );
        pr.show();
        String urlLoadJobs = server + "/php/insert_cart.php";
        http.post(urlLoadJobs, body: {
          "email": widget.user.email,
          "prodid": productdata[index]["id"],
          "quantity": quantity.toString(),
        }).then((res) {
          print(res.body);
          if (res.body == "failed") {
            Toast.show("Failed add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            pr.hide().then((isHidden) {
              print(isHidden);
            });
            return;
          } else {
            List respond = res.body.split(",");
            setState(() {
              cartquantity = respond[1];
              widget.user.quantity = cartquantity;
            });
            Toast.show("Success add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
          pr.hide().then((isHidden) {
            print(isHidden);
          });
        }).catchError((err) {
          print(err);
          pr.hide().then((isHidden) {
            print(isHidden);
          });
        });
        pr.hide().then((isHidden) {
          print(isHidden);
        });
      } else {
        Toast.show("Out of stock", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      Toast.show("Failed add to cart", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _sortItem(String category) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);

      pr.show();
      print(pr);
      String urlLoadJobs =
          "http://saujanaeclipse.com/fastingHealth/php/load_products.php";

      http.post(urlLoadJobs, body: {
        "category": category,
      }).then((res) {
        if (res.body == "nodata") {
          Toast.show("No product found", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          pr.hide().then((isHidden) {
            print(isHidden);
          });
          FocusScope.of(context).requestFocus(new FocusNode());
          return;
        }
        setState(() {
          curcategory = category;
          var extractdata = json.decode(res.body);
          productdata = extractdata["products"];
          FocusScope.of(context).requestFocus(new FocusNode());
          pr.hide().then((isHidden) {
            print(isHidden);
          });
        });
      }).catchError((err) {
        print(err);
        pr.hide().then((isHidden) {
          print(isHidden);
        });
      });
      pr.hide().then((isHidden) {
        print(isHidden);
      });
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void sortItemByName(String name) {
    try {
      print(name);
      String urlLoadProduct =
          "https://saujanaeclipse.com/fastingHealth/php/load_products.php";
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(
          message: 'Searching...',
          progressTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 13.0,
              fontWeight: FontWeight.w400));
      pr.show();
      http
          .post(urlLoadProduct, body: {
            "name": name.toString(),
          })
          .timeout(const Duration(seconds: 4))
          .then((res) {
            if (res.body == "nodata") {
              Toast.show("Ooops..product not found!", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              pr.hide().then((isHidden) {
                print(isHidden);
              });
              FocusScope.of(context).requestFocus(new FocusNode());
              return;
            }
            setState(() {
              var extractdata = json.decode(res.body);
              productdata = extractdata["products"];
              FocusScope.of(context).requestFocus(new FocusNode());
              curcategory = name;
              pr.hide().then((isHidden) {
                print(isHidden);
              });
            });
          })
          .catchError((err) {
            pr.hide().then((isHidden) {
              print(isHidden);
            });
          });
      pr.hide().then((isHidden) {
        print(isHidden);
      });
    } catch (e) {
      Toast.show('Error', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  gotoCart() async {
    if (widget.user.email == "admin@fastinghealth.com") {
      Toast.show("You are in ADMIN mode", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.quantity == "0") {
      Toast.show("Cart empty", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CartScreen(
                    user: widget.user,
                  )));
      _loadData();
      _loadCartQuantity();
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Are you sure?',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            content: new Text(
              'Do you want to exit an App',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )),
            ],
          ),
        ) ??
        false;
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _loadData();
    return null;
  }
}
