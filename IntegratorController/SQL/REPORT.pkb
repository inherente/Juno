CREATE OR REPLACE package body V3_SYSADMIN.REPORT IS
    FUNCTION NoFunction(Param IN NUMBER) RETURN NUMBER
    Is
    BEGIN
    RETURN Param;
    End;

    procedure GET_SYNC_DAY_BEFORE (
        p_option in number ,
        p_value out cursorType
    ) Is
    l_value number;
    BEGIN
        Open p_value for
            Select sysdate as HORA_SINC from dual;
    END GET_SYNC_DAY_BEFORE;

    function GET_ORPHAN_INVOICE (
        p_option in number 
    ) Return cursorType Is
    l_value number;
    p_value cursorType ;
    BEGIN
        Open p_value for
            select /*+ parallel  INDEX(F S_ORG_TERR_U1 )*/
                a.row_id "Id Detalle Factura", a.created "Fecha de Cración dtl",
                a.ln_num, id_pedido "Id Detalle Pedido" ,
                case
                    when decode(id_pedido,null,a.ordeR_item_id,id_pedido)  in  (select row_id from siebel.s_order_item) then 'Existe en Siebel'
                    else 'No existe en Siebel'
                end "Validacion",
                case
                    when case when decode(id_pedido,null,a.ordeR_item_id,id_pedido)  in  (select row_id from siebel.s_order_item) then 'Existe en Siebel'  
                    else 'No existe en Siebel' end = 'No existe en Siebel'  
                         and  (select min(a.ln_num) from siebel.s_invc_itm_dtl z where z.row_id = a.row_id) = a.ln_num 
                    then 'No Salio'
                end validacion_II,
                i.name "Van" ,j.login "Usuario",e.row_id "Id factura",
                e.invc_num "Num Factura", e.goods_dlvrd_flg ,
                e.status_cd "Estatus Factura",c.name "Sku",c.part_num "Num. Sku",
                a.qty "Cantidad"
            from siebel.s_invc_itm_dtl a,
                siebel.s_prod_int c,
                siebel.s_invoice_item d,
                siebel.s_invoice e,
                siebel.s_org_terr f,
                siebel.s_postn g,
                siebel.s_user j,
                siebel.s_invloc i,
                (
                    select b.buscomp_name,instr(a.msg_text,'"',1,2), a.msg_text,substr(a.msg_text,31,(instr(a.msg_text,'"',1,2)-31))id_pedido,b.buscomp_row_iden
                    from SIEBEL.S_HH_TXN_ERRMSG a,
                    SIEBEL.S_HH_TXN_ERR b
                    where (a.msg_text like 'Failed to pick value %')
                    and a.hh_txn_err_id  = b.row_id
                    and buscomp_name = 'FS Invoice Line Item Details'
                ) l
            where E.INVC_DT > trunc(sysdate-8)  and e.invc_dt < trunc(sysdate)
                and E.created > trunc(sysdate-8) and E.created < trunc(sysdate)
                AND E.GOODS_DLVRD_TS > trunc(sysdate-8) AND E.GOODS_DLVRD_TS < trunc(sysdate)
                and e.status_cd in ('Delivered','Closed','Credited')
                and a.prod_id = c.row_id
                and d.row_id  = a.invc_ln_item_id
                and e.row_id = d.invoice_id
                and e.accnt_id = f.ou_id
                and f.terr_id = g.pr_terr_id
                and g.pr_emp_id = j.row_id
                and i.pr_postn_id = g.row_id
                and a.row_id  = buscomp_row_iden(+)
                and e.row_id in (
                    select distinct "Id factura"
                    from (
                        select /*+ parallel  INDEX(F S_ORG_TERR_U1 )*/
                        a.row_id "Id Detalle Factura", a.created "Fecha de Cración dtl",a.ln_num,
                        id_pedido "Id Detalle Pedido" ,
                        case
                            when decode(id_pedido,null,a.ordeR_item_id,id_pedido)  in  (select row_id from siebel.s_order_item) 
                            then 'Existe en Siebel'
                        else 'No existe en Siebel'
                        end "Validacion" ,
                        case
                            when case when decode(id_pedido,null,a.ordeR_item_id,id_pedido)  in  (select row_id from siebel.s_order_item) 
                            then 'Existe en Siebel'  
                            else 'No existe en Siebel' 
                        end = 'No existe en Siebel'  
                        and  (select min(a.ln_num) from siebel.s_invc_itm_dtl z where z.row_id = a.row_id) = a.ln_num then 'No Salio'
                        end validacion_II,
                        i.name "Van" ,j.login "Usuario",e.row_id "Id factura",
                        e.invc_num "Num Factura", e.goods_dlvrd_flg ,
                        e.status_cd "Estatus Factura",c.name "Sku",
                        c.part_num "Num. Sku",a.qty "Cantidad" 
                        from siebel.s_invc_itm_dtl a,
                            siebel.s_prod_int c,
                            siebel.s_invoice_item d,
                            siebel.s_invoice e,
                            siebel.s_org_terr f,
                            siebel.s_postn g,
                            siebel.s_user j,
                            siebel.s_invloc i,
                            (
                                select b.buscomp_name,instr(a.msg_text,'"',1,2), a.msg_text,substr(a.msg_text,31,(instr(a.msg_text,'"',1,2)-31))id_pedido,b.buscomp_row_iden
                                from SIEBEL.S_HH_TXN_ERRMSG a,
                                    SIEBEL.S_HH_TXN_ERR b
                                where (a.msg_text like 'Failed to pick value %')
                                    and a.hh_txn_err_id  = b.row_id
                                    and buscomp_name = 'FS Invoice Line Item Details'
                            ) l
                        where E.INVC_DT > trunc(sysdate-8)  and e.invc_dt < trunc(sysdate)
                        and E.created > trunc(sysdate-8) and E.created < trunc(sysdate)
                        AND E.GOODS_DLVRD_TS > trunc(sysdate-8) AND E.GOODS_DLVRD_TS < trunc(sysdate)
                        and e.status_cd in ('Delivered','Closed','Credited')
                        and a.prod_id = c.row_id
                        and d.row_id  = a.invc_ln_item_id
                        and e.row_id = d.invoice_id
                        and e.accnt_id = f.ou_id
                        and f.terr_id = g.pr_terr_id
                        and g.pr_emp_id = j.row_id
                        and i.pr_postn_id = g.row_id
                        and a.row_id  = buscomp_row_iden(+)
                        and e.status_cd in ('Delivered','Closed','Credited')
                        and g.x_trade_approach in ('Prompt Sales')
                        and e.created_by = j.row_id
                        order by i.name,e.row_id,a.ln_num
                    )
                where "Id Detalle Pedido" is not null
                )
                and e.created_by = j.row_id
                order by i.name,e.row_id,a.ln_num; 

        Return p_value;
    END;

END REPORT;
/