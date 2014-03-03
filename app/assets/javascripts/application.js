// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

/**
 * Function that toggle the selected option of the menu depending on the url
 * @param url - Url of the current page
 *
 */
function toggleActiveOption(url){
	// Remove old active class
	removeActiveClass();

	// Add active class by url, to select the option on the menu
	if (url.toLowerCase().indexOf('providers') > -1 ) {
		$('.providers').addClass('active');
	} else if (url.toLowerCase().indexOf('home') > -1 ) {
		$('.home').addClass('active');
	} else if (url.toLowerCase().indexOf('articles') > -1) {
		$('.articles').addClass('active');
	} else if (url.toLowerCase().indexOf('sales') > -1) {
		$('.sales').addClass('active');
	} else if (url.toLowerCase().indexOf('collects') > -1) {
		$('.collects').addClass('active');
	} else if (url.toLowerCase().indexOf('inputs') > -1) {
		$('.inputs').addClass('active');
	} else if (url.toLowerCase().indexOf('outputs') > -1) {
		$('.outputs').addClass('active');
	}
}

function removeActiveClass(){
	$('active').removeClass('active');
}

$(document).ready(function(){
	toggleActiveOption(window.location.pathname);
});

/**
 *  Devuelve el tipo de input en espanol.
 *
 *  @param Tipo de input.
 *  @return Tipo de input en formato humano y espanol.
 */
function obtainTransactionType(transactionType){
	var humanType;
	switch (transactionType) {
	  case "sale":
	  case "Sale":
	    humanType = 'Venta';
	    break;
	  case "rent":
	  case "Rent":
	    humanType = 'Alquiler';
	    break;
	  case "Output":
	    humanType = 'Egreso';
	    break;
	  case "cancel_input":
	    humanType = 'Anulacion';
	    break;  
	  default:
	    humanType = 'Transaccion no reconocida';
	}
	return humanType;
}

function isUndefined(elem){
	return typeof elem == 'undefined'
}