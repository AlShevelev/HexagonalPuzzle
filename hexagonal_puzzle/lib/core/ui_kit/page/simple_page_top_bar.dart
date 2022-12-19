import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../style/typography.dart';
import '../text/stroked_text.dart';

class SimplePageTopBar extends StatelessWidget {
  SimplePageTopBar({
    required String title,
    required Function onBackClick,
    Key? key,
  }) : super(key: key) {
    _title = title;
    _onBackClick = onBackClick;
  }

  late final Function _onBackClick;
  late final String _title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: GestureDetector(
            onTap: () {
              _onBackClick();
            },
            child: SvgPicture.asset(
              'assets/icons/ic_back.svg',
              width: 30,
              height: 30,
            ),
          ),
        ),
        StrokedText(
          text: _title,
          style: AppTypography.s24w400,
        ),
      ],
    );
  }
}
