define(
	[
        "number_muncher/src/entities/muncher.js",
        "number_muncher/src/entities/valuebox.js",
        "number_muncher/src/entities/additionbox.js",
        "number_muncher/src/entities/subtractionbox.js",
        "number_muncher/src/entities/multiplicationbox.js",
        "number_muncher/src/interfaces/levelmeter.js",
        "number_muncher/src/interfaces/endscreen.js",
        "number_muncher/src/interfaces/instruction_meter.js",
        "number_muncher/src/interfaces/score.js",
        "number_muncher/src/interfaces/livesmeter.js"
	],
  function () {
    return {
      levelFactory: function (options) {
        // clear scene and interface
        if(!options.end){
            sc = []; infc = [];   
            Crafty.background('#333333');

            // Start grid at 20, 50
            var gridOriginX = 20;
            var gridOriginY = 50;

            var cellWidth = 60;
            var cellHeight = 62;

            var numCols = 5;
            var numRows = 6;

            // Set max x and y for movement
            var maxX = gridOriginX + ((numCols - 1) * cellWidth);
            var maxY = gridOriginY + ((numRows - 1) * cellHeight);

            sc.complete = false;

            sc.checker = options.checker;
            sc.lives = 3;

            sc.valueboxes = { good: [], bad: [] };
            sc.muncher = new Muncher({
              x: gridOriginX,
              y: gridOriginY,
              maxX: maxX,
              maxY: maxY,
              minX: gridOriginX,
              minY: gridOriginY
            });
            sc.nextScene = options.nextScene;
            sc.thisScene = options.thisScene;
            infc.level = new LevelMeter({ text: 'Level: ' + options.levelNumber });
            infc.instructions = new InstructionMeter({ text: options.instructions });
            infc.score = new Score();
            infc.lives = new LivesMeter({ value: 3 });

            // Add each of the value boxes in a grid
            // grid is 60x62 like everything else
            var gridX = gridOriginX;
            var gridY = gridOriginY;
            // Add a grid of AdditionBoxes
            _.times(numRows, function () {
              gridX = gridOriginX;
              _.times(numCols, function () {
                // Generate two random numbers between 0 and 10
                var a = Math.floor(Math.random()*11);
                var b = Math.floor(Math.random()*11);
                // Get a random valid boxtype
                var boxType = _.shuffle(options.boxTypes)[0];
                var valuebox = new boxType({ x: gridX, y: gridY, a: a, b: b });
                if(sc.checker(valuebox.getValue())){
                  sc.valueboxes.good.push(valuebox);
                } else {
                  sc.valueboxes.bad.push(valuebox);
                }
                gridX = gridX + cellWidth;
              });
              gridY = gridY + cellHeight;
            });

            // Each frame, check to see if any valueboxes are left that are correct.
            Crafty.e().bind("EnterFrame", function(e) {
              if(sc.complete){ return true; } // Don't check anymore if the level's been won
              if(sc.valueboxes.good.length === 0){
                sc.complete = true;
                alert('you win guy');
                Crafty.e().unbind("EnterFrame");
                Crafty.scene(sc.nextScene);
              }
              if(infc.lives.get('value') === 0){
                sc.complete = true;
                alert('you lost...');
                Crafty.scene(sc.thisScene);
              }
            });
      }else{
        sc = []; infc = [];   
        Crafty.background('#333333');
        infc.level = new EndScreen({ text: options.win_message });

      }
    }
  }
});
