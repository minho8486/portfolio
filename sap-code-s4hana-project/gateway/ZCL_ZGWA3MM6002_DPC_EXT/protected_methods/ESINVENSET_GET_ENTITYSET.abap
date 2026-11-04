**************************************************************************
*   Method attributes.                                                   *
**************************************************************************


Instantiation: Protected


**************************************************************************



  METHOD esinvenset_get_entityset.
    SELECT mtext, labstsum AS labst, meins
      FROM zcds_a3_mm_6004
      INTO CORRESPONDING FIELDS OF TABLE @et_entityset.
  ENDMETHOD.
