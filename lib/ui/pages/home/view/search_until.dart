// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:ride_usuario/themes/themes.dart';
// import 'package:ride_usuario/ui/widgets/widgets.dart';
// import '/utils/button.dart' as btn;

// void showSearchUntilBottomSheet(BuildContext context) {
//   final TextEditingController controller = TextEditingController();

//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     isDismissible: false,
//     builder: (context) {
//       return Container(
//         height: MediaQuery.of(context).size.height - 40,
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(30),
//             topRight: Radius.circular(30),
//           ),
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Column(
//           children: [
//             Container(
//               width: 60,
//               height: 6,
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             Row(
//               children: [
//                 Opacity(
//                   opacity: 0,
//                   child: CircleAvatar(
//                     maxRadius: 25,
//                     backgroundColor: Color(0xffF5F5F7),
//                     child: IconButton(
//                       icon: const Icon(
//                         Icons.close,
//                         color: AppColors.blue,
//                       ),
//                       onPressed: () {},
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                     child: Text(
//                   'Establece tu ruta',
//                   style: TextStyle(
//                     color: AppColors.black,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                   ),
//                   textAlign: TextAlign.center,
//                 )),
//                 CircleAvatar(
//                   maxRadius: 25,
//                   backgroundColor: Color(0xffF5F5F7),
//                   child: IconButton(
//                     icon: const Icon(
//                       Icons.close,
//                       color: AppColors.blue,
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 27),
//             InputFormSearch(type: 'until', controller: controller),
//             SizedBox(height: 25),
//             Row(
//               children: [
//                 SvgPicture.asset(
//                   'assets/img/viewOnMap.svg',
//                   width: 20,
//                   height: 20,
//                 ),
//                 SizedBox(
//                   width: 8,
//                 ),
//                 TextButton(
//                     onPressed: () {},
//                     child: Text(
//                       'Ver en mapa',
//                       style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.blue),
//                       textAlign: TextAlign.start,
//                     )),
//               ],
//             ),
//             Expanded(
//               child: ListView.separated(
//                 itemCount: 10,
//                 separatorBuilder: (context, index) => Divider(
//                   color: AppColors.black10,
//                   height: 1,
//                 ),
//                 itemBuilder: (context, index) {
//                   final title = 'Calle ${index + 1}';
//                   final subtitle = 'Distrito de ${index + 1}';

//                   return ListTile(
//                     leading: SvgPicture.asset(
//                       'assets/img/clock_refresh.svg',
//                       colorFilter:
//                           ColorFilter.mode(AppColors.black25, BlendMode.srcIn),
//                       width: 20,
//                       height: 20,
//                     ),
//                     title: Text(title,
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w500,
//                           color: AppColors.black,
//                         )),
//                     subtitle: Text(subtitle,
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w400,
//                           color: AppColors.black50,
//                         )),
//                     onTap: () {},
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 27),
//             btn.button(label: 'Confirmar', onPressed: () {}, type: 'black'),
//             SizedBox(height: 10),
//           ],
//         ),
//       );
//     },
//   ).whenComplete(() {
//   });
// }
