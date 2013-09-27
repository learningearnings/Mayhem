EndScreen = BaseEntity.extend({
    initialize: function(){
    	var model = this;
    	var entity = Crafty.e("2D, DOM, Text");

    	entity
            .attr({x: 350, y: 200})
            .text(model.get('text'))
            .textColor('#ffffff')
            .textFont({'size' : '12px', 'family': 'Arial'})
            .setName('Victory!')
            .bind('Click', function(){
                                
            });
    	model.set({'entity' : entity });
        Crafty.e("HTML")
          .attr({x: 340, y: 300, w:100, h:100})
          //.attr({x: 340, y: 300, w:100, h:100})
          .append("<a style='color: #ffffff;' href='file:///home/robby/railapp/Mayhem/index.html'>Play Again?</a>");


    }
});

