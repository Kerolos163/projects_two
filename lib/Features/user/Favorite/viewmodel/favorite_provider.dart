import 'package:flutter/material.dart';
import 'package:projects_two/Core/api/api_service.dart';
import 'package:projects_two/Core/api/api_state.dart';

class FavoriteProvider extends ChangeNotifier {
  ApiService apiService = ApiService();
  ApiState state = ApiState.initial;
}
