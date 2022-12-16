import 'package:flutter/material.dart';

import '../../../../core/data/repositories/levels/levels_repository.dart';
import '../../../../core/data/repositories/levels/model/level_dto.dart';
import 'level_grid_item.dart';

class LevelGrid extends StatefulWidget {
  const LevelGrid({Key? key}) : super(key: key);

  @override
  State<LevelGrid> createState() => _LevelGridState();
}

class _LevelGridState extends State<LevelGrid> {
  late final LevelsRepository _repository;

  late final List<LevelDto> _levels;

  late final AssetImage _loadingImage;

  bool _repositorySetup = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _loadingImage = const AssetImage('assets/images/levels/small/empty.webp');

    _repository = LevelsRepository();
    await _repository.init();

    if (mounted) {
      _levels = await _repository.getAll(context);
    } else {
      _levels = List.empty();
    }

    setState(() {
      _repositorySetup = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_repositorySetup) {
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
