import '../../domain/domain.dart';
import '../../domain/entities/game/game.dart';
import 'levels.dart';

export 'africa_continent.dart';
export 'asia_continent.dart';
export 'europe_continent.dart';
export 'north_america_continent.dart';
export 'oceania_continent.dart';
export 'south_america_continent.dart';
export 'whole_world_continent.dart';

class FactoryGameContinent {
  GameLevels create(ContinentType continent) {
    return _continents[continent]!();
  }
}

final Map<ContinentType, GameLevels Function()> _continents = {
  ContinentType.europe: () => EuropeContinent(),
  ContinentType.asia: () => AsiaContinent(),
  ContinentType.africa: () => AfricaContinent(),
  ContinentType.northAmerica: () => NorthAmericaContinent(),
  ContinentType.southAmerica: () => SouthAmericaContinent(),
  ContinentType.oceania: () => OceaniaContinent(),
};
