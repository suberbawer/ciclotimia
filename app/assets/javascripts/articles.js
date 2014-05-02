$(document).ready(function(){

	function Article(_id){
	    
	    var id = _id;							// Id (client side) del article.
		var amount; 							// Monto (por defecto).
		var description = '';

	    var _articleContainer  = $('#articleDetailContainer');	// Contenedor del detalle del articulo.
	    var _modalBackground   = $('.modalBackground');
	    var _formContainer     = $('#returnFormContainer');			// Container of the form.
		var _articleId         = $('#returnArticleId');
	    
	    /**
	     *	Metodo encargado de mostrar o esconder el form container.
	     *	(depende de el estado del articulo).
	     */
	    var showFormContainer = function(relatedArticle){
	    	if (relatedArticle.data('status') == null) {
	    		_formContainer.hide();
	    	}
	    	else{
	    		_formContainer.show();
	    	}
	    	
	    }

	    return {
	    	/**
		     *	Traigo los detalles del articulo de {this}.
		     */
	    	retrieveArticleData: function(){
				$.ajax({
					url      : '/articles/fetch_rented_article',
 					type     : "GET",
					dataType : 'html',
					data     : { 'id' : id },
					success:function(data){
						// Obtengo el importe calculado (mejorar).
						var articlePartial = jQuery.parseHTML(data);
						amount 			   = $(articlePartial[1]).find('#selectedAmount').text(); //articlePartial.find('#articlePartial').val();
						description  	   = $(articlePartial[1]).find('#selectedDescription').text();
						type 			   = $(articlePartial[1]).find('#selectedType').text();
						_articleId.val('');
						_articleContainer.html(data); 	// Muestro detalle del articulo seleccionado...
						showFormContainer($('.articleData'));
						_modalBackground.show();
					}
				});
		    },

		    getId: function(){
		    	return id; 
		    },

		    getAmount: function(){
		    	return amount; 
		    },

		    getDescription: function(){
		    	return description; 
		    },

		    getType: function(){
		    	return type;
		    }
	    }
	}

	/**
	 *	Coleccion de articulos. 
	 */
	function ArticleCollection()
	{
		var _newReturnButton        = $('#newReturnButton');
		var _templateArticleList    = $("#template-articleList").html();
		var _articleId              = $('#returnArticleId');
		var _returnRentedArticle    = $('#returnRentedArticle');
		var _articleDetailContainer = $('#articleDetailContainer');
		var _articleListContainer   = $('.articleCollectionTable'); // Contenedor de los articulos en el lote.
		var _modalBackground        = $('.modalBackground');
		var _devolutionContainer    = $('#devolutionContainer');
		var _returnBatchButton      = $('#returnBatchButton');
		var _returnBatchButtonBill  = $('#returnBatchButtonBilling');
		var _deleteButton			= $('.deleteButton');
		var article;
		var articles = [];

		/**
	     *	Refresco lista de articulos.
	     */
	    var refreshArticleList = function(){
	    	_articleListContainer.find('tbody').html(_.template(_templateArticleList, {articles : articles}));
	    }

	    var getTotal = function(){

	    }

	    var deleteArticle = function(articleId){
	    	articles = _.reject(articles, function(article){ 
	    							return article.getId() == articleId;
							  });
	    	refreshArticleList();
	    }

	    var obtainArticlesId = function(){
	    	var articleIdList = [];
	        _.each(articles, function(art){
	        	articleIdList.push(art.getId());
	        });
	        return articleIdList;
	    }

	    var printInputs = function(path) {
		    newWin = window.open(path);
		    newWin.onload = function(){
		    	var divToPrint = newWin.document.getElementById('receiptContainer');
		    	newWin.document.write(divToPrint.outerHTML);
				newWin.print();
				newWin.close();
			}
		}

		var checkAlreadyAdded = function(articleId) {
			for (var i in articles) {
				if (articleId == articles[i].getId()) {
					return true;
				}
			}
			return false;
		}

		var createParameterList = function(inputIds){
			var paramString = "";
			for(var i in inputIds){
				var separator = (i > 0) ? "&" : "";
				paramString += separator + "inputs[]=" + inputIds[i].toString()
			}
			return paramString;
		}

		var enableButton = function(button) {
			console.info(button);
			button.attr('disabled', false);
			button.removeClass('disabled');
		}

		_newReturnButton.on('click', function(){
			var articleId = _articleId.val();
			if (checkAlreadyAdded(articleId)) {
				_articleId.val('');
				new Messi('El artículo esta ingresado en el lote actual', {title: 'Información', modal: true});
			} else if (articleId) {
				article = new Article(articleId);
				article.retrieveArticleData();
			}
		});

		_articleDetailContainer.on('click', '#returnRentedArticle', function(e){
			if (article) {
				articles.push(article);
				_modalBackground.hide();
				focusCursorOnInput();
	        	refreshArticleList();
			}
		});

		_devolutionContainer.on('click', '#returnBatchButtonBilling', function(e){
			var articleIdList = obtainArticlesId()

			if (articleIdList.length > 0) {
				$.ajax({
					url      : '/articles/actual_billing_rent',
 					type     : "GET",
					dataType : 'html',
					data     : { 'id_list' : articleIdList },
					success:function(data){
						_articleDetailContainer.html(data);
						_modalBackground.show();
					}
				});
			}
			else{
				new Messi('No hay articulos a devolver', {title: 'Información', modal: true});
			}

		});

		_devolutionContainer.on('click', '.deleteButton', function(e){
	    	new Messi('Desea borrar el artículo del lote?', 
						  {title: '',
						   	buttons: [{id: 0, label: 'Yes', val: 'Y'}, 
						   		     {id: 1, label: 'No', val: 'N'}], 
						   	callback: function(val) { 
						   		if (val === 'Yes') {
							   		var articleId = $(e.currentTarget).parent().data('id');
		    						deleteArticle(articleId);
		    					}
						   	}
						  });
	    });

		_devolutionContainer.on('click', '#returnBatchButton', function(e){
			var articleIdList = obtainArticlesId()

			if (articleIdList.length > 0) {
				$.ajax({
					url      : '/articles/return_list_articles',
 					type     : "POST",
					dataType : 'html',
					data     : { 'id_list' : articleIdList },
					success:function(data){
						data = JSON.parse(data);
						if (data.message && data.message.length > 0) {
							var param = createParameterList(data.message);
							enableButton(_returnBatchButtonBill);
							printInputs('/inputs/batch_receipt?' + param);
						}
						else{
							new Messi('No se ingresó ningún alquiler, verifique', {title: 'Información', modal: true});
						}
					}
				});
			}
			else{
				new Messi('No hay articulos a devolver', {title: 'Información', modal: true});
			}
		});

		return{

			getArticleList: function(){
				return articles;
			},

			getListSummary: function(){
				return{
					total: getTotal()
				}
			}
		}
	}

	// Creo nuevo listado de articulos (se comienza un lote).
	articleCollection = new ArticleCollection();
});