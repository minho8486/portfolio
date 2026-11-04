CLASS lsc_zr_b11_t030 DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.

ENDCLASS.

CLASS lsc_zr_b11_t030 IMPLEMENTATION.

  METHOD adjust_numbers.

    " 이동유형별 순번 자동 채번
    LOOP AT mapped-determine ASSIGNING FIELD-SYMBOL(<fs_deter>).

      DATA(lv_bwart) = <fs_deter>-%pre-%tmp-Bwart.

      " 기존 최대 순번 조회
      SELECT MAX( seqnr )
        FROM ztb11t030
        INTO @DATA(lv_seqnr)
        WHERE bwart = @lv_bwart.

      lv_seqnr += 1.

      <fs_deter>-Bwart = lv_bwart.
      <fs_deter>-Seqnr = lv_seqnr.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_Determine DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Determine RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR determine RESULT result.

    METHODS checkbklas FOR VALIDATE ON SAVE
      IMPORTING keys FOR determine~checkbklas.

    METHODS checkbwart FOR VALIDATE ON SAVE
      IMPORTING keys FOR determine~checkbwart.

    METHODS checkktosl FOR VALIDATE ON SAVE
      IMPORTING keys FOR determine~checkktosl.

    METHODS checksaknr FOR VALIDATE ON SAVE
      IMPORTING keys FOR determine~checksaknr.

    METHODS checkshkzg FOR VALIDATE ON SAVE
      IMPORTING keys FOR determine~checkshkzg.

    METHODS setremoved FOR MODIFY
      IMPORTING keys FOR ACTION determine~setremoved.

    METHODS checkdetermine FOR VALIDATE ON SAVE
      IMPORTING keys FOR determine~checkdetermine.

    METHODS clearsakuuid FOR DETERMINE ON SAVE
      IMPORTING keys FOR determine~clearsakuuid.

ENDCLASS.

