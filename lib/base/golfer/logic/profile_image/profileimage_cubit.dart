import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:shot_locker/utility/show_snak_bar.dart';
part 'profileimage_state.dart';

class ProfileimageCubit extends Cubit<ProfileimageState> {
  ProfileimageCubit() : super(ProfileimageInitial());

  Future<void> pickProfileimage(BuildContext context) async {
    FilePickerResult? _pickedImageFile =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (_pickedImageFile == null) {
      ShowSnackBar.showSnackBar(context, 'No image selected.');
      return;
    } else {
      final _compressedFile = await FlutterNativeImage.compressImage(
        _pickedImageFile.files.first.path!,
        quality: 30,
      );
      final _pickedImage = _compressedFile;
      emit(UserProfileImagePicked(pickedImage: _pickedImage));
    }
    return;
  }

  Future<void> clearPickedImage() async {
    emit(ProfileimageInitial());
    return;
  }
}
