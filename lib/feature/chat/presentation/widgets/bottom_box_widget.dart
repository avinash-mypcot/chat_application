import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../../../core/common/popup/pick_image_popup.dart';
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
  final ImagePicker _picker = ImagePicker();
  final SpeechToText _speechToText = SpeechToText();

  @override
  void initState() {
    super.initState();
    // _initializeSpeech();
  }

  void _initializeSpeech() async {
    await _speechToText.initialize(onError: _onSpeechError);
    setState(() {});
  }

  void _onSpeechError(SpeechRecognitionError error) {
    log('Speech recognition error: ${error.errorMsg}');
    setState(() {
      isListening = false;
      isMic = true;
    });
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      widget.msg.text = result.recognizedWords;
      isMic = widget.msg.text.isEmpty;
      isListening = false;
    });
  }

  Future<void> _pickProfileImage() async {
    await showModelBottomSheet(
      context: context,
      imageFile: (File image) {
        setState(() {
          _selectedImage = image;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      TextFormField(
                        onChanged: (value) => setState(() => isMic = widget.msg.text.isEmpty),
                        textAlignVertical: TextAlignVertical.top,
                        cursorColor: AppColors.kColorWhite,
                        style: kTextStylePoppins300.copyWith(color: AppColors.kColorWhite),
                        controller: widget.msg,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 7,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                          hintText: 'Enter Your Message',
                          hintStyle: kTextStylePoppins300.copyWith(height: 1, color: AppColors.kColorWhite),
                        ),
                      ),
                      Positioned(
                        right: 2.w,
                        bottom: 7.h,
                        child: Row(
                          children: [
                            // if (_selectedImage == null)
                            //   GestureDetector(
                            //     onTap: _pickProfileImage,
                            //     child: _buildIconContainer(Icons.image),
                            GestureDetector(
                              onTap: widget.send,
                              child: _buildIconContainer( Icons.send),
                            ),
                          ],
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

  void _handleMicOrSendAction() {
    if (isMic) {
      setState(() => isListening = true);
      _speechToText.isNotListening ? _startListening() : _stopListening();
    } else {
      widget.send;
      setState(() {
        isMic = true;
        _selectedImage = null;
      });
      widget.scroll();
    }
  }
  

  Widget _buildIconContainer(IconData icon) {
    return Container(
      margin: EdgeInsets.only(right: 8.w, top: 6.h),
      height: 35.h,
      width: 35.h,
      decoration: BoxDecoration(
        color: AppColors.kColorBlue,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(icon, color: AppColors.kColorWhite),
      ),
    );
  }
}
