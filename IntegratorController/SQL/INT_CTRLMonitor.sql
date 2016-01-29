 -- 
 -- Something
 --
    Insert into int_ctrl_task_catalog (
        id, formal_Name, Display_Name, Status, last_Update_By, last_Update_Date
    )
    Select -- al.* 
        al.job, al.what, al.what, al.broken, user, sysdate
    From all_jobs al
    where al.job = 191;

    Delete from int_ctrl_task_catalog;


    Select -- al.* 
        al.job ,
        al.log_User, al.schema_user, al.last_date, al.last_sec, al.this_date,
        al.this_sec, al.next_date, al.Next_Sec, al.broken, al.interval, al.what
    From all_jobs al
    order by al.job desc;

    begin    
        Select SEQ_INT_CTRL_TASK.nextval() from dual;
    end;

    Select -- ml.* 
        ml.Row_Id, ml.Created, ml.Queue_Name , ml.reference, ml.Processed,
        ml. status, ml.docnum
    From MX_Receive_Message_Log ml
    Where Queue_Name in ('Invoice', 'Invoice Null' , 'InvoiceNull' ,'Customer', 'Customer Null')
    order by ml.created desc;

    Select ml.* 
    From MX_Receive_Message_Log ml
    Where Row_Id in ('20150219145946135821000135821000', '20150219122908567694000567694000', '20150219120307842463000842463000','20150219120307842463000842463000', '20150219115807482113000482113000')
    order by ml.created desc;

    Select ml.* 
    From MX_Receive_Message_Log ml
    Where Queue_Name = 'InvoiceNull'
    order by ml.created desc;


    Update MX_Receive_Message_Log ml
    set ml.queue_Name = 'Invoice Null'
    Where ml.Row_Id = '20150219120209491281000491281000';

 -- EXEC DBMS_JOB.REMOVE();