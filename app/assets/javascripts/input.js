var inputCollection; // Input list (lote).
var input;           // Input actual (a ingresar).
var staffId;
var inType;

$(document).ready(function(){
    /**
     *  Clase input.
     */
    function Input()
    {
        this._articleContainer  = $('#articleDetailContainer'); // Contenedor del detalle del artículo.
        this._prodContainer     = $('#productorasContainer');
        this._staffContainer    = $('#staffContainer');
        this._modalBackground   = $('.modalBackground');
        this._newInputContainer = $('#newInputPopup');          // Contenedor del nuevo input.
        this._confirmButton     = $('#confirmInput');        // Boton para confirmar insertar el input.
        this._articleId         = $('#articleInputId');         // Articulo relacionado.
        this._typeRadio         = $('input:radio[name=type]');  // Selector de tipo (venta, alquiler).
        this._amountContainer   = $('.amountContainer');        // Amount container.
        this._amountInput       = $('#selectedAmount');         // Amount input.
        this._formContainer     = $('#formContainer');          // Container of the form.
        this._selectedTrProd    = $('tr[id="prod"]');
        this._message           = $('')
        this.type               = $(_.find(this._typeRadio, function(type){ return $(type).prop('checked'); })).val();
        this.amount             = 0                             // Monto (por defecto).
        this.article;                                           // Articulo relacionado.
        this.staff;
        this.productora;
        this.id;                                                // Id (client side) del input.

        var self                = this;

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

        this.getStaffId = function() {
            return this.staff;
        }

        this.setStaffId = function(newStaffId) {
            this.staff = newStaffId;
        }

        this.getProductoraId = function() {
            return this.productora;
        }
        
        this.setProductoraId = function(prodId) {
            this.productora = prodId;
        }

        this.showProductoras = function() {
            this._prodContainer.show();
            this.disableConfirmButton();
        }

        this.hideProductoras = function() {
            this._prodContainer.hide();
        }

        this.showStaffContainer = function() {
            this._prodContainer.hide();
            this._staffContainer.show();
        }

        this.hideStaffContainer = function() {
            this._staffContainer.hide();
        }

        this.disableConfirmButton = function() {
            this._confirmButton.attr('disabled','disabled');
            this._confirmButton.addClass('disBtn');
        }

        this.enableConfirmButton = function() {
            this._confirmButton.attr('disabled', false);
            this._confirmButton.removeClass('disBtn');
        }

        /**
         *  Metodo encargado de mostrar o esconder el form container.
         *  (depende de el estado del artículo).
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

        this.makeConfirmClick = function(inputId, buttonIdToClick) {
            $(inputId).focus();
            
            $(inputId).keypress(function (e) {
                var key = e.which;
                if(key == 13) {
                    $(buttonIdToClick).click();
                    return false;  
                }
            });
        }

        /**
         *  Inserta {this} (no se esta usando, pero mantener para ingreso other_input).
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
                             'cash'    : self.getCash(),
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
         *  Traigo los detalles del artículo de {this}.
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
                            self._articleContainer.html(data);  // Muestro detalle del artículo seleccionado...
                            self.showFormContainer($('.articleData'));
                            self._modalBackground.show();       // ... y muestro popup de la venta.
                            self.makeConfirmClick('#selectedAmount', '#confirmInput');
                            var currentAmount = $('#selectedAmount').val();
                            self.setAmount(currentAmount);
                            
                            // Seteo el tipo para la impresion
                            if (inputCollection.inputList.length == 0 &&
                                $('.articleData').attr('class') != undefined) {
                                
                                inType = $('#type_rent').prop('checked') ? 'rent' : 'sale';
                            }

                            if ($('.articleData').attr('class') != undefined) {
                                if ($('#type_rent').prop('checked')) {
                                    
                                    if (inputCollection.inputList.length == 0) {
                                        self.showProductoras();
                                        self.hideStaffContainer();
                                    // Si no es el primer artículo entonces le seteo a todos el mismo vestuarista
                                    } else {
                                        self.setStaffId(staffId);
                                    }
                                } else {
                                    self.hideProductoras();
                                    self.hideStaffContainer();
                                }
                            }
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
         *  Traigo los vestuaristas dependiendo de la productora
         */
        this.retrieveStaffProductoras = function(){
            var productora_id = self.getProductoraId();
            if (productora_id != undefined) {
                $.ajax({
                    url      : '/staffs/fetch_staff_by_productora',
                    type     : "POST",
                    dataType : 'html',
                    data     : { 'productora_id' : productora_id},
                    success:function(data){
                        self._staffContainer.html(data);
                        self.showStaffContainer();
                        
                        $('#staffContainer .search').prepend('<button class="backBtn" type="btn" style="width: 20px; font-size: 12px; padding: 1px; cursor:pointer; margin: 1px;"><<</button>');
                        
                        self._backBtn           = $('.backBtn');
                        self._selectedTrStaff   = $('tr[id="staff"]');

                        self._selectedTrStaff.on('click', function() {
                            staffId = $(this).find('td[id="staffId"]').text();
                            self.setStaffId(staffId);
                            self.enableConfirmButton();
                            $('tr').css('color', 'black');
                            $(this).css('color','#2222aa');
                        });

                        self._backBtn.on('click', function() {
                            self.hideStaffContainer();
                            self.showProductoras();
                        });
                    }
                });
            }
        }

        this._selectedTrProd.on('click', function() {
            var productoraId = $(this).find('td[id="prodId"]').text();
            self.setProductoraId(productoraId);
            self.retrieveStaffProductoras();
        });

        /**
         *  Devuelve un objeto con los datos mas relevantes de {this}.
         *
         *  @return Objeto con los datos mas importantes de this.
         */
        this.toObject = function(){
            var obj     = {};
            obj.type    = this.type;
            obj.article = this.article;
            obj.amount  = this.amount;
            obj.cash    = this.cash;
            obj.percent = this.percent;
            obj.staff   = this.staff;
            return obj;
        }

        // Listeners

        // Usuario cambia artículo a referenciar.
        this._articleId.on('blur', function(e){
            var articleId = $(e.currentTarget).val();
            self.setArticleId(articleId);
        });

        // Usuario cambia tipo de input.
        this._typeRadio.on('change', function(e){
            var type = $(this).val();
            self.setType(type);

            // Seteo el tipo para la impresion
            if (inputCollection.inputList.length == 0) {
                inType = type;
            }

            if (type == 'rent') {
                if (inputCollection.inputList.length == 0) {
                    self.showProductoras();
                // Si no es el primer artículo entonces le seteo a todos el mismo vestuarista
                } else {
                    self.setStaffId(staffId);
                }
            } else {
                self.enableConfirmButton();
                self.hideProductoras();
                self.hideStaffContainer();
            }           
        });

        this._articleContainer.on('change', '#selectedAmount', function(e){
            var amountInput = $(e.currentTarget);
            var amount = amountInput.val();
            self.setAmount(amount);
        });
    }

    /**
     *  Coleccion de inputs. 
     */
    function InputCollection()
    {
        this.inputList           = new Array();               // Listado de inputs (lote) 
        this.currentInput;                                    // Input actual (el que esta en el popup).
        this.templateInputList   = $("#template-inputList").html();
        this.lastInputId         = 0;                         // Indice del ultimo input creado (puede haber sido borrado) del lote.

        this._articleId          = $('#articleInputId');      // Input text (codigo de barras) del artículo.
        this._newInputButton     = $('#newInputButton');      // Boton para agregar nuevo input popup (tb bindear cuando lee codigo de barras o da enter). 
        this._confirmButton      = $('#confirmInput');        // Boton para confirmar insertar el input.
        this._confirmBatchButton = $('#confirmBatchButton');  // Confirma agregar lote.
        this._newInputContainer  = $('#newInputPopup');       // Contenedor del nuevo input.
        this._inputListContainer = $('.inputCollectionTable'); // Contenedor de los inputs en el lote.
        this._deleteButton       = $('.deleteButton');        // Boton para borrar una venta (fila).
        this._modalBackground    = $('.modalBackground'); 

        var self                 = this;

        var printInputs = function(path) {
            newWin = window.open(path);
            newWin.onload = function(){
                var divToPrint      = newWin.document.getElementById('receiptContainer');
                var rent_disclaimer = '';

                if (inType == 'sale') {
                    newWin.document.write('<style>' + 
                                            '@media print{.center {text-align: center;} .left {text-align: left;} .right {text-align: right;} .size {width:200px; font-size:10px;} table {margin: 5px auto; width:180px; font-size:10px;}} ' +
                                          '</style>');
                } else {
                    newWin.document.write('<style>' + 
                                            '@media print{.center {text-align: center;} .left {text-align: left;} .right {text-align: right;} table {margin: 5px auto; width:100%;}} ' +
                                          '</style>');
                    // Disclaimer
                    rent_disclaimer = ('<p style="font-size:10px; text-align: justify;">Condiciones de alquiler:<br/>Para realizar el alquiler, el interesado deberá dejar en garantía cheque o efectivo por el monto total.<br/>Los artículos se darán en alquiler por un plazo de 15 días, cobrando por el mismo, un 30% más iva, sobre el precio de venta de los artículos.<br/>Vencido dicho plazo, la empresa se reserva el derecho de aumentar el porcentaje de cobro por concepto de alquiler.<br/>Los artículos deberán ser devueltos en las mismas condiciones que fueron entregados, de lo contrario deberán ser abonados en su totalidad</p>');
                }
                newWin.document.write(divToPrint.outerHTML + rent_disclaimer);
                newWin.print();
                newWin.close();
            }
        }

        /**
         *  Recibe un array de ids y los convierte en un array de parametros para enviar.
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
         *  Seteo el id del input, y dejo preparado el nuevo id.
         */
        this.setNewInputId = function() {
            self.currentInput.setId(this.lastInputId);
            this.lastInputId++; 
        }

        /**
         *  Metodo a cargo de borrar el input con el id dado por parametro. 
         *
         *  @param Id del input a ser borrado.
         */
        this.deleteInput = function(inputId){
            this.inputList = _.reject(this.inputList, function(currentInput){   // Borro el elemento de la lista...
                                    return currentInput.id == inputId;
                              });
            this.refreshInputList();                                            // ... y refresco la lista de inputs. 
        }

        /**
         *  Metodo para insertar un input en el lote.
         */
        this.insertInput = function() {
            this.currentInput.hideStaffContainer();
            var relatedArticle = $('.articleData');                     // Obtengo los datos del artículo... 
            this.currentInput.setArticle(relatedArticle);               // ... y seteo los datos del artículo en el input actual.
            var clonedInput    = $.extend(true, {}, this.currentInput); // Clono el objeto a guardar para evitar inconsistencias.  
            this.inputList.push(clonedInput);
            this._modalBackground.hide();
            this.refreshInputList();
        }

        /**
         *  Metodo encargado de salvar la lista de inputs al servidor.
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
                    error    : function(error)
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
         *  Metodo que devuelve el json de la lista de inputs.
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
         *  Refresco lista de inputs.
         */
        this.refreshInputList = function(){
            this._inputListContainer.find('tbody').html(_.template(this.templateInputList, {inputs : this.inputList}));
        }

        /**
         *  Cierro lote.
         *  Reinicio la lista de inputs, y cierro la ventana.
         */
        this.closeInputList = function(){
            this.inputList = new Array();
            this.refreshInputList();
        }

        // Listeners

        // Usuario comienza un proceso de input.
        this._newInputButton.on('click', function(){
            self.currentInput = new Input();            // Creo nuevo input...
            self.setNewInputId();                       // ... seteo id del nuevo input...
            var articleId = self._articleId.val();      // ... obtengo el id del artículo seleccionado...
            self.currentInput.setArticleId(articleId);  // ... seteo el artículo...
            self.currentInput.retrieveArticleData();    // ... y traigo el detalle del artículo.
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
                                    var objectInputList = self.obtainInputList();   // Obtengo el json de la lista de inputs.
                                    self.saveInputList(objectInputList);            // Guardo la lista de inputs en el servidor.
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
                // Esta dando click fuera del detalle del artículo, quiere cerrar el popup.
                $('.modalBackground').hide();
            }
        });
    }

    // Creo nuevo listado de inputs (se comienza un lote).
    inputCollection = new InputCollection();
});