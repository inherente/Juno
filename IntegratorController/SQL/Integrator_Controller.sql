CREATE OR REPLACE PACKAGE Integrator_Controller is
    type cursorType is ref cursor; 
  /* TODO enter package declarations (types, exceptions, methods etc) here */
    procedure UPDATE_V3_IN_FLOW (
        p_option in MONITOR_AVANCE_V3_T3.DOCUMENT_TYPE %type 
    );

    procedure UPDATE_V3_T3_FLOW (
        p_option in MONITOR_AVANCE_V3_T3.DOCUMENT_TYPE %type 
    );

    function GET_ANYTHING (
        p_option in MONITOR_AVANCE_V3_T3.DOCUMENT_TYPE %type
    ) return number;
END;
/


CREATE OR REPLACE package body Integrator_Controller
is
    procedure UPDATE_V3_IN_FLOW (
        p_option in MONITOR_AVANCE_V3_T3.DOCUMENT_TYPE %type 
    ) is
    l_option number;
    begin
        delete from MONITOR_AVANCE_V3_IN;
        insert into MONITOR_AVANCE_V3_IN
        SELECT SYSDATE                                    AS Actualizacion,
               Queue_Name                                 AS Queue_Name   ,
               SUM( DECODE( Status, 'Processed', 1, 0 ) ) AS Procesado    ,
               SUM( DECODE( Status, 'Error'    , 1, 0 ) ) AS Errores      ,
               SUM( DECODE( Status, 'Review'   , 1, 0 ) ) AS Review,
               MIN( Created )                             AS Inicio       ,  
               MAX( Created )                             AS Ultimo       ,
               sysdate, user
        FROM EAI_OWNER.MX_EAI_Message_Log
        WHERE Created > TRUNC( SYSDATE )
            AND Direction = 'Inbound'
            AND Sequence  = 0
        GROUP BY Queue_Name
        ORDER BY Queue_Name;
        update MONITOR_AVANCE_V3_IN av set av.last_update_date = sysdate;
        update monitor_chart_catalog mc set mc.last_update_date = sysdate
        Where mc.Stored_procedured_Name = 'MONITOR.GET_V3_IN_FLOW';
        Commit;
    end UPDATE_V3_IN_FLOW;

    procedure UPDATE_V3_T3_FLOW (
        p_option in MONITOR_AVANCE_V3_T3.DOCUMENT_TYPE %type 
    )is
    l_option number;
    begin 
        delete from MONITOR_AVANCE_V3_T3;
        insert into MONITOR_AVANCE_V3_T3
        SELECT SYSDATE, Tipo_Docto,
		       SUM( SIBDB )                                 AS SIBDB_Tablas   ,
		       SUM( Created_Stg )                           AS Stage_In       ,
		       SUM( Processed_XML )                         AS Stage_XML      ,
		       SUM( Processed_Queue )                       AS Stage_Queue    ,
		       SUM( T3_In )                                 AS T3_In          ,
		       SUM( T3_Proc )                               AS T3_Proc        ,
		       sysdate                                      AS LAST_UPDATE    ,
		       user                                         AS LAST_UPDATE_BY
		FROM (       
		SELECT 'Entregas'                                   AS Tipo_Docto     ,
		       0                                            AS SIBDB          ,   
		       SUM( DECODE( Created_Stg    , NULL, 0, 1 ) ) AS Created_Stg    ,
		       SUM( DECODE( Processed_XML  , NULL, 0, 1 ) ) AS Processed_XML  ,
		       SUM( DECODE( Processed_Queue, NULL, 0, 1 ) ) AS Processed_Queue,
		       0                                            AS T3_In          ,
		       0                                            AS T3_Proc
		FROM EAI_OWNER.STG_DELIVERY
		WHERE Created_Stg > TRUNC( SYSDATE - 0 )
		UNION ALL
		SELECT 'Entregas'                                   AS Tipo_Docto     ,
		       COUNT( Row_ID )                              AS SIBDB          ,   
		       0                                            AS Created_Stg    ,
		       0                                            AS Processed_XML  ,
		       0                                            AS Processed_Queue,
		       0                                            AS T3_In          ,
		       0                                            AS T3_Proc        
		FROM EAI_OWNER.SIBDB_DELIVERY@V3EAI
		WHERE Created_Stg > TRUNC( SYSDATE - 0 )
		UNION ALL
		SELECT 'Entregas'                                   AS Tipo_Docto     ,
		       0                                            AS SIBDB          ,   
		       0                                            AS Created_Stg    ,
		       0                                            AS Processed_XML  ,
		       0                                            AS Processed_Queue,
		       COUNT( Factura )                             AS T3_In          ,
		       SUM( DECODE( TO_CHAR( Fecha_Proc_BATMD, 'YYYY' ),
				    TO_CHAR( SYSDATE         , 'YYYY' ), 1, 0 ) ) 
								    AS T3_Proc
		FROM T3.Entrega
		WHERE Fecha_Trn > TRUNC( SYSDATE - 0 )
		UNION ALL
		SELECT 'Facturas PROMPT'                            AS Tipo_Docto     ,
		       0                                            AS SIBDB          ,   
		       SUM( DECODE( Created_Stg    , NULL, 0, 1 ) ) AS Created_Stg    ,
		       SUM( DECODE( Processed_XML  , NULL, 0, 1 ) ) AS Processed_XML  ,
		       SUM( DECODE( Processed_Queue, NULL, 0, 1 ) ) AS Processed_Queue,
		       0                                            AS T3_In          ,
		       0                                            AS T3_Proc
		FROM EAI_OWNER.STG_INVOICE
		WHERE Created_Stg > TRUNC( SYSDATE - 0 )
		UNION ALL
		SELECT 'Facturas PROMPT'                            AS Tipo_Docto     ,
		       COUNT( Row_ID )                              AS SIBDB          ,   
		       0                                            AS Created_Stg    ,
		       0                                            AS Processed_XML  ,
		       0                                            AS Processed_Queue,
		       0                                            AS T3_In          ,
		       0                                            AS T3_Proc
		FROM EAI_OWNER.SIBDB_INVOICE@V3EAI
		WHERE Created_Stg > TRUNC( SYSDATE - 0 )
		UNION ALL
		SELECT 'Facturas PROMPT'                            AS Tipo_Docto     ,
		       0                                            AS SIBDB          ,   
		       0                                            AS Created_Stg    ,
		       0                                            AS Processed_XML  ,
		       0                                            AS Processed_Queue,
		       COUNT( Factura )                             AS T3_In          ,
		       SUM( DECODE( TO_CHAR( Fecha_Proc_BATMD, 'YYYY' ),
				    TO_CHAR( SYSDATE         , 'YYYY' ), 1, 0 ) ) 
								    AS T3_Proc
		FROM T3.Factura_General
		WHERE Fecha_Trn  > TRUNC( SYSDATE - 0 )
		  AND Tipo_Docto = 'Z003'
		UNION ALL
		SELECT 'Notas PROMPT'                               AS Tipo_Docto     ,
		       0                                            AS SIBDB          ,   
		       SUM( DECODE( Created_Stg    , NULL, 0, 1 ) ) AS Created_Stg    ,
		       SUM( DECODE( Processed_XML  , NULL, 0, 1 ) ) AS Processed_XML  ,
		       SUM( DECODE( Processed_Queue, NULL, 0, 1 ) ) AS Processed_Queue,
		       0                                            AS T3_In          ,
		       0                                            AS T3_Proc
		FROM EAI_OWNER.STG_CREDIT_NOTE
		WHERE Created_Stg > TRUNC( SYSDATE - 0 )
		UNION ALL
		SELECT 'Notas PROMPT'                               AS Tipo_Docto     ,
		       COUNT( Row_ID )                              AS SIBDB          ,   
		       0                                            AS Created_Stg    ,
		       0                                            AS Processed_XML  ,
		       0                                            AS Processed_Queue,
		       0                                            AS T3_In          ,
		       0                                            AS T3_Proc
		FROM EAI_OWNER.SIBDB_CREDIT_NOTE@V3EAI
		WHERE Created_Stg > TRUNC( SYSDATE - 0 )
		UNION ALL
		SELECT 'Notas PROMPT'                               AS Tipo_Docto     ,
		       0                                            AS SIBDB          ,   
		       0                                            AS Created_Stg    ,
		       0                                            AS Processed_XML  ,
		       0                                            AS Processed_Queue,
		       COUNT( Factura )                             AS T3_In          ,
		       SUM( DECODE( TO_CHAR( Fecha_Proc_BATMD, 'YYYY' ),
				    TO_CHAR( SYSDATE -0      , 'YYYY' ), 1, 0 ) ) 
								    AS T3_Proc
		FROM T3.Factura_General
		WHERE Fecha_Trn  > TRUNC( SYSDATE - 0 )
		  AND Tipo_Docto = 'Z004'
		UNION ALL
		SELECT 'Pagos'                                      AS Tipo_Docto     ,
		       0                                            AS SIBDB          ,   
		       SUM( DECODE( Created_Stg    , NULL, 0, 1 ) ) AS Created_Stg    ,
		       SUM( DECODE( Processed_XML  , NULL, 0, 1 ) ) AS Processed_XML  ,
		       SUM( DECODE( Processed_Queue, NULL, 0, 1 ) ) AS Processed_Queue,
		       0                                            AS T3_In          ,
		       0                                            AS T3_Proc
		FROM EAI_OWNER.STG_PAYMENT
		WHERE Created_Stg > TRUNC( SYSDATE - 0 )
		UNION ALL
		SELECT 'Pagos'                                      AS Tipo_Docto     ,
		       COUNT( Row_ID )                              AS SIBDB          ,   
		       0                                            AS Created_Stg    ,
		       0                                            AS Processed_XML  ,
		       0                                            AS Processed_Queue,
		       0                                            AS T3_In          ,
		       0                                            AS T3_Proc
		FROM EAI_OWNER.SIBDB_PAYMENT@V3EAI
		WHERE Created_Stg > TRUNC( SYSDATE - 0 )
		UNION ALL
		SELECT 'Pagos'                                      AS Tipo_Docto     ,
		       0                                            AS SIBDB          ,   
		       0                                            AS Created_Stg    ,
		       0                                            AS Processed_XML  ,
		       0                                            AS Processed_Queue,
		       COUNT(Pago_ID)                             AS T3_In          ,
		       SUM( DECODE( TO_CHAR( Fecha_Proc_BATMD, 'YYYY' ),
				    TO_CHAR( SYSDATE         , 'YYYY' ), 1, 0 ) ) 
								    AS T3_Proc
		FROM T3.PAGO
		WHERE Fecha_Trn > TRUNC( SYSDATE - 0 )
		UNION ALL
		SELECT 'Asignaciones'                               AS Tipo_Docto     ,
		       0                                            AS SIBDB          ,   
		       SUM( DECODE( Created_Stg    , NULL, 0, 1 ) ) AS Created_Stg    ,
		       SUM( DECODE( Processed_XML  , NULL, 0, 1 ) ) AS Processed_XML  ,
		       SUM( DECODE( Processed_Queue, NULL, 0, 1 ) ) AS Processed_Queue,
		       0                                            AS T3_In          ,
		       0                                            AS T3_Proc
		FROM EAI_OWNER.STG_PAYMENT_ALLOCATION
		WHERE Created_Stg > TRUNC( SYSDATE - 0 )
		UNION ALL
		SELECT 'Asignaciones'                               AS Tipo_Docto     ,
		       COUNT( Row_ID )                              AS SIBDB          ,   
		       0                                            AS Created_Stg    ,
		       0                                            AS Processed_XML  ,
		       0                                            AS Processed_Queue,
		       0                                            AS T3_In          ,
		       0                                            AS T3_Proc
		FROM EAI_OWNER.SIBDB_PAYMENT_ALLOCATION@V3EAI
		WHERE Created_Stg > TRUNC( SYSDATE - 0 )
		UNION ALL
		SELECT 'Asignaciones'                               AS Tipo_Docto     ,
		       0                                            AS SIBDB          ,   
		       0                                            AS Created_Stg    ,
		       0                                            AS Processed_XML  ,
		       0                                            AS Processed_Queue,
		       COUNT(Asignacion_ID)                         AS T3_In          ,
		       SUM( DECODE( TO_CHAR( Fecha_Proc_BATMD, 'YYYY' ),
				    TO_CHAR( SYSDATE         , 'YYYY' ), 1, 0 ) ) 
								    AS T3_Proc
		FROM T3.ASIGNACION_PAGO
		WHERE Fecha_Trn > TRUNC( SYSDATE - 0 )
		UNION ALL
		SELECT 'Clientes'                                   AS Tipo_Docto     ,
		       0                                            AS SIBDB          ,   
		       SUM( DECODE( Created_Stg    , NULL, 0, 1 ) ) AS Created_Stg    ,
		       SUM( DECODE( Processed_XML  , NULL, 0, 1 ) ) AS Processed_XML  ,
		       SUM( DECODE( Processed_Queue, NULL, 0, 1 ) ) AS Processed_Queue,
		       0                                            AS T3_In          ,
		       0                                            AS T3_Proc
		FROM EAI_OWNER.STG_CUSTOMER_UPDATE
		WHERE Created_Stg > TRUNC( SYSDATE - 0 )
		UNION ALL
		SELECT 'Clientes'                                   AS Tipo_Docto     ,
		       0                                            AS SIBDB          ,   
		       SUM( DECODE( Stg.Created_Stg    , NULL, 0, 1 ) ) 
								    AS Created_Stg    ,
		       SUM( DECODE( Stg.Processed_XML  , NULL, 0, 1 ) ) 
								    AS Processed_XML  ,
		       SUM( DECODE( Stg.Processed_Queue, NULL, 0, 1 ) ) 
								    AS Processed_Queue,
		       0                                            AS T3_In          ,
		       0                                            AS T3_Proc
		FROM EAI_OWNER.STG_CUSTOMER_CREATE Stg,
		     SIEBEL.S_ORG_EXT@V3           Cte
		WHERE Stg.Created_Stg > TRUNC( SYSDATE - 0 )
		  AND Stg.Row_ID      = Cte.Row_ID
		  AND Cte.Ou_Num     IS NOT NULL
		UNION ALL
		SELECT 'Clientes'                                   AS Tipo_Docto     ,
		       COUNT( Row_ID )                              AS SIBDB          ,   
		       0                                            AS Created_Stg    ,
		       0                                            AS Processed_XML  ,
		       0                                            AS Processed_Queue,
		       0                                            AS T3_In          ,
		       0                                            AS T3_Proc        
		FROM EAI_OWNER.SIBDB_CUSTOMER_UPDATE@V3EAI
		WHERE Created_Stg > TRUNC( SYSDATE - 0 )
		UNION ALL
		SELECT 'Clientes'                                   AS Tipo_Docto     ,
		       COUNT( Stg.Row_ID )                          AS SIBDB          ,   
		       0                                            AS Created_Stg    ,
		       0                                            AS Processed_XML  ,
		       0                                            AS Processed_Queue,
		       0                                            AS T3_In          ,
		       0                                            AS T3_Proc        
		FROM EAI_OWNER.SIBDB_CUSTOMER_CREATE@V3EAI Stg, 
		     SIEBEL.S_ORG_EXT@V3EAI                Cte
		WHERE Stg.Created_Stg > TRUNC( SYSDATE - 0 )
		  AND Stg.Row_ID      = Cte.Row_ID
		  AND Cte.Ou_Num     IS NOT NULL
		UNION ALL
		SELECT 'Clientes'                                   AS Tipo_Docto     ,
		       0                                            AS SIBDB          ,   
		       0                                            AS Created_Stg    ,
		       0                                            AS Processed_XML  ,
		       0                                            AS Processed_Queue,
		       COUNT(Cliente_V3)                            AS T3_In          ,
		       SUM( DECODE( TO_CHAR( Fecha_Proc_BATMD, 'YYYY' ),
				    TO_CHAR( SYSDATE         , 'YYYY' ), 1, 0 ) ) 
								    AS T3_Proc
		FROM T3.MOV_CLIENTE
		WHERE Fecha_Syncr > TRUNC( SYSDATE - 0 )
		)
        GROUP BY Tipo_Docto
		ORDER BY Tipo_Docto;
        update MONITOR_AVANCE_V3_T3 av set av.last_update_date = sysdate;
        update monitor_chart_catalog mc set mc.last_update_date = sysdate
        Where mc.Stored_procedured_Name = 'MONITOR.GET_V3_T3_FLOW';
        Commit;

    end UPDATE_V3_T3_FLOW;

    function GET_ANYTHING (
        p_option MONITOR_AVANCE_V3_T3.DOCUMENT_TYPE %type
    ) return number is
        l_return_value number ;
        l_cursor cursorType;
    begin
        l_return_value := 1;
        open l_cursor for 
        select mm.last_document_date from t3.MONITOR_AVANCE_V3_T3 mm;
        select count(1) into l_return_value from t3.MONITOR_AVANCE_V3_T3 mm;

        return l_return_value ;
    end;
end; -- end of package body
/
