CLASS zcl_trade_spend_cat_flt DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
  DATA: et_payment_type TYPE TABLE OF zi_vh_trade_category.
ENDCLASS.



CLASS zcl_trade_spend_cat_flt IMPLEMENTATION.
 METHOD if_rap_query_provider~select.
    DATA(ld_skip) = io_request->get_paging( )->get_offset( ).
    DATA(ld_top) = io_request->get_paging( )->get_page_size( ).

    SELECT  FROM ztrade_spend
         FIELDS DISTINCT trade_spend_category
         INTO TABLE @DATA(lt_data).

     et_payment_type = CORRESPONDING #( lt_data ).


    IF io_request->is_total_numb_of_rec_requested(  ).
      io_response->set_total_number_of_records( lines( et_payment_type ) ).
    ENDIF.
    IF io_request->is_data_requested(  ).
      io_response->set_data( et_payment_type ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
