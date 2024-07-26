import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:kosarica/Controller/AppDetails_Controller.dart';
import 'package:kosarica/core.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:star_menu/star_menu.dart';

import 'Models/appDetails_model.dart';

class FavouriteScreen extends StatefulWidget {
  FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  appDetails_controller controller = Get.find<appDetails_controller>();
  final TextEditingController _searchController = TextEditingController();

//................................. this is the method for getting data from the database................................

  //use for get values in bolean

  readData() async {
    var data = controller.F_box.keys.map((key) {
      final item = controller.F_box.get(key);
      return {
        "key": key,
        "store_catagory": item["data"],
      };
    }).toList();
    setState(() {
      controller.mycatagory = data.reversed.toList();
      print(controller.mycatagory);
      controller.values.clear();

      for (var item in controller.mycatagory) {
        for (var catagory in item['store_catagory']) {
          controller.values.add(catagory['value'] as bool);
        }
      }
    });
  }

  readData2() async {
    var data = controller.F_offers.keys.map((key) {
      final item = controller.F_offers.get(key);
      return {
        "key": key,
        "keyword":
            item["keyword"], // Assuming item["keyword"] is a List<dynamic>
      };
    }).toList();

    setState(() {
      controller.myoffers = data.reversed.toList();
      print(controller.myoffers);

      controller.keys
          .clear(); // Clear the keys list before populating it with new values

      for (var item in controller.myoffers) {
        if (item["keyword"] is List<String>) {
          // Check if item["keyword"] is a List<String>
          controller.keys
              .addAll(item["keyword"]); // Add all strings in the list directly
        } else if (item["keyword"] is String) {
          // Check if item["keyword"] is a single string
          controller.keys.add(item["keyword"]); // Add the single string
        }
      }
    });
  }

  // ......................... for delete the data of favourite keyword.................................
  // delete the items from cart.......................................

  deleteItem(int? key) async {
    await controller.F_offers.delete(key);
    readData();
  }

