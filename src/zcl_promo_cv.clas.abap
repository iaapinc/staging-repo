CLASS zcl_promo_cv DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

  PRIVATE SECTION.
    TYPES: BEGIN OF deep_struct,
             condition_contract         TYPE c LENGTH 40,
             bus_vol_field_combn_type   TYPE c LENGTH 4,
             cndn_contr_bus_vol_sign    TYPE c LENGTH 1,
             sales_organization         TYPE c LENGTH 4,
             customer                   TYPE c LENGTH 10,
             cndn_contr_bus_vol_valid_f TYPE datn,
             cndn_contr_bus_vol_valid_t TYPE datn,
             product_group              TYPE c LENGTH 40,  " Product group
             Product                    TYPE c LENGTH 40,
             Product_Type               TYPE c LENGTH 40,
             Product_Hierarchy          TYPE c LENGTH 40,
             customer_hierarchy         TYPE c LENGTH 10,
           END OF deep_struct.

    TYPES: BEGIN OF ty_record,
             Condition_Table            TYPE c LENGTH 3,
             condition_application      TYPE c LENGTH 2,
             Condition_Type             TYPE c LENGTH 4,
             condition_validity_start_d TYPE datn,
             condition_validity_end_dat TYPE datn,
             condition_calculation_type TYPE c LENGTH 40,
             condition_rate_ratio       TYPE p LENGTH 13 DECIMALS 9,
             Condition_Rate_Ratio_Unit  TYPE c LENGTH 3,
             Condition_Rate_Amount      TYPE p LENGTH 13 DECIMALS 9,  " Trade spend
             Condition_Currency         TYPE c LENGTH 3,
           END OF ty_record.

    TYPES: BEGIN OF ty_final,
             condition_contract         TYPE c LENGTH 10,
             cndn_contr_type            TYPE c LENGTH 4,
             customer                   TYPE c LENGTH 10,
             supplier                   TYPE c LENGTH 10,
             sales_organization         TYPE c LENGTH 4,
             distribution_channel       TYPE c LENGTH 2,
             division                   TYPE c LENGTH 2,
             amount_field_group         TYPE c LENGTH 4,
             cndn_contr_valid_from      TYPE c LENGTH 40, " promotion_period start
             cndn_contr_valid_to        TYPE c LENGTH 40, " promotion_period end
             document_reference_id      TYPE c LENGTH 16,
             external_document_referenc TYPE c LENGTH 30, " promotion_name
             cndn_contr_source_doc_cat  TYPE c LENGTH 2,  " External Doc id "99",
             cndn_contr_source_doc      TYPE c LENGTH 32, " Promotion_ID
             cndn_contr_bus_vol_sel_cri TYPE STANDARD TABLE OF deep_struct WITH DEFAULT KEY,
             cndn_contr_cndn_record     TYPE STANDARD TABLE OF ty_record WITH DEFAULT KEY,
           END OF ty_final.

    TYPES: BEGIN OF ty_range_option,
             sign   TYPE c LENGTH 1,
             option TYPE c LENGTH 2,
             low    TYPE string,
             high   TYPE string,
           END OF ty_range_option,

           tt_range_option TYPE STANDARD TABLE OF ty_range_option WITH EMPTY KEY.

    DATA et_result TYPE TABLE OF ty_final.
    DATA es_result TYPE ty_final.
    DATA lrt_promo TYPE tt_range_option.
    DATA lrs_promo TYPE ty_range_option.
    DATA et_res    TYPE TABLE OF zi_promo_cv.
    DATA es_res    TYPE zi_promo_cv.
ENDCLASS.


CLASS zcl_promo_cv IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    " Data Declaration.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lr_promo_type TYPE RANGE OF /iap/rgm_t_promo-promotion_type.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lr_status     TYPE RANGE OF /iap/rgm_t_promo-status.
    " data : lr_trade_spend_typ type range of /iap/rgm_t_promo-.

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(ld_skip) = io_request->get_paging( )->get_offset( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(ld_top) = io_request->get_paging( )->get_page_size( ).
    DATA lo_root_filter_node TYPE REF TO /iwbep/if_cp_filter_node.
    " Instantiate Client Proxy
    DATA(lo_client_proxy) = /iap/rgm_rds_cl_aux_condition=>get_client_proxy( ).

    TRY.
        DATA(lo_request) = lo_client_proxy->create_resource_for_entity_set( 'CONDITION_CONTRACT' )->create_request_for_read( ).
        DATA(lr_node) = lo_request->create_expand_node( ).
        lr_node->add_expand( iv_expand_property_path = 'CNDN_CONTR_BUS_VOL_SEL_CRI' ).
        lr_node->add_expand( iv_expand_property_path = 'CNDN_CONTR_CNDN_RECORD' ).

      CATCH /iwbep/cx_gateway.
    ENDTRY.

    " Filter conditions
    TRY.
        DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    DATA(lv_filter_string) = io_request->get_filter( )->get_as_sql_string( ).
    TRY.
        DATA(lo_filter_factory) = lo_request->create_filter_factory( ).
      CATCH /iwbep/cx_gateway.
    ENDTRY.

    LOOP AT lt_filter INTO DATA(ls_filter).
      CASE ls_filter-name.
        WHEN 'PROMOTION_TYPE'.
          lr_promo_type = CORRESPONDING #( ls_filter-range MAPPING sign = sign
                                                                    option = option
                                                                    low = low
                                                                    high = high ).
        WHEN 'PAYMENT_TYPE'.
          lr_status = CORRESPONDING #( ls_filter-range MAPPING sign = sign
                                                                    option = option
                                                                    low = low
                                                                    high = high ).
