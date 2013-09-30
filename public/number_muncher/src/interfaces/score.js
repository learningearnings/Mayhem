Score = BaseEntity.extend({
    initialize: function(){
    	var model = this;
    	var entity = Crafty.e("2D, DOM, Text");
      this.set('value', 0);

    	entity
            .attr({x: 10, y: 490, z: 1000, w: 400})
            .text(model.getText())
            .textColor('#ffffff')
            .textFont({'size' : '12px', 'family': 'Arial'})
            .setName('Score')
            .bind('Click', function(){
                                
            });

    	model.set({'entity' : entity });
    },
    increment: function(/*integer*/ amount) {
      amount = amount || 1;
      this.set('value', this.get('value') + amount);
      this.getEntity().text(this.getText());
    },
    getText: function () {
      return 'Score: ' + this.get('value');
    }
});
