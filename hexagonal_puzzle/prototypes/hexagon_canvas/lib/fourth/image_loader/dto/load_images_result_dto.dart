import '../../calculators/dto/game_field_points_dto.dart';
import 'loaded_images_dto.dart';

class LoadImagesResultDto {
  LoadImagesResultDto({required this.images, required this.points});

  final LoadedImagesDto images;

  final GameFieldPointsDto points;
}

