DROP TABLE INT_CTRL_Process_Gallery;
CREATE TABLE INT_CTRL_Process_Gallery (
    P_ID VARCHAR2(1024) NOT NULL ,
    FORMAL_NAME VARCHAR2(1024) , 
    FUNCTION_NAME VARCHAR2(1024) , 
    DISPLAY_NAME VARCHAR2(1024) , 
    STATUS VARCHAR2(32) , 
    OPTION_FLAG VARCHAR2(1024) , 
    LAST_UPDATE_BY VARCHAR2(1024) ,
    LAST_UPDATE_DATE DATE ,
    CONSTRAINT INT_CTRL_Process_Gallery_PK PRIMARY KEY ( P_ID ) ENABLE 
);
commit;