import '../../../game_field/core/image_loader/dto/game_field_model.dart';

abstract class HelpState {}

class Loading extends HelpState {}

class Rules extends HelpState {
  Rules(
    this.gameFieldModel,
  );

  final GameFieldModel gameFieldModel;
}