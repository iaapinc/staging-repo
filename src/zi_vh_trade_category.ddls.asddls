@EndUserText.label: 'value help for trade category'
@ObjectModel: {
query: {
        implementedBy: 'ABAP:ZCL_TRADE_SPEND_CAT_FLT'
    }
}
define custom entity zi_vh_trade_category
{
  key trade_spend_category : abap.char(60);
  
}
