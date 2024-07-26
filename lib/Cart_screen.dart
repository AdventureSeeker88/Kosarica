import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:kosarica/Controller/AppDetails_Controller.dart';
import 'package:kosarica/constants/color_text.dart';
import 'package:kosarica/constants/kosarica_pocetna_data.dart';
import 'package:share_plus/share_plus.dart';
import 'package:star_menu/star_menu.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class KosaricaScreen extends StatefulWidget {
  KosaricaScreen({super.key});

  @override
  State<KosaricaScreen> createState() => _KosaricaScreenState();
}

class _KosaricaScreenState extends State<KosaricaScreen>
    with TickerProviderStateMixin {
  appDetails_controller details_controller=Get.find<appDetails_controller>();
  String ? Selectedstore;
  final upperMenuItems = <Widget>[
    const Text(
      'Share shopping cart',
      style: TextStyle(fontSize: 18),
    ),
    const Text(
      'Delete shopping cart',
      style: TextStyle(fontSize: 18),
    ),
  ];

  TabController? _controller;
  int _counter = 1;
  double totalPrice = 0.0;
  void _incrementCounter(int index) {
    setState(() {
      double itemPrice = double.parse(mycart[index]['price_eu']);
      itemPrice += itemPrice; // Increment the item price
      // mycart[index]['price_eu'] = itemPrice.toString(); // Update the item price in the list
    });
    // Recalculate and update the total price
    setState(() {
      totalPrice += _counter * calculateTotalPrice();
      _counter++;
      mycart[index]['item_qt'] = _counter;
      // totalPrice +=_counter*  double.parse(mycart[index]['price_eu']);
    });
  }

  void _decrementCounter(int index) {
    setState(() {
      double itemPrice = double.parse(mycart[index]['price_eu']);
      if (itemPrice > 1.0) {
        // Ensure item price does not go below 1.0
        itemPrice -= 1.0; // Decrement the item price by 1.0
        // mycart[index]['price_eu'] = itemPrice.toString(); // Update the item price in the list
      }
    });
    // Recalculate and update the total price
    setState(() {
      totalPrice = calculateTotalPrice();
      _counter--;
      mycart[index]['item_qt'] = _counter;
    });
  }

  int selected1 = 0;
  var img = Image.asset("assets/shopping-bag 1.png");
  final _fromTop = true;
  //....................................... This for the add the total price of cart..............................
  double calculateTotalPrice() {
    double totalPrice = 0.0;
    int _counter = 1;
    for (var item in mycart) {
      _counter = int.parse("${item["item_qt"]}");
      totalPrice += _counter * double.parse(item['price_eu']);
    }
    return totalPrice;
  }

  // ............................. method for getting the data from the Hive............................................

  List<Map<String, dynamic>> mycart = [];
  List<Map<String, dynamic>> searchResults = [];
  var cartbox = Hive.box("cart_items");

  //....reading data from the data base
  readData() async {
    var data = cartbox.keys.map((key) {
      final item = cartbox.get(key);
      return {
        "key": key,
        "item_qt": item["total_quty"],
        "store_img": item["store_img"],
        "offername": item["offername"],
        "offervalid": item["offervalid"],
        "price_eu": item["price_eu"],
        "price_eupoints": ["price_eupoints"].toString(),
        "offer_img": item["offer_img"],
        "storename": item["storename"]
      };
    }).toList();
    setState(() {
      mycart = data.reversed.toList();
      searchResults = mycart; // making the cart searchable
      print(mycart);
    });
  }
  // For the search in the app based upon the prize and the name of the itsm which are added in the cart

  void search(String query) {
    final results = mycart.where((item) {
      final itemQt = item['item_qt'].toString().toLowerCase();
      final storeImg = item['store_img'].toString().toLowerCase();
      final offerName = item['offername'].toString().toLowerCase();
      final offerValid = item['offervalid'].toString().toLowerCase();
      final priceEu = item['price_eu'].toString().toLowerCase();
      final priceEuPoints = item['price_eupoints'].toString().toLowerCase();
      final offerImg = item['offer_img'].toString().toLowerCase();
      final storeName = item['storename'].toString().toLowerCase();
      final searchLower = query.toLowerCase();

      return itemQt.contains(searchLower) ||
          storeImg.contains(searchLower) ||
          offerName.contains(searchLower) ||
          offerValid.contains(searchLower) ||
          priceEu.contains(searchLower) ||
          priceEuPoints.contains(searchLower) ||
          offerImg.contains(searchLower) ||
          storeName.contains(searchLower);
    }).toList();

    setState(() {
      searchResults = results;
    });
  }








  // delete the items from cart.......................................

  deleteItem(int? key) async {
    await cartbox.delete(key);
    readData();
  }

  // for the show the store name according to the item in cart

  int _currentIndex = 0;

  @override
  void initState() {
    _controller = TabController(length: 4, vsync: this);
    super.initState();

    readData();
  }

  //............................................filter mycart items on the base of storename
  List<Map<String, dynamic>> filterCartByStore(String storeName) {
    return mycart.where((item) => item['storename'] == storeName).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double totalPrice = calculateTotalPrice();
    return Container(
      color: maincolor,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              toolbarHeight: 60,
              flexibleSpace: Card(
                shadowColor: Colors.grey[100],
                margin: EdgeInsets.zero,
                elevation: 1,
                color: Colors.white,
                child: TextFormField(
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                  cursorColor: maincolor,
                  onChanged: search,
                  decoration: InputDecoration(
                    hintText: 'searchitemsC'.tr,

                    hintStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 30,
                    ),
                    suffix: InkWell(
                      onTap: () {
                        alertBox();
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.add,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    suffixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(
                            Icons.more_vert,
                            size: 30,
                          ).addStarMenu(
                            onItemTapped: (index, controller) {
                              if (index == 0) {
                                // Share shopping cart
                                String cartContents = mycart.map((item) {
                                  return '''
                                  Item Name: ${item["offername"]}
                                    Store Name: ${item["storename"]}
                                        Price: ${item["price_eu"]}
                                                      ''';
                                }).join('\n');
                                Share.share("Check out my shopping cart:\n\n$cartContents");
                              } else {

                                 details_controller.cartbox.clear();
                                 readData();

                                print("delete button is being pressed");
                              }




                            },
                            items:[
                              const Text(
                                'Share shopping cart',
                                style: TextStyle(fontSize: 18),
                              ),
                              const Text(
                                'Delete shopping cart',
                                style: TextStyle(fontSize: 18),
                              ),
                            ] ,
                            params: StarMenuParameters.dropdown(context),
                          ),
                        ),
                      ],
                    ),
                    contentPadding: const EdgeInsets.only(
                      top: 11,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            body: mycart.isNotEmpty
                ? DefaultTabController(
                    length:
                        mycart.map((item) => item['storename']).toSet().length +
                            1,
                    child: Column(
                      children: [
                        Container(
                          height: size.height * 0.05,
                          color: Colors.white,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: mycart
                                    .map((item) => item['storename'])
                                    .toSet()
                                    .length +
                                1,
                            itemBuilder: (BuildContext context, index) {
                              if (index == 0) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _currentIndex = index;
                                    });
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    height: size.height * 0.06,
                                    width: size.height * 0.1,
                                    decoration: BoxDecoration(
                                        color: _currentIndex == index
                                            ? Colors.white
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Center(
                                      child: Text(
                                        'Sve',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: _currentIndex == index
                                              ? Colors.red
                                              : Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                var storeName = mycart
                                    .map((item) => item['storename'])
                                    .toSet()
                                    .toList()[index - 1];
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _currentIndex = index;
                                    });
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    height: size.height * 0.06,
                                    width: size.height * 0.1,
                                    decoration: BoxDecoration(
                                        color: _currentIndex == index
                                            ? Colors.white
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Center(
                                      child: Text(
                                        storeName,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: _currentIndex == index
                                              ? Colors.red
                                              : Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: IndexedStack(
                            index: _currentIndex,
                            children: [
                              ListView.builder(
                                padding: EdgeInsets.only(bottom: 60),
                                physics: AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:searchResults.isNotEmpty? searchResults.length :mycart.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var searcheditems=searchResults[index] ;
                                  var cart_items = mycart[index];
                                  _counter =
                                      int.parse("${cart_items["item_qt"]}");
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Card(
                                      margin: EdgeInsets.zero,
                                      shadowColor: Colors.grey.shade100,
                                      elevation: 3,
                                      color: Colors.white,
                                      child: Container(
                                        color: Colors.white,
                                        height: 215,
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Image.network(
                                                       searchResults.isNotEmpty? searcheditems["store_img"] :cart_items["store_img"],
                                                        width: 45,
                                                        scale: 0.6,
                                                      ),
                                                      const SizedBox(
                                                        height: 18,
                                                      ),
                                                      Container(
                                                        width: 150,
                                                        child: Image.network(
                                                         searchResults.isNotEmpty? searcheditems["offer_img"] :cart_items["offer_img"],
                                                          fit: BoxFit.fill,
                                                          height: 110,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 13, left: 20),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Container(
                                                              width: 170,
                                                              child: Text(
                                                               searchResults.isNotEmpty? searcheditems["offername"]:cart_items[
                                                                    "offername"],
                                                                style:
                                                                    sliderTextStyle,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Container(
                                                              width: 160,
                                                              child: Text(
                                                                  'Ponuda vrijedi do: ${searchResults.isNotEmpty? searcheditems["offervalid"] :cart_items["offervalid"]}',
                                                                  style: GoogleFonts.roboto(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.7))),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            // Text(
                                                            //   '${cart_items["price_eu"]} €',
                                                            //   style: GoogleFonts
                                                            //       .roboto(
                                                            //     fontWeight:
                                                            //         FontWeight
                                                            //             .w400,
                                                            //     fontSize: 12,
                                                            //     color: const Color(
                                                            //             0xff1E1E1E)
                                                            //         .withOpacity(
                                                            //             0.7),
                                                            //   ),
                                                            // ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  '${   searchResults.isNotEmpty? searcheditems["price_eu"].toString().substring(0, 1):cart_items["price_eu"].toString().substring(0, 1)},',
                                                                  style:
                                                                      GoogleFonts
                                                                          .roboto(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        33,
                                                                  ),
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        '${  searchResults.isNotEmpty? searcheditems["price_eu"].toString().substring(2, 4): cart_items["price_eu"].toString().substring(2, 4)}',
                                                                        style:
                                                                            sliderTextStyle),
                                                                    Text('€',
                                                                        style:
                                                                            sliderTextStyle),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15,
                                                    top: 30,
                                                    bottom: 20),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      child: IconButton(
                                                        onPressed: () {
                                                          deleteItem(cart_items[
                                                              "key"]);
                                                        },
                                                        icon:
                                                            Icon(Icons.delete),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              _decrementCounter(
                                                                  index);
                                                            });
                                                          },
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 13),
                                                            child: Icon(
                                                              Icons.minimize,
                                                              size: 30,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 17,
                                                        ),
                                                        Text(
                                                          "${_counter}",
                                                          // '$_counter',
                                                          style: const TextStyle(
                                                              fontSize: 25,
                                                              color: maincolor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              _counter =
                                                                  cart_items[
                                                                      "item_qt"];
                                                              _incrementCounter(
                                                                  index);
                                                            });
                                                          },
                                                          child: const Icon(
                                                            Icons.add,
                                                            size: 30,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              ...mycart
                                  .map(
                                    (item) => ListView.builder(
                                      padding: EdgeInsets.only(bottom: 60),
                                      physics: AlwaysScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          filterCartByStore(item['storename'])
                                              .length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var storeItems = filterCartByStore(
                                            item['storename']);
                                        var cartItem = storeItems[index];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Card(
                                            margin: EdgeInsets.zero,
                                            shadowColor: Colors.grey.shade100,
                                            elevation: 3,
                                            color: Colors.white,
                                            child: Container(
                                              color: Colors.white,
                                              height: 215,
                                              width: double.infinity,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, top: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Image.network(
                                                              cartItem[
                                                                  "store_img"],
                                                              width: 50,
                                                              scale: 0.6,
                                                            ),
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            Container(
                                                              width: 150,
                                                              child: Image.network(
                                                                cartItem[
                                                                    "offer_img"],
                                                                fit: BoxFit.fill,
                                                                height: 110,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 13),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Container(
                                                                    width: 170,
                                                                    child: Text(
                                                                      cartItem[
                                                                          "offername"],
                                                                      style:
                                                                          sliderTextStyle,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Container(
                                                                    width: 160,
                                                                    child: Text(
                                                                        'Ponuda vrijedi do: ${cartItem["offervalid"]}',
                                                                        style: GoogleFonts.roboto(
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.black.withOpacity(0.7))),
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    '${cartItem["price_eu"]} €',
                                                                    style: GoogleFonts
                                                                        .roboto(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          12,
                                                                      color: const Color(
                                                                              0xff1E1E1E)
                                                                          .withOpacity(
                                                                              0.7),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        '${cartItem["price_eu"].toString().substring(0, 1)},',
                                                                        style: GoogleFonts
                                                                            .roboto(
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontSize:
                                                                              33,
                                                                        ),
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              '${cartItem["price_eu"].toString().substring(2, 4)}',
                                                                              style: sliderTextStyle),
                                                                          Text(
                                                                              '€',
                                                                              style: sliderTextStyle),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 15,
                                                              top: 30,
                                                              bottom: 20),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 10),
                                                            child: IconButton(
                                                                onPressed: () {
                                                                  deleteItem(
                                                                      cartItem[
                                                                          "key"]);
                                                                },
                                                                icon: Icon(Icons
                                                                    .delete)),
                                                          ),
                                                          Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  _counter =
                                                                      cartItem[
                                                                          "item_qt"];
                                                                  _decrementCounter(
                                                                      index);
                                                                },
                                                                child:
                                                                    const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              13),
                                                                  child: Icon(
                                                                    Icons
                                                                        .minimize,
                                                                    size: 30,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 17,
                                                              ),
                                                              Text(
                                                                '$_counter',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        25,
                                                                    color:
                                                                        maincolor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  _counter = storeItems[
                                                                          index]
                                                                      [
                                                                      "item_qt"];
                                                                  _incrementCounter(
                                                                      index);
                                                                },
                                                                child:
                                                                    const Icon(
                                                                  Icons.add,
                                                                  size: 30,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        ),
                        Container(
                          height: 60,
                          width: double.infinity,
                          color: maincolor,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ukupan iznos košarice',
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${totalPrice.toStringAsFixed(2)} €',
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/Kosarica Icon_cropped.png",
                        height: 200,
                      ),
                      SizedBox(height: 15,),
                      Text("cart_empty".tr)
                    ],
                  ))),
      ),
    );
  }

  alertBox() {
    showGeneralDialog(
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position: Tween(
                    begin: Offset(0, _fromTop ? 0 : 0), end: const Offset(0, 0))
                .animate(anim1),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
        barrierColor: Colors.black45,
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Container(
              height: 320,
              child: Dialog(
                shape: const RoundedRectangleBorder(),
                // backgroundColor: Colors.black,
                child: Container(
                  height: 400,
                  width: 430,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, top: 25),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text(
                              'Add your item',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          cursorColor: maincolor,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: maincolor)),
                            hintText: 'Enter item name',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: double.infinity,
                          child:  DropdownButton<String>(
                            isExpanded: true,
                            alignment: Alignment.center,
                            value: details_controller.getAppDetails!.stores!.isNotEmpty?details_controller.getAppDetails!.stores![0].storeId.toString() :Selectedstore,
                            items:details_controller.getAppDetails!.stores!.map((e) => DropdownMenuItem(
                                value: e.storeId.toString(),
                                child: Row(
                                  children: [
                                    Image.network(e.storeImageUrl.toString()),
                                    Text(e.storeName.toString()),
                                  ],
                                )
                            )
                            ).toList()??[],
                            onChanged: (value) {
                              setState(() {
                                Selectedstore = value.toString();
                                print('Selected product: ${Selectedstore}');
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          cursorColor: maincolor,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: maincolor)),
                            hintText: 'Enter the price of the item',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        Row( mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                          TextButton(onPressed: () {
                            Get.back();

                          }, child: Text("Cancel",style: TextStyle(color: Colors.red,fontSize: 20),)),
                          TextButton(onPressed: () {
                            Get.back();

                          }, child: Text("Save",style: TextStyle(color: Colors.red,fontSize: 20),))
                        ],)


                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }
}
// there is working everything