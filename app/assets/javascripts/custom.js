$(document).ready(function() {
  $(".intro").addClass("selected");
  $(".register-slide, .earn-slide, .enter-slide, .buy-slide, .receive-slide").css('display', 'none');
	
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

});