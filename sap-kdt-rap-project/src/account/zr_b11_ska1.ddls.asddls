@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[B11] 계정마스터 Root View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zr_b11_ska1
  as select from ztb11ska1
  composition [0..*] of zi_b11_ska1text as _AccountText
  association [0..1] to ZI_B11_GLACT_F4 as _AccountType on $projection.Glact = _AccountType.DomainValue
{
  key sak_uuid   as SakUuid,
      saknr      as Saknr,
      glact      as Glact,
      xloev      as Xloev,
      created_by as CreatedBy,
      created_at as CreatedAt,
      changed_by as ChangedBy,
      changed_at as ChangedAt,
      _AccountText,
      _AccountType
}
