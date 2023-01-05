
List<MusicTrack> allMusicTracks = [
  MusicTrack('track1.mp3'),
  MusicTrack('track2.mp3'),
  MusicTrack('track3.mp3'),
  MusicTrack('track4.mp3'),
  MusicTrack('track5.mp3'),
  MusicTrack('track6.mp3'),
  MusicTrack('track7.mp3'),
  MusicTrack('track8.mp3')
];

class MusicTrack {
  MusicTrack(this.filename);

  final String filename;
}