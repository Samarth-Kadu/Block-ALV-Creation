REPORT ZPRG_BLOCK_ALV.


TYPES : BEGIN OF STR1,
    VBELN TYPE VBELN_VA,
    ERDAT TYPE ERDAT,
    ERZET TYPE ERZET,
    ERNAM TYPE ERNAM,
    VBTYP TYPE VBTYP,
  END OF STR1.

DATA : LT_DATA1 TYPE TABLE OF STR1.
DATA : WA_DATA1  TYPE STR1.

TYPES : BEGIN OF STR2,
      VBELN TYPE VBELN_VA,
      POSNR TYPE POSNR_VA,
      MATNR TYPE MATNR,
  END OF STR2.

DATA : LT_DATA2 TYPE TABLE OF  STR2.
DATA : WA_DATA2 TYPE STR2.


DATA: VBELN TYPE VBELN_VA.
SELECT-OPTIONS : s_vbeln FOR vbeln.

 DATA : LT_FIELDCAT_VBAK TYPE SLIS_T_FIELDCAT_ALV.
 DATA : LT_FIELDCAT_VBAP TYPE SLIS_T_FIELDCAT_ALV.
 DATA : WA_FIELDCAT_VBAK TYPE slis_fieldcat_alv.
 DATA : WA_FIELDCAT_VBAP TYPE slis_fieldcat_alv.
 DATA : LWA_LAYOUT TYPE SLIS_LAYOUT_ALV.
 DATA : LT_EVENT TYPE SLIS_T_EVENT.
 DATA : LWA_LAYOUT_VBAP TYPE SLIS_LAYOUT_ALV.
 DATA : LT_EVENT_VBAP TYPE SLIS_T_EVENT.



SELECT VBELN ERDAT ERZET ERNAM VBTYP
FROM VBAK
INTO TABLE LT_DATA1
WHERE VBELN IN S_VBELN.

IF LT_DATA1 IS NOT INITIAL.
  SELECT VBELN POSNR MATNR
  FROM VBAP
  INTO TABLE LT_DATA2
  FOR ALL ENTRIES IN LT_DATA1
  WHERE VBELN = LT_DATA1-VBELN.
 ENDIF.

WA_FIELDCAT_VBAK-col_pos = 1.
WA_FIELDCAT_VBAK-fieldname = 'VBELN'.
WA_FIELDCAT_VBAK-tabname = 'LV_VBAK'.
WA_FIELDCAT_VBAK-seltext_l = 'Sales Document Number'.
APPEND WA_FIELDCAT_VBAK TO LT_FIELDCAT_VBAK.
CLEAR WA_FIELDCAT_VBAK.

WA_FIELDCAT_VBAK-col_pos = 2.
WA_FIELDCAT_VBAK-fieldname = 'ERDAT'.
WA_FIELDCAT_VBAK-tabname = 'LV_VBAK'.
WA_FIELDCAT_VBAK-seltext_l = 'Date of Creation'.
APPEND WA_FIELDCAT_VBAK TO LT_FIELDCAT_VBAK.
CLEAR WA_FIELDCAT_VBAK.

WA_FIELDCAT_VBAK-col_pos = 3.
WA_FIELDCAT_VBAK-fieldname = 'ERZET'.
WA_FIELDCAT_VBAK-tabname = 'LV_VBAK'.
WA_FIELDCAT_VBAK-seltext_l = 'Time'.
APPEND WA_FIELDCAT_VBAK TO LT_FIELDCAT_VBAK.
CLEAR WA_FIELDCAT_VBAK.

WA_FIELDCAT_VBAK-col_pos = 4.
WA_FIELDCAT_VBAK-fieldname = 'ERNAM'.
WA_FIELDCAT_VBAK-tabname = 'LV_VBAK'.
WA_FIELDCAT_VBAK-seltext_l = 'Name'.
APPEND WA_FIELDCAT_VBAK TO LT_FIELDCAT_VBAK.
CLEAR WA_FIELDCAT_VBAK.

