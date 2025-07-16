import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import '../../../Core/api/api_end_points.dart';
import '../../../Core/api/api_service.dart';
import '../../../Core/api/api_state.dart';
import '../../../Core/models/user_model.dart';

import '../../../Core/Services/preferences_manager.dart';
import '../../../Core/utils/app_constants.dart';
import '../model/update_model.dart';

enum ShowImage { def, remote, local }

class ProfileProvider extends ChangeNotifier {
  bool update = false;
  ApiService apiService = ApiService();
  ApiState state = ApiState.initial;
  ShowImage showImage = ShowImage.def;
  late UserModel userModel;
  late UserModel localData;

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  final formKey = GlobalKey<FormState>();

  Future<void> getUserInfo() async {
    String userInfo = PreferencesManager.getString(AppConstants.userInfo)!;
    localData = UserModel.fromJson(jsonDecode(userInfo));
    update = false;
    state = ApiState.loading;
    notifyListeners();
    try {
      final response = await apiService.get(
        ApiEndPoints.getUserbyId(id: localData.id),
      );
      userModel = UserModel.fromJson(response.data["data"]);
      initeController();
      image = null;
      if (userModel.avatar != null) {
        showImage = ShowImage.remote;
      }
      state = ApiState.success;
    } catch (error) {
      log('error: $error');
      state = ApiState.error;
    }
    notifyListeners();
  }

  initeController() {
    firstNameController = TextEditingController(text: userModel.fName);
    lastNameController = TextEditingController(text: userModel.lName);
    emailController = TextEditingController(text: userModel.email);
    addressController = TextEditingController(text: userModel.address);
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  void setUpdateValue(bool value) {
    update = value;
    notifyListeners();
  }

  Future<void> updateUser() async {
    state = ApiState.update;
    notifyListeners();
    try {
      UpdateModel updateModel = UpdateModel(
        fName: firstNameController.text,
        lName: lastNameController.text,
        address: addressController.text,
        email: emailController.text,
        password: passwordController.text == ""
            ? null
            : passwordController.text,
      );
      await apiService.patch(
        ApiEndPoints.updateUserbyId(id: localData.id),
        body: updateModel.toJson(),
      );
      // if (image != null) {
      //   uploadImage();
      // }
      getUserInfo();
      state = ApiState.success;
    } catch (error) {
      log('error: $error');
      state = ApiState.error;
    }
    notifyListeners();
  }

  //! Image Pick
  File? image;
  final ImagePicker picker = ImagePicker();
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      showImage = ShowImage.local;
      update = true;
      notifyListeners();
    }
  }

  Future<void> uploadImage() async {
    log("Image Path ${image!.path}");
    state = ApiState.loading;
    notifyListeners();
    try {
      final mimeType = lookupMimeType(image!.path);
      final split = mimeType!.split('/');
      await apiService.patch(
        ApiEndPoints.uploadImage(id: userModel.id),
        body: {
          'avatar': await MultipartFile.fromFile(
            image!.path,
            filename: image!.path.split('/').last,
            contentType: MediaType(split[0], split[1]),
          ),
        },
        isFormData: true,
      );

      state = ApiState.success;
    } catch (error) {
      log('error: $error');
      state = ApiState.error;
    }
    notifyListeners();
  }
}
