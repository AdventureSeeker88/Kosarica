import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kosarica/Controller/AppDetails_Controller.dart';
import 'package:kosarica/constants/color_text.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Cart_screen.dart';
import 'Models/appDetails_model.dart';
import 'kosarica_pocetna_screen.dart';

class SundayScreen extends StatefulWidget {
  const SundayScreen({super.key});

  @override
  State<SundayScreen> createState() => _SundayScreenState();
}

class _SundayScreenState extends State<SundayScreen> {
  appDetails_controller controller = Get.find<appDetails_controller>();

  bool isChecked = false;
  TextEditingController searchController = TextEditingController();
  DateTime currentDate2 = DateTime.now();
  bool ismap=false;
  bool islist=true;

  //................................ for the ads ..............................
  bool _isLoaded = false;
  BannerAd? _bannerAd;
  final adUnitId = 'ca-app-pub-6735162421884355/2653930911';
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



  List<Sundays> getFilteredSundays() {
    DateTime currentDate = DateTime.now();
   // String currentDateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";

    List<Sundays> allSundays = controller.getAppDetails?.sundays ?? [];


    // Filter based on the checkbox status
    List<Sundays> filteredSundays = isChecked
        ? allSundays.where((sunday) => sunday.workingStatus == 1).toList()
        : allSundays;

    // Further filter based on the search query
    String searchQuery = searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      filteredSundays = filteredSundays.where((sunday) {
        return sunday.locationName!.toLowerCase().contains(searchQuery) ||
            sunday.city!.toLowerCase().contains(searchQuery);
      }).toList();
    }

