import 'package:flutter/material.dart';
import 'package:kosarica/constants/color_text.dart';
import 'package:kosarica/constants/text_fields_payment.dart';

class AddCardScreen extends StatelessWidget {
  AddCardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text(
                    'Add New Card',
                    style: heading1,
                  ),
                ],
              ),
              const SizedBox(
                height: 45,
              ),
              const Row(
                children: [
                  Text(
                    'Name in card',
                    // style: labelH,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextFields_PaymentMethod(
                hintText: 'Name in card',
                pre: const Icon(
                  Icons.person,
                  color: Color(0xffFF9F1A),
                  size: 27,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                children: [
                  Text(
                    'Card number',
                    // style: labelH,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              TextFields_PaymentMethod(
                keyboardType: TextInputType.number,
                hintText: 'Card number',
                pre: const Icon(
                  Icons.person,
                  color: Color(0xffFF9F1A),
                  size: 27,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text(
                              'Expiry Date',
                              // style: labelH,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFields_PaymentMethod(
                          keyboardType: TextInputType.number,
                          hintText: 'Expiry Date',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text(
                              'CCV',
                              // style: labelH,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFields_PaymentMethod(
                          keyboardType: TextInputType.number,
                          hintText: 'CCV',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 80,
              ),
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => CheckoutScreen()));
                },
                child: Container(
                  height: 50,
                  child: const Center(
                    child: Text(
                      'Pay Now',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                  color: const Color(0xffFF9F1A),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
