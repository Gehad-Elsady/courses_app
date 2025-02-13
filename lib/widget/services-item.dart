// // ignore_for_file: must_be_immutable

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hasadak/Screens/add-services/model/service-model.dart';

// class ServicesItem extends StatelessWidget {
//   final ServiceModel service;
//   final VoidCallback? callBack;
//   final String buttonTitle;
//   final bool showButton;

//   const ServicesItem({
//     Key? key,
//     required this.service,
//     this.callBack,
//     required this.buttonTitle,
//     this.showButton = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.7),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 4,
//             spreadRadius: 2,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // Image Section
//           ClipRRect(
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(12),
//               topRight: Radius.circular(12),
//             ),
//             child: CachedNetworkImage(
//               imageUrl: service.image,
//               height: MediaQuery.of(context).size.height *
//                   0.17, // Responsive height
//               fit: BoxFit.cover,
//               placeholder: (context, url) =>
//                   const Center(child: CircularProgressIndicator()),
//               errorWidget: (context, url, error) =>
//                   const Icon(Icons.error, size: 50, color: Colors.red),
//             ),
//           ),
//           // Name Section
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text(
//               service.name,
//               textAlign: TextAlign.center,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: GoogleFonts.montserrat(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//                 fontSize: 18,
//               ),
//             ),
//           ),
//           SizedBox(height: 8),
//           // Price Section
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Text(
//               "${service.price} EGP",
//               textAlign: TextAlign.right,
//               style: GoogleFonts.montserrat(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.amber,
//               ),
//             ),
//           ),
//           // Optional Button
//           if (showButton)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.amber,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 onPressed: callBack,
//                 child: Text(
//                   buttonTitle,
//                   style: GoogleFonts.montserrat(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
