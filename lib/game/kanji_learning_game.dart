import 'dart:math';

import 'package:app/game/particle.dart';
import 'package:app/models/vocab.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:kana_kit/kana_kit.dart';
import 'package:flame/input.dart';
import 'package:flame/timer.dart';
import 'package:flutter/material.dart';

import 'kanji_learning_game.dart';

import '../input/flick_component.dart';
import 'common.dart';
import 'word.dart';

enum GameState { menu, play, gameover }

class KanjiLearningGame extends FlameGame
    with
        HasDraggableComponents,
        HasCollidables,
        HasTappableComponents,
        KeyboardEvents {
  late final FlickUI flickUI;
  late final TextComponent test;
  final Vector2 viewportResolution;
  final kanakit = KanaKit();
  final inputOverlay = 'input';
  final textController = TextEditingController();
  List<Vocab> vocabulary;
  List<Word> wordStack = [];
  List<Word> wordActive = [];
  int isMarked = -1;
  Timer countdown = Timer(5);
  late GameState gameState;

  KanjiLearningGame(
      {required this.viewportResolution, required this.vocabulary});

  _shoot() {
    var input = textController.text;
    for (Word word in wordActive) {
      if (word.isMarked && word.checkReading(input)) {
        remove(word);
        add(ExplosionFX(word.position, word.size * 4));
        textController.text = "";
      }
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    textController.addListener(_onInputChange);
    gameState = GameState.menu;
    //textController.text = "Test";
    //camera.viewport = FixedResolutionViewport(viewportResolution);
    //camera.setRelativeOffset(Anchor.topLeft);
    /*flickUI = FlickUI(
      background:
          Rectangle(position: Vector2(0, 0), size: Vector2(300, 300), angle: 0)
              .toComponent(paint: Common.backgroundPaint),
      position: Vector2(size.x / 2, size.y - 200.0),
    );
    add(flickUI);*/
    _loadWords();
  }

  _onInputChange() {
    if (textController.text != kanakit.toHiragana(textController.text)) {
      var tmp = kanakit.toRomaji(textController.text);
      textController.text = kanakit.toHiragana(tmp);
      textController.selection = TextSelection.fromPosition(
          TextPosition(offset: textController.text.length));
    }
  }

  _loadWords() {
    for (Vocab vocab in vocabulary) {
      // TODO Settings
      Random random = new Random();
      double randomX = random.nextInt(400) + 50;
      wordStack.add(
          Word(Vector2(randomX, 10), Vector2(100, 100), vocab, Vector2(0, 25)));
    }
    wordActive.add(wordStack[0]);
    wordActive[0].isActive = true;
    add(wordActive[0]);
    wordStack.remove(wordActive[0]);
    countdown.start();
  }

  _addWordToGameFromWordStack() {
    var element = wordStack[0];
    wordActive.add(element);
    wordActive[wordActive.length - 1].isActive = true;
    add(wordActive[wordActive.length - 1]);
    wordStack.remove(element);
    countdown.start();
  }

  KeyEventResult _switchTarget() {
    if (isMarked == -1) {
      isMarked = 0;
      if (wordActive.length > isMarked) {
        wordActive[isMarked].isMarked = true;
        wordActive[isMarked].changeColor();
        return KeyEventResult.handled;
      }
    } else {
      wordActive[isMarked].isMarked = false;
      wordActive[isMarked].changeColor();
      isMarked += 1;
      if (isMarked < wordActive.length) {
        isMarked = 0;
      }
      wordActive[isMarked].isMarked = true;
      wordActive[isMarked].changeColor();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  update(double dt) {
    super.update(dt);
    countdown.update(dt);
    if (countdown.finished && wordStack.isNotEmpty) {
      _addWordToGameFromWordStack();
    }
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isEnter = keysPressed.contains(LogicalKeyboardKey.space);
    //final isf2 = keysPressed.contains(LogicalKeyboardKey.f2);
    final isKeyDown = event is RawKeyDownEvent;
    if (isKeyDown) {
      if (isEnter) {
        _shoot();
        return KeyEventResult.handled;
      } /*else if (isf2) {
        _switchTarget();
      }*/
      return KeyEventResult.ignored;
    }
    return KeyEventResult.ignored;
  }
}

Widget gameWidgetBuilder(BuildContext buildContext, List<Vocab> vocabulary) {
  return GameWidget<KanjiLearningGame>(
    game: KanjiLearningGame(
        viewportResolution: Vector2(540, 1140), vocabulary: vocabulary),
    overlayBuilderMap: const {'input': _inputBuilder, 'menu': _startBuilder},
    initialActiveOverlays: const ['input'],
    autofocus: false,
  );
}

Widget _inputBuilder(BuildContext buildContext, KanjiLearningGame game) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      width: 300,
      height: 100,
      child: Center(
        child: TextField(
          autocorrect: false,
          keyboardType: TextInputType.text,
          autofocus: true,
          controller: game.textController,
          decoration:
              const InputDecoration(border: OutlineInputBorder(), hintText: ''),
        ),
      ),
    ),
  );
}

Widget _startBuilder(BuildContext buildContext, KanjiLearningGame game) {
  game.pauseEngine();
  return Align(
      alignment: Alignment.topCenter,
      child: Container(
          width: 300,
          height: 100,
          child: Center(
              child: Column(children: [
            Text("Kanji Recognition"),
            Text(
                "Click on the words, then type the reading and hit space. If the reading is correct the word will explode.")
          ]))));
}
