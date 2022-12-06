import 'dart:convert';

import 'package:flutter/material.dart';

import '../../storages/key_value_storage.dart';
import 'model/level_dto.dart';

class LevelsRepository {
  static const String _completedKey = "COMPLETED_KEY";

  late final KeyValueStorage _storage;

  Future<void> init() async {
    _storage = KeyValueStorage();
    await _storage.init();
  }

  Future<List<LevelDto>> getAll(BuildContext context) async {
    final allCompleted = _getAllCompleted();

    final List<dynamic> allLevelsData = await _getAllLevelsRaw(context);

    return allLevelsData.map((e) {
      final id = e['id'];

      return LevelDto(
        id: id,
        nameLocalizationCode: e['name_loc_code'],
        asset: 'assets/images/levels/small/${e['image_name']}',
        isCompleted: allCompleted.contains(id),
      );
    }).toList();
  }

  void markAsCompleted(int id) async {
    final allCompleted = _getAllCompleted();

    if(allCompleted.contains(id)) {
      return;
    }

    allCompleted.add(id);

    _storage.setString(_completedKey, allCompleted.join(';'));
  }

  Future<LevelDto> getLevel(int id, BuildContext context) async {
    final List<dynamic> allLevelsData = await _getAllLevelsRaw(context);

    final rowItem = allLevelsData.singleWhere((element) => element['id'] == id);

    return LevelDto(
      id: id,
      nameLocalizationCode: rowItem['name_loc_code'],
      asset: 'assets/images/levels/large/${rowItem['image_name']}',
      isCompleted: false
    );
  }

  /// Returns id of all completed levels
  List<int> _getAllCompleted() {
    final completedRaw = _storage.getString(_completedKey);

    if (completedRaw == null) {
      return List.empty();
    }

    return completedRaw.split(';').map((e) => int.parse(e)).toList();
  }

  Future<List<dynamic>> _getAllLevelsRaw(BuildContext context) async {
    String allLevelsDataRaw = await DefaultAssetBundle.of(context).loadString("assets/levels_description.json");
    return jsonDecode(allLevelsDataRaw);
  }
}
