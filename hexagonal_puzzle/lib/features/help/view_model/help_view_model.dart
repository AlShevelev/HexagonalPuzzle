
import 'package:flutter/material.dart';

import '../../../core/data/repositories/levels/levels_repository.dart';
import '../../../core/utils/simple_stream.dart';
import '../../../core/view_model/view_model_base.dart';
import '../../game_field/core/image_loader/dto/game_field_model.dart';
import '../../game_field/core/image_loader/images_loader.dart';
import '../core/game_field_shaker.dart';
import 'model/state.dart';

class HelpViewModel extends ViewModelBase {

  static const int _levelId = 1;

  late final LevelsRepository _levelsRepository;

  late final GameFieldModel _gameFieldModel;

  final SimpleStream<HelpState> _state = SimpleStream<HelpState>();

  Stream<HelpState> get state => _state.output;

  Future<void> init() async {
    _state.update(Loading());

    _levelsRepository = LevelsRepository();
    await _levelsRepository.init();
  }

  Future<void> onSizeCalculated(Size size, BuildContext context) async {
    final levelInfo = await _levelsRepository.getLevel(_levelId, context);

    final draftGameFieldModel = await ImageLoader().loadImages(
      levelInfo.asset,
      size,
      3,
    );

    _gameFieldModel = GameFieldShaker().shake(draftGameFieldModel);

    _state.update(Rules(_gameFieldModel));
  }

  @override
  void dispose() {
    _state.close();
  }
}
