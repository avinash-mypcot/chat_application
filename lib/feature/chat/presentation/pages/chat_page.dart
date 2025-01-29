import 'dart:developer';
import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/textstyles.dart';
import '../../../code_verification/bloc/code_verification_bloc.dart';
import '../../../code_verification/presentation/pages/code_verification_pages.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/bottom_box_widget.dart';
import 'package:svg_flutter/svg_flutter.dart';

import '../widgets/drawer_widget.dart';
import '../widgets/massege_widget.dart';
import '../widgets/message_shimmer_widget.dart';

@RoutePage()
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({required this.isUser, required this.message, required this.date});
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _userInput = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _userInput.dispose();
    _scrollController.dispose(); // Dispose of the controller
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

  @override
  void initState() {
          
    context.read<ProfileBloc>().add(ProfileGetEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.kColorGrey,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          centerTitle: true,
          backgroundColor: AppColors.kColorBlack.withValues(alpha: 0.9),
          leading: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                _scaffoldKey.currentState!.openDrawer();
              },
              child: AppIcons.kMenuIc),
          title: Text(
            "Chat with us!",
            style: kTextStylePoppins400.copyWith(
                fontSize: 16.sp, color: AppColors.kColorWhite),
          ),
          actions: [
            GestureDetector(
                onTap: () {
                  context.read<ChatBloc>().add(NewChatEvent());
                },
                child: SvgPicture.asset(AppIcons.kNewChatIc)),
            SizedBox(
              width: 12.w,
            ),
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
                  Expanded(
                    child: BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, state) {
                        if (state is ChatLoaded) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            // _scrollToEnd(); // Scroll to the end when new messages are loaded
                          });
                          _scrollToEnd();
                          return ListView.builder(
                            controller:
                                _scrollController, // Attach the controller
                            itemCount: state
                                .data.candidates![0].content!.parts!.length,
                            itemBuilder: (context, index) {
                              final message = state.data.candidates![0].content!
                                  .parts![index].text;

                              return MessageWidget(
                                image: state.data.candidates![0].content!
                                    .parts![index].base64Image,
                                isUser: state.data.candidates![0].content!
                                        .parts![index].isUser ??
                                    false,
                                message: message!,
                                date: state.data.candidates![0].content!
                                        .parts![index].time ??
                                    DateFormat('HH:mm').format(DateTime.now()),
                              );
                            },
                          );
                        } else if (state is ChatLoading) {
                          return MessageShimmerWidget(
                            isUser: true,
                            message: "message",
                            date: "date",
                            isLoading: true,
                          );
                        }
                        return SizedBox();
                      },
                    ),
                  ),
                  BottomBoxWidget(
                    scroll: _scrollToEnd,
                    msg: _userInput,
                  )
                ],
              ),
            ),BlocConsumer<CodeVerificationBloc,CodeVerificationState>(
              builder:(context, state) {
                if(state is! CodeVerificationFailed && state is! CodeVerified ){
                  log("State $state");
                    return CodeVerificationPopup();
                }
                 log("State $state");
                return SizedBox();
                
            },
            listener:(context,state){
              if(state is CodeVerificationFailed || state is CodeVerified ){

                }else{                }
            },
            )

          ],
        ),
        drawer: DrawerWidget());
  }
}
