class LevelDto {
  LevelDto({
    required this.id,
    required this.nameLocalizationCode,
    required this.asset,
    required this.isCompleted,
  });

  final int id;
  final String nameLocalizationCode;
  final String asset;
  final bool isCompleted;

  LevelDto markAsCompleted() {
    return LevelDto(
      id: id,
      nameLocalizationCode: nameLocalizationCode,
      asset: asset,
      isCompleted: true,
    );
  }
}
