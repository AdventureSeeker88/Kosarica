import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kosarica/ButtomBar.dart';
import 'package:kosarica/Controller/AppDetails_Controller.dart';
import 'package:kosarica/constants/kosarica_pocetna_data.dart';
import 'package:kosarica/store_view.dart';
import 'package:kosarica/store_view_details.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:star_menu/star_menu.dart';

import 'Catagory_view.dart';
import 'Models/appDetails_model.dart';
import 'constants/color_text.dart';
import 'kosarica_pocetna_screen.dart';


class KosaricaPocetna_Trgovine_details extends StatefulWidget {
  final int store_id;
  const KosaricaPocetna_Trgovine_details({super.key, required this.store_id});

  @override
  State<KosaricaPocetna_Trgovine_details> createState() => _KosaricaPocetna_Trgovine_detailsState();
}

class _KosaricaPocetna_Trgovine_detailsState extends State<KosaricaPocetna_Trgovine_details> {


  //............................... for the search in offers.........................................


  TextEditingController _searchcontroller=TextEditingController();
  bool issearching=false;
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




  //................................................................................



  appDetails_controller controller= Get.find<appDetails_controller>();
  int count=1;
  void increment (){
    setState(() {
      count++;
    });
  }
  void Decrement (){
    setState(() {
      count--;
    });
  }
  final upperMenuItems = <Widget>[
    InkWell(
      onTap: () {
        Get.offAll( AnimatedBar());
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
    List<Offers>? filteredOffers = controller.filterOffersByStoreId(controller.getAppDetails?.offers, widget.store_id);
    filteredOffers = filterOffersBySearch(filteredOffers, _searchcontroller.text);


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
              controller: _searchcontroller,
              onChanged: (value) {
                setState(() {

                });
              },
              style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                    onTap: () {}),
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
              filteredOffers != null ?
              Expanded(
                child:  GridView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredOffers!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 170,
                      mainAxisSpacing: 7,
                      crossAxisSpacing: 30),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        print("card is being touch");
                        cartSheet(
                          filteredOffers![index].storeName.toString(),
                          filteredOffers[index].storeImageUrl.toString(),
                          filteredOffers[index].articleImageUrl.toString(),
                          filteredOffers[index].articleName.toString(),
                          filteredOffers[index].offerNewPriceEur.toString(),
                          filteredOffers[index].offerNewPriceHrk.toString().substring(0,1),
                          filteredOffers[index].offerNewPriceEur.toString().substring(2,4),
                          filteredOffers[index].offerNewPriceHrk.toString().substring(2,4),
                          filteredOffers[index].offerValueTo.toString(),

                        );
                      },
                      child: Card(
                        elevation: 2,
                        color: Colors.white,
                        child: Container(
                          // padding: EdgeInsets.symmetric(horizontal: 20),
                          width: 160,
                          height: 125,
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Image.network(
                                  filteredOffers![index].articleImageUrl.toString(),
                                  scale: 0.8,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                filteredOffers![index].articleName.toString().length > 6
                                    ? "${filteredOffers[index].articleName.toString().substring(0, 6)}.."
                                    : filteredOffers[index].articleName.toString(),
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${controller.getAppDetails?.offers?[index].offerNewPriceEur.toString().substring(0,1)}',
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                    ),

                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${controller.getAppDetails?.offers?[index].offerNewPriceEur.toString().substring(2,4)}', style: sliderTextStyle),
                                      Text('€', style: sliderTextStyle),
                                    ],
                                  ),
                                ],
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
              ):Center(
                child: Text('No offers available for this store.',style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
        ),
      ),
    );
  }
  cartSheet(String storename,String storeimage,String offerimage,String offerdes, String offerPE,String offerPK ,String offerPEpoints,String offerPKPoints ,String valuedto ) {
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
                              offerPE.substring(0,1),
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
                              onTap: () {
                                setState(() {
                                  Decrement();
                                });

                              },
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
                                '${count.toString()}',
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
                              onTap: () {
                                setState(() {
                                  increment();
                                });

                              },
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
                        // controller.cartbox.clear();



                        var data={
                          "store_img":storeimage,
                          "offername":offerdes,
                          "offervalid":valuedto,
                          "price_eu":offerPE,
                          "price_eupoints":storename,
                          "offer_img":offerimage,
                          "storename":storename,
                          "total_quty":count.toString()
                        };
                        controller. createData(data);
                        await SnackBar(content: Text("items is add in the cart succesfully"),backgroundColor: Colors.black,);

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







