DROP TABLE INT_CTRL_ACTIVITY ;
CREATE TABLE INT_CTRL_ACTIVITY (
    U_ID NUMBER NOT NULL ,
    FORMAL_NAME VARCHAR2(1024) , 
    JS_FUNCTION_NAME VARCHAR2(1024) , 
    DISPLAY_NAME VARCHAR2(1024) , 
    OPERATION_TYPE VARCHAR2(1024) , 
    STATUS VARCHAR2(32) , 
    STORED_PROCEDURED_NAME VARCHAR2(1024) , 
    OPTION_FLAG VARCHAR2(1024) , 
    LAST_UPDATE_BY VARCHAR2(1024) ,
    LAST_UPDATE_DATE DATE 
);
commit;
