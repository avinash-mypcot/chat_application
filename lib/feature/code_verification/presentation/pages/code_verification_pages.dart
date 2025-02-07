import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _formkey = GlobalKey<FormState>();

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
                  Form(
                    key: _formkey,
                    child: TextFormField(
                    
                      validator: (value) {
                        if(value == null || value.trim().isEmpty){
                            return "Please Enter Code";
                        }
                      },
                      controller: _codeController,
                      decoration: InputDecoration(
                        errorStyle:kTextStylePoppins400.copyWith(fontSize: 14.sp) ,
                        border: OutlineInputBorder(),
                        hintText: "Enter Code",
                      ),
                      keyboardType: TextInputType.number,
                      style: kTextStylePoppins400.copyWith(fontSize: 16.sp),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10), // Limit to 10 digits
                        FilteringTextInputFormatter.digitsOnly, // Allow digits only
                      ],
                    ),
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
                                
                                  context.read<CodeVerificationBloc>().add(VerifyCodeCancel(code));
                              // context.read<ChatBloc>().add(GetTodayChat(isVerified:  false));
                             context.router.maybePop();
                             FocusScope.of(context).unfocus();
                                
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
                                if (_formkey.currentState!.validate()) {
                                  context.read<CodeVerificationBloc>().add(VerifyCode(code));
                              context.read<ChatBloc>().add(GetTodayChat(isVerified: code == '12345'));
                              context.router.maybePop();
                              FocusScope.of(context).unfocus();
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
