require(["number_muncher/src/entities/valuebox.js"], function () {
  MultiplicationBox = ValueBox.extend({
    getText: function () {
      return this.get('a') + ' x ' + this.get('b');
    },
    getValue: function () {
      return this.get('a') * this.get('b');
    }
  });
});
