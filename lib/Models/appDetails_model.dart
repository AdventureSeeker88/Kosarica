class AppDetailsModel {
  List<Categories>? categories;
  List<Offers>? offers;
  List<Stores>? stores;
  List<Sundays>? sundays;
  List<Banners>? banners;
  List<Cards>? cards;
  List<Gasstations>? gasStations;
  GasMessage? gasMessage;

  AppDetailsModel({
    this.categories,
    this.offers,
    this.stores,
    this.sundays,
    this.banners,
    this.cards,
    this.gasStations,
    this.gasMessage,
  });

  AppDetailsModel.fromJson(Map<String, dynamic> json) {
    categories = (json['categories'] as List<dynamic>?)
        ?.map((e) => Categories.fromJson(e))
        .toList();
    offers = (json['offers'] as List<dynamic>?)
        ?.map((e) => Offers.fromJson(e))
        .toList();
    stores = (json['stores'] as List<dynamic>?)
        ?.map((e) => Stores.fromJson(e))
        .toList();
    sundays = (json['sundays'] as List<dynamic>?)
        ?.map((e) => Sundays.fromJson(e))
        .toList();
    banners = (json['banners'] as List<dynamic>?)
        ?.map((e) => Banners.fromJson(e))
        .toList();
    cards = (json['cards'] as List<dynamic>?)
        ?.map((e) => Cards.fromJson(e))
        .toList();
    gasStations = (json['gasStations'] as List<dynamic>?)
        ?.map((e) => Gasstations.fromJson(e))
        .toList();
    gasMessage = json['gasMessage'] != null
        ? GasMessage.fromJson(json['gasMessage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (categories != null) {
      data['categories'] = categories!.map((e) => e.toJson()).toList();
    }
    if (offers != null) {
      data['offers'] = offers!.map((e) => e.toJson()).toList();
    }
    if (stores != null) {
      data['stores'] = stores!.map((e) => e.toJson()).toList();
    }
    if (sundays != null) {
      data['sundays'] = sundays!.map((e) => e.toJson()).toList();
    }
    if (banners != null) {
      data['banners'] = banners!.map((e) => e.toJson()).toList();
    }
    if (cards != null) {
      data['cards'] = cards!.map((e) => e.toJson()).toList();
    }
    if (gasStations != null) {
      data['gasStations'] = gasStations!.map((e) => e.toJson()).toList();
    }
    if (gasMessage != null) {
      data['gasMessage'] = gasMessage!.toJson();
    }
    return data;
  }
}

class Categories {
  int? categoryId;
  String? categoryName;
  String? categoryDescription;
  String? categoryUrl;
  String? categoryImageUrl;
  String? categoryType;
  String? categoryMain;

  Categories({
    this.categoryId,
    this.categoryName,
    this.categoryDescription,
    this.categoryUrl,
    this.categoryImageUrl,
    this.categoryType,
    this.categoryMain,
  });

  Categories.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'] as int?;
    categoryName = json['categoryName'] as String?;
    categoryDescription = json['categoryDescription'] as String?;
    categoryUrl = json['categoryUrl'] as String?;
    categoryImageUrl = json['categoryImageUrl'] as String?;
    categoryType = json['categoryType'] as String?;
    categoryMain = json['categoryMain'] as String?;
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryDescription': categoryDescription,
      'categoryUrl': categoryUrl,
      'categoryImageUrl': categoryImageUrl,
      'categoryType': categoryType,
      'categoryMain': categoryMain,
    };
  }
}

class Offers {
  int? offerId;
  String? articleName;
  String? articleDesc;
  String? articleImageUrl;
  int? storeId;
  String? storeName;
  String? storeImageUrl;
  int? categoryId;
  String? categoryName;
  String? offerValueFrom;
  String? offerValueTo;
  String? offerOldPriceHrk;
  String? offerNewPriceHrk;
  String? offerOldPriceEur;
  String? offerNewPriceEur;
  String? offerDiscount;
  String? offerTimeEntered;
  int? specialOffer;

