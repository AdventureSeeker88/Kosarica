import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kosarica/Alert_boxes/Enable%20_gen_notifications.dart';
import 'package:kosarica/ButtomBar.dart';
import 'package:kosarica/Controller/AppDetails_Controller.dart';
import 'package:kosarica/Gas_Station.dart';
import 'package:kosarica/Instructions.dart';
import 'package:kosarica/Languages/Language%20change%20dialoge.dart';
import 'package:kosarica/Splash_screen.dart';
import 'package:kosarica/View_options.dart';

import 'package:kosarica/constants/color_text.dart';
import 'package:kosarica/subscription_screens/Subscription_controller.dart';
import 'package:kosarica/subscription_screens/Subscrption_page.dart';
import 'package:kosarica/subscription_screens/subscription.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:restart_app/restart_app.dart';
import 'package:share_plus/share_plus.dart';

import 'koverter_screen.dart';

class MoreScreen extends StatefulWidget {
  MoreScreen({
    super.key,
  });

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  appDetails_controller controller = Get.find<appDetails_controller>();
  @override
  DateTime formattedDate = DateTime.now();
  // String formattedDate =
  // DateFormat('EEE d MMM  hh:mm:ss').format(DateTime.now());

  Widget build(BuildContext context) {
    return Container(
      color: maincolor,
      child: SafeArea(
        child: Scaffold(
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CurrencyConverter()));
                        },
                        tileColor: Colors.white,
                        leading: SvgPicture.asset(
                          'assets/currency-euro 1.svg',
                          fit: BoxFit.fill,
                          height: 30,
                          width: 30,
                        ),
                        subtitle: Text(
                          "Converter_sub".tr,
                          style: TextStyle(fontSize: 13),
                        ),
                        title: Text(
                          "Converter".tr,
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
                              return language_change();
                            },
                          );
                        },
                        tileColor: Colors.white,
                        leading: Icon(
                          Icons.language,
                          size: 31,
                        ),
                        subtitle: Text(
                          "Application_lan_sub".tr,
                          style: TextStyle(fontSize: 13),
                        ),
                        title: Text(
                          "Application_lan".tr,
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
                          Restart.restartApp();
                        },
                        tileColor: Colors.white,
                        leading: SvgPicture.asset(
                          'assets/refresh 1.svg',
                          fit: BoxFit.fill,
                          height: 30,
                          width: 30,
                        ),
                        subtitle: Text('${controller.date}'),
                        title: Text(
                          "load_data".tr,
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Gasstation()));
                        },
                        tileColor: Colors.white,
                        leading: Icon(Icons.local_gas_station),
                        subtitle: Text("gas_station".tr),
                        title: Text(
                          "gas_station".tr,
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => viewoption()));
                        },
                        tileColor: Colors.white,
                        leading: SvgPicture.asset(
                          'assets/Vector (1).svg',
                          fit: BoxFit.fill,
                          height: 30,
                          width: 30,
                        ),
                        subtitle: Text(
                          "view_options_sub".tr,
                          style: TextStyle(fontSize: 13),
                        ),
                        title: Text(
                          "view_options".tr,
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
                          //fetchingdata();
                        },
                        tileColor: Colors.white,
                        leading: SvgPicture.asset(
                          'assets/tag 1.svg',
                          fit: BoxFit.fill,
                          height: 30,
                          width: 30,
                        ),
                        subtitle: Text(
                          "Subscription",
                          style: TextStyle(fontSize: 13),
                        ),
                        title: Text(
                          "Subscription",
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
                          Get.to(()=>InstructionScreen());
                        },
                        tileColor: Colors.white,
                        leading: SvgPicture.asset(
                          'assets/academic-cap 1.svg',
                          fit: BoxFit.fill,
                          height: 30,
                          width: 30,
                        ),
                        subtitle: Text(
                          "instruction_sub".tr,
                          style: TextStyle(fontSize: 13),
                        ),
                        title: Text(
                          "instruction".tr,
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
                            Share.share("Check out this awesome app");
                        },
                        tileColor: Colors.white,
                        leading: Icon(
                          Icons.share_outlined,
                          size: 33,
                        ),
                        subtitle: Text(
                          "share_app_sub".tr,
                          style: TextStyle(fontSize: 13),
                        ),
                        title: Text(
                          "share_app".tr,
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CurrencyConverter()));
                        },
                        tileColor: Colors.white,
                        leading: SvgPicture.asset(
                          'assets/hand 2.svg',
                          fit: BoxFit.fill,
                          height: 30,
                          width: 30,
                        ),
                        subtitle: Text(
                          "send_your_opinion_sub".tr,
                          style: TextStyle(fontSize: 13),
                        ),
                        title: Text(
                          "send_your_opinion".tr,
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
                              return notifications();
                            },
                          );
                        },
                        tileColor: Colors.white,
                        leading: SvgPicture.asset(
                          'assets/tag 1.svg',
                          fit: BoxFit.fill,
                          height: 30,
                          width: 30,
                        ),
                        subtitle: Text(
                          "GEN_ntification_sub".tr,
                          style: TextStyle(fontSize: 13),
                        ),
                        title: Text(
                          "GEN_ntification".tr,
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
                              return notifications();
                            },
                          );
                        },
                        tileColor: Colors.white,
                        leading: SvgPicture.asset(
                          'assets/tag 1.svg',
                          fit: BoxFit.fill,
                          height: 30,
                          width: 30,
                        ),
                        subtitle: Text(
                          "OFF_notification_sub".tr,
                          style: TextStyle(fontSize: 13),
                        ),
                        title: Text(
                          "OFF_notification".tr,
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CurrencyConverter()));
                        },
                        tileColor: Colors.white,
                        leading: Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 30,
                        ),
                        subtitle: Text(
                          "F_S_network_sub".tr,
                          style: TextStyle(fontSize: 13),
                        ),
                        title: Text(
                          "F_S_network".tr,
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
  //.......................................... for the getting plans....................................

  // Future fetchingdata()async{
  //
  //   final offerings= await subscription.fetchingoffers();
  //
  //   if(offerings.isEmpty){
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("NO plan is found")));
  //
  //
  //   }else{
  //     final packages=offerings.map((offers) => offers.availablePackages).expand((pair) => pair ).toList();
  //    showBottomSheet(context: context, builder: (context) => parallypage(
  //        Title: "upgrade your plan",
  //        description: "block the adds and get premium ",
  //        package: packages,
  //        onclickPackage: (package) async{
  //          await subscription.purchasePackage(package);
  //
  //
  //
  //        },
  //    ),
  //    );
  //
  //
  //   }
  //
  // }


}
