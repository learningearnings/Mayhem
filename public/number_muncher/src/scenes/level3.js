Crafty.scene("level3", function() {
	require(
    [
      'number_muncher/src/scenes/level_base.js'
    ],
    function(LevelBase) {
      return LevelBase.levelFactory(
        {
          levelNumber: '3',
          instructions: 'Eat the numbers greater than 5',
          nextScene: 'level4',
          thisScene: 'level3',
          boxTypes: [AdditionBox, SubtractionBox],
          checker: function (val) {
            return val > 5;
          }
        }
      );
    });
});
