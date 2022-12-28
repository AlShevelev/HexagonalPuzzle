import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/data/repositories/levels/levels_repository.dart';
import '../../../../core/data/repositories/levels/model/level_dto.dart';
import 'level_grid_item.dart';

class LevelGrid extends StatefulWidget {
  const LevelGrid({Key? key}) : super(key: key);

  @override
  State<LevelGrid> createState() => _LevelGridState();
}

class _LevelGridState extends State<LevelGrid> {
  late List<LevelDto> _levels;

  late final AssetImage _loadingImage;

  @override
  void initState() {
    super.initState();

    _loadingImage = const AssetImage('assets/images/levels/small/empty.webp');
    _levels = List.empty();
  }

  @override
  Widget build(BuildContext context) {
    if(_levels.isEmpty) {
      final repository = context.read<LevelsRepository>();
      Future.delayed(const Duration(milliseconds: 0), () async {
        _levels = await repository.getAll(context);

        setState(() { });
      });
    }

    if (_levels.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return GridView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 16
        ),
        itemCount: _levels.length,
        itemBuilder: (BuildContext context, int index) {
          return LevelGridItem(
            level: _levels[index],
            loadingImage: _loadingImage,
          );
        },
      );
    }
  }
}
