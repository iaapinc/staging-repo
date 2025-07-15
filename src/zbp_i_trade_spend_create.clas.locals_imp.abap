CLASS lhc_zi_trade_spend_create DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_trade_spend_create RESULT result.

*    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
*      IMPORTING REQUEST requested_authorizations FOR zi_trade_spend_create RESULT result.
*
*    METHODS create FOR MODIFY
*      IMPORTING entities FOR CREATE zi_trade_spend_create.

    METHODS create_deep_entity FOR MODIFY
      IMPORTING
        trade        FOR CREATE zi_trade_spend_create
        trade_create FOR CREATE zi_trade_spend_create\_create.


    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_trade_spend_create.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_trade_spend_create.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_trade_spend_create RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_trade_spend_create.

    METHODS rba_Create FOR READ
      IMPORTING keys_rba FOR READ zi_trade_spend_create\_Create FULL result_requested RESULT result LINK association_links.

*    METHODS cba_Create FOR MODIFY
*      IMPORTING entities_cba FOR CREATE zi_trade_spend_create\_Create.

ENDCLASS.

CLASS lhc_zi_trade_spend_create IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD get_global_authorizations.
*  ENDMETHOD.

*  METHOD create.
*  ENDMETHOD.

  METHOD create_deep_entity.

    DATA: lt_trade_data TYPE TABLE OF ztrade_spend.
    DATA: ls_trade_data TYPE ztrade_spend.

    select single
      from ztrade_spend
      FIELDS max( trade_spend_id )
     into @data(lv_max_tradespend).

     lv_max_tradespend += 1.

    LOOP AT trade_create ASSIGNING FIELD-SYMBOL(<fls_trade>).
*      DATA(lv_trade_id) = <fls_trade>-trade_spend_id.
      LOOP AT <fls_trade>-%target  INTO DATA(ls_tradecreate).
       ls_trade_data-trade_spend_id = lv_max_tradespend.
        ls_trade_data-payment_type = ls_tradecreate-payment_type.
        ls_trade_data-pricing_method = ls_tradecreate-pricing_method.
        ls_trade_data-status = ls_tradecreate-status.
        ls_trade_data-trade_spend_category = ls_tradecreate-trade_spend_category.
        ls_trade_data-trade_spend_name = ls_tradecreate-trade_spend_name.
        ls_trade_data-capability_id = ls_tradecreate-capability_id.

        APPEND ls_trade_data TO lt_trade_data.
        CLEAR : ls_trade_data,ls_tradecreate.
      ENDLOOP.
    ENDLOOP.

    MODIFY ztrade_spend FROM TABLE @lt_trade_data.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Create.
  ENDMETHOD.

*  METHOD cba_Create.
*  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZI_TRADE_SPEND DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_trade_spend.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_trade_spend.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_trade_spend RESULT result.

    METHODS rba_Header FOR READ
      IMPORTING keys_rba FOR READ zi_trade_spend\_Header FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_ZI_TRADE_SPEND IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Header.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_TRADE_SPEND_CREATE DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_TRADE_SPEND_CREATE IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
