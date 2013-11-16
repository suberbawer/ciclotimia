var input;			 // Input actual (a ingresar).
var inputCollection; // Input list (lote).

$(document).ready(function(){

	/**
	 *	Clase input.
	 */
	function Input()
	{
	    this.type  	 		    = 'sale';   					// Tipo, por defecto "venta".
	    this.amount 		    = 0;  							// Monto, por defecto 0.
	    this.article;											// Articulo relacionado.
	    this.id;												// Id (client side) del input.

		this._articleContainer  = $('#articleDetailContainer');	// Contenedor del detalle del articulo.
		this._newInputContainer = $('#newInputPopup'); 			// Contenedor del nuevo input. 	    
		this._articleId         = $('#articleInputId');			// Articulo relacionado.
		this._typeRadio         = $('input:radio[name=type]');	// Selector de tipo (venta, alquiler).

		var self 			    = this;

	    var privateMethod = function()
	    {
	        
	    }

	    this.setId = function(newId){
	    	this.id = newId;
	    }

	    this.getType = function() {
	        return this.type;
	    }

	    this.setType = function(newType) {
	        this.type = newType;
	    }

	    this.getAmount = function() {
	    	return this.amount;
	    }

	    this.setAmount = function(newAmount) {
	    	this.amount = newAmount;
	    }

	    this.getArticleDescription = function(){
	    	return this.articleData.description;
	    }

	    this.getArticleId = function() {
	        return this.article;
	    }

	    this.setArticle = function(newArticle) {
	        this.articleData = {
	        					description    : newArticle.data( "description" ),
	        					estimatedPrice : newArticle.data( "estimatedPrice" ),
	        					entryDate      : newArticle.data( "entryDate" ),
	        					comissionPer   : newArticle.data( "comissionPer" ),
	        					status         : newArticle.data( "status" )
	        				   };
	    }

	    this.setArticleId = function(newArticle) {
	        this.article = newArticle;
	    }


	    this.hasArticle = function() {
	    	return this.getArticleId() != undefined && this.getArticleId() !== '';
	    }

	    /**
	     *	Inserta {this} (no se esta usando, pero mantener para ingreso other_input).
	     */
	    this.insertInput = function() {
	    	$.ajax({
				url      : '/inputs/new_manual_input',
				type     : "POST",
				dataType : 'html',
				data     : { 
							 'type'    : self.getType(),
							 'article' : self.getArticleId(),
							 'amount'  : self.getAmount() 
							},
				success:function(data){
					self._articleContainer.html(data);
				},
	            error: function(XMLHttpRequest, textStatus, errorThrown) {
	            	alert('Error: ' + errorThrown + ', ' + textStatus)
	            } 
			});
	    }

	    /**
	     *	Traigo los detalles del articulo de {this}.
	     */
	    this.retrieveArticleData = function(){
	    	if (this.hasArticle()) {
				$.ajax({
					url      : '/articles/fetch_data',
					type     : "POST",
					dataType : 'html',
					data     : { 'id' : self.getArticleId() },
					success:function(data){
						self._articleContainer.html(data); 	// muestro detalle del articulo seleccionado...
						bindArticles();						// ... listeners de articulos...
						self._newInputContainer.show();		// ... muestro popup de la venta.
					}
				});
			}
			else{
				alert('El ingreso no tiene un artículo relacionado');
			}
	    }

	    /**
	     *  Devuelve un objeto con los datos mas relevantes de {this}.
		 *
		 *  @return Objeto con los datos mas importantes de this.
	     */
	    this.toObject = function(){
	    	var obj 	= {};
	    	obj.type 	= this.type;
	    	obj.article = this.article;
	    	obj.amount  = this.amount;
	    	return obj;
	    }

	    // Listeners

	    // Usuario cambia articulo a referenciar.
		this._articleId.on('blur', function(e){
	        var articleId = $(e.currentTarget).val();
	        self.setArticleId(articleId);
	    });

		// Usuario cambia tipo de input.
		this._typeRadio.on('change', function(e){
	        var type = $(this).val();
	        self.setType(type);			
	    });


	    /**
	     *	Metodo encargado de agregar listeners relacionados a los articulos.
	     */
		function bindArticles(){
			
		    $('#selectedAmount').on('change', function(){
		    	// Usuario cambia monto a ingresar.
		    	var amount = $(this).val();
		    	self.setAmount(amount);
		    });
		}
	}

	/**
	 *	Coleccion de inputs. 
	 */
	function InputCollection()
	{
		this.inputList           = new Array();   			  // Listado de inputs (lote) 
		this.currentInput;									  // Input actual (el que esta en el popup).
		this.templateInputList 	 = $("#template-inputList").html();
		this.lastInputId 		 = 0; 	 					  // Indice del ultimo input creado (puede haber sido borrado) del lote.

		this._articleId          = $('#articleInputId');	  // Input text (codigo de barras) del articulo.
		this._newInputButton     = $('#newInputButton'); 	  // Boton para agregar nuevo input popup (tb bindear cuando lee codigo de barras o da enter). 
		this._confirmButton      = $('#confirmInput');		  // Boton para confirmar insertar el input.
		this._confirmBatchButton = $('#confirmBatchButton');  // Confirma agregar lote.
		this._newInputContainer  = $('#newInputPopup'); 	  // Contenedor del nuevo input.
		this._inputListContainer = $('.inputCollectionList'); // Contenedor de los inputs en el lote.
		this._deleteButton       = $('.deleteButton');        // Boton para borrar una venta (fila). 

		var self                 = this;

		this.getLastInputId = function() {
	        return this.lastInputId;
	    }

	    /**
	     *	Seteo el id del input, y dejo preparado el nuevo id.
	     */
	    this.setNewInputId = function() {
	    	self.currentInput.setId(this.lastInputId);
	        this.lastInputId++; 
	    }

	    /**
	     *	Metodo a cargo de borrar el input con el id dado por parametro. 
	     *
	     *  @param Id del input a ser borrado.
	     */
	    this.deleteInput = function(inputId){
	    	this.inputList = _.reject(this.inputList, function(currentInput){ 	// Borro el elemento de la lista...
	    							return currentInput.id == inputId;
							  });
	    	this.refreshInputList();											// ... y refresco la lista de inputs. 
	    }

		/**
		 *	Metodo para insertar un input en el lote.
 		 */
	    this.insertInput = function() {
	    	var relatedArticle = $('.articleData');						// Obtengo los datos del articulo... 
	    	this.currentInput.setArticle(relatedArticle);				// ... y seteo los datos del articulo en el input actual.

	    	var clonedInput    = $.extend(true, {}, this.currentInput);	// Clono el objeto a guardar para evitar inconsistencias.  
	        this.inputList.push(clonedInput);
	        this._newInputContainer.hide();
	        this.refreshInputList();
	    }

	    /**
	     *	Metodo encargado de salvar la lista de inputs al servidor.
	     *
	     *  @param Json de la lista de inputs a guardar.
	     */
	    this.saveInputList = function(objectInputList){
	    	console.info(objectInputList);
	    	if (this.inputList.length > 0) {
	    		$.ajax({
					url      : '/inputs/bulk_save',
					type     : "POST",
					data     : {inputList : objectInputList},
					success  : function(response)
							   {
							   		alert(response.message);
							   },
					error 	 : function(error)
							   {
							   		alert("Error: " + error);
							   }
				});
				this.closeInputList();
	    	}
	    	else{
	    		alert('No hay transacciones a guardar');
	    	}
	    } 

	    /**
		 *	Metodo que devuelve el json de la lista de inputs.
		 *
		 *  @return Json de la lista de inputs.
 		 */
	    this.obtainInputList = function() {
	    	var inputList = new Array();
	        _.each(this.inputList, function(currentInput){
	        	inputList.push( currentInput.toObject() );
	        });
	        return inputList;
	    }

	    /**
	     *	Refresco lista de inputs.
	     */
	    this.refreshInputList = function(){
	    	this._inputListContainer.html(_.template(this.templateInputList, {inputs : this.inputList}));
	    }

	    /**
	     *	Cierro lote.
	     *  Reinicio la lista de inputs, y cierro la ventana.
	     */
	    this.closeInputList = function(){
	    	this.inputList = new Array();
	    	this.refreshInputList();
	    }

	    // Listeners

	    // Usuario comienza un proceso de input.
		this._newInputButton.on('click', function(){
			self.currentInput = new Input();			// Creo nuevo input...
			self.setNewInputId();						// ... seteo id del nuevo input...
			var articleId = self._articleId.val();		// ... obtengo el id del articulo seleccionado...
	        self.currentInput.setArticleId(articleId);	// ... seteo el articulo...
			self.currentInput.retrieveArticleData();	// ... y traigo el detalle del articulo.
		});

		// Usuario confirma ingresar el input.
	    this._confirmButton.on('click', function(){
	   		self.insertInput();
	    });

		// Usuario confirma el lote (levanto json y mando a la controller).
		this._confirmBatchButton.on('click', function(){
			var objectInputList = self.obtainInputList();	// Obtengo el json de la lista de inputs.
			self.saveInputList(objectInputList);			// Guardo la lista de inputs en el servidor.
		});

	    // Usuario da click en el boton "Borrar" en un un input en la lista de inputs (ul.inputListContainer li).
	    this._inputListContainer.on('click', '.deleteButton', function(e){
	    	var inputId = $(e.currentTarget).parent().data('id');
	    	self.deleteInput(inputId);
	    });
	}

	// Creo nuevo listado de inputs (se comienza un lote).
	inputCollection = new InputCollection();
});