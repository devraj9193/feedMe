import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../dashboard_screen.dart';
import '../../main.dart';
import '../../utils/app_config.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/widgets.dart';
import '../../utils/widgets/will_pop_widget.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 2.h, left: 5.w, right: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAppBar(
                  () {
                    Navigator.pop(context);
                  },
                  isBackEnable: true,
                  showLogo: false,
                  showChild: true,
                  child: Text(
                    "Upload",
                    style: TextStyle(
                      fontFamily: kFontBold,
                      fontSize: 15.dp,
                      color: gBlackColor,
                    ),
                  ),
                ),
                if (finalFiles.isEmpty) SizedBox(height: 2.h),
                if (finalFiles.isEmpty)
                  Center(
                    child: IntrinsicWidth(
                      child: GestureDetector(
                        onTap: () async {
                          showChooserSheet();
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 3.h, horizontal: 3.w),
                          padding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 5.w),
                          decoration: BoxDecoration(
                            color: gWhiteColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 12,
                                offset: const Offset(2, 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 2.5.h,
                                  color: gBlackColor,
                                ),
                                Text(
                                  "   Choose file",
                                  style: TextStyle(
                                      fontFamily: "GothamMedium",
                                      color: Colors.black,
                                      fontSize: 13.dp),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 0.5.h),
                if (finalFiles.isNotEmpty)
                  ListView.builder(
                    itemCount: finalFiles.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      final file = finalFiles[index];
                      return buildFile(file, index);
                    },
                  ),
                SizedBox(height: 2.h),
                Text(
                  "Description :",
                  style: TextStyle(
                    fontFamily: kFontMedium,
                    fontSize: 13.dp,
                    color: gBlackColor,
                  ),
                ),
                Container(
                  height: 12.h,
                  margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 1.h),
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(2, 10),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: commentController,
                    cursorColor: gPrimaryColor,
                    style: TextStyle(
                        fontFamily: kFontBook,
                        color: gTextColor,
                        fontSize: 13.dp),
                    decoration: InputDecoration(
                      suffixIcon: commentController.text.isEmpty
                          ? const SizedBox()
                          : InkWell(
                              onTap: () {
                                commentController.clear();
                              },
                              child: const Icon(
                                Icons.close,
                                color: gTextColor,
                              ),
                            ),
                      hintText: "Description",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontFamily: "GothamBook",
                        color: gTextColor,
                        fontSize: 11.dp,
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                  child: ElevatedButton(
                    onPressed: acceptLoading
                        ? null
                        : () {
                            if (finalFiles.isEmpty) {
                              AppConfig().showSnackbar(
                                  context, 'Please Select File',
                                  isError: true);
                            } else if (commentController.text.isEmpty) {
                              AppConfig().showSnackbar(
                                  context, 'Please enter description',
                                  isError: true);
                            } else {
                              submitUpload(
                                commentController.text.trim(),
                                finalFiles[0].path.split("/").last,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          loginButtonSelectedColor, //change background color of button
                      backgroundColor:
                          loginButtonColor, //change text color of button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2.0,
                    ),
                    child: Center(
                      child: (acceptLoading)
                          ? buildThreeBounceIndicator(color: gBlackColor)
                          : Text(
                              "Submit",
                              style: TextStyle(
                                fontFamily: buttonFont,
                                fontSize: buttonFontSize,
                                color: buttonColor,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showChooserSheet() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        enableDrag: false,
        builder: (ctx) {
          return Wrap(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                          color: gHintTextColor,
                          width: 2.0,
                        ),
                      )),
                      child: Text(
                        'Choose Profile Pic',
                        style: TextStyle(
                          color: gTextColor,
                          fontFamily: kFontMedium,
                          fontSize: 12.dp,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () {
                                getImageFromCamera();
                                Navigator.pop(context);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.camera_enhance_outlined,
                                    color: appPrimaryColor,
                                    size: 2.5.h,
                                  ),
                                  SizedBox(width: 1.5.w),
                                  Text(
                                    'Camera',
                                    style: TextStyle(
                                      color: gTextColor,
                                      fontFamily: kFontMedium,
                                      fontSize: 10.dp,
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            width: 5,
                            height: 20,
                            decoration: const BoxDecoration(
                                border: Border(
                              right: BorderSide(
                                color: gHintTextColor,
                                width: 1,
                              ),
                            )),
                          ),
                          TextButton(
                              onPressed: () {
                                pickFromFile();
                                Navigator.pop(context);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.photo_library,
                                    color: appPrimaryColor,
                                    size: 2.5.h,
                                  ),
                                  SizedBox(width: 1.5.w),
                                  Text(
                                    'Gallery',
                                    style: TextStyle(
                                      color: gTextColor,
                                      fontFamily: kFontMedium,
                                      fontSize: 10.dp,
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then(
          (pickedFile) => cropSelectedImage("${pickedFile?.path}").then(
            (croppedFile) => setState(() {
              _image = File("${croppedFile?.path}");
              if (getFileSize(_image!) <= 12) {
                print("filesize: ${getFileSize(_image!)}Mb");
                finalFiles.add(_image!);
              } else {
                print("filesize: ${getFileSize(_image!)}Mb");

                AppConfig().showSnackbar(context, "File size must be <12Mb",
                    isError: true);
              }
            }),
          ),
        );
    print("captured image: $_image");
  }

  void pickFromFile() async {
    await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then(
          (pickedFile) => cropSelectedImage("${pickedFile?.path}").then(
            (croppedFile) => setState(() {
              _image = File("${croppedFile?.path}");
            }),
          ),
        );
    setState(() {
      File file = File(_image?.path ?? "");
      setState(() {
        finalFiles.add(file);
      });
    });
  }

  File? _image;

  getFileSize(File file) {
    var size = file.lengthSync();
    num mb = num.parse((size / (1024 * 1024)).toStringAsFixed(2));
    return mb;
  }

  List<PlatformFile> medicalRecords = [];
  List<File> finalFiles = [];

  Widget buildFile(File file, int index) {
    return buildRecordList(file, index: index);
  }

  buildRecordList(File filename, {int? index}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: ListTile(
        shape: const Border(
          bottom: BorderSide(),
        ),
        leading: SizedBox(
          width: 50,
          height: 50,
          child: Image.file(
            File(filename.path),
          ),
        ),
        title: Text(
          filename.path.split("/").last,
          textAlign: TextAlign.start,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: kFontBold,
            fontSize: 13.dp,
          ),
        ),
        trailing: GestureDetector(
            onTap: () {
              finalFiles.removeAt(index!);
              setState(() {});
            },
            child: const Icon(
              Icons.delete_outline_outlined,
              color: gMainColor,
            )),
      ),
    );
  }

  bool acceptLoading = false;

  final _prefs = AppConfig().preferences;

  void submitUpload(
    String description,
    String fileName,
  ) async {
    setState(() {
      acceptLoading = true;
    });
    try {
      final avatarFile = _image;

      final String path = await supabase.storage.from('profile_pic').upload(
            "${_image?.path.split('/').last}",
            avatarFile!,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      print("Profile update : $path");

      print("user_id : ${_prefs?.getString(AppConfig.userId)}");

      if (path.isNotEmpty) {
        final String getFeedPic =
            supabase.storage.from('profile_pic').getPublicUrl(path.split("/").last);

        print("getFeedPic : $getFeedPic");
        if (getFeedPic.isNotEmpty) {
          final res = await supabase.from('feeds').insert({
            'user_id': "${_prefs?.getString(AppConfig.userId)}",
            'description': description,
            'file_name': getFeedPic,
            'user_name': "${_prefs?.getString(AppConfig.userName)}",
          });

          print("submitUpload:$res");
          print("submitUpload.runtimeType: ${res.toString()}");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const DashboardScreen(
                index: 4,
              ),
            ),
          );
        }
      }
    } on PostgrestException catch (error) {
      AppConfig().showSnackbar(context, error.message, isError: true);
    } catch (error) {
      AppConfig()
          .showSnackbar(context, 'Unexpected error occurred', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          acceptLoading = false;
        });
      }
    }
  }
}
