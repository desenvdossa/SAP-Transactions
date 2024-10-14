/*-------------------------------------------------------------------------------------------------------------------------------------
Autor: Gabriel dos Anjos
Data: 26/09/2022
Objeto: 17 - Pedido de Venda
Descrição: Bloquear, obrigatório o preenchimento do campo "Número da operação de transferência entre armazens" na linha do item
-------------------------------------------------------------------------------------------------------------------------------------*/

IF (@sObjTyp in ('17') AND @sTraTyp IN ('A', 'U'))
	BEGIN
			DECLARE @LineNumRDR1NuTrfArm int = 
				(SELECT 
					MAX(T0.visorder) +1
				FROM RDR1 T0
				WHERE T0.DOCENTRY = @sKeyVal
				AND (T0.CFOPCode = '6949' or T0.CFOPCode = '5949' or T0.CFOPCode = '5554' or T0.CFOPCode = '6554') --Apenas nesses códigos de operação 
				AND ISNULL(T0.U_GALI_NumTrfArm, '') = ''
				) 
			IF (@LineNumRDR1NuTrfArm > 0)					
				BEGIN
					SET @iErrorCode = -40;
					SET	@sErrorMessage = 'UPP :: O campo "Número da operação de transferência entre armazens" é obrigatório. Linha:' + cast(@LineNumRDR1NuTrfArm as varchar(10))
					GOTO breakout
				END	
	END	
