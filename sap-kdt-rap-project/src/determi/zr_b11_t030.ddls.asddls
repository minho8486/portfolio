@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 회계결정코드 마스터 Root View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zr_b11_t030
  as select from ztb11t030
  association [0..1] to ZI_B11_AKONT_F4 as _Account      on $projection.Saknr = _Account.SakUuid
  association [0..1] to ZI_B11_BKLAS_F4 as _Class        on $projection.Bklas = _Class.Bklas
  association [0..1] to ZI_B11_KTOSL_F4 as _Transaction  on $projection.Ktosl = _Transaction.DomainValue
  association [0..1] to ZI_B11_SHKZG_F4 as _DebitCredit  on $projection.Ktosl = _DebitCredit.DomainValue
  association [0..1] to ZI_B11_BWART_F4 as _MovementType on $projection.Bwart = _MovementType.Bwart
{
  key bwart          as Bwart,
  key seqnr          as Seqnr,
      ktosl          as Ktosl,
      bklas          as Bklas,
      saknr          as Saknr,
      shkzg          as Shkzg,
      loekz          as Loekz,
      @Semantics.user.createdBy: true
      created_by     as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at     as CreatedAt,
      @Semantics.user.lastChangedBy: true
      changed_by     as ChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      changed_at     as ChangedAt,
      _Account.Saknr as Account,
      _Account.Glact as Glact,
      _MovementType,
      _Account,
      _Class,
      _Transaction,
      _DebitCredit
}
