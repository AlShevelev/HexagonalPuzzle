import 'package:flutter/material.dart';

import '../../../../core/data/repositories/levels/levels_repository.dart';
import '../../../../core/data/repositories/levels/model/level_dto.dart';
import 'level_grid_item.dart';

class LevelGrid extends StatefulWidget {
  LevelGrid({
    required Function(int) onItemClick,
    Key? key,
  }) : super(key: key) {
    _onItemClick = onItemClick;
  }

  /// The passed parameter is level's id
  late final Function(int) _onItemClick;

  @override
  State<LevelGrid> createState() => _LevelGridState();
}

class _LevelGridState extends State<LevelGrid> {
  late final LevelsRepository _repository;
  late final List<LevelDto> _levels;

  bool _repositorySetup = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
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
          crossAxisSpacing: 8
        ),
        itemCount: _levels.length,
        itemBuilder: (BuildContext context, int index) {
          return LevelGridItem(
            level: _levels[index],
          );
        },
      );
    }
  }
}