    return filteredSundays;
  }

  //....................................for the show the map on the sunday screen ............................................

  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Add markers for gas stations
    _addMarkers();
    fetchScoreAndUpdateScreen();
    loadAd();
  }

  Future<void> fetchScoreAndUpdateScreen() async {
    // Simulating fetching the score data (replace this with your actual code)
    await Future.delayed(Duration(seconds: 3));
    setState(() {});
  }

  void _addMarkers() async {
    int index = 0;
    for (var sundayScreen in controller.getAppDetails!.sundays!) {
      // BitmapDescriptor markerIcon = await _buildMarkerIcon("  https://webservis.mzoe-gor.hr/img/${gasStation.obveznik!.logo.toString()},");
      // BitmapDescriptor markerIcon = await _buildMarkerIcon(" https://upload.wikimedia.org/wikipedia/commons/a/ac/NewTux.png ");

      Uint8List? image = await loadneworkimage(
          "${sundayScreen.storeImageUrl!.toString()}");
      print("images : $image");
      final ui.Codec markerimageCodec = await ui.instantiateImageCodec(
        image!.buffer.asUint8List(),
        targetHeight: 100,
        targetWidth: 100,
      );
      final ui.FrameInfo frameInfo = await markerimageCodec.getNextFrame();
      final ByteData? byteData =
      await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List resizedimagemarker = byteData!.buffer.asUint8List();

      _markers.add(
        Marker(
            markerId: MarkerId(sundayScreen.storeId.toString()),
            position: LatLng(double.parse(sundayScreen.latitude.toString()),
                double.parse(sundayScreen.longitude.toString())),
            onTap: () {
              // _showGasStationDetails(
              //     sundayScreen.naziv.toString(),
              //     gasStation.adresa.toString(),
              //     gasStation.mjesto.toString(),
              //     "${gasStation.cijene![0].gorivo!.naziv.toString()}       ${gasStation.cijene![0].cijena.toString()}",
              //     "${gasStation.cijene![1].gorivo!.naziv.toString()}       ${gasStation.cijene![1].cijena.toString()}",
              //     "${gasStation.cijene![3].gorivo!.naziv.toString()}       ${gasStation.cijene![3].cijena.toString()}",
              //     "${gasStation.cijene![4].gorivo!.naziv.toString()}       ${gasStation.cijene![4].cijena.toString()}",
              //     "https://webservis.mzoe-gor.hr/img/${gasStation.obveznik!.logo.toString()}",
              //     gasStation.lat.toString(),
              //     gasStation.lng.toString(),
              //     "${gasStation.radnoVrijeme![0].dan.toString()}:${gasStation.radnoVrijeme![0].pocetak.toString().substring(0,5)} - ${gasStation.radnoVrijeme![0].kraj.toString().substring(0,5)}",
              //     "${gasStation.radnoVrijeme![1].dan.toString()}:${gasStation.radnoVrijeme![1].pocetak.toString().substring(0,5)} - ${gasStation.radnoVrijeme![1].kraj.toString().substring(0,5)}",
              //     "${gasStation.radnoVrijeme![2].dan.toString()}:${gasStation.radnoVrijeme![2].pocetak.toString().substring(0,5)} - ${gasStation.radnoVrijeme![2].kraj.toString().substring(0,5)}",
              //     "${gasStation.radnoVrijeme![3].dan.toString()}:${gasStation.radnoVrijeme![3].pocetak.toString().substring(0,5)} - ${gasStation.radnoVrijeme![3].kraj.toString().substring(0,5)}"
              //
              //
              // );
            },
            icon: BitmapDescriptor.fromBytes(resizedimagemarker),
            infoWindow:
            InfoWindow(snippet: "gas station name :${sundayScreen.storeName}")),
      );
      setState(() {});
    }
  }

  // ............................ for loading the logos from the network.............................

  Future<Uint8List> loadneworkimage(String path) async {
    final completer = Completer<ImageInfo>();
    final image = await NetworkImage(path);
    image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener((info, _) => completer.complete(info)));
    final imageinfo = await completer.future;
    final bytedata =
    await imageinfo.image.toByteData(format: ui.ImageByteFormat.png);
    return bytedata!.buffer.asUint8List();
  }

  //............................................. Buttom sheet for show detils of the gas stations............................

  void _showGasStationDetails(
      String gasname,
      String location,
      String location2,
      String detils1,
      String detail2,
      String detail3,
      String detail4,
      String url,
      String lat,
      String lng,
      String Dan1,
      String Dan2,
      String Dan3,
      String Dan4
      ) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    "${url.toString()}",
                    height: 50,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Text(
                        "${gasname.toString()}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${location.toString()}, ${location2.toString()}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
              Text("${detils1}"),
              Text("${detail2}"),
              Text("${detail3}"),
              Text("${detail4}"),
              Text("radno Vrijeme",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
              Text(Dan1),
              Text(Dan2),
              Text(Dan3),
              Text(Dan4),
              // Row(
              //   children: [
              //     Text(Dan[0]["dan"]),
              //     Text(Dan[0]["pocetak"]),
              //     Text(Dan[0]["kraj"]),
              //
              //   ],
              // ),
              Expanded(child: SizedBox()),
              InkWell(
                onTap: () async {
                  final url =
                      "https://www.google.com/maps/search/?api=1&query=${lat.toString()},${lng.toString()}";
                  await launchUrl(Uri.parse(url));

//
                },
                child: Container(
                  height: 50,
                  color: Colors.red,
                  child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "show direction",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          )
                        ],
                      )),
                ),
              )
            ],
          ),
        );
      },
    );
  }
















  @override
  Widget build(BuildContext context) {
    List<Sundays> filteredSundays = getFilteredSundays();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 60,
          actions: [
         islist?   TextButton(
                onPressed: () {
              setState(() {
                ismap=true;
                islist=false;
              });
            }, child: Text("show map")):TextButton(
             onPressed: () {
               setState(() {
                 ismap=false;
                 islist=true;
               });
             }, child: Text("show list"))
          ],
          flexibleSpace: Card(
            shadowColor: Colors.grey[100],
            margin: EdgeInsets.zero,
            elevation: 3,
            color: Colors.white,
            child: TextFormField(
              controller: searchController,
              onChanged: (value) {
                setState(() {});
              },
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              cursorColor: maincolor,
              decoration: InputDecoration(
                hintText: 'searchitemsS'.tr,
                hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 30,
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
        body: Stack(
          children: [

            Visibility(
              visible: ismap,
              child: GoogleMap(
                onMapCreated: (GoogleMapController mpcontroller) {
                  mapController = mpcontroller;
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      double.parse(controller
                          .getAppDetails!.sundays![0].latitude
                          .toString()),
                      double.parse(controller
                          .getAppDetails!.sundays![0].longitude
                          .toString())),
                  zoom: 11.0,
                ),
                markers: _markers,
              ),
            ),


//........................................................ show a list of sunday screen ...........................................

            Visibility(
              visible: islist,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 5),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/calendar 1.svg'),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'sundayT'.tr,
                                  style: heading2,
                                ),
                                Text(
                                  " ,${currentDate2.toString().substring(0,10)}",
                                  style: heading2,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'sundayD'.tr,
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Transform.scale(
                                    scale: 1,
                                    child: Checkbox(
                                      activeColor: Colors.black,
                                      checkColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(3)),
                                      side: BorderSide(color: Colors.black, width: 1.5),
                                      value: isChecked,
                                      onChanged: (value) {
                                        setState(() {
                                          isChecked = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'sundayC'.tr,
                                  style: productTitleStyle,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: filteredSundays.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
                          child: Card(
                            margin: EdgeInsets.zero,
                            elevation: 5,
                            color: Colors.white,
                            child: Container(
                              color: Colors.white,
                              height: 80,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10, top: 10),
                                        child: Row(
                                          children: [
                                            Image.network(
                                              filteredSundays[index].storeImageUrl
                                                  .toString(),
                                              fit: BoxFit.fill,
                                              height: 25,
                                              width: 25,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              filteredSundays[index]
                                                  .locationName
                                                  .toString()
                                                  .length >
                                                  22
                                                  ? "${filteredSundays[index].locationName.toString().substring(0, 22)}.."
                                                  : filteredSundays[index]
                                                  .locationName
                                                  .toString(),
                                              style: heading2,
                                            ),
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                final url =
                                                    'https://www.google.com/maps/search/?api=1&query=${filteredSundays[index].latitude.toString()},${filteredSundays[index].longitude.toString()}';
                                                await launchUrl(Uri.parse(url));
                                              },
                                              child: SvgPicture.asset(
                                                'assets/arrow-narrow-right 1.svg',
                                                width: 20,
                                                height: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        color: maincolor,
                                        height: 23,
                                        width: 83,
                                        child: Center(
                                          child: Text(
                                            filteredSundays[index].workingStatus == 1
                                                ? 'OTVORENO'
                                                : 'ZATVORENO',
                                            style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 10,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${filteredSundays[index].address.toString()}, ${filteredSundays[index].city.toString()}',
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          filteredSundays[index].workingStatus == 1
                                              ? 'otvoreno'
                                              : 'zatvoreno',
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
  }
}
