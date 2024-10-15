/*--------------------------------------------------------------------------------------------------
Data: 15/03/2024
Objeto: 18 - Nota Fiscal de Entrada,
Descrição: Data de emissão do documento seja sempre igual ou inferior a data de lançamento.
------------------------------------------------------------------------------------------------*/
IF (@sObjTyp in ('18') AND @sTraTyp IN ('A', 'U'))
	BEGIN
		DECLARE @sTmp73 AS VARCHAR(MAX)
				SET @sTmp73 ='FALSE'

		SELECT @sTmp73 = 'TRUE' FROM OPCH T0
		WHERE T0.DocEntry = @sKeyVal AND T0.TaxDate > T0.DocDate 

				IF @sTmp73 = 'TRUE'				
					BEGIN
						SET @iErrorCode = -71 -- Código do erro é um nº negativo e refere-se ao nº da validação
						SET @sErrorMessage = 'A data de emissão do documento é maior que a data de lançamento'
					END
			
	END
