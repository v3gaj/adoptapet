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
//= timeline

$(document).on('turbolinks:load', function() {

	panelPetProfile();
	petSlider();
	fadeSlider();
	sponsorSlider();
	masonryGallery();
	homeGallery()
	lazyMasonry();
	prettyPhot();
	toolpit();
	showAnimation();
	timeline();
	$(".slide img").load(function(){
		homeSliderHeight();
	});
	$(".pet-cover-img").load(function(){
		petCoverFullBackground();
	});
	windowResize();
	addRemoteTrue("adoptions-available-scroller");
	addRemoteTrue("user-pets-for-adoption");
	addRemoteTrue("user-requests-for-pets");
	addRemoteTrue("user-adopted-pets");
	addRemoteTrue("filter-and-paginate-succesful-adoptions");
	scrollTopPagination("filter-and-paginate-succesful-adoptions");
	scrollTopPagination("adoptions-available-scroller");
	scrollTopPagination("user-pets-for-adoption");
	scrollTopPagination("user-requests-for-pets");
	scrollTopPagination("user-adopted-pets");
});

function windowResize(){
	$(window).on('resize', function(){
		petCoverFullBackground();
		masonryGallery();
	}).promise().done();
}

function petCoverFullBackground(){
	var imageHeight = $('.pet-cover-img').height();
	var wrapperHeight = $('.pet-cover').height();
	var imageWidth = $('.pet-cover-img').width();
	var wrapperWidth = $('.pet-cover').width();
	if (imageHeight < wrapperHeight || imageWidth > wrapperWidth) {
		$('.pet-cover-img').addClass('full-background');
	}else{
		$('.pet-cover-img').removeClass('full-background');
	}
}

function homeSliderHeight(){
	if ($('.slide img').length != 0) {
		var array = $( ".slide img" ).toArray()
		var height = 0;
		var win = $(window).height();
		var menuOffset = $('.navbar').offset();
		var menuHeight = $('.navbar').height();

		var menu = menuOffset.top + menuHeight;
		var menu = win - menu;

		for (var i = 0; i < array.length; i++) {
			var attribute = $(array[i]).height();
			if (height == 0) {
				height = attribute
			}else if (attribute < height) {
				height = attribute
			}
		}

		if(height < 512){
			height = 512
		}

		if (height > (win - menuHeight)) {
			$('#home-slider').css('height', win - menuHeight);
		    $('#home-slider .slide').css('height', win - menuHeight);
		}else{
			$('#home-slider').css('height', height);
		  $('#home-slider .slide').css('height', height);
		}
	}
}

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
	      breakpoint: 600,
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
	$('.home-slider').slick({
	  dots: true,
	  infinite: true,
	  autoplay: true,
	  autoplaySpeed: 5000,
	  arrows: false,
	  cssEase: 'linear',
	  pauseOnHover:false
	});	
}

function sponsorSlider(){
	$('.sponsor-slider').slick({
		arrows: false,
		infinite: true,
		slidesToShow: 5,
		slidesToScroll: 1,
		autoplay: true,
		autoplaySpeed: 2000,
		responsive: [
			{
			  breakpoint: 992,
			  settings: {
				arrows: false,
				slidesToShow: 3
			  }
			},
			{
				breakpoint: 768,
				settings: {
				  arrows: false,
				  slidesToShow: 2
				}
			},
			{
			  breakpoint: 500,
			  settings: {
				arrows: false,
				slidesToShow: 1
			  }
			}
		  ]
		  
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

function homeGallery(){
	$(function(){
	  $('#masonry-thumbs').masonry({
	    itemSelector: '.box',
	    isAnimated: !Modernizr.csstransitions,
	    isFitWidth: true
	  });

	});
}

function lazyMasonry(){
	$('img.lazy').load(function() {
	    masonryGallery();
	    $('#masonry-container').css('opacity', 1);
	});
}

function prettyPhot(){
  $("a[rel^='prettyPhoto']").prettyPhoto();
  $("a.prettyphoto").prettyPhoto();
  $("a[rel^='prettyPhoto']").prettyPhoto({hook:"rel",social_tools:!1,theme:"pp_default",horizontal_padding:20,opacity:.8,deeplinking:!1});
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
	toolpit();
}

function pets_filter_js(){
	addRemoteTrue("adoptions-available-scroller");
	petSlider();
	scrollTop("filter-available-pets");
	scrollTopPagination("adoptions-available-scroller");
	toolpit();
}

function filter_and_paginate_succesful_adoptions_js(){
	addRemoteTrue("filter-and-paginate-succesful-adoptions");
	scrollTopPagination("filter-and-paginate-succesful-adoptions");
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


function timeline(){
	function VerticalTimeline( element ) {
		this.element = element;
		this.blocks = this.element.getElementsByClassName("js-cd-block");
		this.images = this.element.getElementsByClassName("js-cd-img");
		this.contents = this.element.getElementsByClassName("js-cd-content");
		this.offset = 0.8;
		this.hideBlocks();
	};

	VerticalTimeline.prototype.hideBlocks = function() {
		//hide timeline blocks which are outside the viewport
		if ( !"classList" in document.documentElement ) {
			return;
		}
		var self = this;
		for( var i = 0; i < this.blocks.length; i++) {
			(function(i){
				if( self.blocks[i].getBoundingClientRect().top > window.innerHeight*self.offset ) {
					self.images[i].classList.add("cd-is-hidden"); 
					self.contents[i].classList.add("cd-is-hidden"); 
				}
			})(i);
		}
	};

	VerticalTimeline.prototype.showBlocks = function() {
		if ( ! "classList" in document.documentElement ) {
			return;
		}
		var self = this;
		for( var i = 0; i < this.blocks.length; i++) {
			(function(i){
				if( self.contents[i].classList.contains("cd-is-hidden") && self.blocks[i].getBoundingClientRect().top <= window.innerHeight*self.offset ) {
					// add bounce-in animation
					self.images[i].classList.add("cd-timeline__img--bounce-in");
					self.contents[i].classList.add("cd-timeline__content--bounce-in");
					self.images[i].classList.remove("cd-is-hidden");
					self.contents[i].classList.remove("cd-is-hidden");
				}
			})(i);
		}
	};

	var verticalTimelines = document.getElementsByClassName("js-cd-timeline"),
		verticalTimelinesArray = [],
		scrolling = false;
	if( verticalTimelines.length > 0 ) {
		for( var i = 0; i < verticalTimelines.length; i++) {
			(function(i){
				verticalTimelinesArray.push(new VerticalTimeline(verticalTimelines[i]));
			})(i);
		}

		//show timeline blocks on scrolling
		window.addEventListener("scroll", function(event) {
			if( !scrolling ) {
				scrolling = true;
				(!window.requestAnimationFrame) ? setTimeout(checkTimelineScroll, 250) : window.requestAnimationFrame(checkTimelineScroll);
			}
		});
	}

	function checkTimelineScroll() {
		verticalTimelinesArray.forEach(function(timeline){
			timeline.showBlocks();
		});
		scrolling = false;
	};
};