  Offers({
    this.offerId,
    this.articleName,
    this.articleDesc,
    this.articleImageUrl,
    this.storeId,
    this.storeName,
    this.storeImageUrl,
    this.categoryId,
    this.categoryName,
    this.offerValueFrom,
    this.offerValueTo,
    this.offerOldPriceHrk,
    this.offerNewPriceHrk,
    this.offerOldPriceEur,
    this.offerNewPriceEur,
    this.offerDiscount,
    this.offerTimeEntered,
    this.specialOffer,
  });

  Offers.fromJson(Map<String, dynamic> json) {
    offerId = json['offerId'] as int?;
    articleName = json['articleName'] as String?;
    articleDesc = json['articleDesc'] as String?;
    articleImageUrl = json['articleImageUrl'] as String?;
    storeId = json['storeId'] as int?;
    storeName = json['storeName'] as String?;
    storeImageUrl = json['storeImageUrl'] as String?;
    categoryId = json['categoryId'] as int?;
    categoryName = json['categoryName'] as String?;
    offerValueFrom = json['offerValueFrom'] as String?;
    offerValueTo = json['offerValueTo'] as String?;
    offerOldPriceHrk = json['offerOldPriceHrk'] as String?;
    offerNewPriceHrk = json['offerNewPriceHrk'] as String?;
    offerOldPriceEur = json['offerOldPriceEur'] as String?;
    offerNewPriceEur = json['offerNewPriceEur'] as String?;
    offerDiscount = json['offerDiscount'] as String?;
    offerTimeEntered = json['offerTimeEntered'] as String?;
    specialOffer = json['specialOffer'] as int?;
  }

  Map<String, dynamic> toJson() {
    return {
      'offerId': offerId,
      'articleName': articleName,
      'articleDesc': articleDesc,
      'articleImageUrl': articleImageUrl,
      'storeId': storeId,
      'storeName': storeName,
      'storeImageUrl': storeImageUrl,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'offerValueFrom': offerValueFrom,
      'offerValueTo': offerValueTo,
      'offerOldPriceHrk': offerOldPriceHrk,
      'offerNewPriceHrk': offerNewPriceHrk,
      'offerOldPriceEur': offerOldPriceEur,
      'offerNewPriceEur': offerNewPriceEur,
      'offerDiscount': offerDiscount,
      'offerTimeEntered': offerTimeEntered,
      'specialOffer': specialOffer,
    };
  }
}

class Stores {
  int? storeId;
  String? storeName;
  String? storeDesc;
  String? storeImageUrl;
  int? categoryId;
  String? categoryName;

  Stores({
    this.storeId,
    this.storeName,
    this.storeDesc,
    this.storeImageUrl,
    this.categoryId,
    this.categoryName,
  });

  Stores.fromJson(Map<String, dynamic> json) {
    storeId = json['storeId'] as int?;
    storeName = json['storeName'] as String?;
    storeDesc = json['storeDesc'] as String?;
    storeImageUrl = json['storeImageUrl'] as String?;
    categoryId = json['categoryId'] as int?;
    categoryName = json['categoryName'] as String?;
  }

  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      'storeName': storeName,
      'storeDesc': storeDesc,
      'storeImageUrl': storeImageUrl,
      'categoryId': categoryId,
      'categoryName': categoryName,
    };
  }
}

class Sundays {
  String? city;
  String? address;
  int? locationActive;
  String? info;
  String? locationName;
  String? workingDate;
  int? workingStatus;
  String? workingTime;
  int? storeId;
  String? storeName;
  String? storeImageUrl;
  String? latitude;
  String? longitude;
  String? monday;
  String? tuesday;
  String? wednesday;
  String? thursday;
  String? friday;
  String? saturday;
  String? sunday;
  String? locationUrl;

  Sundays({this.city, this.address, this.locationActive, this.info, this.locationName, this.workingDate, this.workingStatus, this.workingTime, this.storeId, this.storeName, this.storeImageUrl, this.latitude, this.longitude, this.monday, this.tuesday, this.wednesday, this.thursday, this.friday, this.saturday, this.sunday, this.locationUrl});

