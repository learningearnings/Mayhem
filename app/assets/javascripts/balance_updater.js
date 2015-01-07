updateBalance = function() {
  $.get("/teachers/balance").success(function(data) {
    $('.credit-balance').html(data);
  });
}
