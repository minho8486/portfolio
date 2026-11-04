CLASS lhc_poitem DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR poitem RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR poitem RESULT result.

    METHODS setvendor FOR DETERMINE ON MODIFY
      IMPORTING keys FOR poitem~setvendor.

    METHODS setwaers FOR DETERMINE ON MODIFY
      IMPORTING keys FOR poitem~setwaers.

    METHODS setmaterialname FOR DETERMINE ON MODIFY
      IMPORTING keys FOR poitem~setmaterialname.

    METHODS checkplantstorage FOR VALIDATE ON SAVE
      IMPORTING keys FOR poitem~checkplantstorage.

    METHODS checkmaterial FOR VALIDATE ON SAVE
      IMPORTING keys FOR poitem~checkmaterial.

    METHODS checkpir FOR VALIDATE ON SAVE
      IMPORTING keys FOR poitem~checkpir.

    METHODS clearpirinfo FOR DETERMINE ON MODIFY
      IMPORTING keys FOR poitem~clearpirinfo.

    METHODS setpirinfo FOR DETERMINE ON MODIFY
      IMPORTING keys FOR poitem~setpirinfo.

    METHODS setblocked FOR MODIFY
      IMPORTING keys FOR ACTION poitem~setblocked.

    METHODS checknetpr FOR VALIDATE ON SAVE
      IMPORTING keys FOR poitem~checknetpr.

    METHODS checkmenge FOR VALIDATE ON SAVE
      IMPORTING keys FOR poitem~checkmenge.
    METHODS clearmatuuid FOR DETERMINE ON MODIFY
      IMPORTING keys FOR poitem~clearmatuuid.
    METHODS setgrcomplete FOR MODIFY
      IMPORTING keys FOR ACTION poitem~setgrcomplete.

    METHODS earlynumbering_cba_poitem FOR NUMBERING
      IMPORTING entities FOR CREATE poheader\_poitem.

ENDCLASS.


