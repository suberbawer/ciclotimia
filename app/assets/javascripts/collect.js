
function enableSameTypeAndStaff(transactionType, staffId){
	if (transactionType === '') {
		$('.inputCheckbox').attr("disabled", false);
		$('#submitSalesContainer').hide();
		$('#submitRentsContainer').hide();
	}
	else{
		var selectedTypeSelector
		if (transactionType === 'Rent') {
			selectedTypeSelector = $('.inputCheckbox[data-input-type=Rent]');
			$('#submitSalesContainer').hide();
			$('#submitRentsContainer').show();
		}
		else{
			selectedTypeSelector = $('.inputCheckbox[data-input-type=Sale]');
			$('#submitRentsContainer').hide();
			$('#submitSalesContainer').show();
		}
		$('.inputCheckbox').attr("disabled", true);
		selectedTypeSelector.attr("disabled", false);
	}

	// Also disable inputs with different staffs
}

function obtainArticlesId(){
	var articleIdList = [];
    $('.inputTable tbody tr').each(function(art){
    	if ($(this).find('.inputCheckbox').prop( "checked" )) {	
    		articleIdList.push($(this).attr('id'));
    	}
    });
    return articleIdList;
}

$(document).on('click', '.inputCheckbox', function(){
	console.info($('.inputCheckbox:checked').length);
	if( $('.inputCheckbox:checked').length > 0 ){
		enableSameTypeAndStaff($(this).data('input-type'));
	}
	else{
		enableSameTypeAndStaff('');
	}
});

$(document).on('click', '#printRents', function(){
	console.info('printRents', $('#articleDetailContainerReprint'));
	var articleIdList = obtainArticlesId()
	console.info(articleIdList)
	if (articleIdList.length > 0) {
		$.ajax({
			url      : '/articles/actual_billing_rent',
			type     : "GET",
			dataType : 'html',
			data     : { 'id_list' : articleIdList },
			success:function(data){
				$('#articleDetailContainerReprint').html(data);
				$('.modalBackgroundReprint').show();
			}
		});
	}
	else{
		new Messi('No hay articulos a devolver', {title: 'Información', modal: true});
	}
});


//controller: "articles", action: ""
