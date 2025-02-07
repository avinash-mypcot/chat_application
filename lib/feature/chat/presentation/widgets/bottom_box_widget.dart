import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/textstyles.dart';

class BottomBoxWidget extends StatefulWidget {
  const BottomBoxWidget({super.key, required this.scroll, required this.msg,required this.send});
  final VoidCallback scroll;
  final TextEditingController msg;
  final VoidCallback send;

  @override
  State<BottomBoxWidget> createState() => _BottomBoxWidgetState();
}
class _BottomBoxWidgetState extends State<BottomBoxWidget> {
  bool isMic = true;
  bool isListening = false;
  File? _selectedImage;
  static final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return 
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.kColorWhite),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_selectedImage != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 8.sp),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Stack(
                    children: [
                      Image.file(
                        _selectedImage!,
                        width: 50.h,
                        height: 50.h,
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        right: 2,
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedImage = null),
                          child: const Icon(Icons.cancel),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.top,
                          cursorColor: AppColors.kColorWhite,
                          style: kTextStylePoppins300.copyWith(color: AppColors.kColorWhite),
                          controller: widget.msg,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 7,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(onPressed: (){}, icon: GestureDetector(
                              onTap: widget.send,
                              child: _buildIconContainer( Icons.send),
                            ),),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                            hintText: 'Enter Your Message',
                            hintStyle: kTextStylePoppins300.copyWith(height: 1, color: AppColors.kColorWhite),
                          ),
                          
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconContainer(IconData icon) {
    return Container(
      height: 35.h,
      width: 35.h,
      decoration: BoxDecoration(
        color: AppColors.kColorBlue,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(icon, color: AppColors.kColorWhite,size: 20.sp,),
      ),
    );
  }
}
