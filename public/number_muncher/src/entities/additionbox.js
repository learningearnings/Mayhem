require(["number_muncher/src/entities/valuebox.js"], function () {
  AdditionBox = ValueBox.extend({
    getText: function () {
      return this.get('a') + ' + ' + this.get('b');
    },
    getValue: function () {
      return this.get('a') + this.get('b');
    }
  });
});
