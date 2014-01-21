Crafty.scene("level4", function() {
	require(
    [
      'number_muncher/src/scenes/level_base.js'
    ],
    function(LevelBase) {
      return LevelBase.levelFactory(
        {
          levelNumber: '4',
          instructions: 'Eat the even numbers',
          nextScene: 'end',
          thisScene: 'level4',
          boxTypes: [MultiplicationBox],
          checker: function (val) {
            return (val % 2) === 0;
          }
        }
      );
    });
});
