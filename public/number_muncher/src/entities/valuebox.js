ValueBox = BaseEntity.extend({
	defaults: {
    },
    initialize: function(){
    	var model = this;
    	var entity = Crafty.e("2D, "+gameContainer.conf.get('renderType')+", Collision, Text, valuebox");

    	entity
            .attr({
              x: model.get('x'),
              y: model.get('y'),
              w: 60,
              h: 62,
              z: 400,
              model: model,
            })
            .text("<div class='valuebox'>" + this.getText() + "</div>")
            .textColor('#ffffff')
            .collision(new Crafty.polygon(
                [0,  0],
                [0,  60],
                [62, 60],
                [62, 0]
            ));

    	model.set({'entity' : entity });
    },
    getText: function () {
      return 'placeholder'
    }
});
