import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../../../core/common/popup/pick_image_popup.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/textstyles.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/upload_image_bloc/upload_image_bloc.dart';

// class BottomBoxWidget extends StatefulWidget {
//   const BottomBoxWidget({
//     super.key,
//     required this.scroll,
//     required this.msg,
//   });
//   final VoidCallback scroll;
//   final TextEditingController msg;

//   @override
//   State<BottomBoxWidget> createState() => _BottomBoxWidgetState();
// }

// class _BottomBoxWidgetState extends State<BottomBoxWidget> {
//   bool isMic = true;
//   bool isListen = false;

//   final SpeechToText _speechToText = SpeechToText();

//   @override
//   void initState() {
//     super.initState();
//     _initSpeech();
//   }

//   /// This has to happen only once per app
//   void _initSpeech() async {
//     await _speechToText.initialize(
//       onError: _onSpeechError,
//     );
//     setState(() {});
//   }

//   /// Each time to start a speech recognition session
//   void _startListening() async {
//     await _speechToText.listen(
//       onResult: _onSpeechResult,
//     );
//     setState(() {});
//   }

//   /// Handle speech recognition errors
//   void _onSpeechError(SpeechRecognitionError error) {
//     log('Speech recognition error: ${error.errorMsg}');
//     setState(() {
//       isListen = false;
//       isMic = true; // Reset to mic mode
//     });
//   }

//   void _stopListening() async {
//     await _speechToText.stop();
//     setState(() {});
//   }

//   void _onSpeechResult(SpeechRecognitionResult result) {
//     setState(() {
//       widget.msg.text = result.recognizedWords;
//       if (widget.msg.text.isNotEmpty) {
//         isMic = false;
//       } else if (widget.msg.text.isEmpty) {
//         isMic = true;
//       }
//       isListen = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Expanded(
//             flex:
//                 1, // Ensures the TextFormField takes up the maximum available space
//             child: Stack(
//               children: [
//                 TextFormField(
//                   onChanged: (value) {
//                     if (widget.msg.text.isNotEmpty) {
//                       log("Toggle called");
//                       setState(() {
//                         isMic = false;
//                       });
//                     } else if (widget.msg.text.isEmpty) {
//                       setState(() {
//                         isMic = true;
//                       });
//                     }
//                   },
//                   textAlignVertical: TextAlignVertical.top,
//                   cursorColor: AppColors.kColorWhite,
//                   style: kTextStylePoppins300.copyWith(
//                     color: AppColors.kColorWhite,
//                   ),
//                   controller: widget.msg,
//                   keyboardType:
//                       TextInputType.multiline, // Allows multiline input
//                   minLines: 1, // Ensures at least 1 line is displayed
//                   maxLines: 7, // Allows the text field to expand vertically
//                   decoration: InputDecoration(
//                     isDense: true,
//                     contentPadding: EdgeInsets.only(
//                         left: 20.w, bottom: 15.h, top: 15.h, right: 100.w),
//                     disabledBorder: InputBorder.none,
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: AppColors.kColorWhite),
//                       borderRadius: BorderRadius.circular(20.r),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide:
//                           BorderSide(color: AppColors.kColorWhite, width: 2.0),
//                       borderRadius: BorderRadius.circular(20.r),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide:
//                           BorderSide(color: AppColors.kColorWhite, width: 1.0),
//                       borderRadius: BorderRadius.circular(20.r),
//                     ),
//                     hintText: 'Enter Your Message',
//                     hintStyle: kTextStylePoppins300.copyWith(
//                         height: 1, color: AppColors.kColorWhite),

//                     // label: Text(
//                     //   'Enter Your Message',
//                     //   style: kTextStylePoppins300.copyWith(
//                     //       height: 1, color: AppColors.kColorWhite),
//                     // ),
//                   ),
//                 ),
//                 Positioned(
//                   right: 2.w,
//                   bottom: 7.h,
//                   child: Row(
//                     children: [
//                       BlocBuilder<ChatBloc, ChatState>(
//                         builder: (context, state) {
//                           return GestureDetector(
//                             onTap: () {

