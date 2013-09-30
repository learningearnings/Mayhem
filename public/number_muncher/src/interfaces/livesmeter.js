LivesMeter = BaseEntity.extend({
    initialize: function(){
    	var model = this;
    	var entity = Crafty.e("2D, DOM, Text");

    	entity
            .attr({x: 200, y: 490, z: 1000, w: 400})
            .text(model.getText())
            .textColor('#ffffff')
            .textFont({'size' : '12px', 'family': 'Arial'})
            .setName('Lives')
            .bind('Click', function(){
                                
            });

    	model.set({'entity' : entity });
    },
    decrement: function() {
      this.set('value', this.get('value') - 1);
      this.getEntity().text(this.getText());
    },
    getText: function () {
      return 'Lives: ' + this.get('value');
    }
});
