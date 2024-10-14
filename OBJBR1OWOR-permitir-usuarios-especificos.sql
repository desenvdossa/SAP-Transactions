/*--------------------------------------------------------------------------------------------------
Data: 12/02/2024
Objeto: BR1POWOR - ORDEM DE PRODUÇÃO 
Descrição: Bloquear a alteração do status da OP de Liberado para Planejado se for algum usuáriuo diferente do controlador de produção.
------------------------------------------------------------------------------------------------*/

IF (@sObjTyp in ('BR1POWOR') AND @sTraTyp IN ('U') AND (@iErrorCode = 0))
	BEGIN 
		DECLARE @LineNumOWORStat int = 
			(SELECT 
				T0.DocEntry
			FROM [dbo].[@UPR_OWOR] T0
			INNER JOIN OUSR T1 ON T0.UserSign = T1.INTERNAL_K 
			--INNER JOIN (SELECT MAX(T3.UpdateTime) VALOR FROM [dbo].[@UPR_AWOR] T3 WHERE T3.DOCENTRY = @sKeyVal) AS T2 ON T0.DocNum = T2.DocNum
			INNER JOIN (SELECT T3.UpdateTime, T3.DocNum, T3.U_UPStatus FROM [dbo].[@UPR_AWOR] T3 WHERE T3.DOCENTRY = @sKeyVal AND T3.UpdateTime = (SELECT MAX(T4.UpdateTime) VALOR FROM [dbo].[@UPR_AWOR] T4 WHERE T4.DOCENTRY = @sKeyVal)) AS T2 ON T0.DocNum = T2.DocNum
			WHERE T0.DOCENTRY = @sKeyVal
			AND T2.U_UPStatus = 'R'
			AND T0.U_UPStatus = 'L'
			AND ( (Select top 1 UserCode from USR5 where SessionID=@@spid order by Date desc,Time desc) NOT IN ('USUARIO1,USUARIO2,...,USUARIOn') )
			
			) 
		IF (@LineNumOWORStat > 0)					
			BEGIN
				SET @iErrorCode = -72
				SET	@sErrorMessage = 'Não é possível alterar status da OP de Liberado para Planejado sem ser o controlador de produção | Usuário: ' + cast((Select top 1 UserCode from USR5 where SessionID=@@spid order by Date desc,Time desc) as varchar(10))
				GOTO breakout
			END	
	END
