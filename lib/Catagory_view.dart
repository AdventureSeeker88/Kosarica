import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kosarica/ButtomBar.dart';
import 'package:kosarica/Controller/AppDetails_Controller.dart';
import 'package:kosarica/catagoris_wise_view.dart';
import 'package:kosarica/store_view.dart';
import 'package:star_menu/star_menu.dart';

class Kosaricapocetna_kategorije extends StatelessWidget {
  Kosaricapocetna_kategorije({super.key});

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
        Get.offAll(KosaricaPocetna_Trgovine());
      },
      child: const Text(
        'Browse by store',
        style: TextStyle(fontSize: 23),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Map to store category item counts
    Map<String, int> categoryItemCount = {};

    // Count items for each category
    controller.getAppDetails?.offers?.forEach((offer) {
      String categoryId = offer.categoryId.toString();
      if (categoryItemCount.containsKey(categoryId)) {
        categoryItemCount[categoryId] = categoryItemCount[categoryId]! + 1;
      } else {
        categoryItemCount[categoryId] = 1;
      }
    });

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          flexibleSpace: Card(
            shadowColor: Colors.grey[100],
            margin: EdgeInsets.zero,
            elevation: 3,
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
                  itemCount: controller.getAppDetails?.categories?.length ?? 0,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 170,
                    mainAxisSpacing: 7,
                    crossAxisSpacing: 30,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    String categoryId =
                        controller.getAppDetails!.categories![index].categoryId.toString();
                    int itemCount = categoryItemCount[categoryId] ?? 0;

                    return InkWell(
                      onTap: () {
                        Get.to(Kosaricapocetna_kategorije_Details(
                          catagories_name:
                          '${controller.getAppDetails!.categories![index].categoryName.toString()}',
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
                              Expanded(
                                child: Image.network(
                                  controller.getAppDetails!.categories![index]
                                      .categoryImageUrl
                                      .toString(),
                                  scale: 0.8,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                controller.getAppDetails!.categories![index]
                                    .categoryName
                                    .toString(),
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                "$itemCount Items",
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
