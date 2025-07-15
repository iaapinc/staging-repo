@EndUserText.label: 'value help for payment type'
@ObjectModel: {
query: {
        implementedBy: 'ABAP:ZCL_PAYMENT_TYPE_FLT'
    }
}
define custom entity zi_vh_payment_typ
{
  key payment_type : abap.char( 60 );
  
}
