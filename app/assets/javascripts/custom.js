$(document).ready(function() {
  var pathArray = window.location.hostname.split( '.' );
  var current_subdomain = pathArray[0];
  var already_selected = 0;
  $('.focus-on-me').focus();
  $(".intro").addClass("selected");
  $(".attention").addClass("selected");
  $(".register-slide, .earn-slide, .enter-slide, .buy-slide, .receive-slide").css('display', 'none');
  $(".step1-slide, .step2-slide, .step3-slide, .step4-slide").css('display', 'none');

	// How it works - not logged in
  $(".register").click(function(){
	  $(".intro-slide, .earn-slide, .enter-slide, .buy-slide, .receive-slide").css('display', 'none');

	  $(".selected").removeClass("selected")
	  $(this).addClass("selected");
	  $(".register-slide").css("display", "block");
          return false;
	});

  $(".earn").click(function(){
	  $(".intro-slide, .register-slide, .enter-slide, .buy-slide, .receive-slide").css('display', 'none');

	  $(".selected").removeClass("selected")
	  $(this).addClass("selected");
	  $(".earn-slide").css("display", "block");
          return false;
	});

  $(".enter").click(function(){
	  $(".intro-slide, .register-slide, .earn-slide, .buy-slide, .receive-slide").css('display', 'none');

	  $(".selected").removeClass("selected")
	  $(this).addClass("selected");
	  $(".enter-slide").css("display", "block");
          return false;
	});

  $(".buy").click(function(){
	  $(".intro-slide, .register-slide, .earn-slide, .enter-slide, .receive-slide").css('display', 'none');

	  $(".selected").removeClass("selected")
	  $(this).addClass("selected");
	  $(".buy-slide").css("display", "block");
          return false;
	});

  $(".receive").click(function(){
	  $(".intro-slide, .register-slide, .earn-slide, .enter-slide, .buy-slide").css('display', 'none');

	  $(".selected").removeClass("selected")
	  $(this).addClass("selected");
	  $(".receive-slide").css("display", "block");
          return false;
	});

  $(".intro").click(function(){
	  $(".receive-slide, .register-slide, .earn-slide, .enter-slide, .buy-slide").css('display', 'none');

	  $(".selected").removeClass("selected")
	  $(this).addClass("selected");
	  $(".intro-slide").css("display", "block")
          return false;
	});

	// How it works - teachers not logged in
  $(".step-1").click(function(){
	  $(".attention-teachers, .step2-slide, .step3-slide, .step4-slide").css('display', 'none');

	  $(".selected").removeClass("selected")
	  $(this).addClass("selected");
	  $(".step1-slide").css("display", "block");
          return false;
	});

  $(".step-2").click(function(){
	  $(".attention-teachers, .step1-slide, .step3-slide, .step4-slide").css('display', 'none');

	  $(".selected").removeClass("selected")
	  $(this).addClass("selected");
	  $(".step2-slide").css("display", "block");
          return false;
	});

  $(".step-3").click(function(){
	  $(".attention-teachers, .step1-slide, .step2-slide, .step4-slide").css('display', 'none');

	  $(".selected").removeClass("selected")
	  $(this).addClass("selected");
	  $(".step3-slide").css("display", "block");
          return false;
	});

  $(".step-4").click(function(){
	  $(".attention-teachers, .step1-slide, .step2-slide, .step3-slide").css('display', 'none');

	  $(".selected").removeClass("selected")
	  $(this).addClass("selected");
	  $(".step4-slide").css("display", "block");
          return false;
	});

  $(".attention").click(function(){
	  $(".step4-slide, .step1-slide, .step2-slide, .step3-slide").css('display', 'none');

	  $(".selected").removeClass("selected")
	  $(this).addClass("selected");
	  $(".attention-teachers").css("display", "block");
          return false;
	});

  function highlightNavigation(path_part, nav_selector, subdomain){
      if((subdomain != undefined && subdomain != current_subdomain) || already_selected) {
          return;
      }
      if(window.location.href.indexOf(path_part) > -1) {
	  $("." + nav_selector).toggleClass("active");
          already_selected = 1;
      }
  }
	// Primary Nav Selected
  highlightNavigation('locker',        'locker');
  highlightNavigation('charities',     'charities')
  highlightNavigation('inbox',         'inbox');
  highlightNavigation('bank',          'bank');
  highlightNavigation('classrooms',    'classrooms');
  highlightNavigation('lounge',        'lounge');
  highlightNavigation('play',          'play');
  highlightNavigation('games',         'play');
  highlightNavigation('rewards',       'rewards');
  highlightNavigation('shop',          'shop');
  highlightNavigation('restock',       'restock');
  highlightNavigation('store',         'restock', 'le');
  highlightNavigation('reports',       'reports');
  highlightNavigation('settings',      'settings');
  highlightNavigation('store',         'rewards');
  highlightNavigation('news',          'news');
  highlightNavigation('how_it_works',  'how-it-works');
  highlightNavigation('testimonials',  'testimonials');
  highlightNavigation('bulk_students', 'manage_students');
  highlightNavigation('bulk_teachers', 'manage_teachers');
  highlightNavigation('',              'home');
  highlightNavigation('help',          'help');

 //detect the width on page load
$(document).ready(function(){
 var current_width = $(window).width();
  //do something with the width value here!
 if(current_width < 1180){
   $(".side-art").css( "display","none" );
 }
 else {
   $(".side-art").css( "display","block" );
 }
 
 $('.arrow img').click(function(){

	if ($('.custom-nav-bar').css('margin-left') == "-200px") {
 		$('.custom-nav-bar').animate({"margin-left": "0px"}); 
    	$('.primary-nav li a').css("margin-left","0px"); 	
    	$('.primary-nav li a').css("text-indent","20px");	
 	}
    else {
    	$('.custom-nav-bar').animate({"margin-left": "-200px"}); 
    	$('.primary-nav li a').css("margin-left","190px");
    	$('.primary-nav li a').css("text-indent","200px");
    }
 });
 
});
//update the width value when the browser is resized
$(window).resize(function(){
 var current_width = $(window).width();
//do something with the width value here!
 if(current_width < 1180){
   $(".side-art").css( "display","none" );
 }
 else {
   $(".side-art").css( "display","block" );
 }
});

// Highlight function
$.fn.animateHighlight = function( highlightColor, duration ) {
    var highlightBg = highlightColor || "#FFFF9C";
    var animateMs = duration || "fast"; // edit is here
    var originalBg = this.css( "background-color" );

    if ( !originalBg || originalBg === highlightBg )
        originalBg = "#FFFFFF"; // default to white

    jQuery( this )
            .css( "backgroundColor", highlightBg )
            .animate( { backgroundColor: originalBg }, animateMs, null, function() {
        jQuery( this ).css( "backgroundColor", originalBg );
    } );
};

});



 