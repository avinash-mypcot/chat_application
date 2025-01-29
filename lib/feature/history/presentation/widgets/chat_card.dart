import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/textstyles.dart';
import '../../../chat/data/model/chat_model.dart';

class ChatCard extends StatelessWidget {
  final ChatModel chat;

  const ChatCard({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: SizedBox(
          height: 150.h,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chat.candidates![0].date ?? 'No Date'),
                if (chat.candidates != null)
                  ...chat.candidates!.map((candidate) {
                    return Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (candidate.content?.parts != null)
                            ...candidate.content!.parts!.map((part) {
                              return Text(
                                part.text ?? '',
                                style: kTextStylePoppins400.copyWith(
                                    fontSize: 14.sp),
                                overflow: TextOverflow.ellipsis,
                              );
                            }),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
