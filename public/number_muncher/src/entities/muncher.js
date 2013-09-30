Muncher = BaseEntity.extend({
	defaults: {
        'steps' : { x: 60, y: 62 }
    },
    initialize: function(){
    	var model = this;
    	var entity = Crafty.e("2D, "+gameContainer.conf.get('renderType')+", MultiwayStepped, Keyboard, muncher, SpriteAnimation, Collision");

      Crafty.audio.add("bloop", "number_muncher/web/sounds/bloop.wav");
      Crafty.audio.add("walk", "number_muncher/web/sounds/walk.wav");
      Crafty.audio.add("wrong", "number_muncher/web/sounds/wrong.wav");

    	entity
            .attr({x: this.get('x'), y: this.get('y'), z: 300})
            .collision(new Crafty.polygon(
                [0,  0],
                [0,  60],
                [62, 60],
                [62, 0]
            ))
            .multiwaystepped(model.get('steps'), {
              UP_ARROW: -90,
              DOWN_ARROW: 90,
              RIGHT_ARROW: 0,
              LEFT_ARROW: 180,
              K: -90,
              J: 90,
              L: 0,
              H: 180
            }, {
              maxX: this.get('maxX'),
              maxY: this.get('maxY'),
              minX: this.get('minX'),
              minY: this.get('minY')
            })
            .bind('EnterFrame', function(e){
            })
            .bind('Moved', function(e) {
                Crafty.audio.play('walk');
            })
            .bind('KeyUp', function(e){
              // If the space key was pressed, then we chomped.
              if(e.key == Crafty.keys.SPACE){
                var values = entity.hit('valuebox');
                _.each(values, function (value) {
                  console.log(value);
                  if(sc.checker(value.obj.model.getValue())){
                    Crafty.audio.play('bloop');
                    infc.score.increment(1);
                    sc.valueboxes.good = _.without(sc.valueboxes.good, value.obj.model);
                  }else{
                    Crafty.audio.play('wrong');
                    infc.lives.decrement();
                    sc.valueboxes.bad = _.without(sc.valueboxes.bad, value.obj.model);
                  };
                  value.obj.destroy();
                });
                return false;
              }
            })
            .setName('Muncher');

      entity.origin(entity.w/2, entity.h/2);

    	model.set({'entity' : entity });
    }
});
