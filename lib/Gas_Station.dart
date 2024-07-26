import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kosarica/Controller/AppDetails_Controller.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

import 'constants/color_text.dart';

class Gasstation extends StatefulWidget {
  const Gasstation({Key? key}) : super(key: key);

  @override
  State<Gasstation> createState() => _GasstationState();
}

class _GasstationState extends State<Gasstation> {
  appDetails_controller controller = Get.find<appDetails_controller>();
bool  isChecked =false;
bool ismap=false;
bool islist=true;

  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Add markers for gas stations
    _addMarkers();
    fetchScoreAndUpdateScreen();
  }

  Future<void> fetchScoreAndUpdateScreen() async {
    // Simulating fetching the score data (replace this with your actual code)
    await Future.delayed(Duration(seconds: 3));
    setState(() {});
  }

  void _addMarkers() async {
    int index = 0;
    for (var gasStation in controller.getAppDetails!.gasStations!) {
      // BitmapDescriptor markerIcon = await _buildMarkerIcon("  https://webservis.mzoe-gor.hr/img/${gasStation.obveznik!.logo.toString()},");
      // BitmapDescriptor markerIcon = await _buildMarkerIcon(" https://upload.wikimedia.org/wikipedia/commons/a/ac/NewTux.png ");

      Uint8List? image = await loadneworkimage(
          "https://webservis.mzoe-gor.hr/img/${gasStation.obveznik!.logo.toString()}");
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
            markerId: MarkerId(gasStation.postajaId.toString()),
            position: LatLng(double.parse(gasStation.lat.toString()),
                double.parse(gasStation.lng.toString())),
            onTap: () {
              _showGasStationDetails(
                  gasStation.naziv.toString(),
                  gasStation.adresa.toString(),
                  gasStation.mjesto.toString(),
                  "${gasStation.cijene![0].gorivo!.naziv.toString()}       ${gasStation.cijene![0].cijena.toString()}",
                  "${gasStation.cijene![1].gorivo!.naziv.toString()}       ${gasStation.cijene![1].cijena.toString()}",
                  "${gasStation.cijene![3].gorivo!.naziv.toString()}       ${gasStation.cijene![3].cijena.toString()}",
                  "${gasStation.cijene![4].gorivo!.naziv.toString()}       ${gasStation.cijene![4].cijena.toString()}",
                  "https://webservis.mzoe-gor.hr/img/${gasStation.obveznik!.logo.toString()}",
                  gasStation.lat.toString(),
                  gasStation.lng.toString(),
                "${gasStation.radnoVrijeme![0].dan.toString()}:${gasStation.radnoVrijeme![0].pocetak.toString().substring(0,5)} - ${gasStation.radnoVrijeme![0].kraj.toString().substring(0,5)}",
                    "${gasStation.radnoVrijeme![1].dan.toString()}:${gasStation.radnoVrijeme![1].pocetak.toString().substring(0,5)} - ${gasStation.radnoVrijeme![1].kraj.toString().substring(0,5)}",
                    "${gasStation.radnoVrijeme![2].dan.toString()}:${gasStation.radnoVrijeme![2].pocetak.toString().substring(0,5)} - ${gasStation.radnoVrijeme![2].kraj.toString().substring(0,5)}",
                    "${gasStation.radnoVrijeme![3].dan.toString()}:${gasStation.radnoVrijeme![3].pocetak.toString().substring(0,5)} - ${gasStation.radnoVrijeme![3].kraj.toString().substring(0,5)}"

                
              );
            },
            icon: BitmapDescriptor.fromBytes(resizedimagemarker),
            infoWindow:
                InfoWindow(snippet: "gas station name :${gasStation.adresa}")),
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 60,
          actions: [
        islist?    TextButton(onPressed: () {
              setState(() {
                ismap=true;
                islist=false;
              });
              
            }, child: Text("show map")): TextButton(onPressed: () {
          setState(() {
            ismap=false;
            islist=true;
          });

        }, child: Text("show List"))
          ],
          flexibleSpace: Card(
            shadowColor: Colors.grey[100],
            margin: EdgeInsets.zero,
            elevation: 1,
            color: Colors.white,
            child: TextFormField(
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'Naziv grada ili trgovine',
                hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
                suffixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 30,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        body: GetBuilder<appDetails_controller>(
            id: 'column_gas',
            builder: (_) {
              return Stack(
                children: [
                  Visibility(
                    visible: ismap,
                    child: Expanded(
                      child: GoogleMap(
                        onMapCreated: (GoogleMapController mpcontroller) {
                          mapController = mpcontroller;
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              double.parse(controller
                                  .getAppDetails!.gasStations![0].lat
                                  .toString()),
                              double.parse(controller
                                  .getAppDetails!.gasStations![0].lng
                                  .toString())),
                          zoom: 11.0,
                        ),
                        markers: _markers,
                      ),
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 20),

                  //................................................ list screen of the gas station.............................

                  Visibility(
                    visible: islist,
                    child: Column(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 20, top: 5),
                        //   child: Row(
                        //     children: [
                        //       SvgPicture.asset('assets/calendar 1.svg'),
                        //       SizedBox(
                        //         width: 15,
                        //       ),
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Text(
                        //             'NEDJELJA, 21.4.2024',
                        //             style: heading2,
                        //           ),
                        //           SizedBox(
                        //             height: 3,
                        //           ),
                        //           Text(
                        //             'Pregledajte koje trgovine us otvorene ovu nedjelju',
                        //             style: TextStyle(
                        //               fontWeight: FontWeight.w400,
                        //               fontSize: 12,
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             height: 5,
                        //           ),
                        //           Row(
                        //             children: [
                        //               SizedBox(
                        //                 height: 20,
                        //                 width: 20,
                        //                 child: Transform.scale(
                        //                   scale: 1,
                        //                   child: Checkbox(
                        //                     activeColor: Colors.black,
                        //                     checkColor: Colors.white,
                        //                     shape: RoundedRectangleBorder(
                        //                         borderRadius:
                        //                         BorderRadius.circular(3)),
                        //                     side: BorderSide(
                        //                         color: Colors.black, width: 1.5),
                        //                     value: isChecked,
                        //                     onChanged: (value) {
                        //                       setState(() {
                        //                         isChecked = value!;
                        //                       });
                        //                     },
                        //                   ),
                        //                 ),
                        //               ),
                        //               SizedBox(
                        //                 width: 10,
                        //               ),
                        //               Text(
                        //                 'Prikazi samo otvorene',
                        //                 style: TextStyle(fontSize: 14),
                        //               ),
                        //             ],
                        //           ),
                        //           SizedBox(
                        //             height: 5,
                        //           ),
                        //         ],
                        //       )
                        //     ],
                        //   ),
                        // ),
                        Divider(),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: controller.getAppDetails?.gasStations?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 8),
                                child: ExpansionTile(
                                  title: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 10),
                                        child: Row(
                                          children: [
                                            Image.network(
                                              "https://webservis.mzoe-gor.hr/img/${controller.getAppDetails!.gasStations![index].obveznik!.logo.toString()}",
                                              fit: BoxFit.fill,
                                              height: 23,
                                              width: 23,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              controller.getAppDetails!.gasStations![index]
                                                  .naziv
                                                  .toString()
                                                  .length >
                                                  18
                                                  ? "${controller.getAppDetails!.gasStations![index].naziv.toString().substring(0, 18)}.."
                                                  : controller.getAppDetails!
                                                  .gasStations![index]
                                                  .naziv
                                                  .toString(),
                                              style: heading2,
                                            ),
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                final url =
                                                    'https://www.google.com/maps/search/?api=1&query=${controller.getAppDetails!.gasStations![index].lat.toString()},${controller.getAppDetails!.gasStations![index].lng.toString()}';
                                                await launch(url);
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
                                            'ZATVORENO',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 10,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${controller.getAppDetails!.gasStations![index].adresa.toString()}, ${controller.getAppDetails!.gasStations![index].mjesto.toString()}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),

                                          Container(
                                            height:100,
                                            child: ListView.builder(
                                              itemCount:controller.getAppDetails!.gasStations![index].cijene!.length ,
                                              itemBuilder: (context, index) {
                                                return Text("${controller.getAppDetails!.gasStations![index].cijene![index].gorivo!.naziv.toString()} ${controller.getAppDetails!.gasStations![index].cijene![index].cijena.toString()} €", style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 14,
                                                ),);

                                              },
                                            ),
                                          )






                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),




                ],
              );
            }),
      ),
    );
  }
}


















