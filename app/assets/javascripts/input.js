var input;	// Input to be entered.

$(document).ready(function(){

	function Input()
	{
	    this.type = 'sale';
	    this.article;

	    var privateMethod = function()
	    {
	        
	    }

	    this.getType = function()
	    {
	        return this.type;
	    }

	    this.setType = function(newType)
	    {
	        this.type = newType;
	    }

	    this.getArticle = function()
	    {
	        return this.article;
	    }

	    this.setArticle = function(newArticle)
	    {
	        this.article = newArticle;
	    }

	}

	// Usuario comienza un proceso de input.
	$('#articleListPopup').on('click', function(){
		$.ajax({
		  url: '/articles/list',
		  type: "POST",
		  success:function(data){
		  	$('#articleListContainer').html(data);
		  	bindArticles();
		    input = new Input();
		  }
		});
	});

	// Usuario cambia tipo de input.
	$('input:radio[name="type"]').on('change', function(e){
			// Setea tipo de input.
	        var type = $(e.currentTarget).val();
	        input.setType(type);			
    });

    // Usuario cambia articulo a enlazar.
    $('input:radio[name="selectArticle"]').on('change', function(e){
		// Setea tipo de input.
        var articleId = $(e.currentTarget).attr('id');
        input.setArticle(articleId);
    });

    // Usuario confirma el input.
    $('#confirmInput').on('click', function(){
   		$.ajax({
			url      : '/inputs/new_manual_input',
			type     : "POST",
			dataType : 'html',
			data     : { 'type' : input.getType() },
			success:function(data){
				console.info(data);
				$('#articleListContainer').html(data);
			},
            error: function(XMLHttpRequest, textStatus, errorThrown) {
            	console.log(arguments);
                console.info("Status: " + textStatus);
                console.info("Error: " + errorThrown); 
            } 
		});	
    });    

	function bindArticles(){
		$('.articleDetail').on('click', function(){
			var articleId = $(this).attr('id');
			$.ajax({
				url: '/articles/fetch_data',
				type: "POST",
				dataType: 'html',
				  data: { 'id' : articleId },
				success:function(data){
					console.info(data);
					$('#articleListContainer').html(data);
				},
	            error: function(XMLHttpRequest, textStatus, errorThrown) {
	            	console.log(arguments);
	                console.info("Status: " + textStatus);
	                console.info("Error: " + errorThrown); 
	            } 
			});
		});
	}
	

	// Callbacks para prueba de concepto solo, cambiar.
/*
	$('#articleListPopup').on('click', function(){
		$.ajax({
		  url: '/articles/list',
		  type: "POST",
		  success:function(data){
		    $('#articleListContainer').html(data);
		    bindArticles();
		  }
		});
	});

	function bindArticles(){
		$('.articleDetail').on('click', function(){
			var articleId = $(this).attr('id');
			$.ajax({
				url: '/articles/fetch_data',
				type: "POST",
				dataType: 'html',
				  data: { 'id' : articleId },
				success:function(data){
					console.info(data);
					$('#articleListContainer').html(data);
				},
	            error: function(XMLHttpRequest, textStatus, errorThrown) {
	            	console.log(arguments);
	                console.info("Status: " + textStatus);
	                console.info("Error: " + errorThrown); 
	            } 
			});
		});
	}

	function getArticleId(){
		return $('.selectArticle:checked').attr('id');
	}
*/
});