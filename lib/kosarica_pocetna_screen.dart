import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:kosarica/constants/color_text.dart';
import 'package:kosarica/Controller/AppDetails_Controller.dart';
import 'package:kosarica/store_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:star_menu/star_menu.dart';

import 'Catagory_view.dart';
import 'Models/appDetails_model.dart';

class KosaricaPocetnaScreen extends StatefulWidget {
  @override
  State<KosaricaPocetnaScreen> createState() => _KosaricaPocetnaScreenState();
}

class _KosaricaPocetnaScreenState extends State<KosaricaPocetnaScreen> {
  final controller = Get.put(appDetails_controller());


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




  //.........................................for the goodle ads........................
  BannerAd? _bannerAd;

  bool _isLoaded = false;

  final adUnitId = 'ca-app-pub-6735162421884355/2653930911';

  final adUnitInterstitalId = 'ca-app-pub-6735162421884355/2833307589';

  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    )..load();
  }





//........................................................................................

  int currentIndex = 0;
  int count = 1;
  void increment() {
    setState(() {
      count++;
    });
  }

  void Decrement() {
    setState(() {
      count--;
    });
  }

  final upperMenuItems = <Widget>[

    InkWell(
      onTap: () {
        Get.offAll(Kosaricapocetna_kategorije());
      },
      child: const Text(
        'View by category',
        style: TextStyle(fontSize: 20),
      ),
    ),
    InkWell(
      onTap: () {
        Get.offAll(KosaricaPocetna_Trgovine());
      },
      child: const Text(
        'Browse by store',
        style: TextStyle(fontSize: 20),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();

    loadAd();



  }

  @override
  Widget build(BuildContext context) {
    List<Offers>? filteredbysearch=filterOffersBySearch(controller.getAppDetails!.offers, _searchcontroller.text);
    controller.date = DateTime.now();
    return Container(
      color: maincolor,
      child: GetBuilder<appDetails_controller>(
        id: "update_data",
        builder: (_) {
          return SafeArea(
            child:  Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                toolbarHeight: 60,
                flexibleSpace: Card(
                  shadowColor: Colors.grey[100],
                  margin: EdgeInsets.zero,
                  elevation: 1,
                  color: Colors.white,
                  child: TextFormField(
                    controller: _searchcontroller,
                    onChanged: (value) {
                      setState(() {
                        issearching=value.isNotEmpty;
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
                              ),
                            ).addStarMenu(
                              onItemTapped: (index, controller) {},
                              items: upperMenuItems,
                              params: StarMenuParameters.dropdown(context),
                            ),
                          ],
                        ),
                        onTap: () {},
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 20),
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              body: issearching
                  ? Stack(
                    children: [
                      Center(
                          child: Column(
                            children: [
                              filteredbysearch != null ?
                              Expanded(
                                child:  GridView.builder(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  // physics: const NeverScrollableScrollPhysics(),
                                  itemCount: filteredbysearch.length,
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
                                          filteredbysearch[index].storeName.toString(),
                                          filteredbysearch[index].storeImageUrl.toString(),
                                          filteredbysearch[index].articleImageUrl.toString(),
                                          filteredbysearch[index].articleName.toString(),
                                          filteredbysearch[index].offerNewPriceEur.toString(),
                                          filteredbysearch[index].offerNewPriceHrk.toString().substring(0,1),
                                          filteredbysearch[index].offerNewPriceEur.toString().substring(2,4),
                                          filteredbysearch[index].offerNewPriceHrk.toString().substring(2,4),
                                          filteredbysearch[index].offerValueTo.toString(),

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
                                                  filteredbysearch[index].articleImageUrl.toString(),
                                                  errorBuilder: (context, error, stackTrace) {
                                                    // Fallback to asset image if there's an error loading the network image
                                                    return Image.asset(
                                                      "assets/Kosarica Icon_cropped.png",
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                  scale: 0.8,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                filteredbysearch[index].articleName.toString().length > 6
                                                    ? "${filteredbysearch[index].articleName.toString().substring(0, 6)}.."
                                                    : filteredbysearch[index].articleName.toString(),
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
                                              const SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ):const Center(
                                child: Text('No offers available for this store.',style: TextStyle(color: Colors.black),),
                              ),
                            ],
                          ),
                        ),

                    ],
                  )
                  : Stack(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                                        height: 10800,
                          child: Stack(
                            children: [
                              Column(
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10, top: 10),
                                          child: Row(
                                            children: [
                                              Text(
                                                's_offer'.tr,
                                                style: heading1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        CarouselSlider(
                                          options: CarouselOptions(
                                            autoPlay: false,
                                            aspectRatio: 2.0,
                                            viewportFraction: 1,
                                            enlargeCenterPage: true,
                                            onPageChanged: (index, reason) {
                                              setState(() {
                                                currentIndex = index;
                                              });
                                            },
                                          ),
                                          items: controller.getAppDetails?.offers != null
                                              ? List.generate(10, (index) {
                                                  final offer = controller
                                                      .getAppDetails!.offers![index];
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(left: 10),
                                                    child: InkWell(
                                                      onTap: () {
                                                        cartSheet(
                                                            offer.storeName.toString(),
                                                            offer.storeImageUrl.toString(),
                                                            offer.articleImageUrl
                                                                .toString(),
                                                            offer.articleName.toString(),
                                                            offer.offerNewPriceEur
                                                                .toString(),
                                                            offer.offerNewPriceHrk
                                                                .toString()
                                                                .substring(0, 1),
                                                            offer.offerNewPriceEur
                                                                .toString()
                                                                .substring(2, 4),
                                                            offer.offerNewPriceHrk
                                                                .toString()
                                                                .substring(2, 4),
                                                            offer.offerValueTo.toString());
                                                      },
                                                      child: Container(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                          children: [
                                                            Image.network(
                                                              '${offer.storeImageUrl.toString()}',
                                                              fit: BoxFit.fill,
                                                              height: 35,
                                                              width: 35,
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 2,
                                                                  child: Image.network(
                                                                    '${offer.articleImageUrl}',
                                                                    errorBuilder: (context, error, stackTrace) {
                                                                      // Fallback to asset image if there's an error loading the network image
                                                                      return Image.asset(
                                                                        "assets/Kosarica Icon_cropped.png",
                                                                        fit: BoxFit.cover,
                                                                      );
                                                                    },
                                                                    fit: BoxFit.fill,
                                                                    height: 155,
                                                                    width: 140,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        width: 200,
                                                                        child: Text(
                                                                          '${offer.articleName ?? ''}',
                                                                          style:
                                                                              GoogleFonts
                                                                                  .roboto(
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .w600,
                                                                            fontSize: 19,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 7,
                                                                      ),
                                                                      Text(
                                                                        '${offer.articleDesc ?? ''}',
                                                                        style: GoogleFonts
                                                                            .roboto(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w400,
                                                                          fontSize: 13,
                                                                          color: const Color(
                                                                                  0xff1E1E1E)
                                                                              .withOpacity(
                                                                                  0.7),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 20,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets
                                                                                .only(
                                                                                right:
                                                                                    50),
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment
                                                                                  .spaceBetween,
                                                                          children: [
                                                                            Column(
                                                                              crossAxisAlignment:
                                                                                  CrossAxisAlignment
                                                                                      .start,
                                                                              children: [
                                                                                // Text(
                                                                                //   '${offer.offerNewPriceEur ?? ''} €',
                                                                                //   style: GoogleFonts
                                                                                //       .roboto(
                                                                                //     fontWeight:
                                                                                //         FontWeight.w400,
                                                                                //     fontSize:
                                                                                //         12,
                                                                                //     color:
                                                                                //         const Color(0xff1E1E1E).withOpacity(0.7),
                                                                                //   ),
                                                                                // ),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      '${offer.offerNewPriceEur?.substring(0, 1) ?? ''}',
                                                                                      style:
                                                                                          GoogleFonts.roboto(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontSize: 33,
                                                                                      ),
                                                                                    ),
                                                                                    Column(
                                                                                      crossAxisAlignment:
                                                                                          CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text('${offer.offerNewPriceEur?.substring(2, 4) ?? ''}', style: sliderTextStyle),
                                                                                        Text('€', style: sliderTextStyle),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 70,
                                                                            ),
                                                                            Column(
                                                                              crossAxisAlignment:
                                                                                  CrossAxisAlignment
                                                                                      .start,
                                                                              children: [
                                                                                // Text(
                                                                                //   '${offer.offerNewPriceHrk?.substring(0, 1)} Kn' ??
                                                                                //       '',
                                                                                //   style: GoogleFonts
                                                                                //       .roboto(
                                                                                //     fontWeight:
                                                                                //         FontWeight.w400,
                                                                                //     fontSize:
                                                                                //         12,
                                                                                //     color:
                                                                                //         const Color(0xff1E1E1E).withOpacity(0.7),
                                                                                //   ),
                                                                                // ),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      '${offer.offerNewPriceHrk?.substring(0, 1)},' ??
                                                                                          '',
                                                                                      style:
                                                                                          GoogleFonts.roboto(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontSize: 33,
                                                                                      ),
                                                                                    ),
                                                                                    Column(
                                                                                      crossAxisAlignment:
                                                                                          CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text('${offer.offerNewPriceEur?.substring(2, 4) ?? ''}', style: sliderTextStyle),
                                                                                        Text('Kn', style: sliderTextStyle),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                })
                                              : [], // Empty list if offers are null
                                        ),
                                        DotsIndicator(
                                          dotsCount:
                                              10, // Assuming 10 items are always shown
                                          position: currentIndex,
                                          decorator: DotsDecorator(
                                            spacing: EdgeInsets.symmetric(horizontal: 3),
                                            activeSize: Size(14, 14),
                                            size: Size(14, 14),
                                            activeColor: maincolor,
                                            color: Colors.grey[400]!,
                                          ),
                                        ),
                                      ],
                                    ),
                                     SizedBox(
                                      height: 40,
                                    ),



                                    Expanded(
                                      child: ListView.builder(
                                         physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            controller.getAppDetails?.stores?.length ?? 0,
                                        itemBuilder: (context, storeIndex) {
                                          final store =
                                              controller.getAppDetails?.stores?[storeIndex];
                                          if (store == null) {
                                            return SizedBox.shrink();
                                          }
                                          final filteredOffers =
                                              controller.filterOffersByStoreId(
                                            controller.getAppDetails?.offers,
                                            int.parse(store.storeId.toString()),
                                          );
                                          // Skip rendering the store if filteredOffers is empty
                                          if (filteredOffers?.isEmpty ?? true) {
                                            return SizedBox.shrink();
                                          }
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, top: 15),
                                                child: Row(
                                                  children: [
                                                    Image.network(
                                                      '${store.storeImageUrl ?? ""}',
                                                      fit: BoxFit.fill,
                                                      height: 30,
                                                      width: 30,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      '${store.storeName ?? ""}',
                                                      style: heading2,
                                                    ),
                                                    const SizedBox(width: 7),
                                                    SvgPicture.asset(
                                                      'assets/arrow-narrow-right 1.svg',
                                                      width: 20,
                                                      height: 20,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                height: 160,
                                                child: ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  scrollDirection: Axis.horizontal,
                                                  shrinkWrap: true,
                                                  itemCount: filteredOffers?.length ?? 0,
                                                  itemBuilder: (BuildContext context,
                                                      int offerIndex) {
                                                    final offer =
                                                        filteredOffers?[offerIndex];
                                                    if (offer == null) {
                                                      return SizedBox.shrink();
                                                    }
                                                    return InkWell(
                                                      onTap: () {
                                                        // show the offers details in the buttom bar

                                                        cartSheet(
                                                            offer.storeName.toString(),
                                                            offer.storeImageUrl.toString(),
                                                            offer.articleImageUrl
                                                                .toString(),
                                                            offer.articleName.toString(),
                                                            offer.offerNewPriceEur
                                                                .toString(),
                                                            offer.offerNewPriceHrk
                                                                .toString()
                                                                .substring(0, 1),
                                                            offer.offerNewPriceEur
                                                                .toString()
                                                                .substring(2, 4),
                                                            offer.offerNewPriceHrk
                                                                .toString()
                                                                .substring(2, 4),
                                                            offer.offerValueTo.toString());
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(left: 10),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Card(
                                                                  margin: EdgeInsets.zero,
                                                                  elevation: 1,
                                                                  child: Container(
                                                                    height: 160,
                                                                    width: 160,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.white,
                                                                        border: Border.all(
                                                                            color: Colors
                                                                                .teal
                                                                                .withOpacity(
                                                                                    0.1))),
                                                                    child: Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height: 10,
                                                                        ),
                                                                        Expanded(
                                                                          child: Image.network(
                                                                            offer.articleImageUrl.toString() ?? "",
                                                                            errorBuilder: (context, error, stackTrace) {
                                                                              // Fallback to asset image if there's an error loading the network image
                                                                              return Image.asset(
                                                                                "assets/Kosarica Icon_cropped.png",
                                                                                fit: BoxFit.cover,
                                                                              );
                                                                            },
                                                                            fit: BoxFit.cover,
                                                                          ),
                                                                        ),

                                                                        SizedBox(
                                                                          height: 10,
                                                                        ),
                                                                        Expanded(
                                                                          child: Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment
                                                                                    .spaceBetween,
                                                                            children: [
                                                                              Container(
                                                                                width:
                                                                                    100,
                                                                                child:
                                                                                    Padding(
                                                                                      padding:  EdgeInsets.symmetric(horizontal: 7.0),
                                                                                      child: Text(
                                                                                        offer.articleName.toString().length >
                                                                                            20
                                                                                        ? "${offer.articleName.toString().substring(0,20)}"
                                                                                        : offer.articleName.toString(),
                                                                                        style: GoogleFonts
                                                                                        .roboto(
                                                                                      fontWeight:
                                                                                          FontWeight.w900,
                                                                                      fontSize:
                                                                                          13,
                                                                                        ),
                                                                                        softWrap:
                                                                                        true,
                                                                                      ),
                                                                                    ),
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    offer.offerNewPriceEur.toString().substring(0, 1) ??
                                                                                        "",
                                                                                    style:
                                                                                        const TextStyle(
                                                                                      fontSize:
                                                                                          18,
                                                                                      fontWeight:
                                                                                          FontWeight.w700,
                                                                                    ),
                                                                                  ),
                                                                                  Column(
                                                                                    crossAxisAlignment:
                                                                                        CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                                                                        child: Text(
                                                                                          offer.offerNewPriceEur.toString().substring(2, 4) ?? "",
                                                                                          style: const TextStyle(
                                                                                            fontSize: 13,
                                                                                            fontWeight: FontWeight.w700,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      const Text(
                                                                                        '€',
                                                                                        style: TextStyle(
                                                                                          fontSize: 13,
                                                                                          fontWeight: FontWeight.w700,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height: 5,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                            ],
                          ),
                        ),
                      ),
                      if(_isLoaded)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: _bannerAd!.size.height.toDouble(),
                            width: _bannerAd!.size.width.toDouble(),
                            child: AdWidget(ad: _bannerAd!),

                          ),
                        ),
                    ],
                  ),
            ),
          );
        },
      ),
    );
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
      String valuedto
      ) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Container(
          height: 525,
          color: Colors.white,
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
                      'Ponuda vrijedi do:  ${valuedto}',
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
                  height: 30,
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
                     //controller.cartbox.clear();

                    var data = {
                      "store_img": storeimage,
                      "offername": offerdes,
                      "offervalid": valuedto,
                      "price_eu": offerPE,
                      "price_eupoints": storename,
                      "offer_img": offerimage,
                      "storename": storename,
                      "total_quty": count.toString()
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

//.................................................. add the item in the cart .....................................................

@HiveType(typeId: 0)
class CartItem extends HiveObject {
  @HiveField(0)
  late String storeName;

  @HiveField(1)
  late String storeImage;

  @HiveField(2)
  late String offerImage;

  @HiveField(3)
  late String offerDescription;

  @HiveField(4)
  late String offerPE;

  @HiveField(5)
  late String offerPK;

  @HiveField(6)
  late String offerPEPoints;

  @HiveField(7)
  late String offerPKPoints;

  @HiveField(8)
  late String validTo;

  @HiveField(9)
  late int quantity;

  CartItem({
    required this.storeName,
    required this.storeImage,
    required this.offerImage,
    required this.offerDescription,
    required this.offerPE,
    required this.offerPK,
    required this.offerPEPoints,
    required this.offerPKPoints,
    required this.validTo,
    required this.quantity,
  });
}