WA_FIELDCAT_VBAK-col_pos = 5.
WA_FIELDCAT_VBAK-fieldname = 'VBTYP'.
WA_FIELDCAT_VBAK-tabname = 'LV_VBAK'.
WA_FIELDCAT_VBAK-seltext_l = 'Category'.
APPEND WA_FIELDCAT_VBAK TO LT_FIELDCAT_VBAK.
CLEAR WA_FIELDCAT_VBAK.

WA_FIELDCAT_VBAP-col_pos = 1.
WA_FIELDCAT_VBAP-fieldname = 'VBELN'.
WA_FIELDCAT_VBAP-tabname = 'LV_VBAP'.
WA_FIELDCAT_VBAP-seltext_l = 'Sales Item Number'.
APPEND WA_FIELDCAT_VBAP TO LT_FIELDCAT_VBAP.
CLEAR WA_FIELDCAT_VBAP.

WA_FIELDCAT_VBAP-col_pos = 2.
WA_FIELDCAT_VBAP-fieldname = 'POSNR'.
WA_FIELDCAT_VBAP-tabname = 'LV_VBAP'.
WA_FIELDCAT_VBAP-seltext_l = 'Item Number'.
APPEND WA_FIELDCAT_VBAP TO LT_FIELDCAT_VBAP.
CLEAR WA_FIELDCAT_VBAP.

WA_FIELDCAT_VBAP-col_pos = 3.
WA_FIELDCAT_VBAP-fieldname = 'MATNR'.
WA_FIELDCAT_VBAP-tabname = 'LV_VBAP'.
WA_FIELDCAT_VBAP-seltext_l = 'Material'.
APPEND WA_FIELDCAT_VBAP TO LT_FIELDCAT_VBAP.
CLEAR WA_FIELDCAT_VBAP.


CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_INIT'
  EXPORTING
    I_CALLBACK_PROGRAM             = sy-repid
*   I_CALLBACK_PF_STATUS_SET       = ' '
*   I_CALLBACK_USER_COMMAND        = ' '
*   IT_EXCLUDING                   =
          .

CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_APPEND'
  EXPORTING
    IS_LAYOUT                        = LWA_LAYOUT
    IT_FIELDCAT                      = LT_FIELDCAT_VBAK
    I_TABNAME                        = 'LT_DATA1'
    IT_EVENTS                        = LT_EVENT
*   IT_SORT                          =
*   I_TEXT                           = ' '
  TABLES
    T_OUTTAB                         = LT_DATA1
 EXCEPTIONS
   PROGRAM_ERROR                    = 1
   MAXIMUM_OF_APPENDS_REACHED       = 2
   OTHERS                           = 3
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.


CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_APPEND'
  EXPORTING
    IS_LAYOUT                        = LWA_LAYOUT_VBAP
    IT_FIELDCAT                      = LT_FIELDCAT_VBAP
    I_TABNAME                        = 'LT_DATA2'
    IT_EVENTS                        = LT_EVENT_VBAP
*   IT_SORT                          =
*   I_TEXT                           = ' '
  TABLES
    T_OUTTAB                         = LT_DATA2
 EXCEPTIONS
   PROGRAM_ERROR                    = 1
   MAXIMUM_OF_APPENDS_REACHED       = 2
   OTHERS                           = 3
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.


CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_DISPLAY'
* EXPORTING
*   I_INTERFACE_CHECK             = ' '
*   IS_PRINT                      =
*   I_SCREEN_START_COLUMN         = 0
*   I_SCREEN_START_LINE           = 0
*   I_SCREEN_END_COLUMN           = 0
*   I_SCREEN_END_LINE             = 0
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER       =
*   ES_EXIT_CAUSED_BY_USER        =
 EXCEPTIONS
   PROGRAM_ERROR                 = 1
   OTHERS                        = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.