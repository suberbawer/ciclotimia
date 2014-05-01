$(document).ready(function(){

	function Article(_id){
	    
	    var id = _id;							// Id (client side) del article.
		var amount; 							// Monto (por defecto).
		var description = '';

	    var _articleContainer  = $('#articleDetailContainer');	// Contenedor del detalle del articulo.
	    var _modalBackground   = $('.modalBackground');
	    var _formContainer     = $('#returnFormContainer');			// Container of the form.

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


	    // Usuario cambia articulo a referenciar.
		// this._articleId.on('blur', function(e){
	 //        var articleId = $(e.currentTarget).val();
	 //        self.setArticleId(articleId);
	 //    });


	    return {
	    	/**
		     *	Traigo los detalles del articulo de {this}.
		     */
	    	retrieveArticleData: function(){
				var currentLotArticle = _.find(inputCollection.inputList, function(cInput){ return cInput.article == self.getArticleId(); });
				if (isUndefined(currentLotArticle)) {
					$.ajax({
						url      : '/articles/fetch_rented_article',
	 					type     : "GET",
						dataType : 'html',
						data     : { 'id' : id },
						success:function(data){
							// Obtengo el importe calculado (mejorar).
							console.info(data)
							var articlePartial = jQuery.parseHTML(data);
							amount = $(articlePartial[1]).find('#selectedAmount').text(); //articlePartial.find('#articlePartial').val();
							console.info(amount)
							description = $(articlePartial[1]).find('#selectedDescription').text();
							_articleContainer.html(data); 	// Muestro detalle del articulo seleccionado...
							showFormContainer($('.articleData'));
							_modalBackground.show();
						}
					});
				}
				else{
					new Messi('El artículo esta ingresado en el lote actual', {title: 'Información', modal: true});
				}
		    },

		    getId: function(){
		    	return id; 
		    },

		    getAmount: function(){
		    	return amount; 
		    },

		    getDescription: function(){
		    	return description; 
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
			}
		}

		var createParameterList = function(inputIds){
			var paramString = "";
			for(var i in inputIds){
				var separator = (i > 0) ? "&" : "";
				paramString += separator + "inputs[]=" + inputIds[i].toString()
			}
			return paramString;
		}

		_newReturnButton.on('click', function(){
			var articleId = _articleId.val();
			if (articleId) {
				article = new Article(articleId);
				article.retrieveArticleData();
			}
		});

		_articleDetailContainer.on('click', '#returnRentedArticle', function(e){
			if (article) {
				articles.push(article);
				_modalBackground.hide();
	        	refreshArticleList();
			}
		});

		_devolutionContainer.on('click', '#returnBatchButton', function(e){
			var articleIdList = obtainArticlesId()
			console.info(articleIdList);

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