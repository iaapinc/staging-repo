@EndUserText.label: 'Promotion Calendar View'
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_PROMO_CV'
    }
}
define custom entity ZI_PROMO_CV
{
  key condition_contract : abap.char(40);
  key promotion_id       : abap.char(40);
//      accplan_contract   : abap.char(40);
      promotion_name     : abap.char(60);
      status             : abap.char(40);
      //      Customer           : abap.string;
      promotion_period   : abap.char(40);  
      trade_spend_type   : abap.string; // not mapped
      promotion_type     : abap.string; // not mapped
      sellin_period      : abap.char(40);
      Payment_type       : abap.char(40);  // not mapped
      Pricing_Method     : abap.char(40);  // not mapped
      Uplift_volume      : abap.char(40);  // not mapped
      total_volume       : abap.char(40);  // not mapped    
      @EndUserText.label : 'total_trade_spend'
      trade_spend        : abap.char(40);
//      product_groups     : abap.string;
}
