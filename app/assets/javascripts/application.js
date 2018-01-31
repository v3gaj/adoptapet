// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .

//= require masonry/jquery.masonry
//= require masonry/jquery.event-drag
//= require masonry/jquery.imagesloaded.min
//= require masonry/jquery.infinitescroll.min
//= require masonry/modernizr-transitions

//= require prettyphoto-rails
//= require prettyphoto-rails-dev

//= require jquery.slick


$(document).on('turbolinks:load', function() {

	$(function(){
		$(".panels-links a").first().addClass('active-pet-panel');

		$(".panels-links a").click(function() {  
			$(".panels-links a").removeClass('active-pet-panel');
			$(this).addClass("active-pet-panel");
		});
	});


	$(function(){
	  $('#masonry-container').masonry({
	    itemSelector: '.box',
	    isAnimated: !Modernizr.csstransitions,
	    isFitWidth: true
	  });

	});

	$('img.lazy').load(function() {
	    masonry_update();
	});


	function masonry_update() {
		$('#masonry-container').masonry({
	    itemSelector: '.box',
	    isAnimated: !Modernizr.csstransitions,
	    isFitWidth: true
	  });
	} 

	jQuery(document).ready(function($) {
	  "use strict";
	  /* pretty photo */
	  $(document).ready(function(){
	    $("a[rel^='prettyPhoto']").prettyPhoto();
	    $("a.prettyphoto").prettyPhoto();
	    $("a[rel^='prettyPhoto']").prettyPhoto({hook:"rel",social_tools:!1,theme:"pp_default",horizontal_padding:20,opacity:.8,deeplinking:!1});
	   })
	});


	$(function(){
		$('.scroller').slick({
		  centerMode: true,
		  centerPadding: '0px',
		  slidesToShow: 3,
		  autoplay: true,
	  	  autoplaySpeed: 2000,
		  responsive: [
		    {
		      breakpoint: 768,
		      settings: {
		        arrows: false,
		        centerMode: true,
		        centerPadding: '40px',
		        slidesToShow: 3
		      }
		    },
		    {
		      breakpoint: 480,
		      settings: {
		        arrows: false,
		        centerMode: true,
		        centerPadding: '40px',
		        slidesToShow: 1
		      }
		    }
		  ]
		});
	});

	showContainer();
			
});

function showContainer(){
  setTimeout(function() {
    $('.container').css({ opacity: "1"});
  }, 500);
}
