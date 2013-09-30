/**@
* #MultiwayStepped
* @category Input
* Used to bind keys to directions and have the entity move acordingly
* @trigger NewDirection - triggered when direction changes - { x:Number, y:Number } - New direction
* @trigger Moved - triggered on movement on either x or y axis. If the entity has moved on both axes for diagonal movement the event is triggered twice - { x:Number, y:Number } - Old position
*/
Crafty.c("MultiwayStepped", {
	_speed: 3,

	init: function () {
		this._keyDirection = {};
		this._keys = {};
		this._movement = { x: 0, y: 0 };
		this._speed = { x: 3, y: 3 };
	},

	/**@
	* #.multiwaystepped
	* @comp MultiwayStepped
	* @sign public this .multiwaystepped(Object speed, Object keyBindings )
	* @param speed - What step should be used in each direction
	* @param keyBindings - What keys should make the entity go in which direction. Direction is specified in degrees
	* Constructor to initialize the speed and keyBindings. Component will listen for key events and move the entity appropriately.
	*
	* When direction changes a NewDirection event is triggered with an object detailing the new direction: {x: x_movement, y: y_movement}
	* When entity has moved on either x- or y-axis a Moved event is triggered with an object specifying the old position {x: old_x, y: old_y}
	* @example
	* ~~~
	* this.multiwaystepped({x:3,y:2}, {UP_ARROW: -90, DOWN_ARROW: 90, RIGHT_ARROW: 0, LEFT_ARROW: 180});
	* ~~~
	*/
	multiwaystepped: function (speed, keys, options) {
		if (keys) {
			if (speed.x && speed.y) {
				this._speed.x = speed.x;
				this._speed.y = speed.y;
			} else {
				this._speed.x = speed;
				this._speed.y = speed;
			}
		}

		this._keyDirection = keys;
        if(options){
            this.maxX = options.maxX;
            this.maxY = options.maxY;
            this.minX = options.minX;
            this.minY = options.minY;
        }
		this.speed(this._speed);

		this.bind("KeyDown", function (e) {
			if (this._keys[e.key]) {
				this._movement.x = Math.round((this._movement.x + this._keys[e.key].x) * 1000) / 1000;
				this._movement.y = Math.round((this._movement.y + this._keys[e.key].y) * 1000) / 1000;
				this.trigger('NewDirection', this._movement);
			}
		})
		.bind("EnterFrame", function () {
			if (this.disableControls) return;

			if (this._movement.x !== 0) {
                var newX = this.x + this._movement.x;
                if(newX <= this.maxX && newX >= this.minX){
                    this.x = newX;
                    this.trigger('Moved', { x: newX, y: this.y });
                }
			}
			if (this._movement.y !== 0) {
                var newY = this.y + this._movement.y;
                if(newY <= this.maxY && newY >= this.minY){
                    this.y = newY;
                    this.trigger('Moved', { x: this.x, y: newY });
                }
			}
      this._movement.x = 0;
      this._movement.y = 0;
		});

		return this;
	},

	speed: function (speed) {
		for (var k in this._keyDirection) {
			var keyCode = Crafty.keys[k] || k;
			this._keys[keyCode] = {
				x: Math.round(Math.cos(this._keyDirection[k] * (Math.PI / 180)) * 1000 * speed.x) / 1000,
				y: Math.round(Math.sin(this._keyDirection[k] * (Math.PI / 180)) * 1000 * speed.y) / 1000
			};
		}
		return this;
	}
});

/**@
* #FourwayStepped
* @category Input
* Move an entity in four directions by using the
* arrow keys or `W`, `A`, `S`, `D`.
*/
Crafty.c("FourwayStepped", {

	init: function () {
		this.requires("MultiwayStepped");
	},

	/**@
	* #.fourway
	* @comp FourwayStepped
	* @sign public this .fourway(Number speed)
	* @param speed - Amount of pixels to move the entity whilst a key is down
	* Constructor to initialize the speed. Component will listen for key events and move the entity appropriately.
	* This includes `Up Arrow`, `Right Arrow`, `Down Arrow`, `Left Arrow` as well as `W`, `A`, `S`, `D`.
	*
	* When direction changes a NewDirection event is triggered with an object detailing the new direction: {x: x_movement, y: y_movement}
	* When entity has moved on either x- or y-axis a Moved event is triggered with an object specifying the old position {x: old_x, y: old_y}
	*
	* The key presses will move the entity in that direction by the speed passed in the argument.
	* @see Multiway
	*/
	fourwaystepped: function (speed) {
		this.multiwaystepped(speed, {
			UP_ARROW: -90,
			DOWN_ARROW: 90,
			RIGHT_ARROW: 0,
			LEFT_ARROW: 180,
			W: -90,
			S: 90,
			D: 0,
			A: 180
		});

		return this;
	}
});
