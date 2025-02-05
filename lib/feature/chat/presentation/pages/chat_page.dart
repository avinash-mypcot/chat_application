import 'dart:developer';
import 'dart:math';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/popup/update_popup.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/textstyles.dart';
import '../../../code_verification/bloc/code_verification_bloc.dart';
import '../../../code_verification/presentation/pages/code_verification_pages.dart';
import '../widgets/bottom_box_widget.dart';
import '../widgets/massege_widget.dart';

@RoutePage()
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _userInput = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? uId;
  late String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    uId = auth.currentUser?.uid;
    if (DateFormat('yyyy-MM-dd').format(DateTime.now()) == '2025-02-12') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        openVersionBottomSheet(context, '');
      });
    }
  }

  @override
  void dispose() {
    _userInput.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _scrambleText(String text) {
    final random = Random();
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+-=[]{}|;:,.<>?';

    return text.split('').map((_) {
      return chars[random.nextInt(chars.length)];
    }).join('');
  }

  Future<void> _sendMessage() async {
    if (_userInput.text.trim().isEmpty) return;

    final chatRef = FirebaseFirestore.instance
        .collection('chatModels')
        .doc(todayDate)
        .collection('messages');

    await chatRef.add({
      'message': _userInput.text.trim(),
      'isUser': uId, // Assuming the sender is the user
      'date': Timestamp.now(),
    });

    _userInput.clear();
    _scrollToEnd();
  }

  @override
  Widget build(BuildContext context) {
    print("ENtire widget rebuild");
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.kColorGrey,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.kColorBlack.withOpacity(0.9),
        title: Text(
          "Chat with us!",
          style: kTextStylePoppins400.copyWith(
            fontSize: 16.sp,
            color: AppColors.kColorWhite,
          ),
        ),
        actions: [
          BlocBuilder<CodeVerificationBloc, CodeVerificationState>(
              builder: (context, state) {
            if (state is! CodeVerified) {
              return GestureDetector(
                onTap: () {
                  // openVersionBottomSheet(context,'');
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CodeVerificationPopup();
                      });
                },
                child: Container(
                  margin: EdgeInsets.only(left: 12.w),
                  height: 40.h,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 12.w,
                      ),
                      Icon(
                        Icons.info,
                        color: AppColors.kColorWhite,
                      ),
                    ],
                  ),
                ),
              );
            }
            return SizedBox();
          }),
          SizedBox(width: 12.w),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/back_img.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatModels')
                        .doc(todayDate)
                        .collection('messages')
                        .orderBy('date', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text("No messages yet."));
                      }

                      final messages = snapshot.data!.docs;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToEnd();
                      });

                      return BlocBuilder<CodeVerificationBloc,
                          CodeVerificationState>(
                        builder: (context, state) {
                          return ListView.builder(
                            controller: _scrollController,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final messageData = messages[index].data()
                                  as Map<String, dynamic>;
                              final bool isUserMessage =
                                  uId == messageData['isUser'];
                              final String originalMessage =
                                  messageData['message'] ?? '';

                              // Encrypt message only if user is not verified
                              final bool isVerified = state is CodeVerified;
                              final String displayedMessage = isVerified
                                  ? originalMessage
                                  : _scrambleText(originalMessage);
                              print("LIST VIEW REFRESH");
                              return MessageWidget(
                                isUser: isUserMessage,
                                message: displayedMessage,
                                date: DateFormat('HH:mm').format(
                                  (messageData['date'] as Timestamp).toDate(),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                BottomBoxWidget(
                  send: _sendMessage,
                  scroll: _scrollToEnd,
                  msg: _userInput,
                  // onSend: _sendMessage, // Pass the send function to BottomBoxWidget
                ),
              ],
            ),
          ),
          BlocConsumer<CodeVerificationBloc, CodeVerificationState>(
            builder: (context, state) {
              if (state is! CodeVerificationFailed && state is! CodeVerified) {
                return CodeVerificationPopup();
              }
              return SizedBox();
            },
            listener: (context, state) {
              if (state is CodeVerificationFailed || state is CodeVerified) {
              } else {}
            },
          )
        ],
      ),
    );
  }
}
