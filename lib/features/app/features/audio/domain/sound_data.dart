import 'package:flags/domain/enums/continent_type.dart';

enum GameSfx {
  button("button_tap.wav"),
  timerTick1("timer_tick_1.wav"),
  timerTick2("timer_tick_2.wav"),
  timerEnd("timer_end.wav"),
  success("success.wav"),
  changePage("change_page.wav"),
  gameWin("success.wav"),
  gameLoose("game_loose.wav"),
  sectionCompleted("section_completed.mp3"),
  correctlyObjectPlacing("object_placing_correct.wav"),
  incorrectObjectPlacing("object_bad_placing.wav"),
  cancelObjectPlacing("return_object.wav"),
  knifeThrow1("knife_throw1.wav"),
  knifeThrow2("knife_throw2.wav"),
  gearCrash("gear_crash.wav"),
  gearSpin("gear_spin.wav"),
  knifeLose("knife_lose.wav"),
  birdFly("bird_fly.wav"),
  birdFly2("bird_fly2.wav"),
  birdFly3("bird_fly3.wav"),
  birdHurt("bird_hurt.wav"),
  carCrash("car_crash.wav"),
  carBrake("car_brake.wav"),
  carHorn("car_horn.wav"),
  carHorn2("car_horn2.wav"),
  money("money.wav"),
  moneyShort("money_short.wav"),
  fallHit1("fall_hit1.wav"),
  fallHit2("fall_hit2.wav"),
  fallHit3("fall_hit3.wav"),
  chain1("chain1.wav"),
  chain2("chain2.wav"),
  chainGear("chain_gear.wav"),
  flash("flash.wav"),
  wind("wind.wav"),
  seaSound("sea_sound.mp3"),
  shot1("shot1.wav"),
  shot2("shot2.wav"),
  noAmmo("no_ammo.wav"),
  reloadAmmo("reload_ammo.wav"),
  reload("reload.wav"),
  waterSplash("water_splash.wav"),
  waterSplash2("water_splash2.wav"),
  kosovoSea("kosovo_sea.mp3"),
  canonSpin("canon_spin.wav"),
  canonShoot("canon_shoot.wav"),
  canonReload("canon_reload.wav"),
  boatExplode("boat_expload.wav"),
  boatExplode2("boat_expload2.wav"),
  boatExplode3("boat_expload3.wav"),
  japanHit1("japan_hit1.wav"),
  japanHit2("japan_hit2.wav"),
  japanIntro("japan_intro.wav"),
  israelJump("israel_jump.wav"),
  israelFall("israel_fall.wav"),
  israelCrash("israel_crash.wav");

  const GameSfx(String file) : file = 'sfx/$file';

  final String file;
}

enum GameMusics {
  main("main_menu.mp3"),
  continents("continents_loop.mp3"),
  fastMode("fastmode.mp3"),
  tanzania("tanzania_music.mp3"),
  zambia1("zambia_music1.mp3"),
  zambia2("zambia_music2.mp3"),
  kosovo("kosovo_music.mp3"),
  cambodia1("cambodia_music1.mp3"),
  cambodia2("cambodia_music2.mp3"),
  israel("israel_music.mp3"),
  angola("angola_music.mp3"),
  kiribati("kiribati_music.mp3"),
  japan("japan_music.mp3"),
  flagGamesMenu("flag_games_menu_music.mp3"),
  african("african_music.mp3"),
  american("american_music.mp3"),
  asian("asian_music.mp3"),
  latina("latina_music.mp3"),
  european("european_music.mp3"),
  oceania("oceania_music.mp3");

  const GameMusics(String file) : file = 'music/$file';

  final String file;
}

/// Музыка пазлов внутри континента.
GameMusics continentMusic(ContinentType type) => switch (type) {
  ContinentType.africa => GameMusics.african,
  ContinentType.asia => GameMusics.asian,
  ContinentType.northAmerica => GameMusics.american,
  ContinentType.southAmerica => GameMusics.latina,
  ContinentType.europe => GameMusics.european,
  ContinentType.oceania => GameMusics.oceania,
};
