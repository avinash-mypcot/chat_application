import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/textstyles.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/profile_textfield_widget.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  String? getUserEmail() {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // The user is logged in, retrieve the email
      return user.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Ensures the layout adjusts when keyboard appears
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
          "Profile",
          style: kTextStylePoppins400.copyWith(
              fontSize: 16.sp, color: AppColors.kColorWhite),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: AppColors.kColorBlack.withValues(alpha: 0.85),
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.fromLTRB(24.0.sp, 24.sp, 24.sp,
                MediaQuery.of(context).viewInsets.bottom + 10.h),
            child: SingleChildScrollView(
              // Ensures scrolling when content overflows
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoadedState) {
                    if (_nameController.text.isEmpty &&
                        _mobileController.text.isEmpty &&
                        _emailController.text.isEmpty) {
                      _nameController.text = state.model.name;
                      _mobileController.text = state.model.mobile;
                      _emailController.text = getUserEmail()!;
                    }

                    return Form(
                      key: _key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Profile Picture
                                  CircleAvatar(
                                    radius: 35.r,
                                    // backgroundImage: AssetImage(''), // Replace with your image asset
                                    child: Icon(Icons.person,
                                        size: 40.sp, color: Colors.white),
                                  ),
                                  SizedBox(height: 24),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            "Name",
                            style: kTextStylePoppins300.copyWith(
                                color: AppColors.kColorGrey),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          ProfileTextfieldWidget(
                              formKey: _key,
                              nameController: _nameController,
                              textHint: 'Enter Name'),
                          SizedBox(
                            height: 12.h,
                          ),
                          Text(
                            "Mobile",
                            style: kTextStylePoppins300.copyWith(
                                color: AppColors.kColorGrey),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          ProfileTextfieldWidget(
                              formKey: _key,
                              nameController: _mobileController,
                              textHint: 'Enter Mobile Number'),
                          SizedBox(
                            height: 12.h,
                          ),
                          Text(
                            "Email",
                            style: kTextStylePoppins300.copyWith(
                                color: AppColors.kColorGrey),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          ProfileTextfieldWidget(
                              isReadOnly: true,
                              formKey: _key,
                              nameController: _emailController,
                              textHint: 'Enter Email Address'),
                          SizedBox(
                            height: 50.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (_key.currentState!.validate()) {
                                    context.read<ProfileBloc>().add(
                                        ProfileUpdateEvent(
                                            username: _nameController.text,
                                            mobile: _mobileController.text,
                                            email: _emailController.text));
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.kColorGrey,
                                      borderRadius:
                                          BorderRadius.circular(12.r)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12.sp, horizontal: 18.sp),
                                  child: Text(
                                    "Save",
                                    style: kTextStylePoppins300.copyWith(
                                        color: AppColors.kColorWhite),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return SizedBox();
                },
              ),
            ),
          ),
          BlocConsumer<ProfileBloc, ProfileState>(builder: (context, state) {
            if (state is ProfileLoadedState && state.isUpdate) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return SizedBox();
          }, listener: (context, state) {
            if (state is ProfileFailedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to upload profile")));
            } else if (state is ProfileLoadedState && state.isUpdate == false) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Profile updated successfully")));
            }
          })
        ],
      ),
    );
  }
}
