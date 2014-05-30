var input;			 // Input actual (a ingresar).
var inputCollection; // Input list (lote).

$(document).ready(function(){
	/**
	 *	Clase input.
	 */
	function Input()
	{
		this._articleContainer  = $('#articleDetailContainer');	// Contenedor del detalle del articulo.
		this._modalBackground   = $('.modalBackground');
		this._newInputContainer = $('#newInputPopup'); 			// Contenedor del nuevo input. 	    
		this._articleId         = $('#articleInputId');			// Articulo relacionado.
		this._typeRadio         = $('input:radio[name=type]');	// Selector de tipo (venta, alquiler).
		this._amountContainer   = $('.amountContainer');        // Amount container.
		this._amountInput       = $('#selectedAmount');         // Amount input.
		this._formContainer     = $('#formContainer');			// Container of the form.

		this.type  	 		    = $(_.find(this._typeRadio, function(type){ return $(type).prop('checked'); })).val();
	    this.amount 		    = 0 							// Monto (por defecto).
	    this.article;											// Articulo relacionado.
	    this.id;												// Id (client side) del input.

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

	    this.getCash = function() {
	    	return this.cash;
	    }

	    this.getPercent = function() {
	    	return parseInt(this.percent, 10);
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

	    /**
	     *	Metodo encargado de mostrar o esconder el form container.
	     *	(depende de el estado del articulo).
	     */
	    this.showFormContainer = function(relatedArticle){
	    	if (relatedArticle.data('status') == null) {
	    		this._formContainer.hide();
	    	}
	    	else{
	    		this._formContainer.show();
	    	}
	    	
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
							 'amount'  : self.getAmount(), 
							 'cash'	   : self.getCash(),
							 'percent' : self.getPercent()
							},
				success:function(data){
					self._articleContainer.html(data);
				},
	            error: function(XMLHttpRequest, textStatus, errorThrown) {
	            	new Messi('Error: ' + errorThrown + ', ' + textStatus, {title: 'Información', modal: true});
	            } 
			});
	    }

	    /**
	     *	Traigo los detalles del articulo de {this}.
	     */
	    this.retrieveArticleData = function(){
	    	if (this.hasArticle()) {
	    		var currentLotInput = _.find(inputCollection.inputList, function(cInput){ return cInput.article == self.getArticleId(); });
				if (isUndefined(currentLotInput)) {
					$.ajax({
						url      : '/articles/fetch_data',
						type     : "POST",
						dataType : 'html',
						data     : { 'id' : self.getArticleId() },
						success:function(data){
							self._articleContainer.html(data); 	// Muestro detalle del articulo seleccionado...
							self.showFormContainer($('.articleData'));
							self._modalBackground.show();		// ... y muestro popup de la venta.

							var currentAmount = $('#selectedAmount').val();
							self.setAmount(currentAmount);
						}
					});
				}
				else{
					new Messi('El artículo esta ingresado en el lote actual', {title: 'Información', modal: true});
				}
			}
			else{
				new Messi('El ingreso no tiene un artículo relacionado', {title: 'Información', modal: true});
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
	    	obj.cash    = this.cash;
	    	obj.percent = this.percent;
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

	    this._articleContainer.on('change', '#selectedAmount', function(e){
	    	var amountInput = $(e.currentTarget);
	    	var amount = amountInput.val();
		    self.setAmount(amount);
	    });

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
		this._inputListContainer = $('.inputCollectionTable'); // Contenedor de los inputs en el lote.
		this._deleteButton       = $('.deleteButton');        // Boton para borrar una venta (fila).
		this._modalBackground    = $('.modalBackground'); 

		var self                 = this;

		var printInputs = function(path) {
		    newWin = window.open(path);
		    newWin.onload = function(){
		    	var divToPrint = newWin.document.getElementById('receiptContainer');
		    	newWin.document.write('<style>' + 
	                            		'@media print{.center {text-align: center;} .left {text-align: left;} .right {text-align: right;} .size {width:275px;} table {margin: 0 auto;width:275px;}} ' +
	                        		  '</style>');
		    	console.log(divToPrint);
		    	newWin.document.write(divToPrint.outerHTML);
				newWin.print();
				newWin.close();
			}
		}

		/**
		 *	Recibe un array de ids y los convierte en un array de parametros para enviar.
		 *
		 *  @param Array de ids.
		 *  @return Parametro para ser enviado.
		 */
		this.createParameterList = function(inputIds){
			var paramString = "";
			for(var i in inputIds){
				var separator = (i > 0) ? "&" : "";
				paramString += separator + "inputs[]=" + inputIds[i].toString()
			}
			return paramString;
		}

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
	        this._modalBackground.hide();
	        this.refreshInputList();
	    }

	    /**
	     *	Metodo encargado de salvar la lista de inputs al servidor.
	     *
	     *  @param Json de la lista de inputs a guardar.
	     */
	    this.saveInputList = function(objectInputList){
	    	if (this.inputList.length > 0) {
	    		$.ajax({
					url      : '/inputs/bulk_save',
					type     : "POST",
					data     : {inputList : objectInputList},
					success  : function(response)
							   {
							   		if (response.message.result === 'ok') {
							   			// Se salvo correctamente el listado asi que borro la lista de inputs
							   			self.closeInputList();
							   		}
							   		new Messi(response.message.message, {title: 'Información', modal: true});
							   		var param = self.createParameterList(response.message.saved_inputs);
							   		
							   		if (response.message.result === 'ok') {
							   			printInputs('/inputs/batch_receipt?' + param);
							   		}
							   },
					error 	 : function(error)
							   {
							   		new Messi("Error: " + error, {title: 'Información', modal: true});
							   }
				});
	    	}
	    	else{
	    		new Messi('No hay transacciones a guardar', {title: 'Información', modal: true});
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
	    	this._inputListContainer.find('tbody').html(_.template(this.templateInputList, {inputs : this.inputList}));
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
	   		// Reseteando el input 
	   		self._articleId.val('');
	   		focusCursorOnInput();
	    });

		// Usuario confirma el lote (levanto json y mando a la controller).
		this._confirmBatchButton.on('click', function(){
			new Messi('Desea salvar las transacciones?', 
						  {title: '',
						   	buttons: [{id: 0, label: 'Yes', val: 'Y'}, 
						   		     {id: 1, label: 'No', val: 'N'}], 
						   	callback: function(val) { 
						   		if (val === 'Yes') {
						   			var objectInputList = self.obtainInputList();	// Obtengo el json de la lista de inputs.
									self.saveInputList(objectInputList);			// Guardo la lista de inputs en el servidor.
		    					}
						   	}
						  });
		});

	    // Usuario da click en el boton "Borrar" en un un input en la lista de inputs (ul.inputListContainer li).
	    this._inputListContainer.on('click', '.deleteButton', function(e){
	    	new Messi('Desea borrar el artículo del lote?', 
						  {title: '',
						   	buttons: [{id: 0, label: 'Yes', val: 'Y'}, 
						   		     {id: 1, label: 'No', val: 'N'}], 
						   	callback: function(val) { 
						   		if (val === 'Yes') {
							   		var inputId = $(e.currentTarget).parent().data('id');
		    						self.deleteInput(inputId);
		    					}
						   	}
						  });
	    });

	    $('.modalBackground:not(.modalBackground#newInputPopup)').on('click', function(e){
	    	if (e.target === e.currentTarget) {
	    		// Esta dando click fuera del detalle del articulo, quiere cerrar el popup.
	    		$('.modalBackground').hide();
	    	}
	    });
	}

	// Creo nuevo listado de inputs (se comienza un lote).
	inputCollection = new InputCollection();
});