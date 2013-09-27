InstructionMeter = BaseEntity.extend({
    initialize: function(){
    	var model = this;
    	var entity = Crafty.e("2D, DOM, Text");

    	entity
            .attr({x: 160, y: 10, z: 1000, w: 400})
            .text(model.get('text'))
            .textColor('#ffffff')
            .textFont({'size' : '12px', 'family': 'Arial'})
            .setName('Instructions')
            .bind('Click', function(){
                                
            });

    	model.set({'entity' : entity });
    }
});
