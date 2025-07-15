@EndUserText.label: 'Adater data'
@ObjectModel: {
query: {
        implementedBy: 'ABAP:ZCL_ADAPTER_DATA'
    }
}
define custom entity ZI_ADAPTER_R
{
  key capability_id   : zcapability_id;
      pricing_rule    : abap.char( 100 );
      payment_type    : abap.char(60);
      pricing_method  : abap.char(60);
      condition_table : abap.char(60);
      adapter_type    : abap.char(60);

}
