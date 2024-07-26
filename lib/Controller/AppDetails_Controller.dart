

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:kosarica/App_Repositry/AppDetails_repositry.dart';
import 'package:kosarica/Models/appDetails_model.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class appDetails_controller extends GetxController{
  AppDetailsModel ? getAppDetails;
  var Loading=false.obs;
  List Cartitems=[];
  var cartbox=Hive.box("cart_items");
  var F_catagory=Hive.box("F_catagories");
  var F_offers=Hive.box("F_offers");
  String ? keyword;
  DateTime ? date;
  TextEditingController favoritename=TextEditingController();
  var qantity=0.obs;

  var totalprice=0.obs;
  List<Map<String , dynamic>> mycatagory=[];
  List<Map<String , dynamic>> myoffers=[];// use to get the data from the Hive
  var F_box=Hive.box("F_catagories");


  List<bool> values = [];
  List<String> keys = [];
  bool fromTop = true;
  bool? isChecked = true;
  List multipleSelected = [];


  List checkListItems = [
    {
      "id": 0,
      "value": true,
      "title": "a",
    },
    {
      "id": 1,
      "value": true,
      "title": "b",
    },
    {
      "id": 2,
      "value": true,
      "title": "c",
    },
    {
      "id": 4,
      "value": true,
      "title": "d",
    },
    {
      "id": 5,
      "value": true,
      "title": "d",
    },
    {
      "id": 6,
      "value": true,
      "title": "d",
    },
    {
      "id": 7,
      "value": true,
      "title": "d",
    },
    {
      "id": 8,
      "value": true,
      "title": "d",
    },
    {
      "id": 9,
      "value": true,
      "title": "d",
    },
    {
      "id": 10,
      "value": true,
      "title": "d",
    },
    {
      "id": 11,
      "value": true,
      "title": "d",
    },
    {
      "id": 12,
      "value": true,
      "title": "d",
    },
    {
      "id": 13,
      "value": true,
      "title": "d",
    },
    {
      "id": 14,
      "value": true,
      "title": "d",
    },
    {
      "id": 15,
      "value": true,
      "title": "d",
    },
    {
      "id": 16,
      "value": true,
      "title": "d",
    },
    {
      "id": 17,
      "value": true,
      "title": "d",
    },
    {
      "id": 18,
      "value": true,
      "title": "d",
    },
    {
      "id": 19,
      "value": true,
      "title": "d",
    },
  ];

// .................................. for filter the offers form the catagories...........................................

  List<Offers>? filterOffersByCategory(List<Offers>? offers, List<Categories>? categories, String categoryName) {
    if (offers == null || categories == null) {
      return null;
    }

    // Find the categoryId corresponding to the given categoryName
    int? categoryId;
    for (var category in categories) {
      if (category.categoryName == categoryName) {
        categoryId = category.categoryId;
        break;
      }
    }

    // Filter the offers based on the categoryId
    List<Offers>? filteredOffers = offers.where((offer) => offer.categoryId == categoryId).toList();

    return filteredOffers;
  }

  // .................................. for filter the offers form the stores...........................................

  List<Offers>? filterOffersByStoreId(List<Offers>? offers, int storeId) {
    if (offers == null) {
      return null;
    }

    // Filter the offers based on the storeId
    List<Offers>? filteredOffers = offers.where((offer) => offer.storeId == storeId).toList();

    return filteredOffers;
  }


  // ........................................ for filter the data basedupon favourite key words..............................

  List<Offers>? filterOffersByKeywords(List<Offers>? offers, List<String> keywords) {
    if (offers == null) {
      return null;
    }

    // Filter the offers based on keywords
    List<Offers>? filteredOffers = offers.where((offer) {
      // Check if any keyword matches either in title or description
      for (String keyword in keywords) {
        if (offer.articleName!.toLowerCase().contains(keyword.toLowerCase()) ||
            offer.articleDesc!.toLowerCase().contains(keyword.toLowerCase())) {
          return true;
        }
      }
      return false;
    }).toList();

    return filteredOffers;
  }





  //.....................................appController Details.....................................................

  Future fetchingStore ()async{
    var result=await Appdetails().fetchingAPPDETALS();
    print('get app Details ${result}');
    getAppDetails=AppDetailsModel.fromJson(result);
    getAppDetails!.offers?.forEach((element) {
      print("offers_details ${element.offerNewPriceEur}"  );
    });
    update(['update_data']);

    print("All the data is loaded successfully");
    Loading.value=true;




  }

  // ............................. creating the local database variabel..........................................................

  createData(Map<String,dynamic> data)async{
    await cartbox.add(data);
    print("cart box update : ${cartbox.length}");

  }

  createFcatagories(Map<String,dynamic> data)async{
    await F_catagory.add(data);
    print("cart box update : ${F_catagory.length}");

  }
  createFoffers(Map<String,dynamic> data)async{
    await F_offers.add(data);
    print("cart box update : ${F_offers.length}");

  }

  //................................ for the google ads implimentations......................................






}