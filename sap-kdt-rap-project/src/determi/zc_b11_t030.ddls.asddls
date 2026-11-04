@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 회계결정코드 마스터 Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity zc_b11_t030
  as projection on zr_b11_t030
{
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: [ 'Btext' ]
      @UI.textArrangement: #TEXT_LAST
      @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_b11_bwart_f4', element: 'Bwart'} }]
  key Bwart,
  key Seqnr,
      @ObjectModel.text.element: [ 'TransactionText' ]
      @UI.textArrangement: #TEXT_LAST
      @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_b11_ktosl_f4', element: 'DomainValue'} }]
      Ktosl,
      @ObjectModel.text.element: [ 'ClassText' ]
      @UI.textArrangement: #TEXT_LAST
      @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_b11_bklas_f4', element: 'Bklas'} }]
      Bklas,
      Saknr,
      @ObjectModel.text.element: [ 'DCText' ]
      @UI.textArrangement: #TEXT_LAST
      @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_b11_shkzg_f4', element: 'DomainValue'} }]
      Shkzg,
      Loekz,
      CreatedBy,
      CreatedAt,
      ChangedBy,
      ChangedAt,
      @ObjectModel.text.element: [ 'AccountText' ]
      @UI.textArrangement: #TEXT_LAST
      @Consumption.valueHelpDefinition: [
      {
        entity:{ name: 'zi_b11_akont_f4', element: 'Saknr' },
        additionalBinding: [
                { localElement: 'Glact', element: 'Glact', usage: #RESULT },
                { localElement: 'Saknr', element: 'SakUuid', usage: #RESULT }
            ]
      }]
      Account,
      @ObjectModel.text.element: [ 'AccountTypeText' ]
      @UI.textArrangement: #TEXT_LAST
      Glact,
      _Account.AccountText     as AccountText,
      @Semantics.text: true
      _Account.AccountTypeText as AccountTypeText,
      _Class.Bkbez             as ClassText,
      _Transaction.DomainText  as TransactionText,
      _DebitCredit.DomainText  as DCText,
      _MovementType.Btext      as Btext,
      /* Associations */
      _Account,
      _Class,
      _Transaction,
      _DebitCredit
}
