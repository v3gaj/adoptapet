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
//= require masonry/jquery.imagesloaded.min
//= require masonry/jquery.infinitescroll.min
//= require masonry/modernizr-transitions

//= require prettyphoto-rails
//= require prettyphoto-rails-dev

//= slick


$(document).on('turbolinks:load', function() {

	panelPetProfile();
	petSlider();
	fadeSlider();
	masonryGallery();
	lazyMasonry();
	prettyPhot();
	toolpit();
	showAnimation();
	addRemoteTrue("adoptions-available-scroller");
	addRemoteTrue("user-pets-for-adoption");
	addRemoteTrue("user-requests-for-pets");
	addRemoteTrue("user-adopted-pets");
	scrollTopPagination("adoptions-available-scroller");
	scrollTopPagination("user-pets-for-adoption");
	scrollTopPagination("user-requests-for-pets");
	scrollTopPagination("user-adopted-pets");


});

function panelPetProfile(){
	$(function(){
		$(".panels-links a").first().addClass('active-pet-panel');

		$(".panels-links a").click(function() {  
			$(".panels-links a").removeClass('active-pet-panel');
			$(this).addClass("active-pet-panel");
		});
	});
}

function petSlider(){
	$('.scroller').slick({
	  centerMode: true,
	  slidesToShow: 3,
	  autoplay: true,
  	  autoplaySpeed: 2000,
	  responsive: [
	    {
	      breakpoint: 768,
	      settings: {
	        arrows: false,
	        centerMode: true,
	        slidesToShow: 3
	      }
	    },
	    {
	      breakpoint: 480,
	      settings: {
	        arrows: false,
	        centerMode: true,
	        slidesToShow: 1
	      }
	    }
	  ]
	});
}

function fadeSlider(){
	$('.fade-slider').slick({
	  dots: true,
	  infinite: true,
	  autoplay: true,
	  autoplaySpeed: 3000,
	  arrows: false,
	  cssEase: 'linear',
	  pauseOnHover:false
	});	
}

function masonryGallery(){
	$(function(){
	  $('#masonry-container').masonry({
	    itemSelector: '.box',
	    isAnimated: !Modernizr.csstransitions,
	    isFitWidth: true
	  });

	});
}

function lazyMasonry(){
	$('img.lazy').load(function() {
	    masonryGallery();
	});
}

function prettyPhot(){
	jQuery(document).ready(function($) {
	  "use strict";
	  /* pretty photo */
	  $(document).ready(function(){
	    $("a[rel^='prettyPhoto']").prettyPhoto();
	    $("a.prettyphoto").prettyPhoto();
	    $("a[rel^='prettyPhoto']").prettyPhoto({hook:"rel",social_tools:!1,theme:"pp_default",horizontal_padding:20,opacity:.8,deeplinking:!1});
	   })
	});
}

function toolpit(){
	$('[data-toggle="tooltip"]').tooltip();   
}

function showAnimation(){
  setTimeout(function() {
    $('.animation-wrapper').css({ opacity: "1"});
  }, 500);
}

function scrollTop(element){
	setTimeout(function() {
		var reference = document.getElementById(element);
		console.log(reference)
		var height = reference.offsetTop;
		$("html").animate({scrollTop:height}, 'slow');
	}, 100);
}

function scrollTopPagination(element){
	$('#'+ element +' .pagination a').bind('click', function(event){
		scrollTop(element);
		console.log(element)
	});
}

function addRemoteTrue(element){
	$('#'+ element +' .pagination a').attr('data-remote', 'true');
}

// Views Ajax Calls

function pets_paginate_js(){
	addRemoteTrue("adoptions-available-scroller");
	scrollTopPagination("adoptions-available-scroller");
}

function pets_filter_js(){
	addRemoteTrue("adoptions-available-scroller");
	petSlider();
	scrollTop("filter-available-pets");
	scrollTopPagination("adoptions-available-scroller");
}

function user_pets_for_adoption_js(){
	addRemoteTrue("user-pets-for-adoption");
	scrollTopPagination("user-pets-for-adoption");
}

function user_requests_for_pets_js(){
	addRemoteTrue("user-requests-for-pets");
	scrollTopPagination("user-requests-for-pets");
}

function user_adopted_pets_js(){
	addRemoteTrue("user-adopted-pets");
	scrollTopPagination("user-adopted-pets");
}

function messages_create_js(){
	$(".message_errors").html("<p class='message_notice'>Mensaje enviado exitosamente.</p>");
	$(".message_notice").addClass("message_warning").delay(5000).queue(function(next){
	    $(this).removeClass("message_warning");
	    next();
	});
	$('html, body').animate({
        scrollTop: $(".message_errors").position().top
    }, 2000);
	$(".form-clear").val('');
}

