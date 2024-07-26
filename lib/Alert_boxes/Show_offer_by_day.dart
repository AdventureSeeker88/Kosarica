import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';


class view_by_day extends StatefulWidget {
  const view_by_day({super.key});

  @override
  State<view_by_day> createState() => _view_by_dayState();
}

class _view_by_dayState extends State<view_by_day> {
  bool ischeck=true;
  bool ischeck2=false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        height: 200,
        width: 300,

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
                alignment: Alignment.topRight,
                child: IconButton(onPressed: () => Get.back() , icon: Icon(Icons.clear))),
            Row(children: [
              RoundCheckBox(
                isChecked: ischeck,
                size: 30,
                checkedColor: Colors.red,

                onTap: (bool? isseleted ) {
                  setState(() {
                    ischeck=isseleted!;
                    ischeck2=false;
                  });
                },
              ),
              SizedBox(width: 10,),
              Text("DA",style: TextStyle(fontSize: 22),)
            ],),
            SizedBox(height: 20,),
            Row(children: [
             RoundCheckBox(
               isChecked: ischeck2,
               size: 30,
               checkedColor: Colors.red,

               onTap: (bool? isseleted ) {
                 setState(() {
                   ischeck2=isseleted!;
                   ischeck=false;
                 });
               },
             ),
              SizedBox(width: 10,),

              Text("NE",style: TextStyle(fontSize: 22))
            ],),
            TextButton(
                onPressed: () {
                  Get.back();
              
            }, child: Text("SAVE",style: TextStyle(color: Colors.red,fontSize: 18),))

          ],
        ),
      ),
    );
  }
}