  // Method for filtering offers by search keyword
  List<Offers>? filterOffersBySearch(List<Offers>? offers, String searchKeyword) {
    if (offers == null || offers.isEmpty || searchKeyword.isEmpty) {
      return offers;
    }

    return offers.where((offer) {
      // Filter by article name or store name containing the search keyword
      return offer.articleName!.toLowerCase().contains(searchKeyword.toLowerCase()) ||
          offer.storeName!.toLowerCase().contains(searchKeyword.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    readData();
    readData2();
  }

  @override
  Widget build(BuildContext context) {
    print("F_catagoeis Get = ${controller.mycatagory}");
    // List<bool> valuesOnly = checkListItems.map((item) => item['value'] as bool).toList();

    print("F_catagories ${controller.F_catagory.length}");

    print("F_offers ${controller.myoffers}");
    print("F_offers ${controller.keys}");

    return Container(
      color: maincolor,
      child: GetBuilder<appDetails_controller>(
          id: "update_data",
          builder: (_) {
            List<Offers>? filteredOffers = controller.filterOffersByKeywords(
                controller.getAppDetails?.offers, controller.keys);
            filteredOffers = filterOffersBySearch(filteredOffers, _searchController.text);

            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: const Icon(
                        Icons.more_vert,
                        size: 30,
                        color: Colors.black,
                      ).addStarMenu(
                        items: [
                          InkWell(
                            onTap: () {
                              favouriteBox(context);
                            },
                            child: const Text(
                              'Favourite Categories',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              //  favouritestore(context);
                            },
                            child: const Text(
                              'Favourite Stores',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                        params: StarMenuParameters.dropdown(context),
                      ),
                    ),
                  ],
                  toolbarHeight: 60,
                  flexibleSpace: Card(
                    shadowColor: Colors.grey[100],
                    margin: EdgeInsets.zero,
                    elevation: 1,
                    color: Colors.white,
                    child: TextFormField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {

                        });
                      },
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                      cursorColor: maincolor,
                      decoration: InputDecoration(
                        hintText: 'searchitemsO'.tr,
                        hintStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 30,
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            alertBox();
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 60),
                            child: Icon(
                              Icons.add,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Column(
                    children: [
                      if (filteredOffers != null && filteredOffers.isNotEmpty)
                        Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: filteredOffers.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 170,
                              mainAxisSpacing: 7,
                              crossAxisSpacing: 30,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  print("Card is being tapped");
                                  cartSheet(
                                    filteredOffers![index].storeName.toString(),
                                    filteredOffers[index]
                                        .storeImageUrl
                                        .toString(),
                                    filteredOffers[index]
                                        .articleImageUrl
                                        .toString(),
                                    filteredOffers[index]
                                        .articleName
                                        .toString(),
                                    filteredOffers[index]
                                        .offerNewPriceEur
                                        .toString(),
                                    filteredOffers[index]
                                        .offerNewPriceHrk
                                        .toString()
                                        .substring(0, 1),
                                    filteredOffers[index]
                                        .offerNewPriceEur
                                        .toString()
                                        .substring(2, 4),
                                    filteredOffers[index]
                                        .offerNewPriceHrk
                                        .toString()
                                        .substring(2, 4),
                                    filteredOffers[index]
                                        .offerValueTo
                                        .toString(),
                                  );
                                },
                                child: Card(
                                  elevation: 2,
                                  color: Colors.white,
                                  child: Container(
                                    width: 160,
                                    height: 125,
                                    color:
                                        const Color.fromRGBO(255, 255, 255, 1),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Expanded(
                                          child: Image.network(
                                            filteredOffers![index]
                                                .articleImageUrl
                                                .toString(),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 160,
                                              child: Text(
                                                filteredOffers[index]
                                                            .articleName
                                                            .toString()
                                                            .length >
                                                        6
                                                    ? "${filteredOffers[index].articleName.toString()}"
                                                    : filteredOffers[index]
                                                        .articleName
                                                        .toString(),
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 3),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${filteredOffers[index].offerNewPriceEur.toString().substring(0, 1)}',
                                              style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    filteredOffers[index]
                                                        .offerNewPriceEur
                                                        .toString()
                                                        .substring(2, 4),
                                                    style: sliderTextStyle),
                                                Text('€',
                                                    style: sliderTextStyle),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      else
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/Kosarica Icon_cropped.png",
                                  height: 200,
                                ),
                                SizedBox(height: 15,),
                                Text("favorite_items".tr),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
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
                    begin: Offset(0, controller.fromTop ? 0 : 0),
                    end: const Offset(0, 0))
                .animate(anim1),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
        barrierColor: Colors.black45,
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
              shape: const RoundedRectangleBorder(),
              // backgroundColor: Colors.black,
              child: Container(
                height: 500,
                width: 430,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, top: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Row(
                            children: [
                              Text(
                                'Favourite Articles',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: controller.favoritename,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                            cursorColor: maincolor,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () async {
                                    var data = {
                                      "keyword": controller.favoritename.text
                                    };
                                    await controller.createFoffers(data);
                                    print(
                                        "data is add in the database succesfully");
                                    setState(
                                      () {
                                        readData2();
                                      },
                                    );
                                    controller.favoritename.clear();
                                  },
                                  icon: Icon(Icons.add)),
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
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300)),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: controller.myoffers.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    color: Colors.amber,
                                    child: Text(
                                      "${controller.myoffers[index]["keyword"]}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        deleteItem(
                                            controller.myoffers[index]["key"]);
                                        setState(
                                          () {
                                            readData2();
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.delete))
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 15, bottom: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'DELETE ALL',
                              style: TextStyle(
                                  color: maincolor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                            TextButton(
                              onPressed: () async {
                                //  controller.F_offers.clear();
                                // // var data={
                                // //   "keyword":controller.favoritename.text
                                // // };
                                // // await controller.createFoffers(data);
                                // // print("data is add in the database succesfully");
                                Navigator.pop(context);
                              },
                              child: Text(
                                'SAVE',
                                style: TextStyle(
                                    color: maincolor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  favouritestore(BuildContext context) {
    showGeneralDialog(
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position: Tween(
                    begin: Offset(0, controller.fromTop ? 0 : 0),
                    end: const Offset(0, 0))
                .animate(anim1),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
        barrierColor: Colors.black45,
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Dialog(
                shape: const RoundedRectangleBorder(),
                // backgroundColor: Colors.black,
                child: Container(
                  height: double.infinity,
                  width: 430,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        margin: EdgeInsets.zero,
                        color: Colors.white,
                        elevation: 2,
                        shadowColor: Colors.grey.shade100,
                        child: Container(
                          height: 60,
                          color: Colors.white,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              children: [
                                Text(
                                  'Favourites Stores',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: controller.getAppDetails!.stores!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Checkbox(
                                          checkColor: Colors.white,
                                          activeColor: maincolor,
                                          side: BorderSide(color: Colors.grey),
                                          value: controller.values.isEmpty
                                              ? controller.checkListItems[index]
                                                  ["value"]
                                              : controller.checkListItems[index]
                                                  ["value"],
                                          onChanged: (value) {
                                            setState(() {
                                              controller.checkListItems[index]
                                                  ["value"] = value;
                                              controller.values[index] = value!;
                                            });
                                          },
                                        ),
                                        Container(
                                          width: 300,
                                          child: Text(
                                            controller.getAppDetails!
                                                .stores![index].storeName
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                      Column(
                        children: [
                          Divider(
                            color: Colors.grey.shade300,
                          ),
                          Container(
                            height: 55,
                            color: Colors.white,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      await controller.F_catagory.clear();

                                      var data = {
                                        "data": controller.checkListItems
                                      };
                                      print("data $data");
                                      await controller.createFcatagories(data);
                                      print(
                                          "F_catagory update ${controller.F_catagory.length}");
                                      readData();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: maincolor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  favouriteBox(BuildContext context) {
    showGeneralDialog(
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position: Tween(
                    begin: Offset(0, controller.fromTop ? 0 : 0),
                    end: const Offset(0, 0))
                .animate(anim1),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
        barrierColor: Colors.black45,
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Dialog(
                shape: const RoundedRectangleBorder(),
                // backgroundColor: Colors.black,
                child: Container(
                  height: double.infinity,
                  width: 430,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        margin: EdgeInsets.zero,
                        color: Colors.white,
                        elevation: 2,
                        shadowColor: Colors.grey.shade100,
                        child: Container(
                          height: 60,
                          color: Colors.white,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              children: [
                                Text(
                                  'Favourites categories',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: controller.checkListItems.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Checkbox(
                                          checkColor: Colors.white,
                                          activeColor: maincolor,
                                          side: BorderSide(color: Colors.grey),
                                          value: controller.values.isEmpty
                                              ? controller.checkListItems[index]
                                                  ["value"]
                                              : controller.values[index],
                                          onChanged: (value) {
                                            setState(() {
                                              controller.checkListItems[index]
                                                  ["value"] = value!;
                                              controller.values[index] = value;
                                            });
                                          },
                                        ),
                                        Container(
                                          width: 300,
                                          child: Text(
                                            controller.getAppDetails!
                                                .categories![index].categoryName
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                      Column(
                        children: [
                          Divider(
                            color: Colors.grey.shade300,
                          ),
                          Container(
                            height: 55,
                            color: Colors.white,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      await controller.F_catagory.clear();

                                      var data = {
                                        "data": controller.checkListItems
                                      };
                                      print("data $data");
                                      await controller.createFcatagories(data);
                                      print(
                                          "F_catagory update ${controller.F_catagory.length}");
                                      readData();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: maincolor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  cartSheet(
      String storename,
      String storeimage,
      String offerimage,
      String offerdes,
      String offerPE,
      String offerPK,
      String offerPEpoints,
      String offerPKPoints,
      String valuedto) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Container(
          height: 505,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.network(
                          storeimage,
                          fit: BoxFit.fill,
                          height: 23,
                          width: 23,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          storename,
                          style: heading2,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                      ],
                    ),
                    Icon(
                      Icons.share_outlined,
                      color: Colors.black,
                      size: 28,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ponuda vrijedi do: ${valuedto}',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    )
                  ],
                ),
                Image.network(
                  offerimage,
                  fit: BoxFit.fill,
                  height: 214,
                  width: 214,
                ),
                Text(
                  offerdes,
                  style: heading2,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          offerPE.substring(0, 1),
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                            fontSize: 34,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(offerPEpoints, style: sliderTextStyle),
                            Text('€/kom', style: sliderTextStyle),
                          ],
                        ),
                        SizedBox(
                          width: 35,
                        ),
                        Row(
                          children: [
                            Text(
                              offerPK,
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w600,
                                fontSize: 34,
                                color: const Color(0xff1E1E1E).withOpacity(0.7),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  offerPKPoints,
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    color: const Color(0xff1E1E1E)
                                        .withOpacity(0.7),
                                  ),
                                ),
                                Text(
                                  'Kn/kom',
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    color: const Color(0xff1E1E1E)
                                        .withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.minimize,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            '1',
                            style: TextStyle(
                                fontSize: 25,
                                color: maincolor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Icon(
                              Icons.add,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () async {
                    var data = {
                      "store_img": storeimage,
                      "offername": offerdes,
                      "offervalid": valuedto,
                      "price_eu": offerPE,
                      "price_eupoints": storename,
                      "offer_img": offerimage,
                      "storename": storename
                    };
                    controller.createData(data);
                    await SnackBar(
                      content: Text("items is add in the cart succesfully"),
                      backgroundColor: Colors.black,
                    );

                    Get.back();
                  },
                  child: Card(
                    elevation: 3,
                    // color: Colors.white.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      height: 53,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: maincolor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 25,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'add_cart'.tr,
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}



//................................keep this data save for future changes ......................................


//
// List<Offers>? filteredOffers =controller. filterOffersByCategory(controller.getAppDetails?.offers, controller.getAppDetails?.categories, "Meso i delikatesa");
// List<Offers>? filteredOffers2 =controller. filterOffersByCategory(controller.getAppDetails?.offers, controller.getAppDetails?.categories, "Riba i plodovi mora");
// List<Offers>? filteredOffers3 =controller. filterOffersByCategory(controller.getAppDetails?.offers, controller.getAppDetails?.categories, "Mliječni proizvodi i jaja");
// List<Offers>? filteredOffers4 =controller. filterOffersByCategory(controller.getAppDetails?.offers, controller.getAppDetails?.categories, "Voće, povrće i biljke");
// List<Offers>? filteredOffers5 =controller. filterOffersByCategory(controller.getAppDetails?.offers, controller.getAppDetails?.categories, "Tjestenina i riža");
// List<Offers>? filteredOffers6 =controller. filterOffersByCategory(controller.getAppDetails?.offers, controller.getAppDetails?.categories, "Kruh i pekarski proizvodi");
// List<Offers>? filteredOffers7 =controller. filterOffersByCategory(controller.getAppDetails?.offers, controller.getAppDetails?.categories, "Kava, slatkiši i grickalice");
// List<Offers>? filteredOffers8 =controller. filterOffersByCategory(controller.getAppDetails?.offers, controller.getAppDetails?.categories, "Umaci i začini");
// List<Offers>? filteredOffers9 =controller. filterOffersByCategory(controller.getAppDetails?.offers, controller.getAppDetails?.categories, "Ostala hrana");
// List<Offers>? filteredOffers10 =controller. filterOffersByCategory(controller.getAppDetails?.offers, controller.getAppDetails?.categories, "Pića");
// List<Offers>? filteredOffers11 =controller. filterOffersByCategory(controller.getAppDetails?.offers, controller.getAppDetails?.categories, "Sredstva za čišćenje");
// List<Offers>? filteredOffers12 =controller. filterOffersByCategory(controller.getAppDetails?.offers, controller.getAppDetails?.categories, "Njega tijela");
// List<Offers>? filteredOffers13 =controller. filterOffersByCategory(controller.getAppDetails?.offers, controller.getAppDetails?.categories, "Higijenske potrepštine");
// List<Offers>? filteredOffers14 =controller. filterOffersByCategory(controller.getAppDetails?.offers, controller.getAppDetails?.categories, "Ostalo iz drogerije");
// List<Offers>? filteredOffers15 =controller. filterOffersByCategory(controller.getAppDetails?.offers, controller.getAppDetails?.categories, "Sve za kućanstvo");
// List<Offers>? filteredOffers16 =controller. filterOffersByCategory(controller.getAppDetails?.offers, controller.getAppDetails?.categories, "Odjeća i obuća");
// List<Offers>? filteredOffers17 =controller. filterOffersByCategory(controller.getAppDetails?.offers, controller.getAppDetails?.categories, "Sve za djecu");
// List<Offers>? filteredOffers18 =controller. filterOffersByCategory(controller.getAppDetails?.offers, controller.getAppDetails?.categories, "Sportska oprema");
// List<Offers>? filteredOffers19 =controller. filterOffersByCategory(controller.getAppDetails?.offers, controller.getAppDetails?.categories, "Kućni ljubimci");



// Column(
//   children: [
//     Visibility(
//       visible: values.isEmpty ? true:values[0],
//       child: Row(
//         children: [
//           Image.network(
//             '${controller.getAppDetails?.categories?[0].categoryImageUrl.toString()}',
//             fit: BoxFit.fill,
//             height: 23,
//             width: 23,
//           ),
//           const SizedBox(
//             width: 5,
//           ),
//           Text(
//             '${controller.getAppDetails?.categories?[0].categoryName.toString()}',
//             style: heading2,
//           ),
//           const SizedBox(
//             width: 7,
//           ),
//           SvgPicture.asset(
//             'assets/arrow-narrow-right 1.svg',
//             width: 20,
//             height: 20,
//           )
//         ],
//       ),
//     ),
//     const SizedBox(
//       height: 20,
//     ),
//     Padding(
//       padding: const EdgeInsets.only(left: 20),
//       child: Column(
//         children: [
//
//           SizedBox(
//             height: 15,
//           ),
//           Visibility(
//             visible: values.isEmpty ? true:values[0],
//             child: Container(
//               height: 160,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 itemCount: filteredOffers?.length ,
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     onTap:  () {
//                       cartSheet(
//                         filteredOffers![index].storeName.toString(),
//                         filteredOffers[index].storeImageUrl.toString(),
//                         filteredOffers[index].articleImageUrl.toString(),
//                         filteredOffers[index].articleName.toString(),
//                         filteredOffers[index].offerNewPriceEur.toString(),
//                         filteredOffers[index].offerNewPriceHrk.toString().substring(0,1),
//                         filteredOffers[index].offerNewPriceEur.toString().substring(2,4),
//                         filteredOffers[index].offerNewPriceHrk.toString().substring(2,4),
//                         filteredOffers[index].offerValueTo.toString(),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Card(
//                                 margin: EdgeInsets.zero,
//                                 elevation: 1,
//                                 child: Container(
//                                   height: 130,
//                                   width: 150,
//                                   color: Colors.white,
//                                   child: Column(
//                                     children: [
//                                       Expanded(
//                                         child: Image.network(
//                                           filteredOffers?[index].articleImageUrl.toString()?? "",
//                                           fit: BoxFit.cover,
//                                           width: 80,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment
//                                               .spaceBetween,
//                                           children: [
//                                             Text(
//                                               "${ filteredOffers?[index].articleName.toString().substring(0,6)}...",
//                                               style: productTitleStyle,
//                                               softWrap: true,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   filteredOffers?[index].offerNewPriceEur.toString().substring(0,1)??"",
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w700),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment
//                                                       .start,
//                                                   children: [
//                                                     Text(
//                                                       filteredOffers?[index].offerNewPriceEur.toString().substring(2,4)??"",
//                                                       style: const TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                     const Text(
//                                                       '€',
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//
//
//           Visibility(
//             visible: values.isEmpty ? true:values[1],
//             child: Row(
//               children: [
//                 Image.network(
//                   '${controller.getAppDetails?.categories?[1].categoryImageUrl.toString()}',
//                   fit: BoxFit.fill,
//                   height: 23,
//                   width: 23,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   '${controller.getAppDetails?.categories?[1].categoryName.toString()}',
//                   style: heading2,
//                 ),
//                 const SizedBox(
//                   width: 7,
//                 ),
//                 SvgPicture.asset(
//                   'assets/arrow-narrow-right 1.svg',
//                   width: 20,
//                   height: 20,
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Visibility(
//             visible: values.isEmpty ? true:values[1],
//             child: Container(
//               height: 160,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 itemCount: filteredOffers2?.length ,
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     onTap: () {
//                       cartSheet(
//                         filteredOffers2![index].storeName.toString(),
//                         filteredOffers2[index].storeImageUrl.toString(),
//                         filteredOffers2[index].articleImageUrl.toString(),
//                         filteredOffers2[index].articleName.toString(),
//                         filteredOffers2[index].offerNewPriceEur.toString(),
//                         filteredOffers2[index].offerNewPriceHrk.toString().substring(0,1),
//                         filteredOffers2[index].offerNewPriceEur.toString().substring(2,4),
//                         filteredOffers2[index].offerNewPriceHrk.toString().substring(2,4),
//                         filteredOffers2[index].offerValueTo.toString(),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Card(
//                                 margin: EdgeInsets.zero,
//                                 elevation: 1,
//                                 child: Container(
//                                   height: 130,
//                                   width: 150,
//                                   color: Colors.white,
//                                   child: Column(
//                                     children: [
//                                       Expanded(
//                                         child: Image.network(
//                                           filteredOffers2?[index].articleImageUrl.toString()?? "",
//                                           fit: BoxFit.cover,
//                                           width: 80,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment
//                                               .spaceBetween,
//                                           children: [
//                                             Text(
//                                               "${ filteredOffers2?[index].articleName.toString().substring(0,6)}...",
//                                               style: productTitleStyle,
//                                               softWrap: true,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   filteredOffers2?[index].offerNewPriceEur.toString().substring(0,1)??"",
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w700),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment
//                                                       .start,
//                                                   children: [
//                                                     Text(
//                                                       filteredOffers2?[index].offerNewPriceEur.toString().substring(2,4)??"",
//                                                       style: const TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                     const Text(
//                                                       '€',
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//
//
//           Visibility(
//             visible: values.isEmpty ? true:values[2],
//             child: Row(
//               children: [
//                 Image.network(
//                   '${controller.getAppDetails?.categories?[2].categoryImageUrl.toString()}',
//                   fit: BoxFit.fill,
//                   height: 23,
//                   width: 23,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   '${controller.getAppDetails?.categories?[2].categoryName.toString()}',
//                   style: heading2,
//                 ),
//                 const SizedBox(
//                   width: 7,
//                 ),
//                 SvgPicture.asset(
//                   'assets/arrow-narrow-right 1.svg',
//                   width: 20,
//                   height: 20,
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Visibility(
//             visible: values.isEmpty ? true:values[2],
//             child: Container(
//               height: 160,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 itemCount: filteredOffers3?.length ,
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     onTap: () {
//                       cartSheet(
//                         filteredOffers3![index].storeName.toString(),
//                         filteredOffers3[index].storeImageUrl.toString(),
//                         filteredOffers3[index].articleImageUrl.toString(),
//                         filteredOffers3[index].articleName.toString(),
//                         filteredOffers3[index].offerNewPriceEur.toString(),
//                         filteredOffers3[index].offerNewPriceHrk.toString().substring(0,1),
//                         filteredOffers3[index].offerNewPriceEur.toString().substring(2,4),
//                         filteredOffers3[index].offerNewPriceHrk.toString().substring(2,4),
//                         filteredOffers3[index].offerValueTo.toString(),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Card(
//                                 margin: EdgeInsets.zero,
//                                 elevation: 1,
//                                 child: Container(
//                                   height: 130,
//                                   width: 150,
//                                   color: Colors.white,
//                                   child: Column(
//                                     children: [
//                                       Expanded(
//                                         child: Image.network(
//                                           filteredOffers3?[index].articleImageUrl.toString()?? "",
//                                           fit: BoxFit.cover,
//                                           width: 80,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment
//                                               .spaceBetween,
//                                           children: [
//                                             Text(
//                                               "${ filteredOffers3?[index].articleName.toString().substring(0,6)}...",
//                                               style: productTitleStyle,
//                                               softWrap: true,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   filteredOffers3?[index].offerNewPriceEur.toString().substring(0,1)??"",
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w700),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment
//                                                       .start,
//                                                   children: [
//                                                     Text(
//                                                       filteredOffers3?[index].offerNewPriceEur.toString().substring(2,4)??"",
//                                                       style: const TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                     const Text(
//                                                       '€',
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//
//
//           Visibility(
//             visible: values.isEmpty ? true:values[3],
//             child: Row(
//               children: [
//                 Image.network(
//                   '${controller.getAppDetails?.categories?[3].categoryImageUrl.toString()}',
//                   fit: BoxFit.fill,
//                   height: 23,
//                   width: 23,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   '${controller.getAppDetails?.categories?[3].categoryName.toString()}',
//                   style: heading2,
//                 ),
//                 const SizedBox(
//                   width: 7,
//                 ),
//                 SvgPicture.asset(
//                   'assets/arrow-narrow-right 1.svg',
//                   width: 20,
//                   height: 20,
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Visibility(
//             visible: values.isEmpty ? true:values[3],
//             child: Container(
//               height: 160,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 itemCount: filteredOffers4?.length ,
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     onTap: () {
//                       cartSheet(
//                         filteredOffers4![index].storeName.toString(),
//                         filteredOffers4[index].storeImageUrl.toString(),
//                         filteredOffers4[index].articleImageUrl.toString(),
//                         filteredOffers4[index].articleName.toString(),
//                         filteredOffers4[index].offerNewPriceEur.toString(),
//                         filteredOffers4[index].offerNewPriceHrk.toString().substring(0,1),
//                         filteredOffers4[index].offerNewPriceEur.toString().substring(2,4),
//                         filteredOffers4[index].offerNewPriceHrk.toString().substring(2,4),
//                         filteredOffers4[index].offerValueTo.toString(),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Card(
//                                 margin: EdgeInsets.zero,
//                                 elevation: 1,
//                                 child: Container(
//                                   height: 130,
//                                   width: 150,
//                                   color: Colors.white,
//                                   child: Column(
//                                     children: [
//                                       Expanded(
//                                         child: Image.network(
//                                           filteredOffers4?[index].articleImageUrl.toString()?? "",
//                                           fit: BoxFit.cover,
//                                           width: 80,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment
//                                               .spaceBetween,
//                                           children: [
//                                             Text(
//                                               "${ filteredOffers4?[index].articleName.toString().substring(0,6)}...",
//                                               style: productTitleStyle,
//                                               softWrap: true,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   filteredOffers4?[index].offerNewPriceEur.toString().substring(0,1)??"",
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w700),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment
//                                                       .start,
//                                                   children: [
//                                                     Text(
//                                                       filteredOffers4?[index].offerNewPriceEur.toString().substring(2,4)??"",
//                                                       style: const TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                     const Text(
//                                                       '€',
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//
//
//           Visibility(
//             visible: values.isEmpty ? true:values[4],
//             child: Row(
//               children: [
//                 Image.network(
//                   '${controller.getAppDetails?.categories?[4].categoryImageUrl.toString()}',
//                   fit: BoxFit.fill,
//                   height: 23,
//                   width: 23,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   '${controller.getAppDetails?.categories?[4].categoryName.toString()}',
//                   style: heading2,
//                 ),
//                 const SizedBox(
//                   width: 7,
//                 ),
//                 SvgPicture.asset(
//                   'assets/arrow-narrow-right 1.svg',
//                   width: 20,
//                   height: 20,
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Visibility(
//             visible: values.isEmpty ? true:values[4],
//             child: Container(
//               height: 160,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 itemCount: filteredOffers5?.length ,
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     onTap: () {
//                       cartSheet(
//                         filteredOffers5![index].storeName.toString(),
//                         filteredOffers5[index].storeImageUrl.toString(),
//                         filteredOffers5[index].articleImageUrl.toString(),
//                         filteredOffers5[index].articleName.toString(),
//                         filteredOffers5[index].offerNewPriceEur.toString(),
//                         filteredOffers5[index].offerNewPriceHrk.toString().substring(0,1),
//                         filteredOffers5[index].offerNewPriceEur.toString().substring(2,4),
//                         filteredOffers5[index].offerNewPriceHrk.toString().substring(2,4),
//                         filteredOffers5[index].offerValueTo.toString(),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Card(
//                                 margin: EdgeInsets.zero,
//                                 elevation: 1,
//                                 child: Container(
//                                   height: 130,
//                                   width: 150,
//                                   color: Colors.white,
//                                   child: Column(
//                                     children: [
//                                       Expanded(
//                                         child: Image.network(
//                                           filteredOffers5?[index].articleImageUrl.toString()?? "",
//                                           fit: BoxFit.cover,
//                                           width: 80,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment
//                                               .spaceBetween,
//                                           children: [
//                                             Text(
//                                               filteredOffers![index].articleName.toString().length > 6
//                                                   ? "${filteredOffers[index].articleName.toString().substring(0, 6)}.."
//                                                   : filteredOffers[index].articleName.toString(),
//                                               style: productTitleStyle,
//                                               softWrap: true,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   filteredOffers5?[index].offerNewPriceEur.toString().substring(0,1)??"",
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w700),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment
//                                                       .start,
//                                                   children: [
//                                                     Text(
//                                                       filteredOffers5?[index].offerNewPriceEur.toString().substring(2,4)??"",
//                                                       style: const TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                     const Text(
//                                                       '€',
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//
//
//           Visibility(
//             visible: values.isEmpty ? true:values[5],
//             child: Row(
//               children: [
//                 Image.network(
//                   '${controller.getAppDetails?.categories?[5].categoryImageUrl.toString()}',
//                   fit: BoxFit.fill,
//                   height: 23,
//                   width: 23,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   '${controller.getAppDetails?.categories?[5].categoryName.toString()}',
//                   style: heading2,
//                 ),
//                 const SizedBox(
//                   width: 7,
//                 ),
//                 SvgPicture.asset(
//                   'assets/arrow-narrow-right 1.svg',
//                   width: 20,
//                   height: 20,
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Visibility(
//             visible: values.isEmpty ? true:values[5],
//             child: Container(
//               height: 160,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 itemCount: filteredOffers6?.length ,
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     onTap:() {
//                       cartSheet(
//                         filteredOffers6![index].storeName.toString(),
//                         filteredOffers6[index].storeImageUrl.toString(),
//                         filteredOffers6[index].articleImageUrl.toString(),
//                         filteredOffers6[index].articleName.toString(),
//                         filteredOffers6[index].offerNewPriceEur.toString(),
//                         filteredOffers6[index].offerNewPriceHrk.toString().substring(0,1),
//                         filteredOffers6[index].offerNewPriceEur.toString().substring(2,4),
//                         filteredOffers6[index].offerNewPriceHrk.toString().substring(2,4),
//                         filteredOffers6[index].offerValueTo.toString(),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Card(
//                                 margin: EdgeInsets.zero,
//                                 elevation: 1,
//                                 child: Container(
//                                   height: 130,
//                                   width: 150,
//                                   color: Colors.white,
//                                   child: Column(
//                                     children: [
//                                       Expanded(
//                                         child: Image.network(
//                                           filteredOffers6?[index].articleImageUrl.toString()?? "",
//                                           fit: BoxFit.cover,
//                                           width: 80,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment
//                                               .spaceBetween,
//                                           children: [
//                                             Text(
//                                               "${ filteredOffers6?[index].articleName.toString().substring(0,6)}...",
//                                               style: productTitleStyle,
//                                               softWrap: true,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   filteredOffers6?[index].offerNewPriceEur.toString().substring(0,1)??"",
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w700),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment
//                                                       .start,
//                                                   children: [
//                                                     Text(
//                                                       filteredOffers6?[index].offerNewPriceEur.toString().substring(2,4)??"",
//                                                       style: const TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                     const Text(
//                                                       '€',
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//
//
//           Visibility(
//             visible: values.isEmpty ? true:values[6],
//             child: Row(
//               children: [
//                 Image.network(
//                   '${controller.getAppDetails?.categories?[6].categoryImageUrl.toString()}',
//                   fit: BoxFit.fill,
//                   height: 23,
//                   width: 23,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   '${controller.getAppDetails?.categories?[6].categoryName.toString()}',
//                   style: heading2,
//                 ),
//                 const SizedBox(
//                   width: 7,
//                 ),
//                 SvgPicture.asset(
//                   'assets/arrow-narrow-right 1.svg',
//                   width: 20,
//                   height: 20,
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Visibility(
//             visible: values.isEmpty ? true:values[6],
//             child: Container(
//               height: 160,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 itemCount: filteredOffers7?.length ,
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     onTap: () {
//                       cartSheet(
//                         filteredOffers7![index].storeName.toString(),
//                         filteredOffers7[index].storeImageUrl.toString(),
//                         filteredOffers7[index].articleImageUrl.toString(),
//                         filteredOffers7[index].articleName.toString(),
//                         filteredOffers7[index].offerNewPriceEur.toString(),
//                         filteredOffers7[index].offerNewPriceHrk.toString().substring(0,1),
//                         filteredOffers7[index].offerNewPriceEur.toString().substring(2,4),
//                         filteredOffers7[index].offerNewPriceHrk.toString().substring(2,4),
//                         filteredOffers7[index].offerValueTo.toString(),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Card(
//                                 margin: EdgeInsets.zero,
//                                 elevation: 1,
//                                 child: Container(
//                                   height: 130,
//                                   width: 150,
//                                   color: Colors.white,
//                                   child: Column(
//                                     children: [
//                                       Expanded(
//                                         child: Image.network(
//                                           filteredOffers7?[index].articleImageUrl.toString()?? "",
//                                           fit: BoxFit.cover,
//                                           width: 80,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment
//                                               .spaceBetween,
//                                           children: [
//                                             Text(
//                                               filteredOffers7![index].articleName.toString().length > 6
//                                                   ? "${filteredOffers7[index].articleName.toString().substring(0, 6)}.."
//                                                   : filteredOffers7[index].articleName.toString(),
//                                               style: productTitleStyle,
//                                               softWrap: true,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   filteredOffers7?[index].offerNewPriceEur.toString().substring(0,1)??"",
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w700),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment
//                                                       .start,
//                                                   children: [
//                                                     Text(
//                                                       filteredOffers7?[index].offerNewPriceEur.toString().substring(2,4)??"",
//                                                       style: const TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                     const Text(
//                                                       '€',
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//
//
//           Visibility(
//             visible: values.isEmpty ? true:values[7],
//             child: Row(
//               children: [
//                 Image.network(
//                   '${controller.getAppDetails?.categories?[7].categoryImageUrl.toString()}',
//                   fit: BoxFit.fill,
//                   height: 23,
//                   width: 23,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   '${controller.getAppDetails?.categories?[7].categoryName.toString()}',
//                   style: heading2,
//                 ),
//                 const SizedBox(
//                   width: 7,
//                 ),
//                 SvgPicture.asset(
//                   'assets/arrow-narrow-right 1.svg',
//                   width: 20,
//                   height: 20,
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Visibility(
//             visible: values.isEmpty ? true:values[7],
//             child: Container(
//               height: 160,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 itemCount: filteredOffers8?.length ,
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     onTap: () {
//                       cartSheet(
//                         filteredOffers8![index].storeName.toString(),
//                         filteredOffers8[index].storeImageUrl.toString(),
//                         filteredOffers8[index].articleImageUrl.toString(),
//                         filteredOffers8[index].articleName.toString(),
//                         filteredOffers8[index].offerNewPriceEur.toString(),
//                         filteredOffers8[index].offerNewPriceHrk.toString().substring(0,1),
//                         filteredOffers8[index].offerNewPriceEur.toString().substring(2,4),
//                         filteredOffers8[index].offerNewPriceHrk.toString().substring(2,4),
//                         filteredOffers8[index].offerValueTo.toString(),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Card(
//                                 margin: EdgeInsets.zero,
//                                 elevation: 1,
//                                 child: Container(
//                                   height: 130,
//                                   width: 150,
//                                   color: Colors.white,
//                                   child: Column(
//                                     children: [
//                                       Expanded(
//                                         child: Image.network(
//                                           filteredOffers8?[index].articleImageUrl.toString()?? "",
//                                           fit: BoxFit.cover,
//                                           width: 80,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment
//                                               .spaceBetween,
//                                           children: [
//                                             Text(
//                                               "${ filteredOffers8?[index].articleName.toString().substring(0,6)}...",
//                                               style: productTitleStyle,
//                                               softWrap: true,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   filteredOffers8?[index].offerNewPriceEur.toString().substring(0,1)??"",
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w700),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment
//                                                       .start,
//                                                   children: [
//                                                     Text(
//                                                       filteredOffers8?[index].offerNewPriceEur.toString().substring(2,4)??"",
//                                                       style: const TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                     const Text(
//                                                       '€',
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//
//
//           Visibility(
//             visible: values.isEmpty ? true:values[8],
//             child: Row(
//               children: [
//                 Image.network(
//                   '${controller.getAppDetails?.categories?[8].categoryImageUrl.toString()}',
//                   fit: BoxFit.fill,
//                   height: 23,
//                   width: 23,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   '${controller.getAppDetails?.categories?[8].categoryName.toString()}',
//                   style: heading2,
//                 ),
//                 const SizedBox(
//                   width: 7,
//                 ),
//                 SvgPicture.asset(
//                   'assets/arrow-narrow-right 1.svg',
//                   width: 20,
//                   height: 20,
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Visibility(
//             visible: values.isEmpty ? true:values[8],
//             child: Container(
//               height: 160,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 itemCount: filteredOffers9?.length ,
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     onTap: () {
//                       cartSheet(
//                         filteredOffers9![index].storeName.toString(),
//                         filteredOffers9[index].storeImageUrl.toString(),
//                         filteredOffers9[index].articleImageUrl.toString(),
//                         filteredOffers9[index].articleName.toString(),
//                         filteredOffers9[index].offerNewPriceEur.toString(),
//                         filteredOffers9[index].offerNewPriceHrk.toString().substring(0,1),
//                         filteredOffers9[index].offerNewPriceEur.toString().substring(2,4),
//                         filteredOffers9[index].offerNewPriceHrk.toString().substring(2,4),
//                         filteredOffers9[index].offerValueTo.toString(),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Card(
//                                 margin: EdgeInsets.zero,
//                                 elevation: 1,
//                                 child: Container(
//                                   height: 130,
//                                   width: 150,
//                                   color: Colors.white,
//                                   child: Column(
//                                     children: [
//                                       Expanded(
//                                         child: Image.network(
//                                           filteredOffers9?[index].articleImageUrl.toString()?? "",
//                                           fit: BoxFit.cover,
//                                           width: 80,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment
//                                               .spaceBetween,
//                                           children: [
//                                             Text(
//                                               "${ filteredOffers9?[index].articleName.toString().substring(0,6)}...",
//                                               style: productTitleStyle,
//                                               softWrap: true,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   filteredOffers9?[index].offerNewPriceEur.toString().substring(0,1)??"",
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w700),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment
//                                                       .start,
//                                                   children: [
//                                                     Text(
//                                                       filteredOffers9?[index].offerNewPriceEur.toString().substring(2,4)??"",
//                                                       style: const TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                     const Text(
//                                                       '€',
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//
//
//           Visibility(
//             visible: values.isEmpty ? true:values[9],
//             child: Row(
//               children: [
//                 Image.network(
//                   '${controller.getAppDetails?.categories?[9].categoryImageUrl.toString()}',
//                   fit: BoxFit.fill,
//                   height: 23,
//                   width: 23,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   '${controller.getAppDetails?.categories?[9].categoryName.toString()}',
//                   style: heading2,
//                 ),
//                 const SizedBox(
//                   width: 7,
//                 ),
//                 SvgPicture.asset(
//                   'assets/arrow-narrow-right 1.svg',
//                   width: 20,
//                   height: 20,
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Visibility(
//             visible: values.isEmpty ? true:values[9],
//             child: Container(
//               height: 160,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 itemCount: filteredOffers10?.length ,
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     onTap: () {
//                       cartSheet(
//                         filteredOffers10![index].storeName.toString(),
//                         filteredOffers10[index].storeImageUrl.toString(),
//                         filteredOffers10[index].articleImageUrl.toString(),
//                         filteredOffers10[index].articleName.toString(),
//                         filteredOffers10[index].offerNewPriceEur.toString(),
//                         filteredOffers10[index].offerNewPriceHrk.toString().substring(0,1),
//                         filteredOffers10[index].offerNewPriceEur.toString().substring(2,4),
//                         filteredOffers10[index].offerNewPriceHrk.toString().substring(2,4),
//                         filteredOffers10[index].offerValueTo.toString(),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Card(
//                                 margin: EdgeInsets.zero,
//                                 elevation: 1,
//                                 child: Container(
//                                   height: 130,
//                                   width: 150,
//                                   color: Colors.white,
//                                   child: Column(
//                                     children: [
//                                       Expanded(
//                                         child: Image.network(
//                                           filteredOffers10?[index].articleImageUrl.toString()?? "",
//                                           fit: BoxFit.cover,
//                                           width: 80,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment
//                                               .spaceBetween,
//                                           children: [
//                                             Text(
//                                               "${ filteredOffers10?[index].articleName.toString().substring(0,6)}...",
//                                               style: productTitleStyle,
//                                               softWrap: true,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   filteredOffers10?[index].offerNewPriceEur.toString().substring(0,1)??"",
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w700),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment
//                                                       .start,
//                                                   children: [
//                                                     Text(
//                                                       filteredOffers10?[index].offerNewPriceEur.toString().substring(2,4)??"",
//                                                       style: const TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                     const Text(
//                                                       '€',
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//
//
//           Visibility(
//             visible: values.isEmpty ? true:values[10],
//             child: Row(
//               children: [
//                 Image.network(
//                   '${controller.getAppDetails?.categories?[10].categoryImageUrl.toString()}',
//                   fit: BoxFit.fill,
//                   height: 23,
//                   width: 23,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   '${controller.getAppDetails?.categories?[10].categoryName.toString()}',
//                   style: heading2,
//                 ),
//                 const SizedBox(
//                   width: 7,
//                 ),
//                 SvgPicture.asset(
//                   'assets/arrow-narrow-right 1.svg',
//                   width: 20,
//                   height: 20,
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Visibility(
//             visible: values.isEmpty ? true:values[10],
//             child: Container(
//               height: 160,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 itemCount: filteredOffers11?.length ,
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     onTap:() {
//                       cartSheet(
//                         filteredOffers11![index].storeName.toString(),
//                         filteredOffers11[index].storeImageUrl.toString(),
//                         filteredOffers11[index].articleImageUrl.toString(),
//                         filteredOffers11[index].articleName.toString(),
//                         filteredOffers11[index].offerNewPriceEur.toString(),
//                         filteredOffers11[index].offerNewPriceHrk.toString().substring(0,1),
//                         filteredOffers11[index].offerNewPriceEur.toString().substring(2,4),
//                         filteredOffers11[index].offerNewPriceHrk.toString().substring(2,4),
//                         filteredOffers11[index].offerValueTo.toString(),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Card(
//                                 margin: EdgeInsets.zero,
//                                 elevation: 1,
//                                 child: Container(
//                                   height: 130,
//                                   width: 150,
//                                   color: Colors.white,
//                                   child: Column(
//                                     children: [
//                                       Expanded(
//                                         child: Image.network(
//                                           filteredOffers11?[index].articleImageUrl.toString()?? "",
//                                           fit: BoxFit.cover,
//                                           width: 80,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment
//                                               .spaceBetween,
//                                           children: [
//                                             Text(
//                                               "${ filteredOffers11?[index].articleName.toString().substring(0,6)}...",
//                                               style: productTitleStyle,
//                                               softWrap: true,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   filteredOffers11?[index].offerNewPriceEur.toString().substring(0,1)??"",
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w700),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment
//                                                       .start,
//                                                   children: [
//                                                     Text(
//                                                       filteredOffers11?[index].offerNewPriceEur.toString().substring(2,4)??"",
//                                                       style: const TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                     const Text(
//                                                       '€',
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//
//
//           Visibility(
//             visible: values.isEmpty ? true:values[11],
//             child: Row(
//               children: [
//                 Image.network(
//                   '${controller.getAppDetails?.categories?[11].categoryImageUrl.toString()}',
//                   fit: BoxFit.fill,
//                   height: 23,
//                   width: 23,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   '${controller.getAppDetails?.categories?[11].categoryName.toString()}',
//                   style: heading2,
//                 ),
//                 const SizedBox(
//                   width: 7,
//                 ),
//                 SvgPicture.asset(
//                   'assets/arrow-narrow-right 1.svg',
//                   width: 20,
//                   height: 20,
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Visibility(
//             visible: values.isEmpty ? true:values[11],
//             child: Container(
//               height: 160,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 itemCount: filteredOffers12?.length ,
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     onTap: () {
//                       cartSheet(
//                         filteredOffers12![index].storeName.toString(),
//                         filteredOffers12[index].storeImageUrl.toString(),
//                         filteredOffers12[index].articleImageUrl.toString(),
//                         filteredOffers12[index].articleName.toString(),
//                         filteredOffers12[index].offerNewPriceEur.toString(),
//                         filteredOffers12[index].offerNewPriceHrk.toString().substring(0,1),
//                         filteredOffers12[index].offerNewPriceEur.toString().substring(2,4),
//                         filteredOffers12[index].offerNewPriceHrk.toString().substring(2,4),
//                         filteredOffers12[index].offerValueTo.toString(),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Card(
//                                 margin: EdgeInsets.zero,
//                                 elevation: 1,
//                                 child: Container(
//                                   height: 130,
//                                   width: 150,
//                                   color: Colors.white,
//                                   child: Column(
//                                     children: [
//                                       Expanded(
//                                         child: Image.network(
//                                           filteredOffers12?[index].articleImageUrl.toString()?? "",
//                                           fit: BoxFit.cover,
//                                           width: 80,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment
//                                               .spaceBetween,
//                                           children: [
//                                             Text(
//                                               "${ filteredOffers12?[index].articleName.toString().substring(0,6)}...",
//                                               style: productTitleStyle,
//                                               softWrap: true,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   filteredOffers12?[index].offerNewPriceEur.toString().substring(0,1)??"",
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w700),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment
//                                                       .start,
//                                                   children: [
//                                                     Text(
//                                                       filteredOffers12?[index].offerNewPriceEur.toString().substring(2,4)??"",
//                                                       style: const TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                     const Text(
//                                                       '€',
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//
//
//           Visibility(
//             visible: values.isEmpty ? true:values[12],
//             child: Row(
//               children: [
//                 Image.network(
//                   '${controller.getAppDetails?.categories?[12].categoryImageUrl.toString()}',
//                   fit: BoxFit.fill,
//                   height: 23,
//                   width: 23,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   '${controller.getAppDetails?.categories?[12].categoryName.toString()}',
//                   style: heading2,
//                 ),
//                 const SizedBox(
//                   width: 7,
//                 ),
//                 SvgPicture.asset(
//                   'assets/arrow-narrow-right 1.svg',
//                   width: 20,
//                   height: 20,
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Visibility(
//             visible: values.isEmpty ? true:values[12],
//             child: Container(
//               height: 160,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 itemCount: filteredOffers13?.length ,
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     onTap: () {
//                       cartSheet(
//                         filteredOffers13![index].storeName.toString(),
//                         filteredOffers13[index].storeImageUrl.toString(),
//                         filteredOffers13[index].articleImageUrl.toString(),
//                         filteredOffers13[index].articleName.toString(),
//                         filteredOffers13[index].offerNewPriceEur.toString(),
//                         filteredOffers13[index].offerNewPriceHrk.toString().substring(0,1),
//                         filteredOffers13[index].offerNewPriceEur.toString().substring(2,4),
//                         filteredOffers13[index].offerNewPriceHrk.toString().substring(2,4),
//                         filteredOffers13[index].offerValueTo.toString(),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Card(
//                                 margin: EdgeInsets.zero,
//                                 elevation: 1,
//                                 child: Container(
//                                   height: 130,
//                                   width: 150,
//                                   color: Colors.white,
//                                   child: Column(
//                                     children: [
//                                       Expanded(
//                                         child: Image.network(
//                                           filteredOffers13?[index].articleImageUrl.toString()?? "",
//                                           fit: BoxFit.cover,
//                                           width: 80,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment
//                                               .spaceBetween,
//                                           children: [
//                                             Text(
//                                               "${ filteredOffers13?[index].articleName.toString().substring(0,6)}...",
//                                               style: productTitleStyle,
//                                               softWrap: true,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   filteredOffers13?[index].offerNewPriceEur.toString().substring(0,1)??"",
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w700),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment
//                                                       .start,
//                                                   children: [
//                                                     Text(
//                                                       filteredOffers13?[index].offerNewPriceEur.toString().substring(2,4)??"",
//                                                       style: const TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                     const Text(
//                                                       '€',
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//
//
//           Visibility(
//             visible: values.isEmpty ? true:values[13],
//             child: Row(
//               children: [
//                 Image.network(
//                   '${controller.getAppDetails?.categories?[13].categoryImageUrl.toString()}',
//                   fit: BoxFit.fill,
//                   height: 23,
//                   width: 23,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   '${controller.getAppDetails?.categories?[13].categoryName.toString()}',
//                   style: heading2,
//                 ),
//                 const SizedBox(
//                   width: 7,
//                 ),
//                 SvgPicture.asset(
//                   'assets/arrow-narrow-right 1.svg',
//                   width: 20,
//                   height: 20,
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Visibility(
//             visible: values.isEmpty ? true:values[13],
//             child: Container(
//               height: 160,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 itemCount: filteredOffers14?.length ,
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     onTap: () {
//                       cartSheet(
//                         filteredOffers14![index].storeName.toString(),
//                         filteredOffers14[index].storeImageUrl.toString(),
//                         filteredOffers14[index].articleImageUrl.toString(),
//                         filteredOffers14[index].articleName.toString(),
//                         filteredOffers14[index].offerNewPriceEur.toString(),
//                         filteredOffers14[index].offerNewPriceHrk.toString().substring(0,1),
//                         filteredOffers14[index].offerNewPriceEur.toString().substring(2,4),
//                         filteredOffers14[index].offerNewPriceHrk.toString().substring(2,4),
//                         filteredOffers14[index].offerValueTo.toString(),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Card(
//                                 margin: EdgeInsets.zero,
//                                 elevation: 1,
//                                 child: Container(
//                                   height: 130,
//                                   width: 150,
//                                   color: Colors.white,
//                                   child: Column(
//                                     children: [
//                                       Expanded(
//                                         child: Image.network(
//                                           filteredOffers14?[index].articleImageUrl.toString()?? "",
//                                           fit: BoxFit.cover,
//                                           width: 80,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment
//                                               .spaceBetween,
//                                           children: [
//                                             Text(
//                                               "${ filteredOffers14?[index].articleName.toString().substring(0,6)}...",
//                                               style: productTitleStyle,
//                                               softWrap: true,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   filteredOffers14?[index].offerNewPriceEur.toString().substring(0,1)??"",
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w700),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment
//                                                       .start,
//                                                   children: [
//                                                     Text(
//                                                       filteredOffers14?[index].offerNewPriceEur.toString().substring(2,4)??"",
//                                                       style: const TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                     const Text(
//                                                       '€',
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//
//
//           Visibility(
//             visible: values.isEmpty ? true:values[14],
//             child: Row(
//               children: [
//                 Image.network(
//                   '${controller.getAppDetails?.categories?[14].categoryImageUrl.toString()}',
//                   fit: BoxFit.fill,
//                   height: 23,
//                   width: 23,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   '${controller.getAppDetails?.categories?[14].categoryName.toString()}',
//                   style: heading2,
//                 ),
//                 const SizedBox(
//                   width: 7,
//                 ),
//                 SvgPicture.asset(
//                   'assets/arrow-narrow-right 1.svg',
//                   width: 20,
//                   height: 20,
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Visibility(
//             visible: values.isEmpty ? true:values[14],
//             child: Container(
//               height: 160,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 itemCount: filteredOffers15?.length ,
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     onTap: () {
//                       cartSheet(
//                         filteredOffers15![index].storeName.toString(),
//                         filteredOffers15[index].storeImageUrl.toString(),
//                         filteredOffers15[index].articleImageUrl.toString(),
//                         filteredOffers15[index].articleName.toString(),
//                         filteredOffers15[index].offerNewPriceEur.toString(),
//                         filteredOffers15[index].offerNewPriceHrk.toString().substring(0,1),
//                         filteredOffers15[index].offerNewPriceEur.toString().substring(2,4),
//                         filteredOffers15[index].offerNewPriceHrk.toString().substring(2,4),
//                         filteredOffers15[index].offerValueTo.toString(),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Card(
//                                 margin: EdgeInsets.zero,
//                                 elevation: 1,
//                                 child: Container(
//                                   height: 130,
//                                   width: 150,
//                                   color: Colors.white,
//                                   child: Column(
//                                     children: [
//                                       Expanded(
//                                         child: Image.network(
//                                           filteredOffers15?[index].articleImageUrl.toString()?? "",
//                                           fit: BoxFit.cover,
//                                           width: 80,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment
//                                               .spaceBetween,
//                                           children: [
//                                             Text(
//                                               "${ filteredOffers15?[index].articleName.toString().substring(0,6)}...",
//                                               style: productTitleStyle,
//                                               softWrap: true,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   filteredOffers15?[index].offerNewPriceEur.toString().substring(0,1)??"",
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w700),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment
//                                                       .start,
//                                                   children: [
//                                                     Text(
//                                                       filteredOffers15?[index].offerNewPriceEur.toString().substring(2,4)??"",
//                                                       style: const TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                     const Text(
//                                                       '€',
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//
//
//           Visibility(
//             visible: values.isEmpty ? true:values[15],
//             child: Row(
//               children: [
//                 Image.network(
//                   '${controller.getAppDetails?.categories?[15].categoryImageUrl.toString()}',
//                   fit: BoxFit.fill,
//                   height: 23,
//                   width: 23,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   '${controller.getAppDetails?.categories?[15].categoryName.toString()}',
//                   style: heading2,
//                 ),
//                 const SizedBox(
//                   width: 7,
//                 ),
//                 SvgPicture.asset(
//                   'assets/arrow-narrow-right 1.svg',
//                   width: 20,
//                   height: 20,
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Visibility(
//             visible: values.isEmpty ? true:values[15],
//             child: Container(
//               height: 160,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 itemCount: filteredOffers16?.length ,
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     onTap: () {
//                       cartSheet(
//                         filteredOffers16![index].storeName.toString(),
//                         filteredOffers16[index].storeImageUrl.toString(),
//                         filteredOffers16[index].articleImageUrl.toString(),
//                         filteredOffers16[index].articleName.toString(),
//                         filteredOffers16[index].offerNewPriceEur.toString(),
//                         filteredOffers16[index].offerNewPriceHrk.toString().substring(0,1),
//                         filteredOffers16[index].offerNewPriceEur.toString().substring(2,4),
//                         filteredOffers16[index].offerNewPriceHrk.toString().substring(2,4),
//                         filteredOffers16[index].offerValueTo.toString(),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Card(
//                                 margin: EdgeInsets.zero,
//                                 elevation: 1,
//                                 child: Container(
//                                   height: 130,
//                                   width: 150,
//                                   color: Colors.white,
//                                   child: Column(
//                                     children: [
//                                       Expanded(
//                                         child: Image.network(
//                                           filteredOffers16?[index].articleImageUrl.toString()?? "",
//                                           fit: BoxFit.cover,
//                                           width: 80,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment
//                                               .spaceBetween,
//                                           children: [
//                                             Text(
//                                               filteredOffers16![index].articleName.toString().length > 6
//                                                   ? "${filteredOffers16[index].articleName.toString().substring(0, 6)}.."
//                                                   : filteredOffers16[index].articleName.toString(),
//                                               style: productTitleStyle,
//                                               softWrap: true,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   filteredOffers16?[index].offerNewPriceEur.toString().substring(0,1)??"",
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w700),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment
//                                                       .start,
//                                                   children: [
//                                                     Text(
//                                                       filteredOffers16?[index].offerNewPriceEur.toString().substring(2,4)??"",
//                                                       style: const TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                     const Text(
//                                                       '€',
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//
//
//           Visibility(
//             visible: values.isEmpty ? true:values[16],
//             child: Row(
//               children: [
//                 Image.network(
//                   '${controller.getAppDetails?.categories?[16].categoryImageUrl.toString()}',
//                   fit: BoxFit.fill,
//                   height: 23,
//                   width: 23,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   '${controller.getAppDetails?.categories?[16].categoryName.toString()}',
//                   style: heading2,
//                 ),
//                 const SizedBox(
//                   width: 7,
//                 ),
//                 SvgPicture.asset(
//                   'assets/arrow-narrow-right 1.svg',
//                   width: 20,
//                   height: 20,
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Visibility(
//             visible: values.isEmpty ? true:values[16],
//             child: Container(
//               height: 160,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 itemCount: filteredOffers17?.length ,
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     onTap: () {
//                       cartSheet(
//                         filteredOffers17![index].storeName.toString(),
//                         filteredOffers17[index].storeImageUrl.toString(),
//                         filteredOffers17[index].articleImageUrl.toString(),
//                         filteredOffers17[index].articleName.toString(),
//                         filteredOffers17[index].offerNewPriceEur.toString(),
//                         filteredOffers17[index].offerNewPriceHrk.toString().substring(0,1),
//                         filteredOffers17[index].offerNewPriceEur.toString().substring(2,4),
//                         filteredOffers17[index].offerNewPriceHrk.toString().substring(2,4),
//                         filteredOffers17[index].offerValueTo.toString(),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Card(
//                                 margin: EdgeInsets.zero,
//                                 elevation: 1,
//                                 child: Container(
//                                   height: 130,
//                                   width: 150,
//                                   color: Colors.white,
//                                   child: Column(
//                                     children: [
//                                       Expanded(
//                                         child: Image.network(
//                                           filteredOffers17?[index].articleImageUrl.toString()?? "",
//                                           fit: BoxFit.cover,
//                                           width: 80,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment
//                                               .spaceBetween,
//                                           children: [
//                                             Text(
//                                               "${ filteredOffers17?[index].articleName.toString().substring(0,6)}...",
//                                               style: productTitleStyle,
//                                               softWrap: true,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   filteredOffers17?[index].offerNewPriceEur.toString().substring(0,1)??"",
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w700),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment
//                                                       .start,
//                                                   children: [
//                                                     Text(
//                                                       filteredOffers17?[index].offerNewPriceEur.toString().substring(2,4)??"",
//                                                       style: const TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                     const Text(
//                                                       '€',
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//
//
//           Visibility(
//             visible: values.isEmpty ? true:values[17],
//             child: Row(
//               children: [
//                 Image.network(
//                   '${controller.getAppDetails?.categories?[17].categoryImageUrl.toString()}',
//                   fit: BoxFit.fill,
//                   height: 23,
//                   width: 23,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   '${controller.getAppDetails?.categories?[17].categoryName.toString()}',
//                   style: heading2,
//                 ),
//                 const SizedBox(
//                   width: 7,
//                 ),
//                 SvgPicture.asset(
//                   'assets/arrow-narrow-right 1.svg',
//                   width: 20,
//                   height: 20,
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Visibility(
//             visible: values.isEmpty ? true:values[17],
//             child: Container(
//               height: 160,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 itemCount: filteredOffers18?.length ,
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     onTap: () {
//                       cartSheet(
//                         filteredOffers18![index].storeName.toString(),
//                         filteredOffers18[index].storeImageUrl.toString(),
//                         filteredOffers18[index].articleImageUrl.toString(),
//                         filteredOffers18[index].articleName.toString(),
//                         filteredOffers18[index].offerNewPriceEur.toString(),
//                         filteredOffers18[index].offerNewPriceHrk.toString().substring(0,1),
//                         filteredOffers18[index].offerNewPriceEur.toString().substring(2,4),
//                         filteredOffers18[index].offerNewPriceHrk.toString().substring(2,4),
//                         filteredOffers18[index].offerValueTo.toString(),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Card(
//                                 margin: EdgeInsets.zero,
//                                 elevation: 1,
//                                 child: Container(
//                                   height: 130,
//                                   width: 150,
//                                   color: Colors.white,
//                                   child: Column(
//                                     children: [
//                                       Expanded(
//                                         child: Image.network(
//                                           filteredOffers18?[index].articleImageUrl.toString()?? "",
//                                           fit: BoxFit.cover,
//                                           width: 80,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment
//                                               .spaceBetween,
//                                           children: [
//                                             Text(
//                                               "${ filteredOffers18?[index].articleName.toString().substring(0,6)}...",
//                                               style: productTitleStyle,
//                                               softWrap: true,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   filteredOffers18?[index].offerNewPriceEur.toString().substring(0,1)??"",
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w700),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment
//                                                       .start,
//                                                   children: [
//                                                     Text(
//                                                       filteredOffers18?[index].offerNewPriceEur.toString().substring(2,4)??"",
//                                                       style: const TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                     const Text(
//                                                       '€',
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//
//
//           Visibility(
//             visible: values.isEmpty ? true:values[18],
//
//             child: Row(
//               children: [
//                 Image.network(
//                   '${controller.getAppDetails?.categories?[18].categoryImageUrl.toString()}',
//                   fit: BoxFit.fill,
//                   height: 23,
//                   width: 23,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   '${controller.getAppDetails?.categories?[18].categoryName.toString()}',
//                   style: heading2,
//                 ),
//                 const SizedBox(
//                   width: 7,
//                 ),
//                 SvgPicture.asset(
//                   'assets/arrow-narrow-right 1.svg',
//                   width: 20,
//                   height: 20,
//                 )
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Visibility(
//             visible: values.isEmpty ? true:values[18],
//             child: Container(
//               height: 160,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 itemCount: filteredOffers19?.length ,
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     onTap:() {
//                       cartSheet(
//                         filteredOffers19![index].storeName.toString(),
//                         filteredOffers19[index].storeImageUrl.toString(),
//                         filteredOffers19[index].articleImageUrl.toString(),
//                         filteredOffers19[index].articleName.toString(),
//                         filteredOffers19[index].offerNewPriceEur.toString(),
//                         filteredOffers19[index].offerNewPriceHrk.toString().substring(0,1),
//                         filteredOffers19[index].offerNewPriceEur.toString().substring(2,4),
//                         filteredOffers19[index].offerNewPriceHrk.toString().substring(2,4),
//                         filteredOffers19[index].offerValueTo.toString(),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Card(
//                                 margin: EdgeInsets.zero,
//                                 elevation: 1,
//                                 child: Container(
//                                   height: 130,
//                                   width: 150,
//                                   color: Colors.white,
//                                   child: Column(
//                                     children: [
//                                       Expanded(
//                                         child: Image.network(
//                                           filteredOffers19?[index].articleImageUrl.toString()?? "",
//                                           fit: BoxFit.cover,
//                                           width: 80,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment
//                                               .spaceBetween,
//                                           children: [
//                                             Text(
//                                               "${ filteredOffers19?[index].articleName.toString().substring(0,6)}...",
//                                               style: productTitleStyle,
//                                               softWrap: true,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   filteredOffers19?[index].offerNewPriceEur.toString().substring(0,1)??"",
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w700),
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                   CrossAxisAlignment
//                                                       .start,
//                                                   children: [
//                                                     Text(
//                                                       filteredOffers19?[index].offerNewPriceEur.toString().substring(2,4)??"",
//                                                       style: const TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                     const Text(
//                                                       '€',
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w700),
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           )
//         ],
//       ),
//     ),
//   ],
// ),



