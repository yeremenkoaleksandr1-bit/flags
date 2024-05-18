import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/domain/entities/game/game_levels/game_levels.dart';
import 'package:flags/prefabs/levels/levels.dart';

export 'africa_continent.dart';
export 'asia_continent.dart';
export 'europe_continent.dart';
export 'north_america_continent.dart';
export 'oceania_continent.dart';
export 'south_america_continent.dart';
export 'whole_world_continent.dart';

class FactoryGameContinent {
  static final Map<ContinentType, GameLevels> continents = {
    ContinentType.europe: EuropeContinent(),
    ContinentType.asia: AsiaContinent(),
    ContinentType.africa: AfricaContinent(),
    ContinentType.northAmerica: NorthAmericaContinent(),
    ContinentType.southAmerica: SouthAmericaContinent(),
    ContinentType.oceania: OceaniaContinent(),
  };

  static final List<GameLevel> allLevels = continents.values
      .map((e) => e.levels)
      .expand((element) => element)
      .toList();

  GameLevels create(ContinentType continent) {
    return continents[continent]!.clone();
  }
}
