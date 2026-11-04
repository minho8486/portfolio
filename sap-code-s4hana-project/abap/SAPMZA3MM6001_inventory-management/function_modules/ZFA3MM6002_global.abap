FUNCTION-POOL zfga3mm61.                    "MESSAGE-ID ..



* INCLUDE LZFGA3MM61D...                     " Local class definition



DATA: gt_domain TYPE dd07v_tab,
      gt_pname  TYPE TABLE OF zta3mm0006_t,
      gs_pname  LIKE LINE OF gt_pname.

DATA: BEGIN OF gs_empnm,
        empid TYPE zta3hr0002-empid,
        empnm TYPE zta3hr0002-empnm,
      END OF gs_empnm,
      gt_empnm LIKE TABLE OF gs_empnm.
