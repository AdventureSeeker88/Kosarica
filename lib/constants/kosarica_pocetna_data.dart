import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kosarica/constants/color_text.dart';

// slider items

final List<Widget> items = [
  Padding(
    padding: const EdgeInsets.only(left: 10),
    child: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/image 2.png',
            fit: BoxFit.fill,
            height: 20,
            width: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Image.asset(
                  'assets/57ed05bea98bceae5f0eaada26b69cee6c61471d3030f7123d212844a35eba04 (4) 1.png',
                  fit: BoxFit.fill,
                  height: 155,
                  width: 140,
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 250,
                      child: Text(
                        'Hrusty Tortilje original 8x20 cm 320 g',
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      'Ponuda vrijedi do: 18.01.2023',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: const Color(0xff1E1E1E).withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '1,32 €',
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: const Color(0xff1E1E1E).withOpacity(0.7),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '1,',
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 33,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('29', style: sliderTextStyle),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '9,99 Kn',
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: const Color(0xff1E1E1E).withOpacity(0.7),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '8,',
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 33,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('97', style: sliderTextStyle),
                                    Text('Kn', style: sliderTextStyle),
                                  ],
                                ),
                              ],
                            ),
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
  ),
];

// categories data

class Categories_Data {
  String productImage;
  String productTitle;
  String productPrice;
  String eUR;

  Categories_Data(
    this.productImage,
    this.productTitle,
    this.productPrice,
    this.eUR,
  );
}

final List<Categories_Data> categoriesD = [
  Categories_Data(
    'assets/57ed05bea98bceae5f0eaada26b69cee6c61471d3030f7123d212844a35eba04 1.png',
    'Krastavci',
    '0,',
    '30',
  ),
  Categories_Data(
    'assets/57ed05bea98bceae5f0eaada26b69cee6c61471d3030f7123d212844a35eba04 1.png',
    'Krastavci',
    '0,',
    '30',
  ),
  Categories_Data(
    'assets/57ed05bea98bceae5f0eaada26b69cee6c61471d3030f7123d212844a35eba04 1.png',
    'Krastavci',
    '0,',
    '30',
  ),
  Categories_Data(
    'assets/57ed05bea98bceae5f0eaada26b69cee6c61471d3030f7123d212844a35eba04 1.png',
    'Krastavci',
    '0,',
    '30',
  ),
  Categories_Data(
    'assets/57ed05bea98bceae5f0eaada26b69cee6c61471d3030f7123d212844a35eba04 1.png',
    'Krastavci',
    '0,',
    '30',
  ),
];
