// import 'dart:developer';
// import 'package:auto_route/auto_route.dart';
// import 'package:chat_application/core/router/app_router.gr.dart';
// import 'package:fast_contacts/fast_contacts.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../../../../core/common/popup/logout_popup.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/theme/textstyles.dart';

// @RoutePage()
// class ContactPage extends StatefulWidget {
//   const ContactPage({super.key});

//   @override
//   State<ContactPage> createState() => _ContactPageState();
// }

// class _ContactPageState extends State<ContactPage> {
//   late Future<List<Contact>> _contactsFuture;

//   @override
//   void initState() {
//     super.initState();
//     _contactsFuture = getContacts(); // Store the future here
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.kColorBlack,
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//         centerTitle: true,
//         backgroundColor: AppColors.kColorBlack.withOpacity(0.9),
//         title: Text(
//           "Chat with us!",
//           style: kTextStylePoppins400.copyWith(
//             fontSize: 16.sp,
//             color: AppColors.kColorWhite,
//           ),
//         ),
//         actions: [
//           GestureDetector(
//             onTap: () {
//               showDialog(
//                   context: context,
//                   builder: (context) {
//                     return LogoutPopup();
//                   });
//             },
//             child: Container(
//               margin: EdgeInsets.only(left: 12.w),
//               height: 40.h,

//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 12.w,
//                   ),
//                   Icon(
//                     Icons.logout_outlined,
//                     color: AppColors.kColorWhite,
//                   ),

//                 ],
//               ),
//             ),
//           ),

//           SizedBox(width: 12.w),
//         ],
//       ),
//       body: FutureBuilder<List<Contact>>(
//         future: _contactsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 Contact contact = snapshot.data![index];
//                 return Column(
//                   children: [
//                     GestureDetector(
//                       onTap: (){
//                         // context.router.push(ChatRoute(mo: contact.phones[0].number,name: contact.displayName));
//                       },
//                       child: ListTile(
//                         leading:  CircleAvatar(
//                           radius: 20.r,
//                           child: Icon(Icons.person),
//                         ),
//                         title: Text(contact.displayName,style: kTextStylePoppins400.copyWith(
//                         fontSize: 14.sp,
//                         color: AppColors.kColorWhite,
//                         )),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             if (contact.phones.isNotEmpty)
//                               Text(contact.phones[0].number,style: kTextStylePoppins400.copyWith(
//                                 fontSize: 14.sp,
//                                 color: AppColors.kColorWhite,
//                               ),),
//                             if (contact.emails.isNotEmpty)
//                               Text(contact.emails[0].address,style: kTextStylePoppins400.copyWith(
//                                 fontSize: 14.sp,
//                                 color: AppColors.kColorWhite,
//                               )),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const Divider(),
//                   ],
//                 );
//               },
//             );
//           } else {
//             return Center(
//               child: Text(
//                 "No Contacts",
//                 style: kTextStylePoppins400.copyWith(
//                   fontSize: 16.sp,
//                   color: AppColors.kColorBlack,
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }

//   Future<List<Contact>> getContacts() async {
//     bool isGranted = await Permission.contacts.status.isGranted;
//     if (!isGranted) {
//       isGranted = await Permission.contacts.request().isGranted;
//     }
//     if (isGranted) {
//       final data = await FastContacts.getAllContacts();
//       log("DATA $data");
//       return data;
//     }
//     return [];
//   }
// }
