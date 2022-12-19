import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hexagonal_puzzle/features/settings/view_model/settings_veiw_model.dart';

import '../../../core/ui_kit/page/page_background.dart';
import '../../../core/ui_kit/style/typography.dart';
import '../../../core/ui_kit/text/stroked_text.dart';
import '../../../core/ui_kit/page/simple_page_top_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsViewModel _viewModel;

  bool _viewModelSetup = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _viewModel = SettingsViewModel();
    await _viewModel.loadSettings();

    setState(() {
      _viewModelSetup = true;
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = AppTypography.s18w400;
    const textPadding = 12.0;

    return PageBackground(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SimplePageTopBar(
              title: tr('settings_title'),
              onBackClick: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(
              child: _viewModelSetup
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StreamBuilder<bool>(
                          stream: _viewModel.musicOn,
                          builder: (context, value) {
                            return GestureDetector(
                              onTap: () {
                                _viewModel.setMusicOn(!value.data!);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: textPadding, bottom: textPadding),
                                child: StrokedText(
                                  text: _getMusicOnText(value.data ?? false),
                                  style: textStyle,
                                ),
                              ),
                            );
                          },
                        ),
                        StreamBuilder<bool>(
                          stream: _viewModel.soundOn,
                          builder: (context, value) {
                            return GestureDetector(
                              onTap: () {
                                _viewModel.setSoundOn(!value.data!);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: textPadding, bottom: textPadding),
                                child: StrokedText(
                                  text: _getSoundOnText(value.data ?? false),
                                  style: textStyle,
                                ),
                              ),
                            );
                          },
                        ),
                        StreamBuilder<int>(
                          stream: _viewModel.numberOfPieces,
                          builder: (context, value) {
                            return GestureDetector(
                              onTap: () {
                                _viewModel.setNumberOfPieces(value.data! + 1);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: textPadding, bottom: textPadding),
                                child: StrokedText(
                                  text: _getNumberOfPiecesText(value.data ?? 0),
                                  style: textStyle,
                                ),
                              ),
                            );
                          },
                        ),
                        StreamBuilder<int>(
                          stream: _viewModel.numberOfPermutations,
                          builder: (context, value) {
                            return GestureDetector(
                              onTap: () {
                                _viewModel.setNumberOfPermutations(value.data! + 1);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: textPadding, bottom: textPadding),
                                child: StrokedText(
                                  text: _getNumberOfPermutationsText(value.data ?? 0),
                                  style: textStyle,
                                ),
                              ),
                            );
                          },
                        ),
                        StreamBuilder<bool>(
                          stream: _viewModel.piecesTurningOn,
                          builder: (context, value) {
                            return GestureDetector(
                              onTap: () {
                                _viewModel.setPiecesTurningOn(!value.data!);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: textPadding, bottom: textPadding),
                                child: StrokedText(
                                  text: _getPiecesTurningOnText(value.data ?? false),
                                  style: textStyle,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            )
          ],
        ),
      ),
    );
  }

  String _getMusicOnText(bool value) {
    if (value) {
      return tr('settings_music_on');
    } else {
      return tr('settings_music_off');
    }
  }

  String _getSoundOnText(bool value) {
    if (value) {
      return tr('settings_sound_effects_on');
    } else {
      return tr('settings_sound_effects_off');
    }
  }

  String _getNumberOfPiecesText(int value) {
    final prefix = tr('settings_number_of_pieces');

    final String suffix;

    if (value == 0) {
      suffix = tr('settings_number_of_pieces_few');
    } else if (value == 1) {
      suffix = tr('settings_number_of_pieces_several');
    } else if (value == 2) {
      suffix = tr('settings_number_of_pieces_many');
    } else {
      suffix = '';
    }

    return '$prefix: $suffix';
  }

  String _getNumberOfPermutationsText(int value) {
    final prefix = tr('settings_number_of_permutations');

    final String suffix;

    if (value == 0) {
      suffix = tr('settings_number_of_permutations_easy');
    } else if (value == 1) {
      suffix = tr('settings_number_of_permutations_quite_easy');
    } else if (value == 2) {
      suffix = tr('settings_number_of_permutations_medium difficulty');
    } else if (value == 3) {
      suffix = tr('settings_number_of_permutations_not_so_hard');
    } else if (value == 4) {
      suffix = tr('settings_number_of_permutations_hard');
    } else {
      suffix = '';
    }

    return '$prefix: $suffix';
  }

  String _getPiecesTurningOnText(bool value) {
    if (value) {
      return tr('settings_pieces_turning_on');
    } else {
      return tr('settings_pieces_turning_off');
    }
  }
}