  Sundays.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    address = json['address'];
    locationActive = json['locationActive'];
    info = json['info'];
    locationName = json['locationName'];
    workingDate = json['workingDate'];
    workingStatus = json['workingStatus'];
    workingTime = json['workingTime'];
    storeId = json['storeId'];
    storeName = json['storeName'];
    storeImageUrl = json['storeImageUrl'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    monday = json['monday'];
    tuesday = json['tuesday'];
    wednesday = json['wednesday'];
    thursday = json['thursday'];
    friday = json['friday'];
    saturday = json['saturday'];
    sunday = json['sunday'];
    locationUrl = json['locationUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['address'] = this.address;
    data['locationActive'] = this.locationActive;
    data['info'] = this.info;
    data['locationName'] = this.locationName;
    data['workingDate'] = this.workingDate;
    data['workingStatus'] = this.workingStatus;
    data['workingTime'] = this.workingTime;
    data['storeId'] = this.storeId;
    data['storeName'] = this.storeName;
    data['storeImageUrl'] = this.storeImageUrl;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['monday'] = this.monday;
    data['tuesday'] = this.tuesday;
    data['wednesday'] = this.wednesday;
    data['thursday'] = this.thursday;
    data['friday'] = this.friday;
    data['saturday'] = this.saturday;
    data['sunday'] = this.sunday;
    data['locationUrl'] = this.locationUrl;
    return data;
  }
}

class Banners {
  int? bannerId;
  String? bannerName;
  String? bannerImage;
  String? bannerUrl;

  Banners({
    this.bannerId,
    this.bannerName,
    this.bannerImage,
    this.bannerUrl,
  });

  Banners.fromJson(Map<String, dynamic> json) {
    bannerId = json['bannerId'] as int?;
    bannerName = json['bannerName'] as String?;
    bannerImage = json['bannerImage'] as String?;
    bannerUrl = json['bannerUrl'] as String?;
  }

  Map<String, dynamic> toJson() {
    return {
      'bannerId': bannerId,
      'bannerName': bannerName,
      'bannerImage': bannerImage,
      'bannerUrl': bannerUrl,
    };
  }
}

class Cards {
  int? cardId;
  String? cardName;
  String? cardDescription;
  String? cardImageUrl;

  Cards({
    this.cardId,
    this.cardName,
    this.cardDescription,
    this.cardImageUrl,
  });

  Cards.fromJson(Map<String, dynamic> json) {
    cardId = json['cardId'] as int?;
    cardName = json['cardName'] as String?;
    cardDescription = json['cardDescription'] as String?;
    cardImageUrl = json['cardImageUrl'] as String?;
  }

  Map<String, dynamic> toJson() {
    return {
      'cardId': cardId,
      'cardName': cardName,
      'cardDescription': cardDescription,
      'cardImageUrl': cardImageUrl,
    };
  }
}

class Gasstations {
  int? postajaId;
  Obveznik? obveznik;
  String? adresa;
  String? mjesto;
  String? naziv;
  String? lat;
  String? lng;
  String? url;
  List<RadnoVrijeme>? radnoVrijeme;
  List<Cijene>? cijene;

  Gasstations(
      {this.postajaId,
        this.obveznik,
        this.adresa,
        this.mjesto,
        this.naziv,
        this.lat,
        this.lng,
        this.url,
        this.radnoVrijeme,
        this.cijene});

