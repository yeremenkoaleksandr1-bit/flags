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
  cancelObjectPlacing("return_object.wav");

  const GameSfx(String file) : file = 'sfx/$file';

  final String file;
}

enum GameMusics {
  main("main_menu.mp3"),
  continents("continents_loop.mp3"),
  fastMode("fastmode.mp3");

  const GameMusics(String file) : file = 'music/$file';

  final String file;
}
