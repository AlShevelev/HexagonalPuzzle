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

    String allLevelsDataRaw = await DefaultAssetBundle.of(context).loadString("assets/levels_description.json");
    final List<dynamic> allLevelsData = jsonDecode(allLevelsDataRaw);

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

  /// Returns id of all completed levels
  List<int> _getAllCompleted() {
    final completedRaw = _storage.getString(_completedKey);

    if (completedRaw == null) {
      return List.empty();
    }

    return completedRaw.split(';').map((e) => int.parse(e)).toList();
  }
}
