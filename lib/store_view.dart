import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kosarica/ButtomBar.dart';
import 'package:kosarica/Catagory_view.dart';
import 'package:kosarica/Controller/AppDetails_Controller.dart';
import 'package:kosarica/store_view_details.dart';
import 'package:star_menu/star_menu.dart';

class KosaricaPocetna_Trgovine extends StatelessWidget {
  KosaricaPocetna_Trgovine({super.key});

  final appDetails_controller controller = Get.find<appDetails_controller>();
  final List<Widget> upperMenuItems = [
    InkWell(
      onTap: () {
        Get.offAll(AnimatedBar());
      },
      child: const Text(
        '    Special Offers',
        style: TextStyle(fontSize: 23),
      ),
    ),
    InkWell(
      onTap: () {
        Get.offAll(Kosaricapocetna_kategorije());
      },
      child: const Text(
        'View by category',
        style: TextStyle(fontSize: 23),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Map to store store item counts
    Map<String, int> storeItemCount = {};

    // Count items for each store
    controller.getAppDetails?.offers?.forEach((offer) {
      String storeId = offer.storeId.toString();
      if (storeItemCount.containsKey(storeId)) {
        storeItemCount[storeId] = storeItemCount[storeId]! + 1;
      } else {
        storeItemCount[storeId] = 1;
      }
    });

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          flexibleSpace: Card(
            shadowColor: Colors.grey[100],
            margin: EdgeInsets.zero,
            elevation: 1,
            color: Colors.white,
            child: TextFormField(
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
             // cursorColor: maincolor,
              decoration: InputDecoration(
                hintText: 'Pretraži artikle',
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 30,
                ),
                suffixIcon: InkWell(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: SvgPicture.asset(
                          "assets/template 1.svg",
                          fit: BoxFit.fill,
                          height: 30,
                          width: 30,
                        ).addStarMenu(
                          onItemTapped: (index, controller) {},
                          items: upperMenuItems,
                          params: StarMenuParameters.dropdown(context),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {},
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: controller.getAppDetails?.stores?.length ?? 0,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 170,
                    mainAxisSpacing: 7,
                    crossAxisSpacing: 30,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    String storeId = controller.getAppDetails!.stores![index].storeId.toString();
                    int itemCount = storeItemCount[storeId] ?? 0;

                    return InkWell(
                      onTap: () {
                        // Navigate to store details screen or do something else
                        Get.to(KosaricaPocetna_Trgovine_details(
                          store_id: controller.getAppDetails!.stores![index].storeId!.toInt(),
                        ));
                      },
                      child: Card(
                        elevation: 2,
                        color: Colors.white,
                        child: Container(
                          width: 160,
                          height: 125,
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(height: 10),
                              Expanded(
                                child: Image.network(
                                  controller.getAppDetails!.stores![index]
                                      .storeImageUrl
                                      .toString(),
                                  scale: 0.8,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                controller
                                    .getAppDetails!.stores![index].storeName
                                    .toString(),
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "$itemCount Items",
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
