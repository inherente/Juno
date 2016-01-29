CREATE OR REPLACE PACKAGE "MONITOR" is
    type cursorType is ref cursor; 
  /* TODO enter package declarations (types, exceptions, methods etc) here */
    procedure UPDATE_V3_IN_FLOW (
        p_option in MONITOR_AVANCE_V3_T3.DOCUMENT_TYPE %type 
    );

    procedure UPDATE_V3_T3_FLOW (
        p_option in MONITOR_AVANCE_V3_T3.DOCUMENT_TYPE %type 
    );

    procedure UPDATE_T3_OUT_FLOW (
        p_option in MONITOR_AVANCE_V3_T3.DOCUMENT_TYPE %type 
    );

    procedure UPDATE_V3_SAP_FLOW (
        p_option in MONITOR_AVANCE_V3_T3.DOCUMENT_TYPE %type 
    );

    procedure GET_V3_IN_FLOW (
        p_option in MONITOR_AVANCE_V3_T3.DOCUMENT_TYPE %type ,
        p_value out cursorType,
        p_row out number
    );

    procedure GET_V3_SAP_FLOW (
        p_option in MONITOR_AVANCE_V3_T3.DOCUMENT_TYPE %type ,
        p_value out cursorType,
        p_row out number
    );

    procedure GET_V3_T3_FLOW (
        p_option in MONITOR_AVANCE_V3_T3.DOCUMENT_TYPE %type ,
        p_value out cursorType,
        p_row out number
    );

    procedure GET_T3_OUT_FLOW (
        p_option in MONITOR_AVANCE_T3_OUT.DOCUMENT_TYPE %type ,
        p_value out cursorType,
        p_row out number
    );

    procedure GET_CHART_CATALOG (
        p_option in MONITOR_AVANCE_V3_T3.DOCUMENT_TYPE %type,
        p_value out cursorType
    );

    function GET_ANYTHING (
        p_option in MONITOR_AVANCE_V3_T3.DOCUMENT_TYPE %type
    ) return number;
END;
/


