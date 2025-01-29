import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/textstyles.dart';
import '../../../chat/presentation/bloc/chat_bloc.dart';
import '../../../code_verification/bloc/code_verification_bloc.dart';
import '../bloc/history_bloc.dart';
import '../widgets/chat_card.dart';

@RoutePage()
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    final currentState = context.read<CodeVerificationBloc>().state;
    bool isVerified =currentState == CodeVerified;
    context.read<HistoryBloc>().add(GetHistoryEvent(isVerified: isVerified));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: AppColors.kColorBlack.withValues(alpha: 0.5),
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              context.router.popForced();
            },
            child: Icon(Icons.arrow_back),
          ),
          foregroundColor: AppColors.kColorWhite,
          scrolledUnderElevation: 0,
          centerTitle: true,
          backgroundColor: AppColors.kColorBlack.withValues(alpha: 0.9),
          title: Text(
            "History",
            style: kTextStylePoppins400.copyWith(
                fontSize: 16.sp, color: AppColors.kColorWhite),
          ),
        ),
        body: Container(
          color: AppColors.kColorBlack.withValues(alpha: 0.85),
          child: Stack(
            children: [
              BlocListener<ChatBloc, ChatState>(
                listener: (context, state) {
                  if (state is ChatLoaded) {
                    context.router.maybePop();
                  }
                },
                child: BlocBuilder<HistoryBloc, HistoryState>(
                  builder: (context, state) {
                    if (state is HistoryLoaded) {
                      return ListView.builder(
                        itemCount: state.model.data!.length,
                        itemBuilder: (context, index) {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  state.model.data![index].date!.chats!.length,
                              itemBuilder: (context, index1) {
                                return GestureDetector(
                                  onTap: () {
                                    context.read<ChatBloc>().add(ChatHistory(
                                      index: index1,
                                        model: state.model.data![index].date!
                                            .chats![index1]));
                                  },
                                  child: ChatCard(
                                      chat: state.model.data![index].date!
                                          .chats![index1]),
                                );
                              });
                        },
                      );
                    } else if (state is HistoryLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is HistoryFailed ||
                        state is HistoryException) {
                      return Center(child: Text("try Again"));
                    }
                    return SizedBox();
                  },
                ),
              )
            ],
          ),
        ));
  }
}
