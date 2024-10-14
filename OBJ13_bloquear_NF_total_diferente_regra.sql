/*--------------------------------------------------------------------------------------------------
Data: 31/05/2023
Objeto: 13 - Nota Fiscal de Saída, 
Descrição: Não permitir incluir NF se total for diferente da regra de distribuição. 
------------------------------------------------------------------------------------------------*/

IF (@sObjTyp in ('13') AND @sTraTyp IN ('A'))
	BEGIN
		DECLARE @LineNumINV1SDistr int = 
			(SELECT 
				MAX(visorder) +1
			FROM INV1 T0
			INNER JOIN OINV T1 ON T1.DocEntry = T1.DocEntry
			INNER JOIN MDR1 T2 ON T0.OcrCode = T2.OcrCode
			INNER JOIN OOCR T3 ON T2.PrcCode = T3.OcrCode
			WHERE T0.DOCENTRY = @sKeyVal
			AND T0.Price != T2.OcrTotal
			) 
		IF (@LineNumINV1SDistr > 0)					
			BEGIN
				SET @iErrorCode = -1;
				SET	@sErrorMessage = 'Valor total do documento é diferente do definido na regra de distribuição.'+ cast(@LineNumINV1SDistr as varchar(20))
				GOTO breakout
			END	
		END
