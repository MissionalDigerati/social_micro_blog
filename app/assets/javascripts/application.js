// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .
jQuery(document).ready(function($) {
	$( ".draggable" ).draggable();
	if($('div.resizable-video').length > 0) {
		/**
		 * Resize the videos anytime they resize the page 
		 */
		resizeVideos();
		$(window).resize(function() {
				resizeVideos();
		});
		$(window).resize();
		/**
		 * Set on Timer to resize as well 
		 */
		window.setInterval(resizeVideos, 2000);
	}
});

/**
 * Resize video based on the aspect width of the site
 * 0.5625 is 9 divided by 16 – the ratio of height to width in an HD video player.
 *  
 * http://technology.latakoo.com/2012/04/10/bootstrap-for-video/ 
 * 
 * @return void
 */
function resizeVideos() {
	var objectWidth = $('.resizable-video').width();
    $('div.resizable-video iframe').css({'height':(objectWidth * 0.5625)+'px', 'width': '100%'});
		$('div.resizable-video object').css({'height':(objectWidth * 0.5625)+'px', 'width': '100%'});
		$('div.resizable-video video').css({'height':(objectWidth * 0.5625)+'px', 'width': '100%'});
		$('div.resizable-video embed').css({'height':(objectWidth * 0.5625)+'px', 'width': '100%'});
		$('div.video_player, div.video_player div').css('height', (objectWidth * 0.5625)+'px');
};
