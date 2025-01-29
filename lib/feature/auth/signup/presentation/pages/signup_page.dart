import 'package:ai_chatbot/core/router/app_router.gr.dart';
import 'package:ai_chatbot/feature/auth/signup/presentation/bloc/signup_bloc.dart';
import 'package:ai_chatbot/feature/auth/signup/presentation/bloc/signup_state.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ai_chatbot/core/theme/app_colors.dart';
import 'package:ai_chatbot/core/theme/textstyles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/already_account.dart';
import '../widgets/register_button.dart';
import '../widgets/text_fields.dart';

@RoutePage()
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            color: AppColors.kColorBlack.withOpacity(0.85),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.0.sp, 16.0.sp, 16.0.sp,
                  MediaQuery.of(context).viewInsets.bottom),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Register",
                          style: kTextStylePoppins500.copyWith(
                            fontSize: 24.sp,
                            color: AppColors.kColorWhite.withValues(alpha: 0.9),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        // Phone Number Field

                        TextFields(
                            emailController: _emailController,
                            passController: _passController),

                        SizedBox(height: 30.h),
                        RegisterButton(
                            formKey: _formKey,
                            emailController: _emailController,
                            passController: _passController),
                        SizedBox(
                          height: 30.h,
                        ),
                        AlreadyAccount()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          BlocConsumer<SignUpBloc, SignUpState>(builder: (context, state) {
            if (state is SignUpLoadingState) {
              return Center(
                  child: SizedBox(child: CircularProgressIndicator()));
            }
            return SizedBox();
          }, listener: (context, state) {
            if (state is SignUpException) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.errorMessage)));
            } else if (state is SignUpSuccessState) {
              context.router.replace(SignInRoute());
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.model.message)));
            }
          })
        ],
      ),
    );
  }
}