//
// // ........................................ this is the old code...............................................
//
//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:kosarica/Controller/AppDetails_Controller.dart';
// import 'package:kosarica/constants/color_text.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class Gasstation extends StatefulWidget {
//   const Gasstation({super.key});
//
//   @override
//   State<Gasstation> createState() => _GasstationState();
// }
//
// class _GasstationState extends State<Gasstation> {
//   appDetails_controller controller = Get.find<appDetails_controller>();
//
//   bool isChecked = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           toolbarHeight: 60,
//           flexibleSpace: Card(
//             shadowColor: Colors.grey[100],
//             margin: EdgeInsets.zero,
//             elevation: 3,
//             color: Colors.white,
//             child: TextFormField(
//               style: const TextStyle(
//                   fontSize: 18, fontWeight: FontWeight.w500),
//               cursorColor: maincolor,
//               decoration: InputDecoration(
//                 hintText: 'Naziv grada ili trgovine',
//                 hintStyle: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.w500),
//                 prefixIcon: const Icon(
//                   Icons.search,
//                   color: Colors.black,
//                   size: 30,
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(
//                   vertical: 20,
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//         ),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 20, top: 5),
//               child: Row(
//                 children: [
//                   SvgPicture.asset('assets/calendar 1.svg'),
//                   SizedBox(
//                     width: 15,
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'NEDJELJA, 21.4.2024',
//                         style: heading2,
//                       ),
//                       SizedBox(
//                         height: 3,
//                       ),
//                       Text(
//                         'Pregledajte koje trgovine us otvorene ovu nedjelju',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 12,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Row(
//                         children: [
//                           SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: Transform.scale(
//                               scale: 1,
//                               child: Checkbox(
//                                 activeColor: Colors.black,
//                                 checkColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius:
//                                     BorderRadius.circular(3)),
//                                 side: BorderSide(
//                                     color: Colors.black, width: 1.5),
//                                 value: isChecked,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     isChecked = value!;
//                                   });
//                                 },
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Text(
//                             'Prikazi samo otvorene',
//                             style: TextStyle(fontSize: 14),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//             Divider(),
//             SizedBox(
//               height: 20,
//             ),
//             Expanded(
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 scrollDirection: Axis.vertical,
//                 shrinkWrap: true,
//                 itemCount: controller.getAppDetails?.gasStations?.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Padding(
//                     padding: const EdgeInsets.only(
//                         left: 20, right: 20, top: 8),
//                     child: ExpansionTile(
//                       title: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 10, top: 10),
//                             child: Row(
//                               children: [
//                                 Image.network(
//                                   "https://webservis.mzoe-gor.hr/img/${controller.getAppDetails!.gasStations![index].obveznik!.logo.toString()}",
//                                   fit: BoxFit.fill,
//                                   height: 23,
//                                   width: 23,
//                                 ),
//                                 const SizedBox(
//                                   width: 5,
//                                 ),
//                                 Text(
//                                   controller.getAppDetails!.gasStations![index]
//                                       .naziv
//                                       .toString()
//                                       .length >
//                                       22
//                                       ? "${controller.getAppDetails!.gasStations![index].naziv.toString().substring(0, 22)}.."
//                                       : controller.getAppDetails!
//                                       .gasStations![index]
//                                       .naziv
//                                       .toString(),
//                                   style: heading2,
//                                 ),
//                                 const SizedBox(
//                                   width: 7,
//                                 ),
//                                 InkWell(
//                                   onTap: () async {
//                                     final url =
//                                         'https://www.google.com/maps/search/?api=1&query=${controller.getAppDetails!.gasStations![index].lat.toString()},${controller.getAppDetails!.gasStations![index].lng.toString()}';
//                                     await launch(url);
//                                   },
//                                   child: SvgPicture.asset(
//                                     'assets/arrow-narrow-right 1.svg',
//                                     width: 20,
//                                     height: 20,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             color: maincolor,
//                             height: 23,
//                             width: 83,
//                             child: Center(
//                               child: Text(
//                                 'ZATVORENO',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 10,
//                                     color: Colors.white),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               left: 10, right: 10, bottom: 10),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 '${controller.getAppDetails!.gasStations![index].adresa.toString()}, ${controller.getAppDetails!.gasStations![index].mjesto.toString()}',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 12,
//                                 ),
//                               ),
//
//                               Container(
//                                 height:100,
//                                 child: ListView.builder(
//                                   itemCount:controller.getAppDetails!.gasStations![index].cijene!.length ,
//                                     itemBuilder: (context, index) {
//                                      return Text("${controller.getAppDetails!.gasStations![index].cijene![index].gorivo!.naziv.toString()} ${controller.getAppDetails!.gasStations![index].cijene![index].cijena.toString()} €", style: TextStyle(
//                                        fontWeight: FontWeight.w800,
//                                        fontSize: 14,
//                                      ),);
//
//                                     },
//                                 ),
//                               )
//
//
//
//
//
//
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// // }
