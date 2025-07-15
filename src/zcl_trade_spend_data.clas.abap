CLASS zcl_trade_spend_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA : lt_trade_data TYPE TABLE OF zi_trade_spend.
ENDCLASS.



CLASS zcl_trade_spend_data IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    DATA: lr_TRADE_CAT    TYPE RANGE OF zi_trade_spend-trade_spend_category,
          lr_pricing_meth TYPE RANGE OF zi_trade_spend-pricing_method,
          lr_pay_typ      TYPE RANGE OF zi_trade_spend-payment_type,
          lt_finaldata    TYPE TABLE OF ztrade_spend,
          ls_finaldata    TYPE  ztrade_spend.

    DATA(ld_skip) = io_request->get_paging( )->get_offset( ).
    DATA(ld_top) = io_request->get_paging( )->get_page_size( ).

    TRY.
        DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range.
        "handle exception
    ENDTRY.

* filter criteria.
    LOOP AT lt_filter INTO DATA(ls_filter).
      CASE ls_filter-name.
        WHEN  'TRADE_SPEND_CATEGORY'.
          lr_trade_Cat = CORRESPONDING #( ls_filter-range MAPPING sign = sign
                                                                    option = option
                                                                    low = low
                                                                    high = high ).
        WHEN 'PAYMENT_TYPE'.
          lr_pay_typ = CORRESPONDING #( ls_filter-range MAPPING sign = sign
                                                                    option = option
                                                                    low = low
                                                                    high = high ).
        WHEN 'PRICING_METHOD'.
          lr_pricing_meth  = CORRESPONDING #( ls_filter-range MAPPING sign = sign
                                                                    option = option
                                                                    low = low
                                                                    high = high ).
      ENDCASE.
    ENDLOOP.

* Fetch the data
    SELECT FROM ztrade_spend
         FIELDS *
         WHERE  payment_type IN @lr_pay_typ
           AND  pricing_method IN @lr_pricing_meth
           AND  trade_spend_category IN @lr_trade_Cat
         INTO TABLE @DATA(lt_data).

*======================Merge rows for payment type and pricing method=======================================
    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fls_data>) GROUP BY <fls_data>-trade_spend_id.
      CLEAR : ls_finaldata.
      ls_finaldata-trade_spend_id = <fls_data>-trade_spend_id.
      ls_finaldata-trade_spend_name = <fls_data>-trade_spend_name.
      ls_finaldata-trade_spend_category = <fls_data>-trade_spend_category.
      ls_finaldata-status = <fls_data>-status.
      LOOP AT GROUP <fls_data> ASSIGNING FIELD-SYMBOL(<fls_group>) WHERE trade_spend_id = <fls_data>-trade_spend_id.
        IF ls_finaldata-payment_type IS INITIAL.
          ls_finaldata-payment_type = <fls_group>-payment_type.
        ELSE.
*          if ls_finaldate-payment_type
          ls_finaldata-payment_type = |{ ls_finaldata-payment_type },{ <fls_group>-payment_type }|.
        ENDIF.

        IF ls_finaldata-pricing_method IS INITIAL.
          ls_finaldata-pricing_method = <fls_group>-pricing_method.
        ELSE.
          ls_finaldata-pricing_method = |{ ls_finaldata-pricing_method },{ <fls_group>-pricing_method }|.
        ENDIF.

      ENDLOOP.
      APPEND ls_finaldata TO lt_finaldata.
      UNASSIGN <fls_group>.
    ENDLOOP.
    UNASSIGN <fls_data>.
*===========================================================================================================

    lt_trade_data = CORRESPONDING #( lt_finaldata ).


    IF io_request->is_total_numb_of_rec_requested(  ).
      io_response->set_total_number_of_records( lines( lt_trade_data ) ).
    ENDIF.
    IF io_request->is_data_requested(  ).
      io_response->set_data( lt_trade_data ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