CREATE OR REPLACE package body "MONITOR"
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

    procedure UPDATE_T3_OUT_FLOW (
        p_option in MONITOR_AVANCE_V3_T3.DOCUMENT_TYPE %type 
    )is 
    l_option number;
    l_last_Factura varchar2 (1024);
    l_last_Dt_Factura varchar2 (1024);
    l_last_Nota varchar2 (1024);
    l_last_Dt_Nota varchar2 (1024);
    l_last_Factura_Agr varchar2 (1024);
    l_last_Dt_Factura_Agr varchar2 (1024);
    l_last_Pago varchar2 (1024);
    l_last_Dt_Pago varchar2 (1024);
    l_last_Asignacion varchar2 (1024);
    l_last_Dt_Asignacion varchar2 (1024);
    l_last_Asignacion_Agr varchar2 (1024);
    l_last_Dt_Asignacion_Agr varchar2 (1024);

    begin
        update MONITOR_AVANCE_T3_OUT av set av.last_update_date = sysdate;
        delete from MONITOR_AVANCE_T3_OUT;

        SELECT Ft.Factura, Doc.procesado into l_last_Factura, l_last_Dt_Factura 
        FROM T3.Fact_T3 Ft,
        (
            SELECT Doc_Id ,Procesado
         -- rank() over (partition by Doc_Id order by xml.procesado ) rnk
            FROM EAI.Fact_Out XML
            order by Procesado desc
        ) Doc
        WHERE Ft.Doc_Id = Doc.Doc_Id
        and rownum = 1;

        SELECT Ft.Factura, Doc.procesado into l_last_Nota, l_last_Dt_Nota 
        FROM T3.Nota_T3 Ft,
        (
            SELECT Doc_Id ,Procesado
         -- rank() over (partition by Doc_Id order by xml.procesado ) rnk
            FROM EAI.Fact_Out XML
            order by Procesado desc
        ) Doc
        WHERE Ft.Doc_Id = Doc.Doc_Id
        and rownum = 1;

        SELECT Ft.Factura, Doc.procesado into l_last_Factura, l_last_Dt_Factura 
        FROM T3.Fact_T3 Ft,
        (
            SELECT Doc_Id ,Procesado
         -- rank() over (partition by Doc_Id order by xml.procesado ) rnk
            FROM EAI.Fact_Out XML
            order by Procesado desc
        ) Doc
        WHERE Ft.Doc_Id = Doc.Doc_Id
        and rownum = 1;

        select max (xml.procesado) into l_last_Asignacion_Agr
        from T3.Asigna_Agr_T3 Doc,EAI.Fact_Out XML
        WHERE Doc.Doc_ID LIKE TO_CHAR( SYSDATE , 'YYYYMMDD' ) || '%'
        AND Doc.Doc_ID = XML.Doc_ID(+);

        insert into MONITOR_AVANCE_T3_OUT        
        SELECT
		       SYSDATE        AS Fecha   ,
		       Doc_Type       AS Doc_Type,
		       to_Char(SUM( T3_Out  ) ) AS T3_Out  ,
		       to_Char(SUM( T3_XML  ) ) AS T3_XML  ,
		       to_Char(SUM( Enviado ) ) AS Enviado ,
		       sysdate        AS last_update_date,
		       user           as last_update_by
		FROM (
		       SELECT 
			      'Factura Individual'                 AS Doc_Type,
			      1                                    AS T3_Out  ,
			      DECODE( Doc.Doc_ID   , NULL, 0, 1 )  AS T3_XML  ,
			      DECODE( XML.Procesado, NULL, 0, 1 )  AS Enviado ,
                  XML.Procesado                        as Fecha
			  FROM T3.Fact_T3       Doc,
			       EAI.Fact_Out     XML
			  WHERE Doc.Doc_ID LIKE TO_CHAR( SYSDATE , 'YYYYMMDD' ) || '%'
			    AND Doc.Doc_ID = XML.Doc_ID(+)
		       UNION ALL      
		       SELECT 
			      'Nota Individual'                    AS Doc_Type,
			      1                                    AS T3_Out  ,
			      DECODE( Doc.Doc_ID   , NULL, 0, 1 )  AS T3_XML  ,
			      DECODE( XML.Procesado, NULL, 0, 1 )  AS Enviado ,
                  XML.Procesado                        as Fecha
			  FROM T3.Nota_T3       Doc,
			       EAI.Nota_Out     XML
			  WHERE Doc.Doc_ID LIKE TO_CHAR( SYSDATE , 'YYYYMMDD' ) || '%'
			    AND Doc.Doc_ID = XML.Doc_ID(+)
		       UNION ALL      
		       SELECT 
			      'Factura Agrupada'                   AS Doc_Type,
			      1                                    AS T3_Out  ,
			      DECODE( Doc.Doc_ID   , NULL, 0, 1 )  AS T3_XML  ,
			      DECODE( XML.Procesado, NULL, 0, 1 )  AS Enviado ,
                  XML.Procesado                        as Fecha
			  FROM T3.Fact_Agr_T3   Doc,
			       EAI.Fact_Agr_Out XML
			  WHERE Doc.Doc_ID LIKE TO_CHAR( SYSDATE, 'YYYYMMDD' ) || '%'
			    AND Doc.Doc_ID = XML.Doc_ID(+)
		       UNION ALL      
		       SELECT 
			      'Pago Individual'                    AS Doc_Type,
			      1                                    AS T3_Out  ,
			      DECODE( Doc.Doc_ID   , NULL, 0, 1 )  AS T3_XML  ,
			      DECODE( XML.Procesado, NULL, 0, 1 )  AS Enviado ,
                  XML.Procesado                        as Fecha
			  FROM T3.Pago_T3   Doc,
			       EAI.Pago_Out XML
			  WHERE Doc.Doc_ID LIKE TO_CHAR( SYSDATE , 'YYYYMMDD' ) || '%'
			    AND Doc.Doc_ID = XML.Doc_ID(+)
		       UNION ALL      
		       SELECT 
			      'Asignacion Individual'               AS Doc_Type,
			      1                                    AS T3_Out  ,
			      DECODE( Doc.Doc_ID   , NULL, 0, 1 )  AS T3_XML  ,
			      DECODE( XML.Procesado, NULL, 0, 1 )  AS Enviado ,
                  XML.Procesado                        as Fecha
			  FROM T3.Asigna_T3   Doc,
			       EAI.Asigna_Out XML
			  WHERE Doc.Doc_ID LIKE TO_CHAR( SYSDATE , 'YYYYMMDD' ) || '%'
			    AND Doc.Doc_ID = XML.Doc_ID(+)
		       UNION ALL      
		       SELECT 
			      'Asignacion Agrupada'                AS Doc_Type,
			      1                                    AS T3_Out  ,
			      DECODE( Doc.Doc_ID   , NULL, 0, 1 )  AS T3_XML  ,
			      DECODE( XML.Procesado, NULL, 0, 1 )  AS Enviado ,
                  XML.Procesado                        as Fecha
			  FROM T3.Asigna_Agr_T3   Doc,
			       EAI.Asigna_Agr_Out XML
			  WHERE Doc.Doc_ID LIKE TO_CHAR( SYSDATE , 'YYYYMMDD' ) || '%'
			    AND Doc.Doc_ID = XML.Doc_ID(+)
		     )      
		GROUP BY Doc_Type
        ORDER BY Doc_Type;

        update MONITOR_AVANCE_T3_OUT av set av.last_update_date = sysdate;
        update monitor_chart_catalog mc set mc.last_update_date = sysdate
        Where mc.Stored_procedured_Name = 'MONITOR.GET_T3_OUT_FLOW';
        Commit;

    end UPDATE_T3_OUT_FLOW;

    procedure UPDATE_V3_SAP_FLOW (
        p_option in MONITOR_AVANCE_V3_T3.DOCUMENT_TYPE %type 
    )is 
    l_option number;
    begin

        delete from MONITOR_AVANCE_V3_SAP;
        insert into MONITOR_AVANCE_V3_SAP
        SELECT SYSDATE, Tipo_Docto,
               SUM( SIBDB )                                 AS SIBDB_Tablas   ,
               SUM( Created_Stg )                           AS Stage_In       ,
               SUM( Processed_XML )                         AS Stage_XML      ,
               SUM( Processed_Queue )                       AS Stage_Queue    ,
               sysdate, user
        FROM (       
        SELECT 'Movtos Producto'                            AS Tipo_Docto     ,
               0                                            AS SIBDB          ,   
               SUM( DECODE( Created_Stg    , NULL, 0, 1 ) ) AS Created_Stg    ,
               SUM( DECODE( Processed_XML  , NULL, 0, 1 ) ) AS Processed_XML  ,
               SUM( DECODE( Processed_Queue, NULL, 0, 1 ) ) AS Processed_Queue,
               0                                            AS V3_In          ,
               0                                            AS T3_In
        FROM EAI_OWNER.STG_PRODUCT_MOVEMENT
        WHERE Created_Stg > TRUNC( SYSDATE - 0 )
        UNION ALL
        SELECT 'Movtos Producto'                            AS Tipo_Docto     ,
               COUNT( Row_ID )                              AS SIBDB          ,   
               0                                            AS Created_Stg    ,
               0                                            AS Processed_XML  ,
               0                                            AS Processed_Queue,
               0                                            AS V3_In          ,
               0                                            AS T3_In
        FROM EAI_OWNER.SIBDB_PRODUCT_MOVEMENT@V3EAI
        WHERE Created_Stg > TRUNC( SYSDATE - 0 )
        UNION ALL
        SELECT 'Ordenes Internas'                           AS Tipo_Docto     ,
               0                                            AS SIBDB          ,   
               SUM( DECODE( Created_Stg    , NULL, 0, 1 ) ) AS Created_Stg    ,
               SUM( DECODE( Processed_XML  , NULL, 0, 1 ) ) AS Processed_XML  ,
               SUM( DECODE( Processed_Queue, NULL, 0, 1 ) ) AS Processed_Queue,
               0                                            AS V3_In          ,
               0                                            AS T3_In
        FROM EAI_OWNER.STG_INTERNAL_ORDER
        WHERE Created_Stg > TRUNC( SYSDATE - 0 )
        UNION ALL
        SELECT 'Ordenes Internas'                           AS Tipo_Docto     ,
               COUNT( Row_ID )                              AS SIBDB          ,   
               0                                            AS Created_Stg    ,
               0                                            AS Processed_XML  ,
               0                                            AS Processed_Queue,
               0                                            AS V3_In          ,
               0                                            AS T3_In
        FROM EAI_OWNER.SIBDB_INTERNAL_ORDER@V3EAI
        WHERE Created_Stg > TRUNC( SYSDATE - 0 )
        UNION ALL
        SELECT 'Depositos Bancarios'                        AS Tipo_Docto     ,
               0                                            AS SIBDB          ,   
               SUM( DECODE( Created_Stg    , NULL, 0, 1 ) ) AS Created_Stg    ,
               SUM( DECODE( Processed_XML  , NULL, 0, 1 ) ) AS Processed_XML  ,
               SUM( DECODE( Processed_Queue, NULL, 0, 1 ) ) AS Processed_Queue,
               0                                            AS V3_In          ,
               0                                            AS T3_In
        FROM EAI_OWNER.STG_BANK_DEPOSIT
        WHERE Created_Stg > TRUNC( SYSDATE - 0 )
        UNION ALL
        SELECT 'Depositos Bancarios'                        AS Tipo_Docto     ,
               COUNT( Row_ID )                              AS SIBDB          ,   
               0                                            AS Created_Stg    ,
               0                                            AS Processed_XML  ,
               0                                            AS Processed_Queue,
               0                                            AS V3_In          ,
               0                                            AS T3_In
        FROM EAI_OWNER.SIBDB_BANK_DEPOSIT@V3EAI
        WHERE Created_Stg > TRUNC( SYSDATE - 0 )
        UNION ALL
        SELECT 'Pedidos'                                    AS Tipo_Docto     ,
               0                                            AS SIBDB          ,   
               SUM( DECODE( Created_Stg    , NULL, 0, 1 ) ) AS Created_Stg    ,
               SUM( DECODE( Processed_XML  , NULL, 0, 1 ) ) AS Processed_XML  ,
               SUM( DECODE( Processed_Queue, NULL, 0, 1 ) ) AS Processed_Queue,
               0                                            AS V3_In          ,
               0                                            AS T3_In
        FROM EAI_OWNER.STG_SALES_ORDER
        WHERE Created_Stg > TRUNC( SYSDATE - 0 )
        UNION ALL
        SELECT 'Pedidos'                                    AS Tipo_Docto     ,
               COUNT( Row_ID )                              AS SIBDB          ,   
               0                                            AS Created_Stg    ,
               0                                            AS Processed_XML  ,
               0                                            AS Processed_Queue,
               0                                            AS V3_In          ,
               0                                            AS T3_In
        FROM EAI_OWNER.SIBDB_SALES_ORDER@V3EAI
        WHERE Created_Stg > TRUNC( SYSDATE - 0 )
        UNION ALL
        SELECT 'Devoluciones'                               AS Tipo_Docto     ,
               0                                            AS SIBDB          ,   
               SUM( DECODE( Created_Stg    , NULL, 0, 1 ) ) AS Created_Stg    ,
               SUM( DECODE( Processed_XML  , NULL, 0, 1 ) ) AS Processed_XML  ,
               SUM( DECODE( Processed_Queue, NULL, 0, 1 ) ) AS Processed_Queue,
               0                                            AS V3_In          ,
               0                                            AS T3_In
        FROM EAI_OWNER.STG_RMA_ORDER
        WHERE Created_Stg > TRUNC( SYSDATE - 0 )
        UNION ALL
        SELECT 'Devoluciones'                               AS Tipo_Docto     ,
               COUNT( Row_ID )                              AS SIBDB          ,   
               0                                            AS Created_Stg    ,
               0                                            AS Processed_XML  ,
               0                                            AS Processed_Queue,
               0                                            AS V3_In          ,
               0                                            AS T3_In
        FROM EAI_OWNER.SIBDB_RMA_ORDER@V3EAI
        WHERE Created_Stg > TRUNC( SYSDATE - 0 )
        )
        GROUP BY Tipo_Docto
        ORDER BY Tipo_Docto;
        update MONITOR_AVANCE_V3_SAP av set av.last_update_date = sysdate;
        update monitor_chart_catalog mc set mc.last_update_date = sysdate
        Where mc.Stored_procedured_Name = 'MONITOR.GET_V3_SAP_FLOW';
        Commit;

    end UPDATE_V3_SAP_FLOW;

    procedure GET_V3_IN_FLOW (
        p_option in MONITOR_AVANCE_V3_T3.DOCUMENT_TYPE %type ,
        p_value out cursorType,
        p_row out number
    ) is
    l_option number;
    begin
        select count(1) into p_row from t3.MONITOR_AVANCE_V3_IN mm;
        open p_value for 
            select mm.DOCUMENT_TYPE , mm.Procesado, 
                mm.Errores,
                mm.Review
            from t3.MONITOR_AVANCE_V3_IN mm;

    end GET_V3_IN_FLOW;    

    procedure GET_V3_SAP_FLOW (
        p_option in MONITOR_AVANCE_V3_T3.DOCUMENT_TYPE %type ,
        p_value out cursorType,
        p_row out number
    ) is
    l_option number;
    begin
        select count(1) into p_row from t3.MONITOR_AVANCE_V3_SAP mm;
        open p_value for 
            select mm.DOCUMENT_TYPE , mm.PRE_STAGE, 
                mm.STAGE_IN,
                mm.STAGE_XML, mm.STATE_QUEUE as QUEUED
            from t3.MONITOR_AVANCE_V3_SAP mm;

    end GET_V3_SAP_FLOW;    

    procedure GET_V3_T3_FLOW (
        p_option in MONITOR_AVANCE_V3_T3.DOCUMENT_TYPE %type,
        p_value out cursorType,
        p_row out number
    ) is
    l_option number;
    begin
        select count(1) into p_row from t3.MONITOR_AVANCE_V3_T3 mm;
        open p_value for 
            select mm.DOCUMENT_TYPE , mm.STATE_V3_OUT as V3_OUT, 
                mm.STATE_STAGE as STAGE,
             -- cast ( (EXTRACT(second FROM current_timestamp) ) as int) as state_v3_out,
             -- cast ( (EXTRACT(second FROM current_timestamp) )/2 as int) as state_stage,
                mm.STATE_XML_PROCESSED as XML_PROCESSED, mm.STATE_QUEUE as QUEUED, 
                mm.STATE_T3_IN as T3_IN, mm.STATE_T3_XML_PROCESSED as T3_XML_PROCESSED
            from t3.MONITOR_AVANCE_V3_T3 mm;
    end GET_V3_T3_FLOW;

    procedure GET_T3_OUT_FLOW (
        p_option in MONITOR_AVANCE_T3_OUT.DOCUMENT_TYPE %type,
        p_value out cursorType,
        p_row out number
    ) is
    l_option number;
    begin
        select count(1) into p_row from t3.MONITOR_AVANCE_T3_OUT mm;
        open p_value for 
            select mm.DOCUMENT_TYPE , mm.STATE_T3_OUT as T3_OUT,
                mm.STATE_T3_XML_PROCESSED AS T3_XML, 
                mm.STATE_SENT as SENT
            from t3.MONITOR_AVANCE_T3_OUT mm
            order by mm.DOCUMENT_TYPE ASC;
    end GET_T3_OUT_FLOW;

    procedure GET_CHART_CATALOG (
        p_option in MONITOR_AVANCE_V3_T3.DOCUMENT_TYPE %type,
        p_value out cursorType
    ) IS
    l_option number;
    BEGIN
        OPEN p_value FOR
            SELECT 
                MC.id, MC.Formal_Name, MC.JS_FUNCTION_Name, MC.Display_Name ,
                MC.Chart_Type, MC.Status, MC.Stored_procedured_Name,
                MC.Option_Flag, to_Char (MC.Last_Update_Date, 'dd/mm/yyyy hh24:Mi:ss')
            FROM MONITOR_CHART_CATALOG MC
            WHERE MC.STATUS = 'Y'
            order by MC.position_Order;
    END GET_CHART_CATALOG;

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
