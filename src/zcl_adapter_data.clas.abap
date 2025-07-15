CLASS zcl_adapter_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: et_pricing_Data TYPE TABLE OF zi_adapter_r.
ENDCLASS.



CLASS zcl_adapter_data IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    DATA: lr_adaptertype TYPE RANGE OF zadapter_tab-adapter_type.
    DATA(ld_skip) = io_request->get_paging( )->get_offset( ).
    DATA(ld_top) = io_request->get_paging( )->get_page_size( ).


    TRY.
        DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range.
        "handle exception
    ENDTRY.

    LOOP AT lt_filter INTO DATA(ls_filter).
      CASE ls_filter-name.
        WHEN  'ADAPTER_TYPE'.
          lr_adaptertype = CORRESPONDING #( ls_filter-range MAPPING sign = sign
                                                                    option = option
                                                                    low = low
                                                                    high = high ).
      ENDCASE.
    ENDLOOP.
    SELECT FROM zadapter_tab
         FIELDS *
         WHERE adapter_type IN @lr_adaptertype
         INTO TABLE @DATA(lt_data).

    et_pricing_Data = CORRESPONDING #( lt_data ).


    IF io_request->is_total_numb_of_rec_requested(  ).
      io_response->set_total_number_of_records( lines( et_pricing_Data ) ).
    ENDIF.
    IF io_request->is_data_requested(  ).
      io_response->set_data( et_pricing_Data ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
