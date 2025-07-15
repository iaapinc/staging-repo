CLASS zcl_insertdata DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_insertdata IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
*         select * from zadapter_tab into table @data(lt_tab).
*
*         delete zadapter_tab from table @lt_Tab.

*    DATA : lt_tab TYPE TABLE OF zadapter_tab,
*           ls_tab TYPE zadapter_tab.
*
*    SELECT * FROM /iap/rgm_t_adapt INTO TABLE @DATA(lt_Adapt) UP TO 5 ROWS.
*
**       loop at lt_adapt into data(ls_adapt).
*    ls_tab-capability_id = 'CAP001'.
*    ls_tab-adapter_type = 'IAP S/4Hana'.
*    ls_tab-condition_table = '163'.
*    ls_tab-payment_type = 'Discount'.
*    ls_tab-pricing_method = 'Dollaroff'.
*    ls_tab-pricing_category = 'Product'.
*    ls_tab-uplift_pricing = ls_tab-pricing_method.
*    ls_tab-pricing_rule = |{ ls_tab-pricing_method } for { ls_tab-payment_type } |.
*    APPEND ls_tab TO lt_tab.
*    CLEAR ls_tab.
*    ls_tab-capability_id = 'CAP002'.
*    ls_tab-adapter_type = 'IAP S/4Hana'.
*    ls_tab-condition_table = '4AB'.
*    ls_tab-payment_type = 'Rebate'.
*    ls_tab-pricing_method = 'Dollaroff'.
*    ls_tab-pricing_category = 'Product Category'.
*    ls_tab-uplift_pricing = ls_tab-pricing_method.
*    ls_tab-pricing_rule = |{ ls_tab-pricing_method } for { ls_tab-payment_type } |.
*    APPEND ls_tab TO lt_tab.
*    CLEAR ls_tab.
*
**       endloop
*    INSERT zadapter_tab FROM TABLE @lt_tab.
*       lt_tab = CORRESPONDING #( lt_adapt mapping capability_id = capability_id
*                                                    ).
   select * from ztrade_spend where trade_spend_id = 2 into table @data(lt_Tab).
   delete ztrade_spend from table @lt_Tab.
  ENDMETHOD.

ENDCLASS.
