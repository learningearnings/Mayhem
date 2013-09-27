Crafty.scene("level1", function() {
	require(
    [
      'number_muncher/src/scenes/level_base.js'
    ],
    function(LevelBase) {
      return LevelBase.levelFactory(
        {
          levelNumber: '1',
          instructions: 'Eat the even numbers',
          nextScene: 'level2',
          thisScene: 'level1',
          boxTypes: [AdditionBox],
          checker: function (val) {
            return (val % 2) === 0;
          }
        }
      );
    });
});
