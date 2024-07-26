//
// import 'package:flutter/material.dart';
// import 'package:purchases_flutter/models/package_wrapper.dart';
//
//
// class parallypage extends StatefulWidget {
//   final String Title;
//   final String description;
//   final List<Package> package;
//   final ValueChanged<Package> onclickPackage;
//
//   const parallypage({super.key, required this.Title, required this.description, required this.package, required this.onclickPackage});
//
//   @override
//   State<parallypage> createState() => _parallypageState();
// }
//
// class _parallypageState extends State<parallypage> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: BoxConstraints(
//         maxHeight: MediaQuery.of(context).size.height*0.75
//       ),
//       child: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Text("${widget.Title}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.amber),),
//             Text("${widget.description}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.amber),),
//             SizedBox(height: 15,),
//
//
//           ],
//         ),
//       ),
//     );
//
//
//
//   }
//   Widget BuildPAckages()=>ListView.builder(
//     itemCount: widget.package.length,
//     itemBuilder:(context, index) {
//       final package= widget.package[index];
//       return buildPackeges(context, package);
//
//   }, );
//
//   Widget buildPackeges(BuildContext context, Package package){
//     final product= package.storeProduct;
//     return Card(
//       color: Theme.of(context).primaryColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12)
//       ),
//       child: Theme(
//           data: ThemeData.light(),
//           child: ListTile(
//             contentPadding: EdgeInsets.all(8),
//             title: Text(product.title.toString()),
//             subtitle: Text(product.description),
//             trailing: Text(product.priceString),
//             onTap: () => widget.onclickPackage(package),
//           )
//       ),
//     );
//
//
//   }
// }
