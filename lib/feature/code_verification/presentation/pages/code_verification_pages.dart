import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/textstyles.dart';
import '../../../chat/presentation/bloc/chat_bloc.dart';
import '../../bloc/code_verification_bloc.dart';

class CodeVerificationPopup extends StatefulWidget {
  const CodeVerificationPopup({super.key});

  @override
    State createState() => _CodeVerificationPopupState();
}

class _CodeVerificationPopupState extends State<CodeVerificationPopup> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.kColorWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: 
        BlocConsumer<CodeVerificationBloc, CodeVerificationState>(
          listener: (context, state) {
            if (state is CodeVerified) {
              log("$state");
              // context.router.maybePop();
            } else if (state is CodeVerificationFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Enter Verification Code", style: kTextStylePoppins400.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.h),
                  TextField(
                    controller: _codeController,
                    decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Enter Code"),
                    keyboardType: TextInputType.number,
                    style: kTextStylePoppins400.copyWith(
                fontSize: 16.sp, ),
                  ),
                  SizedBox(height: 20.h),
                  state is CodeVerifying
                      ? CircularProgressIndicator()
                      : Row(
                        children: [
                          SizedBox(width: 10.w,),
                          ElevatedButton(
                            style:ButtonStyle(
                              backgroundColor:  WidgetStatePropertyAll(AppColors.kColorBlack)
                            ),
                              onPressed: () {
                                String code = _codeController.text.trim();
                                
                                  context.read<CodeVerificationBloc>().add(VerifyCode(code));
                              context.read<ChatBloc>().add(GetTodayChat(isVerified:  false));
                             
                                
                              },
                              child: Text("Cancel",style: kTextStylePoppins400.copyWith(
                fontSize: 14.sp, color: AppColors.kColorWhite),),
                            ),
                           Spacer(),
                          ElevatedButton(
                            style:ButtonStyle(
                              backgroundColor:  WidgetStatePropertyAll(AppColors.kColorBlack)
                            ),
                              onPressed: () {
                                String code = _codeController.text.trim();
                                if (code.isNotEmpty) {
                                  context.read<CodeVerificationBloc>().add(VerifyCode(code));
                              context.read<ChatBloc>().add(GetTodayChat(isVerified: code == '12345'));
                                }
                              },
                              child: Text("Verify",style: kTextStylePoppins400.copyWith(
                fontSize: 14.sp, color: AppColors.kColorWhite),),
                            ),
                            SizedBox(width: 10.w,),
                        ],
                      ),
                ],
              ),
            );
          },
        ),
      
    );
  }
}
