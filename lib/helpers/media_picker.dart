// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';

import '../theme/colors.dart';
import '../theme/style.dart';
import '../widgets/media/media_utils.dart';

enum MediaPickerFileTypes { images, videos, docs, audios }

/// This Media Picker Pickes Files From Gallery,Camera And File Explorer From Android And IOS.
///
/// [context] Provide context of the current screen.
///
/// [callBack] This Callback will return List of all files path
///
/// [allowFileTypes] Provide media types,Type of Media Types is [MediaPickerFileTypes], By default [allowFileTypes] is [MediaPickerFileTypes.images,MediaPickerFileTypes.videos,MediaPickerFileTypes.docs,MediaPickerFileTypes.audios]
///
/// [allowMultiple] If you want to select multiple file at a same time, By default [false],
///
/// [prevPickedFiles] Need to Provide previously picked file paths array, By default empty [],If you want to enable [getBackAllFiles] that time need to provide [prevPickedFiles].
///
/// [maximumUploadSizeInMB] For the Checking maximum file size validation,By default 100, Unit of the file size is MB.
///
/// [getBackAllFiles] If enable, You will return previous selected files and last selected files, By default [false]
///
///
void MediaPicker({
  required BuildContext context,
  required Function(List<String?>) callBack,
  List<MediaPickerFileTypes> allowFileTypes = const [
    MediaPickerFileTypes.images,
    MediaPickerFileTypes.videos,
    MediaPickerFileTypes.docs,
    MediaPickerFileTypes.audios
  ],
  bool allowMultiple = false,
  List<String> prevPickedFiles = const [],
  int maximumUploadSizeInMB = 100,
  bool getBackAllFiles = false,
}) async {
  final ImagePicker _picker = ImagePicker();
  List<String> _allowedExtention = [];

  if (allowFileTypes.contains(MediaPickerFileTypes.images)) {
    _allowedExtention = [..._allowedExtention, ...allowedImagedFormat];
  }
  if (allowFileTypes.contains(MediaPickerFileTypes.videos)) {
    _allowedExtention = [..._allowedExtention, ...videoTypes];
  }
  if (allowFileTypes.contains(MediaPickerFileTypes.audios)) {
    _allowedExtention = [..._allowedExtention, ...audioTypes];
  }
  if (allowFileTypes.contains(MediaPickerFileTypes.docs)) {
    _allowedExtention = [..._allowedExtention, ...docTypes];
  }

  checkValidFileSize({
    required List<String?> pickedFilePaths,
    required List<String> prevPickedFiles,
    required int maximumUploadSizeInMB,
    required bool getBackAllFiles,
  }) async {
    List<String?> pickerFilePaths = [...pickedFilePaths, ...prevPickedFiles];
    double pickedFilesSizeInBytes = 0;
    for (var filePath in pickerFilePaths) {
      int sizeInBytes = await File(filePath ?? "").length(); // get the lenth of the file
      pickedFilesSizeInBytes = pickedFilesSizeInBytes + sizeInBytes;
    }
    double totalFileSizedInMb = ((pickedFilesSizeInBytes) / 1000 / 1000); // convert bytes to MB

    if (totalFileSizedInMb <= maximumUploadSizeInMB) {
      if (getBackAllFiles == true) {
        return pickerFilePaths;
      } else {
        return pickedFilePaths;
      }
    } else if (getBackAllFiles == true) {
      Fluttertoast.showToast(
        msg: 'Maximum total files upload size - ${maximumUploadSizeInMB}MB',
        toastLength: Toast.LENGTH_LONG,
      );
      return prevPickedFiles;
    } else {
      Fluttertoast.showToast(
        msg: 'Maximum total files upload size - ${maximumUploadSizeInMB}MB',
        toastLength: Toast.LENGTH_LONG,
      );
      return [];
    }
  }

  Future<void> handleImageUpload(ImageSource imageOption) async {
    if (imageOption == ImageSource.camera) {
      XFile? file = await _picker.pickImage(
        source: ImageSource.camera,
      );
      checkValidFileSize(
        pickedFilePaths: [file!.path],
        prevPickedFiles: prevPickedFiles,
        maximumUploadSizeInMB: maximumUploadSizeInMB,
        getBackAllFiles: getBackAllFiles,
      ).then((value) => {callBack(value.map<String>((e) => e!).toList())});
    } else {
      XFile? file = await _picker.pickImage(source: ImageSource.gallery);
      checkValidFileSize(
        pickedFilePaths: [file!.path],
        prevPickedFiles: prevPickedFiles,
        maximumUploadSizeInMB: maximumUploadSizeInMB,
        getBackAllFiles: getBackAllFiles,
      ).then((value) => {callBack(value.map<String>((e) => e!).toList())});
    }
  }

  Future<void>? handleFilesUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      type: FileType.custom,
      dialogTitle: 'Choose Files',
      allowedExtensions: _allowedExtention,
    );

    checkValidFileSize(
      pickedFilePaths: result?.paths ?? [],
      prevPickedFiles: prevPickedFiles,
      maximumUploadSizeInMB: maximumUploadSizeInMB,
      getBackAllFiles: getBackAllFiles,
    ).then((value) => {callBack(value.map<String>((e) => e!).toList())});
  }

  if (allowFileTypes.length == 1 && allowFileTypes.contains(MediaPickerFileTypes.docs)) {
    handleFilesUpload();
  } else {
    showModalBottomSheet<File>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          child: Container(
            margin: EdgeInsets.only(bottom: 20.h),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        InkWell(
                            child: ClipOval(
                              child: Container(
                                color: colorSkyLight,
                                width: 88.w,
                                height: 88.w,
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      imageAssets + 'gallery_icon.svg',
                                      width: 40.w,
                                      height: 40.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () async {
                              await handleImageUpload(
                                ImageSource.gallery,
                              );
                              Navigator.of(context).pop();
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Gallery',
                          style: textTitle14RegularStyle.merge(const TextStyle(color: colorWebPanelDarkText)),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                            child: ClipOval(
                              child: Container(
                                color: colorSkyLight,
                                width: 88.w,
                                height: 88.w,
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      imageAssets + 'folder_icon.svg',
                                      width: 40.w,
                                      height: 40.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () async {
                              await handleFilesUpload();
                              Navigator.of(context).pop();
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'File Manager',
                          style: textTitle14RegularStyle.merge(const TextStyle(color: colorWebPanelDarkText)),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                            child: ClipOval(
                              child: Container(
                                color: colorSkyLight,
                                width: 88.w,
                                height: 88.w,
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      imageAssets + 'camera_icon.svg',
                                      width: 40.w,
                                      height: 40.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () async {
                              await handleImageUpload(
                                ImageSource.camera,
                              );
                              Navigator.of(context).pop();
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Camera',
                          style: textTitle14RegularStyle.merge(const TextStyle(color: colorWebPanelDarkText)),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
