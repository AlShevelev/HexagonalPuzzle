import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/routing/routes.dart';
import '../../../../core/ui_kit/style/typography.dart';
import '../../../../core/ui_kit/text/stroked_text.dart';

import '../../../../core/data/repositories/levels/model/level_dto.dart';
import '../../../../core/ui_kit/style/colors.dart';

class LevelGridItem extends StatefulWidget {
  LevelGridItem({
    Key? key,
    required LevelDto level,
    required AssetImage loadingImage
  }) : super(key: key) {
    _level = level;
    _loadingImage = loadingImage;
  }

  late final LevelDto _level;
  late final AssetImage _loadingImage;

  @override
  State<LevelGridItem> createState() => _LevelGridItemState();
}

class _LevelGridItemState extends State<LevelGridItem> {
  bool isOnTap = false;

  late LevelDto _level;
  late AssetImage _loadingImage;

  @override
  void initState() {
    _level = widget._level;
    _loadingImage = widget._loadingImage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) {
            setState(() {
              isOnTap = true;
            });
          },
          onTapUp: (_) {
            setState(() {
              isOnTap = true;
            });

            Future.delayed(const Duration(milliseconds: 100), () async {
              setState(() {
                isOnTap = false;
              });

              final completed = await Navigator.of(context).pushNamed(Routes.gameFieldPage, arguments: _level.id);

              if (!mounted) return;

              if(completed == true) {
                setState(() {
                  _level = _level.markAsCompleted();
                });
              }
            });
          },
          onTapCancel: () {
            setState(() {
              isOnTap = false;
            });
          },
          child: Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: <Widget>[
              Container(
                color: AppColors.white,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: AppColors.brown),
                    ),
                    child: Opacity(
                      opacity: isOnTap ? 0.5 : 1.0,
                      child: Stack(children: <Widget>[
                        Image(image: _loadingImage),
                        Image.asset(_level.asset),
                      ]),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _level.isCompleted
                    ? SvgPicture.asset(
                        'assets/icons/ic_check.svg',
                        width: 30,
                        height: 30,
                      )
                    : const SizedBox.shrink(),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: StrokedText(
            text: _level.nameLocalizationCode.tr(),
            style: AppTypography.s16w400,
          ),
        )
      ],
    );
  }
}
