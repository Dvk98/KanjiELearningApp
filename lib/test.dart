import 'package:app/game/kanji_learning_game.dart';
import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';

import 'game/kanji_learning_game.dart';

void addGame(Dashbook dashbook) {
  dashbook
      .storiesOf('Game')
      .add('KanjiLearningTest', (_) => GameWidget(game: KanjiLearningGame()));
}
