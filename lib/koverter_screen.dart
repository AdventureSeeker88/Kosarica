import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:kosarica/constants/color_text.dart';

class CurrencyConverter extends StatefulWidget {
  @override
  State<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {


  bool _isEuroInput = true;
  double euroAmount = 0.0;
  double hrkAmount = 0.0;
  final double euroToHrkRate = 7.53450;

  void convertCurrency(double amount) {
    setState(() {
      if (_isEuroInput) {
        euroAmount = amount;
        hrkAmount = amount * euroToHrkRate;
      } else {
        hrkAmount = amount;
        euroAmount = amount / euroToHrkRate;
      }
    });
  }
  TextEditingController controller = TextEditingController();

  void toggleInput() {
    setState(() {
      _isEuroInput = !_isEuroInput;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: maincolor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 19),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 26,
                ),
              ),
            ),
            toolbarHeight: 60,
            title: Text(
              'Currency Converter',
              style: heading2,
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Image.asset('assets/Group 16.png'),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 1,
                      child: Image.asset('assets/Group 17.png'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60, right: 100, top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [

                    Container(
                      width: 130,
                      child: TextFormField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w500,
                        ),
                        cursorColor: maincolor,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            double amount = double.tryParse(value) ?? 0.0;
                            convertCurrency(amount);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter amount',
                          hintStyle: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          contentPadding: const EdgeInsets.only(
                            top: 11,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      _isEuroInput ? hrkAmount.toStringAsFixed(2) : euroAmount.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 65,
              ),
              InkWell(
                onTap: () {
                  Get.to(CurrencyConverter2(controller: controller,));
                },
                child: Icon(
                  Icons.swap_horiz,
                  size: 50,
                ),
              ),
              Expanded(child: SizedBox()),

              Container(

                height: 80,
                width: double.infinity,
                color: Colors.red,
                child: Column(
                  children: [
                    Text("Fixed conversion rate:",style: TextStyle(color: Colors.white60,fontSize: 20),),

                    Row( mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("1 Eur = 7.53450 HRK",style: TextStyle(color: Colors.white,fontSize: 21),)

                      ],),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



// .................................... now for HRK to Euro ......................................................





class CurrencyConverter2 extends StatefulWidget {
  final TextEditingController  controller;

  const CurrencyConverter2({super.key, required this.controller});
  @override
  State<CurrencyConverter2> createState() => _CurrencyConverter2State();
}

class _CurrencyConverter2State extends State<CurrencyConverter2> {
  bool _isEuroInput = true;
  double euroAmount = 0.0;
  double hrkAmount = 0.0;
  final double hrkToEuroRate = 0.1327;

  void convertCurrency(double amount) {
    setState(() {
      euroAmount = amount;
      hrkAmount = amount * hrkToEuroRate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: maincolor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 19),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 26,
                ),
              ),
            ),
            toolbarHeight: 60,
            title: Text(
              'Currency Converter',
              style: heading2,
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Image.asset('assets/Group 16.png'),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 1,
                      child: Image.asset('assets/Group 17.png'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60, right: 100, top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      hrkAmount.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      width: 130,
                      child: TextFormField(
                        controller: widget.controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w500,
                        ),
                        cursorColor: maincolor,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            double amount = double.tryParse(value) ?? 0.0;
                            convertCurrency(amount);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter amount',
                          hintStyle: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          contentPadding: const EdgeInsets.only(
                            top: 11,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 65,
              ),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.swap_horiz,
                  size: 50,
                ),
              ),
              Expanded(child: SizedBox()),

              Container(

                height: 80,
                width: double.infinity,
                color: Colors.red,
                child: Column(
                  children: [
                    Text("Fixed conversion rate:",style: TextStyle(color: Colors.white60,fontSize: 20),),

                    Row( mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("1 Eur = 7.53450 HRK",style: TextStyle(color: Colors.white,fontSize: 21),)

                    ],),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