CLASS lhc_Determine IMPLEMENTATION.

  METHOD get_instance_authorizations.

  ENDMETHOD.

  METHOD get_instance_features.

    " 현재 인스턴스 조회
    READ ENTITIES OF zr_b11_t030 IN LOCAL MODE
      ENTITY Determine
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(result_determin).

    LOOP AT result_determin INTO DATA(ls_determin).

      APPEND VALUE #(
        %tky = ls_determin-%tky
      ) TO result ASSIGNING FIELD-SYMBOL(<ls_result>).

      " 물리 삭제 비활성화
      <ls_result>-%delete = if_abap_behv=>fc-o-disabled.

      " 이미 삭제 처리된 경우 삭제 Action 비활성화
      IF ls_determin-Loekz = 'X'.
        <ls_result>-%action-SetRemoved = if_abap_behv=>fc-o-disabled.
      ELSE.
        <ls_result>-%action-SetRemoved = if_abap_behv=>fc-o-enabled.
      ENDIF.

      " DB 저장 여부 확인
      SELECT SINGLE COUNT( * )
        FROM ztb11t030
        WHERE bwart = @ls_determin-Bwart
          AND seqnr = @ls_determin-Seqnr.

      " 저장된 데이터만 삭제 플래그 수정 허용
      IF sy-subrc = 0.
        <ls_result>-%field-Loekz = if_abap_behv=>fc-f-unrestricted.
      ELSE.
        <ls_result>-%field-Loekz = if_abap_behv=>fc-f-read_only.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD CheckBklas.

    " 입력 데이터 조회
    READ ENTITIES OF zr_b11_t030
      ENTITY Determine
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_determin).

      " 평가클래스 존재 여부 확인
      SELECT SINGLE bklas
        FROM zi_b11_bklas_f4
        WHERE Bklas = @ls_determin-Bklas
        INTO @DATA(lv_bklas).

      IF sy-subrc <> 0.

        " 오류 메시지 및 필드 강조
        APPEND VALUE #(
          %tky = ls_determin-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '010'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Bklas = if_abap_behv=>mk-on
        ) TO reported-determine.

        APPEND VALUE #(
          %tky = ls_determin-%tky
        ) TO failed-determine.

        RETURN.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD CheckBwart.

    " 입력 데이터 조회
    READ ENTITIES OF zr_b11_t030
      ENTITY Determine
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_determin).

      " 이동유형 필수 입력 확인
      IF ls_determin-Bwart IS INITIAL.

        APPEND VALUE #(
          %tky = ls_determin-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '026'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Bwart = if_abap_behv=>mk-on
        ) TO reported-determine.

        APPEND VALUE #(
          %tky = ls_determin-%tky
        ) TO failed-determine.

        RETURN.

      ENDIF.

      " 이동유형 존재 여부 확인
      SELECT SINGLE Bwart
        FROM zi_b11_bwart_f4
        WHERE Bwart = @ls_determin-Bwart
        INTO @DATA(lv_bwart).

      IF sy-subrc <> 0.

        APPEND VALUE #(
          %tky = ls_determin-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '027'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Bwart = if_abap_behv=>mk-on
        ) TO reported-determine.

        APPEND VALUE #(
          %tky = ls_determin-%tky
        ) TO failed-determine.

        RETURN.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD CheckKtosl.

    " 입력 데이터 조회
    READ ENTITIES OF zr_b11_t030
      ENTITY Determine
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_determin).

      " 회계결정코드 필수 입력 확인
      IF ls_determin-Ktosl IS INITIAL.

        APPEND VALUE #(
          %tky = ls_determin-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '028'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Ktosl = if_abap_behv=>mk-on
        ) TO reported-determine.

        APPEND VALUE #(
          %tky = ls_determin-%tky
        ) TO failed-determine.

        RETURN.

      ENDIF.

      " 회계결정코드 존재 여부 확인
      SELECT SINGLE DomainValue
        FROM zi_b11_ktosl_f4
        WHERE DomainValue = @ls_determin-Ktosl
        INTO @DATA(lv_Ktosl).

      IF sy-subrc <> 0.

        APPEND VALUE #(
          %tky = ls_determin-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '029'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Ktosl = if_abap_behv=>mk-on
        ) TO reported-determine.

        APPEND VALUE #(
          %tky = ls_determin-%tky
        ) TO failed-determine.

        RETURN.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD CheckSaknr.

    " 입력 데이터 조회
    READ ENTITIES OF zr_b11_t030
      ENTITY Determine
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_determin).

      " 계정번호 필수 입력 확인
      IF ls_determin-Account IS INITIAL.

        APPEND VALUE #(
          %tky = ls_determin-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '011'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Saknr = if_abap_behv=>mk-on
        ) TO reported-determine.

        APPEND VALUE #(
          %tky = ls_determin-%tky
        ) TO failed-determine.

        RETURN.

      ENDIF.

      " FI 계정 존재 및 삭제 여부 확인
      SELECT SINGLE sak_uuid, xloev
        FROM ztb11ska1
        WHERE sak_uuid = @ls_determin-Saknr
        INTO @DATA(ls_account).

      IF sy-subrc <> 0.

        APPEND VALUE #(
          %tky = ls_determin-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '025'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Saknr = if_abap_behv=>mk-on
        ) TO reported-determine.

        APPEND VALUE #(
          %tky = ls_determin-%tky
        ) TO failed-determine.

        RETURN.

      ENDIF.

      " 삭제된 FI 계정 사용 방지
      IF ls_account-xloev = 'X'.

        APPEND VALUE #(
          %tky = ls_determin-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '062'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Saknr = if_abap_behv=>mk-on
        ) TO reported-determine.

        APPEND VALUE #(
          %tky = ls_determin-%tky
        ) TO failed-determine.

        RETURN.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD CheckShkzg.

    " 입력 데이터 조회
    READ ENTITIES OF zr_b11_t030
      ENTITY Determine
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_determin).

      " 미입력 시 검증 제외
      IF ls_determin-Shkzg IS INITIAL.
        CONTINUE.
      ENDIF.

      " 차변/대변 구분값 존재 여부 확인
      SELECT SINGLE DomainValue
        FROM zi_b11_shkzg_f4
        WHERE DomainValue = @ls_determin-Shkzg
        INTO @DATA(lv_Shkzg).

      IF sy-subrc <> 0.

        APPEND VALUE #(
          %tky = ls_determin-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '030'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Shkzg = if_abap_behv=>mk-on
        ) TO reported-determine.

        APPEND VALUE #(
          %tky = ls_determin-%tky
        ) TO failed-determine.

        RETURN.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD SetRemoved.

    " 대상 데이터 조회
    READ ENTITIES OF zr_b11_t030 IN LOCAL MODE
      ENTITY Determine
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(result_determine).

    LOOP AT result_determine INTO DATA(ls_determine).

      " 이미 삭제된 데이터 확인
      IF ls_determine-Loekz = 'X'.

        APPEND VALUE #(
          %tky = ls_determine-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '041'
            severity = if_abap_behv_message=>severity-error
          )
        ) TO reported-determine.

        APPEND VALUE #(
          %tky = ls_determine-%tky
        ) TO failed-determine.

        CONTINUE.

      ENDIF.

      " 삭제 플래그 설정
      MODIFY ENTITIES OF zr_b11_t030 IN LOCAL MODE
        ENTITY Determine
        UPDATE FIELDS ( Loekz )
        WITH VALUE #(
          (
            %tky  = ls_determine-%tky
            Loekz = 'X'
          )
        )
        FAILED DATA(lt_failed).

      " 삭제 처리 실패
      IF lt_failed IS NOT INITIAL.

        APPEND VALUE #(
          %tky = ls_determine-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '046'
            severity = if_abap_behv_message=>severity-error
          )
        ) TO reported-determine.

        APPEND VALUE #(
          %tky = ls_determine-%tky
        ) TO failed-determine.

        CONTINUE.

      ENDIF.

      " 삭제 처리 성공
      APPEND VALUE #(
        %tky = ls_determine-%tky
        %msg = new_message(
          id       = 'ZMCB11'
          number   = '047'
          severity = if_abap_behv_message=>severity-success
        )
      ) TO reported-determine.

    ENDLOOP.

  ENDMETHOD.

  METHOD CheckDetermine.

    " 입력 데이터 조회
    READ ENTITIES OF zr_b11_t030
      ENTITY Determine
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_determin).

      " 동일 계정결정 조합 중복 확인
      SELECT SINGLE bklas
        FROM ztb11t030
        WHERE Bklas = @ls_determin-Bklas
          AND bwart = @ls_determin-Bwart
          AND ktosl = @ls_determin-Ktosl
        INTO @DATA(lv_bklas).

      IF sy-subrc = 0.

        APPEND VALUE #(
          %tky = ls_determin-%tky
          %msg = new_message(
            id       = 'ZMCB11'
            number   = '063'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Bwart = if_abap_behv=>mk-on
          %element-Bklas = if_abap_behv=>mk-on
          %element-Ktosl = if_abap_behv=>mk-on
        ) TO reported-determine.

        APPEND VALUE #(
          %tky = ls_determin-%tky
        ) TO failed-determine.

        RETURN.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD ClearSakUuid.

    " 입력 데이터 조회
    READ ENTITIES OF zr_b11_t030 IN LOCAL MODE
      ENTITY Determine
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_determin).

      " 계정번호 기준 UUID 확인
      SELECT SINGLE sak_uuid
        FROM ztb11ska1
        WHERE saknr = @ls_determin-Account
        INTO @DATA(lv_sakuuid).

      " 유효하지 않은 경우 UUID 초기화
      IF sy-subrc <> 0 OR ls_determin-Saknr IS INITIAL.

        MODIFY ENTITIES OF zr_b11_t030 IN LOCAL MODE
          ENTITY Determine
          UPDATE FIELDS ( Saknr )
          WITH VALUE #(
            (
              %tky  = ls_determin-%tky
              Saknr = VALUE #( )
            )
          ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
