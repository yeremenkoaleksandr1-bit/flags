import 'package:flags/domain/enums/game_mode_type.dart';
import 'package:flags/features/app/domain/models/game/game_mode_data.dart';
import 'package:flags/prefabs/levels/levels.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Игры на флагах открываются, когда флаг собран в обычном режиме пазлов
/// (режим «на скорость» не считается).
abstract final class FlagGameUnlocks {
  static const String _unlockedKey = 'flag_games_unlocked';

  /// ВРЕМЕННО для тестов: все игры открыты. Сохранённые открытия и покупки
  /// не трогаются — false вернёт всё как было.
  static const bool unlockAllForTesting = true;

  /// Флаги пазлов (GameFlag.name), у которых есть своя игра.
  /// Косово в пазлах нет — его игра покупается за монеты ([prices]).
  static const Set<String> gameFlags = {
    'Zambia',
    'Tanzania',
    'Angola',
    'Japan',
    'Cambodia',
    'Israel',
    'Kiribati',
  };

  /// Игры, которые открываются покупкой, а не пазлами: ключ → цена в монетах.
  static const Map<String, int> prices = {'Kosovo': 500};

  static const String _revealedKey = 'flag_games_revealed';

  /// Игры, анимация открытия которых уже показана в списке.
  static Future<Set<String>> loadRevealed() async {
    final prefs = await SharedPreferences.getInstance();
    return {...?prefs.getStringList(_revealedKey)};
  }

  /// Анимация открытия показана — больше не повторять.
  static Future<void> markRevealed(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final revealed = {...?prefs.getStringList(_revealedKey), key};
    await prefs.setStringList(_revealedKey, revealed.toList());
  }

  /// Открыть купленную игру.
  static Future<void> unlockPurchased(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final unlocked = {...?prefs.getStringList(_unlockedKey), key};
    await prefs.setStringList(_unlockedKey, unlocked.toList());
  }

  /// Открытые игры: сохранённые открытия + флаги, уже пройденные в пазлах
  /// (чтобы у игроков со старым прогрессом игры открылись сразу).
  static Future<Set<String>> load() async {
    if (unlockAllForTesting) return {...gameFlags, ...prices.keys};
    final prefs = await SharedPreferences.getInstance();
    final unlocked = {...?prefs.getStringList(_unlockedKey)};

    final progress = GameModeProgressData.load(GameProcessType.puzzle, prefs);
    if (progress != null) {
      FactoryGameContinent.continents.forEach((continent, data) {
        final done = progress.data[continent];
        if (done == null) return;
        for (final level in data.levels) {
          final name = level.flag.name;
          if (gameFlags.contains(name) &&
              (done['${level.id}']?.completed ?? false)) {
            unlocked.add(name);
          }
        }
      });
    }
    return unlocked;
  }

  /// Флаг собран в пазлах. true — если этим открылась новая игра.
  static Future<bool> onPuzzleCompleted(String flagName) async {
    if (!gameFlags.contains(flagName)) return false;
    final prefs = await SharedPreferences.getInstance();
    final unlocked = {...?prefs.getStringList(_unlockedKey)};
    if (!unlocked.add(flagName)) return false;
    await prefs.setStringList(_unlockedKey, unlocked.toList());
    return true;
  }
}
