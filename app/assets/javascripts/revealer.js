function Revealer() {
  var OVERLAY_ZINDEX = 10;
  var OVERLAY_BACKGROUND = 'rgba(0,0,0,0.5)';

  var $overlay, $prevTarget, $currTarget;

  function overlay() {
    if ($overlay) {
      return $overlay;
    }
    $overlay = $('<div>');
    var $prevTarget, $currTarget;
    $overlay.css({
      zIndex:     OVERLAY_ZINDEX,
      background: OVERLAY_BACKGROUND,
      position:   'fixed',
      display:    'none',
      top:        0,
      right:      0,
      bottom:     0,
      left:       0
    });
    $(document.body).append($overlay);
    return $overlay;
  }

  function cleanupPrevTarget() {
    if ($prevTarget) {
      $prevTarget.css({
        position: '',
        zIndex:   ''
      });
    }
    $prevTarget = null;
  }

  function hide() {
    overlay().fadeOut();
    cleanupPrevTarget();
  }

  function reveal(target) {
    cleanupPrevTarget();
    overlay().fadeIn();
    if (target) {
      $currTarget = $(target);
      // make sure the target node's `position` behaves with `z-index` correctly
      var position = $currTarget.css('position')
      if (!/^(?:absolute|fixed|relative)$/.test(position)) {
        position = 'relative';
      }
      $currTarget.css({
        position: position,
        zIndex:   OVERLAY_ZINDEX + 1
      });
      $prevTarget = $currTarget;
    }
  }

  return {
    reveal: reveal,
    hide: hide
  };
}