CLASS lhc_poitem IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD get_instance_features.

    " Item 조회
    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POItem
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(result_item).

    LOOP AT result_item INTO DATA(ls_item).

      APPEND VALUE #( %tky = ls_item-%tky ) TO result ASSIGNING FIELD-SYMBOL(<ls_result>).

      " Active Item 확인
      SELECT SINGLE ebeln_uuid FROM ztb11ekpo
        WHERE ebeln_uuid = @ls_item-EbelnUuid
          AND ebelp      = @ls_item-Ebelp
        INTO @DATA(lv_active_item).

      IF sy-subrc <> 0.
        <ls_result>-%action-SetBlocked = if_abap_behv=>fc-o-disabled.
        <ls_result>-%delete = if_abap_behv=>fc-o-enabled.
      ELSE.
        <ls_result>-%delete = if_abap_behv=>fc-o-disabled.

        IF ls_item-Loekz = 'X'.
          <ls_result>-%action-SetBlocked = if_abap_behv=>fc-o-disabled.
        ELSE.
          <ls_result>-%action-SetBlocked = if_abap_behv=>fc-o-enabled.
        ENDIF.
      ENDIF.

      " PIR 사용 시 입력 제한
      IF ls_item-InfUuid IS NOT INITIAL.
        <ls_result>-%field-Meins = if_abap_behv=>fc-f-read_only.
        <ls_result>-%field-Matnr = if_abap_behv=>fc-f-read_only.
        <ls_result>-%field-Werks = if_abap_behv=>fc-f-read_only.
        <ls_result>-%field-Netpr = if_abap_behv=>fc-f-read_only.
      ELSE.
        <ls_result>-%field-Meins = if_abap_behv=>fc-f-unrestricted.
        <ls_result>-%field-Matnr = if_abap_behv=>fc-f-unrestricted.
        <ls_result>-%field-Werks = if_abap_behv=>fc-f-unrestricted.
        <ls_result>-%field-Netpr = if_abap_behv=>fc-f-unrestricted.
      ENDIF.

      <ls_result>-%field-Waers = if_abap_behv=>fc-f-read_only.

    ENDLOOP.

  ENDMETHOD.


  METHOD earlynumbering_cba_poitem.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_header>).

      DATA(lv_ebeln_uuid) = <fs_header>-EbelnUuid.

      " 기존 Item 조회
      READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
        ENTITY POHeader BY \_POItem
        FIELDS ( EbelnUuid Ebelp )
        WITH VALUE #( ( EbelnUuid = lv_ebeln_uuid %is_draft = <fs_header>-%is_draft ) )
        RESULT DATA(lt_result).

      " 최대 순번
      SORT lt_result BY Ebelp DESCENDING.
      READ TABLE lt_result INDEX 1 INTO DATA(ls_result).

      DATA lv_ebelp TYPE zeb11ebelp.

      IF sy-subrc <> 0.
        lv_ebelp = 10.
      ELSE.
        lv_ebelp = ls_result-Ebelp + 10.
      ENDIF.

      " 신규 Item 번호
      LOOP AT <fs_header>-%target INTO DATA(ls_target).

        IF ls_target-Ebelp IS INITIAL.
          APPEND VALUE #(
            %cid = ls_target-%cid
            %is_draft = ls_target-%is_draft
            EbelnUuid = lv_ebeln_uuid
            Ebelp = lv_ebelp
          ) TO mapped-poitem.
          lv_ebelp = lv_ebelp + 10.
        ELSE.
          APPEND VALUE #(
            %cid = ls_target-%cid
            %is_draft = ls_target-%is_draft
            EbelnUuid = lv_ebeln_uuid
            Ebelp = ls_target-Ebelp
          ) TO mapped-poitem.
        ENDIF.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD SetVendor.

    " Item / Header 조회
    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POItem
      FIELDS ( EbelnUuid VendorUuid )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POItem BY \_POHeader
      FIELDS ( LifUuid )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    LOOP AT lt_item INTO DATA(ls_item).

      READ TABLE lt_header INTO DATA(ls_header) WITH KEY EbelnUuid = ls_item-EbelnUuid.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      " Vendor 설정
      MODIFY ENTITIES OF zr_b11_ekko IN LOCAL MODE
        ENTITY POItem
        UPDATE FIELDS ( VendorUuid )
        WITH VALUE #( ( %tky = ls_item-%tky VendorUuid = ls_header-LifUuid ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD SetWaers.

    " Item / Header 조회
    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POItem
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POItem BY \_POHeader
      FIELDS ( Waers )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    LOOP AT lt_item INTO DATA(ls_item).

      READ TABLE lt_header INTO DATA(ls_header) WITH KEY EbelnUuid = ls_item-EbelnUuid.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      " 통화 설정
      MODIFY ENTITIES OF zr_b11_ekko IN LOCAL MODE
        ENTITY POItem
        UPDATE FIELDS ( Waers )
        WITH VALUE #( ( %tky = ls_item-%tky Waers = ls_header-Waers ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD SetMaterialName.

    " Item 조회
    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POItem
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).

      IF ls_item-MatUuid IS INITIAL.
        CONTINUE.
      ENDIF.

      SELECT SINGLE Maktx, Mtart FROM zi_b11_matnr_f4
        WHERE MatUuid = @ls_item-MatUuid
        INTO @DATA(ls_mat).

      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      " 자재명 설정
      MODIFY ENTITIES OF zr_b11_ekko IN LOCAL MODE
        ENTITY POItem
        UPDATE FIELDS ( Txz01 )
        WITH VALUE #( ( %tky = ls_item-%tky
                        Txz01 = ls_mat-Maktx
                        Mtart = ls_mat-Mtart
                        ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckPlantStorage.

    " 플랜트 / 저장위치 확인
    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POItem
      FIELDS ( Werks Lgort )
      WITH CORRESPONDING #( keys )
      RESULT DATA(result_item).

    LOOP AT result_item INTO DATA(ls_item).

      " 필수값
      IF ls_item-Werks IS INITIAL OR ls_item-Lgort IS INITIAL.

        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-poitem.
        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message( id = 'ZMCB11' number = '003' severity = if_abap_behv_message=>severity-error )
          %element-Werks = COND #( WHEN ls_item-Werks IS INITIAL THEN if_abap_behv=>mk-on )
          %element-Lgort = COND #( WHEN ls_item-Lgort IS INITIAL THEN if_abap_behv=>mk-on )
        ) TO reported-poitem.

      ELSE.

        " 플랜트 확인
        SELECT SINGLE Werks FROM zi_b11_werks_f4
          WHERE Werks = @ls_item-Werks
          INTO @DATA(lv_werks).

        IF sy-subrc <> 0.

          APPEND VALUE #( %tky = ls_item-%tky ) TO failed-poitem.
          APPEND VALUE #(
            %tky = ls_item-%tky
            %msg = new_message( id = 'ZMCB11' number = '004' severity = if_abap_behv_message=>severity-error )
            %element-Werks = if_abap_behv=>mk-on
          ) TO reported-poitem.

        ELSE.

          " 저장위치 확인
          SELECT SINGLE Lgort FROM zi_b11_lgort_f4
            WHERE Werks = @ls_item-Werks
              AND Lgort = @ls_item-Lgort
            INTO @DATA(lv_lgort).

          IF sy-subrc <> 0.
            APPEND VALUE #( %tky = ls_item-%tky ) TO failed-poitem.
            APPEND VALUE #(
              %tky = ls_item-%tky
              %msg = new_message( id = 'ZMCB11' number = '005' severity = if_abap_behv_message=>severity-error )
              %element-Lgort = if_abap_behv=>mk-on
            ) TO reported-poitem.
          ENDIF.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckMaterial.

    " 자재 확인
    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POItem
      FIELDS ( MatUuid Matnr )
      WITH CORRESPONDING #( keys )
      RESULT DATA(result_item).

    LOOP AT result_item INTO DATA(ls_item).

      IF ls_item-Matnr IS INITIAL OR ls_item-MatUuid IS INITIAL.

        " 자재 필수
        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-poitem.
        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message( id = 'ZMCB11' number = '001' severity = if_abap_behv_message=>severity-error )
          %element-Matnr = if_abap_behv=>mk-on
        ) TO reported-poitem.

      ELSE.

        SELECT SINGLE Matnr, Lvorm FROM ztb11mara
          WHERE mat_uuid = @ls_item-MatUuid
          INTO @DATA(ls_material).

        IF sy-subrc <> 0.

          " 자재 없음
          APPEND VALUE #( %tky = ls_item-%tky ) TO failed-poitem.
          APPEND VALUE #(
            %tky = ls_item-%tky
            %msg = new_message( id = 'ZMCB11' number = '031' severity = if_abap_behv_message=>severity-error )
            %element-Matnr = if_abap_behv=>mk-on
          ) TO reported-poitem.

        ELSEIF ls_material-Lvorm = 'X'.

          " 삭제 자재
          APPEND VALUE #( %tky = ls_item-%tky ) TO failed-poitem.
          APPEND VALUE #(
            %tky = ls_item-%tky
            %msg = new_message( id = 'ZMCB11' number = '050' severity = if_abap_behv_message=>severity-error )
            %element-Matnr = if_abap_behv=>mk-on
          ) TO reported-poitem.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckPIR.

    " Item 조회
    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POItem
      FIELDS ( EbelnUuid InfUuid MatUuid Werks )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    " Header 조회
    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POItem BY \_POHeader
      FIELDS ( LifUuid )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    LOOP AT lt_item INTO DATA(ls_item).

      " PIR 선택사항
      IF ls_item-InfUuid IS INITIAL.
        CONTINUE.
      ENDIF.

      READ TABLE lt_header INTO DATA(ls_header) WITH KEY EbelnUuid = ls_item-EbelnUuid.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      " PIR 조회
      SELECT SINGLE a~inf_uuid, a~vendor_uuid, a~material_uuid,
                    a~loekz AS hloek, b~werks, b~loekz AS iloek
        FROM ztb11eina AS a
        INNER JOIN ztb11eine AS b ON b~inf_uuid = a~inf_uuid
        WHERE a~inf_uuid = @ls_item-InfUuid
          AND b~werks    = @ls_item-Werks
        INTO @DATA(ls_pir).

      IF sy-subrc <> 0.

        " PIR 없음
        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-poitem.
        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message( id = 'ZMCB11' number = '052' severity = if_abap_behv_message=>severity-error )
          %element-Infnr = if_abap_behv=>mk-on
        ) TO reported-poitem.

      ELSEIF ls_pir-hloek = 'X' OR ls_pir-iloek = 'X'.

        " 삭제 PIR
        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-poitem.
        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message( id = 'ZMCB11' number = '057' severity = if_abap_behv_message=>severity-error )
          %element-Infnr = if_abap_behv=>mk-on
        ) TO reported-poitem.

      ELSEIF ls_pir-vendor_uuid <> ls_header-LifUuid
          OR ls_pir-material_uuid <> ls_item-MatUuid.

        " Vendor / Material 불일치
        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-poitem.
        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message( id = 'ZMCB11' number = '052' severity = if_abap_behv_message=>severity-error )
          %element-Infnr = if_abap_behv=>mk-on
        ) TO reported-poitem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD ClearPIRInfo.

    " PIR 조회
    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POItem
      FIELDS ( Infnr InfUuid )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).

      SELECT SINGLE inf_uuid
        FROM ztb11eina
       WHERE inf_uuid = @ls_item-infuuid
        INTO @DATA(lv_infuuid).

      IF sy-subrc <> 0 OR ls_item-Infnr IS NOT INITIAL.
        CONTINUE.
      ENDIF.

      " PIR 정보 초기화
      MODIFY ENTITIES OF zr_b11_ekko IN LOCAL MODE
        ENTITY POItem
        UPDATE FIELDS ( InfUuid MatUuid Matnr Txz01 Meins Netpr Werks Menge )
        WITH VALUE #( (
          %tky = ls_item-%tky
          InfUuid = VALUE #( )
          MatUuid = VALUE #( )
          Matnr = VALUE #( )
          Txz01 = VALUE #( )
          Meins = VALUE #( )
          Netpr = VALUE #( )
          Werks = VALUE #( )
          Menge = VALUE #( )
        ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD SetPIRInfo.

    " Item 조회
    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POItem
      FIELDS ( InfUuid MatUuid )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).

      IF ls_item-InfUuid IS INITIAL.
        CONTINUE.
      ENDIF.

      " PIR 조회
      SELECT SINGLE a~meins, b~werks, b~netpr, b~minbm
        FROM ztb11eina AS a
        INNER JOIN ztb11eine AS b ON b~inf_uuid = a~inf_uuid
        WHERE a~inf_uuid = @ls_item-InfUuid
        INTO @DATA(ls_pir).

      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      " 자재 조회
      SELECT SINGLE matnr, mtart FROM ztb11mara
        WHERE mat_uuid = @ls_item-MatUuid
        INTO @DATA(ls_mara).

      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      " PIR 정보 설정
      MODIFY ENTITIES OF zr_b11_ekko IN LOCAL MODE
        ENTITY POItem
        UPDATE FIELDS ( Werks Meins Netpr Menge Matnr Mtart )
        WITH VALUE #( (
          %tky = ls_item-%tky
          Werks = ls_pir-Werks
          Meins = ls_pir-Meins
          Netpr = ls_pir-Netpr
          Menge = ls_pir-Minbm
          Matnr = ls_mara-Matnr
          Mtart = ls_mara-Mtart
        ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD SetBlocked.

    " Item 조회
    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POItem
      FIELDS ( Loekz )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).

      IF ls_item-Loekz = 'X'.
        CONTINUE.
      ENDIF.

      " 삭제 플래그
      MODIFY ENTITIES OF zr_b11_ekko IN LOCAL MODE
        ENTITY POItem
        UPDATE FIELDS ( Loekz )
        WITH VALUE #( ( %tky = ls_item-%tky Loekz = 'X' ) )
        FAILED DATA(lt_failed)
        REPORTED DATA(lt_reported).

      IF lt_failed-poitem IS NOT INITIAL.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message( id = 'ZMCB11' number = '055' severity = if_abap_behv_message=>severity-error )
        ) TO reported-poitem.

        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-poitem.
        CONTINUE.

      ENDIF.

      " 성공 메시지
      APPEND VALUE #(
        %tky = ls_item-%tky
        %msg = new_message( id = 'ZMCB11' number = '056' severity = if_abap_behv_message=>severity-success )
      ) TO reported-poitem.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckNetpr.

    " 가격 확인
    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POItem
      FIELDS ( Netpr )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).

      IF ls_item-Netpr < 0.

        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-poitem.
        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message( id = 'ZMCB11' number = '058' severity = if_abap_behv_message=>severity-error )
          %element-Netpr = if_abap_behv=>mk-on
        ) TO reported-poitem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckMenge.

    " 수량 확인
    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POItem
      FIELDS ( InfUuid Werks Menge )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).

      IF ls_item-Menge IS INITIAL.

        " 수량 필수
        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-poitem.
        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message( id = 'ZMCB11' number = '058' severity = if_abap_behv_message=>severity-error )
          %element-Menge = if_abap_behv=>mk-on
        ) TO reported-poitem.

        CONTINUE.

      ENDIF.

      IF ls_item-Menge < 0.

        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-poitem.
        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message( id = 'ZMCB11' number = '061' severity = if_abap_behv_message=>severity-error )
          %element-Menge = if_abap_behv=>mk-on
        ) TO reported-poitem.

      ENDIF.

      IF ls_item-InfUuid IS NOT INITIAL.

        " PIR 수량 조건
        SELECT SINGLE bstma, minbm FROM ztb11eine
          WHERE inf_uuid = @ls_item-InfUuid
            AND werks    = @ls_item-Werks
          INTO @DATA(ls_pir).

        IF sy-subrc = 0.

          IF ls_pir-bstma IS NOT INITIAL AND ls_item-Menge > ls_pir-bstma.

            " 최대수량 초과
            APPEND VALUE #( %tky = ls_item-%tky ) TO failed-poitem.
            APPEND VALUE #(
              %tky = ls_item-%tky
              %msg = new_message( id = 'ZMCB11' number = '059' severity = if_abap_behv_message=>severity-error )
              %element-Menge = if_abap_behv=>mk-on
            ) TO reported-poitem.

          ELSEIF ls_pir-minbm IS NOT INITIAL AND ls_item-Menge < ls_pir-minbm.

            " 최소수량 미만
            APPEND VALUE #( %tky = ls_item-%tky ) TO failed-poitem.
            APPEND VALUE #(
              %tky = ls_item-%tky
              %msg = new_message( id = 'ZMCB11' number = '060' severity = if_abap_behv_message=>severity-error )
              %element-Menge = if_abap_behv=>mk-on
            ) TO reported-poitem.

          ENDIF.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD ClearMatUuid.

    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POItem
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_item).

      " 자재 확인
      SELECT SINGLE mat_uuid FROM ztb11mara
        WHERE matnr = @ls_item-Matnr
        INTO @DATA(lv_matuuid).

      IF sy-subrc <> 0 OR ls_item-Matnr IS INITIAL.
        MODIFY ENTITIES OF zr_b11_ekko IN LOCAL MODE
          ENTITY POItem
          UPDATE FIELDS ( MatUuid Mtart )
          WITH VALUE #( ( %tky = ls_item-%tky
                          MatUuid = VALUE #( )
                          Mtart = VALUE #( )
                          ) ).
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD SetGrComplete.

    " 입고완료 처리
    MODIFY ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POItem
      UPDATE FIELDS ( Elikz )
      WITH VALUE #(
        FOR key IN keys
        (
          %tky  = key-%tky
          Elikz = 'X'
        )
      ).

  ENDMETHOD.

