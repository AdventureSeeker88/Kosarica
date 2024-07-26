import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kosarica/ButtomBar.dart';
import 'package:kosarica/Controller/AppDetails_Controller.dart';
import 'package:kosarica/Gas_Station.dart';
import 'package:kosarica/Languages/Language%20change%20dialoge.dart';

import 'package:kosarica/constants/color_text.dart';
// import 'package:share_plus/share_plus.dart';

import 'Alert_boxes/Defu_currency.dart';
import 'Alert_boxes/Defu_order.dart';
import 'Alert_boxes/Defu_sorting_method.dart';
import 'Alert_boxes/Show_offer_by_day.dart';
import 'koverter_screen.dart';

class viewoption extends StatefulWidget {
  viewoption({
    super.key,
  });

  @override
  State<viewoption> createState() => _viewoptionState();
}

class _viewoptionState extends State<viewoption> {
  appDetails_controller controller = Get.find<appDetails_controller>();

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

  deleteItem(int? key) async {
    await controller.F_offers.delete(key);
    readData();
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
    return Container(
      color: maincolor,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("View option"),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    elevation: 5,
                    color: Colors.white,
                    child: Container(
                      color: Colors.white,
                      height: 80,
                      child: Center(
                        child: ListTile(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return view_by_day();
                                },
                              );
                            },
                            tileColor: Colors.white,
                            leading: Icon(
                              Icons.date_range,
                              size: 31,
                            ),
                            subtitle: Text(
                              "show_offer_byday_sub".tr,
                              style: TextStyle(fontSize: 13),
                            ),
                            title: Text(
                              "show_offer_byday".tr,
                              style: sliderTextStyle,
                            )),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    color: Colors.white,
                    child: Container(
                      color: Colors.white,
                      height: 80,
                      child: Center(
                        child: ListTile(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Defu_Sorting_method();
                                },
                              );
                            },
                            tileColor: Colors.white,
                            leading: Icon(
                              Icons.view_array,
                              size: 31,
                            ),
                            subtitle: Text(
                              "D_sorting_method_sub".tr,
                              style: TextStyle(fontSize: 13),
                            ),
                            title: Text(
                              "D_sorting_method".tr,
                              style: sliderTextStyle,
                            )),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    color: Colors.white,
                    child: Container(
                      color: Colors.white,
                      height: 80,
                      child: Center(
                        child: ListTile(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Defu_order();
                                },
                              );
                            },
                            tileColor: Colors.white,
                            leading: Icon(Icons.list_outlined),
                            subtitle: Text('D_order_sub'.tr),
                            title: Text(
                              "D_order".tr,
                              style: sliderTextStyle,
                            )),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    color: Colors.white,
                    child: Container(
                      color: Colors.white,
                      height: 80,
                      child: Center(
                        child: ListTile(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Defu_currency();
                                },
                              );
                            },
                            tileColor: Colors.white,
                            leading: Icon(Icons.currency_exchange_outlined),
                            subtitle: Text("D_currency_show_sub".tr),
                            title: Text(
                              "D_currency_show".tr,
                              style: sliderTextStyle,
                            )),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    color: Colors.white,
                    child: Container(
                      color: Colors.white,
                      height: 80,
                      child: Center(
                        child: ListTile(
                            onTap: () {
                              alertBox();
                            },
                            tileColor: Colors.white,
                            leading: Icon(Icons.favorite),
                            subtitle: Text(
                              "F_items_Sub".tr,
                              style: TextStyle(fontSize: 13),
                            ),
                            title: Text(
                              "F_items".tr,
                              style: sliderTextStyle,
                            )),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    color: Colors.white,
                    child: Container(
                      color: Colors.white,
                      height: 80,
                      child: Center(
                        child: ListTile(
                            onTap: () {
                              favouritestore(context);
                            },
                            tileColor: Colors.white,
                            leading: Icon(Icons.shopping_cart),
                            subtitle: Text(
                              "F_store_sub".tr,
                              style: TextStyle(fontSize: 13),
                            ),
                            title: Text(
                              "F_store".tr,
                              style: sliderTextStyle,
                            )),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    color: Colors.white,
                    child: Container(
                      color: Colors.white,
                      height: 80,
                      child: Center(
                        child: ListTile(
                            onTap: () {
                              // replease your app link with this
                              favouriteBox(context);
                            },
                            tileColor: Colors.white,
                            leading: Icon(
                              Icons.local_offer,
                              size: 33,
                            ),
                            subtitle: Text(
                              "F_cata_sub".tr,
                              style: TextStyle(fontSize: 13),
                            ),
                            title: Text(
                              "F_cata".tr,
                              style: sliderTextStyle,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            )),
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
                height: 400,
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
                        height: 100,
                        child: ListView.builder(
                          itemCount: controller.myoffers.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Text(
                                  "${controller.myoffers[index]["keyword"]}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
}