  Gasstations.fromJson(Map<String, dynamic> json) {
    postajaId = json['postajaId'];
    obveznik = json['obveznik'] != null
        ? new Obveznik.fromJson(json['obveznik'])
        : null;
    adresa = json['adresa'];
    mjesto = json['mjesto'];
    naziv = json['naziv'];
    lat = json['lat'];
    lng = json['lng'];
    url = json['url'];
    if (json['radnoVrijeme'] != null) {
      radnoVrijeme = <RadnoVrijeme>[];
      json['radnoVrijeme'].forEach((v) {
        radnoVrijeme!.add(new RadnoVrijeme.fromJson(v));
      });
    }
    if (json['cijene'] != null) {
      cijene = <Cijene>[];
      json['cijene'].forEach((v) {
        cijene!.add(new Cijene.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postajaId'] = this.postajaId;
    if (this.obveznik != null) {
      data['obveznik'] = this.obveznik!.toJson();
    }
    data['adresa'] = this.adresa;
    data['mjesto'] = this.mjesto;
    data['naziv'] = this.naziv;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['url'] = this.url;
    if (this.radnoVrijeme != null) {
      data['radnoVrijeme'] = this.radnoVrijeme!.map((v) => v.toJson()).toList();
    }
    if (this.cijene != null) {
      data['cijene'] = this.cijene!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Obveznik {
  int? obveznikId;
  String? naziv;
  String? logo;

  Obveznik({this.obveznikId, this.naziv, this.logo});

  Obveznik.fromJson(Map<String, dynamic> json) {
    obveznikId = json['obveznik_id'];
    naziv = json['naziv'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['obveznik_id'] = this.obveznikId;
    data['naziv'] = this.naziv;
    data['logo'] = this.logo;
    return data;
  }
}

class RadnoVrijeme {
  String? dan;
  String? pocetak;
  String? kraj;

  RadnoVrijeme({this.dan, this.pocetak, this.kraj});

  RadnoVrijeme.fromJson(Map<String, dynamic> json) {
    dan = json['dan'];
    pocetak = json['pocetak'];
    kraj = json['kraj'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dan'] = this.dan;
    data['pocetak'] = this.pocetak;
    data['kraj'] = this.kraj;
    return data;
  }
}

class Cijene {
  int? postajaId;
  Gorivo? gorivo;
   double? cijena;
  String? updated;
  int? tipGoriva;

  Cijene(
      {this.postajaId, this.gorivo,  this.updated, this.tipGoriva,this.cijena});

  Cijene.fromJson(Map<String, dynamic> json) {
    postajaId = json['postajaId'];
    gorivo =
    json['gorivo'] != null ? new Gorivo.fromJson(json['gorivo']) : null;
    cijena = json['cijena'] != null ? (json['cijena'] as num).toDouble() : null;

    updated = json['updated'];
    tipGoriva = json['tipGoriva'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postajaId'] = this.postajaId;
    if (this.gorivo != null) {
      data['gorivo'] = this.gorivo!.toJson();
    }
     data["cijena"]=this.cijena;
    data['updated'] = this.updated;
    data['tipGoriva'] = this.tipGoriva;
    return data;
  }
}

class Gorivo {
  int? gorivoId;
  String? naziv;
  String? oznaka;
  Null? obveznik;
  int? gorivoId1;
  int? obveznikId;
  int? vrstaGorivaId;

  Gorivo(
      {this.gorivoId,
        this.naziv,
        this.oznaka,
        this.obveznik,
        this.gorivoId1,
        this.obveznikId,
        this.vrstaGorivaId});

  Gorivo.fromJson(Map<String, dynamic> json) {
    gorivoId = json['gorivoId'];
    naziv = json['naziv'];
    oznaka = json['oznaka'];
    obveznik = json['obveznik'];
    gorivoId1 = json['gorivo_id'];
    obveznikId = json['obveznik_id'];
    vrstaGorivaId = json['vrsta_goriva_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gorivoId'] = this.gorivoId;
    data['naziv'] = this.naziv;
    data['oznaka'] = this.oznaka;
    data['obveznik'] = this.obveznik;
    data['gorivo_id1'] = this.gorivoId1;
    data['obveznik_id'] = this.obveznikId;
    data['vrsta_goriva_id'] = this.vrstaGorivaId;
    return data;
  }
}

class GasMessage {
  int? messageId;
  String? messageText;

  GasMessage({
    this.messageId,
    this.messageText,
  });

  GasMessage.fromJson(Map<String, dynamic> json) {
    messageId = json['messageId'] as int?;
    messageText = json['messageText'] as String?;
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'messageText': messageText,
    };
  }
}








