
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/textstyles.dart';
import '../../../../core/utils/utils.dart';

class MessageWidget extends StatefulWidget {
  final bool isUser;
  final String message;
  final String date;
  final String? image;

  const MessageWidget(
      {super.key,
      required this.isUser,
      required this.message,
      required this.date,
      this.image});

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  bool _isExpanded = false; // Track if the message is expanded

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          widget.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(vertical: 15.sp).copyWith(
                left: widget.isUser ? 100.sp : 10.sp,
                right: widget.isUser ? 10.sp : 100.sp),
            decoration: BoxDecoration(
                color: widget.isUser
                    ? AppColors.kColorBlue.withValues(alpha: 0.7)
                    : AppColors.kColorBlack.withValues(alpha: 0.5),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft:
                        widget.isUser ? Radius.circular(10) : Radius.zero,
                    topRight: Radius.circular(10),
                    bottomRight:
                        widget.isUser ? Radius.zero : Radius.circular(10))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.image != null)
                  AppUtils.decodeBase64ToImage(widget.image!),
                Text(
                  widget.isUser
                      ? widget.message
                      : _isExpanded
                          ? widget.message
                          : (widget.message.length > 100
                              ? '${widget.message.substring(0, 100)}...'
                              : widget.message),
                  style: kTextStylePoppins300.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.kColorWhite.withValues(alpha: 0.8)),
                ),
                if (widget.message.length > 100)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(
                      _isExpanded ? 'See less' : 'See more',
                      style: kTextStylePoppins200.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.kColorBlue,
                        fontSize: 12.sp,
                        color: AppColors.kColorBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Text(
                  widget.date,
                  style: kTextStylePoppins300.copyWith(
                    fontSize: 10.sp,
                    color: AppColors.kColorWhite,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
