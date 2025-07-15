@EndUserText.label: 'Trade spend data'
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_TRADE_SPEND_DATA'
    }
}
define custom entity ZI_TRADE_SPEND
{
  key trade_spend_id       : abap.char(40);
  key capability_id        : zcapability_id;
      trade_spend_name     : abap.char(60);
      trade_spend_category : abap.char(60);
//  pricing data
      payment_type         : abap.char(60);
      pricing_method       : abap.char(60);
      status               : abap.char(50);
      _header : association to parent zi_trade_spend_create on $projection.trade_spend_id = _header.trade_spend_id;

}
