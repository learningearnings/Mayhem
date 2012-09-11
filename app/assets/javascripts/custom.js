$(document).ready(function() {
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
	});

  	$(".earn").click(function(){
	  $(".intro-slide, .register-slide, .enter-slide, .buy-slide, .receive-slide").css('display', 'none');
  
	  $(".selected").removeClass("selected")
	  $(this).addClass("selected");	
	  $(".earn-slide").css("display", "block");
	});

  	$(".enter").click(function(){
	  $(".intro-slide, .register-slide, .earn-slide, .buy-slide, .receive-slide").css('display', 'none');
  
	  $(".selected").removeClass("selected")
	  $(this).addClass("selected");	
	  $(".enter-slide").css("display", "block");
	});

  	$(".buy").click(function(){
	  $(".intro-slide, .register-slide, .earn-slide, .enter-slide, .receive-slide").css('display', 'none');	
  
	  $(".selected").removeClass("selected")
	  $(this).addClass("selected");	
	  $(".buy-slide").css("display", "block");
	});

  	$(".receive").click(function(){
	  $(".intro-slide, .register-slide, .earn-slide, .enter-slide, .buy-slide").css('display', 'none');	
 
	  $(".selected").removeClass("selected")
	  $(this).addClass("selected");	
	  $(".receive-slide").css("display", "block");
	});

  	$(".intro").click(function(){
	  $(".receive-slide, .register-slide, .earn-slide, .enter-slide, .buy-slide").css('display', 'none');
  
	  $(".selected").removeClass("selected")
	  $(this).addClass("selected");	
	  $(".intro-slide").css("display", "block")
	});	
	
	// How it works - teachers not logged in	
  	$(".step-1").click(function(){
	  $(".attention-teachers, .step2-slide, .step3-slide, .step4-slide").css('display', 'none');
	  
	  $(".selected").removeClass("selected")
	  $(this).addClass("selected");	
	  $(".step1-slide").css("display", "block");	
	});

  	$(".step-2").click(function(){
	  $(".attention-teachers, .step1-slide, .step3-slide, .step4-slide").css('display', 'none');
  
	  $(".selected").removeClass("selected")
	  $(this).addClass("selected");	
	  $(".step2-slide").css("display", "block");
	});

  	$(".step-3").click(function(){
	  $(".attention-teachers, .step1-slide, .step2-slide, .step4-slide").css('display', 'none');
  
	  $(".selected").removeClass("selected")
	  $(this).addClass("selected");	
	  $(".step3-slide").css("display", "block");
	});

  	$(".step-4").click(function(){
	  $(".attention-teachers, .step1-slide, .step2-slide, .step3-slide").css('display', 'none');
  
	  $(".selected").removeClass("selected")
	  $(this).addClass("selected");	
	  $(".step4-slide").css("display", "block");
	});

  	$(".attention").click(function(){
	  $(".step4-slide, .step1-slide, .step2-slide, .step3-slide").css('display', 'none');
 
	  $(".selected").removeClass("selected")
	  $(this).addClass("selected");	
	  $(".attention-teachers").css("display", "block");
	});
	
	// Primary Nav Selected
	if(window.location.href.indexOf("how_it_works") > -1) {
	 $(".how-it-works").toggleClass("how-it-works-selected")
	 } 
	 else if(window.location.href.indexOf("not_logged_in_locker") > -1) {
		 $(".locker").toggleClass("locker-selected")		
	}
	 else if(window.location.href.indexOf("not_logged_in_inbox") > -1) {
		 $(".inbox").toggleClass("inbox-selected")	
	}
	 else if(window.location.href.indexOf("not_logged_in_bank") > -1) {
		 $(".bank").toggleClass("bank-selected")	
	}	
	 else if(window.location.href.indexOf("not_logged_in_play") > -1) {
		 $(".play").toggleClass("play-selected")	
	}	
	 else if(window.location.href.indexOf("not_logged_in_rewards") > -1) {
		 $(".rewards").toggleClass("rewards-selected")	
	}	
	 else if(window.location.href.indexOf("news") > -1) {
		 $(".news").toggleClass("news-selected")	
	}	
	 else if(window.location.href.indexOf("") > -1) {
		 $(".home").toggleClass("inbox-selected")	
	}	
  
	
});