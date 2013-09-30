Crafty.scene("end", function() {
	require(
    [
      'number_muncher/src/scenes/level_base.js'
    ],
    function(LevelBase) {
      return LevelBase.levelFactory(
        {
          end: true,
          win_message: 'VICTORY!'
        }
      );
    });
});