*        WHEN 'PRICING_METHOD'.
*          lr_pricing_meth  = CORRESPONDING #( ls_filter-range MAPPING sign = sign
*                                                                    option = option
*                                                                    low = low
*                                                                    high = high ).

*        WHEN 'ACCPLAN_CONTRACT'.
*          lr_accplan = CORRESPONDING #( ls_filter-range MAPPING sign = sign
*                                                                    option = option
*                                                                    low = low
*                                                                    high = high ).
      ENDCASE.
    ENDLOOP.

    " Fetch promo data
    SELECT * FROM /iap/rgm_t_promo
      WHERE (lv_filter_string)
      INTO TABLE @DATA(lt_promo).

    LOOP AT lt_promo INTO DATA(ls_promo_range).
      lrs_promo-sign   = 'I'.
      lrs_promo-option = 'EQ'.
      lrs_promo-low    = ls_promo_range-condition_contract.
      lrs_promo-high   = ''.
      APPEND lrs_promo TO lrt_promo.
      CLEAR lrs_promo.
    ENDLOOP.

    IF lrt_promo IS NOT INITIAL.
      TRY.
          DATA(lo_filter_node) = lo_filter_factory->create_by_range( iv_property_path = 'CONDITION_CONTRACT'
                                                                     it_range         = lrt_promo ).
        CATCH /iwbep/cx_gateway.
      ENDTRY.

      IF lo_root_filter_node IS INITIAL.
        lo_root_filter_node = lo_filter_node.
      ELSE.
        TRY.
            lo_root_filter_node = lo_root_filter_node->and( lo_filter_node ).
          CATCH /iwbep/cx_gateway.
        ENDTRY.
      ENDIF.

      " Set filter
      IF lo_root_filter_node IS NOT INITIAL.
        TRY.
            lo_request->set_filter( lo_root_filter_node ).
          CATCH /iwbep/cx_gateway.
        ENDTRY.
      ENDIF.

      TRY.
          DATA(lo_response) = lo_request->execute( ).
        CATCH /iwbep/cx_cp_remote
              /iwbep/cx_gateway.
      ENDTRY.
      TRY.
          " fetch the data.
          lo_response->get_business_data( IMPORTING et_business_data = et_result ).
        CATCH /iwbep/cx_gateway.
      ENDTRY.
    ENDIF.

    " Modify the data for the final output.
    LOOP AT et_result INTO DATA(es_result_outer) GROUP BY es_result_outer-cndn_contr_source_doc
         INTO DATA(et_result_group).
      LOOP AT GROUP et_result_group INTO DATA(es_result).
        es_res-promotion_id       = es_result-cndn_contr_source_doc.  " added promotion id --> PM
        es_res-condition_contract = es_result-condition_contract.
        " promotion period
        DATA(lv_start_date) = CONV d( es_result-cndn_contr_valid_from ).
        DATA(lv_end_date) = CONV d( es_result-cndn_contr_valid_to ).
        es_res-promotion_period = |{ lv_start_date DATE = USER } - { lv_end_date DATE = USER } |.

        es_res-promotion_name   = es_result-external_document_referenc.

        " product group
*        LOOP AT es_result-cndn_contr_bus_vol_sel_cri INTO DATA(ls_busvol).
*          IF sy-tabix = 1.
*            CONCATENATE es_res-product_groups ls_busvol-product INTO es_res-product_groups.
*          ELSE.
*            CONCATENATE es_res-product_groups ls_busvol-product INTO es_res-product_groups SEPARATED BY ','.
*          ENDIF.
*        ENDLOOP.

        " sell in period and Status.
        READ TABLE lt_promo INTO DATA(ls_promo) WITH KEY condition_contract = es_result-condition_contract.
        IF sy-subrc = 0.
          es_res-sellin_period = |{ ls_promo-sellin_start_date DATE = USER } - { ls_promo-sellin_end_date DATE = USER } |.
          IF ls_promo-status = ''.
            es_res-status = 'Draft'.
          ELSE.
            es_res-status = ls_promo-status.
          ENDIF.
          es_res-promotion_type = ls_promo-promotion_type.
        ENDIF.

        " Total Trade Spend
        LOOP AT es_result-cndn_contr_cndn_record INTO DATA(ls_record).
          IF ls_record-condition_table = '4AB'.
            es_res-trade_spend += ls_record-condition_rate_amount.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
      APPEND es_res TO et_res.
      CLEAR es_res.
    ENDLOOP.

    " apply the filter


    " pass the data to UI.
    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records( lines( et_res ) ).
    ENDIF.
    IF io_request->is_data_requested( ).
      io_response->set_data( et_res ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
