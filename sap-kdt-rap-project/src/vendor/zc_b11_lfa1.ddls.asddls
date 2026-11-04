@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 공급업체 마스터 Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: [ 'Lifnr' ]
define root view entity zc_b11_lfa1
  as projection on zr_b11_lfa1
{
  key     LifUuid,
          @ObjectModel.text.element: [ 'Name1' ]
          @UI.textArrangement: #TEXT_LAST
          @Search.defaultSearchElement: true
          Lifnr,
          Name1,
          Waers,
          @Semantics.amount.currencyCode: 'Waers'
          Minbw,
          @ObjectModel.text.element: [ 'VendorGroupText' ]
          @UI.textArrangement: #TEXT_LAST
          @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_b11_fdgrv_f4', element: 'DomainValue'} }]
          Fdgrv,
          AkontUuid,
          Loevm,
          @ObjectModel.text.element: [ 'AccountText' ]
          @UI.textArrangement: #TEXT_LAST
          @Consumption.valueHelpDefinition: [
          {
            entity:{ name: 'zi_b11_akont_f4', element: 'Saknr' },
            additionalBinding: [
                    { localElement: 'Glact', element: 'Glact', usage: #RESULT },
                    { localElement: 'AkontUuid', element: 'SakUuid', usage: #RESULT }
                ]
          }]
          Saknr,
          @ObjectModel.text.element: [ 'AccountTypeText' ]
          @UI.textArrangement: #TEXT_LAST
          Glact,
          CreatedBy,
          CreatedAt,
          ChangedBy,
          ChangedAt,
          _Account.AccountText    as AccountText,
          @Semantics.text: true
          _Account.AccountTypeText as AccountTypeText,
          _VendorGroup.DomainText as VendorGroupText,
          _Account,
          _VendorGroup
}
