import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';


class Defu_Sorting_method extends StatefulWidget {
  const Defu_Sorting_method({super.key});

  @override
  State<Defu_Sorting_method> createState() => _Defu_Sorting_methodState();
}

class _Defu_Sorting_methodState extends State<Defu_Sorting_method> {
  bool ischeck=true;
  bool ischeck2=false;
  bool ischeck3=false;
  bool ischeck4=false;
  bool ischeck5=false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        height: 350,
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
                     ischeck3=false;
                     ischeck4=false;
                     ischeck5=false;
                  });
                },
              ),
              SizedBox(width: 10,),
              Text("Items name",style: TextStyle(fontSize: 22),)
            ],),
            SizedBox(height: 10,),
            Row(children: [
              RoundCheckBox(
                isChecked: ischeck2,
                size: 30,
                checkedColor: Colors.red,

                onTap: (bool? isseleted ) {
                  setState(() {
                    ischeck2=isseleted!;
                    ischeck=false;
                    ischeck3=false;
                    ischeck4=false;
                    ischeck5=false;
                  });
                },
              ),
              SizedBox(width: 10,),

              Text("Price",style: TextStyle(fontSize: 22))
            ],),
            SizedBox(height: 10,),
            Row(children: [
              RoundCheckBox(
                isChecked: ischeck3,
                size: 30,
                checkedColor: Colors.red,

                onTap: (bool? isseleted ) {
                  setState(() {
                    ischeck3=isseleted!;
                    ischeck2=false;
                    ischeck=false;
                    ischeck4=false;
                    ischeck5=false;
                  });
                },
              ),
              SizedBox(width: 10,),

              Text("Category",style: TextStyle(fontSize: 22))
            ],),
            SizedBox(height: 10,),
            Row(children: [
              RoundCheckBox(
                isChecked: ischeck4,
                size: 30,
                checkedColor: Colors.red,

                onTap: (bool? isseleted ) {
                  setState(() {
                    ischeck4=isseleted!;
                    ischeck2=false;
                    ischeck3=false;
                    ischeck=false;
                    ischeck5=false;
                  });
                },
              ),
              SizedBox(width: 10,),

              Text("Shop",style: TextStyle(fontSize: 22))
            ],),
            SizedBox(height: 10,),
            Row(children: [
              RoundCheckBox(
                isChecked: ischeck5,
                size: 30,
                checkedColor: Colors.red,

                onTap: (bool? isseleted ) {
                  setState(() {
                    ischeck5=isseleted!;
                    ischeck2=false;
                    ischeck3=false;
                    ischeck4=false;
                    ischeck=false;
                  });
                },
              ),
              SizedBox(width: 10,),

              Text("Duration",style: TextStyle(fontSize: 22))
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
