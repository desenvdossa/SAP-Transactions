/*--------------------------------------------------------------------------------------------------
Data: 22/11/2020
Objeto: 20 - Recebimento
Descrição: Bloquear lançamentos onde não foi informada o pedido de compra com excessão dos convênios
------------------------------------------------------------------------------------------------*/

IF (@sObjTyp in ('20') AND @sTraTyp IN ('A'))
	BEGIN
		DECLARE @LineNumOPDNcrspc int = 
			(SELECT 
				MAX(visorder) +1
			FROM PDN1 T0
			INNER JOIN OPDN T1 ON T1.DocNum = T0.DocEntry
			WHERE T0.DOCENTRY = @sKeyVal
			AND ISNULL(T0.[BaseDocNum], '') = ''
			AND T1.DocTotal > 0
			) 
		IF (@LineNumOPDNcrspc > 0)					
			BEGIN
				SET @iErrorCode = -55;
				SET	@sErrorMessage = 'Recebimentos precisam de um pedido de compra como base'
				GOTO breakout
			END	
	END 