//                             },
//                             child: Container(
//                               margin: EdgeInsets.only(right: 8.w, top: 6.h),
//                               height: 35.h,
//                               width: 35.h,
//                               decoration: BoxDecoration(
//                                 color: AppColors.kColorBlue,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Center(
//                                 child: Icon(
//                                   Icons.image,
//                                   color: AppColors.kColorWhite,
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                       BlocBuilder<ChatBloc, ChatState>(
//                         builder: (context, state) {
//                           if (state is ChatLoaded) {
//                             return GestureDetector(
//                               onTap: () {
//                                 if (isMic) {
//                                   setState(() {
//                                     isListen = true;
//                                   });
//                                   _speechToText.isNotListening
//                                       ? _startListening()
//                                       : _stopListening();
//                                 } else {
//                                   context.read<ChatBloc>().add(ChatRequest(
//                                       isNewChat: state.isNewChat,
//                                       msg: widget.msg.text.trim(),
//                                       date: state.data.date!));
//                                   widget.msg.clear();
//                                   widget
//                                       .scroll(); // Scroll to the end when a new message is sent
//                                   setState(() {
//                                     isMic = true;
//                                   });
//                                 }
//                               },
//                               child: Container(
//                                 margin: EdgeInsets.only(right: 8.w, top: 6.h),
//                                 height: 35.h,
//                                 width: 35.h,
//                                 decoration: BoxDecoration(
//                                   color: AppColors.kColorBlue,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Center(
//                                   child: !isMic
//                                       ? Icon(
//                                           Icons.send,
//                                           color: AppColors.kColorWhite,
//                                         )
//                                       : isListen
//                                           ? Icon(
//                                               Icons.mic,
//                                               color: AppColors.kColorWhite,
//                                             )
//                                           : Icon(
//                                               Icons.mic_off,
//                                               color: AppColors.kColorWhite,
//                                             ),
//                                 ),
//                               ),
//                             );
//                           }
//                           return SizedBox();
//                         },
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class BottomBoxWidget extends StatefulWidget {
  const BottomBoxWidget({
    super.key,
    required this.scroll,
    required this.msg,
  });
  final VoidCallback scroll;
  final TextEditingController msg;

  @override
  State<BottomBoxWidget> createState() => _BottomBoxWidgetState();
}

class _BottomBoxWidgetState extends State<BottomBoxWidget> {
  bool isMic = true;
  bool isListen = false;
  File? _selectedImage; // Store selected image file
  final ImagePicker _picker = ImagePicker();
  final SpeechToText _speechToText = SpeechToText();

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speechToText.initialize(
      onError: _onSpeechError,
    );
    setState(() {});
  }

  String? imageUrl;
  Future<void> setProfileImage() async {
    await showModelBottomSheet(
        context: context,
        imageFile: (File image) {
          setState(() {
            _selectedImage = image;
          });
          if (_selectedImage != null && mounted) {
            log("API Called");
            context
                .read<UploadImageBloc>()
                .add(UploadImageToGemini(image: _selectedImage!.path));
          }
        });
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
    );
    setState(() {});
  }

  void _onSpeechError(SpeechRecognitionError error) {
    log('Speech recognition error: ${error.errorMsg}');
    setState(() {
      isListen = false;
      isMic = true;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      widget.msg.text = result.recognizedWords;
      if (widget.msg.text.isNotEmpty) {
        isMic = false;
      } else if (widget.msg.text.isEmpty) {
        isMic = true;
      }
      isListen = false;
    });
  }

  // Function to open image picker
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      if (_selectedImage != null && mounted) {
        log("API Called");
        context
            .read<UploadImageBloc>()
            .add(UploadImageToGemini(image: _selectedImage!.path));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.kColorWhite)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_selectedImage != null) // Show the image if selected
              Padding(
                padding: EdgeInsets.only(bottom: 8.0.sp, top: 8.sp, left: 8.sp),
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
                              onTap: () {
                                setState(() {
                                  _selectedImage = null;
                                });
                              },
                              child: Icon(Icons.cancel)))
                    ],
                  ),
                ),
              ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          if (widget.msg.text.isNotEmpty) {
                            setState(() {
                              isMic = false;
                            });
                          } else if (widget.msg.text.isEmpty) {
                            setState(() {
                              isMic = true;
                            });
                          }
                        },
                        textAlignVertical: TextAlignVertical.top,
                        cursorColor: AppColors.kColorWhite,
                        style: kTextStylePoppins300.copyWith(
                          color: AppColors.kColorWhite,
                        ),
                        controller: widget.msg,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 7,
                        decoration: InputDecoration(
                          border: InputBorder.none,

                          isDense: true,
                          contentPadding: EdgeInsets.only(
                              left: 20.w,
                              bottom: 15.h,
                              top: 15.h,
                              right: 100.w),
                          disabledBorder: InputBorder.none,
                          // border: OutlineInputBorder(
                          //   borderSide:
                          //       BorderSide(color: AppColors.kColorWhite),
                          //   borderRadius: BorderRadius.circular(20.r),
                          // ),
                          // focusedBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //       color: AppColors.kColorWhite, width: 2.0),
                          //   borderRadius: BorderRadius.circular(20.r),
                          // ),
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //       color: AppColors.kColorWhite, width: 1.0),
                          //   borderRadius: BorderRadius.circular(20.r),
                          // ),
                          hintText: 'Enter Your Message',
                          hintStyle: kTextStylePoppins300.copyWith(
                              height: 1, color: AppColors.kColorWhite),
                        ),
                      ),
                      Positioned(
                        right: 2.w,
                        bottom: 7.h,
                        child: Row(
                          children: [
                            if (_selectedImage == null)
                              GestureDetector(
                                onTap: setProfileImage, // Trigger image picker
                                child: Container(
                                  margin: EdgeInsets.only(right: 8.w, top: 6.h),
                                  height: 35.h,
                                  width: 35.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.kColorBlue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.image,
                                      color: AppColors.kColorWhite,
                                    ),
                                  ),
                                ),
                              ),
                            BlocBuilder<ChatBloc, ChatState>(
                              builder: (context, state) {
                                if (state is ChatLoaded) {
                                  final isNewChat = state.isNewChat;
                                  final date = state.data.date;
                                  final index = state.index;
                                  return BlocBuilder<UploadImageBloc,
                                      UploadImageState>(
                                    builder: (context, state) {
                                      return GestureDetector(
                                        onTap: () {
                                          log("API CALLED FOR MSG : $isMic");
                                          if (isMic) {
                                            setState(() {
                                              isListen = true;
                                            });
                                            _speechToText.isNotListening
                                                ? _startListening()
                                                : _stopListening();
                                          } else {
                                            log("API CALLED FOR MSG");
                                            if (_selectedImage != null &&
                                                state is UploadImageSuccess) {
                                              context.read<ChatBloc>().add(
                                                  ImageResponseReq(
                                                    index: index,
                                                      imagePath:
                                                          _selectedImage!.path,
                                                      date: date!,
                                                      imageUrl: state
                                                          .model.file1!.uri!,
                                                      msg: widget.msg.text
                                                          .trim(),
                                                      mimeType: state.model
                                                          .file1!.mimeType!,
                                                      isNewChat: isNewChat));   
                                            } else {
                                              context.read<ChatBloc>().add(
                                                  ChatRequest(
                                                      isNewChat: isNewChat,
                                                      index: index,
                                                      msg: widget.msg.text
                                                          .trim(),
                                                      date: date!));

                                              widget.scroll();
                                              setState(() {
                                                isMic = true;
                                              });
                                            }
                                          }
                                          widget.msg.clear();
                                          setState(() {
                                            _selectedImage = null;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              right: 8.w, top: 6.h),
                                          height: 35.h,
                                          width: 35.h,
                                          decoration: BoxDecoration(
                                            color: AppColors.kColorBlue,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: !isMic
                                                ? Icon(
                                                    Icons.send,
                                                    color:
                                                        AppColors.kColorWhite,
                                                  )
                                                : isListen
                                                    ? Icon(
                                                        Icons.mic,
                                                        color: AppColors
                                                            .kColorWhite,
                                                      )
                                                    : Icon(
                                                        Icons.mic_off,
                                                        color: AppColors
                                                            .kColorWhite,
                                                      ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                                return SizedBox();
                              },
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
}
