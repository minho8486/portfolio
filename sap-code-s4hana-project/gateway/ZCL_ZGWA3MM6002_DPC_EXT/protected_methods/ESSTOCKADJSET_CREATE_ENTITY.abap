**************************************************************************
*   Method attributes.                                                   *
**************************************************************************


Instantiation: Protected


**************************************************************************



  METHOD esstockadjset_create_entity.

    DATA: ls_input      TYPE zsa3mm6033,
          ls_zta3mm0002 TYPE zta3mm0002,
          ls_zta3mm0010 TYPE zta3mm0010,
          ls_zta3mm0011 TYPE zta3mm0011,
          lv_iotid      TYPE zta3mm0010-iotid,
          lv_scode      TYPE zta3mm0011-scode,
          lv_empid      TYPE zta3hr0002-empid.

    DATA: lv_num(10) TYPE n,
          lv_year TYPE nryear.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ls_input
    ).

    "필수값 체크
    IF ls_input-matid IS INITIAL
    OR ls_input-batid IS INITIAL
    OR ls_input-plaid IS INITIAL
    OR ls_input-stoid IS INITIAL.
      ls_input-sflag = 'E'.
      MESSAGE i030(zmcn11601) INTO ls_input-smesg. "자재번호, 배치번호, 플랜트, 저장공간은 필수입니다.
      er_entity = ls_input.
      RETURN.
    ENDIF.

    IF ls_input-adjqt IS INITIAL OR ls_input-adjqt <= 0.
      ls_input-sflag = 'E'.
      MESSAGE i031(zmcn11601) INTO ls_input-smesg. "조정수량은 0보다 커야 합니다.
      er_entity = ls_input.
      RETURN.
    ENDIF.

    "현재 재고 조회
    SELECT SINGLE matid batid plaid stoid labst
      FROM zta3mm0002
      INTO CORRESPONDING FIELDS OF ls_zta3mm0002
     WHERE matid = ls_input-matid
       AND batid = ls_input-batid
       AND plaid = ls_input-plaid
       AND stoid = ls_input-stoid.

    IF sy-subrc <> 0.
      ls_input-sflag = 'E'.
      MESSAGE i015(zmcn11601) INTO ls_input-smesg. "없는 재고정보 입니다.
      er_entity = ls_input.
      RETURN.
    ENDIF.

    ls_input-labst = ls_zta3mm0002-labst.
    lv_year = sy-datum+0(4).

    "조정구분 처리
    CASE ls_input-adjty.
      WHEN 'A'. "증가
        ls_zta3mm0002-labst = ls_zta3mm0002-labst + ls_input-adjqt.
        ls_input-otype = 'I'.
        ls_zta3mm0010-iflag = 'N'.

        CALL FUNCTION 'NUMBER_GET_NEXT'
          EXPORTING
            nr_range_nr             = '01'
            object                  = 'ZNRA3MM12'
            toyear                  = lv_year
          IMPORTING
            number                  = lv_num
          EXCEPTIONS
            interval_not_found      = 1
            number_range_not_intern = 2
            object_not_found        = 3
            quantity_is_0           = 4
            quantity_is_not_1       = 5
            interval_overflow       = 6
            buffer_overflow         = 7
            OTHERS                  = 8.
        IF sy-subrc <> 0.
          ROLLBACK WORK.
          ls_input-sflag = 'E'.
          MESSAGE i004(zmcn11602) INTO ls_input-smesg.
          er_entity = ls_input.
          RETURN.
        ENDIF.

        lv_iotid = 'I' && lv_year && lv_num.

      WHEN 'S'. "감소
        IF ls_zta3mm0002-labst < ls_input-adjqt.
          ls_input-sflag = 'E'.
          MESSAGE i032(zmcn11601) INTO ls_input-smesg. "현재 재고보다 감소 수량이 큽니다.
          er_entity = ls_input.
          RETURN.
        ENDIF.

        ls_zta3mm0002-labst = ls_zta3mm0002-labst - ls_input-adjqt.
        ls_input-otype = 'O'.

        CALL FUNCTION 'NUMBER_GET_NEXT'
          EXPORTING
            nr_range_nr             = '01'
            object                  = 'ZNRA3MM62'
            toyear                  = lv_year
          IMPORTING
            number                  = lv_num
          EXCEPTIONS
            interval_not_found      = 1
            number_range_not_intern = 2
            object_not_found        = 3
            quantity_is_0           = 4
            quantity_is_not_1       = 5
            interval_overflow       = 6
            buffer_overflow         = 7
            OTHERS                  = 8.
        IF sy-subrc <> 0.
          ROLLBACK WORK.
          ls_input-sflag = 'E'.
          MESSAGE i004(zmcn11602) INTO ls_input-smesg.
          er_entity = ls_input.
          RETURN.
        ENDIF.

        lv_iotid = 'R' && lv_year && lv_num.

      WHEN OTHERS.
        ls_input-sflag = 'E'.
        MESSAGE i033(zmcn11601) INTO ls_input-smesg. "조정구분이 올바르지 않습니다. A 또는 S를 입력하세요.
        er_entity = ls_input.
        RETURN.
    ENDCASE.

    ls_input-afqty = ls_zta3mm0002-labst.


    SELECT SINGLE empid
      FROM zta3hr0002
      INTO lv_empid
     WHERE mpgid = sy-uname.

    SELECT SINGLE meins
      FROM zta3mm0001
      INTO ls_input-meins
     WHERE matid = ls_input-matid.

    "Header 생성
    CLEAR ls_zta3mm0010.
    ls_zta3mm0010-iotid = lv_iotid.
    ls_zta3mm0010-plaid = ls_input-plaid.
    ls_zta3mm0010-prtyp = 'IM'.
    ls_zta3mm0010-otype = ls_input-otype.
    ls_zta3mm0010-bktxt = ls_input-bktxt.
    ls_zta3mm0010-erdat = sy-datum.
    ls_zta3mm0010-erzet = sy-uzeit.
    ls_zta3mm0010-ereid = lv_empid.
    ls_zta3mm0010-aedat = sy-datum.
    ls_zta3mm0010-aezet = sy-uzeit.
    ls_zta3mm0010-aeeid = lv_empid.

    "Item 생성
    CLEAR ls_zta3mm0011.
    ls_zta3mm0011-iotid = lv_iotid.
    ls_zta3mm0011-scode = '001'.
    ls_zta3mm0011-matid = ls_input-matid.
    ls_zta3mm0011-stoid = ls_input-stoid.
    ls_zta3mm0011-batid = ls_input-batid.
    ls_zta3mm0011-mtcnt = ls_input-adjqt.
    ls_zta3mm0011-meins = ls_input-meins.
    ls_zta3mm0011-eflag = 'I'.
    ls_zta3mm0011-erdat = sy-datum.
    ls_zta3mm0011-erzet = sy-uzeit.
    ls_zta3mm0011-ereid = lv_empid.
    ls_zta3mm0011-aedat = sy-datum.
    ls_zta3mm0011-aezet = sy-uzeit.
    ls_zta3mm0011-aeeid = lv_empid.

    "DB 반영
    UPDATE zta3mm0002 SET labst = ls_zta3mm0002-labst
                          aedat = sy-datum
                          aezet = sy-uzeit
                          aeeid = lv_empid
                    WHERE matid = ls_zta3mm0002-matid
                      AND batid = ls_zta3mm0002-batid
                      AND plaid = ls_zta3mm0002-plaid
                      AND stoid = ls_zta3mm0002-stoid.

    IF sy-subrc <> 0.
      ROLLBACK WORK.
      ls_input-sflag = 'E'.
      MESSAGE i034(zmcn11601) INTO ls_input-smesg. "재고 수정 중 오류가 발생했습니다.
      er_entity = ls_input.
      RETURN.
    ENDIF.

    INSERT zta3mm0010 FROM ls_zta3mm0010.

    IF sy-subrc <> 0.
      ROLLBACK WORK.
      ls_input-sflag = 'E'.
      MESSAGE i035(zmcn11601) INTO ls_input-smesg. "입출고 Header 생성 중 오류가 발생했습니다.
      er_entity = ls_input.
      RETURN.
    ENDIF.

    INSERT zta3mm0011 FROM ls_zta3mm0011.

    IF sy-subrc <> 0.
      ROLLBACK WORK.
      ls_input-sflag = 'E'.
      MESSAGE i036(zmcn11601) INTO ls_input-smesg. "입출고 Item 생성 중 오류가 발생했습니다.
      er_entity = ls_input.
      RETURN.
    ENDIF.

    COMMIT WORK.

    ls_input-sflag = 'S'.
    MESSAGE i037(zmcn11601) INTO ls_input-smesg. "재고 조정이 완료되었습니다.

    er_entity = ls_input.

  ENDMETHOD.
