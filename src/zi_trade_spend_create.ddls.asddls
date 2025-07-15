@EndUserText.label: 'create trade spend data'
define root custom entity zi_trade_spend_create
{
  key trade_spend_id       : abap.char(40);
      _create              : composition [0..*] of ZI_TRADE_SPEND;
}
