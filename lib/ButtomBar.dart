import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kosarica/Cart_screen.dart';
import 'package:kosarica/Favorite_screen.dart';
import 'package:kosarica/More_screen.dart';
import 'package:kosarica/Sunday_Screen.dart';
import 'package:kosarica/kosarica_pocetna_screen.dart';

class AnimatedBar extends StatefulWidget {
  const AnimatedBar({Key? key}) : super(key: key);

  @override
  State<AnimatedBar> createState() => _AnimatedBarState();
}

class _AnimatedBarState extends State<AnimatedBar> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  //.............................. for the intersitial ads ...............................
  InterstitialAd? _interstitialAd;
  bool _isLoaded = false;
  final adUnitInterstitalId = 'ca-app-pub-6735162421884355/2833307589';

  void loadInterstitialAd() {
    InterstitialAd.load(
        adUnitId: adUnitInterstitalId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }





  //.............................................................................



  static List<Widget> _widgetOptions = <Widget>[
    KosaricaPocetnaScreen(),
    KosaricaScreen(),
    FavouriteScreen(),

    SundayScreen(),
    // Replace 'MoreScreen()' with your more screen widget
    MoreScreen(),
  ];

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _widgetOptions,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: Container(
        height: 70,
        child: BottomNavigationBar(
          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: () {
                  _interstitialAd!.show();
                },
                child: Icon(
                  Icons.local_fire_department_outlined,
                  size: 27,
                ),
              ),
              label: 'Offers',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_bag_outlined,
                size: 27,
              ),
              label: 'Cart',
            ),
            // Replace 'Favourites' with your favorite screen label
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite_outline,
                size: 27,
              ),
              label: 'Favourites',
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: () {
                  _interstitialAd!.show();
                },
                child: Icon(
                  Icons.more_outlined,
                  size: 27,
                ),
              ),
              label: 'Sunday',
            ),
            // Replace 'More' with your more screen label
            BottomNavigationBarItem(
              icon: Icon(
                Icons.euro_rounded,
                size: 27,
              ),
              label: 'More',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
