DROP TABLE INT_CTRL_Report_Gallery;
CREATE TABLE INT_CTRL_Report_Gallery (
    R_ID NUMBER NOT NULL ,
    FORMAL_NAME VARCHAR2(1024) , 
    FUNCTION_NAME VARCHAR2(1024) , 
    DISPLAY_NAME VARCHAR2(1024) , 
    STATUS VARCHAR2(32) , 
    OPTION_FLAG VARCHAR2(1024) , 
    LAST_UPDATE_BY VARCHAR2(1024) ,
    LAST_UPDATE_DATE DATE ,
    CONSTRAINT INT_CTRL_Report_Gallery_PK PRIMARY KEY ( R_ID ) ENABLE 
);
Drop TABLE INT_CTRL_Report_Detail;
CREATE TABLE INT_CTRL_Report_Detail (
    RI_ID NUMBER NOT NULL ,
    R_ID NUMBER NOT NULL ,
    Column_NAME VARCHAR2(1024) , 
    Column_priority VARCHAR2(1024) , 
    Column_type VARCHAR2(1024) , 
    Column_Length VARCHAR2(1024) , 
    Column_Desc VARCHAR2(1024) , 
    OPTION_FLAG VARCHAR2(1024) , 
    LAST_UPDATE_BY VARCHAR2(1024) ,
    LAST_UPDATE_DATE DATE ,
    CONSTRAINT INT_CTRL_Report_Detail_PK PRIMARY KEY ( RI_ID ) ENABLE 
);

DECLARE
nid number(10);
BEGIN

Select SEQ_INT_CTRL_Report_Gallery.nextval into nid from dual;
Insert into INT_CTRL_Report_Gallery (
    R_ID , FORMAL_NAME , FUNCTION_NAME , DISPLAY_NAME , STATUS , OPTION_FLAG , LAST_UPDATE_BY ,LAST_UPDATE_DATE 
) values (
    nid ,
    'name',
    'Integrator_Controller.GET_Diff_V3_SAP_Report(?,?)' ,
    'Integrator_Controller.GET_Diff_V3_SAP_Report' ,
    'Y' ,
    'Y',
    user,
    sysdate
);
Insert into INT_CTRL_Report_Detail (
    RI_ID , R_ID , Column_NAME , Column_priority , Column_type , Column_Length, Column_Desc , OPTION_FLAG , LAST_UPDATE_BY , LAST_UPDATE_DATE  
) values (
    SEQ_INT_CTRL_Report_Detail.nextval ,
    nid ,
    'stockpartner' ,
    '1' ,
    'text' ,
    '1024' ,
    null ,
    'Y' ,
    user ,
    sysdate
);
Insert into INT_CTRL_Report_Detail (
    RI_ID , R_ID , Column_NAME , Column_priority , Column_type , Column_Length, Column_Desc , OPTION_FLAG , LAST_UPDATE_BY , LAST_UPDATE_DATE  
) values (
    SEQ_INT_CTRL_Report_Detail.nextval ,
    nid ,
    'vanname' ,
    '2' ,
    'text' ,
    '1024' ,
    null ,
    'Y' ,
    user ,
    sysdate
);
Insert into INT_CTRL_Report_Detail (
    RI_ID , R_ID , Column_NAME , Column_priority , Column_type , Column_Length, Column_Desc , OPTION_FLAG , LAST_UPDATE_BY , LAST_UPDATE_DATE  
) values (
    SEQ_INT_CTRL_Report_Detail.nextval ,
    nid ,
    'docdate' ,
    '3' ,
    'text' ,
    '1024' ,
    null ,
    'Y' ,
    user ,
    sysdate
);

Select SEQ_INT_CTRL_Report_Gallery.nextval into nid from dual;
Insert into INT_CTRL_Report_Gallery (
    R_ID , FORMAL_NAME , FUNCTION_NAME , DISPLAY_NAME , STATUS , OPTION_FLAG , LAST_UPDATE_BY ,LAST_UPDATE_DATE 
) values (
    nid ,
    'named',
    'Integrator_Controller.GET_Diff_SAP_V3_Report(?,?)' ,
    'Integrator_Controller.GET_Diff_SAP_V3_Report' ,
    'Y' ,
    'Y',
    user,
    sysdate
);

Select SEQ_INT_CTRL_Report_Gallery.nextval into nid from dual;
Insert into INT_CTRL_Report_Gallery (
    R_ID , FORMAL_NAME , FUNCTION_NAME , DISPLAY_NAME , STATUS , OPTION_FLAG , LAST_UPDATE_BY ,LAST_UPDATE_DATE 
) values (
    nid ,
    'namedly',
    'Integrator_Controller.GET_Diff_SAP_T3_Report(?,?)' ,
    'Integrator_Controller.GET_Diff_SAP_T3_Report' ,
    'Y' ,
    'Y',
    user,
    sysdate
);
commit;
END;
/
