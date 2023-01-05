
List<String> soundTypeToFilename(SoundType type) {
  switch (type) {
    case SoundType.success:
      return const [
        'success1.mp3'
      ];
    case SoundType.win:
      return const [
        'win1.mp3',
        'win2.mp3',
      ];
  }
}

enum SoundType {
  success,
  win
}
