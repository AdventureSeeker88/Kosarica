import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class language_change extends StatefulWidget {
  const language_change({super.key});

  @override
  State<language_change> createState() => _language_changeState();
}

class _language_changeState extends State<language_change> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        backgroundColor: Colors.white,
        content: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.redAccent, width: 7)),
          height: 200,
          width: 300,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300),
                        child: Center(
                          child: IconButton(
                              onPressed: () => Get.back(),
                              icon: Icon(Icons.clear)),
                        ),
                      )),
                ),
                InkWell(
                    onTap: () {
                      Get.updateLocale(Locale("en", "Us"));
                      Get.back();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.language),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          "English (US)",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                    onTap: () {
                      Get.updateLocale(Locale("hr", "croatia"));
                      Get.back();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.language),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          "Coratian (Coratia)",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