ENDCLASS.



CLASS lhc_poheader DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR poheader RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR poheader RESULT result.

    METHODS setebeln FOR DETERMINE ON SAVE
      IMPORTING keys FOR poheader~setebeln.

    METHODS setbedat FOR DETERMINE ON MODIFY
      IMPORTING keys FOR poheader~setbedat.

    METHODS setwaers FOR DETERMINE ON MODIFY
      IMPORTING keys FOR poheader~setwaers.

    METHODS checklifnr FOR VALIDATE ON SAVE
      IMPORTING keys FOR poheader~checklifnr.

    METHODS checkbedat FOR VALIDATE ON SAVE
      IMPORTING keys FOR poheader~checkbedat.

    METHODS setblocked FOR MODIFY
      IMPORTING keys FOR ACTION poheader~setblocked.
    METHODS clearlifuuid FOR DETERMINE ON MODIFY
      IMPORTING keys FOR poheader~clearlifuuid.

ENDCLASS.


CLASS lhc_poheader IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD get_instance_features.

    " Header 조회
    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POHeader
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(result_header).

    LOOP AT result_header INTO DATA(ls_header).

      APPEND VALUE #( %tky = ls_header-%tky ) TO result ASSIGNING FIELD-SYMBOL(<ls_result>).

      " Draft / Active 제어
      IF ls_header-%is_draft = if_abap_behv=>mk-on.
        <ls_result>-%action-SetBlocked = if_abap_behv=>fc-o-disabled.
        <ls_result>-%delete = if_abap_behv=>fc-o-enabled.
      ELSE.
        <ls_result>-%delete = if_abap_behv=>fc-o-disabled.

        IF ls_header-Loekz = 'X'.
          <ls_result>-%action-SetBlocked = if_abap_behv=>fc-o-disabled.
        ELSE.
          <ls_result>-%action-SetBlocked = if_abap_behv=>fc-o-enabled.
        ENDIF.
      ENDIF.

      " 삭제 필드 제어
      SELECT SINGLE ebeln_uuid FROM ztb11ekko
        WHERE ebeln_uuid = @ls_header-EbelnUuid
        INTO @DATA(lv_ebelnuuid).

      IF sy-subrc = 0.
        <ls_result>-%field-Loekz = if_abap_behv=>fc-f-unrestricted.
      ELSE.
        <ls_result>-%field-Loekz = if_abap_behv=>fc-f-read_only.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD SetEbeln.

    DATA lv_num TYPE numc10.

    " Header 조회
    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POHeader
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(result_header).

    LOOP AT result_header INTO DATA(ls_header).

      IF ls_header-Ebeln IS NOT INITIAL.
        CONTINUE.
      ENDIF.

      " 구매오더번호 채번
      TRY.

          cl_numberrange_runtime=>number_get(
            EXPORTING object = 'ZNRB1104' nr_range_nr = '01'
            IMPORTING number = DATA(lv_number_raw) returncode = DATA(lv_returncode)
          ).

        CATCH cx_number_ranges INTO DATA(lx_nr).

          APPEND VALUE #(
            %tky = ls_header-%tky
            %msg = new_message_with_text(
              severity = if_abap_behv_message=>severity-error
              text = lx_nr->get_text( )
            )
          ) TO reported-poheader.

          CONTINUE.

      ENDTRY.

      lv_num = lv_number_raw.

      MODIFY ENTITIES OF zr_b11_ekko IN LOCAL MODE
        ENTITY POHeader
        UPDATE FIELDS ( Ebeln )
        WITH VALUE #( ( %tky = ls_header-%tky Ebeln = lv_num ) )
        FAILED DATA(lt_failed)
        REPORTED DATA(lt_reported).

      IF lt_failed-poheader IS NOT INITIAL.
        APPEND VALUE #(
          %tky = ls_header-%tky
          %msg = new_message( id = 'ZMCB11' number = '032' severity = if_abap_behv_message=>severity-error )
        ) TO reported-poheader.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD SetBedat.

    " 생성일 기본값
    MODIFY ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POHeader
      UPDATE FIELDS ( Bedat )
      WITH VALUE #( FOR key IN keys ( %tky = key-%tky Bedat = sy-datum ) ).

  ENDMETHOD.


  METHOD SetWaers.

    " Header 조회
    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POHeader
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(result_header).

    LOOP AT result_header INTO DATA(ls_header).

      SELECT SINGLE Waers FROM ztb11lfa1
        WHERE lif_uuid = @ls_header-LifUuid
        INTO @DATA(lv_waers).

      " 통화 설정
      MODIFY ENTITIES OF zr_b11_ekko IN LOCAL MODE
        ENTITY POHeader
        UPDATE FIELDS ( Waers )
        WITH VALUE #( ( %tky = ls_header-%tky Waers = lv_waers ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckLifnr.

    " Vendor 확인
    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POHeader
      FIELDS ( LifUuid Lifnr )
      WITH CORRESPONDING #( keys )
      RESULT DATA(result_header).

    LOOP AT result_header INTO DATA(ls_header).

      " 이전 메시지 초기화
      APPEND VALUE #( %tky = ls_header-%tky %state_area = 'CHECK_LIFNR' ) TO reported-poheader.

      IF ls_header-Lifnr IS INITIAL.

        " Vendor 필수
        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-poheader.
        APPEND VALUE #(
          %tky = ls_header-%tky
          %state_area = 'CHECK_LIFNR'
          %msg = new_message( id = 'ZMCB11' number = '036' severity = if_abap_behv_message=>severity-error )
          %element-Lifnr = if_abap_behv=>mk-on
        ) TO reported-poheader.

      ELSE.

        SELECT SINGLE Lifnr, Loevm FROM ztb11lfa1
          WHERE lif_uuid = @ls_header-LifUuid
          INTO @DATA(ls_lifnr).

        IF sy-subrc <> 0.

          " Vendor 없음
          APPEND VALUE #( %tky = ls_header-%tky ) TO failed-poheader.
          APPEND VALUE #(
            %tky = ls_header-%tky
            %state_area = 'CHECK_LIFNR'
            %msg = new_message( id = 'ZMCB11' number = '037' severity = if_abap_behv_message=>severity-error )
            %element-Lifnr = if_abap_behv=>mk-on
          ) TO reported-poheader.

        ELSEIF ls_lifnr-Loevm = 'X'.

          " 삭제 Vendor
          APPEND VALUE #( %tky = ls_header-%tky ) TO failed-poheader.
          APPEND VALUE #(
            %tky = ls_header-%tky
            %state_area = 'CHECK_LIFNR'
            %msg = new_message( id = 'ZMCB11' number = '049' severity = if_abap_behv_message=>severity-error )
            %element-Lifnr = if_abap_behv=>mk-on
          ) TO reported-poheader.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CheckBedat.

    " 생성일 확인
    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POHeader
      FIELDS ( Bedat )
      WITH CORRESPONDING #( keys )
      RESULT DATA(result_header).

    LOOP AT result_header INTO DATA(ls_header).

      " 이전 메시지 초기화
      APPEND VALUE #( %tky = ls_header-%tky %state_area = 'CHECK_BEDAT' ) TO reported-poheader.

      IF ls_header-Bedat IS INITIAL.

        " 날짜 필수
        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-poheader.
        APPEND VALUE #(
          %tky = ls_header-%tky
          %state_area = 'CHECK_BEDAT'
          %msg = new_message( id = 'ZMCB11' number = '051' severity = if_abap_behv_message=>severity-error )
          %element-Bedat = if_abap_behv=>mk-on
        ) TO reported-poheader.

      ELSEIF sy-datum < ls_header-Bedat.

        " 미래 날짜 방지
        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-poheader.
        APPEND VALUE #(
          %tky = ls_header-%tky
          %state_area = 'CHECK_BEDAT'
          %msg = new_message( id = 'ZMCB11' number = '048' severity = if_abap_behv_message=>severity-error )
          %element-Bedat = if_abap_behv=>mk-on
        ) TO reported-poheader.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD SetBlocked.

    " Header 조회
    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POHeader
      FIELDS ( Loekz )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    LOOP AT lt_header INTO DATA(ls_header).

      IF ls_header-Loekz = 'X'.
        CONTINUE.
      ENDIF.

      " Header 삭제
      MODIFY ENTITIES OF zr_b11_ekko IN LOCAL MODE
        ENTITY POHeader
        UPDATE FIELDS ( Loekz )
        WITH VALUE #( ( %tky = ls_header-%tky Loekz = 'X' ) )
        FAILED DATA(lt_failed)
        REPORTED DATA(lt_reported).

      IF lt_failed-poheader IS NOT INITIAL.

        APPEND VALUE #(
          %tky = ls_header-%tky
          %msg = new_message( id = 'ZMCB11' number = '053' severity = if_abap_behv_message=>severity-error )
        ) TO reported-poheader.

        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-poheader.
        CONTINUE.

      ENDIF.

      " 하위 Item 조회
      READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
        ENTITY POHeader BY \_POItem
        FIELDS ( EbelnUuid Ebelp Loekz )
        WITH VALUE #( ( %tky = ls_header-%tky ) )
        RESULT DATA(lt_item).

      " Item 삭제
      MODIFY ENTITIES OF zr_b11_ekko IN LOCAL MODE
        ENTITY POItem
        UPDATE FIELDS ( Loekz )
        WITH VALUE #( FOR ls_item IN lt_item ( %tky = ls_item-%tky Loekz = 'X' ) )
        FAILED lt_failed
        REPORTED lt_reported.

      IF lt_failed-poitem IS NOT INITIAL.

        APPEND VALUE #(
          %tky = ls_header-%tky
          %msg = new_message( id = 'ZMCB11' number = '055' severity = if_abap_behv_message=>severity-error )
        ) TO reported-poheader.

        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-poheader.
        CONTINUE.

      ENDIF.

      " 성공 메시지
      APPEND VALUE #(
        %tky = ls_header-%tky
        %msg = new_message( id = 'ZMCB11' number = '054' severity = if_abap_behv_message=>severity-success )
      ) TO reported-poheader.

    ENDLOOP.

  ENDMETHOD.

  METHOD ClearLifUuid.

    READ ENTITIES OF zr_b11_ekko IN LOCAL MODE
      ENTITY POHeader
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_header).

      " 공급업체 확인
      SELECT SINGLE lif_uuid FROM ztb11lfa1
        WHERE lifnr = @ls_header-Lifnr
        INTO @DATA(lv_lifuuid).

      IF sy-subrc <> 0 OR ls_header-Lifnr IS INITIAL.
        MODIFY ENTITIES OF zr_b11_ekko IN LOCAL MODE
          ENTITY POHeader
          UPDATE FIELDS ( LifUuid )
          WITH VALUE #( ( %tky = ls_header-%tky LifUuid = VALUE #( ) ) ).
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
