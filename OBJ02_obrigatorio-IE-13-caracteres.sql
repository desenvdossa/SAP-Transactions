/*--------------------------------------------------------------------------------------------------
Data: 13/06/2024
Objeto: 2 - Cadastro de PN, 
Descrição: Obrigar a Inscrição estadual ter 13 caracteres para fornecedores de MG
----------------------------------------------------------------------------------------------------*/
IF (@sObjTyp in ('2') AND @sTraTyp IN ('A', 'U'))
	BEGIN
		DECLARE @MGinscrOCRD AS VARCHAR(MAX)
		SET @MGinscrOCRD = 'FALSE'
		
		SELECT	@MGinscrOCRD = 'TRUE'
				FROM OCRD T0
				WHERE T0.[CardCode] = @sKeyVal 
				AND T0.[State1] = 'MG'
				AND U_UPTxIdIE <> 'Isento'
				AND LEN (T0.[U_UPTxIdIE]) < 13
				
		IF (@MGinscrOCRD = 'TRUE')					
			BEGIN
				SET @iErrorCode = -75;
				SET	@sErrorMessage = 'INSCRIÇÃO ESTADIUAL menor que 13 caracteres para fornecedor de MG'
				GOTO breakout
			END	
	END
