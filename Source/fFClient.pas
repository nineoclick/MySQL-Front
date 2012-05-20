unit fFClient;

interface {********************************************************************}

uses
  Forms, Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Dialogs, ActnList, ComCtrls, ExtCtrls, Menus, StdCtrls, DB, DBGrids, Grids,
  DBCtrls, DBActns, StdActns, ImgList, XMLIntf,
  ShDocVw, CommCtrl, PNGImage, GIFImg, Jpeg,
  MPHexEditor, MPHexEditorEx,
  SynEdit, SynEditHighlighter, SynMemo, SynEditMiscClasses, SynEditSearch,
  SynCompletionProposal, SynEditPrint,
  acSQL92SynProvider, acQBBase, acAST, acQBEventMetaProvider, acMYSQLSynProvider, acSQLBuilderPlainText,
  ComCtrls_Ext, StdCtrls_Ext, Dialogs_Ext, Forms_Ext, ExtCtrls_Ext,
  MySQLDB, MySQLDBGrid,
  fDExport, fDImport, fClient, fAccount, fBase, fPreferences, fTools,
  fCWorkbench, ToolWin;

const
  CM_ACTIVATEFGRID = WM_USER + 500;
  CM_ACTIVATEFTEXT = WM_USER + 501;
  CM_POSTPOSTSCROLL = WM_USER + 502;
  CM_ACTIVATEFRAME = WM_USER + 503;
  CM_DEACTIVATEFRAME = WM_USER + 504;
  CM_EXECUTE = WM_USER + 505;
  CM_UPDATETOOLBAR = WM_USER + 506;
  CM_BOOKMARKCHANGED = WM_USER + 507;
  CM_POST_BUILDER_QUERY_CHANGE = WM_USER + 508;
  CM_POST_MONITOR = WM_USER + 509;
  CM_REMOVE_WFOREIGENKEY = WM_USER + 510;
  WM_WANTED_SYNCHRONIZE = WM_USER + 511;

  sbMessage = 0;
  sbItem = 1;
  sbSummarize = 2;
  sbConnected = 3;

type
  TLastDataSource = record ResultSet: TCResultSet; DataSet: TDataSet; end;
  TSynMemoBeforeDrag = record SelStart: Integer; SelLength: Integer; end;
  TFListSortColumn = array [0 .. 7] of record Index: Integer; Order: Integer; end;
  TSQLEditor = record Filename: TFileName; CodePage: Cardinal; end;

type
  TFClient = class (TFrame)
    ActionList: TActionList;
    aDCreate: TAction;
    aDDelete: TAction;
    aDDeleteRecord: TDataSetDelete;
    aDInsertRecord: TDataSetInsert;
    aDNext: TAction;
    aDPrev: TAction;
    aEClearAll: TAction;
    aPCollapse: TAction;
    aPExpand: TAction;
    aPObjectBrowserTable: TAction;
    aPOpenInNewTab: TAction;
    aPOpenInNewWindow: TAction;
    aPResult: TAction;
    aTBFilter: TAction;
    aTBLimit: TAction;
    aTBOffset: TAction;
    aTBQuickSearch: TAction;
    aVBlobHexEditor: TAction;
    aVBlobHTML: TAction;
    aVBlobImage: TAction;
    aVBlobRTF: TAction;
    aVBlobText: TAction;
    BDELETE: TButton;
    BINSERT: TButton;
    BREPLACE: TButton;
    BUPDATE: TButton;
    DataSetCancel: TDataSetCancel;
    DataSetDelete: TDataSetDelete;
    DataSetFirst: TDataSetFirst;
    DataSetLast: TDataSetLast;
    DataSetPost: TDataSetPost;
    FBlobSearch: TEdit;
    FBookmarks: TListView;
    FBuilder: TacQueryBuilder;
    FBuilderEditor: TSynMemo;
    FFilter: TComboBox_Ext;
    FFilterEnabled: TToolButton;
    FGrid: TMySQLDBGrid;
    FGridDataSource: TDataSource;
    FHexEditor: TMPHexEditorEx;
    FImage: TImage;
    FLimit: TEdit;
    FLimitEnabled: TToolButton;
    FList: TListView_Ext;
    FLog: TRichEdit;
    FNavigator: TTreeView_Ext;
    FObjectIDEGrid: TMySQLDBGrid;
    FOffset: TEdit;
    FQuickSearch: TEdit;
    FQuickSearchEnabled: TToolButton;
    FRTF: TRichEdit;
    FSQLEditor: TSynMemo;
    FSQLEditorCompletion: TSynCompletionProposal;
    FSQLEditorPrint: TSynEditPrint;
    FSQLEditorSearch: TSynEditSearch;
    FSQLHistory: TTreeView_Ext;
    FText: TMemo_Ext;
    FUDLimit: TUpDown;
    FUDOffset: TUpDown;
    gmDDeleteRecord: TMenuItem;
    gmDEditRecord: TMenuItem;
    gmDInsertRecord: TMenuItem;
    gmECopy: TMenuItem;
    gmECopyToFile: TMenuItem;
    gmECut: TMenuItem;
    gmEDelete: TMenuItem;
    gmEPaste: TMenuItem;
    gmEPasteFromFile: TMenuItem;
    gmFExport: TMenuItem;
    gmFExportExcel: TMenuItem;
    gmFExportHTML: TMenuItem;
    gmFExportSQL: TMenuItem;
    gmFExportText: TMenuItem;
    gmFExportXML: TMenuItem;
    gmFilter: TMenuItem;
    hmECopy: TMenuItem;
    hmECut: TMenuItem;
    hmEDelete: TMenuItem;
    hmEPaste: TMenuItem;
    hmESelectAll: TMenuItem;
    mbBAdd: TMenuItem;
    mbBDelete: TMenuItem;
    mbBEdit: TMenuItem;
    mbBOpen: TMenuItem;
    mbBOpenInNewTab: TMenuItem;
    mbBOpenInNewWindow: TMenuItem;
    MBookmarks: TPopupMenu;
    MetadataProvider: TacEventMetadataProvider;
    MGrid: TPopupMenu;
    MGridHeader: TPopupMenu;
    MHexEditor: TPopupMenu;
    miHCollapse: TMenuItem;
    miHCopy: TMenuItem;
    miHExpand: TMenuItem;
    miHOpen: TMenuItem;
    miHProperties: TMenuItem;
    miHRun: TMenuItem;
    miHSaveAs: TMenuItem;
    miHStatementIntoSQLEditor: TMenuItem;
    miNCollapse: TMenuItem;
    miNCopy: TMenuItem;
    miNCreate: TMenuItem;
    miNCreateDatabase: TMenuItem;
    miNCreateEvent: TMenuItem;
    miNCreateField: TMenuItem;
    miNCreateForeignKey: TMenuItem;
    miNCreateFunction: TMenuItem;
    miNCreateHost: TMenuItem;
    miNCreateIndex: TMenuItem;
    miNCreateProcedure: TMenuItem;
    miNCreateTable: TMenuItem;
    miNCreateTrigger: TMenuItem;
    miNCreateUser: TMenuItem;
    miNCreateView: TMenuItem;
    miNDelete: TMenuItem;
    miNEmpty: TMenuItem;
    miNExpand: TMenuItem;
    miNExport: TMenuItem;
    miNExportAccess: TMenuItem;
    miNExportExcel: TMenuItem;
    miNExportHTML: TMenuItem;
    miNExportODBC: TMenuItem;
    miNExportSQL: TMenuItem;
    miNExportSQLite: TMenuItem;
    miNExportText: TMenuItem;
    miNExportXML: TMenuItem;
    miNImport: TMenuItem;
    miNImportAccess: TMenuItem;
    miNImportExcel: TMenuItem;
    miNImportODBC: TMenuItem;
    miNImportSQL: TMenuItem;
    miNImportSQLite: TMenuItem;
    miNImportText: TMenuItem;
    miNImportXML: TMenuItem;
    miNOpenInNewTab: TMenuItem;
    miNOpenInNewWinodow: TMenuItem;
    miNPaste: TMenuItem;
    miNProperties: TMenuItem;
    miNRename: TMenuItem;
    miSBookmarks: TMenuItem;
    miSNavigator: TMenuItem;
    miSSQLHistory: TMenuItem;
    mlDCreate: TMenuItem;
    mlDCreateDatabase: TMenuItem;
    mlDCreateEvent: TMenuItem;
    mlDCreateField: TMenuItem;
    mlDCreateForeignKey: TMenuItem;
    mlDCreateFunction: TMenuItem;
    mlDCreateHost: TMenuItem;
    mlDCreateIndex: TMenuItem;
    mlDCreateProcedure: TMenuItem;
    mlDCreateTable: TMenuItem;
    mlDCreateTrigger: TMenuItem;
    mlDCreateUser: TMenuItem;
    mlDCreateView: TMenuItem;
    mlDDelete: TMenuItem;
    mlDEmpty: TMenuItem;
    mlECopy: TMenuItem;
    mlEPaste: TMenuItem;
    mlEProperties: TMenuItem;
    mlERename: TMenuItem;
    mlFExport: TMenuItem;
    mlFExportAccess: TMenuItem;
    mlFExportExcel: TMenuItem;
    mlFExportHTML: TMenuItem;
    mlFExportODBC: TMenuItem;
    mlFExportSQL: TMenuItem;
    mlFExportSQLite: TMenuItem;
    mlFExportText: TMenuItem;
    mlFExportXML: TMenuItem;
    mlFImport: TMenuItem;
    mlFImportAccess: TMenuItem;
    mlFImportExcel: TMenuItem;
    mlFImportODBC: TMenuItem;
    mlFImportSQL: TMenuItem;
    mlFImportSQLite: TMenuItem;
    mlFImportText: TMenuItem;
    mlFImportXML: TMenuItem;
    MList: TPopupMenu;
    MLog: TPopupMenu;
    mlOpen: TMenuItem;
    mlOpenInNewTab: TMenuItem;
    mlOpenInNewWinodow: TMenuItem;
    MNavigator: TPopupMenu;
    mpDRun: TMenuItem;
    mpDRunSelection: TMenuItem;
    mpECopy: TMenuItem;
    mpECopyToFile: TMenuItem;
    mpECut: TMenuItem;
    mpEDelete: TMenuItem;
    mpEPaste: TMenuItem;
    mpEPasteFromFile: TMenuItem;
    mpESelectAll: TMenuItem;
    MSideBar: TPopupMenu;
    MSQLEditor: TPopupMenu;
    MSQLHistory: TPopupMenu;
    mtDataBrowser: TMenuItem;
    mtDiagram: TMenuItem;
    MText: TPopupMenu;
    mtObjectIDE: TMenuItem;
    MToolBar: TPopupMenu;
    mtQueryBuilder: TMenuItem;
    mtSQLEditor: TMenuItem;
    mwAddTable: TMenuItem;
    mwCreateLine: TMenuItem;
    mwCreateSection: TMenuItem;
    mwDCreate: TMenuItem;
    mwDCreateField: TMenuItem;
    mwDCreateForeignKey: TMenuItem;
    mwDCreateTable: TMenuItem;
    mwDDelete: TMenuItem;
    mwDEmpty: TMenuItem;
    mwDProperties: TMenuItem;
    mwECopy: TMenuItem;
    mwEDelete: TMenuItem;
    mwEPaste: TMenuItem;
    mwFExport: TMenuItem;
    mwFExportAccess: TMenuItem;
    mwFExportBitmap: TMenuItem;
    mwFExportExcel: TMenuItem;
    mwFExportHTML: TMenuItem;
    mwFExportODBC: TMenuItem;
    mwFExportSQL: TMenuItem;
    mwFExportSQLite: TMenuItem;
    mwFExportText: TMenuItem;
    mwFExportXML: TMenuItem;
    mwFImport: TMenuItem;
    mwFImportAccess: TMenuItem;
    mwFImportExcel: TMenuItem;
    mwFImportODBC: TMenuItem;
    mwFImportSQL: TMenuItem;
    mwFImportSQLite: TMenuItem;
    mwFImportText: TMenuItem;
    mwFImportXML: TMenuItem;
    MWorkbench: TPopupMenu;
    mwPOpenInNewTab: TMenuItem;
    mwPOpenInNewWinodw: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    N34: TMenuItem;
    N35: TMenuItem;
    N36: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    OpenDialog: TOpenDialog_Ext;
    PBlob: TPanel_Ext;
    PBlobSpacer: TPanel_Ext;
    PBookmarks: TPanel_Ext;
    PBuilder: TPanel_Ext;
    PBuilderQuery: TPanel_Ext;
    PContent: TPanel_Ext;
    PDataBrowser: TPanel_Ext;
    PDataBrowserSpacer: TPanel_Ext;
    PGrid: TPanel_Ext;
    PHeader: TPanel_Ext;
    PList: TPanel_Ext;
    PLog: TPanel_Ext;
    PLogHeader: TPanel_Ext;
    PNavigator: TPanel_Ext;
    PObjectIDE: TPanel_Ext;
    PObjectIDEGridDataSource: TDataSource;
    PObjectIDESpacer: TPanel_Ext;
    PObjectIDETrigger: TPanel_Ext;
    PResult: TPanel_Ext;
    PResultHeader: TPanel_Ext;
    PResult_2: TPanel_Ext;
    PrintDialog: TPrintDialog_Ext;
    PSideBar: TPanel_Ext;
    PSideBarHeader: TPanel_Ext;
    PSQLEditor: TPanel_Ext;
    PSQLHistory: TPanel_Ext;
    PToolBar: TPanel_Ext;
    PWorkbench: TPanel_Ext;
    SaveDialog: TSaveDialog_Ext;
    SBlob: TSplitter_Ext;
    SBResult: TStatusBar;
    SBuilderQuery: TSplitter_Ext;
    SLog: TSplitter_Ext;
    smECopy: TMenuItem;
    smECopyToFile: TMenuItem;
    smEEmpty: TMenuItem;
    smESelectAll: TMenuItem;
    SQLBuilder: TacSQLBuilderPlainText;
    SResult: TSplitter_Ext;
    SSideBar: TSplitter_Ext;
    SyntaxProvider: TacMYSQLSyntaxProvider;
    tbBlobHexEditor: TToolButton;
    tbBlobHTML: TToolButton;
    tbBlobImage: TToolButton;
    tbBlobRTF: TToolButton;
    tbBlobSpacer: TPanel_Ext;
    tbBlobText: TToolButton;
    tbBookmarks: TToolButton;
    tbDataBrowser: TToolButton;
    tbDiagram: TToolButton;
    tbNavigator: TToolButton;
    tbObjectBrowser: TToolButton;
    tbObjectIDE: TToolButton;
    tbQueryBuilder: TToolButton;
    TBSideBar: TToolBar;
    tbSQLEditor: TToolButton;
    tbSQLHistory: TToolButton;
    TCResult: TTabControl;
    tmECopy: TMenuItem;
    tmECut: TMenuItem;
    tmEDelete: TMenuItem;
    tmEPaste: TMenuItem;
    tmESelectAll: TMenuItem;
    ToolBar: TToolBar;
    ToolBarBlob: TToolBar;
    ToolBarFilterEnabled: TToolBar;
    ToolBarLimitEnabled: TToolBar;
    ToolBarQuickSearchEnabled: TToolBar;
    TSXML: TTabSheet;
    procedure aBAddExecute(Sender: TObject);
    procedure aBDeleteExecute(Sender: TObject);
    procedure aBEditExecute(Sender: TObject);
    procedure aDCreateDatabaseExecute(Sender: TObject);
    procedure aDCreateEventExecute(Sender: TObject);
    procedure aDCreateExecute(Sender: TObject);
    procedure aDCreateFieldExecute(Sender: TObject);
    procedure aDCreateForeignKeyExecute(Sender: TObject);
    procedure aDCreateHostExecute(Sender: TObject);
    procedure aDCreateIndexExecute(Sender: TObject);
    procedure aDCreateRoutineExecute(Sender: TObject);
    procedure aDCreateTableExecute(Sender: TObject);
    procedure aDCreateTriggerExecute(Sender: TObject);
    procedure aDCreateUserExecute(Sender: TObject);
    procedure aDCreateViewExecute(Sender: TObject);
    procedure aDDeleteExecute(Sender: TObject);
    procedure aDDeleteHostExecute(Sender: TObject);
    procedure aDDeleteRecordExecute(Sender: TObject);
    procedure aDDeleteUserExecute(Sender: TObject);
    procedure aDInsertRecordExecute(Sender: TObject);
    procedure aDNextExecute(Sender: TObject);
    procedure aDPrevExecute(Sender: TObject);
    procedure aDPropertiesExecute(Sender: TObject);
    procedure aEClearAllExecute(Sender: TObject);
    procedure aEPasteFromFileExecute(Sender: TObject);
    procedure aFExportAccessExecute(Sender: TObject);
    procedure aFExportBitmapExecute(Sender: TObject);
    procedure aFExportExcelExecute(Sender: TObject);
    procedure aFExportHTMLExecute(Sender: TObject);
    procedure aFExportODBCExecute(Sender: TObject);
    procedure aFExportSQLExecute(Sender: TObject);
    procedure aFExportSQLiteExecute(Sender: TObject);
    procedure aFExportTextExecute(Sender: TObject);
    procedure aFExportXMLExecute(Sender: TObject);
    procedure aFImportAccessExecute(Sender: TObject);
    procedure aFImportExcelExecute(Sender: TObject);
    procedure aFImportODBCExecute(Sender: TObject);
    procedure aFImportSQLExecute(Sender: TObject);
    procedure aFImportSQLiteExecute(Sender: TObject);
    procedure aFImportTextExecute(Sender: TObject);
    procedure aFImportXMLExecute(Sender: TObject);
    procedure aHRunClick(Sender: TObject);
    procedure aHRunExecute(Sender: TObject);
    procedure aPCollapseExecute(Sender: TObject);
    procedure aPExpandExecute(Sender: TObject);
    procedure aPObjectBrowserTableExecute(Sender: TObject);
    procedure aPOpenInNewTabExecute(Sender: TObject);
    procedure aPOpenInNewWindowExecute(Sender: TObject);
    procedure aPResultExecute(Sender: TObject);
    procedure aSSearchFindNotFound(Sender: TObject);
    procedure aTBFilterExecute(Sender: TObject);
    procedure aTBLimitExecute(Sender: TObject);
    procedure aTBOffsetExecute(Sender: TObject);
    procedure aTBQuickSearchExecute(Sender: TObject);
    procedure aVBlobExecute(Sender: TObject);
    procedure aVDetailsExecute(Sender: TObject);
    procedure aVSortAscExecute(Sender: TObject);
    procedure aVSortDescExecute(Sender: TObject);
    procedure BObjectIDEClick(Sender: TObject);
    procedure DataSetAfterCancel(DataSet: TDataSet);
    procedure DataSetAfterClose(DataSet: TDataSet);
    procedure DataSetAfterOpen(DataSet: TDataSet);
    procedure DataSetAfterPost(DataSet: TDataSet);
    procedure DataSetAfterScroll(DataSet: TDataSet);
    procedure DataSetBeforeCancel(DataSet: TDataSet);
    procedure DataSetBeforePost(DataSet: TDataSet);
    procedure DataSetBeforeReceivingRecords(DataSet: TDataSet);
    procedure DBGridColEnter(Sender: TObject);
    procedure DBGridColExit(Sender: TObject);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGridEnter(Sender: TObject);
    procedure DBGridExit(Sender: TObject);
    procedure DBGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FBlobResize(Sender: TObject);
    procedure FBlobSearchChange(Sender: TObject);
    procedure FBlobSearchKeyPress(Sender: TObject; var Key: Char);
    procedure FBookmarksChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FBookmarksDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FBookmarksDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FBookmarksEnter(Sender: TObject);
    procedure FBookmarksExit(Sender: TObject);
    procedure FBuilderDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure FBuilderDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FBuilderEditorChange(Sender: TObject);
    procedure FBuilderEditorEnter(Sender: TObject);
    procedure FBuilderEditorExit(Sender: TObject);
    procedure FBuilderEditorStatusChange(Sender: TObject;
      Changes: TSynStatusChanges);
    procedure FBuilderEnter(Sender: TObject);
    procedure FBuilderExit(Sender: TObject);
    procedure FBuilderResize(Sender: TObject);
    procedure FBuilderValidatePopupMenu(Sender: TacQueryBuilder;
      AControlOwner: TacQueryBuilderControlOwner; AForControl: TControl;
      APopupMenu: TPopupMenu);
    procedure FFilesEnter(Sender: TObject);
    procedure FFilterChange(Sender: TObject);
    procedure FFilterDropDown(Sender: TObject);
    procedure FFilterEnabledClick(Sender: TObject);
    procedure FFilterEnter(Sender: TObject);
    procedure FFilterKeyPress(Sender: TObject; var Key: Char);
    procedure FGridCellClick(Column: TColumn);
    procedure FGridColumnMoved(Sender: TObject; FromIndex: Integer;
      ToIndex: Integer);
    procedure FGridCopyToExecute(Sender: TObject);
    procedure FGridDataSourceDataChange(Sender: TObject; Field: TField);
    procedure FGridDblClick(Sender: TObject);
    procedure FGridEditButtonClick(Sender: TObject);
    procedure FGridEditExecute(Sender: TObject);
    procedure FGridEmptyClick(Sender: TObject);
    procedure FGridEmptyExecute(Sender: TObject);
    procedure FGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FGridTitleClick(Column: TColumn);
    procedure FHexEditorChange(Sender: TObject);
    procedure FHexEditorEnter(Sender: TObject);
    procedure FHexEditorKeyPress(Sender: TObject; var Key: Char);
    procedure FLimitChange(Sender: TObject);
    procedure FLimitEnabledClick(Sender: TObject);
    procedure FListChanging(Sender: TObject; Item: TListItem;
      Change: TItemChange; var AllowChange: Boolean);
    procedure FListColumnClick(Sender: TObject; Column: TListColumn);
    procedure FListCompare(Sender: TObject; Item1: TListItem;
      Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure FListData(Sender: TObject; Item: TListItem);
    procedure FListDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FListEdited(Sender: TObject; Item: TListItem;
      var S: string);
    procedure FListEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure FListEnter(Sender: TObject);
    procedure FListExit(Sender: TObject);
    procedure FListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FLogEnter(Sender: TObject);
    procedure FLogExit(Sender: TObject);
    procedure FLogSelectionChange(Sender: TObject);
    procedure FNavigatorChange(Sender: TObject; Node: TTreeNode);
    procedure FNavigatorChange2(Sender: TObject; Node: TTreeNode);
    procedure FNavigatorChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure FNavigatorDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure FNavigatorDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure FNavigatorEdited(Sender: TObject; Node: TTreeNode; var S: string);
    procedure FNavigatorEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure FNavigatorEnter(Sender: TObject);
    procedure FNavigatorExit(Sender: TObject);
    procedure FNavigatorExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure FNavigatorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FNavigatorKeyPress(Sender: TObject; var Key: Char);
    procedure FNavigatorSetMenuItems(Sender: TObject; const Node: TTreeNode);
    procedure FOffsetChange(Sender: TObject);
    procedure FOffsetKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure FQuickSearchChange(Sender: TObject);
    procedure FQuickSearchEnabledClick(Sender: TObject);
    procedure FQuickSearchKeyPress(Sender: TObject; var Key: Char);
    procedure FRTFChange(Sender: TObject);
    procedure FRTFEnter(Sender: TObject);
    procedure FRTFExit(Sender: TObject);
    procedure FSQLEditorCompletionClose(Sender: TObject);
    procedure FSQLEditorCompletionExecute(Kind: SynCompletionType;
      Sender: TObject; var CurrentInput: string; var x, y: Integer;
      var CanExecute: Boolean);
    procedure FSQLEditorCompletionPaintItem(Sender: TObject;
      Index: Integer; TargetCanvas: TCanvas; ItemRect: TRect;
      var CustomDraw: Boolean);
    procedure FSQLEditorCompletionShow(Sender: TObject);
    procedure FSQLEditorCompletionTimerTimer(Sender: TObject);
    procedure FSQLEditorEnter(Sender: TObject);
    procedure FSQLEditorExit(Sender: TObject);
    procedure FSQLEditorStatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure FSQLHistoryChange(Sender: TObject; Node: TTreeNode);
    procedure FSQLHistoryDblClick(Sender: TObject);
    procedure FSQLHistoryEnter(Sender: TObject);
    procedure FSQLHistoryExit(Sender: TObject);
    procedure FSQLHistoryKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FSQLHistoryKeyPress(Sender: TObject; var Key: Char);
    procedure FTextChange(Sender: TObject);
    procedure FTextEnter(Sender: TObject);
    procedure FTextExit(Sender: TObject);
    procedure FTextKeyPress(Sender: TObject; var Key: Char);
    procedure ListViewDblClick(Sender: TObject);
    procedure ListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mbBOpenClick(Sender: TObject);
    procedure MBookmarksPopup(Sender: TObject);
    procedure MetadataProviderGetSQLFieldNames(Sender: TacBaseMetadataProvider;
      const ASQL: WideString; AFields: TacFieldsList);
    procedure MGridHeaderPopup(Sender: TObject);
    procedure MGridPopup(Sender: TObject);
    procedure miHOpenClick(Sender: TObject);
    procedure miHPropertiesClick(Sender: TObject);
    procedure miHSaveAsClick(Sender: TObject);
    procedure miHStatementIntoSQLEditorClick(Sender: TObject);
    procedure MListPopup(Sender: TObject);
    procedure mlOpenClick(Sender: TObject);
    procedure MNavigatorPopup(Sender: TObject);
    procedure MSQLEditorPopup(Sender: TObject);
    procedure MSQLHistoryPopup(Sender: TObject);
    procedure MTextPopup(Sender: TObject);
    procedure MToolBarPopup(Sender: TObject);
    procedure mwCreateLineExecute(Sender: TObject);
    procedure mwCreateSectionClick(Sender: TObject);
    procedure mwDCreateForeignKeyClick(Sender: TObject);
    procedure mwEPasteClick(Sender: TObject);
    procedure MWorkbenchPopup(Sender: TObject);
    procedure PanelMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PanelPaint(Sender: TObject);
    procedure PanelResize(Sender: TObject);
    procedure PContentResize(Sender: TObject);
    procedure PGridResize(Sender: TObject);
    procedure PLogResize(Sender: TObject);
    procedure PObjectIDEResize(Sender: TObject);
    procedure PSideBarResize(Sender: TObject);
    procedure SearchNotFound(Sender: TObject; FindText: string);
    procedure SLogCanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure SLogMoved(Sender: TObject);
    procedure smEEmptyClick(Sender: TObject);
    procedure SplitterCanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure SQLBuilderSQLUpdated(Sender: TObject);
    procedure SResultMoved(Sender: TObject);
    procedure SSideBarCanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure SSideBarMoved(Sender: TObject);
    procedure SynMemoDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure SynMemoDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure TCResultChange(Sender: TObject);
    procedure TCResultChanging(Sender: TObject; var AllowChange: Boolean);
    procedure ToolBarBlobResize(Sender: TObject);
    procedure ToolBarTabsClick(Sender: TObject);
    procedure ToolButtonStyleClick(Sender: TObject);
    procedure TreeViewCollapsed(Sender: TObject; Node: TTreeNode);
    procedure TreeViewCollapsing(Sender: TObject;
      Node: TTreeNode; var AllowCollapse: Boolean);
    procedure TreeViewEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure TreeViewExpanded(Sender: TObject; Node: TTreeNode);
    procedure TreeViewGetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure TreeViewMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TreeViewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  type
    TView = (avObjectBrowser, avDataBrowser, avObjectIDE, avQueryBuilder, avSQLEditor, avDiagram);
    TToolBarData = record
      View: TView;
      Address: string;
      Addresses: TStringList;
      AddressMRU: TMRUList;
      Caption: string;
      CurrentAddress: Integer;
      RefreshAll: Boolean;
      tbPropertiesAction: TBasicAction;
    end;
    TNewLineFormat = (nlWindows, nlUnix, nlMacintosh);
    TTabState = set of (tsLoading, tsActive);
    TWanted = class
    private
      FAction: TAction;
      FAddress: string;
      FClient: TFClient;
      FFNavigatorNodeExpand: string;
      FInitialize: TCClient.TInitialize;
      procedure Clear();
      function GetNothing(): Boolean;
      procedure SetAction(const AAction: TAction);
      procedure SetAddress(const AAddress: string);
      procedure SetFNavigatorNodeExpand(const ANode: string);
      procedure SetInitialize(const AInitialize: TCClient.TInitialize);
    protected
      procedure Synchronize();
    public
      property Action: TAction read FAction write SetAction;
      property Address: string read FAddress write SetAddress;
      property FNavigatorNodeExpand: string read FFNavigatorNodeExpand write SetFNavigatorNodeExpand;
      property Initialize: TCClient.TInitialize read FInitialize write SetInitialize;
      property Nothing: Boolean read GetNothing;
      constructor Create(const AFClient: TFClient);
      procedure Execute();
    end;
  private
    ActiveControlOnDeactivate: TWinControl;
    aDRunExecuteSelStart: Integer;
    CloseButton: TPicture;
    CreateLine: Boolean;
    EditorField: TField;
    FHTML: TWebBrowser;
    FilterMRU: TMRUList;
    FListSortColumn: TFListSortColumn;
    FNavigatorMenuNode: TTreeNode;
    FrameState: TTabState;
    FSQLEditorCompletionTimerCounter: Integer;
    FSQLHistoryMenuNode: TTreeNode;
    FWorkbenchMouseDownPoint: TPoint;
    GIFImage: TGIFImage;
    IgnoreFGridTitleClick, UseNavigatorTimer: Boolean;
    JPEGImage: TJPEGImage;
    LastDataSource: TLastDataSource;
    LastFNavigatorSelected: string;
    LastObjectIDEAddress: string;
    LastSelectedDatabase: string;
    LastSelectedImageIndex: Integer;
    LastSelectedTable: string;
    LastTableView: TView;
    LeftMousePressed: Boolean;
    MouseDownNode: TTreeNode;
    MovingToAddress: Boolean;
    NewLineFormat: TNewLineFormat;
    NMListView: PNMListView;
    OldFListOrderIndex: Integer;
    PanelMouseDownPoint: TPoint;
    Param: string;
    PasteMode: Boolean;
    PNGImage: TPNGImage;
    PResultHeight: Integer;
    SQLEditor: TSQLEditor;
    SynMemoBeforeDrag: TSynMemoBeforeDrag;
    UsedView: TView;
    Wanted: TWanted;
    procedure aBookmarkExecute(Sender: TObject);
    function ViewToParam(const AView: TView): Variant;
    procedure aDAutoCommitExecute(Sender: TObject);
    procedure aDCancelExecute(Sender: TObject);
    procedure aDCommitExecute(Sender: TObject);
    procedure aDCommitRefresh(Sender: TObject);
    procedure AddressChange(Sender: TObject);
    function AddressToNavigatorNode(const Address: string): TTreeNode;
    procedure aDPostObjectExecute(Sender: TObject);
    procedure aDRollbackExecute(Sender: TObject);
    procedure aDRunExecute(Sender: TObject);
    procedure aDRunSelectionExecute(Sender: TObject);
    procedure aECopyExecute(Sender: TObject);
    procedure aEPasteExecute(Sender: TObject);
    procedure aEPasteFromExecute(Sender: TObject);
    procedure aERedoExecute(Sender: TObject);
    procedure aERenameExecute(Sender: TObject);
    procedure aFExportExecute(const Sender: TObject; const ExportType: TExportType);
    procedure aFImportExecute(const ImportType: TImportType);
    procedure aFOpenExecute(Sender: TObject);
    procedure aFPrintExecute(Sender: TObject);
    procedure aFSaveAsExecute(Sender: TObject);
    procedure aFSaveExecute(Sender: TObject);
    procedure AfterConnect(Sender: TObject);
    procedure AfterExecuteSQL(Sender: TObject);
    function ApplicationHelp(Command: Word; Data: THelpEventData; var CallHelp: Boolean): Boolean;
    procedure aViewExecute(Sender: TObject);
    procedure aVRefreshAllExecute(Sender: TObject);
    procedure aVRefreshExecute(Sender: TObject);
    procedure aVSideBarExecute(Sender: TObject);
    procedure aVSQLLogExecute(Sender: TObject);
    procedure BeforeConnect(Sender: TObject);
    procedure BeforeExecuteSQL(Sender: TObject);
    procedure BeginEditLabel(Sender: TObject);
    procedure ClientRefresh(const Event: TCClient.TEvent);
    function ContentWidthIndexFromImageIndex(AImageIndex: Integer): Integer;
    function Dragging(const Sender: TObject): Boolean;
    procedure EndEditLabel(Sender: TObject);
    function FBuilderActiveSelectList(): TacQueryBuilderSelectListControl;
    function FBuilderActiveWorkArea(): TacQueryBuilderWorkArea;
    procedure FBuilderAddTable(Sender: TObject);
    function FBuilderEditorPageControl(): TacPageControl;
    procedure FBuilderEditorPageControlChange(Sender: TObject);
    procedure FBuilderEditorPageControlCheckStyle();
    procedure FBuilderEditorTabSheetEnter(Sender: TObject);
    procedure FGridGotoExecute(Sender: TObject);
    procedure FGridRefresh(Sender: TObject);
    procedure FHexEditorShow(Sender: TObject);
    procedure FHTMLHide(Sender: TObject);
    procedure FHTMLShow(Sender: TObject);
    procedure FieldSetText(Sender: TField; const Text: string);
    procedure FImageShow(Sender: TObject);
    procedure FListEmptyExecute(Sender: TObject);
    procedure FListRefresh(Sender: TObject);
    procedure FNavigatorEmptyExecute(Sender: TObject);
    procedure FNavigatorRefresh(const Event: TCClient.TEvent);
    procedure FormClientEvent(const Event: TCClient.TEvent);
    procedure FormAccountEvent(const ClassType: TClass);
    procedure FRTFShow(Sender: TObject);
    procedure FSQLHistoryRefresh(Sender: TObject);
    procedure FTextShow(Sender: TObject);
    procedure FWorkbenchAddTable(Sender: TObject);
    procedure FWorkbenchChange(Sender: TObject; Control: TWControl);
    procedure FWorkbenchCursorMove(Sender: TObject; X, Y: Integer);
    procedure FWorkbenchDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FWorkbenchDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FWorkbenchEmptyExecute(Sender: TObject);
    procedure FWorkbenchEnter(Sender: TObject);
    procedure FWorkbenchExit(Sender: TObject);
    procedure FWorkbenchMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FWorkbenchPasteExecute(Sender: TObject);
    procedure FWorkbenchPrintExecute(Sender: TObject);
    procedure FWorkbenchValidateControl(Sender: TObject; Control: TWControl);
    function FWorkbenchValidateForeignKeys(Sender: TObject; WTable: TWTable): Boolean;
    function GetView(): TView;
    function GetAddress(): string;
    function GetFocusedCItem(): TCItem;
    function GetFocusedDatabaseName(): string;
    function GetFocusedTableName(): string;
    function GetMenuDatabase(): string;
    function GetResultSet(): TCResultSet;
    function GetSelectedDatabase(): string;
    function GetSelectedImageIndex(): Integer;
    function GetSelectedItem(): string;
    function GetSelectedNavigator(): string;
    function GetSelectedTable(): string;
    function GetSynMemo(): TSynMemo;
    function GetWindow(): TForm_Ext;
    function GetWorkbench(): TWWorkbench;
    procedure gmFilterClearClick(Sender: TObject);
    procedure gmFilterIntoFilterClick(Sender: TObject);
    procedure ImportError(const Sender: TObject; const Error: TTools.TError; const Item: TTools.TItem; var Success: TDataAction);
    procedure MGridHeaderMenuOrderClick(Sender: TObject);
    procedure MGridTitleMenuVisibleClick(Sender: TObject);
    function NavigatorNodeToAddress(const Node: TTreeNode): string;
    procedure OnConvertError(Sender: TObject; Text: string);
    procedure OpenInNewTabExecute(const DatabaseName, TableName: string; const OpenNewWindow: Boolean = False; const Filename: TFileName = '');
    procedure OpenSQLFile(const AFilename: TFileName; const Insert: Boolean = False);
    procedure PasteExecute(const Node: TTreeNode; const Objects: string);
    procedure PContentChange(Sender: TObject);
    procedure PContentRefresh(Sender: TObject);
    procedure PObjectIDERefresh(Sender: TObject);
    function PostObject(Sender: TObject): Boolean;
    procedure PropertiesServerExecute(Sender: TObject);
    procedure PSQLEditorRefresh(Sender: TObject);
    procedure PWorkbenchRefresh(Sender: TObject);
    function RenameCItem(const CItem: TCItem; const NewName: string): Boolean;
    function ResultSetEvent(const Connection: TMySQLConnection; const Data: Boolean): Boolean;
    procedure SaveSQLFile(Sender: TObject);
    procedure SBResultRefresh(const DataSet: TMySQLDataSet);
    procedure SendQuery(Sender: TObject; const SQL: string);
    procedure SetView(const AView: TView);
    procedure SetAddress(const AAddress: string);
    procedure SetDataSource(const ResultSet: TCResultSet = nil; const DataSet: TDataSet = nil);
    procedure SetSelectedDatabase(const ADatabaseName: string);
    procedure SetSelectedItem(const AItem: string);
    procedure SetSelectedTable(const ATableName: string);
    procedure SQLError(DataSet: TDataSet; E: EDatabaseError; var Action: TDataAction);
    procedure SQLHelp();
    procedure StoreFListColumnWidths();
    procedure SynMemoApllyPreferences(const SynMemo: TSynMemo);
    procedure SynMemoPrintExecute(Sender: TObject);
    procedure TableOpen(Sender: TObject);
    procedure TSymMemoGotoExecute(Sender: TObject);
    procedure CMActivateFGrid(var Message: TMessage); message CM_ACTIVATEFGRID;
    procedure CMActivateFText(var Message: TMessage); message CM_ACTIVATEFTEXT;
    procedure CMBeforeReceivingDataSet(var Message: TMessage); message CM_BEFORE_RECEIVING_DATASET;
    procedure CMChangePreferences(var Message: TMessage); message CM_CHANGEPREFERENCES;
    procedure CMCloseTabQuery(var Message: TMessage); message CM_CLOSE_TAB_QUERY;
    procedure CMExecute(var Message: TMessage); message CM_EXECUTE;
    procedure CMFrameActivate(var Message: TMessage); message CM_ACTIVATEFRAME;
    procedure CMFrameDeactivate(var Message: TMessage); message CM_DEACTIVATEFRAME;
    procedure CMPostBuilderQueryChange(var Message: TMessage); message CM_POST_BUILDER_QUERY_CHANGE;
    procedure CMPostMonitor(var Message: TMessage); message CM_POST_MONITOR;
    procedure CMPostPostScroll(var Message: TMessage); message CM_POSTPOSTSCROLL;
    procedure CMPostShow(var Message: TMessage); message CM_POSTSHOW;
    procedure CMRemoveWForeignKey(var Message: TMessage); message CM_REMOVE_WFOREIGENKEY;
    procedure CMSysFontChanged(var Message: TMessage); message CM_SYSFONTCHANGED;
    procedure CMWantedSynchronize(var Message: TWMTimer); message WM_WANTED_SYNCHRONIZE;
    procedure WMNotify(var Message: TWMNotify); message WM_NOTIFY;
    procedure WMParentNotify(var Message: TWMParentNotify); message WM_PARENTNOTIFY;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
    property FocusedCItem: TCItem read GetFocusedCItem;
    property FocusedDatabases: string read GetFocusedDatabaseName;
    property FocusedTables: string read GetFocusedTableName;
    property MenuDatabase: string read GetMenuDatabase;
    property SelectedImageIndex: Integer read GetSelectedImageIndex;
    property SelectedItem: string read GetSelectedItem write SetSelectedItem;
    property SelectedNavigator: string read GetSelectedNavigator;
    property SynMemo: TSynMemo read GetSynMemo;
    property Workbench: TWWorkbench read GetWorkbench;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    property ResultSet: TCResultSet read GetResultSet;
  public
    Client: TCClient;
    StatusBar: TStatusBar;
    ToolBarData: TToolBarData;
    constructor CreateTab(const AOwner: TComponent; const AParent: TWinControl; const AClient: TCClient; const AParam: string; const IconIndex: Integer); overload;
    destructor Destroy(); override;
    procedure AddressChanging(const Sender: TObject; const NewAddress: String; var AllowChange: Boolean);
    function AddressToCaption(const AAddress: string): string;
    procedure aEFindExecute(Sender: TObject);
    procedure aEReplaceExecute(Sender: TObject);
    procedure aETransferExecute(Sender: TObject);
    procedure CrashRescue();
    procedure MetadataProviderAfterConnect(Sender: TObject);
    procedure MoveToAddress(const ADiff: Integer);
    procedure StatusBarRefresh(const Immediately: Boolean = False);
    property View: TView read GetView write SetView;
    property Address: string read GetAddress write SetAddress;
    property SelectedDatabase: string read GetSelectedDatabase write SetSelectedDatabase;
    property SelectedTable: string read GetSelectedTable write SetSelectedTable;
    property Window: TForm_Ext read GetWindow;
  end;

implementation {***************************************************************}

{$R *.dfm}

uses
  MMSystem, Math, DBConsts, Clipbrd, DBCommon, ShellAPI, Variants,
  XMLDoc, Themes, StrUtils, UxTheme, FileCtrl, SysConst, RichEdit,
  ShLwApi,
  SynHighlighterSQL,
  acQBLocalizer, acQBStrings,
  CommCtrl_Ext, StdActns_Ext,
  MySQLConsts, SQLUtils,
  fDField, fDIndex, fDTable, fDVariable, fDDatabase, fDForeignKey,
  fDHost, fDUser, fDQuickFilter, fDGoto, fDSQLHelp, fDTransfer,
  fDSearch, fDServer, fDBookmark, fURI, fDView, fDRoutine,
  fDTrigger, fDStatement, fDEvent, fDSelection, fDColumns, fWForeignKeySelect,
  fDPaste, fDSegment;

const
  nlHost = 0;
  nlDatabase = 1;
  nlTable = 2;

const
  tiNavigator = 1;
  tiStatusBar = 2;
  tiCodeCompletion = 3;

const
  Filters: array[0 .. 12 - 1] of
    record Text: PChar; ValueType: Integer end = (
      (Text: '%s IS NULL'; ValueType: 0),
      (Text: '%s IS NOT NULL'; ValueType: 0),
      (Text: '%s = %s'; ValueType: 1),
      (Text: '%s <> %s'; ValueType: 1),
      (Text: '%s < %s'; ValueType: 1),
      (Text: '%s > %s'; ValueType: 1),
      (Text: '%s LIKE %s'; ValueType: 2),
      (Text: '%s = %s'; ValueType: 3),
      (Text: '%s <> %s'; ValueType: 3),
      (Text: '%s < %s'; ValueType: 3),
      (Text: '%s > %s'; ValueType: 3),
      (Text: '%s LIKE %s'; ValueType: 4)
    );

function IsRTF(const Value: string): Boolean;
var
  S: string;
begin
  S := Value;
  while (Copy(S, 2, 1) = '{') do Delete(S, 2, 1);
  Result := Copy(S, 1, 5) = '{\rtf';
end;

function IsHTML(const Value: string): Boolean;
begin
  Result := Copy(Trim(Value), 1, 2) = '<!';
end;

function FindChildByClassType(const Control: TWinControl; ClassType: TClass): TWinControl;
var
  I: Integer;
begin
  Result := nil;

  if (Assigned(Control)) then
    for I := 0 to Control.ControlCount - 1 do
      if (not Assigned(Result) and (Control.Controls[I] is TWinControl)) then
        if (Control.Controls[I].ClassType = ClassType) then
          Result := TWinControl(Control.Controls[I])
        else
          Result := FindChildByClassType(TWinControl(Control.Controls[I]), ClassType);
end;

function CopyName(const Name: string; const Items: TCItems): string;
var
  I: Integer;
begin
  Result := Name;
  I := 1;
  while (Items.IndexByName(Result) >= 0) do
  begin
    if (I = 1) then
      Result := Preferences.LoadStr(680, Name)
    else
      Result := Preferences.LoadStr(681, Name, IntToStr(I));
    Result := ReplaceStr(Result, ' ', '_');
    Inc(I);
  end;
end;

{ TFClient.TWanted ************************************************************}

procedure TFClient.TWanted.Clear();
begin
  FAction := nil;
  FAddress := '';
  FInitialize := nil;
  FFNavigatorNodeExpand := '';
end;

constructor TFClient.TWanted.Create(const AFClient: TFClient);
begin
  FClient := AFClient;

  Clear();
end;

procedure TFClient.TWanted.Execute();
begin
  if (not FClient.Client.Asynchron) then
    FClient.Perform(WM_WANTED_SYNCHRONIZE, 0, 0)
  else
    PostMessage(FClient.Handle, WM_WANTED_SYNCHRONIZE, 0, 0);
end;

function TFClient.TWanted.GetNothing(): Boolean;
begin
  Result := not Assigned(Action) and (Address = '') and (FFNavigatorNodeExpand = '');
end;

procedure TFClient.TWanted.SetAction(const AAction: TAction);
begin
  if (AAction <> FAction) then
  begin
    Clear();
    FAction := AAction;
  end;
end;

procedure TFClient.TWanted.SetAddress(const AAddress: string);
begin
  if (AAddress <> FAddress) then
  begin
    Clear();
    FAddress := AAddress;
  end;
end;

procedure TFClient.TWanted.SetFNavigatorNodeExpand(const ANode: string);
begin
  Clear();
  FFNavigatorNodeExpand := ANode;
end;

procedure TFClient.TWanted.SetInitialize(const AInitialize: TCClient.TInitialize);
begin
  Clear();
  FInitialize := AInitialize;
end;

procedure TFClient.TWanted.Synchronize();
var
  ExpandingEvent: TTVExpandingEvent;
  TempAction: TAction;
  TempAddress: string;
  TempInitialize: TCClient.TInitialize;
  TempNode: TTreeNode;
begin
  if (Assigned(Action)) then
  begin
    TempAction := Action;
    Clear();
    TempAction.Execute();
  end
  else if (Address <> '') then
  begin
    TempAddress := Address;
    Clear();
    FClient.Address := TempAddress;
  end
  else if (Assigned(Initialize)) then
  begin
    TempInitialize := Initialize;
    Clear();
    TempInitialize();
  end
  else if (Assigned(FClient.AddressToNavigatorNode(FFNavigatorNodeExpand))) then
  begin
    TempNode := FClient.AddressToNavigatorNode(FFNavigatorNodeExpand);
    Clear();
    ExpandingEvent := FClient.FNavigator.OnExpanding;
    FClient.FNavigator.OnExpanding := nil;
    TempNode.Expand(False);
    FClient.FNavigator.OnExpanding := ExpandingEvent;
  end;
end;

{ TFClient ********************************************************************}

procedure TFClient.aBAddExecute(Sender: TObject);
begin
  Wanted.Clear();

  DBookmark.Bookmarks := Client.Account.Desktop.Bookmarks;
  DBookmark.Bookmark := nil;
  DBookmark.NewCaption := AddressToCaption(Address);
  DBookmark.NewURI := Address;
  if (DBookmark.Execute()) then
    FBookmarks.Selected := FBookmarks.Items[FBookmarks.Items.Count - 1];
end;

procedure TFClient.aBDeleteExecute(Sender: TObject);
begin
  Wanted.Clear();

  Client.Account.Desktop.Bookmarks.DeleteBookmark(Client.Account.Desktop.Bookmarks.ByCaption(FBookmarks.Selected.Caption));
end;

procedure TFClient.aBEditExecute(Sender: TObject);
begin
  Wanted.Clear();

  DBookmark.Bookmarks := Client.Account.Desktop.Bookmarks;
  DBookmark.Bookmark := Client.Account.Desktop.Bookmarks.ByCaption(FBookmarks.Selected.Caption);
  DBookmark.Execute();
end;

procedure TFClient.aBookmarkExecute(Sender: TObject);
begin
  Wanted.Clear();

  Address := Client.Account.Desktop.Bookmarks.ByCaption(TMenuItem(Sender).Caption).URI;
end;

function TFClient.ViewToParam(const AView: TView): Variant;
begin
  case (AView) of
    avDataBrowser: Result := 'browser';
    avObjectIDE: Result := 'ide';
    avQueryBuilder: Result := 'builder';
    avSQLEditor: Result := 'editor';
    avDiagram: Result := 'diagram';
    else Result := Null;
  end;
end;

procedure TFClient.aDAutoCommitExecute(Sender: TObject);
begin
  Wanted.Clear();

  Client.AutoCommit := not Client.AutoCommit;

  MainAction('aDAutoCommit').Checked := Client.AutoCommit;

  aDCommitRefresh(Sender);
end;

procedure TFClient.aDCancelExecute(Sender: TObject);
begin
  Wanted.Clear();

  Client.Terminate();

  MainAction('aDCancel').Enabled := Client.InUse();
end;

procedure TFClient.aDCommitExecute(Sender: TObject);
begin
  Wanted.Clear();

  Client.CommitTransaction();

  aDCommitRefresh(Sender);
end;

procedure TFClient.aDCommitRefresh(Sender: TObject);
begin
  MainAction('aDAutoCommit').Enabled := (Client.ServerVersion >= 40002) and (Client.Lib.LibraryType <> ltHTTP);
  MainAction('aDAutoCommit').Checked := Client.AutoCommit;
  MainAction('aDCommit').Enabled := not MainAction('aDAutoCommit').Checked and (Client.ServerVersion >= 40002) and (Client.Lib.LibraryType <> ltHTTP);
  MainAction('aDRollback').Enabled := not MainAction('aDAutoCommit').Checked and (Client.ServerVersion >= 40002) and (Client.Lib.LibraryType <> ltHTTP);
end;

procedure TFClient.aDCreateDatabaseExecute(Sender: TObject);
begin
  Wanted.Clear();

  DDatabase.Client := Client;
  DDatabase.Database := nil;
  DDatabase.Execute();
end;

procedure TFClient.aDCreateEventExecute(Sender: TObject);
begin
  Wanted.Clear();

  if (FocusedCItem is TCDatabase) then
  begin
    DEvent.Database := TCDatabase(FocusedCItem);
    DEvent.Event := nil;
    DEvent.Execute();
  end;
end;

procedure TFClient.aDCreateExecute(Sender: TObject);
begin
  Wanted.Clear();

  if ((Window.ActiveControl = FNavigator) or (Window.ActiveControl = FList)) then
  begin
    if (MainAction('aDCreateDatabase').Enabled) then MainAction('aDCreateDatabase').Execute()
    else if (MainAction('aDCreateDatabase').Enabled) then MainAction('aDCreateDatabase').Execute()
    else if (MainAction('aDCreateTable').Enabled) then MainAction('aDCreateTable').Execute()
    else if (MainAction('aDCreateField').Enabled) then MainAction('aDCreateField').Execute()
    else if (MainAction('aDCreateHost').Enabled) then MainAction('aDCreateHost').Execute()
    else if (MainAction('aDCreateUser').Enabled) then MainAction('aDCreateUser').Execute();
  end
  else if (Window.ActiveControl = FSQLEditor) then
    FSQLEditor.InsertMode := not FSQLEditor.InsertMode
  else if (Window.ActiveControl = FGrid) and (not FGrid.EditorMode) then
    MainAction('aDInsertRecord').Execute()
  else if (Window.ActiveControl = FText) then
    FText.InsertMode := not FText.InsertMode;
end;

procedure TFClient.aDCreateFieldExecute(Sender: TObject);
begin
  Wanted.Clear();

  if (FocusedCItem is TCBaseTable) then
  begin
    DField.Table := TCBaseTable(FocusedCItem);
    DField.Database := DField.Table.Database;
    DField.Field := nil;
    DField.Execute();
  end;
end;

procedure TFClient.aDCreateForeignKeyExecute(Sender: TObject);
begin
  Wanted.Clear();

  if (FocusedCItem is TCBaseTable) then
  begin
    DForeignKey.Table := TCBaseTable(FocusedCItem);
    DForeignKey.Database := DForeignKey.Table.Database;
    DForeignKey.ParentTable := nil;
    DForeignKey.ForeignKey := nil;
    DForeignKey.Execute();
  end;
end;

procedure TFClient.aDCreateHostExecute(Sender: TObject);
begin
  Wanted.Clear();

  DHost.Client := Client;
  DHost.Host := nil;
  DHost.Execute();
end;

procedure TFClient.aDCreateIndexExecute(Sender: TObject);
begin
  Wanted.Clear();

  if (FocusedCItem is TCBaseTable) then
  begin
    DIndex.Table := TCBaseTable(FocusedCItem);
    DIndex.Database := DIndex.Table.Database;
    DIndex.Index := nil;
    DIndex.Execute();
  end;
end;

procedure TFClient.aDCreateRoutineExecute(Sender: TObject);
begin
  Wanted.Clear();

  if (FocusedCItem is TCDatabase) then
  begin
    DRoutine.Database := TCDatabase(FocusedCItem);
    if (Sender = MainAction('aDCreateProcedure')) then
      DRoutine.RoutineType := rtProcedure
    else if (Sender = MainAction('aDCreateFunction')) then
      DRoutine.RoutineType := rtFunction
    else
      DRoutine.RoutineType := rtUnknown;
    DRoutine.Routine := nil;
    DRoutine.Execute();
  end;
end;

procedure TFClient.aDCreateTableExecute(Sender: TObject);
begin
  Wanted.Clear();

  if (FocusedCItem is TCDatabase) then
  begin
    DTable.Database := TCDatabase(FocusedCItem);
    DTable.Table := nil;
    DTable.Execute();
  end;
end;

procedure TFClient.aDCreateTriggerExecute(Sender: TObject);
begin
  Wanted.Clear();

  if (FocusedCItem is TCBaseTable) then
  begin
    DTrigger.Table := TCBaseTable(FocusedCItem);
    DTrigger.Trigger := nil;
    DTrigger.Execute();
  end;
end;

procedure TFClient.aDCreateUserExecute(Sender: TObject);
begin
  Wanted.Clear();

  DUser.Client := Client;
  DUser.User := nil;
  DUser.Execute();
end;

procedure TFClient.aDCreateViewExecute(Sender: TObject);
begin
  Wanted.Clear();

  if (FocusedCItem is TCDatabase) then
  begin
    DView.Database := TCDatabase(FocusedCItem);
    DView.View := nil;
    DView.Execute();
  end;
end;

procedure TFClient.aDDeleteExecute(Sender: TObject);
var
  CItems: TList;
  I: Integer;
  Msg: string;
  Names: array of string;
  NewTable: TCBaseTable;
  Objects: array of TCDBObject;
  Success: Boolean;
  Table: TCBaseTable;
begin
  Wanted.Clear();

  CItems := TList.Create();

  if ((Window.ActiveControl = FList) and (FList.SelCount > 1)) then
  begin
    for I := 0 to FList.Items.Count - 1 do
      if (FList.Items[I].Selected) then
        case (FList.Items[I].ImageIndex) of
          iiDatabase: CItems.Add(Client.DatabaseByName(FList.Items[I].Caption));
          iiBaseTable,
          iiView: CItems.Add(Client.DatabaseByName(SelectedDatabase).TableByName(FList.Items[I].Caption));
          iiProcedure: CItems.Add(Client.DatabaseByName(SelectedDatabase).ProcedureByName(FList.Items[I].Caption));
          iiFunction: CItems.Add(Client.DatabaseByName(SelectedDatabase).FunctionByName(FList.Items[I].Caption));
          iiEvent: CItems.Add(Client.DatabaseByName(SelectedDatabase).EventByName(FList.Items[I].Caption));
          iiTrigger: CItems.Add(Client.DatabaseByName(SelectedDatabase).TriggerByName(FList.Items[I].Caption));
          iiIndex: CItems.Add(Client.DatabaseByName(SelectedDatabase).BaseTableByName(SelectedTable).IndexByCaption(FList.Items[I].Caption));
          iiField: CItems.Add(Client.DatabaseByName(SelectedDatabase).BaseTableByName(SelectedTable).FieldByName(FList.Items[I].Caption));
          iiForeignKey: CItems.Add(Client.DatabaseByName(SelectedDatabase).BaseTableByName(SelectedTable).ForeignKeyByName(FList.Items[I].Caption));
          iiHost: CItems.Add(Client.HostByCaption(FList.Items[I].Caption));
          iiUser: CItems.Add(Client.UserByCaption(FList.Items[I].Caption));
          iiProcess: CItems.Add(Client.ProcessById(SysUtils.StrToInt(FList.Items[I].Caption)));
        end;
  end
  else if ((Window.ActiveControl = Workbench) and (Workbench.SelCount > 1)) then
  begin
    for I := 0 to Workbench.ControlCount - 1 do
      if ((Workbench.Controls[I] is TWTable) and (TWTable(Workbench.Controls[I]).Selected)) then
        CItems.Add(Client.DatabaseByName(SelectedDatabase).BaseTableByName(TWTable(Workbench.Controls[I]).Caption))
      else if ((Workbench.Controls[I] is TWForeignKey) and (TWForeignKey(Workbench.Controls[I]).Selected)) then
        CItems.Add(Client.DatabaseByName(SelectedDatabase).BaseTableByName(TWForeignKey(Workbench.Controls[I]).ChildTable.Caption).ForeignKeyByName(TWForeignKey(Workbench.Controls[I]).Caption));
  end
  else if (Assigned(FocusedCItem)) then
    CItems.Add(FocusedCItem);

  if (CItems.Count > 1) then
    Msg := Preferences.LoadStr(413)
  else if (CItems.Count = 1) then
  begin
    if (TCItem(CItems[0]) is TCDatabase) then Msg := Preferences.LoadStr(146, TCItem(CItems[0]).Name)
    else if (TCItem(CItems[0]) is TCBaseTable) then Msg := Preferences.LoadStr(113, TCItem(CItems[0]).Name)
    else if (TCItem(CItems[0]) is TCView) then Msg := Preferences.LoadStr(748, TCItem(CItems[0]).Name)
    else if (TCItem(CItems[0]) is TCProcedure) then Msg := Preferences.LoadStr(772, TCItem(CItems[0]).Name)
    else if (TCItem(CItems[0]) is TCFunction) then Msg := Preferences.LoadStr(773, TCItem(CItems[0]).Name)
    else if (TCItem(CItems[0]) is TCEvent) then Msg := Preferences.LoadStr(813, TCItem(CItems[0]).Name)
    else if (TCItem(CItems[0]) is TCTrigger) then Msg := Preferences.LoadStr(787, TCItem(CItems[0]).Name)
    else if (TCItem(CItems[0]) is TCIndex) then Msg := Preferences.LoadStr(162, TCItem(CItems[0]).Name)
    else if (TCItem(CItems[0]) is TCField) then Msg := Preferences.LoadStr(100, TCItem(CItems[0]).Name)
    else if (TCItem(CItems[0]) is TCForeignKey) then Msg := Preferences.LoadStr(692, TCItem(CItems[0]).Name)
    else if (TCItem(CItems[0]) is TCHost) then Msg := Preferences.LoadStr(429, TCItem(CItems[0]).Name)
    else if (TCItem(CItems[0]) is TCUser) then Msg := Preferences.LoadStr(428, TCItem(CItems[0]).Name)
    else if (TCItem(CItems[0]) is TCProcess) then Msg := Preferences.LoadStr(534, TCItem(CItems[0]).Name);
  end
  else
    Msg := '';

  if ((Msg <> '') and (MsgBox(Msg, Preferences.LoadStr(101), MB_YESNOCANCEL + MB_ICONQUESTION) = IDYES)) then
  begin
    Success := True;

    SetLength(Names, 0);
    for I := 0 to CItems.Count - 1 do
      if (TCItem(CItems[I]) is TCDatabase) then
      begin
        SetLength(Names, Length(Names) + 1);
        Names[Length(Names) - 1] := TCDatabase(CItems[I]).Name;
        CItems[I] := nil;
      end;
    if (Success and (Length(Names) > 0)) then
      Success := Client.DeleteDatabases(Names);

    SetLength(Objects, 0);
    for I := 0 to CItems.Count - 1 do
      if (TCItem(CItems[I]) is TCDBObject) then
      begin
        SetLength(Objects, Length(Objects) + 1);
        Objects[Length(Objects) - 1] := TCDBObject(CItems[I]);
        CItems[I] := nil;
      end;
    if (Success and (Length(Objects) > 0)) then
      Success := Objects[0].Database.DeleteObjects(Objects);
    SetLength(Objects, 0);

    Table := nil;
    for I := 0 to CItems.Count - 1 do
      if (TCItem(CItems[I]) is TCIndex) then
        Table := TCIndex(CItems[I]).Table
      else if (TCItem(CItems[I]) is TCBaseTableField) then
        Table := TCBaseTableField(CItems[I]).Table
      else if (TCItem(CItems[I]) is TCForeignKey) then
        Table := TCForeignKey(CItems[I]).Table;
    if (Success and Assigned(Table)) then
    begin
      NewTable := TCBaseTable.Create(Table.Database);
      NewTable.Assign(Table);

      for I := 0 to CItems.Count - 1 do
        if ((TCItem(CItems[I]) is TCIndex) and (TCIndex(CItems[I]).Table = Table)) then
        begin
          NewTable.Indices.DeleteIndex(NewTable.IndexByCaption(TCIndex(CItems[I]).Name));
          CItems[I] := nil;
        end
        else if ((TCItem(CItems[I]) is TCBaseTableField) and (TCBaseTableField(CItems[I]).Table = Table)) then
        begin
          NewTable.Fields.DeleteField(NewTable.FieldByName(TCBaseTableField(CItems[I]).Name));
          CItems[I] := nil;
        end
        else if ((TCItem(CItems[I]) is TCForeignKey) and (TCForeignKey(CItems[I]).Table = Table)) then
        begin
          NewTable.ForeignKeys.DeleteForeignKey(NewTable.ForeignKeyByName(TCForeignKey(CItems[I]).Name));
          CItems[I] := nil;
        end;

      if (NewTable.Fields.Count = 0) then
        Success := Table.Database.DeleteObjects([NewTable])
      else
        Success := Table.Database.UpdateTable(Table, NewTable);

      NewTable.Free();
    end;

    SetLength(Names, 0);
    for I := 0 to CItems.Count - 1 do
      if (TCItem(CItems[I]) is TCHost) then
      begin
        SetLength(Names, Length(Names) + 1);
        Names[Length(Names) - 1] := TCHost(CItems[I]).Name;
        CItems[I] := nil;
      end;
    if (Success and (Length(Names) > 0)) then
      Success := Client.DeleteHosts(Names);

    SetLength(Names, 0);
    for I := 0 to CItems.Count - 1 do
      if (TCItem(CItems[I]) is TCUser) then
      begin
        SetLength(Names, Length(Names) + 1);
        Names[Length(Names) - 1] := TCUser(CItems[I]).Name;
        CItems[I] := nil;
      end;
    if (Success and (Length(Names) > 0)) then
      Success := Client.DeleteUsers(Names);

    SetLength(Names, 0);
    for I := 0 to CItems.Count - 1 do
      if (TCItem(CItems[I]) is TCProcess) then
      begin
        SetLength(Names, Length(Names) + 1);
        Names[Length(Names) - 1] := TCProcess(CItems[I]).Name;
        CItems[I] := nil;
      end;
    if (Success and (Length(Names) > 0)) then
      Client.DeleteProcesses(Names);

    SetLength(Names, 0);
  end;

  CItems.Free();
end;

procedure TFClient.aDDeleteHostExecute(Sender: TObject);
begin
  Wanted.Clear();

;
end;

procedure TFClient.aDDeleteRecordExecute(Sender: TObject);
var
  Bookmarks: array of TBookmark;
  I: Integer;
begin
  Wanted.Clear();

  if (MsgBox(Preferences.LoadStr(176), Preferences.LoadStr(101), MB_YESNOCANCEL + MB_ICONQUESTION) = ID_YES) then
  begin
    if (FGrid.SelectedRows.Count = 0) then
      aDDeleteRecord.Execute()
    else if (FGrid.DataSource.DataSet is TMySQLDataSet) then
    begin
      SetLength(Bookmarks, FGrid.SelectedRows.Count);
      for I := 0 to Length(Bookmarks) - 1 do
        Bookmarks[I] := FGrid.SelectedRows.Items[I];
      FGrid.SelectedRows.Clear();
      TMySQLDataSet(FGrid.DataSource.DataSet).Delete(Bookmarks);
      SetLength(Bookmarks, 0);
    end;
  end;
end;

procedure TFClient.aDDeleteUserExecute(Sender: TObject);
begin
  Wanted.Clear();

;
end;

procedure TFClient.AddressChange(Sender: TObject);
var
  Control: TWinControl;
  Database: TCDatabase;
  DDLStmt: TSQLDDLStmt;
  Empty: Boolean;
  I: Integer;
  NewActiveControl: TWinControl;
  OldControl: TWinControl;
  Parse: TSQLParse;
  Sibling: TTreeNode;
  SQL: string;
  Table: TCTable;
begin
  if (not (csDestroying in ComponentState)) then
  begin
    LeftMousePressed := False;

    OldControl := Window.ActiveControl;

    PContentChange(Sender);
    PContentRefresh(Sender);

    while (Assigned(OldControl) and OldControl.Visible and OldControl.Enabled and Assigned(OldControl.Parent)) do
      OldControl := OldControl.Parent;

    case (View) of
      avObjectBrowser: NewActiveControl := FList;
      avDataBrowser: NewActiveControl := FGrid;
      avObjectIDE: NewActiveControl := SynMemo;
      avQueryBuilder: NewActiveControl := FBuilderActiveWorkArea();
      avSQLEditor: NewActiveControl := FSQLEditor;
      avDiagram: NewActiveControl := Workbench;
      else NewActiveControl := nil;
    end;

    Control := NewActiveControl;
    while (Assigned(Control) and Control.Visible and Control.Enabled and Assigned(Control.Parent)) do
      Control := Control.Parent;

    if (not Assigned(OldControl) or not OldControl.Visible or not OldControl.Enabled and (Assigned(Control) and Control.Visible and Control.Enabled)) then
      Window.ActiveControl := NewActiveControl;


    Empty := not Assigned(SynMemo) or (SynMemo.Lines.Count <= 1) and (SynMemo.Text = ''); // Takes a lot of time
    if (not Empty and (View = avObjectIDE)) then SQL := SynMemo.Text else SQL := '';

    MainAction('aFOpen').Enabled := View = avSQLEditor;
    MainAction('aFSave').Enabled := (View = avSQLEditor) and not Empty and ((SQLEditor.Filename = '') or SynMemo.Modified);
    MainAction('aFSaveAs').Enabled := (View = avSQLEditor) and not Empty;
    MainAction('aVObjectBrowser').Enabled := True;
    MainAction('aVDataBrowser').Enabled := (SelectedImageIndex in [iiBaseTable, iiSystemView, iiView, iiTrigger]) or ((LastSelectedDatabase <> '') and (LastSelectedDatabase = SelectedDatabase) and (LastSelectedTable <> ''));
    MainAction('aVObjectIDE').Enabled := (SelectedImageIndex in [iiView, iiProcedure, iiFunction, iiEvent, iiTrigger]) or (LastObjectIDEAddress <> '');
    MainAction('aVQueryBuilder').Enabled := (SelectedDatabase <> '');
    MainAction('aVSQLEditor').Enabled := True;
    MainAction('aVDiagram').Enabled := (SelectedDatabase <> '') or (LastSelectedDatabase <> '');
    MainAction('aDRun').Enabled :=
      ((View = avSQLEditor)
      or ((View  = avQueryBuilder) and FBuilder.Visible)
      or ((View = avObjectIDE) and SQLSingleStmt(SQL) and (SelectedImageIndex in [iiView, iiProcedure, iiFunction, iiEvent]))) and not Empty;
    MainAction('aDRunSelection').Enabled := (((SynMemo = FSQLEditor) and not Empty) or Assigned(SynMemo) and (SynMemo.SelText <> '')) and True;
    MainAction('aDPostObject').Enabled := (View = avObjectIDE) and Assigned(SynMemo) and SynMemo.Modified and SQLSingleStmt(SQL)
      and ((SelectedImageIndex in [iiView]) and SQLCreateParse(Parse, PChar(SQL), Length(SQL),Client.ServerVersion) and (SQLParseKeyword(Parse, 'SELECT'))
        or (SelectedImageIndex in [iiProcedure, iiFunction]) and SQLParseDDLStmt(DDLStmt, PChar(SQL), Length(SQL), Client.ServerVersion) and (DDLStmt.DefinitionType = dtCreate) and (DDLStmt.ObjectType in [otProcedure, otFunction])
        or (SelectedImageIndex in [iiEvent, iiTrigger]));

    StatusBarRefresh();

    UsedView := View;
    case (View) of
      avDataBrowser: if (not (ttDataBrowser in Preferences.ToolbarTabs)) then begin Include(Preferences.ToolbarTabs, ttDataBrowser); PostMessage(Window.Handle, CM_CHANGEPREFERENCES, 0, 0); end;
      avObjectIDE: if (not (ttObjectIDE in Preferences.ToolbarTabs)) then begin Include(Preferences.ToolbarTabs, ttObjectIDE); PostMessage(Window.Handle, CM_CHANGEPREFERENCES, 0, 0); end;
      avQueryBuilder: if (not (ttQueryBuilder in Preferences.ToolbarTabs)) then begin Include(Preferences.ToolbarTabs, ttQueryBuilder); PostMessage(Window.Handle, CM_CHANGEPREFERENCES, 0, 0); end;
      avSQLEditor: if (not (ttSQLEditor in Preferences.ToolbarTabs)) then begin Include(Preferences.ToolbarTabs, ttSQLEditor); PostMessage(Window.Handle, CM_CHANGEPREFERENCES, 0, 0); end;
      avDiagram: if (not (ttDiagram in Preferences.ToolbarTabs)) then begin Include(Preferences.ToolbarTabs, ttDiagram); PostMessage(Window.Handle, CM_CHANGEPREFERENCES, 0, 0); end;
    end;

    ToolBarData.Caption := Client.Account.Name + ' - ' + AddressToCaption(Address);

    ToolBarData.View := View;

    if (Address <> ToolBarData.Address) then
    begin
      ToolBarData.Address := Address;

      if (not MovingToAddress) then
      begin
        while (ToolBarData.Addresses.Count > ToolBarData.CurrentAddress + 1) do
          ToolBarData.Addresses.Delete(ToolBarData.CurrentAddress + 1);
        ToolBarData.Addresses.Add(Address);

        while (ToolBarData.Addresses.Count > 100) do
          ToolBarData.Addresses.Delete(0);

        ToolBarData.CurrentAddress := ToolBarData.Addresses.Count - 1;
      end;

      Window.Perform(CM_UPDATETOOLBAR, 0, LPARAM(Self));
    end;

    if (Assigned(FNavigator.Selected) and (FNavigator.Selected <> AddressToNavigatorNode(LastFNavigatorSelected))) then
    begin
      if (FNavigator.AutoExpand and Assigned(FNavigator.Selected)) then
      begin
        if ((FNavigator.Selected.ImageIndex in [iiBaseTable, iiSystemView, iiView]) and not Dragging(FNavigator)) then
          FNavigator.Selected.Expand(False);

        if (Assigned(FNavigator.Selected.Parent)) then
        begin
          Sibling := FNavigator.Selected.Parent.getFirstChild();
          while (Assigned(Sibling)) do
          begin
            if (Sibling <> FNavigator.Selected) then
              Sibling.Collapse(False);
            Sibling := FNavigator.Selected.Parent.getNextChild(Sibling);
          end;
        end;
      end;

      if ((tsActive in FrameState) and (ToolBarData.CurrentAddress > 0) and Wanted.Nothing) then
        PlaySound(PChar(Preferences.SoundFileNavigating), Handle, SND_FILENAME or SND_ASYNC);

      if (SelectedTable <> '') then
      begin
        Database := Client.DatabaseByName(SelectedDatabase);
        Table := Database.TableByName(SelectedTable);

        if (not (Table.DataSet is TMySQLTable) or not Assigned(Table.DataSet) or not Table.DataSet.Active or (TMySQLTable(Table.DataSet).Limit < 1)) then
        begin
          FUDOffset.Position := 0;
          FUDLimit.Position := Table.Desktop.Limit;
          FLimitEnabled.Down := Table.Desktop.Limited;
        end
        else
        begin
          FUDOffset.Position := TMySQLTable(Table.DataSet).Offset;
          FUDLimit.Position := TMySQLTable(Table.DataSet).Limit;
          FLimitEnabled.Down := TMySQLTable(Table.DataSet).Limit > 1;
        end;
        FFilterEnabled.Down := (Table.DataSet is TMySQLTable) and Assigned(Table.DataSet) and Table.DataSet.Active and (Table.DataSet.FilterSQL <> '');
        if (not FFilterEnabled.Down) then
          FFilter.Text := ''
        else
          FFilter.Text := TMySQLTable(Table.DataSet).FilterSQL;
        FilterMRU.Clear();
        for I := 0 to Table.Desktop.FilterCount - 1 do
          FilterMRU.Add(Table.Desktop.Filters[I]);
        FFilterEnabled.Enabled := FFilter.Text <> '';
      end;

      if (Window.ActiveControl = FNavigator) then
        FNavigatorSetMenuItems(FNavigator, FNavigator.Selected);

      FNavigator.AutoExpand := not (FNavigator.Selected.ImageIndex in [iiBaseTable, iiSystemView, iiView]) and not CheckWin32Version(6);

      TreeViewExpanded(FNavigator, FNavigator.Selected);
    end;

    FNavigatorMenuNode := FNavigator.Selected;

    LastFNavigatorSelected := NavigatorNodeToAddress(FNavigator.Selected);
    if (SelectedDatabase <> '') then
      LastSelectedDatabase := SelectedDatabase;
    if (SelectedTable <> '') then
      LastSelectedTable := SelectedTable;
    if (SelectedImageIndex in [iiBaseTable, iiSystemView, iiView]) then
      LastTableView := View;
    if (View = avObjectIDE) then
      LastObjectIDEAddress := Address;
  end;
end;

procedure TFClient.AddressChanging(const Sender: TObject; const NewAddress: String; var AllowChange: Boolean);
var
  NotFound: Boolean;
  Database: TCDatabase;
  DBObject: TCDBObject;
  I: Integer;
  S: string;
  URI: TUURI;
begin
  URI := TUURI.Create(NewAddress); NotFound := False;

  if (URI.Scheme <> 'mysql') then
    AllowChange := False
  else if (lstrcmpi(PChar(URI.Host), PChar(Client.Account.Connection.Host)) <> 0) then
    AllowChange := False
  else if (URI.Port <> Client.Account.Connection.Port) then
    AllowChange := False
  else if ((URI.Username <> '') and (lstrcmpi(PChar(URI.Username), PChar(Client.Account.Connection.User)) <> 0)) then
    AllowChange := False
  else if ((URI.Password <> '') and (URI.Password <> Client.Account.Connection.Password)) then
    AllowChange := False
  else
  begin
    S := URI.Path;
    if (URI.Database <> '') then
      Delete(S, 1, 1 + Length(URI.ParamEncode(URI.Database)));
    if (URI.Table <> '') then
      Delete(S, 1, 1 + Length(URI.ParamEncode(URI.Table)));
    if ((S <> '') and (S <> '/')) then
      AllowChange := False;
  end;

  if (not AllowChange) then
    MessageBeep(MB_ICONERROR)
  else
  begin
    AllowChange := not Client.Initialize();
    if (AllowChange) then
      if ((URI.Database = '') and (URI.Param['view'] = Null) and (URI.Param['system'] = Null)) then
      begin
        for I := 0 to Client.Databases.Count - 1 do
          AllowChange := AllowChange and not Client.Databases[I].Initialize();
      end
      else if (URI.Database <> '') then
      begin
        Database := Client.DatabaseByName(URI.Database);
        if (not Assigned(Database)) then
          NotFound := True
        else
        begin
          AllowChange := not Database.Initialize();
          if (AllowChange) then
            if (URI.Param['view'] = 'editor') then
              AllowChange := not Database.InitializeSources()
            else
            begin
              if (URI.Table <> '') then
                DBObject := Database.TableByName(URI.Table)
              else if ((URI.Param['objecttype'] = 'procedure') and (URI.Param['object'] <> Null)) then
                DBObject := Database.ProcedureByName(URI.Param['object'])
              else if ((URI.Param['objecttype'] = 'function') and (URI.Param['object'] <> Null)) then
                DBObject := Database.FunctionByName(URI.Param['object'])
              else if ((URI.Param['objecttype'] = 'trigger') and (URI.Param['object'] <> Null)) then
                DBObject := Database.EventByName(URI.Param['object'])
              else if ((URI.Param['objecttype'] = 'event') and (URI.Param['object'] <> Null)) then
                DBObject := Database.EventByName(URI.Param['object'])
              else
                DBObject := nil;

              if (Assigned(DBObject)) then
                AllowChange := not DBObject.Initialize()
              else if ((URI.Table = '') and (URI.Param['objecttype'] = Null)) then
                AllowChange := True
              else
                NotFound := True;
            end;
        end;
      end;
    if (NotFound) then
    begin
      AllowChange := False;
      Wanted.Clear();
    end
    else if (not AllowChange and Client.Asynchron) then
      Wanted.Address := NewAddress;
  end;

  URI.Free();

  if (AllowChange and Assigned(FGrid.DataSource.DataSet) and FGrid.DataSource.DataSet.Active) then
    try
      if ((Window.ActiveControl = FText) or (Window.ActiveControl = FRTF) or (Window.ActiveControl = FHexEditor)) then
        Window.ActiveControl := FGrid;
      FGrid.DataSource.DataSet.CheckBrowseMode();
    except
      AllowChange := False;
    end;
end;

function TFClient.AddressToCaption(const AAddress: string): string;
var
  URI: TUURI;
  View: string;
begin
  URI := TUURI.Create(AAddress); if (URI.Scheme <> 'mysql') then FreeAndNil(URI);

  if (not Assigned(URI)) then
    Result := ''
  else
  begin
    Result := URI.Database;
    if (URI.Table <> '') then
      Result := Result + '.' + URI.Table
    else if (URI.Param['object'] <> Null) then
      Result := Result + '.' + URI.Param['object'];

    if ((URI.Database = '') and (URI.Param['system'] = 'hosts')) then View := ReplaceStr(Preferences.LoadStr(335), '&', '')
    else if ((URI.Database = '') and (URI.Param['system'] = 'processes')) then View := ReplaceStr(Preferences.LoadStr(24), '&', '')
    else if ((URI.Database = '') and (URI.Param['system'] = 'stati')) then View := ReplaceStr(Preferences.LoadStr(23), '&', '')
    else if ((URI.Database = '') and (URI.Param['system'] = 'users')) then View := ReplaceStr(Preferences.LoadStr(561), '&', '')
    else if ((URI.Database = '') and (URI.Param['system'] = 'variables')) then View := ReplaceStr(Preferences.LoadStr(22), '&', '')
    else if (URI.Param['view'] = Null) then View := ReplaceStr(Preferences.LoadStr(4), '&', '')
    else if (URI.Param['view'] = 'browser') then View := ReplaceStr(Preferences.LoadStr(5), '&', '')
    else if (URI.Param['view'] = 'builder') then View := ReplaceStr(Preferences.LoadStr(852), '&', '')
    else if (URI.Param['view'] = 'ide') then View := ReplaceStr(Preferences.LoadStr(865), '&', '')
    else if (URI.Param['view'] = 'editor') then View := ReplaceStr(Preferences.LoadStr(6), '&', '')
    else if (URI.Param['view'] = 'diagram') then View := ReplaceStr(Preferences.LoadStr(800), '&', '');

    if (Result = '') then
      Result := View
    else if ((URI.Param['view'] = 'editor') and (SQLEditor.Filename <> '')) then
      Result := Result + '  (' + View + ': ' + SQLEditor.Filename + ')'
    else if (View <> '') then
      Result := Result + '  (' + View + ')';

    URI.Free();
  end;
end;

function TFClient.AddressToNavigatorNode(const Address: string): TTreeNode;
var
  Child: TTreeNode;
  DatabaseNode: TTreeNode;
  ObjectIDENode: TTreeNode;
  S: string;
  ServerNode: TTreeNode;
  SystemNode: TTreeNode;
  TableName: string;
  TableNode: TTreeNode;
  URI: TUURI;
begin
  URI := TUURI.Create(Address);

  Result := FNavigator.Items.getFirstNode();

  if (URI.Scheme <> 'mysql') then
    Result := nil
  else if (lstrcmpi(PChar(URI.Host), PChar(Client.Account.Connection.Host)) <> 0) then
    Result := nil
  else if (URI.Port <> Client.Account.Connection.Port) then
    Result := nil
  else if ((URI.Username <> '') and (lstrcmpi(PChar(URI.Username), PChar(Client.Account.Connection.User)) <> 0)) then
    Result := nil
  else if ((URI.Password <> '') and (URI.Password <> Client.Account.Connection.Password)) then
    Result := nil
  else
  begin
    S := URI.Path;
    if (URI.Database <> '') then
      Delete(S, 1, 1 + Length(URI.ParamEncode(URI.Database)));
    if (URI.Table <> '') then
      Delete(S, 1, 1 + Length(URI.ParamEncode(URI.Table)));
    if ((S <> '') and (S <> '/')) then
      Result := nil;
  end;

  if (Assigned(Result)) then
  begin
    ServerNode := FNavigator.Items.getFirstNode();
    SystemNode := nil;
    DatabaseNode := nil;
    TableNode := nil;
    ObjectIDENode := nil;

    if (Assigned(ServerNode)) then
    begin
      Child := ServerNode.getFirstChild();

      if (URI.Param['system'] <> Null) then
      begin
        while (Assigned(Child) and not Assigned(SystemNode)) do
          if ((URI.Param['system'] = 'hosts') and (Child.ImageIndex = iiHosts)
            or (URI.Param['system'] = 'processes') and (Child.ImageIndex = iiProcesses)
            or (URI.Param['system'] = 'stati') and (Child.ImageIndex = iiStati)
            or (URI.Param['system'] = 'users') and (Child.ImageIndex = iiUsers)
            or (URI.Param['system'] = 'variables') and (Child.ImageIndex = iiVariables)) then
            SystemNode := Child
          else
            Child := Child.getNextSibling();
      end
      else if (URI.Database <> '') then
      begin
        while (Assigned(Child) and not Assigned(DatabaseNode)) do
          if ((Client.TableNameCmp(PChar(URI.Database), PChar(Child.Text)) = 0) and (Child.ImageIndex in [iiDatabase, iiSystemDatabase])) then
            DatabaseNode := Child
          else
            Child := Child.getNextSibling();

        if (Assigned(DatabaseNode)) then
          if ((URI.Table <> '') or (URI.Param['objecttype'] = 'trigger') and (URI.Param['object'] <> Null)) then
          begin
            Child := DatabaseNode.getFirstChild();
            if (URI.Table <> '') then
              TableName := URI.Table
            else
              TableName := Client.DatabaseByName(URI.Database).TriggerByName(URI.Param['object']).TableName;
            while (Assigned(Child) and not Assigned(TableNode)) do
              if ((Client.TableNameCmp(PChar(TableName), PChar(Child.Text)) = 0) and (Child.ImageIndex in [iiBaseTable, iiSystemView, iiView])) then
                TableNode := Child
              else
                Child := Child.getNextSibling();
          end;

        if (URI.Param['view'] = 'ide') then
          if (Assigned(DatabaseNode) and ((URI.Table <> '') or (URI.Param['objecttype'] <> 'trigger') and (URI.Param['object'] <> Null))) then
          begin
            Child := DatabaseNode.getFirstChild();
            while (Assigned(Child) and not Assigned(ObjectIDENode)) do
              if ((Client.TableNameCmp(PChar(URI.Table), PChar(Child.Text)) = 0) and (Child.ImageIndex = iiView)
                  or (Client.TableNameCmp(PChar(string(URI.Param['object'])), PChar(Child.Text)) = 0) and (URI.Param['objecttype'] = 'procedure') and (Child.ImageIndex = iiProcedure)
                  or (Client.TableNameCmp(PChar(string(URI.Param['object'])), PChar(Child.Text)) = 0) and (URI.Param['objecttype'] = 'function') and (Child.ImageIndex = iiFunction)
                  or (Client.TableNameCmp(PChar(string(URI.Param['object'])), PChar(Child.Text)) = 0) and (URI.Param['objecttype'] = 'event') and (Child.ImageIndex = iiEvent)) then
                ObjectIDENode := Child
              else
                Child := Child.getNextSibling();
          end
          else if (Assigned(TableNode) and (URI.Param['objecttype'] = 'trigger') and (URI.Param['object'] <> Null)) then
          begin
            Child := TableNode.getFirstChild();
            while (Assigned(Child) and not Assigned(ObjectIDENode)) do
              if ((Client.TableNameCmp(PChar(string(URI.Param['object'])), PChar(Child.Text)) = 0) and (URI.Param['objecttype'] = 'trigger') and (Child.ImageIndex = iiTrigger)) then
                ObjectIDENode := Child
              else
                Child := TableNode.getNextChild(Child);
          end;
      end;
    end;

    if (Assigned(ObjectIDENode)) then
      Result := ObjectIDENode
    else if (Assigned(TableNode)) then
      Result := TableNode
    else if (Assigned(DatabaseNode)) then
      Result := DatabaseNode
    else if (Assigned(SystemNode)) then
      Result := SystemNode
    else
      Result := ServerNode;
  end;

  URI.Free();
end;

procedure TFClient.aDInsertRecordExecute(Sender: TObject);
begin
  Wanted.Clear();

  aDInsertRecord.Execute();
end;

procedure TFClient.aDNextExecute(Sender: TObject);
begin
  Wanted.Clear();

  FGrid.DataSource.DataSet.MoveBy(FGrid.RowCount - 1);
end;

procedure TFClient.aDPostObjectExecute(Sender: TObject);
begin
  Wanted.Clear();

  PostObject(Sender)
end;

procedure TFClient.aDPrevExecute(Sender: TObject);
begin
  Wanted.Clear();

  FGrid.DataSource.DataSet.MoveBy(- (FGrid.RowCount - 1));
end;

procedure TFClient.aDPropertiesExecute(Sender: TObject);
var
  CItem: TCItem;
  Database: TCDatabase;
  I: Integer;
  Process: TCProcess;
begin
  Wanted.Clear();

  if ((Window.ActiveControl = FList) and (FList.SelCount > 1)) then
  begin
    Database := Client.DatabaseByName(SelectedDatabase);

    for I := 0 to FList.Items.Count - 1 do
      if (FList.Items[I].Selected) then
      begin
        SetLength(DTable.TableNames, Length(DTable.TableNames) + 1);
        DTable.TableNames[Length(DTable.TableNames) - 1] := FList.Items[I].Caption;
      end;

    DTable.Database := Database;
    DTable.Table := nil;
    if (DTable.Execute()) then
      FListRefresh(Sender);
  end
  else if ((Window.ActiveControl = Workbench) and (Workbench.Selected is TWSection)) then
  begin
    DSegment.Section := TWSection(Workbench.Selected);
    DSegment.Execute();
    Workbench.Selected := nil;
  end
  else
  begin
    CItem := FocusedCItem;

    if (CItem is TCDatabase) then
    begin
      DDatabase.Client := Client;
      DDatabase.Database := TCDatabase(CItem);
      DDatabase.Execute();
    end
    else if (CItem is TCBaseTable) then
    begin
      DTable.Database := TCBaseTable(CItem).Database;
      DTable.Table := TCBaseTable(CItem);
      DTable.Execute();
    end
    else if (CItem is TCView) then
    begin
      DView.Database := TCView(CItem).Database;
      DView.View := TCView(CItem);
      DView.Execute();
    end
    else if (CItem is TCProcedure) then
    begin
      DRoutine.Database := TCRoutine(CItem).Database;
      DRoutine.Routine := TCRoutine(CItem);
      DRoutine.Execute();
    end
    else if (CItem is TCFunction) then
    begin
      DRoutine.Database := TCRoutine(CItem).Database;
      DRoutine.Routine := TCRoutine(CItem);
      DRoutine.Execute();
    end
    else if (CItem is TCTrigger) then
    begin
      DTrigger.Table := TCTrigger(CItem).Table;
      DTrigger.Trigger := TCTrigger(CItem);
      DTrigger.Execute();
    end
    else if (CItem is TCEvent) then
    begin
      DEvent.Database := TCEvent(CItem).Database;
      DEvent.Event := TCEvent(CItem);
      DEvent.Execute();
    end
    else if (CItem is TCIndex) then
    begin
      DIndex.Database := TCIndex(CItem).Table.Database;
      DIndex.Table := TCIndex(CItem).Table;
      DIndex.Index := TCIndex(CItem);
      DIndex.Execute();
    end
    else if (CItem is TCBaseTableField) then
    begin
      DField.Database := TCBaseTableField(CItem).Table.Database;
      DField.Table := TCBaseTable(TCBaseTableField(CItem).Table);
      DField.Field := TCBaseTableField(CItem);
      DField.Execute();
    end
    else if (CItem is TCForeignKey) then
    begin
      DForeignKey.Database := TCForeignKey(CItem).Table.Database;
      DForeignKey.Table := TCForeignKey(CItem).Table;
      DForeignKey.ParentTable := nil;
      DForeignKey.ForeignKey := TCForeignKey(CItem);
      DForeignKey.Execute();
    end
    else if (CItem is TCHost) then
    begin
      DHost.Client := Client;
      DHost.Host := TCHost(CItem);
      DHost.Execute();
    end
    else if (CItem is TCProcess) then
    begin
      Process := Client.ProcessById(SysUtils.StrToInt(FList.Selected.Caption));

      DStatement.DatabaseName := Process.DatabaseName;
      DStatement.DateTime := Client.DateTime - Process.Time;
      DStatement.Host := Process.Host;
      DStatement.Id := Process.Id;
      DStatement.StatementTime := Process.Time;
      if (UpperCase(Process.Command) <> 'QUERY') then
        DStatement.SQL := ''
      else
        DStatement.SQL := Process.SQL + ';';
      DStatement.UserName := Process.UserName;
      DStatement.ViewType := vtProcess;

      DStatement.Execute();
    end
    else if (CItem is TCUser) then
    begin
      DUser.Client := Client;
      DUser.User := TCUser(CItem);
      DUser.Execute();
    end
    else if (CItem is TCVariable) then
    begin
      DVariable.Client := Client;
      DVariable.Variable := TCVariable(CItem);
      DVariable.Execute();
    end;
  end;
end;

procedure TFClient.aDRollbackExecute(Sender: TObject);
begin
  Wanted.Clear();

  Client.RollbackTransaction();

  aDCommitRefresh(Sender);
end;

procedure TFClient.aDRunExecute(Sender: TObject);
var
  SQL: string;
begin
  Wanted.Clear();

  if (Window.ActiveControl is TMySQLDBGrid) then
    TMySQLDBGrid(Window.ActiveControl).EditorMode := False;

  FSQLEditorCompletion.CancelCompletion();
  if (Assigned(FBuilderActiveSelectList())) then
    FBuilderActiveSelectList().EditorMode := False;

  SQL := '';
  if (View in [avQueryBuilder, avSQLEditor]) then
    SQL := Trim(SynMemo.Text)
  else if ((View = avObjectIDE) and (SelectedImageIndex = iiView)) then
  begin
    if (not SynMemo.Modified or PostObject(Sender)) then
      View := avDataBrowser;
  end
  else if ((View = avObjectIDE) and (SelectedImageIndex = iiProcedure)) then
  begin
    if (Assigned(FObjectIDEGrid.DataSource.DataSet)) then
      FObjectIDEGrid.DataSource.DataSet.CheckBrowseMode();
    if (not SynMemo.Modified or PostObject(Sender)) then
      SQL := Client.DatabaseByName(SelectedDatabase).ProcedureByName(SelectedNavigator).SQLRun();
  end
  else if ((View = avObjectIDE) and (SelectedImageIndex = iiFunction)) then
  begin
    if (Assigned(FObjectIDEGrid.DataSource.DataSet)) then
      FObjectIDEGrid.DataSource.DataSet.CheckBrowseMode();
    if (not SynMemo.Modified or PostObject(Sender)) then
      SQL := Client.DatabaseByName(SelectedDatabase).FunctionByName(SelectedNavigator).SQLRun();
  end
  else if ((View = avObjectIDE) and (SelectedImageIndex = iiEvent)) then
  begin
    if (not SynMemo.Modified or PostObject(Sender)) then
      SQL := Client.DatabaseByName(SelectedDatabase).EventByName(SelectedNavigator).SQLRun();
  end;

  if (SQL = 'debug-raise') then
    raise Exception.Create('Debug Exception')
  else if (SQL <> '') then
  begin
    if ((SelectedDatabase <> Client.DatabaseName) and (SelectedDatabase <> '')) then
      Client.ExecuteSQL(Client.SQLUse(SelectedDatabase));

    aDRunExecuteSelStart := 0;
    SendQuery(Sender, SQL);
  end;
end;

procedure TFClient.aDRunSelectionExecute(Sender: TObject);
var
  Index: Integer;
  Len: Integer;
  SQL: string;
  Success: Boolean;
begin
  Wanted.Clear();

  FSQLEditorCompletion.CancelCompletion();

  aDRunExecuteSelStart := SynMemo.SelStart;
  if (SynMemo.SelText = '') then
  begin
    SQL := SynMemo.Text;
    Index := 1; Len := 0;
    while (Index <= aDRunExecuteSelStart + 1) do
    begin
      Len := SQLStmtLength(SQL, Index);
      Inc(Index, Len);
    end;
    Dec(Index, Len);
    SQL := Copy(SQL, Index, Len);
    aDRunExecuteSelStart := Index - 1;
  end
  else
    SQL := SynMemo.SelText;

  if (SQL <> '') then
  begin
    if ((SelectedDatabase <> Client.DatabaseName) and (SelectedDatabase <> '')) then
      Success := Client.ExecuteSQL(Client.SQLUse(SelectedDatabase))
    else
      Success := True;

    if (Success) then
      SendQuery(Sender, SQL);
  end;
end;

procedure TFClient.aEClearAllExecute(Sender: TObject);
begin
  Wanted.Clear();

  if (Window.ActiveControl = FText) then
    FText.Text := ''
  else if (Window.ActiveControl = FSQLEditor) then
  begin
    // ClearAll kann nicht mit Undo R�ckg�ngig gemacht werden.
    FSQLEditor.BeginUpdate();
    FSQLEditor.SelectAll();
    MainAction('aEDelete').Execute();
    FSQLEditor.EndUpdate();
  end;
end;

procedure TFClient.aECopyExecute(Sender: TObject);
var
  ClipboardData: HGLOBAL;
  Data: string;
  I: Integer;
  ImageIndex: Integer;
  S: string;
  StringList: TStringList;
begin
  Data := '';

  if (Window.ActiveControl = FNavigator) then
  begin
    if (not Assigned(FNavigatorMenuNode.Parent)) then
      ImageIndex := -1
    else
    begin
      ImageIndex := FNavigatorMenuNode.Parent.ImageIndex;
      case (FNavigatorMenuNode.ImageIndex) of
        iiDatabase,
        iiSystemView: Data := Data + 'Database='    + FNavigatorMenuNode.Text + #13#10;
        iiBaseTable:  Data := Data + 'Table='       + FNavigatorMenuNode.Text + #13#10;
        iiView:       Data := Data + 'View='        + FNavigatorMenuNode.Text + #13#10;
        iiProcedure:  Data := Data + 'Procedure='   + FNavigatorMenuNode.Text + #13#10;
        iiFunction:   Data := Data + 'Function='    + FNavigatorMenuNode.Text + #13#10;
        iiEvent:      Data := Data + 'Event='       + FNavigatorMenuNode.Text + #13#10;
        iiIndex:      Data := Data + 'Index='       + FNavigatorMenuNode.Text + #13#10;
        iiSystemViewField,
        iiField,
        iiViewField:  Data := Data + 'Field='       + FNavigatorMenuNode.Text + #13#10;
        iiForeignKey: Data := Data + 'ForeignKey='  + FNavigatorMenuNode.Text + #13#10;
        iiTrigger:    Data := Data + 'Trigger='     + FNavigatorMenuNode.Text + #13#10;
        iiHost:       Data := Data + 'Host='        + FNavigatorMenuNode.Text + #13#10;
        iiUser:       Data := Data + 'User='        + FNavigatorMenuNode.Text + #13#10;
      end;
      if (Data <> '') then
        Data := 'Address=' + NavigatorNodeToAddress(FNavigatorMenuNode.Parent) + #13#10 + Data;
    end;
  end
  else if (Window.ActiveControl = FList) then
  begin
    ImageIndex := SelectedImageIndex;
    for I := 0 to FList.Items.Count - 1 do
      if (FList.Items[I].Selected) then
        case (FList.Items[I].ImageIndex) of
          iiDatabase,
          iiSystemView: Data := Data + 'Database='   + FList.Items[I].Caption + #13#10;
          iiBaseTable:  Data := Data + 'Table='      + FList.Items[I].Caption + #13#10;
          iiView:       Data := Data + 'View='       + FList.Items[I].Caption + #13#10;
          iiProcedure:  Data := Data + 'Procedure='  + FList.Items[I].Caption + #13#10;
          iiFunction:   Data := Data + 'Function='   + FList.Items[I].Caption + #13#10;
          iiEvent:      Data := Data + 'Event='      + FList.Items[I].Caption + #13#10;
          iiIndex:      Data := Data + 'Index='      + Client.DatabaseByName(SelectedDatabase).BaseTableByName(SelectedTable).IndexByCaption(FList.Items[I].Caption).Name + #13#10;
          iiField,
          iiViewField:  Data := Data + 'Field='      + FList.Items[I].Caption + #13#10;
          iiForeignKey: Data := Data + 'ForeignKey=' + FList.Items[I].Caption + #13#10;
          iiTrigger:    Data := Data + 'Trigger='    + FList.Items[I].Caption + #13#10;
          iiHost:       Data := Data + 'Host='       + Client.HostByCaption(FList.Items[I].Caption).Name + #13#10;
          iiUser:       Data := Data + 'User='       + FList.Items[I].Caption + #13#10;
        end;
    if (Data <> '') then
      Data := 'Address=' + NavigatorNodeToAddress(FNavigator.Selected) + #13#10 + Data;
  end
  else if (Window.ActiveControl = Workbench) then
  begin
    ImageIndex := SelectedImageIndex;
    if (Assigned(Workbench)) then
    begin
      Data := 'Address=' + NavigatorNodeToAddress(FNavigator.Selected);
      if (not Assigned(Workbench.Selected)) then
        Data := Data + 'Database='   + Workbench.Selected.Name + #13#10
      else if (Workbench.Selected is TWTable) then
        Data := Data + 'Table='      + Workbench.Selected.Name + #13#10
      else if (Workbench.Selected is TWForeignKey) then
        Data := Data + 'ForeignKey=' + Workbench.Selected.Name + #13#10;
      if (Data <> '') then
        Data := 'Address=' + NavigatorNodeToAddress(FNavigator.Selected) + #13#10 + Data;
    end;
  end
  else if (Window.ActiveControl = FGrid) then
  begin
    FGrid.CopyToClipboard();
    Exit;
  end
  else if (Window.ActiveControl = FSQLHistory) then
  begin
    if (Assigned(FSQLHistory.Selected) and OpenClipboard(Handle)) then
    begin
      EmptyClipboard();

      S := XMLNode(IXMLNode(FSQLHistoryMenuNode.Data), 'sql').Text;
      ClipboardData := GlobalAlloc(GMEM_MOVEABLE + GMEM_DDESHARE, SizeOf(S[1]) * (Length(S) + 1));
      StrPCopy(GlobalLock(ClipboardData), S);
      SetClipboardData(CF_UNICODETEXT, ClipboardData);
      GlobalUnlock(ClipboardData);

      CloseClipboard();
    end;
    Exit;
  end
  else if (Window.ActiveControl = FHexEditor) then
  begin
    FHexEditor.ExecuteAction(MainAction('aECopy'));
    Exit;
  end
  else
  begin
    if (Assigned(Window.ActiveControl)) then
      SendMessage(Window.ActiveControl.Handle, WM_COPY, 0, 0);
    Exit;
  end;

  if ((Data <> '') and OpenClipboard(Handle)) then
  begin
    EmptyClipboard();

    ClipboardData := GlobalAlloc(GMEM_MOVEABLE + GMEM_DDESHARE, SizeOf(Char) * (Length(Data) + 1));
    StrPCopy(GlobalLock(ClipboardData), Data);
    case (ImageIndex) of
      iiServer: SetClipboardData(CF_MYSQLSERVER, ClipboardData);
      iiDatabase,
      iiSystemDatabase: SetClipboardData(CF_MYSQLDATABASE, ClipboardData);
      iiTable,
      iiBaseTable,
      iiSystemView: SetClipboardData(CF_MYSQLTABLE, ClipboardData);
      iiView: SetClipboardData(CF_MYSQLVIEW, ClipboardData);
      iiUsers: SetClipboardData(CF_MYSQLUSERS, ClipboardData);
      iiHosts: SetClipboardData(CF_MYSQLHOSTS, ClipboardData);
    end;
    GlobalUnlock(ClipboardData);

    StringList := TStringList.Create();
    StringList.Text := Trim(Data);
    for I := 1 to StringList.Count - 1 do
      if (StringList.ValueFromIndex[I] <> '') then
      begin
        if (S <> '') then S := S + ',';
        S := S + StringList.ValueFromIndex[I];
      end;
    StringList.Free();

    ClipboardData := GlobalAlloc(GMEM_MOVEABLE + GMEM_DDESHARE, SizeOf(S[1]) * (Length(S) + 1));
    StrPCopy(GlobalLock(ClipboardData), S);
    SetClipboardData(CF_UNICODETEXT, ClipboardData);
    GlobalUnlock(ClipboardData);

    CloseClipboard();
  end;
end;

procedure TFClient.aEFindExecute(Sender: TObject);
var
  I: Integer;
begin
  Wanted.Clear();

  DSearch.Client := Client;
  if ((SelectedTable <> '') and (Window.ActiveControl = FList)) then
  begin
    DSearch.DatabaseName := SelectedDatabase;
    DSearch.TableName := SelectedTable;
    DSearch.FieldName := '';
    for I := 0 to FList.Items.Count - 1 do
      if (FList.Items[I].Selected and (FList.Items[I].ImageIndex in [iiField, iiSystemViewField, iiViewField])) then
      begin
        if (DSearch.FieldName <> '') then
          DSearch.FieldName := DSearch.FieldName + ',';
        DSearch.FieldName := DSearch.FieldName + FList.Items[I].Caption;
      end;
  end
  else
  begin
    DSearch.DatabaseName := FocusedDatabases;
    if (DSearch.DatabaseName = '') then
    begin
      DSearch.TableName := '';
      DSearch.FieldName := '';
    end
    else
    begin
      DSearch.DatabaseName := SelectedDatabase;
      DSearch.TableName := FocusedTables;
      DSearch.FieldName := '';
    end;
  end;
  DSearch.SearchOnly := True;
  DSearch.Frame := Self;
  DSearch.Execute();
end;

procedure TFClient.aEPasteExecute(Sender: TObject);
var
  B: Boolean;
  ClipboardData: HGLOBAL;
  I: Integer;
  Node: TTreeNode;
  S: string;
begin
  if (Client.InUse()) then
    MessageBeep(MB_ICONERROR)
  else if (Window.ActiveControl = FGrid) then
  begin
    if (not Assigned(EditorField)) then
      FGrid.PasteFromClipboard()
    else if (FText.Visible) then
      FText.PasteFromClipboard()
    else if (FRTF.Visible) then
      FRTF.PasteFromClipboard();
  end
  else if (Window.ActiveControl = FGrid.InplaceEditor) then
  begin
    FGrid.DataSource.DataSet.Edit();
    FGrid.InplaceEditor.PasteFromClipboard()
  end
  else if ((Window.ActiveControl = FNavigator) or (Window.ActiveControl = FList)) then
  begin
    if (Window.ActiveControl = FNavigator) then
      Node := FNavigatorMenuNode
    else if ((Window.ActiveControl = FList) and Assigned(FList.Selected)) then
    begin
      Node := nil;
      FNavigatorExpanding(Sender, FNavigator.Selected, B);
      for I := 0 to FNavigator.Selected.Count - 1 do
        if ((FNavigator.Selected[I].ImageIndex = FList.Selected.ImageIndex)
          and (FNavigator.Selected[I].Text = FList.Selected.Caption)) then
          Node := FNavigator.Selected[I];
    end
    else
      Node := FNavigator.Selected;

    if (not Assigned(Node)) then
      MessageBeep(MB_ICONERROR)
    else if ((Node.ImageIndex > 0) and OpenClipboard(Handle)) then
    begin
      case (Node.ImageIndex) of
        iiServer: ClipboardData := GetClipboardData(CF_MYSQLSERVER);
        iiDatabase: ClipboardData := GetClipboardData(CF_MYSQLDATABASE);
        iiBaseTable: ClipboardData := GetClipboardData(CF_MYSQLTABLE);
        iiView: ClipboardData := GetClipboardData(CF_MYSQLVIEW);
        iiHosts: ClipboardData := GetClipboardData(CF_MYSQLHOSTS);
        iiUsers: ClipboardData := GetClipboardData(CF_MYSQLUSERS);
        else ClipboardData := 0;
      end;

      if (ClipboardData = 0) then
      begin
        CloseClipboard();
        MessageBeep(MB_ICONERROR);
      end
      else
      begin
        S := Trim(PChar(GlobalLock(ClipboardData)));;
        GlobalUnlock(ClipboardData);
        CloseClipboard();

        PasteExecute(Node, S)
      end;
    end;
  end
  else if (Window.ActiveControl = FSQLEditor) then
    FSQLEditor.PasteFromClipboard()
  else if ((Window.ActiveControl = Workbench) and Assigned(Workbench)) then
    FWorkbenchPasteExecute(Sender)
  else
    MessageBeep(MB_ICONERROR);
end;

procedure TFClient.aEPasteFromExecute(Sender: TObject);
begin
  Wanted.Clear();

  OpenSQLFile('', True);
end;

procedure TFClient.aEPasteFromFileExecute(Sender: TObject);
var
  Encoding: TEncoding;
  Reader: TStreamReader;
begin
  Wanted.Clear();

  OpenDialog.Title := ReplaceStr(Preferences.LoadStr(581), '&', '');
  OpenDialog.InitialDir := Preferences.Path;
  OpenDialog.FileName := '';
  if (FGrid.SelectedField.DataType = ftWideMemo) then
  begin
    OpenDialog.DefaultExt := 'txt';
    OpenDialog.Filter := FilterDescription('txt') + ' (*.txt)|*.txt|' + FilterDescription('*') + ' (*.*)|*.*';
    OpenDialog.Encodings.Text := EncodingCaptions();
    OpenDialog.EncodingIndex := OpenDialog.Encodings.IndexOf(CodePageToEncoding(Client.CodePage));
  end
  else if (FGrid.SelectedField.DataType = ftBlob) then
  begin
    OpenDialog.DefaultExt := '';
    OpenDialog.Filter := FilterDescription('*') + ' (*.*)|*.*';
    OpenDialog.Encodings.Clear();
    OpenDialog.EncodingIndex := -1;
  end;

  if (OpenDialog.Execute()) then
  begin
    Preferences.Path := ExtractFilePath(OpenDialog.FileName);

    FGrid.SelectedField.DataSet.Edit();
    if (FGrid.SelectedField.DataType = ftWideMemo) then
    begin
      case (EncodingToCodePage(OpenDialog.Encodings[OpenDialog.EncodingIndex])) of
        CP_UTF8: Encoding := TUTF8Encoding.Create();
        CP_UNICODE: Encoding := TUnicodeEncoding.Create();
        else Encoding := TMBCSEncoding.Create(EncodingToCodePage(OpenDialog.Encodings[OpenDialog.EncodingIndex]))
      end;
      try
        Reader := TStreamReader.Create(OpenDialog.Filename, Encoding, True);
        try
          TMySQLWideMemoField(FGrid.SelectedField).LoadFromStream(Reader.BaseStream);
        finally
          Reader.Free();
        end;
      except
        on E: EFileStreamError do
          MsgBox(SysErrorMessage(GetLastError), Preferences.LoadStr(45), MB_OK + MB_ICONERROR);
      end;
      Encoding.Free();
    end
    else if (FGrid.SelectedField.DataType = ftBlob) then
      TBlobField(FGrid.SelectedField).LoadFromFile(OpenDialog.FileName);
  end;
end;

procedure TFClient.aERedoExecute(Sender: TObject);
begin
  FSQLEditor.Redo();
  FSQLEditorStatusChange(Sender, [scAll]);
end;

procedure TFClient.aERenameExecute(Sender: TObject);
begin
  if (Window.ActiveControl = FNavigator) then
    FNavigatorMenuNode.EditText()
  else if (Window.ActiveControl = FList) then
    FList.Selected.EditCaption();
end;

procedure TFClient.aEReplaceExecute(Sender: TObject);
var
  I: Integer;
begin
  Wanted.Clear();

  DSearch.Client := Client;
  if ((SelectedTable <> '') and (Window.ActiveControl = FList)) then
  begin
    DSearch.DatabaseName := SelectedDatabase;
    DSearch.TableName := SelectedTable;
    DSearch.FieldName := '';
    for I := 0 to FList.Items.Count - 1 do
      if (FList.Items[I].Selected and (FList.Items[I].ImageIndex in [iiField, iiSystemViewField, iiViewField])) then
      begin
        if (DSearch.FieldName <> '') then
          DSearch.FieldName := DSearch.FieldName + ',';
        DSearch.FieldName := DSearch.FieldName + FList.Items[I].Caption;
      end;
  end
  else
  begin
    DSearch.DatabaseName := FocusedDatabases;
    if (DSearch.DatabaseName = '') then
    begin
      DSearch.TableName := '';
      DSearch.FieldName := '';
    end
    else
    begin
      DSearch.DatabaseName := SelectedDatabase;
      DSearch.TableName := FocusedTables;
      DSearch.FieldName := '';
    end;
  end;
  DSearch.SearchOnly := False;
  DSearch.Frame := Self;
  DSearch.Execute();
end;

procedure TFClient.aETransferExecute(Sender: TObject);
begin
  Wanted.Clear();

  DTransfer.MasterClient := Client;
  DTransfer.MasterDatabaseName := FocusedDatabases;
  if (DTransfer.MasterDatabaseName = '') then
    DTransfer.MasterTableName := ''
  else
  begin
    DTransfer.MasterDatabaseName := SelectedDatabase;
    DTransfer.MasterTableName := FocusedTables;
  end;
  DTransfer.SlaveClient := nil;
  DTransfer.Execute();
end;

procedure TFClient.aFExportAccessExecute(Sender: TObject);
begin
  Wanted.Clear();

  aFExportExecute(Sender, etAccessFile);
end;

procedure TFClient.aFExportBitmapExecute(Sender: TObject);
begin
  Wanted.Clear();

  SaveDialog.Title := ReplaceStr(Preferences.LoadStr(582), '&', '');
  SaveDialog.InitialDir := Preferences.Path;
  SaveDialog.FileName := SelectedDatabase + '.bmp';
  SaveDialog.DefaultExt := 'bmp';
  SaveDialog.Filter := FilterDescription('bmp') + ' (*.bmp)|*.bmp';
  SaveDialog.Encodings.Clear();
  SaveDialog.EncodingIndex := -1;
  if (SaveDialog.Execute()) then
  begin
    Workbench.SaveToBMP(SaveDialog.FileName);

    Preferences.Path := ExtractFilePath(SaveDialog.FileName);
  end;
end;

procedure TFClient.aFExportExcelExecute(Sender: TObject);
begin
  Wanted.Clear();

  aFExportExecute(Sender, etExcelFile);
end;

procedure TFClient.aFExportExecute(const Sender: TObject; const ExportType: TExportType);
var
  CodePage: Cardinal;
  Database: TCDatabase;
  FolderName: string;
  I: Integer;
  Initialized: Boolean;
  J: Integer;
  Table: TCBaseTable;
  TableNames: array of string;
begin
  Database := nil;
  DExport.Client := Client;
  DExport.DBGrid := nil;
  DExport.DBObjects.Clear();
  DExport.ExportType := ExportType;
  DExport.Window := Window;

  if (Window.ActiveControl = FGrid) then
    DExport.DBGrid := FGrid
  else if (Window.ActiveControl = Workbench) then
  begin
    Database := Client.DatabaseByName(SelectedDatabase);
    for I := 0 to Workbench.Tables.Count - 1 do
      if (not Assigned(Workbench.Selected) or Workbench.Tables[I].Selected) then
        DExport.DBObjects.Add(Database.TableByName(Workbench.Tables[I].Caption));
  end
  else if ((Window.ActiveControl = FList) and (FList.SelCount > 0)) then
  begin
    case (SelectedImageIndex) of
      iiServer:
        for I := 0 to FList.Items.Count - 1 do
          if (FList.Items[I].Selected) then
          begin
            Database := Client.DatabaseByName(FList.Items[I].Caption);
            if ((Client.TableNameCmp(Database.Name, 'mysql') <> 0) and not (Database is TCSystemDatabase)) then
            begin
              for J := 0 to Database.Tables.Count - 1 do
                DExport.DBObjects.Add(Database.Tables[J]);
              if (Assigned(Database.Routines)) then
                for J := 0 to Database.Routines.Count - 1 do
                  DExport.DBObjects.Add(Database.Routines[J]);
              if (Assigned(Database.Triggers)) then
                for J := 0 to Database.Triggers.Count - 1 do
                  DExport.DBObjects.Add(Database.Triggers[J]);
            end;
          end;

      iiDatabase:
        begin
          Database := Client.DatabaseByName(SelectedDatabase);
          if ((Client.TableNameCmp(Database.Name, 'mysql') <> 0) and not (Database is TCSystemDatabase)) then
          begin
            SetLength(TableNames, 0);
            for I := 0 to FList.Items.Count - 1 do
              if (FList.Items[I].Selected and (FList.Items[I].ImageIndex in [iiBaseTable, iiView])) then
              begin
                SetLength(TableNames, Length(TableNames) + 1);
                TableNames[Length(TableNames) - 1] := FList.Items[I].Caption;
              end;

            if ((Sender is TAction) and Database.Initialize()) then
              Wanted.Action := TAction(Sender)
            else
              for I := 0 to FList.Items.Count - 1 do
                if (FList.Items[I].Selected) then
                  if (FList.Items[I].ImageIndex in [iiBaseTable, iiView]) then
                  begin
                    DExport.DBObjects.Add(Database.TableByName(FList.Items[I].Caption));

                    if (Assigned(Database.Triggers)) then
                      for J := 0 to Database.Triggers.Count - 1 do
                        DExport.DBObjects.Add(Database.Triggers[J]);
                  end
                  else if (FList.Items[I].ImageIndex = iiProcedure) then
                    DExport.DBObjects.Add(Database.ProcedureByName(FList.Items[I].Caption))
                  else if (FList.Items[I].ImageIndex = iiFunction) then
                    DExport.DBObjects.Add(Database.FunctionByName(FList.Items[I].Caption))
                  else if (FList.Items[I].ImageIndex = iiEvent) then
                    DExport.DBObjects.Add(Database.EventByName(FList.Items[I].Caption))
                  else if (FList.Items[I].ImageIndex = iiTrigger) then
                    DExport.DBObjects.Add(Database.TriggerByName(FList.Items[I].Caption));

            SetLength(TableNames, 0);
          end;
        end;
      iiBaseTable:
        begin
          Database := Client.DatabaseByName(SelectedDatabase);
          if ((Client.TableNameCmp(Database.Name, 'mysql') <> 0) and not (Database is TCSystemDatabase)) then
            for I := 0 to FList.Items.Count - 1 do
              if (FList.Items[I].Selected and (FList.Items[I].ImageIndex = iiTrigger) and Assigned(Database.TriggerByName(FList.Items[I].Caption))) then
                DExport.DBObjects.Add(Database.TriggerByName(FList.Items[I].Caption));
        end;
    end
  end
  else if (FocusedCItem is TCDatabase) then
  begin
    Database := TCDatabase(FocusedCItem);
    if (not (Database is TCSystemDatabase)) then
    begin
      for J := 0 to Database.Tables.Count - 1 do
        DExport.DBObjects.Add(Database.Tables[J]);
      if (Assigned(Database.Routines)) then
        for J := 0 to Database.Routines.Count - 1 do
          DExport.DBObjects.Add(Database.Routines[J]);
      if (Assigned(Database.Triggers)) then
        for J := 0 to Database.Triggers.Count - 1 do
          DExport.DBObjects.Add(Database.Triggers[J]);
    end;
  end
  else if (FocusedCItem is TCBaseTable) then
  begin
    Table := TCBaseTable(FocusedCItem);
    Database := Table.Database;
    DExport.DBObjects.Add(Table);

    if (Assigned(Database.Triggers)) then
      for J := 0 to Database.Triggers.Count - 1 do
        if (Database.Triggers[J].Table = Table) then
          DExport.DBObjects.Add(Database.Triggers[J]);
  end
  else if (FocusedCItem is TCDBObject) then
  begin
    Database := TCDBObject(FocusedCItem).Database;
    DExport.DBObjects.Add(FocusedCItem);
  end
  else if (Assigned(FocusedCItem)) then
    DExport.DBObjects.Add(FocusedCItem)
  else
  begin
    Initialized := False;
    for I := 0 to DExport.Client.Databases.Count - 1 do
      if ((Client.TableNameCmp(Client.Databases[I].Name, 'mysql') <> 0) and not (Client.Databases[I] is TCSystemDatabase)) then
        Initialized := Initialized or Client.Databases[I].Initialize();

    if (Initialized and (Sender is TAction)) then
      Wanted.Action := TAction(Sender)
    else
      for I := 0 to DExport.Client.Databases.Count - 1 do
        if ((Client.TableNameCmp(Client.Databases[I].Name, 'mysql') <> 0) and not (Client.Databases[I] is TCSystemDatabase)) then
        begin
          for J := 0 to Client.Databases[I].Tables.Count - 1 do
            DExport.DBObjects.Add(Client.Databases[I].Tables[J]);
          if (Assigned(Client.Databases[I].Routines)) then
            for J := 0 to Client.Databases[I].Routines.Count - 1 do
              DExport.DBObjects.Add(Client.Databases[I].Routines[J]);
          if (Assigned(Client.Databases[I].Triggers)) then
            for J := 0 to Client.Databases[I].Triggers.Count - 1 do
              DExport.DBObjects.Add(Client.Databases[I].Triggers[J]);
        end;
  end;

  if (Assigned(DExport.DBGrid) or (DExport.DBObjects.Count >= 1)) then
  begin
    if (Assigned(Client) and (Client.Account.Connection.Charset <> '')) then
      CodePage := Client.CharsetToCodePage(Client.Account.Connection.Charset)
    else if ((DExport.DBObjects.Count = 1) and (TObject(DExport.DBObjects[0]) is TCBaseTable)) then
      CodePage := Client.CharsetToCodePage(TCBaseTable(DExport.DBObjects[0]).DefaultCharset)
    else if (Assigned(Database)) then
      CodePage := Client.CharsetToCodePage(Database.DefaultCharset)
    else
      CodePage := Client.CodePage;

    if (ExportType = etPrint) then
    begin
      DExport.ExportType := etPrint;
      DExport.Execute();
    end
    else if ((ExportType in [etTextFile]) and (DExport.DBObjects.Count > 1)) then
    begin
      FolderName := Preferences.Path;
      if (SelectDirectory(Preferences.LoadStr(351) + ':', '', FolderName, [sdNewFolder, sdShowEdit, sdShowShares, sdNewUI, sdValidateDir], Self)) then
      begin
        DExport.Filename := FolderName + PathDelim;
        DExport.CodePage := CodePage;
        DExport.Execute();
      end;
    end
    else if (ExportType = etODBC) then
    begin
      DExport.Execute();
    end
    else
    begin
      SaveDialog.Title := ReplaceStr(Preferences.LoadStr(582), '&', '');
      SaveDialog.InitialDir := Preferences.Path;
      SaveDialog.Filter := '';
      case (ExportType) of
        etSQLFile:
          begin
            SaveDialog.Filter := FilterDescription('sql') + ' (*.sql)|*.sql';
            SaveDialog.DefaultExt := 'sql';
            SaveDialog.Encodings.Text := EncodingCaptions();
          end;
        etTextFile:
          begin
            SaveDialog.Filter := FilterDescription('txt') + ' (*.txt;*.csv;*.tab;*.asc)|*.txt;*.csv;*.tab;*.asc';
            SaveDialog.DefaultExt := 'csv';
            SaveDialog.Encodings.Text := EncodingCaptions();
          end;
        etExcelFile:
          begin
            SaveDialog.Filter := FilterDescription('xls') + ' (*.xls)|*.xls';
            SaveDialog.DefaultExt := 'xls';
            SaveDialog.Encodings.Clear();
          end;
        etAccessFile:
          begin
            SaveDialog.Filter := FilterDescription('mdb') + ' (*.mdb)|*.mdb';
            SaveDialog.DefaultExt := 'mdb';
            SaveDialog.Encodings.Clear();
          end;
        etSQLiteFile:
          begin
            SaveDialog.Filter := FilterDescription('sqlite') + ' (*.db3;*.sqlite)|*.db3;*.sqlite';
            SaveDialog.DefaultExt := 'db3';
            SaveDialog.Encodings.Clear();
          end;
        etHTMLFile:
          begin
            SaveDialog.Filter := FilterDescription('html') + ' (*.html;*.htm)|*.html;*.htm';
            SaveDialog.DefaultExt := 'html';
            SaveDialog.Encodings.Text := EncodingCaptions(True);
          end;
        etXMLFile:
          begin
            SaveDialog.Filter := FilterDescription('xml') + ' (*.xml)|*.xml';
            SaveDialog.DefaultExt := 'xml';
            SaveDialog.Encodings.Text := EncodingCaptions(True);
          end;
      end;
      SaveDialog.Filter := SaveDialog.Filter + '|' + FilterDescription('*') + ' (*.*)|*.*';

      if (Assigned(DExport.DBGrid)) then
        SaveDialog.FileName := Preferences.LoadStr(362) + '.' + SaveDialog.DefaultExt
      else if (not Assigned(Database)) then
        SaveDialog.FileName := TCDBObject(DExport.DBObjects[0]).Database.Client.Account.Name + '.' + SaveDialog.DefaultExt
      else if (DExport.DBObjects.Count = 1) then
        SaveDialog.FileName := TCDBObject(DExport.DBObjects[0]).Name + '.' + SaveDialog.DefaultExt
      else
        SaveDialog.FileName := Database.Name + '.' + SaveDialog.DefaultExt;

      if (SaveDialog.Encodings.Count = 0) then
        SaveDialog.EncodingIndex := -1
      else
        SaveDialog.EncodingIndex := SaveDialog.Encodings.IndexOf(CodePageToEncoding(CodePage));

      if (SaveDialog.Execute()) then
      begin
        Preferences.Path := ExtractFilePath(SaveDialog.FileName);

        if (SaveDialog.EncodingIndex < 0) then
          DExport.CodePage := CP_ACP
        else
          DExport.CodePage := EncodingToCodePage(SaveDialog.Encodings[SaveDialog.EncodingIndex]);
        DExport.Filename := SaveDialog.FileName;
        DExport.Execute();
      end;
    end;
  end;
end;

procedure TFClient.aFExportHTMLExecute(Sender: TObject);
begin
  Wanted.Clear();

  aFExportExecute(Sender, etHTMLFile);
end;

procedure TFClient.aFExportODBCExecute(Sender: TObject);
begin
  Wanted.Clear();

  aFExportExecute(Sender, etODBC);
end;

procedure TFClient.aFExportSQLExecute(Sender: TObject);
begin
  Wanted.Clear();

  aFExportExecute(Sender, etSQLFile);
end;

procedure TFClient.aFExportSQLiteExecute(Sender: TObject);
begin
  Wanted.Clear();

  aFExportExecute(Sender, etSQLiteFile);
end;

procedure TFClient.aFExportTextExecute(Sender: TObject);
begin
  Wanted.Clear();

  aFExportExecute(Sender, etTextFile);
end;

procedure TFClient.aFExportXMLExecute(Sender: TObject);
begin
  Wanted.Clear();

  aFExportExecute(Sender, etXMLFile);
end;

procedure TFClient.aFImportAccessExecute(Sender: TObject);
begin
  Wanted.Clear();

  aFImportExecute(itAccessFile);
end;

procedure TFClient.aFImportExcelExecute(Sender: TObject);
begin
  Wanted.Clear();

  aFImportExecute(itExcelFile);
end;

procedure TFClient.aFImportExecute(const ImportType: TImportType);
var
  CItem: TCItem;
begin
  CItem := FocusedCItem;

  DImport.Client := Client;
  DImport.Database := nil;
  DImport.Table := nil;
  if (CItem is TCDatabase) then
    DImport.Database := TCDatabase(CItem)
  else if (CItem is TCBaseTable) then
  begin
    DImport.Table := TCBaseTable(CItem);
    DImport.Database := DImport.Table.Database;
  end;

  OpenDialog.Title := ReplaceStr(Preferences.LoadStr(581), '&', '');
  OpenDialog.InitialDir := Preferences.Path;
  OpenDialog.Filter := '';
  case (ImportType) of
    itSQLFile:
      begin
        OpenDialog.Filter := FilterDescription('sql') + ' (*.sql)|*.sql';
        OpenDialog.DefaultExt := 'sql';
        OpenDialog.Encodings.Text := EncodingCaptions();
      end;
    itTextFile:
      begin
        OpenDialog.Filter := FilterDescription('txt') + ' (*.txt;*.csv;*.tab;*.asc)|*.txt;*.csv;*.tab;*.asc';
        OpenDialog.DefaultExt := 'csv';
        OpenDialog.Encodings.Text := EncodingCaptions();
      end;
    itExcelFile:
      begin
        OpenDialog.Filter := FilterDescription('xls') + ' (*.xls)|*.xls';
        OpenDialog.DefaultExt := 'xls';
        OpenDialog.Encodings.Clear();
      end;
    itAccessFile:
      begin
        OpenDialog.Filter := FilterDescription('mdb') + ' (*.mdb)|*.mdb';
        OpenDialog.DefaultExt := 'mdb';
        OpenDialog.Encodings.Clear();
      end;
    itSQLiteFile:
      begin
        OpenDialog.Filter := FilterDescription('sqlite') + ' (*.db3;*.sqlite)|*.db3;*.sqlite';
        OpenDialog.DefaultExt := 'db3';
        OpenDialog.Encodings.Clear();
      end;
    itXMLFile:
      begin
        OpenDialog.Filter := FilterDescription('xml') + ' (*.xml)|*.xml';
        OpenDialog.DefaultExt := 'xml';
        OpenDialog.Encodings.Clear();
      end;
  end;
  OpenDialog.Filter := OpenDialog.Filter + '|' + FilterDescription('*') + ' (*.*)|*.*';

  OpenDialog.FileName := '';
  OpenDialog.EncodingIndex := OpenDialog.Encodings.IndexOf(CodePageToEncoding(CP_ACP));

  if (OpenDialog.Execute()) then
  begin
    Preferences.Path := ExtractFilePath(OpenDialog.FileName);

    DImport.Window := Window;
    DImport.ImportType := ImportType;
    DImport.Filename := OpenDialog.FileName;
    if (OpenDialog.EncodingIndex < 0) then
      DImport.CodePage := CP_ACP
    else
      DImport.CodePage := EncodingToCodePage(OpenDialog.Encodings[OpenDialog.EncodingIndex]);
    if (DImport.Execute()) then
      if (Assigned(DImport.Table)) then
        DImport.Table.Clear()
      else if (Assigned(DImport.Database)) then
        DImport.Database.Clear()
      else
        MainAction('aVRefresh').Execute();
  end;
end;

procedure TFClient.aFImportODBCExecute(Sender: TObject);
begin
  Wanted.Clear();

  DImport.Window := Window;
  DImport.Client := Client;
  if (FocusedCItem is TCDatabase) then
  begin
    DImport.Database := TCDatabase(FocusedCItem);
    DImport.Table := nil;
  end
  else if (FocusedCItem is TCBaseTable) then
  begin
    DImport.Table := TCBaseTable(FocusedCItem);
    DImport.Database := DImport.Table.Database;
  end
  else
  begin
    DImport.Database := nil;
    DImport.Table := nil;
  end;
  DImport.Filename := '';
  DImport.CodePage := CP_ACP;
  DImport.ImportType := itODBC;
  if (DImport.Execute()) then
    if (Assigned(DImport.Table)) then
      DImport.Table.Clear()
    else if (Assigned(DImport.Database)) then
      DImport.Database.Clear()
    else
      MainAction('aVRefresh').Execute();
end;

procedure TFClient.aFImportSQLExecute(Sender: TObject);
begin
  Wanted.Clear();

  aFImportExecute(itSQLFile);
end;

procedure TFClient.aFImportSQLiteExecute(Sender: TObject);
begin
  Wanted.Clear();

  aFImportExecute(itSQLiteFile);
end;

procedure TFClient.aFImportTextExecute(Sender: TObject);
begin
  Wanted.Clear();

  aFImportExecute(itTextFile);
end;

procedure TFClient.aFImportXMLExecute(Sender: TObject);
begin
  Wanted.Clear();

  aFImportExecute(itXMLFile);
end;

procedure TFClient.aFOpenExecute(Sender: TObject);
begin
  Wanted.Clear();

  if (Boolean(Perform(CM_CLOSE_TAB_QUERY, 0, 0))) then
    OpenSQLFile('');
end;

procedure TFClient.aFPrintExecute(Sender: TObject);
begin
  Wanted.Clear();

  if ((Window.ActiveControl = FSQLEditor) or (Window.ActiveControl = FLog)) then
    SynMemoPrintExecute(Sender)
  else if (Window.ActiveControl = Workbench) then
    FWorkbenchPrintExecute(Sender)
  else
    aFExportExecute(Sender, etPrint);
end;

procedure TFClient.aFSaveAsExecute(Sender: TObject);
begin
  Wanted.Clear();

  SaveSQLFile(Sender);
end;

procedure TFClient.aFSaveExecute(Sender: TObject);
begin
  Wanted.Clear();

  SaveSQLFile(Sender);
end;

procedure TFClient.AfterConnect(Sender: TObject);
begin
  MainAction('aDCancel').Enabled := False;

  StatusBar.Panels.Items[sbMessage].Text := Preferences.LoadStr(382);
  SetTimer(Handle, tiStatusBar, 5000, nil);
end;

procedure TFClient.AfterExecuteSQL(Sender: TObject);
var
  Hour: Word;
  Minute: Word;
  MSec: Word;
  Msg: string;
  Second: Word;
begin
  MainAction('aDCancel').Enabled := False;

  aDCommitRefresh(Client);     // Maybe we're still in a database transaction...

  if (Client.RowsAffected < 0) then
    Msg := Preferences.LoadStr(382)
  else
    Msg := Preferences.LoadStr(658, IntToStr(Client.RowsAffected));

  DecodeTime(Client.ExecutionTime, Hour, Minute, Second, MSec);
  if (Hour > 0) or (Minute > 0) then
    Msg := Msg + '  (' + Preferences.LoadStr(520) + ': ' + FormatDateTime(FormatSettings.LongTimeFormat, Client.ExecutionTime) + ')'
  else if (Client.ExecutionTime >= 0) then
    Msg := Msg + '  (' + Preferences.LoadStr(520) + ': ' + Format('%2.2f', [Second + MSec / 1000]) + ')';

  StatusBar.Panels.Items[sbMessage].Text := Msg;
  SetTimer(Handle, tiStatusBar, 5000, nil);

  if (Assigned(Wanted.Action) or (Wanted.Address <> '') or Assigned(Wanted.Initialize)) then
    Wanted.Execute();
end;

procedure TFClient.aHRunClick(Sender: TObject);
var
  SQL: string;
begin
  if (Assigned(FSQLHistoryMenuNode) and (FSQLHistoryMenuNode.ImageIndex in [iiStatement, iiQuery, iiClock])) then
  begin
    Wanted.Clear();

    View := avSQLEditor;
    if (View = avSQLEditor) then
    begin
      SQL := '';

      if ((XMLNode(IXMLNode(FSQLHistoryMenuNode.Data), 'database').Text <> Client.DatabaseName) and (XMLNode(IXMLNode(FSQLHistoryMenuNode.Data), 'database').Text <> '')) then
        SQL := SQL + Client.SQLUse(XMLNode(IXMLNode(FSQLHistoryMenuNode.Data), 'database').Text);

      SQL := SQL + XMLNode(IXMLNode(FSQLHistoryMenuNode.Data), 'sql').Text;

      SendQuery(Sender, SQL);
    end;
  end;
end;

procedure TFClient.aHRunExecute(Sender: TObject);
var
  SQL: string;
begin
  Wanted.Clear();

  if (Assigned(FSQLHistoryMenuNode) and (FSQLHistoryMenuNode.ImageIndex in [iiStatement, iiQuery, iiClock])) then
  begin
    View := avSQLEditor;
    if (View = avSQLEditor) then
    begin
      SQL := '';

      if ((XMLNode(IXMLNode(FSQLHistoryMenuNode.Data), 'database').Text <> Client.DatabaseName) and (XMLNode(IXMLNode(FSQLHistoryMenuNode.Data), 'database').Text <> '')) then
        SQL := SQL + Client.SQLUse(XMLNode(IXMLNode(FSQLHistoryMenuNode.Data), 'database').Text);

      SQL := SQL + XMLNode(IXMLNode(FSQLHistoryMenuNode.Data), 'sql').Text;

      SendQuery(Sender, SQL);
    end;
  end;
end;

procedure TFClient.aPCollapseExecute(Sender: TObject);
begin
  if (Window.ActiveControl = FNavigator) then
    FNavigatorMenuNode.Collapse(False)
  else if (Window.ActiveControl = FSQLHistory) then
    FSQLHistoryMenuNode.Collapse(False);
end;

procedure TFClient.aPExpandExecute(Sender: TObject);
begin
  if (Window.ActiveControl = FNavigator) then
    FNavigatorMenuNode.Expand(False)
  else if (Window.ActiveControl = FSQLHistory) then
    FSQLHistoryMenuNode.Expand(False);
end;

procedure TFClient.aPObjectBrowserTableExecute(Sender: TObject);
begin
  Wanted.Clear();

  if (View <> avObjectBrowser) then
    View := avObjectBrowser;
  SelectedTable := LastSelectedTable; // Navigator auf Table stellen
end;

procedure TFClient.aPOpenInNewTabExecute(Sender: TObject);
begin
  if (FocusedCItem is TCDatabase) then
    OpenInNewTabExecute(TCDatabase(FocusedCItem).Name, '')
  else if (FocusedCItem is TCTable) then
    OpenInNewTabExecute(TCTable(FocusedCItem).Database.Name, TCTable(FocusedCItem).Name)
  else if (Window.ActiveControl = FBookmarks) then
  begin
    if (Assigned(FBookmarks.Selected)) then
      Window.Perform(CM_ADDTAB, 0, LPARAM(PChar(string(Client.Account.Desktop.Bookmarks.ByCaption(FBookmarks.Selected.Caption).URI))));
  end;
end;

procedure TFClient.aPOpenInNewWindowExecute(Sender: TObject);
begin
  if (FocusedCItem is TCDatabase) then
    OpenInNewTabExecute(TCDatabase(FocusedCItem).Name, '', True)
  else if (FocusedCItem is TCTable) then
    OpenInNewTabExecute(TCTable(FocusedCItem).Database.Name, TCTable(FocusedCItem).Name, True)
  else if (Window.ActiveControl = FBookmarks) then
  begin
    if (Assigned(FBookmarks.Selected)) then
      ShellExecute(Application.Handle, 'open', PChar(TFileName(Application.ExeName)), PChar(string(Client.Account.Desktop.Bookmarks.ByCaption(FBookmarks.Selected.Caption).URI)), '', SW_SHOW);
  end;
end;

function TFClient.ApplicationHelp(Command: Word; Data: THelpEventData; var CallHelp: Boolean): Boolean;
begin
  if ((Window.ActiveControl = SynMemo) and (Client.ServerVersion >= 40100)) then
  begin
    CallHelp := False;
    SQLHelp();
  end;

  Result := True;
end;

procedure TFClient.aPResultExecute(Sender: TObject);
begin
  Wanted.Clear();

  if (PResult.Visible and PGrid.Visible) then
    Window.ActiveControl := FGrid;
end;

procedure TFClient.aSSearchFindNotFound(Sender: TObject);
begin
  MsgBox(Preferences.LoadStr(533, TSearchFind(Sender).Dialog.FindText), Preferences.LoadStr(43), MB_OK + MB_ICONINFORMATION);
end;

procedure TFClient.aTBFilterExecute(Sender: TObject);
begin
  if (View = avDataBrowser) then
    Window.ActiveControl := FFilter;
end;

procedure TFClient.aTBLimitExecute(Sender: TObject);
begin
  if (View = avDataBrowser) then
    Window.ActiveControl := FLimit;
end;

procedure TFClient.aTBOffsetExecute(Sender: TObject);
begin
  if (View = avDataBrowser) then
    Window.ActiveControl := FOffset;
end;

procedure TFClient.aTBQuickSearchExecute(Sender: TObject);
begin
  if (View = avDataBrowser) then
    Window.ActiveControl := FQuickSearch;
end;

procedure TFClient.aVBlobExecute(Sender: TObject);
begin
  Wanted.Clear();

  FHTMLHide(Sender);

  FText.Visible := (Sender = aVBlobText) or not Assigned(Sender) and aVBlobText.Checked;
  FRTF.Visible := (Sender = aVBlobRTF) or not Assigned(Sender) and aVBlobRTF.Checked;
  if (Assigned(FHTML)) then
    FHTML.Visible := (Sender = aVBlobHTML) or not Assigned(Sender) and aVBlobHTML.Checked;
  FImage.Visible := (Sender = aVBlobImage) or not Assigned(Sender) and aVBlobImage.Checked;
  FHexEditor.Visible := (Sender = aVBlobHexEditor) or not Assigned(Sender) and aVBlobHexEditor.Checked;
  FBlobSearch.Visible := aVBlobText.Checked;
  ToolBarBlobResize(Sender);

  if (FText.Visible) then
    FTextShow(Sender)
  else if (FRTF.Visible) then
    FRTFShow(Sender)
  else if ((Sender = aVBlobHTML) or not Assigned(Sender) and aVBlobHTML.Checked) then
    FHTMLShow(Sender)
  else if (FImage.Visible) then
    FImageShow(Sender)
  else if (FHexEditor.Visible) then
    FHexEditorShow(Sender);

  if (CheckWin32Version(6)) then
    SendMessage(FBlobSearch.Handle, EM_SETCUEBANNER, 0, LParam(PChar(ReplaceStr(Preferences.LoadStr(424), '&', ''))));
end;

procedure TFClient.aVDetailsExecute(Sender: TObject);
begin
  Wanted.Clear();

  DColumns.DBGrid := FGrid;
  if (DColumns.Execute()) then
  begin
    Window.ActiveControl := nil;
    Window.ActiveControl := FGrid;
  end;
end;

procedure TFClient.aViewExecute(Sender: TObject);
var
  NewView: TView;
  AllowChange: Boolean;
begin
  if (Sender = MainAction('aVObjectBrowser')) then
    NewView := avObjectBrowser
  else if (Sender = MainAction('aVDataBrowser')) then
    NewView := avDataBrowser
  else if (Sender = MainAction('aVObjectIDE')) then
    NewView := avObjectIDE
  else if (Sender = MainAction('aVQueryBuilder')) then
    NewView := avQueryBuilder
  else if (Sender = MainAction('aVSQLEditor')) then
    NewView := avSQLEditor
  else if (Sender = MainAction('aVDiagram')) then
    NewView := avDiagram
  else
    NewView := View;

  AllowChange := True;
  if (AllowChange and Assigned(FGrid.DataSource.DataSet) and FGrid.DataSource.DataSet.Active) then
    try
      if ((Window.ActiveControl = FText) or (Window.ActiveControl = FRTF) or (Window.ActiveControl = FHexEditor)) then
        Window.ActiveControl := FGrid;
      FGrid.DataSource.DataSet.CheckBrowseMode();
    except
      AllowChange := False;
    end;

  tbObjectBrowser.Down := MainAction('aVObjectBrowser').Checked;
  tbDataBrowser.Down := MainAction('aVDataBrowser').Checked;
  tbObjectIDE.Down := MainAction('aVObjectIDE').Checked;
  tbQueryBuilder.Down := MainAction('aVQueryBuilder').Checked;
  tbSQLEditor.Down := MainAction('aVSQLEditor').Checked;
  tbDiagram.Down := MainAction('aVDiagram').Checked;

  if (AllowChange) then
  begin
    View := NewView;

    case (View) of
      avObjectBrowser: if (PList.Visible) then Window.ActiveControl := FList;
      avDataBrowser: if (PResult.Visible and PGrid.Visible) then Window.ActiveControl := FGrid;
      avObjectIDE: if (PSQLEditor.Visible and Assigned(SynMemo)) then Window.ActiveControl := SynMemo;
      avQueryBuilder: if (PBuilder.Visible and Assigned(FBuilderActiveWorkArea())) then Window.ActiveControl := FBuilderActiveWorkArea();
      avSQLEditor: if (PSQLEditor.Visible) then Window.ActiveControl := FSQLEditor;
      avDiagram: if (PWorkbench.Visible) then Window.ActiveControl := Workbench;
    end;
  end;
end;

procedure TFClient.aVRefreshAllExecute(Sender: TObject);
var
  ChangeEvent: TTVChangedEvent;
  ChangingEvent: TTVChangingEvent;
  TempAddress: string;
begin
  KillTimer(Handle, tiStatusBar);
  KillTimer(Handle, tiNavigator);

  SetDataSource();

  Client.Clear();

  TempAddress := Address;

  ChangingEvent := FNavigator.OnChanging; FNavigator.OnChanging := nil;
  ChangeEvent := FNavigator.OnChange; FNavigator.OnChange := nil;
  FNavigator.Selected := nil;
  FNavigator.OnChanging := ChangingEvent;
  FNavigator.OnChange := ChangeEvent;

  Address := TempAddress;
end;

procedure TFClient.aVRefreshExecute(Sender: TObject);
var
  RecNo: Integer;
begin
  if (GetKeyState(VK_SHIFT) < 0) then
    aVRefreshAllExecute(Sender)
  else
  begin
    KillTimer(Handle, tiNavigator);

    case (View) of
      avObjectBrowser,
      avObjectIDE:
        begin
          case (SelectedImageIndex) of
            iiServer: Client.Clear();
            iiDatabase,
            iiSystemDatabase: Client.DatabaseByName(SelectedDatabase).Clear();
            iiBaseTable,
            iiSystemView:
              begin
                Client.DatabaseByName(SelectedDatabase).TableByName(SelectedTable).Clear();
                Client.DatabaseByName(SelectedDatabase).Triggers.Clear();
              end;
            iiView: Client.DatabaseByName(SelectedDatabase).TableByName(SelectedTable).Clear();
            iiProcedure: Client.DatabaseByName(SelectedDatabase).ProcedureByName(SelectedNavigator).Clear();
            iiFunction: Client.DatabaseByName(SelectedDatabase).FunctionByName(SelectedNavigator).Clear();
            iiEvent: Client.DatabaseByName(SelectedDatabase).EventByName(SelectedNavigator).Clear();
            iiTrigger: Client.DatabaseByName(SelectedDatabase).TriggerByName(SelectedNavigator).Clear();
            iiHosts: Client.Hosts.Clear();
            iiProcesses: Client.Processes.Clear();
            iiStati: Client.Stati.Clear();
            iiUsers: Client.Users.Clear();
            iiVariables: Client.Variables.Clear();
          end;

          Address := Address;
        end;
      avDataBrowser,
      avQueryBuilder,
      avSQLEditor:
        if (PResult.Visible and (FGrid.DataSource.DataSet is TMySQLDataSet) and TMySQLDataSet(FGrid.DataSource.DataSet).Active and (TMySQLDataSet(FGrid.DataSource.DataSet).CommandText <> '')) then
        begin
          TCResult.Tabs.Clear();

          FGrid.EditorMode := False;
          FGrid.DataSource.DataSet.CheckBrowseMode();

          TMySQLDataSet(FGrid.DataSource.DataSet).DisableControls();
          RecNo := TMySQLDataSet(FGrid.DataSource.DataSet).RecNo;
          TMySQLDataSet(FGrid.DataSource.DataSet).Refresh();
          if (Assigned(FGrid.DataSource.DataSet)) then
          begin
            TMySQLDataSet(FGrid.DataSource.DataSet).RecNo := RecNo;
            DBGridColEnter(FGrid);
            TMySQLDataSet(FGrid.DataSource.DataSet).EnableControls();
          end;
        end;
    end;
  end;
end;

procedure TFClient.aVSideBarExecute(Sender: TObject);
begin
  PSideBar.DisableAlign();

  MainAction('aVNavigator').Checked := (Sender = MainAction('aVNavigator')) and MainAction('aVNavigator').Checked;
  MainAction('aVBookmarks').Checked := (Sender = MainAction('aVBookmarks')) and MainAction('aVBookmarks').Checked;
  MainAction('aVSQLHistory').Checked := (Sender = MainAction('aVSQLHistory')) and MainAction('aVSQLHistory').Checked;

  PNavigator.Visible := MainAction('aVNavigator').Checked;
  PBookmarks.Visible := MainAction('aVBookmarks').Checked;
  PSQLHistory.Visible := MainAction('aVSQLHistory').Checked;

  SSideBar.Visible := PNavigator.Visible or PBookmarks.Visible or PSQLHistory.Visible;
  if (SSideBar.Visible) then
  begin
    SSideBar.Left := PNavigator.Width;
    SSideBar.Align := alLeft;
    PSideBar.Visible := SSideBar.Visible;
  end
  else
    PSideBar.Visible := False;

  PSideBar.EnableAlign();

  if (MainAction('aVNavigator').Checked) then
    Window.ActiveControl := FNavigator
  else if (MainAction('aVBookmarks').Checked) then
    Window.ActiveControl := FBookmarks
  else if (MainAction('aVSQLHistory').Checked) then
  begin
    FSQLHistoryRefresh(Sender);
    Window.ActiveControl := FSQLHistory;
  end;
end;

procedure TFClient.aVSortAscExecute(Sender: TObject);
var
  SortDef: TIndexDef;
begin
  Wanted.Clear();

  SortDef := TIndexDef.Create(nil, 'SortDef', FGrid.SelectedField.FieldName, []);

  TMySQLDataSet(FGrid.DataSource.DataSet).Sort(SortDef);
  FGrid.UpdateHeader();

  SortDef.Free();
end;

procedure TFClient.aVSortDescExecute(Sender: TObject);
var
  SortDef: TIndexDef;
begin
  Wanted.Clear();

  SortDef := TIndexDef.Create(nil, 'SortDef', FGrid.SelectedField.FieldName, []);
  SortDef.DescFields := FGrid.SelectedField.FieldName;

  TMySQLDataSet(FGrid.DataSource.DataSet).Sort(SortDef);
  FGrid.UpdateHeader();

  SortDef.Free();
end;

procedure TFClient.aVSQLLogExecute(Sender: TObject);
begin
  PLog.Visible := MainAction('aVSQLLog').Checked;
  SLog.Visible := PLog.Visible;

  if (PLog.Visible) then
  begin
    // make sure, SLog is above PLog
    SLog.Align := alNone;
    SLog.Top := 0;
    SLog.Align := alBottom;

    Perform(CM_POST_MONITOR, 0, 0);
  end;

  FormResize(Sender);
end;

procedure TFClient.BeforeConnect(Sender: TObject);
begin
  StatusBar.Panels.Items[sbMessage].Text := Preferences.LoadStr(195) + '...';
  KillTimer(Handle, tiStatusBar);

  MainAction('aDCancel').Enabled := True;
end;

procedure TFClient.BeforeExecuteSQL(Sender: TObject);
begin
  StatusBar.Panels.Items[sbMessage].Text := Preferences.LoadStr(196) + '...';
  KillTimer(Handle, tiStatusBar);

  MainAction('aDCancel').Enabled := True;
end;

procedure TFClient.BeginEditLabel(Sender: TObject);
begin
  KillTimer(Handle, tiNavigator);

  aDCreate.ShortCut := 0;
  aDDelete.ShortCut := 0;
end;

procedure TFClient.BObjectIDEClick(Sender: TObject);
var
  SQL: string;
  Trigger: TCTrigger;
begin
  Wanted.Clear();

  Trigger := Client.DatabaseByName(SelectedDatabase).TriggerByName(SelectedNavigator);

  if (Assigned(Trigger) and (not SynMemo.Modified or PostObject(Sender))) then
  begin
    FObjectIDEGrid.EditorMode := False;
    if (Sender = BINSERT) then
      SQL := Trigger.SQLInsert()
    else if (Sender = BREPLACE) then
      SQL := Trigger.SQLReplace()
    else if (Sender = BUPDATE) then
      SQL := Trigger.SQLUpdate()
    else if (Sender = BDELETE) then
      SQL := Trigger.SQLDelete();

    if (SelectedDatabase <> Client.DatabaseName) then
      SQL := Client.SQLUse(SelectedDatabase) + SQL;

    Client.ExecuteSQL(SQL);
  end;
end;

procedure TFClient.ClientRefresh(const Event: TCClient.TEvent);
var
  Control: TWinControl;
  OldAddress: string;
  TempActiveControl: TWinControl;
  TempSelectedItem: string;
  WTable: TWTable;
begin
  LeftMousePressed := False;

  TempActiveControl := Window.ActiveControl;
  TempSelectedItem := SelectedItem;

  if (not Assigned(Event.CItem)) then
  begin
    Client.SQLEditorResult.Clear();
    Client.QueryBuilderResult.Clear();
  end;


  OldAddress := Address;

  FNavigatorRefresh(Event);

  if ((OldAddress <> '') and (Address <> OldAddress)) then
    Wanted.Address := OldAddress
  else if (Assigned(FNavigator.Selected)) then
  begin
    FNavigatorMenuNode := FNavigator.Selected;
    PContentRefresh(Event.Sender);
  end;

  if (PContent.Visible and Assigned(TempActiveControl) and TempActiveControl.Visible) then
  begin
    SelectedItem := TempSelectedItem;
    Control := TempActiveControl;
    while (Control.Visible and Control.Enabled and Assigned(Control.Parent)) do Control := Control.Parent;
    if (Control.Visible and Control.Enabled) then
      Window.ActiveControl := TempActiveControl;
  end;

  if (Assigned(Workbench)) then
    Workbench.Refresh();

  if ((Event.EventType = ceCreated) and Assigned(Event.Database) and (SelectedDatabase = Event.Database.Name)) then
    case (View) of
      avDiagram:
        if (Event.CItem is TCBaseTable) then
        begin
          Workbench.BeginUpdate();
          WTable := TWTable.Create(Workbench.Tables);
          WTable.Caption := Event.CItem.Name;
          FWorkbenchValidateControl(nil, WTable);
          WTable.Move(nil, [], FWorkbenchMouseDownPoint);
          Workbench.Tables.Add(WTable);
          FWorkbenchValidateForeignKeys(nil, WTable);
          Workbench.Selected := WTable;
          Workbench.EndUpdate();
        end;
    end;

  if ((Event.EventType = ceCreated) and (Event.CItem is TCDBObject)) then
    Wanted.Initialize := TCDBObject(Event.CItem).Initialize;
end;

procedure TFClient.CMActivateFGrid(var Message: TMessage);
begin
  Window.ActiveControl := FGrid;
  FGrid.EditorMode := False;
end;

procedure TFClient.CMActivateFText(var Message: TMessage);
const
  KEYEVENTF_UNICODE = 4;
var
  Input: TInput;
begin
  Window.ActiveControl := FText;
  if (Message.WParam <> 0) then
  begin
    ZeroMemory(@Input, SizeOf(Input));
    Input.Itype := INPUT_KEYBOARD;
    Input.ki.wVk := Message.WParam;
    Input.ki.dwFlags := KEYEVENTF_UNICODE;
    SendInput(1, Input, SizeOf(Input));
  end;
  FText.SelStart := Length(FText.Text);
end;

procedure TFClient.CMBeforeReceivingDataSet(var Message: TMessage);
var
  DataSet: TDataSet;
  I: Integer;
begin
  DataSet := TDataSet(Message.wParam);

  Client.OpenDataSets();

  if ((View = avDataBrowser) and (DataSet is TCTableDataSet) and (TCTableDataSet(DataSet).DatabaseName = SelectedDatabase) and (TCTableDataSet(DataSet).CommandText = SelectedTable)) then
  begin
    FUDOffset.Position := TCTableDataSet(DataSet).Offset;
    FLimitEnabled.Down := TCTableDataSet(DataSet).Limit > 0;
    if (FLimitEnabled.Down) then
      FUDLimit.Position := TCTableDataSet(DataSet).Limit;

    FFilterEnabled.Down := TCTableDataSet(DataSet).FilterSQL <> '';
    FFilterEnabled.Enabled := FFilter.Text <> '';
    FilterMRU.Clear();
    if (FFilterEnabled.Down) then
      FFilter.Text := TCTableDataSet(DataSet).FilterSQL;
    for I := 0 to TCTableDataSet(DataSet).Table.Desktop.FilterCount - 1 do
      FilterMRU.Add(TCTableDataSet(DataSet).Table.Desktop.Filters[I]);
    gmFilter.Clear();

    FQuickSearchEnabled.Down := TCTableDataSet(DataSet).QuickSearch <> '';

    Window.Perform(CM_UPDATETOOLBAR, 0, LPARAM(Self));

    AddressChange(nil);
  end;
end;

procedure TFClient.CMChangePreferences(var Message: TMessage);
var
  Event: TCClient.TEvent;
  I: Integer;
begin
  TBSideBar.Images := Preferences.SmallImages;
  ToolBar.Images := Preferences.SmallImages;
  FNavigator.Images := Preferences.SmallImages;
  FBookmarks.SmallImages := Preferences.SmallImages;
  FSQLHistory.Images := Preferences.SmallImages;
  ToolBarLimitEnabled.Images := Preferences.SmallImages;
  ToolBarQuickSearchEnabled.Images := Preferences.SmallImages;
  ToolBarFilterEnabled.Images := Preferences.SmallImages;
  FList.SmallImages := Preferences.SmallImages;


  Perform(CM_SYSFONTCHANGED, 0, 0);

  Client.SQLMonitor.CacheSize := Preferences.LogSize;
  if (Preferences.LogResult) then
    Client.SQLMonitor.TraceTypes := Client.SQLMonitor.TraceTypes + [ttInfo]
  else
    Client.SQLMonitor.TraceTypes := Client.SQLMonitor.TraceTypes - [ttInfo];
  if (Preferences.LogTime) then
    Client.SQLMonitor.TraceTypes := Client.SQLMonitor.TraceTypes + [ttTime]
  else
    Client.SQLMonitor.TraceTypes := Client.SQLMonitor.TraceTypes - [ttTime];

  aPExpand.Caption := Preferences.LoadStr(150);
  aPCollapse.Caption := Preferences.LoadStr(151);
  aPOpenInNewWindow.Caption := Preferences.LoadStr(760);
  aPOpenInNewTab.Caption := Preferences.LoadStr(850);
  aDDelete.Caption := Preferences.LoadStr(559);
  aDPrev.Caption := Preferences.LoadStr(512);
  aDNext.Caption := Preferences.LoadStr(513);
  DataSetFirst.Caption := Preferences.LoadStr(514);
  DataSetLast.Caption := Preferences.LoadStr(515);
  DataSetPost.Caption := Preferences.LoadStr(516);
  DataSetCancel.Caption := Preferences.LoadStr(517);
  aVBlobText.Caption := Preferences.LoadStr(379);
  aVBlobRTF.Caption := 'RTF';
  aVBlobHTML.Caption := 'HTML';
  aVBlobImage.Caption := Preferences.LoadStr(380);
  aVBlobHexEditor.Caption := Preferences.LoadStr(381);
  mwCreateSection.Caption := Preferences.LoadStr(877) + ' ...';
  mwCreateLine.Caption := Preferences.LoadStr(251) + ' ...';

  for I := 0 to ActionList.ActionCount - 1 do
    if (ActionList.Actions[I] is TCustomAction) and (TCustomAction(ActionList.Actions[I]).Hint = '') then
      TCustomAction(ActionList.Actions[I]).Hint := TCustomAction(ActionList.Actions[I]).Caption;

  tbObjectBrowser.Caption := ReplaceStr(Preferences.LoadStr(4), '&', '');
  tbDataBrowser.Caption := ReplaceStr(Preferences.LoadStr(5), '&', '');
  tbObjectIDE.Caption := ReplaceStr(Preferences.LoadStr(865), '&', '');
  tbQueryBuilder.Caption := ReplaceStr(tbQueryBuilder.Caption, '&', '');
  tbSQLEditor.Caption := ReplaceStr(Preferences.LoadStr(6), '&', '');
  tbDiagram.Caption := ReplaceStr(Preferences.LoadStr(800), '&', '');

  miNImport.Caption := Preferences.LoadStr(371);
  miNExport.Caption := Preferences.LoadStr(200);
  miNCreate.Caption := Preferences.LoadStr(26);
  miNDelete.Caption := Preferences.LoadStr(559);

  mbBOpen.Caption := Preferences.LoadStr(581);

  miHOpen.Caption := Preferences.LoadStr(581);
  miHSaveAs.Caption := MainAction('aFSaveAs').Caption;
  miHStatementIntoSQLEditor.Caption := Preferences.LoadStr(198) + ' -> ' + Preferences.LoadStr(20);
  miHRun.Caption := MainAction('aDRun').Caption;
  miHProperties.Caption := Preferences.LoadStr(684) + '...';

  mlOpen.Caption := Preferences.LoadStr(581);
  mlFImport.Caption := Preferences.LoadStr(371);
  mlFExport.Caption := Preferences.LoadStr(200);
  mlDCreate.Caption := Preferences.LoadStr(26);
  mlDDelete.Caption := Preferences.LoadStr(559);

  mwFImport.Caption := Preferences.LoadStr(371);
  mwFExport.Caption := Preferences.LoadStr(200);
  mwAddTable.Caption := Preferences.LoadStr(383);
  mwEPaste.Caption := MainAction('aEPaste').Caption;
  mwDCreate.Caption := Preferences.LoadStr(26);
  mwDProperties.Caption := Preferences.LoadStr(97) + '...';

  gmFExport.Caption := Preferences.LoadStr(200);
  gmFilter.Caption := Preferences.LoadStr(209);

  FSQLHistory.Font.Name := Preferences.SQLFontName;
  FSQLHistory.Font.Style := Preferences.SQLFontStyle;
  FSQLHistory.Font.Color := Preferences.SQLFontColor;
  FSQLHistory.Font.Size := Preferences.SQLFontSize;
  FSQLHistory.Font.Charset := Preferences.SQLFontCharset;

  mtDataBrowser.Caption := tbDataBrowser.Caption;
  mtObjectIDE.Caption := tbObjectIDE.Caption;
  mtQueryBuilder.Caption := tbQueryBuilder.Caption;
  mtSQLEditor.Caption := tbSQLEditor.Caption;
  mtDiagram.Caption := tbDiagram.Caption;

  tbDataBrowser.Visible := ttDataBrowser in Preferences.ToolbarTabs;
  tbObjectIDE.Visible := ttObjectIDE in Preferences.ToolbarTabs;
  tbQueryBuilder.Visible := ttQueryBuilder in Preferences.ToolbarTabs;
  tbSQLEditor.Visible := ttSQLEditor in Preferences.ToolbarTabs;
  tbDiagram.Visible := ttDiagram in Preferences.ToolbarTabs;


  if (not (tsLoading in FrameState)) then
  begin
    Event.EventType := ceBuild;
    Event.Sender := Client;
    Event.CItem := nil;
    Event.Database := nil;
    Event.Initialize := Client.Initialize;
    ClientRefresh(Event);
  end;

  acQBLanguageManager.CurrentLanguageIndex := -1;
  for I := 0 to acQBLanguageManager.LanguagesCount - 1 do
    if (lstrcmpi(PChar(acQBLanguageManager.Language[i].LanguageName), PChar(Preferences.Language.ActiveQueryBuilderLanguageName)) = 0) then
      acQBLanguageManager.CurrentLanguageIndex := I;
  SQLBuilder.RightMargin := Preferences.Editor.RightEdge;

  FOffset.Hint := ReplaceStr(Preferences.LoadStr(846), '&', '') + ' (' + ShortCutToText(aTBOffset.ShortCut) + ')';
  FUDOffset.Hint := ReplaceStr(Preferences.LoadStr(846), '&', '');
  FLimit.Hint := ReplaceStr(Preferences.LoadStr(197), '&', '') + ' (' + ShortCutToText(aTBLimit.ShortCut) + ')';
  FUDLimit.Hint := ReplaceStr(Preferences.LoadStr(846), '&', '');
  FLimitEnabled.Hint := ReplaceStr(Preferences.LoadStr(197), '&', '');
  FFilter.Hint := ReplaceStr(Preferences.LoadStr(209), '&', '') + ' (' + ShortCutToText(aTBFilter.ShortCut) + ')';
  FFilterEnabled.Hint := ReplaceStr(Preferences.LoadStr(209), '&', '');
  FQuickSearch.Hint := ReplaceStr(Preferences.LoadStr(424), '&', '') + ' (' + ShortCutToText(aTBQuickSearch.ShortCut) + ')';
  FQuickSearchEnabled.Hint := ReplaceStr(Preferences.LoadStr(424), '&', '');
  FBlobSearch.Hint := ReplaceStr(Preferences.LoadStr(424), '&', '');

  if (Preferences.Editor.LineNumbersBackground = clNone) then
    FSQLEditor.Gutter.Color := clBtnFace
  else
    FSQLEditor.Gutter.Color := Preferences.Editor.LineNumbersBackground;
  FSQLEditor.Gutter.Font.Style := Preferences.Editor.LineNumbersStyle;
  FSQLEditor.Gutter.Font.Size := FSQLEditor.Font.Size;
  FSQLEditor.Gutter.Font.Charset := FSQLEditor.Font.Charset;
  FSQLEditor.Gutter.Visible := Preferences.Editor.LineNumbers;
  FSQLEditor.Options := FSQLEditor.Options + [eoScrollHintFollows];  // Slow down the performance on large content
  if (Preferences.Editor.AutoIndent) then
    FSQLEditor.Options := FSQLEditor.Options + [eoAutoIndent, eoSmartTabs]
  else
    FSQLEditor.Options := FSQLEditor.Options - [eoAutoIndent, eoSmartTabs];
  if (Preferences.Editor.TabToSpaces) then
    FSQLEditor.Options := FSQLEditor.Options + [eoTabsToSpaces]
  else
    FSQLEditor.Options := FSQLEditor.Options - [eoTabsToSpaces];
  FSQLEditor.TabWidth := Preferences.Editor.TabWidth;
  FSQLEditor.RightEdge := Preferences.Editor.RightEdge;
  FSQLEditor.WantTabs := Preferences.Editor.TabAccepted;
  if (not Preferences.Editor.CurrRowBGColorEnabled) then
    FSQLEditor.ActiveLineColor := clNone
  else
    FSQLEditor.ActiveLineColor := Preferences.Editor.CurrRowBGColor;

  for I := 0 to PSQLEditor.ControlCount - 1 do
    if (PSQLEditor.Controls[I] is TSynMemo) then
      SynMemoApllyPreferences(TSynMemo(PSQLEditor.Controls[I]));

  SynMemoApllyPreferences(FBuilderEditor);

  FSQLEditorPrint.Font := FSQLEditor.Font;

  {$IFNDEF Debug}
  // Bug in SynEdit: Bei Verwendung in der Delphi IDE h�ngt sich diess Programm auf
  FSQLEditorCompletion.Font.Name := FSQLEditor.Font.Name;
  {$ENDIF}
  FSQLEditorCompletion.Font.Style := FSQLEditor.Font.Style;
  FSQLEditorCompletion.Font.Color := FSQLEditor.Font.Color;
  FSQLEditorCompletion.Font.Size := FSQLEditor.Font.Size;
  FSQLEditorCompletion.Font.Charset := FSQLEditor.Font.Charset;

  for I := 0 to TCResult.Tabs.Count - 1 do
    TCResult.Tabs[I] := Preferences.LoadStr(861, IntToStr(I + 1));

  smEEmpty.Caption := Preferences.LoadStr(181);

  for I := 0 to FNavigator.Items.Count - 1 do
    case (FNavigator.Items[I].ImageIndex) of
      iiHosts: FNavigator.Items[I].Text := Preferences.LoadStr(335);
      iiProcesses: FNavigator.Items[I].Text := ReplaceStr(Preferences.LoadStr(24), '&', '');
      iiStati: FNavigator.Items[I].Text := ReplaceStr(Preferences.LoadStr(23), '&', '');
      iiUsers: FNavigator.Items[I].Text := ReplaceStr(Preferences.LoadStr(561), '&', '');
      iiVariables: FNavigator.Items[I].Text := ReplaceStr(Preferences.LoadStr(22), '&', '');
    end;

  BINSERT.Font := FSQLEditor.Font;
  BINSERT.Font.Style := [fsBold];
  BREPLACE.Font := BINSERT.Font;
  BUPDATE.Font := BINSERT.Font;
  BDELETE.Font := BINSERT.Font;

  OpenDialog.EncodingLabel := Preferences.LoadStr(682) + ':';
  SaveDialog.EncodingLabel := Preferences.LoadStr(682) + ':';

  SQLBuilderSQLUpdated(nil);

  if (PList.Visible) then
    case (SelectedImageIndex) of
      iiServer:
      begin
        if (View = avObjectBrowser) then
        begin
          FList.Column[0].Caption := ReplaceStr(Preferences.LoadStr(38), '&', '');
          FList.Column[1].Caption := Preferences.LoadStr(76);
          FList.Column[2].Caption := Preferences.LoadStr(67);
          FList.Column[3].Caption := Preferences.LoadStr(77);
        end
        else if (View = avDataBrowser) then
        begin
          FList.Column[0].Caption := Preferences.LoadStr(267);
          FList.Column[1].Caption := Preferences.LoadStr(268);
        end;
      end;
      iiDatabase,
      iiSystemDatabase:
      begin
        FList.Column[0].Caption := ReplaceStr(Preferences.LoadStr(35), '&', '');
        FList.Column[1].Caption := Preferences.LoadStr(69);
        FList.Column[2].Caption := Preferences.LoadStr(66);
        FList.Column[3].Caption := Preferences.LoadStr(67);
        FList.Column[4].Caption := Preferences.LoadStr(68);
        FList.Column[5].Caption := ReplaceStr(Preferences.LoadStr(73), '&', '');
        FList.Column[6].Caption := ReplaceStr(Preferences.LoadStr(111), '&', '');
      end;
      iiBaseTable,
      iiSystemView:
      begin
        FList.Column[0].Caption := ReplaceStr(Preferences.LoadStr(35), '&', '');
        FList.Column[1].Caption := Preferences.LoadStr(69);
        FList.Column[2].Caption := Preferences.LoadStr(71);
        FList.Column[3].Caption := Preferences.LoadStr(72);
        FList.Column[4].Caption := ReplaceStr(Preferences.LoadStr(73), '&', '');
        if (FList.Columns.Count > 5) then
          FList.Column[5].Caption := ReplaceStr(Preferences.LoadStr(111), '&', '');
      end;
      iiHosts:
        FList.Column[0].Caption := Preferences.LoadStr(335);
      iiUsers:
        FList.Column[0].Caption := Preferences.LoadStr(335);
      iiStati,
      iiVariables:
      begin
        FList.Column[0].Caption := Preferences.LoadStr(267);
        FList.Column[1].Caption := Preferences.LoadStr(268);
      end;
      iiProcesses:
      begin
        FList.Column[0].Caption := Preferences.LoadStr(269);
        FList.Column[1].Caption := ReplaceStr(Preferences.LoadStr(561), '&', '');
        FList.Column[2].Caption := Preferences.LoadStr(271);
        FList.Column[3].Caption := ReplaceStr(Preferences.LoadStr(38), '&', '');
        FList.Column[4].Caption := Preferences.LoadStr(273);
        FList.Column[5].Caption := Preferences.LoadStr(274);
        FList.Column[6].Caption := ReplaceStr(Preferences.LoadStr(661), '&', '');
        FList.Column[7].Caption := Preferences.LoadStr(276);
      end;
    end;

  if (PList.Visible) then
    for I := 0 to FList.Items.Count - 1 do
      case (FList.Items[I].ImageIndex) of
        iiHosts: FList.Items[I].Caption := Preferences.LoadStr(335);
        iiProcesses: FList.Items[I].Caption := ReplaceStr(Preferences.LoadStr(24), '&', '');
        iiStati: FList.Items[I].Caption := ReplaceStr(Preferences.LoadStr(23), '&', '');
        iiUsers: FList.Items[I].Caption := ReplaceStr(Preferences.LoadStr(561), '&', '');
        iiVariables: FList.Items[I].Caption := ReplaceStr(Preferences.LoadStr(22), '&', '');
      end;

  FLog.Font.Name := Preferences.LogFontName;
  FLog.Font.Style := Preferences.LogFontStyle;
  FLog.Font.Color := Preferences.LogFontColor;
  FLog.Font.Size := Preferences.LogFontSize;
  FLog.Font.Charset := Preferences.LogFontCharset;

  if (Visible) then
    PContentRefresh(nil);

  PasteMode := False;
end;

procedure TFClient.CMCloseTabQuery(var Message: TMessage);
var
  CanClose: Boolean;
  Database: TCDatabase;
  I: Integer;
  Msg: string;
  ServerNode: TTreeNode;
begin
  CanClose := True;

  if (CanClose and Assigned(FGrid.DataSource.DataSet) and FGrid.DataSource.DataSet.Active) then
    FGrid.DataSource.DataSet.CheckBrowseMode();

  if (CanClose) then
    if (FSQLEditor.Modified and (SQLEditor.Filename <> '')) then
    begin
      if (SQLEditor.Filename = '') then
        Msg := Preferences.LoadStr(589)
      else
        Msg := Preferences.LoadStr(584, ExtractFileName(SQLEditor.Filename));
      View := avSQLEditor;
      Window.ActiveControl := FSQLEditor;
      case (MsgBox(Msg, Preferences.LoadStr(101), MB_YESNOCANCEL + MB_ICONQUESTION)) of
        IDYES: SaveSQLFile(MainAction('aFSave'));
        IDCANCEL: CanClose := False;
      end;
    end;

  ServerNode := FNavigator.Items.getFirstNode();
  if (Assigned(ServerNode)) then
    for I := 0 to ServerNode.Count - 1 do
      if (CanClose and (ServerNode.Item[I].ImageIndex = iiDatabase)) then
      begin
        Database := Client.DatabaseByName(ServerNode.Item[I].Text);
        if (Assigned(Database) and Assigned(Database.Workbench) and TWWorkbench(Database.Workbench).Modified) then
        begin
          try
            SysUtils.ForceDirectories(ExtractFilePath(Client.Account.DataPath + Database.Name));
          except
            raise EInOutError.Create(SysErrorMessage(GetLastError()) + '  (' + Client.Account.DataPath + Database.Name + ')');
          end;
          TWWorkbench(Database.Workbench).SaveToFile(Client.Account.DataPath + Database.Name + PathDelim + 'Diagram.xml');
        end;
      end;

  if (not CanClose) then
    Message.Result := 0
  else
    Message.Result := 1;
end;

procedure TFClient.CMExecute(var Message: TMessage);
begin
  MainAction('aDRun').Execute();

  Window.Close();
end;

procedure TFClient.CMFrameActivate(var Message: TMessage);
begin
  Include(FrameState, tsActive);

  FormatSettings.ThousandSeparator := Client.FormatSettings.ThousandSeparator;
  FormatSettings.DecimalSeparator := Client.FormatSettings.DecimalSeparator;
  FormatSettings.ShortDateFormat := Client.FormatSettings.ShortDateFormat;
  FormatSettings.LongTimeFormat := Client.FormatSettings.LongTimeFormat;
  FormatSettings.DateSeparator := Client.FormatSettings.DateSeparator;
  FormatSettings.TimeSeparator := Client.FormatSettings.TimeSeparator;

  Application.OnHelp := ApplicationHelp;

  Client.BeforeConnect := BeforeConnect;
  Client.AfterConnect := AfterConnect;
  Client.BeforeExecuteSQL := BeforeExecuteSQL;
  Client.OnConvertError := OnConvertError;
  Client.AfterExecuteSQL := AfterExecuteSQL;

  if (Window.ActiveControl is TWinControl) then
    Perform(CM_ENTER, 0, 0);

  if (Assigned(MainActionList)) then
  begin
    MainAction('aVNavigator').Checked := PNavigator.Visible;
    MainAction('aVBookmarks').Checked := PBookmarks.Visible;
    MainAction('aVSQLHistory').Checked := PSQLHistory.Visible;
    MainAction('aVSQLLog').Checked := PLog.Visible;

    MainAction('aFOpen').OnExecute := aFOpenExecute;
    MainAction('aFSave').OnExecute := aFSaveExecute;
    MainAction('aFSaveAs').OnExecute := aFSaveAsExecute;
    MainAction('aFImportSQL').OnExecute := aFImportSQLExecute;
    MainAction('aFImportText').OnExecute := aFImportTextExecute;
    MainAction('aFImportExcel').OnExecute := aFImportExcelExecute;
    MainAction('aFImportAccess').OnExecute := aFImportAccessExecute;
    MainAction('aFImportSQLite').OnExecute := aFImportSQLiteExecute;
    MainAction('aFImportODBC').OnExecute := aFImportODBCExecute;
    MainAction('aFImportXML').OnExecute := aFImportXMLExecute;
    MainAction('aFExportSQL').OnExecute := aFExportSQLExecute;
    MainAction('aFExportText').OnExecute := aFExportTextExecute;
    MainAction('aFExportExcel').OnExecute := aFExportExcelExecute;
    MainAction('aFExportAccess').OnExecute := aFExportAccessExecute;
    MainAction('aFExportSQLite').OnExecute := aFExportSQLiteExecute;
    MainAction('aFExportODBC').OnExecute := aFExportODBCExecute;
    MainAction('aFExportXML').OnExecute := aFExportXMLExecute;
    MainAction('aFExportHTML').OnExecute := aFExportHTMLExecute;
    MainAction('aFExportBitmap').OnExecute := aFExportBitmapExecute;
    MainAction('aFPrint').OnExecute := aFPrintExecute;
    MainAction('aERedo').OnExecute := aERedoExecute;
    MainAction('aECopy').OnExecute := aECopyExecute;
    MainAction('aEPaste').OnExecute := aEPasteExecute;
    MainAction('aERename').OnExecute := aERenameExecute;
    MainAction('aVObjectBrowser').OnExecute := aViewExecute;
    MainAction('aVDataBrowser').OnExecute := aViewExecute;
    MainAction('aVObjectIDE').OnExecute := aViewExecute;
    MainAction('aVQueryBuilder').OnExecute := aViewExecute;
    MainAction('aVSQLEditor').OnExecute := aViewExecute;
    MainAction('aVDiagram').OnExecute := aViewExecute;
    MainAction('aVNavigator').OnExecute := aVSideBarExecute;
    MainAction('aVBookmarks').OnExecute := aVSideBarExecute;
    MainAction('aVSQLHistory').OnExecute := aVSideBarExecute;
    MainAction('aVSQLLog').OnExecute := aVSQLLogExecute;
    MainAction('aVDetails').OnExecute := aVDetailsExecute;
    MainAction('aVRefresh').OnExecute := aVRefreshExecute;
    MainAction('aVRefreshAll').OnExecute := aVRefreshAllExecute;
    MainAction('aBAdd').OnExecute := aBAddExecute;
    MainAction('aBDelete').OnExecute := aBDeleteExecute;
    MainAction('aBEdit').OnExecute := aBEditExecute;
    MainAction('aBookmark').OnExecute := aBookmarkExecute;
    MainAction('aDCancel').OnExecute := aDCancelExecute;
    MainAction('aDCreateDatabase').OnExecute := aDCreateDatabaseExecute;
    MainAction('aDCreateTable').OnExecute := aDCreateTableExecute;
    MainAction('aDCreateView').OnExecute := aDCreateViewExecute;
    MainAction('aDCreateProcedure').OnExecute := aDCreateRoutineExecute;
    MainAction('aDCreateFunction').OnExecute := aDCreateRoutineExecute;
    MainAction('aDCreateIndex').OnExecute := aDCreateIndexExecute;
    MainAction('aDCreateField').OnExecute := aDCreateFieldExecute;
    MainAction('aDCreateForeignKey').OnExecute := aDCreateForeignKeyExecute;
    MainAction('aDCreateTrigger').OnExecute := aDCreateTriggerExecute;
    MainAction('aDCreateEvent').OnExecute := aDCreateEventExecute;
    MainAction('aDCreateHost').OnExecute := aDCreateHostExecute;
    MainAction('aDCreateUser').OnExecute := aDCreateUserExecute;
    MainAction('aDEditServer').OnExecute := PropertiesServerExecute;
    MainAction('aDEditDatabase').OnExecute := aDPropertiesExecute;
    MainAction('aDEditTable').OnExecute := aDPropertiesExecute;
    MainAction('aDEditView').OnExecute := aDPropertiesExecute;
    MainAction('aDEditRoutine').OnExecute := aDPropertiesExecute;
    MainAction('aDEditEvent').OnExecute := aDPropertiesExecute;
    MainAction('aDEditTrigger').OnExecute := aDPropertiesExecute;
    MainAction('aDEditIndex').OnExecute := aDPropertiesExecute;
    MainAction('aDEditField').OnExecute := aDPropertiesExecute;
    MainAction('aDEditForeignKey').OnExecute := aDPropertiesExecute;
    MainAction('aDEditHost').OnExecute := aDPropertiesExecute;
    MainAction('aDEditProcess').OnExecute := aDPropertiesExecute;
    MainAction('aDEditUser').OnExecute := aDPropertiesExecute;
    MainAction('aDEditVariable').OnExecute := aDPropertiesExecute;
    MainAction('aDDeleteDatabase').OnExecute := aDDeleteExecute;
    MainAction('aDDeleteTable').OnExecute := aDDeleteExecute;
    MainAction('aDDeleteView').OnExecute := aDDeleteExecute;
    MainAction('aDDeleteRoutine').OnExecute := aDDeleteExecute;
    MainAction('aDDeleteIndex').OnExecute := aDDeleteExecute;
    MainAction('aDDeleteField').OnExecute := aDDeleteExecute;
    MainAction('aDDeleteForeignKey').OnExecute := aDDeleteExecute;
    MainAction('aDDeleteTrigger').OnExecute := aDDeleteExecute;
    MainAction('aDDeleteEvent').OnExecute := aDDeleteExecute;
    MainAction('aDDeleteHost').OnExecute := aDDeleteExecute;
    MainAction('aDDeleteUser').OnExecute := aDDeleteExecute;
    MainAction('aDDeleteProcess').OnExecute := aDDeleteExecute;
    MainAction('aDInsertRecord').OnExecute := aDInsertRecordExecute;
    MainAction('aDDeleteRecord').OnExecute := aDDeleteRecordExecute;
    MainAction('aDRun').OnExecute := aDRunExecute;
    MainAction('aDRunSelection').OnExecute := aDRunSelectionExecute;
    MainAction('aDPostObject').OnExecute := aDPostObjectExecute;
    MainAction('aDAutoCommit').OnExecute := aDAutoCommitExecute;
    MainAction('aDCommit').OnExecute := aDCommitExecute;
    MainAction('aDRollback').OnExecute := aDRollbackExecute;


    MainAction('aSAddress').Enabled := True;
    MainAction('aVObjectBrowser').Enabled := True;
    MainAction('aVDataBrowser').Enabled := (SelectedImageIndex in [iiBaseTable, iiSystemView, iiView, iiTrigger]) or ((LastSelectedDatabase <> '') and (LastSelectedDatabase = SelectedDatabase) and (LastSelectedTable <> ''));
    MainAction('aVObjectIDE').Enabled := (SelectedImageIndex in [iiView, iiProcedure, iiFunction, iiEvent, iiTrigger]) or (LastObjectIDEAddress <> '');
    MainAction('aVQueryBuilder').Enabled := (SelectedDatabase <> '');
    MainAction('aVSQLEditor').Enabled := True;
    MainAction('aVDiagram').Enabled := (SelectedDatabase <> '') or (LastSelectedDatabase <> '');
    MainAction('aVNavigator').Enabled := True;
    MainAction('aVBookmarks').Enabled := True;
    MainAction('aVSQLHistory').Enabled := True;
    MainAction('aVSQLLog').Enabled := True;
    MainAction('aVRefresh').Enabled := True;
    MainAction('aVRefreshAll').Enabled := True;
    MainAction('aBAdd').Enabled := True;
    MainAction('aDCancel').Enabled := Client.InUse();
    aDCommitRefresh(nil);

    aPResult.ShortCut := ShortCut(VK_F8, [ssAlt]);

    if (Assigned(ActiveControlOnDeactivate) and ActiveControlOnDeactivate.Visible) then
      try Window.FocusControl(ActiveControlOnDeactivate); except end;

    if (Window.ActiveControl = FNavigator) then FNavigatorEnter(nil)
    else if (Window.ActiveControl = FList) then FListEnter(nil)
    else if (Window.ActiveControl = FLog) then FLogEnter(nil)
    else if (Window.ActiveControl is TSynMemo) then FSQLEditorEnter(nil)
    else if (Window.ActiveControl = FGrid) then DBGridEnter(FGrid);
  end;

  if (Assigned(StatusBar)) then
    StatusBarRefresh(True);
end;

procedure TFClient.CMFrameDeactivate(var Message: TMessage);
begin
  KillTimer(Handle, tiNavigator);
  KillTimer(Handle, tiStatusBar);

  ActiveControlOnDeactivate := Window.ActiveControl;

  Application.OnHelp := nil;

  MainAction('aSAddress').Enabled := False;
  MainAction('aVObjectBrowser').Enabled := False;
  MainAction('aVDataBrowser').Enabled := False;
  MainAction('aVObjectIDE').Enabled := False;
  MainAction('aVQueryBuilder').Enabled := False;
  MainAction('aVSQLEditor').Enabled := False;
  MainAction('aVDiagram').Enabled := False;
  MainAction('aVNavigator').Enabled := False;
  MainAction('aVBookmarks').Enabled := False;
  MainAction('aVSQLHistory').Enabled := False;
  MainAction('aVSQLLog').Enabled := False;
  MainAction('aVRefresh').Enabled := False;
  MainAction('aVRefreshAll').Enabled := False;
  MainAction('aBAdd').Enabled := False;
  MainAction('aDCancel').Enabled := False;
  MainAction('aDAutoCommit').Enabled := False;
  MainAction('aDCommit').Enabled := False;
  MainAction('aDRollback').Enabled := False;

  MainAction('aECopy').OnExecute := nil;
  MainAction('aEPaste').OnExecute := nil;

  aPResult.ShortCut := 0;

  if (Window.ActiveControl = FNavigator) then FNavigatorExit(nil)
  else if (Window.ActiveControl = FList) then FListExit(nil)
  else if (Window.ActiveControl = FLog) then FLogExit(nil)
  else if (Window.ActiveControl is TSynMemo) then FSQLEditorExit(nil)
  else if (Window.ActiveControl = FGrid) then DBGridExit(FGrid);

  Include(FrameState, tsActive);
end;

procedure TFClient.CMPostBuilderQueryChange(var Message: TMessage);
begin
  FBuilderEditorPageControlCheckStyle();
end;

procedure TFClient.CMPostMonitor(var Message: TMessage);
var
  Text: string;
begin
  if (MainAction('aVSQLLog').Checked) then
  begin
    Text := Client.SQLMonitor.CacheText;
    try
      SendMessage(FLog.Handle, WM_SETTEXT, 0, LPARAM(PChar(Text)));
    except
    end;

    PLogResize(nil);
  end;
end;

procedure TFClient.CMPostPostScroll(var Message: TMessage);
begin
  StatusBarRefresh();
end;

procedure TFClient.CMPostShow(var Message: TMessage);
var
  URI: TUURI;
begin
  PNavigator.Visible := Client.Account.Desktop.NavigatorVisible;
  PBookmarks.Visible := Client.Account.Desktop.BookmarksVisible;
  PSQLHistory.Visible := Client.Account.Desktop.SQLHistoryVisible; if (PSQLHistory.Visible) then FSQLHistoryRefresh(nil);
  PSideBar.Visible := PNavigator.Visible or PBookmarks.Visible or PSQLHistory.Visible; SSideBar.Visible := PSideBar.Visible;

  PSideBar.Width := Client.Account.Desktop.SelectorWitdth;

  FSQLEditor.Options := FSQLEditor.Options + [eoScrollPastEol];  // Speed up the performance
  FSQLEditor.Text := Client.Account.Desktop.EditorContent;
  if (Length(FSQLEditor.Lines.Text) < LargeSQLScriptSize) then
    FSQLEditor.Options := FSQLEditor.Options - [eoScrollPastEol]  // Slow down the performance on large content
  else
    FSQLEditor.Options := FSQLEditor.Options + [eoScrollPastEol];  // Speed up the performance
  PResult.Height := Client.Account.Desktop.DataHeight;
  PResultHeight := PResult.Height;
  PBlob.Height := Client.Account.Desktop.BlobHeight;

  PLog.Height := Client.Account.Desktop.LogHeight;
  PLog.Visible := Client.Account.Desktop.LogVisible; SLog.Visible := PLog.Visible;

  aVBlobText.Checked := True;

  FormResize(nil);

  Visible := True;

  Perform(CM_ACTIVATEFRAME, 0, 0);

  Exclude(FrameState, tsLoading);


  if (Copy(Param, 1, 8) = 'mysql://') then
    Address := Param
  else if (Param <> '') then
  begin
    URI := TUURI.Create(Client.Account.Desktop.Address);
    URI.Param['view'] := 'editor';
    URI.Table := '';
    URI.Param['system'] := Null;
    URI.Param['filter'] := Null;
    URI.Param['offset'] := Null;
    URI.Param['file'] := PathToURI(SQLEditor.Filename);
    Address := URI.Address;
    URI.Free();
  end
  else
    Address := Client.Account.Desktop.Address;
  Param := '';

  if (PSideBar.Visible) then
  begin
    if (PNavigator.Visible) then Window.ActiveControl := FNavigator
    else if (PBookmarks.Visible) then Window.ActiveControl := FBookmarks
    else if (PList.Visible) then Window.ActiveControl := FList
    else if (PBuilder.Visible) then Window.ActiveControl := FBuilder
    else if (PSQLEditor.Visible) then Window.ActiveControl := FSQLEditor
    else if (PResult.Visible and PGrid.Visible) then Window.ActiveControl := FGrid;
  end
  else
    case (View) of
      avObjectBrowser: if (PList.Visible) then Window.ActiveControl := FList;
      avDataBrowser: if (PResult.Visible and PGrid.Visible) then Window.ActiveControl := FGrid;
      avObjectIDE: if (PSQLEditor.Visible and Assigned(SynMemo)) then Window.ActiveControl := SynMemo;
      avQueryBuilder: if (PBuilder.Visible and Assigned(FBuilderActiveWorkArea())) then Window.ActiveControl := FBuilderActiveWorkArea();
      avSQLEditor: if (PSQLEditor.Visible) then Window.ActiveControl := FSQLEditor;
      avDiagram: if (PWorkbench.Visible) then Window.ActiveControl := Workbench;
    end;
end;

procedure TFClient.CMRemoveWForeignKey(var Message: TMessage);
var
  ForeignKey: TWForeignKey;
  Index: Integer;
  Workbench: TWWorkbench;
begin
  Workbench := TWWorkbench(Message.WParam);
  ForeignKey := TWForeignKey(Message.LParam);
  Index := Workbench.ForeignKeys.IndexOf(ForeignKey);
  if (Index >= 0) then
    Workbench.ForeignKeys.Delete(Index);
end;

procedure TFClient.CMSysFontChanged(var Message: TMessage);
var
  I: Integer;
  LogFont: TLogFont;
  NonClientMetrics: TNonClientMetrics;
begin
  inherited;

  if (not StyleServices.Enabled and not CheckWin32Version(6)) then
  begin
    PNavigator.BevelInner := bvRaised; PNavigator.BevelOuter := bvLowered;
    PBookmarks.BevelInner := bvRaised; PBookmarks.BevelOuter := bvLowered;
    PSQLHistory.BevelInner := bvRaised; PSQLHistory.BevelOuter := bvLowered;
    PList.BevelInner := bvRaised; PList.BevelOuter := bvLowered;
    PBuilderQuery.BevelInner := bvRaised; PBuilderQuery.BevelOuter := bvLowered;
    PSQLEditor.BevelInner := bvRaised; PSQLEditor.BevelOuter := bvLowered;
    PWorkbench.BevelInner := bvRaised; PWorkbench.BevelOuter := bvLowered;
    PGrid.BevelInner := bvRaised; PGrid.BevelOuter := bvLowered;
    PBlob.BevelInner := bvRaised; PBlob.BevelOuter := bvLowered;
    PLog.BevelInner := bvRaised; PLog.BevelOuter := bvLowered;

    TBSideBar.BorderWidth := 1;
    ToolBar.BorderWidth := 1;
  end
  else
  begin
    PNavigator.BevelInner := bvNone; PNavigator.BevelOuter := bvNone;
    PBookmarks.BevelInner := bvNone; PBookmarks.BevelOuter := bvNone;
    PSQLHistory.BevelInner := bvNone; PSQLHistory.BevelOuter := bvNone;
    PList.BevelInner := bvNone; PList.BevelOuter := bvNone;
    PBuilderQuery.BevelInner := bvNone; PBuilderQuery.BevelOuter := bvNone;
    PSQLEditor.BevelInner := bvNone; PSQLEditor.BevelOuter := bvNone;
    PWorkbench.BevelInner := bvNone; PWorkbench.BevelOuter := bvNone;
    PGrid.BevelInner := bvNone; PGrid.BevelOuter := bvNone;
    PBlob.BevelInner := bvNone; PBlob.BevelOuter := bvNone;
    PLog.BevelInner := bvNone; PLog.BevelOuter := bvNone;

    TBSideBar.BorderWidth := 2;
    ToolBar.BorderWidth := 2;
  end;

  PSideBarHeader.AutoSize := False;
  TBSideBar.Left := 0;
  TBSideBar.Top := 0;
  TBSideBar.ButtonHeight := TBSideBar.Images.Height + 6; TBSideBar.ButtonWidth := TBSideBar.Images.Width + 7;
  PSideBarHeader.AutoSize := True;

  ToolBar.ButtonHeight := ToolBar.Images.Height + 6; ToolBar.ButtonWidth := ToolBar.Images.Width + 7;
  PToolBar.Height := PSideBarHeader.Height;

  if (CheckWin32Version(6)) then
  begin
    SendMessage(FFilter.Handle, CB_SETCUEBANNER, 0, LParam(PChar(ReplaceStr(Preferences.LoadStr(209), '&', ''))));
    SendMessage(FQuickSearch.Handle, EM_SETCUEBANNER, 0, LParam(PChar(ReplaceStr(Preferences.LoadStr(424), '&', ''))));
    SendMessage(FBlobSearch.Handle, EM_SETCUEBANNER, 0, LParam(PChar(ReplaceStr(Preferences.LoadStr(424), '&', ''))));
  end;

  SetWindowLong(ListView_GetHeader(FList.Handle), GWL_STYLE, GetWindowLong(ListView_GetHeader(FList.Handle), GWL_STYLE) or HDS_DRAGDROP);

  if (not StyleServices.Enabled) then
    PObjectIDESpacer.Color := clBtnFace
  else
    PObjectIDESpacer.Color := clActiveBorder;

  if (Assigned(Client)) then
  begin
    PResultHeader.Width := CloseButton.Bitmap.Width + 2 * GetSystemMetrics(SM_CXEDGE);
    PLogHeader.Width := CloseButton.Bitmap.Width + 2 * GetSystemMetrics(SM_CXEDGE);

    if (Assigned(FGrid.DataSource.DataSet) and (FGrid.DataSource.DataSet is TMySQLDataSet)) then
      SBResultRefresh(TMySQLDataSet(FGrid.DataSource.DataSet));

    FormResize(nil);
  end;

  Font := Window.Font;

  FSQLEditor.Font.Name := Preferences.SQLFontName;
  FSQLEditor.Font.Style := Preferences.SQLFontStyle;
  FSQLEditor.Font.Color := Preferences.SQLFontColor;
  FSQLEditor.Font.Size := Preferences.SQLFontSize;
  FSQLEditor.Font.Charset := Preferences.SQLFontCharset;
  FSQLEditor.Gutter.Font := FSQLEditor.Font;
  if (Preferences.Editor.LineNumbersForeground = clNone) then
    FSQLEditor.Gutter.Font.Color := clWindowText
  else
    FSQLEditor.Gutter.Font.Color := Preferences.Editor.LineNumbersForeground;

  FGrid.Font.Name := Preferences.GridFontName;
  FGrid.Font.Style := Preferences.GridFontStyle;
  FGrid.Font.Color := Preferences.GridFontColor;
  FGrid.Font.Size := Preferences.GridFontSize;
  FGrid.Font.Charset := Preferences.GridFontCharset;
  NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
  if (SystemParametersInfo(SPI_GETNONCLIENTMETRICS, SizeOf(NonClientMetrics), @NonClientMetrics, 0)
    and (GetObject(FGrid.Font.Handle, SizeOf(LogFont), @LogFont) <> 0)) then
  begin
    LogFont.lfQuality  := NonClientMetrics.lfMessageFont.lfQuality;
    FGrid.Font.Handle := CreateFontIndirect(LogFont);
  end;
  FGrid.Canvas.Font := FGrid.Font;
  for I := 0 to FGrid.Columns.Count - 1 do
    FGrid.Columns[I].Font := FGrid.Font;
  FGrid.OnCanEditShow := Client.GridCanEditShow;

  FText.Font.Name := Preferences.GridFontName;
  FText.Font.Style := Preferences.GridFontStyle;
  FText.Font.Color := Preferences.GridFontColor;
  FText.Font.Size := Preferences.GridFontSize;
  FText.Font.Charset := Preferences.GridFontCharset;
  NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
  if (SystemParametersInfo(SPI_GETNONCLIENTMETRICS, SizeOf(NonClientMetrics), @NonClientMetrics, 0)
    and (GetObject(FText.Font.Handle, SizeOf(LogFont), @LogFont) <> 0)) then
  begin
    LogFont.lfQuality  := NonClientMetrics.lfMessageFont.lfQuality;
    FText.Font.Handle := CreateFontIndirect(LogFont);
  end;
  FText.WantTabs := Preferences.Editor.TabAccepted;

  FRTF.Font := FText.Font;

  FHexEditor.Font := FSQLEditor.Font;
  if (Preferences.Editor.LineNumbersForeground = clNone) then
    FHexEditor.Colors.Offset := clWindowText
  else
    FHexEditor.Colors.Offset := Preferences.Editor.LineNumbersForeground;
  if (Preferences.Editor.LineNumbersBackground = clNone) then
    FHexEditor.Colors.OffsetBackground := clBtnFace
  else
    FHexEditor.Colors.OffsetBackground := Preferences.Editor.LineNumbersBackground;

  SendMessage(FLog.Handle, EM_SETTEXTMODE, TM_PLAINTEXT, 0);
  SendMessage(FLog.Handle, EM_SETWORDBREAKPROC, 0, LPARAM(@EditWordBreakProc));
end;

procedure TFClient.CMWantedSynchronize(var Message: TWMTimer);
begin
  if (not (csDestroying in ComponentState)) then
    Wanted.Synchronize();
end;

function TFClient.ContentWidthIndexFromImageIndex(AImageIndex: Integer): Integer;
begin
  case (AImageIndex) of
    iiServer: Result := 0;
    iiDatabase,
    iiSystemDatabase: Result := 1;
    iiBaseTable,
    iiSystemView,
    iiView: Result := 2;
    iiHosts: Result := 3;
    iiUsers: Result := 4;
    iiProcesses: Result := 5;
    iiStati: Result := 6;
    iiVariables: Result := 7;
    else Result := -1;
  end;
end;

procedure TFClient.CrashRescue();
begin
  if ((SQLEditor.Filename <> '') and not FSQLEditor.Modified) then
    Client.Account.Desktop.EditorContent := ''
  else
    Client.Account.Desktop.EditorContent := FSQLEditor.Text;

  try
    if (Assigned(Workbench)) then
      Workbench.SaveToFile(Client.Account.DataPath + Workbench.Name + PathDelim + 'Diagram.xml');
  except
  end;
end;

procedure TFClient.CreateParams(var Params: TCreateParams);
begin
  inherited;

  Params.Style := Params.Style
    and not (WS_THICKFRAME or WS_SYSMENU or WS_DLGFRAME or WS_BORDER);
end;

constructor TFClient.CreateTab(const AOwner: TComponent; const AParent: TWinControl; const AClient: TCClient; const AParam: string; const IconIndex: Integer);
var
  I: Integer;
  NonClientMetrics: TNonClientMetrics;
begin
  inherited Create(AOwner);


  Parent := TWinControl(AParent);

  Width := Window.ClientWidth;
  Height := Window.ClientHeight;

  FrameState := [tsLoading];

  NMListView := nil;
  Client := AClient;
  SQLEditor.Filename := '';
  SQLEditor.CodePage := CP_ACP;
  Param := AParam;
  ActiveControlOnDeactivate := nil;
  PanelMouseDownPoint := Point(-1, -1);
  for I := 0 to Length(FListSortColumn) - 1 do
  begin
    FListSortColumn[I].Index := 0;
    if (I = 2) then
      FListSortColumn[I].Order := 0
    else
      FListSortColumn[I].Order := 1;
  end;
  CreateLine := False;


  FUDOffset.HandleNeeded();
  FOffset.HandleNeeded();
  FUDLimit.HandleNeeded();
  FLimit.HandleNeeded();

  tbNavigator.Action := MainAction('aVNavigator');
  tbBookmarks.Action := MainAction('aVBookmarks');
  tbSQLHistory.Action := MainAction('aVSQLHistory');

  tbObjectBrowser.Action := MainAction('aVObjectBrowser'); tbObjectBrowser.Caption := ReplaceStr(tbObjectBrowser.Caption, '&', '');
  tbDataBrowser.Action := MainAction('aVDataBrowser'); tbDataBrowser.Caption := ReplaceStr(tbDataBrowser.Caption, '&', '');
  tbObjectIDE.Action := MainAction('aVObjectIDE'); tbObjectIDE.Caption := ReplaceStr(tbObjectIDE.Caption, '&', '');
  tbQueryBuilder.Action := MainAction('aVQueryBuilder'); tbQueryBuilder.Caption := ReplaceStr(tbQueryBuilder.Caption, '&', '');
  tbSQLEditor.Action := MainAction('aVSQLEditor'); tbSQLEditor.Caption := ReplaceStr(tbSQLEditor.Caption, '&', '');
  tbDiagram.Action := MainAction('aVDiagram'); tbDiagram.Caption := ReplaceStr(tbDiagram.Caption, '&', '');

  miSNavigator.Action := MainAction('aVNavigator');
  miSBookmarks.Action := MainAction('aVBookmarks');
  miSSQLHistory.Action := MainAction('aVSQLHistory');

  miNImportSQL.Action := MainAction('aFImportSQL');
  miNImportText.Action := MainAction('aFImportText');
  miNImportExcel.Action := MainAction('aFImportExcel');
  miNImportAccess.Action := MainAction('aFImportAccess');
  miNImportSQLite.Action := MainAction('aFImportSQLite');
  miNImportODBC.Action := MainAction('aFImportODBC');
  miNImportXML.Action := MainAction('aFImportXML');
  miNExportSQL.Action := MainAction('aFExportSQL');
  miNExportText.Action := MainAction('aFExportText');
  miNExportExcel.Action := MainAction('aFExportExcel');
  miNExportAccess.Action := MainAction('aFExportAccess');
  miNExportSQLite.Action := MainAction('aFExportSQLite');
  miNExportODBC.Action := MainAction('aFExportODBC');
  miNExportXML.Action := MainAction('aFExportXML');
  miNExportHTML.Action := MainAction('aFExportHTML');
  miNCopy.Action := MainAction('aECopy');
  miNPaste.Action := MainAction('aEPaste');
  miNRename.Action := MainAction('aERename');
  miNCreateDatabase.Action := MainAction('aDCreateDatabase');
  miNCreateTable.Action := MainAction('aDCreateTable');
  miNCreateView.Action := MainAction('aDCreateView');
  miNCreateProcedure.Action := MainAction('aDCreateProcedure');
  miNCreateFunction.Action := MainAction('aDCreateFunction');
  miNCreateIndex.Action := MainAction('aDCreateIndex');
  miNCreateField.Action := MainAction('aDCreateField');
  miNCreateForeignKey.Action := MainAction('aDCreateForeignKey');
  miNCreateTrigger.Action := MainAction('aDCreateTrigger');
  miNCreateEvent.Action := MainAction('aDCreateEvent');
  miNCreateUser.Action := MainAction('aDCreateUser');
  miNCreateHost.Action := MainAction('aDCreateHost');
  miNEmpty.Action := MainAction('aDEmpty');

  mbBAdd.Action := MainAction('aBAdd');
  mbBDelete.Action := MainAction('aBDelete');
  mbBEdit.Action := MainAction('aBEdit');

  miHCopy.Action := MainAction('aECopy');

  mlFImportSQL.Action := MainAction('aFImportSQL');
  mlFImportText.Action := MainAction('aFImportText');
  mlFImportExcel.Action := MainAction('aFImportExcel');
  mlFImportAccess.Action := MainAction('aFImportAccess');
  mlFImportSQLite.Action := MainAction('aFImportSQLite');
  mlFImportODBC.Action := MainAction('aFImportODBC');
  mlFImportXML.Action := MainAction('aFImportXML');
  mlFExportSQL.Action := MainAction('aFExportSQL');
  mlFExportText.Action := MainAction('aFExportText');
  mlFExportExcel.Action := MainAction('aFExportExcel');
  mlFExportAccess.Action := MainAction('aFExportAccess');
  mlFExportSQLite.Action := MainAction('aFExportSQLite');
  mlFExportODBC.Action := MainAction('aFExportODBC');
  mlFExportXML.Action := MainAction('aFExportXML');
  mlFExportHTML.Action := MainAction('aFExportHTML');
  mlECopy.Action := MainAction('aECopy');
  mlEPaste.Action := MainAction('aEPaste');
  mlERename.Action := MainAction('aERename');
  mlDCreateDatabase.Action := MainAction('aDCreateDatabase');
  mlDCreateTable.Action := MainAction('aDCreateTable');
  mlDCreateView.Action := MainAction('aDCreateView');
  mlDCreateProcedure.Action := MainAction('aDCreateProcedure');
  mlDCreateFunction.Action := MainAction('aDCreateFunction');
  mlDCreateIndex.Action := MainAction('aDCreateIndex');
  mlDCreateField.Action := MainAction('aDCreateField');
  mlDCreateForeignKey.Action := MainAction('aDCreateForeignKey');
  mlDCreateTrigger.Action := MainAction('aDCreateTrigger');
  mlDCreateEvent.Action := MainAction('aDCreateEvent');
  mlDCreateUser.Action := MainAction('aDCreateUser');
  mlDCreateHost.Action := MainAction('aDCreateHost');
  mlDEmpty.Action := MainAction('aDEmpty');

  mpDRun.Action := MainAction('aDRun');
  mpDRunSelection.Action := MainAction('aDRunSelection');
  mpECut.Action := MainAction('aECut');
  mpECopy.Action := MainAction('aECopy');
  mpEPaste.Action := MainAction('aEPaste');
  mpEDelete.Action := MainAction('aEDelete');
  mpECopyToFile.Action := MainAction('aECopyToFile');
  mpEPasteFromFile.Action := MainAction('aEPasteFromFile');
  mpESelectAll.Action := MainAction('aESelectAll');

  gmECut.Action := MainAction('aECut');
  gmECopy.Action := MainAction('aECopy');
  gmEPaste.Action := MainAction('aEPaste');
  gmEDelete.Action := MainAction('aEDelete');
  gmECopyToFile.Action := MainAction('aECopyToFile');
  gmEPasteFromFile.Action := MainAction('aEPasteFromFile');
  gmFExportSQL.Action := MainAction('aFExportSQL');
  gmFExportText.Action := MainAction('aFExportText');
  gmFExportExcel.Action := MainAction('aFExportExcel');
  gmFExportXML.Action := MainAction('aFExportXML');
  gmFExportHTML.Action := MainAction('aFExportHTML');
  gmDInsertRecord.Action := MainAction('aDInsertRecord');
  gmDDeleteRecord.Action := MainAction('aDDeleteRecord');
  gmDEditRecord.Action := MainAction('aDEditRecord');

  mwFImportSQL.Action := MainAction('aFImportSQL');
  mwFImportText.Action := MainAction('aFImportText');
  mwFImportExcel.Action := MainAction('aFImportExcel');
  mwFImportAccess.Action := MainAction('aFImportAccess');
  mwFImportSQLite.Action := MainAction('aFImportSQLite');
  mwFImportODBC.Action := MainAction('aFImportODBC');
  mwFImportXML.Action := MainAction('aFImportXML');
  mwFExportSQL.Action := MainAction('aFExportSQL');
  mwFExportText.Action := MainAction('aFExportText');
  mwFExportExcel.Action := MainAction('aFExportExcel');
  mwFExportAccess.Action := MainAction('aFExportAccess');
  mwFExportSQLite.Action := MainAction('aFExportSQLite');
  mwFExportODBC.Action := MainAction('aFExportODBC');
  mwFExportXML.Action := MainAction('aFExportXML');
  mwFExportHTML.Action := MainAction('aFExportHTML');
  mwFExportBitmap.Action := MainAction('aFExportBitmap');
  mwECopy.Action := MainAction('aECopy');
  mwEDelete.Action := MainAction('aEDelete');
  mwDCreateTable.Action := MainAction('aDCreateTable');
  mwDCreateField.Action := MainAction('aDCreateField');
  mwDCreateForeignKey.Action := MainAction('aDCreateForeignKey');
  mwDEmpty.Action := MainAction('aDEmpty');

  tmECut.Action := MainAction('aECut');
  tmECopy.Action := MainAction('aECopy');
  tmEPaste.Action := MainAction('aEPaste');
  tmEDelete.Action := MainAction('aEDelete');
  tmESelectAll.Action := MainAction('aESelectAll');

  hmECut.Action := MainAction('aECut');
  hmECopy.Action := MainAction('aECopy');
  hmEPaste.Action := MainAction('aEPaste');
  hmEDelete.Action := MainAction('aEDelete');
  hmESelectAll.Action := MainAction('aESelectAll');

  smECopy.Action := MainAction('aECopy');
  smECopyToFile.Action := MainAction('aECopyToFile');
  smESelectAll.Action := MainAction('aESelectAll');

  FNavigator.RowSelect := CheckWin32Version(6, 1);
  FSQLHistory.RowSelect := CheckWin32Version(6, 1);

  PList.Align := alClient;
  PSQLEditor.Align := alClient;
  PBuilder.Align := alClient;

  FList.RowSelect := CheckWin32Version(6);

  FSQLEditor.Highlighter := MainHighlighter;
  FBuilderEditor.Highlighter := MainHighlighter;
  FSQLEditorPrint.Highlighter := MainHighlighter;

  FText.Modified := False;
  GIFImage := TGIFImage.Create();
  PNGImage := TPNGImage.Create();
  JPEGImage := TJPEGImage.Create();

  UseNavigatorTimer := False;
  MovingToAddress := False;

  LastDataSource.ResultSet := nil;
  LastDataSource.DataSet := nil;
  LastFNavigatorSelected := '';
  LastSelectedDatabase := '';
  LastSelectedTable := '';
  LastTableView := avObjectBrowser;
  LastObjectIDEAddress := '';


  LastSelectedImageIndex := -1;
  OldFListOrderIndex := -1;
  IgnoreFGridTitleClick := False;
  SelectedItem := '';

  if (Assigned(AClient)) then
  begin
    AClient.RegisterEventProc(FormClientEvent);
    AClient.Account.RegisterDesktop(Self, FormAccountEvent);
  end;

  Wanted := TWanted.Create(Self);

  ToolBarData.Addresses := TStringList.Create();
  ToolBarData.AddressMRU := TMRUList.Create(0);
  ToolBarData.AddressMRU.Assign(Client.Account.Desktop.AddressMRU);
  FilterMRU := TMRUList.Create(100);
  ToolBarData.CurrentAddress := -1;

  SyntaxProvider.ServerVersionInt := Client.ServerVersion;
  if (Client.LowerCaseTableNames <> 0) then
    SyntaxProvider.IdentCaseSens := icsSensitiveLowerCase
  else
    SyntaxProvider.IdentCaseSens := icsNonSensitive;

  FormAccountEvent(Client.Account.Desktop.Bookmarks.ClassType);


  CloseButton := TPicture.Create();
  CloseButton.Bitmap.Height := 11;
  CloseButton.Bitmap.Width := CloseButton.Bitmap.Height + 1;
  DrawCloseBitmap(CloseButton.Bitmap);

  FOffset.Constraints.MaxWidth := FOffset.Width;

  Perform(CM_CHANGEPREFERENCES, 0, 0);

  NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
  if (SystemParametersInfo(SPI_GETNONCLIENTMETRICS, SizeOf(NonClientMetrics), @NonClientMetrics, 0)) then
    Window.ApplyWinAPIUpdates(Self, NonClientMetrics.lfStatusFont);


  PostMessage(Handle, CM_POSTSHOW, 0, 0);
end;

procedure TFClient.DataSetAfterCancel(DataSet: TDataSet);
begin
  DBGridColEnter(FGrid);
end;

procedure TFClient.DataSetAfterClose(DataSet: TDataSet);
begin
  PBlob.Visible := False; SBlob.Visible := PBlob.Visible;
  if (PResult.Align = alClient) then
  begin
    PResult.Align := alBottom;
    PResult.Height := PResultHeight;
    if (PBuilder.Visible) then PBuilder.Align := alClient;
    if (PSQLEditor.Visible) then PSQLEditor.Align := alClient;
  end;

  PResult.Visible := False; SResult.Visible := False;
  PBuilder.Update(); // TSynMemo aktualisiert leider nicht sofort nach �nderung von TSynMemo.Align
  PSQLEditor.Update(); // TSynMemo aktualisiert leider nicht sofort nach �nderung von TSynMemo.Align

  aDPrev.Enabled := False;
  aDNext.Enabled := False;

  MainAction('aFExportSQL').Enabled := False;
  MainAction('aFExportText').Enabled := False;
  MainAction('aFExportExcel').Enabled := False;
  MainAction('aFExportSQLite').Enabled := False;
  MainAction('aFExportXML').Enabled := False;
  MainAction('aFExportHTML').Enabled := False;
end;

procedure TFClient.DataSetAfterOpen(DataSet: TDataSet);
var
  ResultSet: TCResultSet;
begin
  if (DataSet is TMySQLDataSet) then
    ResultSet := TCResultSet(DataSet.Tag)
  else
    ResultSet := nil;

  if ((DataSet.FieldCount > 0)
    and ((View = avDataBrowser) and (DataSet is TCTableDataSet) and (TCTableDataSet(DataSet).DatabaseName = SelectedDatabase) and (TCTableDataSet(DataSet).CommandText = SelectedTable)
      or (View = avObjectIDE) and Assigned(ResultSet) and (ResultSet <> Client.QueryBuilderResult) and (ResultSet <> Client.SQLEditorResult)
      or (View = avQueryBuilder) and (ResultSet = Client.QueryBuilderResult)
      or (View = avSQLEditor) and (ResultSet = Client.SQLEditorResult))) then
  begin
    PContentChange(DataSet);
    PContentRefresh(DataSet);

    gmFilter.Clear();
  end;
end;

procedure TFClient.DataSetAfterPost(DataSet: TDataSet);
begin
  DataSetAfterScroll(DataSet);

  StatusBarRefresh();
end;

procedure TFClient.DataSetAfterScroll(DataSet: TDataSet);
begin
  if (not DataSet.ControlsDisabled) then
  begin
    if (((Window.ActiveControl = FGrid) or (Window.ActiveControl = FText) or (Window.ActiveControl = FRTF) or (Window.ActiveControl = FHexEditor)) and (TMySQLQuery(DataSet).FieldCount > 0)) then
      DBGridColEnter(FGrid);

    aDPrev.Enabled := not DataSet.Bof;
    aDNext.Enabled := not DataSet.Eof;
    MainAction('aDInsertRecord').Enabled := aDInsertRecord.Enabled and (DataSet.State in [dsBrowse, dsEdit]) and (DataSet.FieldCount > 0) and (FGrid.SelectedRows.Count < 1) and True;
    MainAction('aDDeleteRecord').Enabled := aDDeleteRecord.Enabled and (DataSet.State in [dsBrowse, dsEdit]) and not DataSet.IsEmpty();

    PostMessage(Handle, CM_POSTPOSTSCROLL, 0, 0);
  end;
end;

procedure TFClient.DataSetBeforeCancel(DataSet: TDataSet);
begin
  if (PBlob.Visible) then
  begin
    DBGridColEnter(FGrid);
    if (PResult.Visible and PGrid.Visible) then
      Window.ActiveControl := FGrid;
  end;
end;

procedure TFClient.DataSetBeforePost(DataSet: TDataSet);
begin
  if (PBlob.Visible and aVBlobText.Checked) then
    FTextExit(DataSetPost);
end;

procedure TFClient.DataSetBeforeReceivingRecords(DataSet: TDataSet);
begin
  PostMessage(Handle, CM_BEFORE_RECEIVING_DATASET, WParam(DataSet), 0);
end;

procedure TFClient.DBGridColEnter(Sender: TObject);
var
  DBGrid: TMySQLDBGrid;
begin
  if (Sender is TMySQLDBGrid) then
  begin
    DBGrid := TMySQLDBGrid(Sender);

    if ((((Window.ActiveControl = DBGrid) or (Window.ActiveControl = FText) or (Window.ActiveControl = FRTF) or (Window.ActiveControl = FHexEditor)) and Assigned(DBGrid.SelectedField)) or (Sender = DataSetCancel)) then
    begin
      FText.OnChange := nil;

      EditorField := nil;
      if (DBGrid.SelectedField.DataType in [ftWideMemo, ftBlob]) then
        EditorField := DBGrid.SelectedField;
      if (Assigned(EditorField) xor PBlob.Visible) then
      begin
        PostMessage(DBGrid.Handle, WM_SIZE, SIZE_MAXIMIZED, DBGrid.Height shl 16 + DBGrid.Width);
        PContentChange(DBGrid);
      end;

      if (Assigned(EditorField)) then
      begin
        if (EditorField.DataType = ftBlob) then
          FImageShow(Sender);

        aVBlobText.Visible := not GeometryField(EditorField) and ((EditorField.DataType = ftWideMemo) or not Assigned(FImage.Picture.Graphic));
        aVBlobRTF.Visible := aVBlobText.Visible and (EditorField.DataType = ftWideMemo) and not EditorField.IsNull and IsRTF(EditorField.AsString);
        aVBlobHTML.Visible := aVBlobText.Visible and (EditorField.DataType = ftWideMemo) and not EditorField.IsNull and IsHTML(EditorField.AsString);
        aVBlobImage.Visible := (EditorField.DataType = ftBlob) and Assigned(FImage.Picture.Graphic);
        ToolBarBlobResize(Sender);

        if (aVBlobText.Visible and aVBlobText.Checked) then
          aVBlobExecute(nil)
        else if (aVBlobRTF.Visible and aVBlobRTF.Checked) then
          aVBlobExecute(nil)
        else if (aVBlobHTML.Visible and aVBlobHTML.Checked) then
          aVBlobExecute(nil)
        else if (aVBlobImage.Visible and aVBlobImage.Checked) then
          aVBlobExecute(nil)
        else if (aVBlobHexEditor.Visible and aVBlobHexEditor.Checked) then
          aVBlobExecute(nil)
        else if (aVBlobText.Visible) then
          aVBlobText.Execute()
        else if (aVBlobRTF.Visible) then
          aVBlobRTF.Execute()
        else if (aVBlobHTML.Visible) then
          aVBlobHTML.Execute()
        else if (aVBlobImage.Visible) then
          aVBlobImage.Execute()
        else
          aVBlobHexEditor.Execute();
      end;

      if (not Assigned(DBGrid.SelectedField) or (DBGrid.SelectedField.DataType in [ftWideMemo, ftBlob]) or (DBGrid.SelectedField.DataType in [ftUnknown])) then
        DBGrid.Options := DBGrid.Options - [dgEditing]
      else
        DBGrid.Options := DBGrid.Options + [dgEditing];

      FText.OnChange := FTextChange;
    end;

    DBGrid.UpdateAction(MainAction('aEPaste'));
    MainAction('aECopyToFile').Enabled := (DBGrid.SelectedField.DataType in [ftWideMemo, ftBlob]) and (not DBGrid.SelectedField.IsNull) and (DBGrid.SelectedRows.Count <= 1);
    MainAction('aEPasteFromFile').Enabled := (DBGrid.SelectedField.DataType in [ftWideMemo, ftBlob]) and not DBGrid.SelectedField.ReadOnly and (DBGrid.SelectedRows.Count <= 1);
    MainAction('aDCreateField').Enabled := Assigned(DBGrid.SelectedField) and (View = avDataBrowser);
    MainAction('aDEditRecord').Enabled := Assigned(DBGrid.SelectedField);
    MainAction('aDEmpty').Enabled := Assigned(DBGrid.DataSource.DataSet) and DBGrid.DataSource.DataSet.CanModify and Assigned(DBGrid.SelectedField) and not DBGrid.SelectedField.IsNull and not DBGrid.SelectedField.Required and (DBGrid.SelectedRows.Count <= 1) and True;
  end;

  StatusBarRefresh();
end;

procedure TFClient.DBGridColExit(Sender: TObject);
var
  Trigger: TCTrigger;
begin
  MainAction('aECopyToFile').Enabled := False;
  MainAction('aEPasteFromFile').Enabled := False;
  MainAction('aDCreateField').Enabled := False;
  MainAction('aDEditRecord').Enabled := False;
  MainAction('aDEmpty').Enabled := False;

  if ((Sender = FObjectIDEGrid) and (SelectedImageIndex = iiTrigger) and (TMySQLDBGrid(Sender).DataSource.DataSet is TMySQLDataSet)) then
  begin
    Trigger := Client.DatabaseByName(SelectedDatabase).TriggerByName(SelectedNavigator);

    FObjectIDEGrid.DataSource.DataSet.CheckBrowseMode();

    BINSERT.Enabled := Trigger.SQLInsert() <> '';
    BREPLACE.Enabled := Trigger.SQLReplace() <> '';
    BUPDATE.Enabled := Trigger.SQLUpdate() <> '';
    BDELETE.Enabled := Trigger.SQLDelete() <> '';
  end;

  gmFilter.Clear();
end;

procedure TFClient.DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);

  function ColorAdd(const Color1, Color2: TColor): TColor;
  begin
    if (Color2 > 0) then
      Result :=
        Color1 and $ff0000 or Color2 and $ff0000
        + Color1 and $00ff00 or Color2 and $00ff00
        + Color1 and $0000ff or Color2 and $0000ff
    else
      Result :=
        Color1 and $ff0000 and not (-Color2 and $ff0000)
        + Color1 and $00ff00 and not (-Color2 and $00ff00)
        + Color1 and $0000ff and not (-Color2 and $0000ff);
  end;

var
  BGRect: TRect;
  DBGrid: TMySQLDBGrid;
  Text: string;
  TextRect: TRect;
begin
  if (Sender is TMySQLDBGrid) then
  begin
    DBGrid := TMySQLDBGrid(Sender);

    if (Column.Field.IsNull) then
      if (not Column.Field.Required and Preferences.GridNullText) then
        Text := '<NULL>'
      else
        Text := ''
    else if (GeometryField(Column.Field)) then
      Text := '<GEO>'
    else if (Column.Field.DataType = ftBlob) then
      Text := '<BLOB>'
    else if (Column.Field.DataType = ftWideMemo) then
      if (not Preferences.GridShowMemoContent) then
        Text := '<MEMO>'
      else
        Text := Copy(TMySQLQuery(Column.Field.DataSet).GetAsString(Column.Field.FieldNo), 1, 1000)
    else
      Text := TMySQLQuery(Column.Field.DataSet).GetAsString(Column.Field.FieldNo);

    TextRect := Rect;
    InflateRect(TextRect, -2, -2);
    if (Column.Alignment = taRightJustify) then
      TextRect.Left := Max(TextRect.Left, TextRect.Right - DBGrid.Canvas.Textwidth(Text));

    if (DBGrid.Focused and DBGrid.SelectedRows.CurrentRowSelected) then
    begin // Row is selected, Grid is focused
      DBGrid.Canvas.Font.Color := clHighlightText;
      DBGrid.Canvas.Brush.Color := clHighlight;
    end
    else if (not DBGrid.Focused and DBGrid.SelectedRows.CurrentRowSelected) then
    begin // Row is selected, Grid is NOT focused
      DBGrid.Canvas.Font.Color := clBtnText;
      DBGrid.Canvas.Brush.Color := clBtnFace;
    end
    else if (gdFocused in State) then
    begin // Cell is focused, Grid is focused
      DBGrid.Canvas.Font.Color := clHighlightText;
      DBGrid.Canvas.Brush.Color := clHighlight;

      DBGrid.Canvas.Pen.Style := psDot;
      DBGrid.Canvas.Pen.Mode := pmNotCopy;
      DBGrid.Canvas.Rectangle(Rect);

      BGRect := Rect; InflateRect(BGRect, -1, -1);
      DBGrid.Canvas.Pen.Style := psSolid;
      DBGrid.Canvas.Pen.Mode := pmCopy;
    end
    else if (not DBGrid.Focused and (Column.Field = DBGrid.SelectedField) and DBGrid.CurrentRow and not DBGrid.Focused) then
    begin // Cell is focused, Grid is NOT focused
      DBGrid.Canvas.Font.Color := clBtnText;
      DBGrid.Canvas.Brush.Color := clBtnFace;
    end
    else if ((DBGrid.Parent <> PObjectIDE) and Preferences.GridCurrRowBGColorEnabled and DBGrid.CurrentRow) then
    begin // Row is focused
      DBGrid.Canvas.Font.Color := clWindowText;
      DBGrid.Canvas.Brush.Color := ColorToRGB(Preferences.GridCurrRowBGColor);
    end
    else if ((DBGrid.Parent <> PObjectIDE) and Preferences.GridNullBGColorEnabled and Column.Field.IsNull and not Column.Field.Required) then
    begin // Cell is NULL
      DBGrid.Canvas.Font.Color := clGrayText;
      DBGrid.Canvas.Brush.Color := Preferences.GridNullBGColor;
    end
    else if (Column.Field.Tag and ftSortedField <> 0) then
    begin // Column is sorted
      DBGrid.Canvas.Font.Color := clWindowText;
      if (ColorToRGB(clWindow) >= $800000) then
        DBGrid.Canvas.Brush.Color := ColorAdd(ColorToRGB(clWindow), -$101010)
      else
        DBGrid.Canvas.Brush.Color := ColorAdd(ColorToRGB(clWindow), $101010);
    end
    else if ((DBGrid.Parent <> PObjectIDE) and Preferences.GridRowBGColorEnabled and (DBGrid.DataSource.DataSet.RecNo mod 2 <> 0) and not (dgRowSelect in DBGrid.Options)) then
    begin // Row is even
      DBGrid.Canvas.Font.Color := clWindowText;
      if (ColorToRGB(clWindow) >= $800000) then
        DBGrid.Canvas.Brush.Color := ColorAdd(ColorToRGB(clWindow), -$080808)
      else
        DBGrid.Canvas.Brush.Color := ColorAdd(ColorToRGB(clWindow), $080808);
    end
    else
    begin
      DBGrid.Canvas.Font.Color := clWindowText;
      DBGrid.Canvas.Brush.Color := clWindow;
    end;

    if (Column.Field.IsNull) then
      DBGrid.Canvas.Font.Color := clGrayText;
    DBGrid.Canvas.FillRect(Rect);
    DBGrid.Canvas.TextRect(TextRect, TextRect.Left, TextRect.Top, Text);
  end;
end;

procedure TFClient.DBGridEnter(Sender: TObject);
var
  DBGrid: TMySQLDBGrid;
  FieldInfo: TFieldInfo;
  Found: Boolean;
  I: Integer;
  SQL: string;
  Table: TCBaseTable;
begin
  if (Sender is TMySQLDBGrid) then
  begin
    if (View = avObjectIDE) then SQL := SQLTrimStmt(SynMemo.Text) else SQL := '';

    DBGrid := TMySQLDBGrid(Sender);

    Found := False;
    for I := 0 to DBGrid.DataSource.DataSet.FieldCount - 1 do
      Found := Found or GetFieldInfo(DBGrid.DataSource.DataSet.Fields[I].Origin, FieldInfo) and (FieldInfo.TableName <> '');
    MainAction('aFExportSQL').Enabled := Found;
    MainAction('aFExportText').Enabled := True;
    MainAction('aFExportExcel').Enabled := True;
    MainAction('aFExportXML').Enabled := True;
    MainAction('aFExportHTML').Enabled := True;
    MainAction('aFPrint').Enabled := True;
    MainAction('aECopyToFile').OnExecute := FGridCopyToExecute;
    MainAction('aEPasteFromFile').OnExecute := aEPasteFromFileExecute;
    MainAction('aSGoto').OnExecute := FGridGotoExecute;
    MainAction('aDEditRecord').OnExecute := FGridEditExecute;
    MainAction('aDEmpty').OnExecute := FGridEmptyExecute;

    MainAction('aVDetails').Enabled := True;

    MainAction('aERename').ShortCut := 0;

    MainAction('aDEditRecord').ShortCut := VK_F2;

    MainAction('aSGoto').Enabled := False;
    if (SelectedDatabase <> '') then
    begin
      Table := Client.DatabaseByName(SelectedDatabase).BaseTableByName(SelectedTable);
      if (Assigned(Table)) then
        for I := 0 to Table.Indices.Count - 1 do
          if (Table.Indices[I].Unique) then
            MainAction('aSGoto').Enabled := True;
    end;

    DataSetAfterScroll(DBGrid.DataSource.DataSet);
  end;
end;

procedure TFClient.DBGridExit(Sender: TObject);
var
  DBGrid: TMySQLDBGrid;
begin
  if (Sender is TMySQLDBGrid) then
  begin
    DBGrid := TMySQLDBGrid(Sender);

    DBGridColExit(Sender);
    DBGrid.Repaint();

    MainAction('aFExportSQL').Enabled := False;
    MainAction('aFExportText').Enabled := False;
    MainAction('aFExportExcel').Enabled := False;
    MainAction('aFExportXML').Enabled := False;
    MainAction('aFExportHTML').Enabled := False;
    MainAction('aFImportText').Enabled := False;
    MainAction('aFImportExcel').Enabled := False;
    MainAction('aFImportAccess').Enabled := False;
    MainAction('aFImportSQLite').Enabled := False;
    MainAction('aFImportODBC').Enabled := False;
    MainAction('aFImportXML').Enabled := False;
    MainAction('aFPrint').Enabled := False;
    MainAction('aECopyToFile').Enabled := False;
    MainAction('aEPasteFromFile').Enabled := False;
    MainAction('aSGoto').Enabled := False;
    MainAction('aVDetails').Enabled := False;
    MainAction('aDInsertRecord').Enabled := False;
    MainAction('aDDeleteRecord').Enabled := False;
    MainAction('aDEditRecord').Enabled := False;
    MainAction('aDPostObject').Enabled := False;
    MainAction('aDEmpty').Enabled := False;

    MainAction('aDEditRecord').ShortCut := 0;

    MainAction('aERename').ShortCut := VK_F2;

    WForeignKeySelect.ForeignKey := nil;
  end;
end;

procedure TFClient.DBGridMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  GridCoord: TGridCoord;
begin
  inherited;

  if (not (ssLeft in Shift) and FGrid.Dragging()) then
    FGrid.EndDrag(False);

  GridCoord := FGrid.MouseCoord(X, Y);

  if ((GridCoord.X < 0) or (GridCoord.Y < 0)) then
    FGrid.PopupMenu := MGrid
  else if (GridCoord.Y = 0) then
    FGrid.PopupMenu := MGridHeader
  else
    FGrid.PopupMenu := MGrid;
end;

destructor TFClient.Destroy();
var
  TempB: Boolean;
  URI: TUURI;
begin
  FNavigatorChanging(nil, nil, TempB);

  SetDataSource();

  if ((SQLEditor.Filename <> '') and not FSQLEditor.Modified) then
    Client.Account.Desktop.EditorContent := ''
  else
    Client.Account.Desktop.EditorContent := FSQLEditor.Text;
  Client.Account.Desktop.NavigatorVisible := PNavigator.Visible;
  Client.Account.Desktop.BookmarksVisible := PBookmarks.Visible;
  Client.Account.Desktop.SQLHistoryVisible := PSQLHistory.Visible;
  Client.Account.Desktop.SelectorWitdth := PSideBar.Width;
  Client.Account.Desktop.LogVisible := PLog.Visible;
  Client.Account.Desktop.LogHeight := PLog.Height;
  URI := TUURI.Create(Address);
  URI.Param['file'] := '';
  Client.Account.Desktop.Address := URI.Address;
  FreeAndNil(URI);
  if (ToolBarData.RefreshAll) then
    Client.Account.Desktop.ToolBarRefresh := 1
  else
    Client.Account.Desktop.ToolBarRefresh := 0;

  if (PResult.Align <> alBottom) then
    Client.Account.Desktop.DataHeight := PResultHeight
  else
    Client.Account.Desktop.DataHeight := PResult.Height;
  Client.Account.Desktop.BlobHeight := PBlob.Height;

  Client.Account.Desktop.AddressMRU.Assign(ToolBarData.AddressMRU);
  Client.Account.UnRegisterDesktop(Self);

  Client.UnRegisterEventProc(FormClientEvent);
  Clients.ReleaseClient(Client);

  FNavigator.Items.BeginUpdate();
  FNavigator.Items.Clear();
  FNavigator.Items.EndUpdate();

  FList.OnChanging := nil;
  FList.Items.BeginUpdate();
  FList.Items.Clear();
  FList.Items.EndUpdate();

  FreeAndNil(JPEGImage);
  FreeAndNil(PNGImage);
  FreeAndNil(GIFImage);

  FLog.Lines.Clear();

  Parent := nil;

  FreeAndNil(CloseButton);

  FreeAndNil(FilterMRU);
  FreeAndNil(ToolBarData.AddressMRU);
  FreeAndNil(ToolBarData.Addresses);
  FreeAndNil(Wanted);

  inherited;
end;

function TFClient.Dragging(const Sender: TObject): Boolean;
begin
  Result := LeftMousePressed and (Window.ActiveControl = FNavigator) and ((Window.ActiveControl as TTreeView_Ext).Selected <> MouseDownNode);
end;

procedure TFClient.EndEditLabel(Sender: TObject);
begin
  aDCreate.ShortCut := VK_INSERT;
  aDDelete.ShortCut := VK_DELETE;
end;

procedure TFClient.FBlobResize(Sender: TObject);
begin
  FText.Repaint();
end;

procedure TFClient.FBlobSearchChange(Sender: TObject);
begin
  if (FBlobSearch.Text <> '') then
  begin
    TSearchFind_Ext(MainAction('aSSearchFind')).Control := FText;
    TSearchFind_Ext(MainAction('aSSearchFind')).Dialog.FindText := FBlobSearch.Text;
    TSearchFind_Ext(MainAction('aSSearchFind')).FindFirst := Assigned(Sender);
    TSearchFind_Ext(MainAction('aSSearchFind')).Search(Sender);
  end;
end;

procedure TFClient.FBlobSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if (Ord(Key) = VK_ESCAPE) then
  begin
    FBlobSearch.Text := '';
    Key := #0;
  end
  else if ((Ord(Key) = VK_RETURN) and (FText.Text <> '')) then
  begin
    FBlobSearchChange(nil);
    Key := #0;
  end;
end;

procedure TFClient.FBookmarksChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  mbBOpen.Enabled := Assigned(Item) and Item.Selected;
  aPOpenInNewWindow.Enabled := Assigned(Item) and Item.Selected;
  aPOpenInNewTab.Enabled := Assigned(Item) and Item.Selected;
  MainAction('aBDelete').Enabled := Assigned(Item) and Item.Selected;
  MainAction('aBEdit').Enabled := Assigned(Item) and Item.Selected;

  mbBOpen.Default := mbBOpen.Enabled;
end;

procedure TFClient.FBookmarksDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  TargetItem: TListItem;
begin
  TargetItem := TListView(Sender).GetItemAt(X, Y);

  Client.Account.Desktop.Bookmarks.MoveBookmark(Client.Account.Desktop.Bookmarks.ByCaption(FBookmarks.Selected.Caption), FBookmarks.Items.IndexOf(TargetItem));
end;

procedure TFClient.FBookmarksDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  TargetItem: TListItem;
begin
  TargetItem := TListView(Sender).GetItemAt(X, Y);

  Accept := (Sender = Source) and (TargetItem <> FBookmarks.Selected);
end;

procedure TFClient.FBookmarksEnter(Sender: TObject);
begin
  mbBOpen.ShortCut := VK_RETURN;
  MainAction('aBDelete').ShortCut := VK_DELETE;
  MainAction('aBEdit').ShortCut := ShortCut(VK_RETURN, [ssAlt]);

  FBookmarksChange(Sender, FBookmarks.Selected, ctState);
end;

procedure TFClient.FBookmarksExit(Sender: TObject);
begin
  mbBOpen.ShortCut := 0;
  MainAction('aBDelete').ShortCut := 0;
  MainAction('aBEdit').ShortCut := 0;

  aPOpenInNewWindow.Enabled := False;
  aPOpenInNewTab.Enabled := False;
  MainAction('aBDelete').Enabled := False;
  MainAction('aBEdit').Enabled := False;
end;

function TFClient.FBuilderActiveSelectList(): TacQueryBuilderSelectListControl;
begin
  if (not Assigned(FBuilderEditorPageControl())) then
    Result := nil
  else
  begin
    Result := TacQueryBuilderSelectListControl(FindChildByClassType(FBuilderEditorPageControl().ActivePage, TacQueryBuilderSelectListControl));
    if (not Assigned(Result) and (FBuilderEditorPageControl().PageCount = 1)) then
      Result := TacQueryBuilderSelectListControl(FindChildByClassType(FBuilderEditorPageControl().Pages[0], TacQueryBuilderSelectListControl));
  end;
end;

function TFClient.FBuilderActiveWorkArea(): TacQueryBuilderWorkArea;
var
  PageControl: TPageControl;
begin
  if (not Assigned(FBuilderEditorPageControl())) then
    Result := nil
  else
  begin
    PageControl := FBuilderEditorPageControl();
    if (Assigned(PageControl.ActivePage)) then
      Result := TacQueryBuilderWorkArea(FindChildByClassType(PageControl.ActivePage, TacQueryBuilderWorkArea))
    else if (PageControl.PageCount = 1) then
      Result := TacQueryBuilderWorkArea(FindChildByClassType(PageControl.Pages[0], TacQueryBuilderWorkArea))
    else
      Result := nil;

    if (not Assigned(PageControl.OnChange)) then
    begin
      PageControl.OnChange := FBuilderEditorPageControlChange;
      FBuilderEditorPageControlChange(nil);
    end;
    FBuilderEditorPageControlCheckStyle();
  end;
end;

procedure TFClient.FBuilderAddTable(Sender: TObject);
var
  MenuItem: TMenuItem;
  SQLQualifiedName: TSQLQualifiedName;
  Table: TCTable;
begin
  if (Sender is TMenuItem) then
  begin
    MenuItem := TMenuItem(Sender);

    if ((MenuItem.GetParentMenu() is TPopupMenu) and (TObject(MenuItem.Tag) is TCTable)) then
    begin
      Table := TCTable(TMenuItem(Sender).Tag);

      SQLQualifiedName := TSQLQualifiedName.Create(FBuilder.MetadataContainer.SQLContext);

      SQLQualifiedName.AddName(Table.Name);
      FBuilder.ActiveSubQuery.ActiveUnionSubquery.AddObjectAt(SQLQualifiedName, FBuilderActiveWorkArea().ScreenToClient(TPopupMenu(MenuItem.GetParentMenu()).PopupPoint));

      SQLQualifiedName.Free();
    end;
  end;
end;

procedure TFClient.FBuilderDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  Database: TCDatabase;
  Node: TTreeNode;
  SQLQualifiedName: TSQLQualifiedName;
begin
  if (Source = FNavigator) then
  begin
    Node := MouseDownNode;

    Database := Client.DatabaseByName(Node.Parent.Text);

    SQLQualifiedName := TSQLQualifiedName.Create(FBuilder.MetadataContainer.SQLContext);
    if (Database <> Client.DatabaseByName(SelectedDatabase)) then
      SQLQualifiedName.AddPrefix(Database.Name);

    SQLQualifiedName.AddName(Database.TableByName(Node.Text).Name);
    FBuilder.ActiveSubQuery.ActiveUnionSubquery.AddObjectAt(SQLQualifiedName, Point(X, Y));

    SQLQualifiedName.Free();
  end;
end;

procedure TFClient.FBuilderDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  SourceNode: TTreeNode;
begin
  Accept := False;

  if (Source = FNavigator) then
  begin
    SourceNode := MouseDownNode;

    Accept := SourceNode.ImageIndex in [iiBaseTable, iiSystemView, iiView];
  end
end;

procedure TFClient.FBuilderEditorChange(Sender: TObject);
begin
  FBuilder.Enabled := True;
  try
    FBuilder.SQL := FBuilderEditor.Lines.Text;
    PostMessage(Handle, CM_POST_BUILDER_QUERY_CHANGE, 0, 0);

    FBuilderEditorPageControlCheckStyle();

    FBuilder.Visible := True;
  except
    FBuilder.Visible := False;
  end;

  FBuilderEditorStatusChange(Sender, [scModified]);
end;

procedure TFClient.FBuilderEditorEnter(Sender: TObject);
begin
  SQLBuilder.OnSQLUpdated := nil;

  FSQLEditorEnter(Sender);
end;

procedure TFClient.FBuilderEditorExit(Sender: TObject);
begin
  FSQLEditorExit(Sender);

  SQLBuilder.OnSQLUpdated := SQLBuilderSQLUpdated;
end;

function TFClient.FBuilderEditorPageControl(): TacPageControl;
begin
  Result := TacQueryBuilderPageControl(FindChildByClassType(FBuilder, TacQueryBuilderPageControl));
end;

procedure TFClient.FBuilderEditorPageControlChange(Sender: TObject);
begin
  if (not Assigned(FBuilderEditorPageControl().ActivePage.OnEnter)) then
    FBuilderEditorPageControl().ActivePage.OnEnter := FBuilderEditorTabSheetEnter;
end;

procedure TFClient.FBuilderEditorPageControlCheckStyle();
begin
  if (PBuilder.Visible and Assigned(FBuilderEditorPageControl())) then
  begin
    if ((FBuilder.SubQueries.Count = 1) and FBuilderEditorPageControl().Pages[0].TabVisible) then
    begin
      FBuilderEditorPageControl().Style := tsFlatButtons;
      FBuilderEditorPageControl().Pages[0].TabVisible := False;
      FBuilderEditorPageControl().Pages[0].Visible := True;
    end
    else if ((FBuilder.SubQueries.Count > 1) and not FBuilderEditorPageControl().Pages[0].TabVisible) then
    begin
      FBuilderEditorPageControl().Style := tsTabs;
      FBuilderEditorPageControl().Pages[0].TabVisible := True;
    end;
  end;
end;

procedure TFClient.FBuilderEditorStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
var
  BevelWidth: Integer;
  LineCount: Integer;
  NewHeight: Integer;
  ScrollBarInfo: TScrollBarInfo;
begin
  BevelWidth := 0;
  if (PBuilderQuery.BevelInner in [bvLowered, bvRaised]) then
    Inc(BevelWidth, PBuilderQuery.BevelWidth);
  if (PBuilderQuery.BevelOuter in [bvLowered, bvRaised]) then
    Inc(BevelWidth, PBuilderQuery.BevelWidth);

  ZeroMemory(@ScrollBarInfo, SizeOf(ScrollBarInfo));
  ScrollBarInfo.cbSize := SizeOf(ScrollBarInfo);
  GetScrollBarInfo(FBuilderEditor.Handle, Integer(OBJID_HSCROLL), ScrollBarInfo);

  LineCount := FBuilderEditor.Lines.Count;
  if (LineCount = 0) then
    LineCount := 1;

  if (ScrollBarInfo.rgstate[0] = STATE_SYSTEM_INVISIBLE) then
    NewHeight := LineCount * (FBuilderEditor.Canvas.TextHeight('SELECT') + 1) + 2 * FBuilderEditor.Top + 2 * BevelWidth
  else
    NewHeight := LineCount * (FBuilderEditor.Canvas.TextHeight('SELECT') + 1) + 2 * FBuilderEditor.Top + 2 * BevelWidth + GetSystemMetrics(SM_CYHSCROLL);
  PBuilderQuery.Constraints.MaxHeight := NewHeight;

  if (NewHeight > (PBuilder.Height + PBuilderQuery.Height) div 3) then
    NewHeight := (PBuilder.Height + PBuilderQuery.Height) div 3;

  if ((Sender = FBuilder) or (NewHeight < PBuilderQuery.Height) or (scModified in Changes)) then
    PBuilderQuery.Height := NewHeight;

  FSQLEditorStatusChange(FBuilderEditor, Changes);
end;

procedure TFClient.FBuilderEditorTabSheetEnter(Sender: TObject);
begin
  StatusBarRefresh();
end;

procedure TFClient.FBuilderEnter(Sender: TObject);
begin
  FBuilderEditor.OnChange := nil;

  StatusBarRefresh();
end;

procedure TFClient.FBuilderExit(Sender: TObject);
begin
  FBuilderEditor.OnChange := FBuilderEditorChange;
end;

procedure TFClient.FBuilderResize(Sender: TObject);
var
  FBuilderEditorSelectList: TacQueryBuilderSelectListControl;
  I: Integer;
  PSQLEditorBuilderSelectList: TacPanel;
  ScrollBarInfo: TScrollBarInfo;
begin
  if (Assigned(FBuilderEditorPageControl())) then
    for I := 0 to FBuilderEditorPageControl().PageCount - 1 do
    begin
      FBuilderEditorSelectList := TacQueryBuilderSelectListControl(FindChildByClassType(FBuilderEditorPageControl().Pages[I], TacQueryBuilderSelectListControl));
      if (Assigned(FBuilderEditorSelectList) and (FBuilderEditorSelectList.Parent is TacPanel)) then
        PSQLEditorBuilderSelectList := TacPanel(FBuilderEditorSelectList.Parent)
      else
        PSQLEditorBuilderSelectList := nil;
      if (Assigned(PSQLEditorBuilderSelectList)) then
      begin
        ZeroMemory(@ScrollBarInfo, SizeOf(ScrollBarInfo));
        ScrollBarInfo.cbSize := SizeOf(ScrollBarInfo);
        GetScrollBarInfo(FBuilderEditorSelectList.Handle, Integer(OBJID_HSCROLL), ScrollBarInfo);

        if (ScrollBarInfo.rgstate[0] = STATE_SYSTEM_INVISIBLE) then
          PSQLEditorBuilderSelectList.Height := (FBuilderEditorSelectList.DefaultRowHeight + 2) + FBuilderEditorSelectList.SelectList.Count * (FBuilderEditorSelectList.DefaultRowHeight + 1) + 3
        else
          PSQLEditorBuilderSelectList.Height := (FBuilderEditorSelectList.DefaultRowHeight + 2) + FBuilderEditorSelectList.SelectList.Count * (FBuilderEditorSelectList.DefaultRowHeight + 1) + 3 + GetSystemMetrics(SM_CYHSCROLL);

        if (PSQLEditorBuilderSelectList.Height > FBuilder.Height div 2) then
          PSQLEditorBuilderSelectList.Height := FBuilder.Height div 2;
      end;
    end;
end;

procedure TFClient.FBuilderValidatePopupMenu(Sender: TacQueryBuilder;
  AControlOwner: TacQueryBuilderControlOwner; AForControl: TControl;
  APopupMenu: TPopupMenu);
var
  I: Integer;
  J: Integer;
  MenuItem: TMenuItem;
begin
  if (AForControl.ClassType = TacQueryBuilderWorkArea) then
  begin
    for I := 0 to APopupMenu.Items.Count - 1 do
      if (APopupMenu.Items[I].Caption = QueryBuilderLocalizer.ReadWideString('acAddObject', acAddObject)) then
      begin
        APopupMenu.Items[I].Caption := Preferences.LoadStr(383);
        APopupMenu.Items[I].OnClick := nil;

        for J := 0 to Client.DatabaseByName(SelectedDatabase).Tables.Count - 1 do
        begin
          MenuItem := TMenuItem.Create(Self);
          MenuItem.Caption := Client.DatabaseByName(SelectedDatabase).Tables[J].Name;
          MenuItem.OnClick := FBuilderAddTable;
          MenuItem.Tag := Integer(Client.DatabaseByName(SelectedDatabase).Tables[J]);
          APopupMenu.Items[I].Add(MenuItem);
        end;
      end;
  end;
end;

procedure TFClient.FFilesEnter(Sender: TObject);
begin
  miHOpen.ShortCut := VK_RETURN;
end;

procedure TFClient.FFilterChange(Sender: TObject);
begin
  FFilter.Text := FFilter.Text;

  FFilterEnabled.Enabled := SQLSingleStmt(FFilter.Text);
  FFilterEnabled.Down := FFilterEnabled.Enabled and Assigned(FGrid.DataSource.DataSet) and (FFilter.Text = TMySQLTable(FGrid.DataSource.DataSet).FilterSQL);
end;

procedure TFClient.FFilterDropDown(Sender: TObject);
var
  I: Integer;
begin
  FFilter.Items.Clear();
  for I := FilterMRU.Count - 1 downto 0 do
    FFilter.Items.Add(FilterMRU.Values[I]);
end;

procedure TFClient.FFilterEnabledClick(Sender: TObject);
begin
  FQuickSearchEnabled.Down := False;
  TableOpen(Sender);
  AddressChange(Sender);
  Window.ActiveControl := FFilter;
end;

procedure TFClient.FFilterEnter(Sender: TObject);
begin
  if (FFilter.Items.Count = 0) then
    FFilterDropDown(Sender);
end;

procedure TFClient.FFilterKeyPress(Sender: TObject; var Key: Char);
begin
  if ((Key = Chr(VK_ESCAPE)) and (TMySQLTable(FGrid.DataSource.DataSet).FilterSQL <> '')) then
  begin
    FFilter.Text := TMySQLTable(FGrid.DataSource.DataSet).FilterSQL;
    FFilterChange(Sender);

    FFilter.SelStart := 0;
    FFilter.SelLength := Length(FFilter.Text);
    Key := #0;
  end
  else if ((Key = Chr(VK_RETURN)) and not FFilterEnabled.Down) then
  begin
    FFilterEnabled.Down := True;
    FFilterEnabledClick(Sender);

    FFilter.SelStart := 0;
    FFilter.SelLength := Length(FFilter.Text);
    Key := #0;
  end;
end;

procedure TFClient.FGridCellClick(Column: TColumn);
begin
  StatusBarRefresh();
end;

procedure TFClient.FGridColumnMoved(Sender: TObject; FromIndex: Integer;
  ToIndex: Integer);
begin
  IgnoreFGridTitleClick := IgnoreFGridTitleClick or (FromIndex <> ToIndex);
end;

procedure TFClient.FGridCopyToExecute(Sender: TObject);
const
  ChunkSize = 32768;
var
  BytesRead: DWord;
  BytesToWrite: DWord;
  BytesWritten: DWord;
  CodePage: Cardinal;
  FileBuffer: array[0 .. (ChunkSize - 1) * 3] of AnsiChar;
  Handle: THandle;
  Stream: TStream;
  StreamBuffer: array[0 .. ChunkSize - 1] of Byte;
  Success: Boolean;
begin
  SaveDialog.Title := ReplaceStr(Preferences.LoadStr(582), '&', '');
  SaveDialog.InitialDir := Preferences.Path;
  if (FGrid.SelectedField.DataType = ftWideMemo) then
  begin
    SaveDialog.FileName := FGrid.SelectedField.DisplayName + '.txt';
    SaveDialog.DefaultExt := 'txt';
    SaveDialog.Filter := FilterDescription('txt') + ' (*.txt)|*.txt' + '|' + FilterDescription('*') + ' (*.*)|*.*';
    SaveDialog.Encodings.Text := EncodingCaptions();
    SaveDialog.EncodingIndex := SaveDialog.Encodings.IndexOf(CodePageToEncoding(Client.CodePage));
  end
  else if (FGrid.SelectedField.DataType in [ftWideMemo, ftBlob]) then
  begin
    SaveDialog.FileName := FGrid.SelectedField.DisplayName;
    SaveDialog.DefaultExt := '';
    SaveDialog.Filter := FilterDescription('*') + ' (*.*)|*.*';
    SaveDialog.Encodings.Clear();
    SaveDialog.EncodingIndex := -1;
  end
  else
    Exit;

  if (SaveDialog.Execute()) then
  begin
    Preferences.Path := ExtractFilePath(SaveDialog.FileName);

    Handle := CreateFile(PChar(SaveDialog.FileName),
                         GENERIC_WRITE,
                         FILE_SHARE_READ,
                         nil,
                         CREATE_ALWAYS, 0, 0);
    if (Handle = INVALID_HANDLE_VALUE) then
      MsgBox(SysErrorMessage(GetLastError()), Preferences.LoadStr(45), MB_OK + MB_ICONERROR)
    else
    begin
      if (FGrid.SelectedField.DataType in BinaryDataTypes) then
        CodePage := 0
      else
        CodePage := EncodingToCodePage(SaveDialog.Encodings[SaveDialog.EncodingIndex]);

      Stream := FGrid.SelectedField.DataSet.CreateBlobStream(FGrid.SelectedField, bmRead);

      if (FGrid.SelectedField.DataType = ftWideMemo) then
        case (CodePage) of
          CP_UNICODE: WriteFile(Handle, BOM_UNICODE^, Length(BOM_UNICODE), BytesWritten, nil);
          CP_UTF8: WriteFile(Handle, BOM_UTF8^, Length(BOM_UTF8), BytesWritten, nil);
        end;

      repeat
        BytesRead := Stream.Read(StreamBuffer, SizeOf(StreamBuffer));
        if (BytesRead = 0) then
        begin
          BytesToWrite := 0;
          BytesWritten := 0;
          Success := True;
        end
        else if ((FGrid.SelectedField.DataType = ftBlob) or (CodePage = CP_UNICODE)) then
        begin
          BytesToWrite := BytesRead;
          Success := WriteFile(Handle, StreamBuffer, BytesToWrite, BytesWritten, nil);
        end
        else
        begin
          BytesToWrite := WideCharToMultiByte(CodePage, 0, PWideChar(@StreamBuffer), BytesRead div SizeOf(WideChar), nil, 0, nil, nil);
          if (BytesToWrite < 1) or (SizeOf(FileBuffer) < BytesToWrite) then
            raise ERangeError.Create(SRangeError);
          WideCharToMultiByte(CodePage, 0, PWideChar(@StreamBuffer), BytesRead div SizeOf(WideChar), @FileBuffer, SizeOf(FileBuffer), nil, nil);
          Success := WriteFile(Handle, FileBuffer, BytesToWrite, BytesWritten, nil);
        end;
      until ((BytesToWrite = 0) or (BytesWritten <> BytesToWrite));

      Stream.Free();

      if (not Success) then
        MsgBox(SysErrorMessage(GetLastError), Preferences.LoadStr(45), MB_OK + MB_ICONERROR);

      CloseHandle(Handle);
    end;
  end;
end;

procedure TFClient.FGridDataSourceDataChange(Sender: TObject; Field: TField);
begin
  if ((Window.ActiveControl = FGrid) and (Field = FGrid.SelectedField) and (FGrid.SelectedField.DataType in [ftWideMemo, ftBlob])) then
    aVBlobExecute(nil);
end;

procedure TFClient.FGridDblClick(Sender: TObject);
begin
  Wanted.Clear();

  if (not (FGrid.SelectedField.DataType in [ftWideMemo, ftBlob])) then
    FGrid.EditorMode := True
  else if (aVBlobText.Visible) then
  begin
    aVBlobText.Checked := True;
    aVBlobExecute(nil);
    FText.SelStart := FText.SelStart + FText.SelLength;
    SendMessage(FText.Handle, WM_VSCROLL, SB_BOTTOM, 0);
    Window.ActiveControl := FText;
  end
  else
  begin
    aVBlobHexEditor.Checked := True;
    aVBlobExecute(nil);
    FHexEditor.SelStart := FHexEditor.DataSize - 1;
    SendMessage(FHexEditor.Handle, WM_VSCROLL, SB_BOTTOM, 0);
    Window.ActiveControl := FHexEditor;
  end;
end;

procedure TFClient.FGridEditButtonClick(Sender: TObject);
var
  Database: TCDatabase;
  Field: TCTableField;
  FieldInfo: TFieldInfo;
  ForeignKey: TCForeignKey;
  Grid: TMySQLDBGrid;
  I: Integer;
  J: Integer;
  Table: TCBaseTable;
begin
  Wanted.Clear();

  if (Sender is TMySQLDBGrid) then
  begin
    Grid := TMySQLDBGrid(Sender);
    if (GetFieldInfo(Grid.SelectedField.Origin, FieldInfo)) then
    begin
      Database := Client.DatabaseByName(FieldInfo.DatabaseName);
      if (Assigned(Database)) then
      begin
        Table := Database.BaseTableByName(FieldInfo.TableName);
        if (Assigned(Table)) then
        begin
          Field := Table.FieldByName(FieldInfo.OriginalFieldName);
          if (Assigned(Field)) then
          begin
            ForeignKey := nil;
            for I := 0 to Table.ForeignKeys.Count - 1 do
              for J := 0 to Length(Table.ForeignKeys[I].Fields) - 1 do
                if (Table.ForeignKeys[I].Fields[J] = Field) then
                  ForeignKey := Table.ForeignKeys[I];

            if (Assigned(ForeignKey)) then
            begin
              if (Length(ForeignKey.Fields) <> Length(ForeignKey.Parent.FieldNames)) then
                ForeignKey := nil; // Foreign Key is broken

              I := 0;
              while (Assigned(ForeignKey) and (I < Length(ForeignKey.Fields))) do
                Inc(I);

              if (Assigned(ForeignKey)) then
              begin
                WForeignKeySelect.ChildGrid := Grid;
                WForeignKeySelect.ForeignKey := ForeignKey;
                WForeignKeySelect.Show();
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TFClient.FGridEditExecute(Sender: TObject);
begin
  Wanted.Clear();

  FGridDblClick(Sender);
end;

procedure TFClient.FGridEmptyClick(Sender: TObject);
begin
  Wanted.Clear();

  FGrid.DataSource.DataSet.Edit();
  FGrid.SelectedField.Clear();

  DBGridColEnter(FGrid);
end;

procedure TFClient.FGridEmptyExecute(Sender: TObject);
begin
  Wanted.Clear();

  FText.Lines.Clear();
  FHexEditor.DataSize := 0;
  if (Assigned(FImage.Picture.Graphic)) then
    FImage.Picture.Graphic := nil;

  if (not FGrid.SelectedField.IsNull) then
  begin
    FGrid.DataSource.DataSet.Edit();
    if (FGrid.EditorMode) then
      FGrid.InplaceEditor.Text := '';
    FGrid.SelectedField.Clear();
  end;
  DBGridColEnter(FGrid);
end;

procedure TFClient.FGridGotoExecute(Sender: TObject);
var
  Database: TCDatabase;
  I: Integer;
  Index: TCIndex;
  Line: Integer;
  Table: TCBaseTable;
begin
  Wanted.Clear();

  Database := Client.DatabaseByName(SelectedDatabase);
  Table := Database.BaseTableByName(SelectedTable);
  Index := nil;
  if (Assigned(Table) and (FGrid.DataSource.DataSet = Table.DataSet) and (Table.Indices.Count >= 0)) then
    Index := Table.Indices[0];

  if (Assigned(Index) and Index.Unique) then
  begin
    DGoto.Captions := '';
    for I := 0 to Index.Columns.Count - 1 do
    begin
      if (DGoto.Captions <> '') then DGoto.Captions := DGoto.Captions + ';';
      DGoto.Captions := DGoto.Captions + Index.Columns.Column[I].Field.Name;
    end;
    if (DGoto.Execute()) then
      if (not FGrid.DataSource.DataSet.Locate(DGoto.Captions, DGoto.Values, [loCaseInsensitive])) then
        MsgBox(Preferences.LoadStr(677), Preferences.LoadStr(43), MB_OK + MB_ICONINFORMATION)
      else
        for I := FGrid.Columns.Count - 1 downto 0 do
          if (FGrid.Columns[I].Field.FieldName = Index.Columns.Column[0].Field.Name) then
            FGrid.SelectedField := FGrid.Columns[I].Field;
  end
  else
  begin
    DGoto.Captions := Preferences.LoadStr(678);
    if (DGoto.Execute()) then
      if (not TryStrToInt(DGoto.Values[0], Line)) then
        MessageBeep(MB_ICONERROR)
      else if (not (Line in [1 .. FGrid.DataSource.DataSet.RecordCount])) then
        MessageBeep(MB_ICONERROR)
      else
        FGrid.DataSource.DataSet.RecNo := Line - 1;
  end;
end;

procedure TFClient.FGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_APPS) then
    FGrid.PopupMenu := MGrid
  else if ((Key = VK_INSERT) and (Shift = []) and not FGrid.EditorMode) then
    MainAction('aDInsertRecord').Execute()
  else if ((Key = VK_DELETE) and (Shift = []) and not FGrid.EditorMode) then
    MainAction('aDDeleteRecord').Execute()
  else if (FGrid.SelectedField.DataType in [ftWideMemo, ftBlob]) then
    if ((Key = VK_RETURN) and not aVBlobText.Visible) then
    begin
      aVBlobHexEditor.Checked := True;
      SendMessage(FText.Handle, WM_VSCROLL, SB_BOTTOM, 0);
    end
    else if (not (Key in [VK_F2, VK_TAB, VK_DOWN, VK_UP, VK_LEFT, VK_RIGHT, VK_HOME, VK_END, VK_PRIOR, VK_NEXT, VK_APPS, VK_SHIFT, VK_CONTROL, VK_MENU])) then
    begin
      aVBlobText.Checked := True;
      if (Key = VK_RETURN) then
      begin
        SendMessage(FText.Handle, WM_VSCROLL, SB_BOTTOM, 0);
        PostMessage(Handle, CM_ACTIVATEFTEXT, 0, 0);
      end
      else if (Key = VK_DELETE) then
        SendMessage(FText.Handle, WM_CLEAR, 0, 0)
      else
        PostMessage(Handle, CM_ACTIVATEFTEXT, Key, 0);

      Key := 0;
    end;
end;

procedure TFClient.FGridRefresh(Sender: TObject);
var
  Database: TCDatabase;
  DataSet: TMySQLDataSet;
  Field: TCTableField;
  FieldInfo: TFieldInfo;
  I: Integer;
  J: Integer;
  MenuItem: TMenuItem;
  SortMenuItem: TMenuItem;
  TabIndex: Integer;
  Table: TCTable;
begin
  if (FGrid.DataSource.DataSet is TMySQLDataSet) then
    DataSet := TMySQLDataSet(FGrid.DataSource.DataSet)
  else
    DataSet := nil;

  if (Assigned(DataSet)) then
  begin
    if (DataSet.FieldCount > 0) then
    begin
      MGridHeader.Items.Clear();

      for I := 0 to FGrid.Columns.Count - 1 do
        if (Assigned(FGrid.Columns[I].Field)) then
        begin
          MenuItem := TMenuItem.Create(Self);
          MenuItem.Caption := FGrid.Columns[I].Field.DisplayLabel;
          MenuItem.OnClick := MGridTitleMenuVisibleClick;
          MGridHeader.Items.Add(MenuItem);
        end;

      MenuItem := TMenuItem.Create(Self);
      MenuItem.Caption := '-';
      MenuItem.Tag := -1;
      MGridHeader.Items.Add(MenuItem);

      MenuItem := TMenuItem.Create(Self);
      MenuItem.Action := MainAction('aVDetails');
      MenuItem.Tag := -1;
      MGridHeader.Items.Add(MenuItem);

      if ((View = avDataBrowser) and (SelectedImageIndex in [iiBaseTable, iiSystemView])) then
      begin
        Database := Client.DatabaseByName(SelectedDatabase);
        Table := Database.BaseTableByName(SelectedTable);

        if (TCBaseTable(Table).Indices.Count > 0) then
        begin
          MenuItem := TMenuItem.Create(Self);
          MenuItem.Caption := '-';
          MenuItem.Tag := -1;
          MGridHeader.Items.Add(MenuItem);

          SortMenuItem := TMenuItem.Create(Self);
          SortMenuItem.Caption := Preferences.LoadStr(672);
          MenuItem.Tag := -1;
          MGridHeader.Items.Add(SortMenuItem);

          for I := 0 to TCBaseTable(Table).Indices.Count - 1 do
          begin
            MenuItem := TMenuItem.Create(Self);
            MenuItem.Caption := TCBaseTable(Table).Indices[I].Caption;
            MenuItem.Tag := I;
            MenuItem.RadioItem := True;
            MenuItem.OnClick := MGridHeaderMenuOrderClick;
            SortMenuItem.Add(MenuItem);
          end;
        end;
      end;

      FGrid.DisableAlign();
      FGrid.DataSource.DataSet.DisableControls();

      for I := 0 to FGrid.Columns.Count - 1 do
      begin
        if (View <> avDataBrowser) then
          Database := nil
        else
          Database := Client.DatabaseByName(SelectedDatabase);
        if (not Assigned(Database)) then
          Table := nil
        else
          Table := Database.TableByName(SelectedTable); // Must be first f�r Views where FieldInfo.TableName the name of the BaseTable
        if (not Assigned(Table) or not Assigned(FGrid.Fields[I])) then
          Field := nil
        else if ((DataSet is TMySQLQuery) and GetFieldInfo(FGrid.Fields[I].Origin, FieldInfo) and (FieldInfo.OriginalFieldName <> '')) then
          Field := Table.FieldByName(FieldInfo.OriginalFieldName)
        else
          Field := Table.FieldByName(FGrid.Fields[I].DisplayName);

        if ((DataSet is TMySQLTable) and Assigned(Field)) then
        begin
          if (I < Table.Desktop.Columns) then
            for J := 0 to FGrid.FieldCount - 1 do
              if (FGrid.Fields[J].FieldNo - 1 = Table.Desktop.ColumnIndices[I]) then
                FGrid.Fields[J].Index := I;

          if (GetFieldInfo(FGrid.Columns[I].Field.Origin, FieldInfo) and Assigned(Table.FieldByName(FieldInfo.OriginalFieldName))) then
          begin
            FGrid.Columns[I].Visible := Table.Desktop.GridVisible[FieldInfo.OriginalFieldName];
            if (Table.Desktop.GridWidths[FieldInfo.OriginalFieldName] > 0) then
              FGrid.Columns[I].Width := Table.Desktop.GridWidths[FieldInfo.OriginalFieldName];
          end;
        end
        else if (Assigned(LastDataSource.ResultSet)) then
        begin
          TabIndex := TCResult.TabIndex;
          if ((TabIndex >= 0) and (Length(LastDataSource.ResultSet.Columns) > TabIndex) and (Length(LastDataSource.ResultSet.Columns[TabIndex].Width) = FGrid.Columns.Count)) then
          begin
            for J := 0 to FGrid.FieldCount - 1 do
              if (Assigned(FGrid.Fields[J]) and (FGrid.Fields[J].FieldNo - 1 = LastDataSource.ResultSet.Columns[TabIndex].Index[I])) then
                FGrid.Fields[J].Index := I;
            if (Length(LastDataSource.ResultSet.Columns[TabIndex].Visible) = FGrid.Columns.Count) then
            begin
              FGrid.Columns[I].Visible := LastDataSource.ResultSet.Columns[TabIndex].Visible[I];
              FGrid.Columns[I].Width := LastDataSource.ResultSet.Columns[TabIndex].Width[I];
            end;
          end;
        end;

        if (FGrid.Columns[I].Visible) then
          if (FGrid.Columns[I].Width < 10) then
            FGrid.Columns[I].Width := 10
          else if (FGrid.Columns[I].Width > Preferences.GridMaxColumnWidth) then
            FGrid.Columns[I].Width := Preferences.GridMaxColumnWidth;


        if (FGrid.Columns[I].Field.IsIndexField) then
          FGrid.Columns[I].Font.Style := FGrid.Columns[I].Font.Style + [fsBold]
        else
          FGrid.Columns[I].Font.Style := FGrid.Columns[I].Font.Style - [fsBold];

        if (Assigned(FGrid.Columns[I].Field)) then
          FGrid.Columns[I].Field.OnSetText := FieldSetText;
      end;

      FGrid.DataSource.DataSet.EnableControls();
      FGrid.EnableAlign();

      if (DataSet.Active) then
      begin
        FGrid.Show();

        if (Assigned(DataSet.AfterScroll)) then
          DataSet.AfterScroll(DataSet);
      end;
    end;

    SResult.Visible := PResult.Visible and (PBuilder.Visible or PSQLEditor.Visible);
  end;
end;

procedure TFClient.FGridTitleClick(Column: TColumn);
var
  FieldName: string;
  OldDescending: Boolean;
  Pos: Integer;
  SortDef: TIndexDef;
begin
  if (not IgnoreFGridTitleClick
    and not (FGrid.Fields[Column.Index].DataType in [ftUnknown, ftWideMemo, ftBlob])) then
  begin
    SortDef := TIndexDef.Create(nil, 'SortDef', '', []);

    OldDescending := True;

    Pos := 1;
    repeat
      FieldName := ExtractFieldName(TMySQLDataSet(FGrid.DataSource.DataSet).SortDef.Fields, Pos);
      if (FieldName <> '') then
        if (FieldName <> FGrid.Fields[Column.Index].FieldName) then
        begin
          if (SortDef.Fields <> '') then SortDef.Fields := SortDef.Fields + ';';
          SortDef.Fields := SortDef.Fields + FieldName;
        end
        else
          OldDescending := False;
    until (FieldName = '');

    Pos := 1;
    repeat
      FieldName := ExtractFieldName(TMySQLDataSet(FGrid.DataSource.DataSet).SortDef.DescFields, Pos);
      if (FieldName <> '') then
        if (FieldName <> FGrid.Fields[Column.Index].FieldName) then
        begin
          if (SortDef.DescFields <> '') then SortDef.DescFields := SortDef.DescFields + ';';
          SortDef.DescFields := SortDef.DescFields + FieldName;
        end
        else
          OldDescending := True;
    until (FieldName = '');

    if (ssShift in FGrid.MouseDownShiftState) then
    begin
      if (SortDef.Fields <> '') then SortDef.Fields := ';' + SortDef.Fields;
      SortDef.Fields := FGrid.Fields[Column.Index].FieldName + SortDef.Fields;
      if (not OldDescending) then
      begin
        if (SortDef.DescFields <> '') then SortDef.DescFields := ';' + SortDef.DescFields;
        SortDef.DescFields := FGrid.Fields[Column.Index].FieldName + SortDef.DescFields;
      end;
    end
    else if (ssCtrl in FGrid.MouseDownShiftState) then
    begin
      if (SortDef.Fields <> '') then SortDef.Fields := SortDef.Fields + ';';
      SortDef.Fields := SortDef.Fields + FGrid.Fields[Column.Index].FieldName;
      if (not OldDescending) then
      begin
        if (SortDef.DescFields <> '') then SortDef.DescFields := SortDef.DescFields + ';';
        SortDef.DescFields := SortDef.DescFields + FGrid.Fields[Column.Index].FieldName;
      end;
    end
    else
    begin
      SortDef.Fields := FGrid.Fields[Column.Index].FieldName;
      if (not OldDescending) then
        SortDef.DescFields := FGrid.Fields[Column.Index].FieldName;
    end;

    TMySQLDataSet(FGrid.DataSource.DataSet).Sort(SortDef);
    FGrid.UpdateHeader();

    SortDef.Free();
  end;

  IgnoreFGridTitleClick := False;
end;

procedure TFClient.FHexEditorChange(Sender: TObject);
var
  Stream: TStream;
begin
  if (FHexEditor.Modified) then
  begin
    if (EditorField.DataSet.State <> dsEdit) then
      EditorField.DataSet.Edit();

    if (EditorField.DataType = ftWideMemo) then
      Stream := TStringStream.Create('')
    else if (EditorField.DataType = ftBlob) then
      Stream := EditorField.DataSet.CreateBlobStream(EditorField, bmWrite)
    else
      Stream := nil;

    if (Assigned(Stream)) then
    begin
      FHexEditor.SaveToStream(Stream);

      Stream.Free();
    end;
  end;

  aVBlobRTF.Visible := Assigned(EditorField) and (EditorField.DataType = ftWideMemo) and not EditorField.IsNull and IsRTF(EditorField.AsString);
end;

procedure TFClient.FHexEditorEnter(Sender: TObject);
begin
  StatusBarRefresh();
end;

procedure TFClient.FHexEditorKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
  begin
    Window.ActiveControl := FGrid;
    FGrid.DataSource.DataSet.Cancel();
  end;
end;

procedure TFClient.FHexEditorShow(Sender: TObject);
var
  Stream: TStream;
begin
  FHexEditor.UnicodeChars := False;
  if (not EditorField.IsNull and (EditorField.DataType = ftBlob)) then
  begin
    Stream := EditorField.DataSet.CreateBlobStream(EditorField, bmRead);
    FHexEditor.BytesPerColumn := 1;
  end
  else if (not EditorField.IsNull and (EditorField.DataType = ftWideMemo)) then
  begin
    Stream := EditorField.DataSet.CreateBlobStream(EditorField, bmRead);
    FHexEditor.BytesPerColumn := 2;
  end
  else
    Stream := nil;

  if (not Assigned(Stream)) then
    FHexEditor.DataSize := 0
  else
  begin
    FHexEditor.LoadFromStream(Stream);
    FHexEditor.UnicodeChars := EditorField.DataType = ftWideMemo;
    FHexEditor.AllowInsertMode := True;
    FHexEditor.InsertMode := False;
    FHexEditor.ReadOnlyView := EditorField.ReadOnly or not EditorField.DataSet.CanModify;
    FHexEditor.SelectAll();
    Stream.Free();
  end;
end;

procedure TFClient.FHTMLHide(Sender: TObject);
begin
  if (Assigned(FHTML)) then
    FreeAndNil(FHTML);
end;

procedure TFClient.FHTMLShow(Sender: TObject);
var
  FilenameP: array [0 .. MAX_PATH] of Char;
  FileStream: TFileStream;
  Stream: TStream;
begin
  if (not Assigned(FHTML)) then
  begin
    FHTML := TWebBrowser.Create(Self);
    FHTML.Align := alClient;

    PBlob.InsertControl(FHTML);
  end;

  if (Assigned(FHTML)) then
  begin
    if (not EditorField.IsNull and (EditorField.DataType = ftWideMemo)) then
      Stream := TStringStream.Create(EditorField.AsString)
    else if (not EditorField.IsNull and (EditorField.DataType = ftBlob)) then
      Stream := EditorField.DataSet.CreateBlobStream(EditorField, bmRead)
    else
      Stream := nil;

    if (Assigned(Stream) and (GetTempPath(MAX_PATH, FilenameP) > 0) and (GetTempFileName(@FilenameP, '~MF', 0, @FilenameP) > 0)) then
    begin
      FileStream := TFileStream.Create(FilenameP, fmCreate or fmShareDenyWrite);
      if (Assigned(FileStream)) then
      begin
        FileStream.CopyFrom(Stream, 0);
        FileStream.Free();

        FHTML.Navigate(FilenameP);

        DeleteFile(string(FilenameP));
      end;

      Stream.Free();
    end;
  end;
end;

procedure TFClient.FieldSetText(Sender: TField; const Text: string);
begin
  try
    Sender.AsString := Text;
  except
    OnConvertError(Sender, Text);
    Abort();
  end;
end;

procedure TFClient.FImageShow(Sender: TObject);
var
  Buffer: array [0..9] of AnsiChar;
  Size: Integer;
  Stream: TStream;
begin
  if (EditorField.IsNull or not (EditorField.DataType in [ftWideMemo, ftBlob])) then
    Stream := nil
  else
    Stream := EditorField.DataSet.CreateBlobStream(EditorField, bmRead);

  if (not Assigned(Stream) or (Stream.Size = 0)) then
    Size := 0
  else
    begin Size := Stream.Read(Buffer, Length(Buffer)); Stream.Seek(0, soFromBeginning); end;

  try
    if ((Size > 3) and (Buffer[0] = 'G') and (Buffer[1] = 'I') and (Buffer[2] = 'F')) then
      try GIFImage.LoadFromStream(Stream); FImage.Picture.Graphic := GIFImage; except FImage.Picture.Graphic := nil; end
    else if ((Size >= 10) and (Buffer[6] = 'J') and (Buffer[7] = 'F') and (Buffer[8] = 'I') and (Buffer[9] = 'F')) then
      try JPEGImage.LoadFromStream(Stream); FImage.Picture.Graphic := JPEGImage; except FImage.Picture.Graphic := nil; end
    else if ((Size >= 4) and (Buffer[1] = 'P') and (Buffer[2] = 'N') and (Buffer[3] = 'G')) then
      try PNGImage.LoadFromStream(Stream); FImage.Picture.Graphic := PNGImage; except FImage.Picture.Graphic := nil; end
    else
      FImage.Picture.Graphic := nil;
  except
  end;
  if (Assigned(Stream)) then
    Stream.Free();
end;

procedure TFClient.FLimitChange(Sender: TObject);
begin
  FUDLimit.Position := FUDLimit.Position;

  FUDOffset.Increment := FUDLimit.Position;

  FOffsetChange(Sender);
end;

procedure TFClient.FLimitEnabledClick(Sender: TObject);
begin
  FQuickSearchEnabled.Down := False;
  TableOpen(Sender);
  Window.ActiveControl := FOffset;
end;

procedure TFClient.FListChanging(Sender: TObject; Item: TListItem;
  Change: TItemChange; var AllowChange: Boolean);
var
  Database: TCDatabase;
begin
  if (not Assigned(FList.ItemFocused) and (Change = ctState) and Assigned(Item) and (Item.SubItems.Count = 0) and (NMListView^.uNewState and LVIS_SELECTED <> 0) and (Item.ImageIndex = iiBaseTable)) then
  begin
    Database := Client.DatabaseByName(SelectedDatabase);
    AllowChange := Assigned(Database) and Assigned(Database.BaseTableByName(Item.Caption));
  end;
end;

procedure TFClient.FListColumnClick(Sender: TObject; Column: TListColumn);
var
  HDItem: THDItem;
  I: Integer;
begin
  with (FListSortColumn[ContentWidthIndexFromImageIndex(SelectedImageIndex)]) do
  begin
    FListSortColumn[ContentWidthIndexFromImageIndex(SelectedImageIndex)].Index := Column.Index;
    if (Sender = FList) then
    begin
      if ((OldFListOrderIndex <> Index) or ((Order = 0) or (Order < 0) and (not (SelectedImageIndex in [iiBaseTable, iiSystemView, iiView]) or (Index > 0)))) then
        FListSortColumn[ContentWidthIndexFromImageIndex(SelectedImageIndex)].Order := 1
      else if (Order = 1) then
        FListSortColumn[ContentWidthIndexFromImageIndex(SelectedImageIndex)].Order := -1
      else
        FListSortColumn[ContentWidthIndexFromImageIndex(SelectedImageIndex)].Order := 0;

      if (Order = 0) then
        FListRefresh(Sender)
      else
        FList.CustomSort(nil, Index);
    end;

    HDItem.Mask := HDI_FORMAT;
    for I := 0 to FList.Columns.Count - 1 do
      if (BOOL(SendMessage(ListView_GetHeader(FList.Handle), HDM_GETITEM, I, LParam(@HDItem)))) then
      begin
        if ((Order = 0) or (I <> Index)) then
          HDItem.fmt := HDItem.fmt and not HDF_SORTUP and not HDF_SORTDOWN
        else if (Order > 0) then
          HDItem.fmt := HDItem.fmt and not HDF_SORTDOWN or HDF_SORTUP
        else
          HDItem.fmt := HDItem.fmt and not HDF_SORTUP or HDF_SORTDOWN;
        SendMessage(ListView_GetHeader(FList.Handle), HDM_SETITEM, I, LParam(@HDItem));
      end;

    if (ComCtl32MajorVersion >= 6) then
      if (Order = 0) then
        SendMessage(FList.Handle, LVM_SETSELECTEDCOLUMN, -1, 0)
      else
        SendMessage(FList.Handle, LVM_SETSELECTEDCOLUMN, Index, 0);

    OldFListOrderIndex := Index;
  end;
end;

procedure TFClient.FListCompare(Sender: TObject; Item1: TListItem;
  Item2: TListItem; Data: Integer; var Compare: Integer);
const
  iiServerSort = Chr(iiDatabase) + Chr(iiHosts) + Chr(iiProcesses) + Chr(iiStati) + Chr(iiUsers) + Chr(iiVariables);
  iiDatabaseSort = Chr(iiBaseTable) + Chr(iiView) + Chr(iiProcedure) + Chr(iiFunction) + Chr(iiEvent);
  iiTableSort = Chr(iiIndex) + Chr(iiField) + Chr(iiForeignKey) + Chr(iiTrigger);
  SourceImageIndex = Chr(iiSystemDatabase) + Chr(iiFunction);
  DestImageIndex = Chr(iiDatabase) + Chr(iiProcedure);
var
  ImageIndex1: Integer;
  ImageIndex2: Integer;
  String1: string;
  String2: string;
begin
  ImageIndex1 := Item1.ImageIndex;
  ImageIndex2 := Item2.ImageIndex;
  if (Pos(Chr(ImageIndex1), SourceImageIndex) > 0) then ImageIndex1 := Ord(DestImageIndex[Pos(Chr(ImageIndex1), SourceImageIndex)]);
  if (Pos(Chr(ImageIndex2), SourceImageIndex) > 0) then ImageIndex2 := Ord(DestImageIndex[Pos(Chr(ImageIndex2), SourceImageIndex)]);

  Compare := 0;
  if ((ImageIndex1 <> ImageIndex2) and not ((ImageIndex1 in [iiBaseTable, iiSystemView, iiView]) and (ImageIndex2 in [iiBaseTable, iiSystemView, iiView]))) then
    case (SelectedImageIndex) of
      iiServer: Compare := Sign(Pos(Chr(ImageIndex1), iiServerSort) - Pos(Chr(ImageIndex2), iiServerSort));
      iiDatabase: Compare := Sign(Pos(Chr(ImageIndex1), iiDatabaseSort) - Pos(Chr(ImageIndex2), iiDatabaseSort));
      iiBaseTable: Compare := Sign(Pos(Chr(ImageIndex1), iiTableSort) - Pos(Chr(ImageIndex2), iiTableSort));
    end
  else
  begin
    if ((Data = 0) or (Data > Item1.SubItems.Count) or (Data > Item2.SubItems.Count)) then
    begin
      String1 := Item1.Caption;
      String2 := Item2.Caption;
    end
    else
    begin
      String1 := Item1.SubItems[Data - 1];
      String2 := Item2.SubItems[Data - 1];

      Compare := 0;
      case (SelectedImageIndex) of
        iiServer:
          case (Data) of
            0: if (Client.LowerCaseTableNames = 0) then
                 Compare := Sign(lstrcmp(PChar(String1), PChar(String2)))
               else
                 Compare := Sign(lstrcmpi(PChar(String1), PChar(String2)));
            1: Compare := Sign(SysUtils.StrToInt64(String1) - SysUtils.StrToInt64(String2));
            2:
              begin
                if (String1 = '') then String1 := '0';               if (String2 = '') then String2 := '0';

                String1 := ReplaceStr(String1, '???', '0');         String2 := ReplaceStr(String2, '???', '0');

                String1 := ReplaceStr(String1, ' B', '');           String2 := ReplaceStr(String2, ' B', '');
                String1 := ReplaceStr(String1, ' KB', '000');       String2 := ReplaceStr(String2, ' KB', '000');
                String1 := ReplaceStr(String1, ' MB', '000000');    String2 := ReplaceStr(String2, ' MB', '000000');
                String1 := ReplaceStr(String1, ' GB', '000000000'); String2 := ReplaceStr(String2, ' GB', '000000000');

                String1 := ReplaceStr(String1, LocaleFormatSettings.ThousandSeparator, '');
                String2 := ReplaceStr(String2, LocaleFormatSettings.ThousandSeparator, '');
                Compare := Sign(SysUtils.StrToFloat(String1, LocaleFormatSettings) - SysUtils.StrToFloat(String2, LocaleFormatSettings));
              end;
            3:
              begin
                if (String1 = '') then String1 := SysUtils.DateToStr(1, LocaleFormatSettings);
                if (String2 = '') then String2 := SysUtils.DateToStr(1, LocaleFormatSettings);

                String1 := ReplaceStr(String1, '???', SysUtils.DateToStr(1, LocaleFormatSettings));
                String2 := ReplaceStr(String2, '???', SysUtils.DateToStr(1, LocaleFormatSettings));

                Compare := Sign(SysUtils.StrToDateTime(String1, LocaleFormatSettings) - SysUtils.StrToDateTime(String2, LocaleFormatSettings));
              end;
          end;
        iiDatabase:
          case (Data) of
            0: if (Client.LowerCaseTableNames = 0) then
                 Compare := Sign(lstrcmp(PChar(String1), PChar(String2)))
               else
                 Compare := Sign(lstrcmpi(PChar(String1), PChar(String2)));
            2:
              begin
                if (String1 = '') then String1 := '0';
                if (String2 = '') then String2 := '0';

                String1 := ReplaceStr(String1, '~', '');            String2 := ReplaceStr(String2, '~', '');
                String1 := ReplaceStr(String1, '???', '0');         String2 := ReplaceStr(String2, '???', '0');

                String1 := ReplaceStr(String1, LocaleFormatSettings.ThousandSeparator, '');
                String2 := ReplaceStr(String2, LocaleFormatSettings.ThousandSeparator, '');
                Compare := Sign(SysUtils.StrToFloat(String1, LocaleFormatSettings) - SysUtils.StrToFloat(String2, LocaleFormatSettings));
              end;
            3:
              begin
                if (String1 = '') then String1 := '0';               if (String2 = '') then String2 := '0';

                String1 := ReplaceStr(String1, '???', '0');         String2 := ReplaceStr(String2, '???', '0');
                String1 := ReplaceStr(String1, '???', '0');         String2 := ReplaceStr(String2, '???', '0');
                String1 := ReplaceStr(String1, ' B', '');           String2 := ReplaceStr(String2, ' B', '');
                String1 := ReplaceStr(String1, ' KB', '000');       String2 := ReplaceStr(String2, ' KB', '000');
                String1 := ReplaceStr(String1, ' MB', '000000');    String2 := ReplaceStr(String2, ' MB', '000000');
                String1 := ReplaceStr(String1, ' GB', '000000000'); String2 := ReplaceStr(String2, ' GB', '000000000');

                String1 := ReplaceStr(String1, LocaleFormatSettings.ThousandSeparator, '');
                String2 := ReplaceStr(String2, LocaleFormatSettings.ThousandSeparator, '');
                Compare := Sign(SysUtils.StrToFloat(String1, LocaleFormatSettings) - SysUtils.StrToFloat(String2, LocaleFormatSettings));
              end;
            4:
              begin
                if (String1 = '') then String1 := SysUtils.DateToStr(1, LocaleFormatSettings);
                if (String2 = '') then String2 := SysUtils.DateToStr(1, LocaleFormatSettings);

                String1 := ReplaceStr(String1, '???', SysUtils.DateToStr(1, LocaleFormatSettings));
                String2 := ReplaceStr(String2, '???', SysUtils.DateToStr(1, LocaleFormatSettings));

                Compare := Sign(SysUtils.StrToDateTime(String1, LocaleFormatSettings) - SysUtils.StrToDateTime(String2, LocaleFormatSettings));
              end;
          end;
      end;
    end;

    if (Compare = 0) then
      Compare := Sign(lstrcmp(PChar(String1), PChar(String2)));
    if (Compare = 0) then
      Compare := Sign(lstrcmp(PChar(Item1.Caption), PChar(Item2.Caption)));

    Compare := FListSortColumn[ContentWidthIndexFromImageIndex(SelectedImageIndex)].Order * Compare;
  end;
end;

procedure TFClient.FListData(Sender: TObject; Item: TListItem);
var
  BaseTable: TCBaseTable;
  BaseTableField: TCBaseTableField;
  Database: TCDatabase;
  Event: TCEvent;
  FieldNames: string;
  ForeignKey: TCForeignKey;
  Host: TCHost;
  I: Integer;
  J: Integer;
  Index: TCIndex;
  Process: TCProcess;
  Routine: TCRoutine;
  S: string;
  S2: string;
  Status: TCStatus;
  Table: TCTable;
  Trigger: TCTrigger;
  User: TCUser;
  Variable: TCVariable;
  View: TCView;
  ViewField: TCViewField;
begin
  if (Assigned(FNavigator.Selected)) then
    case (FNavigator.Selected.ImageIndex) of
      iiServer:
        begin
          if (Item.Index < Client.Databases.Count) then
          begin
            Database := Client.Databases[Item.Index];

            Item.GroupId := iiDatabase;
            if (Database is TCSystemDatabase) then
              Item.ImageIndex := iiSystemDatabase
            else
              Item.ImageIndex := iiDatabase;
            Item.Caption := Database.Name;

            if (not Database.Actual) then
              Item.SubItems.Add('')
            else
              Item.SubItems.Add(FormatFloat('#,##0', Database.Count, LocaleFormatSettings));
            Item.SubItems.Add(SizeToStr(Database.Size));
            if (Database is TCSystemDatabase) then
              Item.SubItems.Add('')
            else if (Database.Created = 0) then
              Item.SubItems.Add('???')
            else
              Item.SubItems.Add(SysUtils.DateToStr(Database.Created, LocaleFormatSettings));
            if (Database.DefaultCharset = Client.DefaultCharset) then
              S := ''
            else
              S := Database.DefaultCharset;
            if ((Database.Collation <> '') and (Database.Collation <> Client.Collation)) then
            begin
              if (S <> '') then S := S + ', ';
              S := S + Database.Collation;
            end;
            if (Database is TCSystemDatabase) then
              Item.SubItems.Add('')
            else
              Item.SubItems.Add(S);
          end;

          case (FNavigator.Selected.Item[Item.Index].ImageIndex) of
            iiHosts:
              begin
                Item.GroupID := 0;
                Item.Caption := Preferences.LoadStr(335);
                Item.ImageIndex := iiHosts;
                if (Client.Hosts.Actual) then
                  Item.SubItems.Add(FormatFloat('#,##0', Client.Hosts.Count, LocaleFormatSettings));
              end;
            iiProcesses:
              begin
                Item.GroupID := 0;
                Item.ImageIndex := iiProcesses;
                Item.Caption := Preferences.LoadStr(24);
                if (Client.Processes.Actual) then
                  Item.SubItems.Add(FormatFloat('#,##0', Client.Processes.Count, LocaleFormatSettings));
              end;
            iiStati:
              begin
                Item.GroupID := 0;
                Item.ImageIndex := iiStati;
                Item.Caption := Preferences.LoadStr(23);
                if (Client.Stati.Actual) then
                  Item.SubItems.Add(FormatFloat('#,##0', Client.Stati.Count, LocaleFormatSettings));
              end;
            iiUsers:
              begin
                Item.GroupID := 0;
                Item.ImageIndex := iiUsers;
                Item.Caption := ReplaceStr(Preferences.LoadStr(561), '&', '');
                if (Client.Users.Actual) then
                  if (Client.Users.Count >= 0) then
                    Item.SubItems.Add(FormatFloat('#,##0', Client.Users.Count, LocaleFormatSettings))
                  else
                    Item.SubItems.Add('???');
              end;
            iiVariables:
              begin
                Item.GroupID := 0;
                Item.ImageIndex := iiVariables;
                Item.Caption := Preferences.LoadStr(22);
                if (Client.Variables.Actual) then
                  Item.SubItems.Add(FormatFloat('#,##0', Client.Variables.Count, LocaleFormatSettings));
              end;
          end;
        end;
      iiDatabase,
      iiSystemDatabase:
        begin
          Database := Client.Databases[FNavigator.Selected.Index];

          if (Item.Index < Database.Tables.Count) then
          begin
            Table := Database.Tables[Item.Index];

            Item.GroupID := iiTable;
            if (Table is TCSystemView) then
              Item.ImageIndex := iiSystemView
            else if (Table is TCBaseTable) then
              Item.ImageIndex := iiBaseTable
            else
              Item.ImageIndex := iiView;
            Item.Caption := Table.Name;

            if ((Table is TCBaseTable) and Assigned(TCBaseTable(Table).Engine)) then
              Item.SubItems.Add(TCBaseTable(Table).Engine.Name)
            else if ((Table is TCView)) then
              Item.SubItems.Add(ReplaceStr(Preferences.LoadStr(738), '&', ''))
            else
              Item.SubItems.Add('???');

            if ((Table is TCBaseTable) and not TCBaseTable(Table).ActualStatus) then
              Item.SubItems.Add('')
            else if ((Table is TCBaseTable) and (TCBaseTable(Table).Rows < 0)) then
              Item.SubItems.Add('???')
            else if ((Table is TCBaseTable) and Assigned(TCBaseTable(Table).Engine) and (UpperCase(TCBaseTable(Table).Engine.Name) = 'INNODB')) then
              Item.SubItems.Add('~' + FormatFloat('#,##0', TCBaseTable(Table).Rows, LocaleFormatSettings))
            else if ((Table is TCBaseTable)) then
              Item.SubItems.Add(FormatFloat('#,##0', TCBaseTable(Table).Rows, LocaleFormatSettings))
            else
              Item.SubItems.Add('');

            if ((Table is TCBaseTable) and not TCBaseTable(Table).ActualStatus) then
              Item.SubItems.Add('')
            else if ((Table is TCBaseTable) and (TCBaseTable(Table).DataSize + TCBaseTable(Table).IndexSize < 0)) then
              Item.SubItems.Add('???')
            else if ((Table is TCBaseTable)) then
              Item.SubItems.Add(SizeToStr(TCBaseTable(Table).DataSize + TCBaseTable(Table).IndexSize + 1))
            else if ((Table is TCView) and TCView(Table).ActualSource) then
              Item.SubItems.Add(SizeToStr(Length(TCView(Table).Source)))
            else
              Item.SubItems.Add('');

            if ((Table is TCBaseTable) and not TCBaseTable(Table).ActualStatus) then
              Item.SubItems.Add('')
            else if ((Table is TCBaseTable) and (TCBaseTable(Table).Updated <= 0)) then
              Item.SubItems.Add('???')
            else if ((Table is TCBaseTable)) then
              Item.SubItems.Add(SysUtils.DateTimeToStr(TCBaseTable(Table).Updated, LocaleFormatSettings))
            else
              Item.SubItems.Add('');

            S := '';
            if ((Table is TCBaseTable) and (TCBaseTable(Table).DefaultCharset <> '') and (TCBaseTable(Table).DefaultCharset <> TCBaseTable(Table).Database.DefaultCharset)) then
              S := S + TCBaseTable(Table).DefaultCharset;
            if ((Table is TCBaseTable) and (TCBaseTable(Table).Collation <> '') and (TCBaseTable(Table).Collation <> TCBaseTable(Table).Database.Collation)) then
            begin
              if (S <> '') then S := S + ', ';
              S := S + TCBaseTable(Table).Collation;
            end;
            Item.SubItems.Add(S);

            if ((Table is TCBaseTable)) then
              Item.SubItems.Add(TCBaseTable(Table).Comment)
            else
              Item.SubItems.Add(TCView(Table).Comment);
          end
          else if (Assigned(Database.Routines) and (Item.Index < Database.Tables.Count + Database.Routines.Count)) then
          begin
            Routine := Database.Routines[Item.Index - Database.Tables.Count];

            Item.GroupID := iiProcedure;
            if (Routine is TCProcedure) then
              Item.ImageIndex := iiProcedure
            else if (Routine is TCFunction) then
              Item.ImageIndex := iiFunction;
            Item.Caption := Routine.Name;

            case (Routine.RoutineType) of
              rtProcedure: Item.SubItems.Add('Procedure');
              rtFunction: Item.SubItems.Add('Function');
            end;
            Item.SubItems.Add('');

            if (not Routine.ActualSource) then
              Item.SubItems.Add('')
            else
              Item.SubItems.Add(SizeToStr(Length(Routine.Source)));
            if (Routine.Modified = 0) then
              Item.SubItems.Add('???')
            else
              Item.SubItems.Add(SysUtils.DateTimeToStr(Routine.Modified, LocaleFormatSettings));
            if (not Assigned(Routine.FunctionResult) or (Routine.FunctionResult.Charset = '') or (Routine.FunctionResult.Charset = Database.DefaultCharset)) then
              Item.SubItems.Add('')
            else
              Item.SubItems.Add(Routine.FunctionResult.Charset);
            Item.SubItems.Add(Routine.Comment);
          end
          else if (Assigned(Database.Routines) and Assigned(Database.Events) and (Item.Index < Database.Tables.Count + Database.Routines.Count + Database.Events.Count)) then
          begin
            Event := Database.Events[Item.Index - Database.Tables.Count - Database.Routines.Count];

            Item.GroupID := iiEvent;
            Item.ImageIndex := iiEvent;
            Item.Caption := Event.Name;
            Item.SubItems.Add('Event');
            Item.SubItems.Add('');
            if (not Event.ActualSource) then
              Item.SubItems.Add('')
            else
              Item.SubItems.Add(SizeToStr(Length(Event.Source)));
            if (Event.Updated = 0) then
              Item.SubItems.Add('???')
            else
              Item.SubItems.Add(SysUtils.DateTimeToStr(Event.Updated, LocaleFormatSettings));
            Item.SubItems.Add('');
            Item.SubItems.Add(Event.Comment);
          end;
        end;
      iiBaseTable,
      iiSystemView:
        begin
          Database := Client.Databases[FNavigator.Selected.Parent.Index];
          BaseTable := Database.BaseTableByName(FNavigator.Selected.Text);

          if (Assigned(BaseTable)) then
            if (Item.Index < BaseTable.Indices.Count) then
            begin
              Index := BaseTable.Indices[Item.Index];

              Item.GroupID := iiIndex;
              Item.ImageIndex := iiIndex;
              Item.Caption := Index.Caption;

              FieldNames := '';
              for I := 0 to Index.Columns.Count - 1 do
              begin
                if (FieldNames <> '') then FieldNames := FieldNames + ',';
                FieldNames := FieldNames + Index.Columns[I].Field.Name;
                if (Index.Columns.Column[I].Length > 0) then
                  FieldNames := FieldNames + '(' + IntToStr(Index.Columns[I].Length) + ')';
              end;
              Item.SubItems.Add(FieldNames);
              Item.SubItems.Add('');
              Item.SubItems.Add('');
              if (Index.Unique) then
                Item.SubItems.Add('unique')
              else if (Index.Fulltext) then
                Item.SubItems.Add('fulltext')
              else
                Item.SubItems.Add('');
              if (Client.ServerVersion >= 40100) then
                Item.SubItems.Add('');
            end
            else if (Item.Index < BaseTable.Indices.Count + BaseTable.Fields.Count) then
            begin
              BaseTableField := TCBaseTableField(BaseTable.Fields[Item.Index - BaseTable.Indices.Count]);

              Item.GroupID := iiField;
              if (BaseTable is TCSystemView) then
                Item.ImageIndex := iiSystemViewField
              else
                Item.ImageIndex := iiField;
              Item.Caption := BaseTableField.Name;

              Item.SubItems.Add(BaseTableField.DBTypeStr());

              if (BaseTableField.NullAllowed) then
                Item.SubItems.Add(Preferences.LoadStr(74))
              else
                Item.SubItems.Add(Preferences.LoadStr(75));
              if (BaseTableField.AutoIncrement) then
                Item.SubItems.Add('<auto_increment>')
              else if (BaseTableField.Default = 'NULL') then
                Item.SubItems.Add('<' + Preferences.LoadStr(71) + '>')
              else if (BaseTableField.Default = 'CURRENT_TIMESTAMP') then
                Item.SubItems.Add('<INSERT-TimeStamp>')
              else
                Item.SubItems.Add(BaseTableField.UnescapeValue(BaseTableField.Default));
              S := '';
              if (BaseTableField.FieldType in TextFieldTypes) then
              begin
                if ((BaseTableField.Charset <> '') and (BaseTableField.Charset <> BaseTable.DefaultCharset)) then
                  S := S + BaseTableField.Charset;
                if ((BaseTableField.Collation <> '') and (BaseTableField.Collation <> BaseTable.Collation)) then
                begin
                  if (S <> '') then S := S + ', ';
                  S := S + BaseTableField.Collation;
                end;
              end;
              Item.SubItems.Add(S);
              if (Client.ServerVersion >= 40100) then
                Item.SubItems.Add(BaseTableField.Comment);
            end
            else if (Assigned(BaseTable.ForeignKeys) and (Item.Index < BaseTable.Indices.Count + BaseTable.Fields.Count + BaseTable.ForeignKeys.Count)) then
            begin
              ForeignKey := BaseTable.ForeignKeys[Item.Index - BaseTable.Indices.Count - BaseTable.Fields.Count];

              Item.GroupID := iiForeignKey;
              Item.ImageIndex := iiForeignKey;
              Item.Caption := ForeignKey.Name;

              Item.SubItems.Add(ForeignKey.DBTypeStr());
              Item.SubItems.Add('');
              Item.SubItems.Add('');

              S := '';
              if (ForeignKey.OnDelete = dtCascade) then S := 'cascade on delete';
              if (ForeignKey.OnDelete = dtSetNull) then S := 'set NULL on delete';
              if (ForeignKey.OnDelete = dtSetDefault) then S := 'set default on delete';
              if (ForeignKey.OnDelete = dtNoAction) then S := 'no action on delete';
              S2 := '';
              if (ForeignKey.OnUpdate = utCascade) then S2 := 'cascade on update';
              if (ForeignKey.OnUpdate = utSetNull) then S2 := 'set NULL on update';
              if (ForeignKey.OnUpdate = utSetDefault) then S2 := 'set default on update';
              if (ForeignKey.OnUpdate = utNoAction) then S2 := 'no action on update';
              if (S <> '') and (S2 <> '') then S := S + ', ';
              S := S + S2;
              Item.SubItems.Add(S);

              if (Client.ServerVersion >= 40100) then
                Item.SubItems.Add('');
            end
            else if (Assigned(Database.Triggers)) then
            begin
              I := 0; J := 0;
              while ((I < Database.Triggers.Count) and (J < Item.Index - BaseTable.Indices.Count - BaseTable.Fields.Count - BaseTable.ForeignKeys.Count)) do
              begin
                if (Database.Triggers[I].Table = BaseTable) then
                  Inc(J);
                Inc(I);
              end;

              if (I < Database.Triggers.Count) then
              begin
                Trigger := Database.Triggers[I];

                Item.GroupID := iiTrigger;
                Item.ImageIndex := iiTrigger;
                Item.Caption := Trigger.Name;

                S := '';
                case (Trigger.Timing) of
                  ttBefore: S := S + 'before ';
                  ttAfter: S := S + 'after ';
                end;
                case (Trigger.Event) of
                  teInsert: S := S + 'insert ';
                  teUpdate: S := S + 'update ';
                  teDelete: S := S + 'delete ';
                end;
                Item.SubItems.Add(S);
              end;
            end;
        end;
      iiView:
        begin
          Database := Client.Databases[FNavigator.Selected.Parent.Index];
          View := Database.ViewByName(FNavigator.Selected.Text);
          ViewField := TCViewField(View.Fields[Item.Index]);

          Item.GroupID := iiField;
          Item.ImageIndex := iiViewField;
          Item.Caption := ViewField.Name;
          if (ViewField.FieldType <> mfUnknown) then
          begin
            Item.SubItems.Add(ViewField.DBTypeStr());
            if (ViewField.NullAllowed) then
              Item.SubItems.Add(Preferences.LoadStr(74))
            else
              Item.SubItems.Add(Preferences.LoadStr(75));
            if (ViewField.AutoIncrement) then
              Item.SubItems.Add('<auto_increment>')
            else
              Item.SubItems.Add(ViewField.Default);
            if (ViewField.Charset <> Client.DatabaseByName(SelectedDatabase).DefaultCharset) then
              Item.SubItems.Add(ViewField.Charset);
          end;
        end;
      iiHosts:
        begin
          Host := Client.Hosts[Item.Index];

          Item.GroupID := iiHost;
          Item.ImageIndex := iiHost;
          Item.Caption := Host.Caption;
        end;
      iiProcesses:
        begin
          Process := Client.Processes[Item.Index];

          Item.GroupID := iiProcess;
          Item.ImageIndex := iiProcess;
          Item.Caption := IntToStr(Process.Id);
          Item.SubItems.Add(Process.UserName);
          Item.SubItems.Add(Process.Host);
          Item.SubItems.Add(Process.DatabaseName);
          Item.SubItems.Add(Process.Command);
          Item.SubItems.Add(SQLStmtToCaption(Process.SQL, 30));
          if (Process.Time = 0) then
            Item.SubItems.Add('???')
          else
            Item.SubItems.Add(ExecutionTimeToStr(Process.Time));
          Item.SubItems.Add(Process.State);
        end;
      iiStati:
        begin
          Status := Client.Stati[Item.Index];

          Item.GroupID := iiStatus;
          Item.ImageIndex := iiStatus;
          Item.Caption := Status.Name;
          Item.SubItems.Add(Status.Value);
        end;
      iiUsers:
        begin
          User := Client.Users[Item.Index];

          Item.GroupID := iiUser;
          Item.ImageIndex := iiUser;
          Item.Caption := User.Caption;
        end;
      iiVariables:
        begin
          Variable := Client.Variables[Item.Index];

          Item.GroupID := iiVariable;
          Item.ImageIndex := iiVariable;
          Item.Caption := Variable.Name;
          Item.SubItems.Add(Variable.Value);
        end;
    end;
end;

procedure TFClient.FListDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  SourceClient: TCClient;
  SourceDatabase: TCDatabase;
  SourceItem: TListItem;
  SourceNode: TTreeNode;
  TargetItem: TListItem;
begin
  Accept := False;

  TargetItem := TListView(Sender).GetItemAt(X, Y);

  if ((Source is TTreeView_Ext) and (TTreeView_Ext(Source).Name = FNavigator.Name)) then
  begin
    SourceNode := TFClient(TTreeView_Ext(Source).Owner).MouseDownNode;

    if (not Assigned(TargetItem)) then
      case (SourceNode.ImageIndex) of
        iiBaseTable,
        iiProcedure,
        iiFunction,
        iiField: Accept := (SourceNode.Parent.ImageIndex = SelectedImageIndex) and (SourceNode.Parent <> FNavigator.Selected);
      end
    else if (((TargetItem.Caption <> SourceNode.Text) or (SourceNode.Parent <> FNavigator.Selected)) and (SourceNode.Parent.Text <> TargetItem.Caption)) then
      case (TargetItem.ImageIndex) of
        iiDatabase: Accept := (SourceNode.ImageIndex in [iiDatabase, iiBaseTable, iiProcedure, iiFunction]);
        iiBaseTable: Accept := SourceNode.ImageIndex in [iiBaseTable, iiField];
      end;
  end
  else if ((Source is TListView) and (TListView(Source).SelCount = 1) and (TListView(Source).Name = FList.Name)) then
  begin
    SourceItem := TListView(Source).Selected;
    SourceClient := TFClient(TTreeView_Ext(Source).Owner).Client;
    SourceDatabase := SourceClient.DatabaseByName(TFClient(TTreeView_Ext(Source).Owner).MenuDatabase);

    if (not Assigned(TargetItem)) then
      case (SourceItem.ImageIndex) of
        iiBaseTable,
        iiProcedure,
        iiFunction: Accept := (SelectedImageIndex = iiDatabase) and (not Assigned(TargetItem) and (Client.DatabaseByName(SelectedDatabase) <> SourceDatabase));
      end
    else if ((TargetItem <> SourceItem) and (TargetItem.ImageIndex = SourceItem.ImageIndex)) then
      case (SourceItem.ImageIndex) of
        iiBaseTable: Accept := (SelectedImageIndex = iiDatabase);
      end
    else if ((TargetItem <> SourceItem) and (SourceClient <> Client)) then
      case (SourceItem.ImageIndex) of
        iiBaseTable: Accept := (SelectedImageIndex = iiServer);
      end;
  end;
end;

procedure TFClient.FListEdited(Sender: TObject; Item: TListItem;
  var S: string);
begin
  if (not RenameCItem(FocusedCItem, S)) then
    S := Item.Caption;
end;

procedure TFClient.FListEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  AllowEdit := (Item.ImageIndex = iiDatabase) and (Client.ServerVersion >= 50107) or (Item.ImageIndex = iiForeignKey) and (Client.ServerVersion >= 40013) or (Item.ImageIndex in [iiBaseTable, iiView, iiEvent, iiField, iiTrigger, iiHost, iiUser]);
end;

procedure TFClient.FListEmptyExecute(Sender: TObject);
var
  I: Integer;
  Names: array of string;
begin
  Wanted.Clear();

  if (FList.SelCount <= 1) then
    FNavigatorEmptyExecute(Sender)
  else
  begin
    SetLength(Names, 0);
    case (SelectedImageIndex) of
      iiServer:
        if (MsgBox(Preferences.LoadStr(405), Preferences.LoadStr(101), MB_YESNOCANCEL + MB_ICONQUESTION) = IDYES) then
        begin
          for I := 0 to FList.Items.Count - 1 do
            if (FList.Items[I].Selected) then
            begin
              SetLength(Names, Length(Names) + 1);
              Names[Length(Names) - 1] := FList.Items[I].Caption;
            end;
          Client.EmptyDatabases(Names);
        end;
      iiDatabase:
        if (MsgBox(Preferences.LoadStr(406), Preferences.LoadStr(101), MB_YESNOCANCEL + MB_ICONQUESTION) = IDYES) then
        begin
          for I := 0 to FList.Items.Count - 1 do
            if (FList.Items[I].Selected) then
            begin
              SetLength(Names, Length(Names) + 1);
              Names[Length(Names) - 1] := FList.Items[I].Caption;
            end;
          Client.DatabaseByName(SelectedDatabase).EmptyTables(Names);
        end;
      iiBaseTable:
        if (MsgBox(Preferences.LoadStr(407), Preferences.LoadStr(101), MB_YESNOCANCEL + MB_ICONQUESTION) = IDYES) then
        begin
          for I := 0 to FList.Items.Count - 1 do
            if (FList.Items[I].Selected) then
            begin
              SetLength(Names, Length(Names) + 1);
              Names[Length(Names) - 1] := FList.Items[I].Caption;
            end;
          Client.DatabaseByName(SelectedDatabase).BaseTableByName(SelectedTable).EmptyFields(Names);
        end;
    end;
    SetLength(Names, 0);
  end;
end;

procedure TFClient.FListEnter(Sender: TObject);
begin
  MainAction('aDEmpty').OnExecute := FListEmptyExecute;

  aDCreate.ShortCut := VK_INSERT;
  aDDelete.ShortCut := VK_DELETE;

  FListSelectItem(Sender, FList.Selected, Assigned(FList.Selected));
  if (not Assigned(FList.Selected) and (FList.Items.Count > 0)) then
    FList.Items[0].Focused := True;

  StatusBarRefresh();
end;

procedure TFClient.FListExit(Sender: TObject);
begin
  StoreFListColumnWidths();

  MainAction('aFImportSQL').Enabled := False;
  MainAction('aFImportText').Enabled := False;
  MainAction('aFImportExcel').Enabled := False;
  MainAction('aFImportAccess').Enabled := False;
  MainAction('aFImportSQLite').Enabled := False;
  MainAction('aFImportODBC').Enabled := False;
  MainAction('aFImportXML').Enabled := False;
  MainAction('aFExportSQL').Enabled := False;
  MainAction('aFExportText').Enabled := False;
  MainAction('aFExportExcel').Enabled := False;
  MainAction('aFExportAccess').Enabled := False;
  MainAction('aFExportSQLite').Enabled := False;
  MainAction('aFExportODBC').Enabled := False;
  MainAction('aFExportXML').Enabled := False;
  MainAction('aFExportHTML').Enabled := False;
  MainAction('aFPrint').Enabled := False;
  MainAction('aERename').Enabled := False;
  MainAction('aDCreateDatabase').Enabled := False;
  MainAction('aDCreateTable').Enabled := False;
  MainAction('aDCreateView').Enabled := False;
  MainAction('aDCreateProcedure').Enabled := False;
  MainAction('aDCreateFunction').Enabled := False;
  MainAction('aDCreateEvent').Enabled := False;
  MainAction('aDCreateTrigger').Enabled := False;
  MainAction('aDCreateIndex').Enabled := False;
  MainAction('aDCreateField').Enabled := False;
  MainAction('aDCreateForeignKey').Enabled := False;
  MainAction('aDCreateHost').Enabled := False;
  MainAction('aDCreateUser').Enabled := False;
  MainAction('aDDeleteDatabase').Enabled := False;
  MainAction('aDDeleteTable').Enabled := False;
  MainAction('aDDeleteView').Enabled := False;
  MainAction('aDDeleteRoutine').Enabled := False;
  MainAction('aDDeleteEvent').Enabled := False;
  MainAction('aDDeleteIndex').Enabled := False;
  MainAction('aDDeleteField').Enabled := False;
  MainAction('aDDeleteForeignKey').Enabled := False;
  MainAction('aDDeleteTrigger').Enabled := False;
  MainAction('aDDeleteHost').Enabled := False;
  MainAction('aDDeleteUser').Enabled := False;
  MainAction('aDEditServer').Enabled := False;
  MainAction('aDEditDatabase').Enabled := False;
  MainAction('aDEditTable').Enabled := False;
  MainAction('aDEditView').Enabled := False;
  MainAction('aDEditRoutine').Enabled := False;
  MainAction('aDEditEvent').Enabled := False;
  MainAction('aDEditIndex').Enabled := False;
  MainAction('aDEditField').Enabled := False;
  MainAction('aDEditForeignKey').Enabled := False;
  MainAction('aDEditTrigger').Enabled := False;
  MainAction('aDEditHost').Enabled := False;
  MainAction('aDEditProcess').Enabled := False;
  MainAction('aDEditUser').Enabled := False;
  MainAction('aDEditVariable').Enabled := False;
  MainAction('aDEmpty').Enabled := False;

  aDCreate.ShortCut := 0;
  aDDelete.ShortCut := 0;
  mlEProperties.ShortCut := 0;
end;

procedure TFClient.FListRefresh(Sender: TObject);

  procedure SetFListColumnWidths();
  var
    I, Index, ContentWidth: Integer;
  begin
    Index := ContentWidthIndexFromImageIndex(SelectedImageIndex);
    if ((0 <= Index) and (Index < Length(Client.Account.Desktop.ContentWidths))) then
      for I := 0 to Min(FList.Columns.Count, Length(Client.Account.Desktop.ContentWidths[Index])) - 1 do
      begin
        ContentWidth := Client.Account.Desktop.ContentWidths[Index][I];
        if (ContentWidth <= 10) then
          FList.Column[I].Width := 100
        else
          FList.Column[I].Width := ContentWidth;
      end;
  end;

var
  BaseTable: TCBaseTable;
  ChangingEvent: TLVChangingEvent;
  Count: Integer;
  Database: TCDatabase;
  Group: TListGroup;
  I: Integer;
  LVItem: TLVItem;
  S: string;
  S2: string;
  View: TCView;
begin
  if (FList.Columns.Count > 0) then
    StoreFListColumnWidths();

  ChangingEvent := FList.OnChanging;
  FList.DisableAlign();
  FList.Items.BeginUpdate();
  FList.OnChanging := nil;
  FList.Items.Clear();

  if (LastSelectedImageIndex <> FNavigator.Selected.ImageIndex) then
  begin
    FList.Columns.BeginUpdate();
    FList.Columns.Clear();
    FList.Groups.Clear();

    case (FNavigator.Selected.ImageIndex) of
      iiServer:
        begin
          FList.Columns.Add().Caption := ReplaceStr(Preferences.LoadStr(38), '&', '');
          FList.Columns.Add().Caption := Preferences.LoadStr(76);
          FList.Columns.Add().Caption := Preferences.LoadStr(67);
          FList.Columns.Add().Caption := Preferences.LoadStr(77);
          FList.Columns.Add().Caption := ReplaceStr(Preferences.LoadStr(73), '&', '');
          SetFListColumnWidths();
          FList.Columns[1].Alignment := taRightJustify;
          FList.Columns[2].Alignment := taRightJustify;

          Group := FList.Groups.Add();
          Group.GroupID := iiDatabase;
          Group.Header := ReplaceStr(Preferences.LoadStr(265) + ' (' + IntToStr(Client.Databases.Count) + ')', '&', '');

          Group := FList.Groups.Add();
          Group.GroupID := 0;
          Group.Header := ReplaceStr(Preferences.LoadStr(12), '&', '');
        end;
      iiDatabase,
      iiSystemDatabase:
        begin
          Database := Client.DatabaseByName(FNavigator.Selected.Text);

          FList.Columns.Add().Caption := ReplaceStr(Preferences.LoadStr(35), '&', '');
          FList.Columns.Add().Caption := Preferences.LoadStr(69);
          FList.Columns.Add().Caption := Preferences.LoadStr(66);
          FList.Columns.Add().Caption := Preferences.LoadStr(67);
          FList.Columns.Add().Caption := Preferences.LoadStr(68);
          FList.Columns.Add().Caption := ReplaceStr(Preferences.LoadStr(73), '&', '');
          FList.Columns.Add().Caption := ReplaceStr(Preferences.LoadStr(111), '&', '');
          SetFListColumnWidths();
          if (FList.Column[1].Width > 2 * Preferences.GridMaxColumnWidth) then
            FList.Column[1].Width := 2 * Preferences.GridMaxColumnWidth;
          FList.Columns[2].Alignment := taRightJustify;
          FList.Columns[3].Alignment := taRightJustify;

          Group := FList.Groups.Add();
          Group.GroupID := iiTable;
          S := ReplaceStr(Preferences.LoadStr(234), '&', '');
          if (Client.ServerVersion >= 50001) then
            S := S + ' + ' + ReplaceStr(Preferences.LoadStr(873), '&', '');
          Group.Header := S + ' (' + IntToStr(Database.Tables.Count) + ')';

          if (Assigned(Database.Routines)) then
          begin
            Group := FList.Groups.Add();
            Group.GroupID := iiProcedure;
            Group.Header := ReplaceStr(Preferences.LoadStr(874) + ' + ' + Preferences.LoadStr(875), '&', '') + ' (' + IntToStr(Database.Routines.Count) + ')';
          end;

          if (Assigned(Database.Events)) then
          begin
            Group := FList.Groups.Add();
            Group.GroupID := iiEvent;
            Group.Header := ReplaceStr(Preferences.LoadStr(876), '&', '') + ' (' + IntToStr(Database.Events.Count) + ')';
          end;
        end;
      iiBaseTable,
      iiSystemView:
        begin
          Database := Client.DatabaseByName(FNavigator.Selected.Parent.Text);
          BaseTable := Database.BaseTableByName(FNavigator.Selected.Text);

          FList.Columns.Add().Caption := ReplaceStr(Preferences.LoadStr(35), '&', '');
          FList.Columns.Add().Caption := Preferences.LoadStr(69);
          FList.Columns.Add().Caption := Preferences.LoadStr(71);
          FList.Columns.Add().Caption := Preferences.LoadStr(72);
          FList.Columns.Add().Caption := ReplaceStr(Preferences.LoadStr(73), '&', '');
          if (Client.ServerVersion >= 40100) then
            FList.Columns.Add().Caption := ReplaceStr(Preferences.LoadStr(111), '&', '');
          SetFListColumnWidths();
          if (FList.Column[1].Width > 2 * Preferences.GridMaxColumnWidth) then
            FList.Column[1].Width := 2 * Preferences.GridMaxColumnWidth;

          Group := FList.Groups.Add();
          Group.GroupID := iiIndex;
          Group.Header := ReplaceStr(Preferences.LoadStr(458), '&', '') + ' (' + IntToStr(BaseTable.Indices.Count) + ')';

          Group := FList.Groups.Add();
          Group.GroupID := iiField;
          Group.Header := ReplaceStr(Preferences.LoadStr(253), '&', '') + ' (' + IntToStr(BaseTable.Fields.Count) + ')';

          if (Assigned(BaseTable.ForeignKeys)) then
          begin
            Group := FList.Groups.Add();
            Group.GroupID := iiForeignKey;
            Group.Header := ReplaceStr(Preferences.LoadStr(253), '&', '') + ' (' + IntToStr(BaseTable.ForeignKeys.Count) + ')';
          end;

          if (Assigned(Database.Triggers)) then
          begin
            Count := 0;
            for I := 0 to Database.Triggers.Count - 1 do
              if (Database.Triggers[I].Table = BaseTable) then
                Inc(Count);
            Group := FList.Groups.Add();
            Group.GroupID := iiTrigger;
            Group.Header := ReplaceStr(Preferences.LoadStr(797), '&', '') + ' (' + IntToStr(Count) + ')';
          end;
        end;
      iiView:
        begin
          Database := Client.DatabaseByName(FNavigator.Selected.Parent.Text);
          View := Database.ViewByName(FNavigator.Selected.Text);

          FList.Columns.Add().Caption := ReplaceStr(Preferences.LoadStr(35), '&', '');
          FList.Columns.Add().Caption := Preferences.LoadStr(69);
          FList.Columns.Add().Caption := Preferences.LoadStr(71);
          FList.Columns.Add().Caption := Preferences.LoadStr(72);
          FList.Columns.Add().Caption := ReplaceStr(Preferences.LoadStr(73), '&', '');
          SetFListColumnWidths();
          if (FList.Column[1].Width > 2 * Preferences.GridMaxColumnWidth) then
            FList.Column[1].Width := 2 * Preferences.GridMaxColumnWidth;

          Group := FList.Groups.Add();
          Group.GroupID := iiField;
          Group.Header := ReplaceStr(Preferences.LoadStr(253), '&', '') + ' (' + IntToStr(View.Fields.Count) + ')';
        end;
      iiHosts:
        begin
          FList.Columns.Add().Caption := Preferences.LoadStr(335);
          SetFListColumnWidths();

          Group := FList.Groups.Add();
          Group.GroupID := iiHost;
          Group.Header := ReplaceStr(Preferences.LoadStr(335), '&', '') + ' (' + IntToStr(Client.Hosts.Count) + ')';
        end;
      iiProcesses:
        begin
          FList.Columns.Add().Caption := Preferences.LoadStr(269);
          FList.Columns.Add().Caption := ReplaceStr(Preferences.LoadStr(561), '&', '');
          FList.Columns.Add().Caption := Preferences.LoadStr(271);
          FList.Columns.Add().Caption := ReplaceStr(Preferences.LoadStr(38), '&', '');
          FList.Columns.Add().Caption := Preferences.LoadStr(273);
          FList.Columns.Add().Caption := Preferences.LoadStr(274);
          FList.Columns.Add().Caption := ReplaceStr(Preferences.LoadStr(661), '&', '');
          FList.Columns.Add().Caption := Preferences.LoadStr(276);
          SetFListColumnWidths();

          Group := FList.Groups.Add();
          Group.GroupID := iiProcess;
          Group.Header := ReplaceStr(Preferences.LoadStr(24), '&', '') + ' (' + IntToStr(Client.Processes.Count) + ')';
        end;
      iiStati:
        begin
          FList.Columns.Add().Caption := Preferences.LoadStr(267);
          FList.Columns.Add().Caption := Preferences.LoadStr(268);
          SetFListColumnWidths();

          Group := FList.Groups.Add();
          Group.GroupID := iiStatus;
          Group.Header := ReplaceStr(Preferences.LoadStr(23), '&', '') + ' (' + IntToStr(Client.Stati.Count) + ')';
        end;
      iiUsers:
        begin
          FList.Columns.Add().Caption := ReplaceStr(Preferences.LoadStr(561), '&', '');
          SetFListColumnWidths();

          Group := FList.Groups.Add();
          Group.GroupID := iiUser;
          Group.Header := ReplaceStr(Preferences.LoadStr(561), '&', '') + ' (' + IntToStr(Client.Users.Count) + ')';
        end;
      iiVariables:
        begin
          FList.Columns.Add().Caption := Preferences.LoadStr(267);
          FList.Columns.Add().Caption := Preferences.LoadStr(268);
          SetFListColumnWidths();

          Group := FList.Groups.Add();
          Group.GroupID := iiVariable;
          Group.Header := ReplaceStr(Preferences.LoadStr(22), '&', '') + ' (' + IntToStr(Client.Variables.Count) + ')';
        end;
    end;

    FList.Columns.EndUpdate();
  end;

  case (FNavigator.Selected.ImageIndex) of
    iiHosts: Count := Client.Hosts.Count;
    iiProcesses: Count := Client.Processes.Count;
    iiStati: Count := Client.Stati.Count;
    iiUsers: Count := Client.Users.Count;
    iiVariables: Count := Client.Variables.Count;
    else Count := FNavigator.Selected.Count;
  end;

  if (FList.OwnerData) then
    FList.Items.Count := Count
  else
  begin
    for I := 0 to Count - 1 do
    begin
      FList.AddItem('', nil);
      FListData(Sender, FList.Items[I]);
    end;
    if (not (FNavigator.Selected.ImageIndex in [iiDatabase, iiSystemDatabase]) and (Count > 0)) then
      FList.ItemFocused := FList.Items[0];
    if ((Window.ActiveControl = FList) and Assigned(FList.OnSelectItem)) then
      FList.OnSelectItem(Sender, FList.Selected, Assigned(FList.Selected));
  end;

  if (FNavigator.Selected.ImageIndex in [iiHosts, iiStati, iiUsers, iiVariables]) then
    for I := 0 to FList.Columns.Count - 1 do
      if (Count = 0) then
        FList.Columns[I].Width := ColumnHeaderWidth
      else
        FList.Columns[I].Width := ColumnTextWidth
  else if (FNavigator.Selected.ImageIndex in [iiProcesses]) then
    for I := 0 to FList.Columns.Count - 1 do
      if (I = 5) then
        FList.Columns[I].Width := Preferences.GridMaxColumnWidth
      else
        FList.Columns[I].Width := ColumnTextWidth;

  FList.Items.EndUpdate();
  FList.EnableAlign();
  FList.OnChanging := ChangingEvent;

  if (FNavigator.Selected.ImageIndex >= 0) then
  begin
    if ((SelectedImageIndex >= 0) and (ContentWidthIndexFromImageIndex(SelectedImageIndex) < FList.Columns.Count)) then
      FListColumnClick(nil, FList.Column[FListSortColumn[ContentWidthIndexFromImageIndex(SelectedImageIndex)].Index]);
  end;

  LastSelectedImageIndex := FNavigator.Selected.ImageIndex;
end;

procedure TFClient.FListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  BaseTable: TCBaseTable;
  Database: TCDatabase;
  I: Integer;
  Msg: TMsg;
begin
  if (not (PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE) and (Msg.Message = WM_MOUSEMOVE) and (Msg.wParam = MK_LBUTTON)) or (FList.SelCount <= 1)) then
  begin
    aPOpenInNewWindow.Enabled := False;
    aPOpenInNewTab.Enabled := False;
    MainAction('aFImportSQL').Enabled := False;
    MainAction('aFImportText').Enabled := False;
    MainAction('aFImportExcel').Enabled := False;
    MainAction('aFImportAccess').Enabled := False;
    MainAction('aFImportSQLite').Enabled := False;
    MainAction('aFImportODBC').Enabled := False;
    MainAction('aFImportXML').Enabled := False;
    MainAction('aFExportSQL').Enabled := False;
    MainAction('aFExportText').Enabled := False;
    MainAction('aFExportExcel').Enabled := False;
    MainAction('aFExportAccess').Enabled := False;
    MainAction('aFExportSQLite').Enabled := False;
    MainAction('aFExportODBC').Enabled := False;
    MainAction('aFExportXML').Enabled := False;
    MainAction('aFExportHTML').Enabled := False;
    MainAction('aFPrint').Enabled := False;
    MainAction('aECopy').Enabled := False;
    MainAction('aEPaste').Enabled := False;
    MainAction('aERename').Enabled := False;
    MainAction('aDCreateDatabase').Enabled := False;
    MainAction('aDCreateTable').Enabled := False;
    MainAction('aDCreateView').Enabled := False;
    MainAction('aDCreateProcedure').Enabled := False;
    MainAction('aDCreateFunction').Enabled := False;
    MainAction('aDCreateTrigger').Enabled := False;
    MainAction('aDCreateEvent').Enabled := False;
    MainAction('aDCreateIndex').Enabled := False;
    MainAction('aDCreateField').Enabled := False;
    MainAction('aDCreateForeignKey').Enabled := False;
    MainAction('aDCreateHost').Enabled := False;
    MainAction('aDCreateUser').Enabled := False;
    MainAction('aDDeleteDatabase').Enabled := False;
    MainAction('aDDeleteTable').Enabled := False;
    MainAction('aDDeleteView').Enabled := False;
    MainAction('aDDeleteRoutine').Enabled := False;
    MainAction('aDDeleteIndex').Enabled := False;
    MainAction('aDDeleteField').Enabled := False;
    MainAction('aDDeleteForeignKey').Enabled := False;
    MainAction('aDDeleteTrigger').Enabled := False;
    MainAction('aDDeleteEvent').Enabled := False;
    MainAction('aDDeleteHost').Enabled := False;
    MainAction('aDDeleteUser').Enabled := False;
    MainAction('aDEditServer').Enabled := False;
    MainAction('aDEditDatabase').Enabled := False;
    MainAction('aDEditTable').Enabled := False;
    MainAction('aDEditView').Enabled := False;
    MainAction('aDEditRoutine').Enabled := False;
    MainAction('aDEditEvent').Enabled := False;
    MainAction('aDEditIndex').Enabled := False;
    MainAction('aDEditField').Enabled := False;
    MainAction('aDEditForeignKey').Enabled := False;
    MainAction('aDEditTrigger').Enabled := False;
    MainAction('aDEmpty').Enabled := False;

    mlOpen.Enabled := False;
    aDDelete.Enabled := False;
    mlEProperties.Action := nil;

    if (not Assigned(Item) or (Item is TListItem)) then
      case (SelectedImageIndex) of
        iiServer:
          begin
            aPOpenInNewWindow.Enabled := (FList.SelCount = 1) and Assigned(Item) and (Item.ImageIndex in [iiDatabase, iiSystemDatabase]);
            aPOpenInNewTab.Enabled := aPOpenInNewWindow.Enabled;
            MainAction('aFImportSQL').Enabled := (FList.SelCount <= 1) and (not Assigned(Client.UserRights) or Client.UserRights.RInsert) or Assigned(Item) and (Item.ImageIndex = iiDatabase);
            MainAction('aFImportExcel').Enabled := (FList.SelCount = 1) and Assigned(Item) and (Item.ImageIndex = iiDatabase);
            MainAction('aFImportAccess').Enabled := (FList.SelCount = 1) and Assigned(Item) and (Item.ImageIndex = iiDatabase);
            MainAction('aFImportSQLite').Enabled := (FList.SelCount = 1) and Assigned(Item) and (Item.ImageIndex = iiDatabase);
            MainAction('aFImportODBC').Enabled := (FList.SelCount = 1) and Assigned(Item) and (Item.ImageIndex = iiDatabase);
            MainAction('aFExportSQL').Enabled := (FList.SelCount = 0) or Assigned(Item) and (Item.ImageIndex = iiDatabase);
            MainAction('aFExportText').Enabled := (FList.SelCount = 1) and Assigned(Item) and (Item.ImageIndex = iiDatabase);
            MainAction('aFExportExcel').Enabled := (FList.SelCount = 1) and Assigned(Item) and (Item.ImageIndex = iiDatabase);
            MainAction('aFExportAccess').Enabled := (FList.SelCount = 1) and Assigned(Item) and (Item.ImageIndex = iiDatabase);
            MainAction('aFExportSQLite').Enabled := (FList.SelCount = 1) and Assigned(Item) and (Item.ImageIndex = iiDatabase);
            MainAction('aFExportODBC').Enabled := (FList.SelCount = 1) and Assigned(Item) and (Item.ImageIndex = iiDatabase);
            MainAction('aFExportXML').Enabled := (FList.SelCount = 0) or Assigned(Item) and (Item.ImageIndex = iiDatabase);
            MainAction('aFExportHTML').Enabled := (FList.SelCount = 0) or Assigned(Item) and (Item.ImageIndex = iiDatabase);
            MainAction('aFPrint').Enabled := (FList.SelCount = 0) or Assigned(Item) and (Item.ImageIndex = iiDatabase);
            MainAction('aECopy').Enabled := FList.SelCount >= 1;
            MainAction('aEPaste').Enabled := (not Assigned(Item) and Clipboard.HasFormat(CF_MYSQLSERVER) or Assigned(Item) and (Item.ImageIndex = iiDatabase) and Clipboard.HasFormat(CF_MYSQLDATABASE)) and True;
            MainAction('aDCreateDatabase').Enabled := (FList.SelCount = 0) and (not Assigned(Client.UserRights) or Client.UserRights.RCreate);
            MainAction('aDCreateTable').Enabled := (FList.SelCount = 1) and Assigned(Item) and (Item.ImageIndex = iiDatabase);
            MainAction('aDCreateView').Enabled := (FList.SelCount = 1) and Assigned(Item) and (Item.ImageIndex = iiDatabase) and (Client.ServerVersion >= 50001);
            MainAction('aDCreateProcedure').Enabled := (FList.SelCount = 1) and Assigned(Item) and (Item.ImageIndex = iiDatabase) and (Client.ServerVersion >= 50004);
            MainAction('aDCreateFunction').Enabled := MainAction('aDCreateProcedure').Enabled;
            MainAction('aDCreateEvent').Enabled := (FList.SelCount = 1) and Assigned(Item) and (Item.ImageIndex = iiDatabase) and (Client.ServerVersion >= 50106);
            MainAction('aDCreateHost').Enabled := (FList.SelCount = 1) and Assigned(Item) and (Item.ImageIndex = iiHosts);
            MainAction('aDCreateUser').Enabled := (FList.SelCount = 1) and Assigned(Item) and (Item.ImageIndex = iiUsers);
            MainAction('aDDeleteDatabase').Enabled := (FList.SelCount >= 1) and Assigned(Item) and (Item.ImageIndex = iiDatabase) and True;
            MainAction('aDEditServer').Enabled := (FList.SelCount = 0);
            MainAction('aDEditDatabase').Enabled := (FList.SelCount >= 1) and Assigned(Item) and (Item.ImageIndex = iiDatabase);
            MainAction('aDEmpty').Enabled := (FList.SelCount >= 1) and Assigned(Item) and (Item.ImageIndex = iiDatabase) and True;
            aDDelete.Enabled := MainAction('aDDeleteDatabase').Enabled;

            for I := 0 to FList.Items.Count - 1 do
              if (FList.Items[I].Selected) then
              begin
                MainAction('aFExportSQL').Enabled := MainAction('aFExportSQL').Enabled and (FList.Items[I].ImageIndex in [iiDatabase]);
                MainAction('aFExportText').Enabled := MainAction('aFExportText').Enabled and (FList.Items[I].ImageIndex in [iiDatabase]);
                MainAction('aFExportExcel').Enabled := MainAction('aFExportExcel').Enabled and (FList.Items[I].ImageIndex in [iiDatabase]);
                MainAction('aFExportAccess').Enabled := MainAction('aFExportAccess').Enabled and (FList.Items[I].ImageIndex in [iiDatabase]);
                MainAction('aFExportSQLite').Enabled := MainAction('aFExportSQLite').Enabled and (FList.Items[I].ImageIndex in [iiDatabase]);
                MainAction('aFExportODBC').Enabled := MainAction('aFExportODBC').Enabled and (FList.Items[I].ImageIndex in [iiDatabase]);
                MainAction('aFExportXML').Enabled := MainAction('aFExportXML').Enabled and (FList.Items[I].ImageIndex in [iiDatabase]);
                MainAction('aFExportHTML').Enabled := MainAction('aFExportHTML').Enabled and (FList.Items[I].ImageIndex in [iiDatabase]);
                MainAction('aFPrint').Enabled := MainAction('aFPrint').Enabled and (FList.Items[I].ImageIndex in [iiDatabase]);
                MainAction('aECopy').Enabled := MainAction('aECopy').Enabled and (FList.Items[I].ImageIndex in [iiDatabase, iiSystemDatabase]);
                MainAction('aDDeleteDatabase').Enabled := MainAction('aDDeleteDatabase').Enabled and (FList.Items[I].ImageIndex in [iiDatabase]);
                MainAction('aDEditDatabase').Enabled := MainAction('aDEditDatabase').Enabled and (FList.Items[I].ImageIndex in [iiDatabase]);
                MainAction('aDEmpty').Enabled := MainAction('aDEmpty').Enabled and (FList.Items[I].ImageIndex in [iiDatabase]);
              end;

            mlOpen.Enabled := FList.SelCount = 1;

            if (not Assigned(Item)) then
              mlEProperties.Action := MainAction('aDEditServer')
            else
              mlEProperties.Action := MainAction('aDEditDatabase');
          end;
        iiDatabase,
        iiSystemDatabase:
          begin
            Database := Client.DatabaseByName(SelectedDatabase);

            aPOpenInNewWindow.Enabled := (FList.SelCount = 1) and Selected and Assigned(Item) and (Item.ImageIndex in [iiBaseTable, iiSystemView, iiView, iiProcedure, iiFunction]);
            aPOpenInNewTab.Enabled := aPOpenInNewWindow.Enabled;
            MainAction('aFImportSQL').Enabled := (FList.SelCount = 0) and (SelectedImageIndex = iiDatabase);
            MainAction('aFImportText').Enabled := ((FList.SelCount = 0) or (FList.SelCount = 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiBaseTable));
            MainAction('aFImportExcel').Enabled := ((FList.SelCount = 0) or (FList.SelCount = 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiBaseTable));
            MainAction('aFImportAccess').Enabled := ((FList.SelCount = 0) or (FList.SelCount = 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiBaseTable));
            MainAction('aFImportSQLite').Enabled := ((FList.SelCount = 0) or (FList.SelCount = 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiBaseTable));
            MainAction('aFImportODBC').Enabled := ((FList.SelCount = 0) or (FList.SelCount = 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiBaseTable));
            MainAction('aFImportXML').Enabled := (FList.SelCount = 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiBaseTable);
            MainAction('aFExportSQL').Enabled := ((FList.SelCount = 0) or Selected and Assigned(Item) and (Item.ImageIndex in [iiBaseTable, iiView, iiProcedure, iiFunction, iiEvent, iiTrigger])) and (SelectedImageIndex = iiDatabase);
            MainAction('aFExportText').Enabled := ((FList.SelCount = 0) or Selected and Assigned(Item) and (Item.ImageIndex in [iiBaseTable, iiView])) and (SelectedImageIndex = iiDatabase);
            MainAction('aFExportExcel').Enabled := ((FList.SelCount = 0) or Selected and Assigned(Item) and (Item.ImageIndex in [iiBaseTable, iiView])) and (SelectedImageIndex = iiDatabase);
            MainAction('aFExportAccess').Enabled := ((FList.SelCount = 0) or Selected and Assigned(Item) and (Item.ImageIndex in [iiBaseTable])) and (SelectedImageIndex = iiDatabase);
            MainAction('aFExportSQLite').Enabled := ((FList.SelCount = 0) or Selected and Assigned(Item) and (Item.ImageIndex in [iiBaseTable])) and (SelectedImageIndex = iiDatabase);
            MainAction('aFExportODBC').Enabled := ((FList.SelCount = 0) or Selected and Assigned(Item) and (Item.ImageIndex in [iiBaseTable])) and (SelectedImageIndex = iiDatabase);
            MainAction('aFExportXML').Enabled := ((FList.SelCount = 0) or Selected and Assigned(Item) and (Item.ImageIndex in [iiBaseTable, iiView])) and (SelectedImageIndex = iiDatabase);
            MainAction('aFExportHTML').Enabled := SelectedImageIndex = iiDatabase;
            MainAction('aFPrint').Enabled := SelectedImageIndex = iiDatabase;
            MainAction('aECopy').Enabled := FList.SelCount >= 1;
            MainAction('aEPaste').Enabled := (not Assigned(Item) and Clipboard.HasFormat(CF_MYSQLDATABASE) or Assigned(Item) and ((Item.ImageIndex = iiBaseTable) and Clipboard.HasFormat(CF_MYSQLTABLE) or (Item.ImageIndex = iiView) and Clipboard.HasFormat(CF_MYSQLVIEW))) and True;
            MainAction('aERename').Enabled := Assigned(Item) and (FList.SelCount = 1) and (Item.ImageIndex in [iiBaseTable, iiView, iiEvent]) and True;
            MainAction('aDCreateTable').Enabled := (FList.SelCount = 0) and (SelectedImageIndex = iiDatabase);
            MainAction('aDCreateView').Enabled := (FList.SelCount = 0) and (Client.ServerVersion >= 50001) and (SelectedImageIndex = iiDatabase);
            MainAction('aDCreateProcedure').Enabled := (FList.SelCount = 0) and (Client.ServerVersion >= 50004) and (SelectedImageIndex = iiDatabase);
            MainAction('aDCreateFunction').Enabled := MainAction('aDCreateProcedure').Enabled;
            MainAction('aDCreateEvent').Enabled := (FList.SelCount = 0) and (Client.ServerVersion >= 50106) and (SelectedImageIndex = iiDatabase);
            MainAction('aDCreateIndex').Enabled := (FList.SelCount = 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiBaseTable);
            MainAction('aDCreateField').Enabled := (FList.SelCount = 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiBaseTable);
            MainAction('aDCreateForeignKey').Enabled := (FList.SelCount = 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiBaseTable) and Assigned(Database.BaseTableByName(Item.Caption)) and Assigned(Client.DatabaseByName(SelectedDatabase).BaseTableByName(Item.Caption).Engine) and Client.DatabaseByName(SelectedDatabase).BaseTableByName(Item.Caption).Engine.ForeignKeyAllowed;
            MainAction('aDCreateTrigger').Enabled := (FList.SelCount = 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiBaseTable) and Assigned(Database.Triggers);
            MainAction('aDDeleteTable').Enabled := (FList.SelCount >= 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiBaseTable) and True;
            MainAction('aDDeleteView').Enabled := (FList.SelCount >= 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiView) and True;
            MainAction('aDDeleteRoutine').Enabled := (FList.SelCount >= 1) and Selected and Assigned(Item) and (Item.ImageIndex in [iiProcedure, iiFunction]) and True;
            MainAction('aDDeleteEvent').Enabled := (FList.SelCount = 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiEvent) and True;
            MainAction('aDEditDatabase').Enabled := (FList.SelCount = 0) and (SelectedImageIndex = iiDatabase);
            MainAction('aDEditTable').Enabled := (FList.SelCount >= 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiBaseTable);
            MainAction('aDEditView').Enabled := (FList.SelCount = 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiView);
            MainAction('aDEditRoutine').Enabled := (FList.SelCount = 1) and Selected and Assigned(Item) and (Item.ImageIndex in [iiProcedure, iiFunction]);
            MainAction('aDEditEvent').Enabled := (FList.SelCount = 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiEvent);
            MainAction('aDEmpty').Enabled := (FList.SelCount >= 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiBaseTable);
            aDDelete.Enabled := (FList.SelCount >= 1);

            for I := 0 to FList.Items.Count - 1 do
              if (FList.Items[I].Selected) then
              begin
                MainAction('aFExportSQL').Enabled := MainAction('aFExportSQL').Enabled and (FList.Items[I].ImageIndex in [iiBaseTable, iiView, iiProcedure, iiFunction, iiEvent, iiTrigger]);
                MainAction('aFExportText').Enabled := MainAction('aFExportText').Enabled and (FList.Items[I].ImageIndex in [iiBaseTable, iiView]);
                MainAction('aFExportExcel').Enabled := MainAction('aFExportExcel').Enabled and (FList.Items[I].ImageIndex in [iiBaseTable, iiView]);
                MainAction('aFExportAccess').Enabled := MainAction('aFExportAccess').Enabled and (FList.Items[I].ImageIndex in [iiBaseTable]);
                MainAction('aFExportSQLite').Enabled := MainAction('aFExportSQLite').Enabled and (FList.Items[I].ImageIndex in [iiBaseTable]);
                MainAction('aFExportODBC').Enabled := MainAction('aFExportODBC').Enabled and (FList.Items[I].ImageIndex in [iiBaseTable]);
                MainAction('aFExportXML').Enabled := MainAction('aFExportXML').Enabled and (FList.Items[I].ImageIndex in [iiBaseTable, iiView]);
                MainAction('aFExportHTML').Enabled := MainAction('aFExportHTML').Enabled and (FList.Items[I].ImageIndex in [iiBaseTable, iiView]);
                MainAction('aFPrint').Enabled := MainAction('aFPrint').Enabled and (FList.Items[I].ImageIndex in [iiBaseTable, iiView]);
                MainAction('aECopy').Enabled := MainAction('aECopy').Enabled and (FList.Items[I].ImageIndex in [iiBaseTable, iiSystemView, iiView, iiProcedure, iiFunction, iiEvent]);
                MainAction('aDDeleteTable').Enabled := MainAction('aDDeleteTable').Enabled and (FList.Items[I].ImageIndex in [iiBaseTable]);
                MainAction('aDDeleteView').Enabled := MainAction('aDDeleteView').Enabled and (FList.Items[I].ImageIndex in [iiView]);
                MainAction('aDDeleteRoutine').Enabled := MainAction('aDDeleteRoutine').Enabled and (FList.Items[I].ImageIndex in [iiProcedure, iiFunction]);
                MainAction('aDDeleteEvent').Enabled := MainAction('aDDeleteEvent').Enabled and (FList.Items[I].ImageIndex in [iiEvent]);
                MainAction('aDEditTable').Enabled := MainAction('aDEditTable').Enabled and (FList.Items[I].ImageIndex in [iiBaseTable]);
                MainAction('aDEditView').Enabled := MainAction('aDEditView').Enabled and (FList.Items[I].ImageIndex in [iiView]);
                MainAction('aDEditRoutine').Enabled := MainAction('aDEditRoutine').Enabled and (FList.Items[I].ImageIndex in [iiProcedure, iiFunction]);
                MainAction('aDEditEvent').Enabled := MainAction('aDEditEvent').Enabled and (FList.Items[I].ImageIndex in [iiEvent]);
                MainAction('aDEmpty').Enabled := MainAction('aDEmpty').Enabled and (FList.Items[I].ImageIndex in [iiBaseTable]);
                aDDelete.Enabled := aDDelete.Enabled and not (FList.Items[I].ImageIndex in [iiSystemView]);
              end;

            mlOpen.Enabled := (FList.SelCount = 1) and Selected and Assigned(Item) and (Item.ImageIndex in [iiBaseTable, iiSystemView, iiView, iiProcedure, iiFunction, iiEvent]);

            if (SelectedImageIndex = iiSystemDatabase) then
              mlEProperties.Action := nil
            else if (not Assigned(Item)) then
              mlEProperties.Action := MainAction('aDEditDatabase')
            else
              case (Item.ImageIndex) of
                iiBaseTable,
                iiSystemView: mlEProperties.Action := MainAction('aDEditTable');
                iiView: mlEProperties.Action := MainAction('aDEditView');
                iiProcedure,
                iiFunction: mlEProperties.Action := MainAction('aDEditRoutine');
                iiEvent: mlEProperties.Action := MainAction('aDEditEvent');
              end;
          end;
        iiBaseTable:
          begin
            Database := Client.DatabaseByName(SelectedDatabase);
            BaseTable := Database.BaseTableByName(SelectedTable);

            MainAction('aFImportText').Enabled := (FList.SelCount = 0);
            MainAction('aFImportExcel').Enabled := (FList.SelCount = 0);
            MainAction('aFImportAccess').Enabled := (FList.SelCount = 0);
            MainAction('aFImportSQLite').Enabled := (FList.SelCount = 0);
            MainAction('aFImportODBC').Enabled := (FList.SelCount = 0);
            MainAction('aFImportXML').Enabled := (FList.SelCount = 0);
            MainAction('aFExportSQL').Enabled := (FList.SelCount = 0) or Selected and Assigned(Item) and (Item.ImageIndex in [iiTrigger]);
            MainAction('aFExportText').Enabled := (FList.SelCount = 0);
            MainAction('aFExportExcel').Enabled := (FList.SelCount = 0);
            MainAction('aFExportAccess').Enabled := (FList.SelCount = 0);
            MainAction('aFExportSQLite').Enabled := (FList.SelCount = 0);
            MainAction('aFExportODBC').Enabled := (FList.SelCount = 0);
            MainAction('aFExportXML').Enabled := (FList.SelCount = 0);
            MainAction('aFExportHTML').Enabled := (FList.SelCount = 0);
            MainAction('aECopy').Enabled := (FList.SelCount >= 1);
            MainAction('aEPaste').Enabled := not Assigned(Item) and Clipboard.HasFormat(CF_MYSQLTABLE) and True;
            MainAction('aERename').Enabled := Assigned(Item) and (FList.SelCount = 1) and ((Item.ImageIndex in [iiField, iiTrigger]) or (Item.ImageIndex = iiForeignKey) and (Client.ServerVersion >= 40013)) and True;
            MainAction('aDCreateIndex').Enabled := (FList.SelCount = 0);
            MainAction('aDCreateField').Enabled := (FList.SelCount = 0);
            MainAction('aDCreateForeignKey').Enabled := (FList.SelCount = 0) and Assigned(BaseTable.Engine) and BaseTable.Engine.ForeignKeyAllowed;
            MainAction('aDCreateTrigger').Enabled := (FList.SelCount = 0) and Assigned(Database.Triggers);
            MainAction('aDDeleteIndex').Enabled := (FList.SelCount >= 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiIndex) and True;
            MainAction('aDDeleteField').Enabled := (FList.SelCount >= 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiField) and (BaseTable.Fields.Count > FList.SelCount) and True;
            MainAction('aDDeleteForeignKey').Enabled := (FList.SelCount >= 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiForeignKey) and (Client.ServerVersion >= 40013) and True;
            MainAction('aDDeleteTrigger').Enabled := (FList.SelCount >= 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiTrigger) and True;
            MainAction('aDEditTable').Enabled := (FList.SelCount = 0);
            MainAction('aDEditIndex').Enabled := (FList.SelCount = 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiIndex);
            MainAction('aDEditField').Enabled := (FList.SelCount = 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiField);
            MainAction('aDEditForeignKey').Enabled := (FList.SelCount = 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiForeignKey);
            MainAction('aDEditTrigger').Enabled := (FList.SelCount = 1) and Selected and Assigned(Item) and (Item.ImageIndex = iiTrigger);
            MainAction('aDEmpty').Enabled := (FList.SelCount = 0) or Selected and Assigned(Item) and (Item.ImageIndex = iiField) and (BaseTable.FieldByName(Item.Caption).NullAllowed);
            aDDelete.Enabled := (FList.SelCount >= 1);

            for I := 0 to FList.Items.Count - 1 do
              if (FList.Items[I].Selected) then
              begin
                MainAction('aFExportSQL').Enabled := MainAction('aFExportSQL').Enabled and (FList.Items[I].ImageIndex in [iiTrigger]);
                MainAction('aDDeleteIndex').Enabled := MainAction('aDDeleteIndex').Enabled and (FList.Items[I].ImageIndex in [iiIndex]);
                MainAction('aDDeleteField').Enabled := MainAction('aDDeleteField').Enabled and (FList.Items[I].ImageIndex in [iiField]);
                MainAction('aDDeleteForeignKey').Enabled := MainAction('aDDeleteForeignKey').Enabled and (FList.Items[I].ImageIndex in [iiForeignKey]);
                MainAction('aDEditIndex').Enabled := MainAction('aDEditIndex').Enabled and (FList.Items[I].ImageIndex in [iiIndex]);
                MainAction('aDEditField').Enabled := MainAction('aDEditField').Enabled and (FList.Items[I].ImageIndex in [iiField]);
                MainAction('aDEditForeignKey').Enabled := MainAction('aDEditForeignKey').Enabled and (FList.Items[I].ImageIndex in [iiForeignKey]);
                MainAction('aDEditTrigger').Enabled := MainAction('aDEditTrigger').Enabled and (FList.Items[I].ImageIndex in [iiTrigger]);
                MainAction('aDEmpty').Enabled := MainAction('aDEmpty').Enabled and (FList.Items[I].ImageIndex in [iiField]);
              end;

            mlOpen.Enabled := (FList.SelCount = 1) and Selected and Assigned(Item) and (Item.ImageIndex in [iiForeignKey, iiTrigger]);

            if (not Assigned(Item)) then
              mlEProperties.Action := MainAction('aDEditTable')
            else
              case (Item.ImageIndex) of
                iiIndex: mlEProperties.Action := MainAction('aDEditIndex');
                iiField: mlEProperties.Action := MainAction('aDEditField');
                iiForeignKey: mlEProperties.Action := MainAction('aDEditForeignKey');
                iiTrigger: mlEProperties.Action := MainAction('aDEditTrigger');
              end;
          end;
        iiSystemView:
          begin
            MainAction('aECopy').Enabled := (FList.SelCount >= 1);
          end;
        iiView:
          begin
            MainAction('aFExportSQL').Enabled := (FList.SelCount = 0);
            MainAction('aFExportText').Enabled := (FList.SelCount = 0);
            MainAction('aFExportExcel').Enabled := (FList.SelCount = 0);
            MainAction('aFExportXML').Enabled := (FList.SelCount = 0);
            MainAction('aFExportHTML').Enabled := (FList.SelCount = 0);
            MainAction('aFExportSQLite').Enabled := (FList.SelCount = 0);
            MainAction('aECopy').Enabled := (FList.SelCount >= 1);
            MainAction('aEPaste').Enabled := not Assigned(Item) and Clipboard.HasFormat(CF_MYSQLVIEW) and True;
            MainAction('aDEditView').Enabled := (FList.SelCount = 0);

            mlEProperties.Action := MainAction('aDEditView');
          end;
        iiHosts:
          begin
            MainAction('aECopy').Enabled := (FList.SelCount >= 1);
            MainAction('aEPaste').Enabled := not Assigned(Item) and Clipboard.HasFormat(CF_MYSQLHOSTS) and True;
            MainAction('aDCreateHost').Enabled := (FList.SelCount = 0);
            MainAction('aDDeleteHost').Enabled := (FList.SelCount >= 1) and True;
            MainAction('aDEditHost').Enabled := (FList.SelCount = 1);
            aDDelete.Enabled := (FList.SelCount >= 1) and True;

            mlEProperties.Action := MainAction('aDEditHost');
          end;
        iiProcesses:
          begin
            MainAction('aDDeleteProcess').Enabled := (FList.SelCount >= 1) and Selected and Assigned(Item) and (Trunc(SysUtils.StrToInt(Item.Caption)) <> Client.ThreadId) and True;
            MainAction('aDEditProcess').Enabled := (FList.SelCount = 1);
            aDDelete.Enabled := (FList.SelCount >= 1) and True;

            mlEProperties.Action := MainAction('aDEditProcess');
          end;
        iiUsers:
          begin
            MainAction('aECopy').Enabled := (FList.SelCount >= 1);
            MainAction('aEPaste').Enabled := not Assigned(Item) and Clipboard.HasFormat(CF_MYSQLUSERS) and True;
            MainAction('aDCreateUser').Enabled := (FList.SelCount = 0);
            MainAction('aDDeleteUser').Enabled := (FList.SelCount >= 1) and True;
            MainAction('aDEditUser').Enabled := (FList.SelCount = 1);
            aDDelete.Enabled := (FList.SelCount >= 1) and True;

            mlEProperties.Action := MainAction('aDEditUser');
          end;
        iiVariables:
          begin
            MainAction('aDEditVariable').Enabled := (FList.SelCount = 1);

            mlEProperties.Action := MainAction('aDEditVariable');
          end;
      end;

    mlOpen.Default := mlOpen.Enabled and not (Assigned(Item) and (Item.ImageIndex = iiForeignKey));
    mlEProperties.Default := Assigned(Item) and not mlOpen.Default and mlEProperties.Enabled;
    mlEProperties.Caption := Preferences.LoadStr(97) + '...';
    mlEProperties.ShortCut := ShortCut(VK_RETURN, [ssAlt]);

    ToolBarData.tbPropertiesAction := mlEProperties.Action;
    Window.Perform(CM_UPDATETOOLBAR, 0, LPARAM(Self));

    ShowEnabledItems(MList.Items);

    if (Sender <> MList) then
      StatusBarRefresh();
  end;
end;

procedure TFClient.FLogEnter(Sender: TObject);
begin
  MainAction('aECopyToFile').OnExecute := SaveSQLFile;
  MainAction('aSGoto').OnExecute := TSymMemoGotoExecute;

  MainAction('aFPrint').Enabled := True;
  MainAction('aSSearchReplace').Enabled := False;
  MainAction('aSGoto').Enabled := True;

  FLogSelectionChange(Sender);
  StatusBarRefresh();
end;

procedure TFClient.FLogExit(Sender: TObject);
begin
  MainAction('aFPrint').Enabled := False;
  MainAction('aECopyToFile').Enabled := False;
  MainAction('aSGoto').Enabled := False;
end;

procedure TFClient.FLogSelectionChange(Sender: TObject);
begin
  if (PLog.Visible and (Window.ActiveControl = FLog)) then
    MainAction('aECopyToFile').Enabled := FLog.SelText <> '';
end;

procedure TFClient.FNavigatorChange(Sender: TObject; Node: TTreeNode);
begin
  if (not (tsLoading in FrameState)) then
  begin
    FNavigatorMenuNode := Node;

    KillTimer(Handle, tiNavigator);
//    if (not UseNavigatorTimer) then
      FNavigatorChange2(Sender, Node)
//    else
//    begin
//      SetTimer(Self.Handle, tiNavigator, 500, nil);
//      UseNavigatorTimer := False;
//    end;
  end;
end;

procedure TFClient.FNavigatorChange2(Sender: TObject; Node: TTreeNode);
begin
  KillTimer(Handle, tiNavigator);

  if (Assigned(Node)) then
    Address := NavigatorNodeToAddress(Node)
  else
    Wanted.Address := NavigatorNodeToAddress(Node);
end;

procedure TFClient.FNavigatorChanging(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
begin
  AllowChange := AllowChange and not Dragging(Sender) and not (Assigned(Node) and (Node.ImageIndex in [iiIndex, iiField, iiSystemViewField, iiViewField, iiForeignKey]));

  if (AllowChange and Assigned(FGrid.DataSource.DataSet) and FGrid.DataSource.DataSet.Active) then
    try
      if ((Window.ActiveControl = FText) or (Window.ActiveControl = FRTF) or (Window.ActiveControl = FHexEditor)) then
        Window.ActiveControl := FGrid;
      FGrid.DataSource.DataSet.CheckBrowseMode();
    except
      AllowChange := False;
    end;
end;

procedure TFClient.FNavigatorDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  I: Integer;
  Objects: string;
  SourceNode: TTreeNode;
  TargetNode: TTreeNode;
begin
  if (Sender = FNavigator) then
    TargetNode := FNavigator.GetNodeAt(X, Y)
  else if (Sender = FList) then
    TargetNode := FNavigator.Selected
  else
    TargetNode := nil;

  if ((Source is TTreeView_Ext) and (TTreeView_Ext(Source).Name = FNavigator.Name)) then
  begin
    SourceNode := TFClient(TTreeView_Ext(Source).Owner).MouseDownNode;

    case (SourceNode.ImageIndex) of
      iiDatabase,
      iiSystemView: Objects := Objects + 'Database='    + SourceNode.Text + #13#10;
      iiBaseTable:  Objects := Objects + 'Table='       + SourceNode.Text + #13#10;
      iiView:       Objects := Objects + 'View='        + SourceNode.Text + #13#10;
      iiProcedure:  Objects := Objects + 'Procedure='   + SourceNode.Text + #13#10;
      iiFunction:   Objects := Objects + 'Function='    + SourceNode.Text + #13#10;
      iiEvent:      Objects := Objects + 'Event='       + SourceNode.Text + #13#10;
      iiIndex:      Objects := Objects + 'Index='       + SourceNode.Text + #13#10;
      iiField,
      iiViewField:  Objects := Objects + 'Field='       + SourceNode.Text + #13#10;
      iiForeignKey: Objects := Objects + 'ForeignKey='  + SourceNode.Text + #13#10;
      iiTrigger:    Objects := Objects + 'Trigger='     + SourceNode.Text + #13#10;
      iiHost:       Objects := Objects + 'Host='        + SourceNode.Text + #13#10;
      iiUser:       Objects := Objects + 'User='        + SourceNode.Text + #13#10;
    end;
    if (Objects <> '') then
      Objects := 'Address=' + NavigatorNodeToAddress(SourceNode) + #13#10 + Objects;
  end
  else if ((Source is TListView) and (TListView(Source).Name = 'FList')) then
  begin
    SourceNode := TFClient(TComponent(TListView(Source).Owner)).FNavigator.Selected;

    for I := 0 to TListView(Source).Items.Count - 1 do
      if (TListView(Source).Items[I].Selected) then
        case (TListView(Source).Items[I].ImageIndex) of
          iiDatabase,
          iiSystemView: Objects := Objects + 'Database='   + TListView(Source).Items[I].Caption + #13#10;
          iiBaseTable:  Objects := Objects + 'Table='      + TListView(Source).Items[I].Caption + #13#10;
          iiView:       Objects := Objects + 'View='       + TListView(Source).Items[I].Caption + #13#10;
          iiProcedure:  Objects := Objects + 'Procedure='  + TListView(Source).Items[I].Caption + #13#10;
          iiFunction:   Objects := Objects + 'Function='   + TListView(Source).Items[I].Caption + #13#10;
          iiEvent:      Objects := Objects + 'Event='      + TListView(Source).Items[I].Caption + #13#10;
          iiIndex:      Objects := Objects + 'Index='      + Client.DatabaseByName(SelectedDatabase).BaseTableByName(SelectedTable).IndexByCaption(TListView(Source).Items[I].Caption).Name + #13#10;
          iiField,
          iiViewField:  Objects := Objects + 'Field='      + TListView(Source).Items[I].Caption + #13#10;
          iiForeignKey: Objects := Objects + 'ForeignKey=' + TListView(Source).Items[I].Caption + #13#10;
          iiTrigger:    Objects := Objects + 'Trigger='    + TListView(Source).Items[I].Caption + #13#10;
          iiHost:       Objects := Objects + 'Host='       + Client.HostByCaption(TListView(Source).Items[I].Caption).Name + #13#10;
          iiUser:       Objects := Objects + 'User='       + TListView(Source).Items[I].Caption + #13#10;
        end;
    if (Objects <> '') then
      Objects := 'Address=' + NavigatorNodeToAddress(SourceNode) + #13#10 + Objects;
  end;

  if (Objects <> '') then
    PasteExecute(TargetNode, Objects);
end;

procedure TFClient.FNavigatorDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  SourceNode: TTreeNode;
  TargetNode: TTreeNode;
begin
  Accept := False;

  TargetNode := TTreeView_Ext(Sender).GetNodeAt(X, Y);

  if (Source is TTreeView_Ext and (TTreeView_Ext(Source).Name = FNavigator.Name)) then
  begin
    SourceNode := TFClient(TTreeView_Ext(Source).Owner).MouseDownNode;
    if (Assigned(TargetNode) and (TargetNode <> SourceNode)) then
      case (SourceNode.ImageIndex) of
        iiDatabase: Accept := (TargetNode = TTreeView_Ext(Sender).Items.getFirstNode()) and (TargetNode <> SourceNode.Parent);
        iiBaseTable: Accept := (TargetNode.ImageIndex = iiDatabase) and (TargetNode <> SourceNode.Parent) or (TargetNode.ImageIndex = iiBaseTable) and (TargetNode <> SourceNode);
        iiProcedure,
        iiFunction: Accept := (TargetNode.ImageIndex = iiDatabase) and (TargetNode <> SourceNode.Parent);
        iiField: Accept := (TargetNode.ImageIndex = iiBaseTable) and (TargetNode <> SourceNode.Parent);
      end;
  end
  else if ((Source is TListView) and (TListView(Source).Name = FList.Name)) then
    Accept := ((TFClient(TListView(Source).Owner).Client <> Client) or (TFClient(TListView(Source).Owner).FNavigator.Selected <> TargetNode))
      and (TFClient(TListView(Source).Owner).FNavigator.Selected.ImageIndex = SelectedImageIndex);
end;

procedure TFClient.FNavigatorEdited(Sender: TObject; Node: TTreeNode; var S: string);
begin
  if (not RenameCItem(FocusedCItem, S)) then
    S := Node.Text;
end;

procedure TFClient.FNavigatorEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
  AllowEdit := (Node.ImageIndex = iiDatabase) and (Client.ServerVersion >= 50107) or (Node.ImageIndex = iiForeignKey) and (Client.ServerVersion >= 40013) or (Node.ImageIndex in [iiBaseTable, iiView, iiEvent, iiTrigger, iiField]);
end;

procedure TFClient.FNavigatorEmptyExecute(Sender: TObject);
var
  Database: TCDatabase;
  Field: TCBaseTableField;
  Table: TCBaseTable;
begin
  Wanted.Clear();

  if (FocusedCItem is TCDatabase) then
  begin
    Database := TCDatabase(FocusedCItem);
    if (MsgBox(Preferences.LoadStr(374, Database.Name), Preferences.LoadStr(101), MB_YESNOCANCEL + MB_ICONQUESTION) = IDYES) then
      Database.EmptyTables([]);
  end
  else if (FocusedCItem is TCBaseTable) then
  begin
    Table := TCBaseTable(FocusedCItem);
    if (MsgBox(Preferences.LoadStr(375, Table.Name), Preferences.LoadStr(101), MB_YESNOCANCEL + MB_ICONQUESTION) = IDYES) then
      Table.Empty();
  end
  else if (FocusedCItem is TCBaseTableField) then
  begin
    Field := TCBaseTableField(FocusedCItem);
    Table := Field.Table;
    if (Assigned(Field) and (MsgBox(Preferences.LoadStr(376, Field.Name), Preferences.LoadStr(101), MB_YESNOCANCEL + MB_ICONQUESTION) = IDYES)) then
    begin
      Table.EmptyFields([Field.Name]);
      PContentRefresh(Sender);
    end;
  end;
end;

procedure TFClient.FNavigatorEnter(Sender: TObject);
begin
  MainAction('aDEmpty').OnExecute := FNavigatorEmptyExecute;

  aDDelete.ShortCut := VK_DELETE;

  FNavigatorSetMenuItems(Sender, FNavigator.Selected);
  StatusBarRefresh();
end;

procedure TFClient.FNavigatorExit(Sender: TObject);
begin
  MainAction('aFImportSQL').Enabled := False;
  MainAction('aFImportText').Enabled := False;
  MainAction('aFImportExcel').Enabled := False;
  MainAction('aFImportAccess').Enabled := False;
  MainAction('aFImportSQLite').Enabled := False;
  MainAction('aFImportODBC').Enabled := False;
  MainAction('aFImportXML').Enabled := False;
  MainAction('aFExportSQL').Enabled := False;
  MainAction('aFExportText').Enabled := False;
  MainAction('aFExportExcel').Enabled := False;
  MainAction('aFExportAccess').Enabled := False;
  MainAction('aFExportSQLite').Enabled := False;
  MainAction('aFExportODBC').Enabled := False;
  MainAction('aFExportXML').Enabled := False;
  MainAction('aFExportHTML').Enabled := False;
  MainAction('aFPrint').Enabled := False;
  MainAction('aECopy').Enabled := False;
  MainAction('aEPaste').Enabled := False;
  MainAction('aERename').Enabled := False;
  MainAction('aDCreateDatabase').Enabled := False;
  MainAction('aDCreateTable').Enabled := False;
  MainAction('aDCreateView').Enabled := False;
  MainAction('aDCreateProcedure').Enabled := False;
  MainAction('aDCreateFunction').Enabled := False;
  MainAction('aDCreateEvent').Enabled := False;
  MainAction('aDCreateTrigger').Enabled := False;
  MainAction('aDCreateIndex').Enabled := False;
  MainAction('aDCreateField').Enabled := False;
  MainAction('aDCreateForeignKey').Enabled := False;
  MainAction('aDCreateHost').Enabled := False;
  MainAction('aDCreateUser').Enabled := False;
  MainAction('aDDeleteDatabase').Enabled := False;
  MainAction('aDDeleteTable').Enabled := False;
  MainAction('aDDeleteView').Enabled := False;
  MainAction('aDDeleteRoutine').Enabled := False;
  MainAction('aDDeleteEvent').Enabled := False;
  MainAction('aDDeleteIndex').Enabled := False;
  MainAction('aDDeleteField').Enabled := False;
  MainAction('aDDeleteForeignKey').Enabled := False;
  MainAction('aDDeleteTrigger').Enabled := False;
  MainAction('aDEditServer').Enabled := False;
  MainAction('aDEditDatabase').Enabled := False;
  MainAction('aDEditTable').Enabled := False;
  MainAction('aDEditView').Enabled := False;
  MainAction('aDEditRoutine').Enabled := False;
  MainAction('aDEditEvent').Enabled := False;
  MainAction('aDEditTrigger').Enabled := False;
  MainAction('aDEditIndex').Enabled := False;
  MainAction('aDEditField').Enabled := False;
  MainAction('aDEditForeignKey').Enabled := False;
  MainAction('aDEditHost').Enabled := False;
  MainAction('aDEditProcess').Enabled := False;
  MainAction('aDEditUser').Enabled := False;
  MainAction('aDEditVariable').Enabled := False;
  MainAction('aDEmpty').Enabled := False;

  aDDelete.ShortCut := 0;
end;

procedure TFClient.FNavigatorExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
var
  Database: TCDatabase;
  Table: TCTable;
begin
  if (Node.HasChildren) then
  begin
    case (Node.ImageIndex) of
      iiDatabase,
      iiSystemDatabase:
        begin
          Database := Client.DatabaseByName(Node.Text);
          AllowExpansion := not Database.Initialize();
        end;
      iiBaseTable,
      iiSystemView,
      iiView:
        begin
          Database := Client.DatabaseByName(Node.Parent.Text);
          Table := Database.TableByName(Node.Text);
          AllowExpansion := not Table.Initialize();
        end;
    end;

    if (not AllowExpansion and (Sender = FNavigator)) then
      Wanted.FNavigatorNodeExpand := NavigatorNodeToAddress(Node);
  end;
end;

procedure TFClient.FNavigatorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (not TTreeView(Sender).IsEditing()) then
    if ((Key = Ord('C')) and (Shift = [ssCtrl]) or (Key = VK_INSERT) and (Shift = [ssCtrl])) then
      begin aECopyExecute(Sender); Key := 0; end
    else if ((Key = Ord('V')) and (Shift = [ssCtrl]) or (Key = VK_INSERT) and (Shift = [ssShift])) then
      begin aEPasteExecute(Sender); Key := 0; end
    else if (not (Key in [VK_SHIFT, VK_CONTROL])) then
      UseNavigatorTimer := True;
end;

procedure TFClient.FNavigatorKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #3) then Key := #0; // Why is threre a Beep on <Ctrl+C> without this?
end;

procedure TFClient.FNavigatorRefresh(const Event: TCClient.TEvent);
var
  Child: TTreeNode;
  Database: TCDatabase;
  DatabaseNode: TTreeNode;
  ExpandingEvent: TTVExpandingEvent;
  I: Integer;
  Node: TTreeNode;
  Sibling: TTreeNode;
  Table: TCTable;
begin
  FNavigator.Items.BeginUpdate();

  if (FNavigator.Items.Count = 0) then
  begin
    Node := FNavigator.Items.Add(nil, Client.Caption);
    Node.HasChildren := True;
    Node.ImageIndex := iiServer;
  end;

  if (Event.Sender is TCDatabases) then
  begin
    Node := FNavigator.Items.getFirstNode();

    if (Node.Count = 0) then
    begin
      if (Assigned(Client.Hosts)) then
        FNavigator.Items.AddChild(Node, Preferences.LoadStr(335)).ImageIndex := iiHosts;
      if (Assigned(Client.Processes)) then
        FNavigator.Items.AddChild(Node, Preferences.LoadStr(24)).ImageIndex := iiProcesses;
      FNavigator.Items.AddChild(Node, Preferences.LoadStr(23)).ImageIndex := iiStati;
      if (Assigned(Client.Users)) then
        FNavigator.Items.AddChild(Node, ReplaceStr(Preferences.LoadStr(561), '&', '')).ImageIndex := iiUsers;
      FNavigator.Items.AddChild(Node, Preferences.LoadStr(22)).ImageIndex := iiVariables;
      Node.Expand(False);
    end;

    if (Event.EventType in [ceBuild, ceDroped]) then
    begin
      Child := Node.getFirstChild();
      while (Assigned(Child) and (Child.ImageIndex in [iiDatabase, iiSystemDatabase])) do
      begin
        Sibling := Child.getNextSibling();
        if (not Assigned(Client.DatabaseByName(Child.Text)) or (Event.EventType = ceDroped) and (Event.CItem = Client.DatabaseByName(Child.Text))) then
          Child.Delete();
        Child := Sibling;
      end;
    end;
    if (Event.EventType in [ceBuild, ceCreated]) then
    begin
      for I := 0 to Client.Databases.Count - 1 do
      begin
        Child := Node.getFirstChild();
        while (Assigned(Child) and (Child.ImageIndex in [iiDatabase, iiSystemDatabase]) and (Client.TableNameCmp(Client.Databases[I].Name, Child.Text) > 0)) do
          Child := Child.getNextSibling();
        if (not Assigned(Child)) then
          Child := FNavigator.Items.AddChild(Node, Client.Databases[I].Name)
        else if (not (Child.ImageIndex in [iiDatabase, iiSystemDatabase]) or (Client.TableNameCmp(Client.Databases[I].Name, Child.Text) < 0)) then
          Child := FNavigator.Items.Insert(Child, Client.Databases[I].Name)
        else
          Child := nil;
        if (Assigned(Child)) then
        begin
          Child.HasChildren := True;
          if (Client.Databases[I] is TCSystemDatabase) then
            Child.ImageIndex := iiSystemDatabase
          else
            Child.ImageIndex := iiDatabase;
        end;
      end;

      ExpandingEvent := FNavigator.OnExpanding;
      FNavigator.OnExpanding := nil;
      Node.Expand(False);
      FNavigator.OnExpanding := ExpandingEvent;
    end;

    Node.HasChildren := Node.Count > 0;
  end
  else if ((Event.Sender is TCTables) or (Event.Sender is TCRoutines) or (Event.Sender is TCEvents)) then
  begin
    Database := TCDBObjects(Event.Sender).Database;

    Node := FNavigator.Items.getFirstNode().getFirstChild();
    while (Assigned(Node) and (Node.ImageIndex in [iiDatabase, iiSystemDatabase]) and (Node.Text <> Database.Name)) do
      Node := Node.getNextSibling();

    if (Assigned(Node)) then
    begin
      if (Event.Sender is TCTables) then
      begin
        if (Event.EventType in [ceBuild, ceDroped]) then
        begin
          Child := Node.getFirstChild();
          while (Assigned(Child) and (Child.ImageIndex in [iiBaseTable, iiSystemView, iiView])) do
          begin
            Sibling := Child.getNextSibling();
            if (not Assigned(Database.TableByName(Child.Text)) or (Event.EventType = ceDroped) and (Event.CItem = Database.TableByName(Child.Text))) then
              Child.Delete();
            Child := Sibling;
          end;
        end;
        if (Event.EventType in [ceBuild, ceCreated]) then
          for I := 0 to Database.Tables.Count - 1 do
          begin
            Child := Node.getFirstChild();
            while (Assigned(Child) and (Child.ImageIndex in [iiBaseTable, iiSystemView, iiView]) and (Client.TableNameCmp(Database.Tables[I].Name, Child.Text) > 0)) do
              Child := Child.getNextSibling();
            if (not Assigned(Child)) then
              Child := FNavigator.Items.AddChild(Node, Database.Tables[I].Name)
            else if (Client.TableNameCmp(Database.Tables[I].Name, Child.Text) <> 0) then
              Child := FNavigator.Items.Insert(Child, Database.Tables[I].Name)
            else
              Child := nil;
            if (Assigned(Child)) then
            begin
              Child.HasChildren := True;
              if (Database.Tables[I] is TCSystemView) then
                Child.ImageIndex := iiSystemView
              else if (Database.Tables[I] is TCBaseTable) then
                Child.ImageIndex := iiBaseTable
              else
                Child.ImageIndex := iiView;
            end;
          end;
      end
      else if (Event.Sender is TCRoutines) then
      begin
        if (Event.EventType in [ceBuild, ceDroped]) then
        begin
          Child := Node.getFirstChild();
          while (Assigned(Child) and (Child.ImageIndex in [iiBaseTable, iiSystemView, iiView])) do
            Child := Child.getNextSibling();
          while (Assigned(Child) and (Child.ImageIndex in [iiProcedure, iiFunction])) do
          begin
            Sibling := Child.getNextSibling();
            if ((Child.ImageIndex = iiProcedure) and (not Assigned(Database.ProcedureByName(Child.Text)) or (Event.EventType = ceDroped) and (Event.CItem = Database.ProcedureByName(Child.Text)))
              or (Child.ImageIndex = iiFunction) and (not Assigned(Database.FunctionByName(Child.Text)) or (Event.EventType = ceDroped) and (Event.CItem = Database.FunctionByName(Child.Text)))) then
              Child.Delete();
            Child := Sibling;
          end;
        end;
        if (Event.EventType in [ceBuild, ceCreated]) then
          for I := 0 to Database.Routines.Count - 1 do
          begin
            Child := Node.getFirstChild();
            while (Assigned(Child) and not (Child.ImageIndex in [iiProcedure, iiFunction])) do
              Child := Child.getNextSibling();
            while (Assigned(Child) and (Child.ImageIndex in [iiProcedure, iiFunction]) and (lstrcmpi(PChar(Database.Routines[I].Name), PChar(Child.Text)) > 0)) do
              Child := Child.getNextSibling();
            if (not Assigned(Child)) then
              Child := FNavigator.Items.AddChild(Node, Database.Routines[I].Name)
            else if (lstrcmpi(PChar(Database.Routines[I].Name), PChar(Child.Text)) <> 0) then
              Child := FNavigator.Items.Insert(Child, Database.Routines[I].Name)
            else
              Child := nil;
            if (Assigned(Child)) then
              if (Database.Routines[I] is TCProcedure) then
                Child.ImageIndex := iiProcedure
              else
                Child.ImageIndex := iiFunction;
          end;
      end
      else if (Event.Sender is TCEvents) then
      begin
        if (Event.EventType in [ceBuild, ceDroped]) then
        begin
          Child := Node.getFirstChild();
          while (Assigned(Child) and (Child.ImageIndex in [iiBaseTable, iiSystemView, iiView, iiProcedure, iiFunction])) do
            Child := Child.getNextSibling();
          while (Assigned(Child) and (Child.ImageIndex in [iiEvent])) do
          begin
            Sibling := Child.getNextSibling();
            if (not Assigned(Database.EventByName(Child.Text)) or (Event.EventType = ceDroped) and (Event.CItem = Database.EventByName(Child.Text))) then
              Child.Delete();
            Child := Sibling;
          end;
        end;
        if (Event.EventType in [ceBuild, ceCreated]) then
          for I := 0 to Database.Events.Count - 1 do
          begin
            Child := Node.getFirstChild();
            while (Assigned(Child) and not (Child.ImageIndex in [iiEvent])) do
              Child := Child.getNextSibling();
            while (Assigned(Child) and (Child.ImageIndex in [iiEvent]) and (lstrcmpi(PChar(Database.Events[I].Name), PChar(Child.Text)) > 0)) do
              Child := Child.getNextSibling();
            if (not Assigned(Child)) then
              Child := FNavigator.Items.AddChild(Node, Database.Events[I].Name)
            else if (lstrcmpi(PChar(Database.Events[I].Name), PChar(Child.Text)) <> 0) then
              Child := FNavigator.Items.Insert(Child, Database.Events[I].Name)
            else
              Child := nil;
            if (Assigned(Child)) then
              Child.ImageIndex := iiEvent;
          end;
      end;

      Node.HasChildren := (Node.Count > 0)
        or not Database.Tables.Actual or (Database.Tables.Count > 0)
        or (Assigned(Database.Routines) and ((Database.Routines.Count > 0) or not Database.Routines.Actual))
        or (Assigned(Database.Events) and ((Database.Events.Count > 0) or not Database.Events.Actual));
    end;
  end
  else if (Event.Sender is TCTriggers) then
  begin
    Database := TCTriggers(Event.Sender).Database;

    DatabaseNode := FNavigator.Items.getFirstNode().getFirstChild();
    while (Assigned(DatabaseNode) and (DatabaseNode.ImageIndex in [iiDatabase, iiSystemDatabase]) and (DatabaseNode.Text <> Database.Name)) do
      DatabaseNode := DatabaseNode.getNextSibling();

    if (not Assigned(DatabaseNode)) then
      Node := nil
    else
    begin
      Node := DatabaseNode.getFirstChild();
      while (Assigned(Node) and (Node.ImageIndex in [iiBaseTable, iiSystemView, iiView])) do
      begin
        Table := Database.TableByName(Node.Text);

        if (Assigned(Table) and (Table is TCBaseTable)) then
        begin
          if (Event.EventType in [ceBuild, ceDroped]) then
          begin
            Child := Node.getFirstChild();
            while (Assigned(Child) and not (Child.ImageIndex in [iiTrigger])) do
              Child := Child.getNextSibling();
            while (Assigned(Child)) do
            begin
              Sibling := Child.getNextSibling();
              if (not Assigned(Database.TriggerByName(Child.Text))) then
                Child.Delete();
              Child := Sibling;
            end;
          end;

          if (Event.EventType in [ceBuild, ceUpdated, ceCreated]) then
            for I := 0 to Database.Triggers.Count - 1 do
              if (Database.Triggers[I].Table = Table) then
              begin
                Child := Node.getFirstChild();
                while (Assigned(Child) and not (Child.ImageIndex in [iiTrigger])) do
                  Child := Child.getNextSibling();
                while (Assigned(Child) and (Child.ImageIndex in [iiTrigger]) and (lstrcmpi(PChar(Database.Triggers[I].Name), PChar(Child.Text)) > 0)) do
                  Child := Child.getNextSibling();
                if (not Assigned(Child)) then
                  Child := FNavigator.Items.AddChild(Node, Database.Triggers[I].Name)
                else if (lstrcmpi(PChar(Database.Triggers[I].Name), PChar(Child.Text)) <> 0) then
                  Child := FNavigator.Items.Insert(Child, Database.Triggers[I].Name)
                else
                  Child := nil;
                if (Assigned(Child)) then
                  Child.ImageIndex := iiTrigger;
              end;
        end;

        Node := Node.getNextSibling();
      end;
    end;
  end
  else if (Event.Sender is TCTable) then
  begin
    Database := TCTable(Event.Sender).Database;
    Table := TCTable(Event.Sender);

    Node := FNavigator.Items.getFirstNode().getFirstChild();
    while (Assigned(Node) and (Node.ImageIndex in [iiDatabase, iiSystemDatabase]) and (Node.Text <> Database.Name)) do
      Node := Node.getNextSibling();

    if (Assigned(Node)) then
    begin
      Node := Node.getFirstChild();
      while (Assigned(Node) and (Node.ImageIndex in [iiBaseTable, iiSystemView, iiView]) and (Node.Text <> Table.Name)) do
        Node := Node.getNextSibling();

      if (Assigned(Node)) then
      begin
        Node.DeleteChildren();
        Node.HasChildren := True;

        if (Event.Sender is TCBaseTable) then
        begin
          for I := 0 to TCBaseTable(Table).Indices.Count - 1 do
          begin
            Child := FNavigator.Items.AddChild(Node, TCBaseTable(Table).Indices[I].Caption);
            Child.ImageIndex := iiIndex;
          end;
          for I := 0 to TCBaseTable(Table).Fields.Count - 1 do
          begin
            Child := FNavigator.Items.AddChild(Node, TCBaseTable(Table).Fields[I].Name);
            if (Node.ImageIndex = iiSystemView) then
              Child.ImageIndex := iiSystemViewField
            else
              Child.ImageIndex := iiField;
          end;
          for I := 0 to TCBaseTable(Table).ForeignKeys.Count - 1 do
          begin
            Child := FNavigator.Items.AddChild(Node, TCBaseTable(Table).ForeignKeys[I].Name);
            Child.ImageIndex := iiForeignKey;
          end;
          if (Assigned(Database.Triggers)) then
            for I := 0 to Database.Triggers.Count - 1 do
              if (Database.Triggers[I].TableName = TCBaseTable(Table).Name) then
              begin
                Child := FNavigator.Items.AddChild(Node, Database.Triggers[I].Name);
                Child.ImageIndex := iiTrigger;
              end;
        end
        else if (Event.Sender is TCView) then
          for I := 0 to Table.Fields.Count - 1 do
          begin
            Child := FNavigator.Items.AddChild(Node, Table.Fields[I].Name);
            Child.ImageIndex := iiViewField;
          end;
      end;
    end;
  end
  else
    Node := nil;

  FNavigator.Items.EndUpdate();

  if (Assigned(Node) and (Node = AddressToNavigatorNode(Wanted.FNavigatorNodeExpand)) and (Node.Count > 0)) then
    Wanted.Execute();
end;

procedure TFClient.FNavigatorSetMenuItems(Sender: TObject; const Node: TTreeNode);
begin
  aPExpand.Enabled := Assigned(Node) and (not Assigned(Node) or not Node.Expanded) and (Assigned(Node) and Node.HasChildren);
  aPCollapse.Enabled := Assigned(Node) and (not Assigned(Node) or Node.Expanded) and (Node.ImageIndex <> iiServer);
  aPOpenInNewWindow.Enabled := Assigned(Node) and (Node.ImageIndex in [iiServer, iiDatabase, iiSystemDatabase, iiBaseTable, iiSystemView, iiView, iiProcedure, iiFunction]);
  aPOpenInNewTab.Enabled := aPOpenInNewWindow.Enabled;

  MainAction('aFImportSQL').Enabled := Assigned(Node) and (((Node.ImageIndex = iiServer) and (not Assigned(Client.UserRights) or Client.UserRights.RInsert)) or (Node.ImageIndex = iiDatabase));
  MainAction('aFImportText').Enabled := Assigned(Node) and (Node.ImageIndex in [iiDatabase, iiBaseTable]);
  MainAction('aFImportExcel').Enabled := Assigned(Node) and (Node.ImageIndex in [iiDatabase, iiBaseTable]);
  MainAction('aFImportAccess').Enabled := Assigned(Node) and (Node.ImageIndex in [iiDatabase, iiBaseTable]);
  MainAction('aFImportSQLite').Enabled := Assigned(Node) and (Node.ImageIndex in [iiDatabase, iiBaseTable]);
  MainAction('aFImportODBC').Enabled := Assigned(Node) and (Node.ImageIndex in [iiDatabase, iiBaseTable]);
  MainAction('aFImportXML').Enabled := Assigned(Node) and (Node.ImageIndex in [iiBaseTable]);
  MainAction('aFExportSQL').Enabled := Assigned(Node) and (Node.ImageIndex in [iiServer, iiDatabase, iiBaseTable, iiView, iiProcedure, iiFunction, iiEvent, iiTrigger]);
  MainAction('aFExportText').Enabled := Assigned(Node) and (Node.ImageIndex in [iiDatabase, iiBaseTable, iiView]);
  MainAction('aFExportExcel').Enabled := Assigned(Node) and (Node.ImageIndex in [iiDatabase, iiBaseTable, iiView]);
  MainAction('aFExportAccess').Enabled := Assigned(Node) and (Node.ImageIndex in [iiDatabase, iiBaseTable]);
  MainAction('aFExportSQLite').Enabled := Assigned(Node) and (Node.ImageIndex in [iiDatabase, iiBaseTable, iiView]);
  MainAction('aFExportODBC').Enabled := Assigned(Node) and (Node.ImageIndex in [iiDatabase, iiBaseTable]);
  MainAction('aFExportXML').Enabled := Assigned(Node) and (Node.ImageIndex in [iiServer, iiDatabase, iiBaseTable, iiView]);
  MainAction('aFExportHTML').Enabled := Assigned(Node) and (Node.ImageIndex in [iiServer, iiDatabase, iiBaseTable, iiView]);
  MainAction('aFPrint').Enabled := Assigned(Node) and ((View = avDiagram) or (Node.ImageIndex in [iiServer, iiDatabase, iiBaseTable, iiView]));
  MainAction('aECopy').Enabled := Assigned(Node) and (Node.ImageIndex in [iiDatabase, iiSystemDatabase, iiBaseTable, iiSystemView, iiView, iiProcedure, iiFunction, iiEvent, iiTrigger, iiField, iiSystemViewField, iiViewField, iiHost, iiUser]);
  MainAction('aEPaste').Enabled := Assigned(Node) and ((Node.ImageIndex = iiServer) and Clipboard.HasFormat(CF_MYSQLSERVER) or (Node.ImageIndex = iiDatabase) and Clipboard.HasFormat(CF_MYSQLDATABASE) or (Node.ImageIndex = iiBaseTable) and Clipboard.HasFormat(CF_MYSQLTABLE) or (Node.ImageIndex = iiHosts) and Clipboard.HasFormat(CF_MYSQLHOSTS) or (Node.ImageIndex = iiUsers) and Clipboard.HasFormat(CF_MYSQLUSERS)) and True;
  MainAction('aERename').Enabled := Assigned(Node) and ((Node.ImageIndex = iiForeignKey) and (Client.ServerVersion >= 40013) or (Node.ImageIndex in [iiBaseTable, iiView, iiEvent, iiTrigger, iiField])) and True;
  MainAction('aDCreateDatabase').Enabled := Assigned(Node) and (Node.ImageIndex in [iiServer]) and (not Assigned(Client.UserRights) or Client.UserRights.RCreate);
  MainAction('aDCreateTable').Enabled := Assigned(Node) and (Node.ImageIndex = iiDatabase);
  MainAction('aDCreateView').Enabled := Assigned(Node) and (Node.ImageIndex = iiDatabase) and (Client.ServerVersion >= 50001);
  MainAction('aDCreateProcedure').Enabled := Assigned(Node) and (Node.ImageIndex = iiDatabase) and (Client.ServerVersion >= 50004);
  MainAction('aDCreateFunction').Enabled := MainAction('aDCreateProcedure').Enabled;
  MainAction('aDCreateEvent').Enabled := Assigned(Node) and (Node.ImageIndex = iiDatabase) and (Client.ServerVersion >= 50106);
  MainAction('aDCreateTrigger').Enabled := Assigned(Node) and (Node.ImageIndex = iiBaseTable) and Assigned(Client.DatabaseByName(Node.Parent.Text).Triggers);
  MainAction('aDCreateIndex').Enabled := Assigned(Node) and (Node.ImageIndex = iiBaseTable);
  MainAction('aDCreateField').Enabled := Assigned(Node) and (Node.ImageIndex = iiBaseTable);
  MainAction('aDCreateForeignKey').Enabled := Assigned(Node) and (Node.ImageIndex in [iiBaseTable]) and Assigned(Client.DatabaseByName(Node.Parent.Text).BaseTableByName(Node.Text)) and Assigned(Client.DatabaseByName(Node.Parent.Text).BaseTableByName(Node.Text).Engine) and Client.DatabaseByName(Node.Parent.Text).BaseTableByName(Node.Text).Engine.ForeignKeyAllowed;
  MainAction('aDCreateHost').Enabled := Assigned(Node) and (Node.ImageIndex = iiHosts);
  MainAction('aDCreateUser').Enabled := Assigned(Node) and (Node.ImageIndex = iiUsers);
  MainAction('aDDeleteDatabase').Enabled := Assigned(Node) and (Node.ImageIndex = iiDatabase) and True;
  MainAction('aDDeleteTable').Enabled := Assigned(Node) and (Node.ImageIndex = iiBaseTable) and True;
  MainAction('aDDeleteView').Enabled := Assigned(Node) and (Node.ImageIndex = iiView) and True;
  MainAction('aDDeleteRoutine').Enabled := Assigned(Node) and (Node.ImageIndex in [iiProcedure, iiFunction]) and True;
  MainAction('aDDeleteEvent').Enabled := Assigned(Node) and (Node.ImageIndex = iiEvent) and True;
  MainAction('aDDeleteIndex').Enabled := Assigned(Node) and (Node.ImageIndex = iiIndex) and True;
  MainAction('aDDeleteField').Enabled := Assigned(Node) and (Node.ImageIndex = iiField) and (Client.DatabaseByName(Node.Parent.Parent.Text).TableByName(Node.Parent.Text).Fields.Count > 1) and True;
  MainAction('aDDeleteForeignKey').Enabled := Assigned(Node) and (Node.ImageIndex = iiForeignKey) and (Client.ServerVersion >= 40013) and True;
  MainAction('aDDeleteTrigger').Enabled := Assigned(Node) and (Node.ImageIndex = iiTrigger) and True;
  MainAction('aDDeleteHost').Enabled := False;
  MainAction('aDDeleteUser').Enabled := False;
  MainAction('aDDeleteProcess').Enabled := False;
  MainAction('aDEditServer').Enabled := Assigned(Node) and (Node.ImageIndex = iiServer);
  MainAction('aDEditDatabase').Enabled := Assigned(Node) and (Node.ImageIndex = iiDatabase);
  MainAction('aDEditTable').Enabled := Assigned(Node) and (Node.ImageIndex = iiBaseTable);
  MainAction('aDEditView').Enabled := Assigned(Node) and (Node.ImageIndex = iiView);
  MainAction('aDEditRoutine').Enabled := Assigned(Node) and (Node.ImageIndex in [iiProcedure, iiFunction]);
  MainAction('aDEditEvent').Enabled := Assigned(Node) and (Node.ImageIndex = iiEvent);
  MainAction('aDEditIndex').Enabled := Assigned(Node) and (Node.ImageIndex = iiIndex);
  MainAction('aDEditField').Enabled := Assigned(Node) and (Node.ImageIndex = iiField);
  MainAction('aDEditForeignKey').Enabled := Assigned(Node) and (Node.ImageIndex = iiForeignKey);
  MainAction('aDEditTrigger').Enabled := Assigned(Node) and (Node.ImageIndex = iiTrigger);
  MainAction('aDEmpty').Enabled := Assigned(Node) and (((Node.ImageIndex = iiDatabase) or (Node.ImageIndex = iiBaseTable) or ((Node.ImageIndex = iiField) and Client.DatabaseByName(Node.Parent.Parent.Text).BaseTableByName(Node.Parent.Text).FieldByName(Node.Text).NullAllowed))) and True;

  miNExpand.Default := aPExpand.Enabled;
  miNCollapse.Default := aPCollapse.Enabled;
  aDDelete.Enabled := MainAction('aDDeleteDatabase').Enabled
    or MainAction('aDDeleteTable').Enabled
    or MainAction('aDDeleteView').Enabled
    or MainAction('aDDeleteRoutine').Enabled
    or MainAction('aDDeleteEvent').Enabled
    or MainAction('aDDeleteIndex').Enabled
    or MainAction('aDDeleteField').Enabled
    or MainAction('aDDeleteForeignKey').Enabled
    or MainAction('aDDeleteTrigger').Enabled;
  if (not Assigned(Node)) then
    miNProperties.Action := nil
  else
    case (Node.ImageIndex) of
      iiServer: miNProperties.Action := MainAction('aDEditServer');
      iiDatabase: miNProperties.Action := MainAction('aDEditDatabase');
      iiBaseTable: miNProperties.Action := MainAction('aDEditTable');
      iiView: miNProperties.Action := MainAction('aDEditView');
      iiProcedure,
      iiFunction: miNProperties.Action := MainAction('aDEditRoutine');
      iiEvent: miNProperties.Action := MainAction('aDEditEvent');
      iiTrigger: miNProperties.Action := MainAction('aDEditTrigger');
      iiIndex: miNProperties.Action := MainAction('aDEditIndex');
      iiField: miNProperties.Action := MainAction('aDEditField');
      iiForeignKey: miNProperties.Action := MainAction('aDEditForeignKey');
      iiHost: miNProperties.Action := MainAction('aDEditHost');
      iiProcess: miNProperties.Action := MainAction('aDEditProcess');
      iiUser: miNProperties.Action := MainAction('aDEditUser');
      iiVariable: miNProperties.Action := MainAction('aDEditVariable');
      else miNProperties.Action := nil;
    end;
  miNProperties.Enabled := Assigned(miNProperties.Action);
  miNProperties.Caption := Preferences.LoadStr(97) + '...';
  miNProperties.ShortCut := ShortCut(VK_RETURN, [ssAlt]);

  ToolBarData.tbPropertiesAction := miNProperties.Action;
  Window.Perform(CM_UPDATETOOLBAR, 0, LPARAM(Self));

  ShowEnabledItems(MNavigator.Items);

  miNExpand.Default := miNExpand.Visible;
  miNCollapse.Default := miNCollapse.Visible;

  FNavigator.ReadOnly := not MainAction('aERename').Enabled;
end;

procedure TFClient.FOffsetChange(Sender: TObject);
begin
  if (Assigned(FGrid.DataSource.DataSet)) then
  begin
    FUDOffset.Position := FUDOffset.Position;

    FLimitEnabled.Enabled := FUDLimit.Position > 0;
    FLimitEnabled.Down := (FUDOffset.Position = TMySQLTable(FGrid.DataSource.DataSet).Offset) and (FUDLimit.Position = TMySQLTable(FGrid.DataSource.DataSet).Limit);
  end;
end;

procedure TFClient.FOffsetKeyPress(Sender: TObject; var Key: Char);
begin
  if ((Key = Chr(VK_ESCAPE)) and (TMySQLTable(FGrid.DataSource.DataSet).Limit > 0)) then
  begin
    FUDOffset.Position := FUDOffset.Position;
    FUDLimit.Position := FUDLimit.Position;
    FLimitChange(Sender);

    if (Sender is TEdit) then
    begin
      TEdit(Sender).SelStart := 0;
      TEdit(Sender).SelLength := Length(TEdit(Sender).Text);
    end;
    Key := #0;
  end
  else if ((Key = Chr(VK_RETURN)) and not FLimitEnabled.Down) then
  begin
    FLimitEnabled.Down := True;
    FLimitEnabledClick(Sender);

    if (Sender is TEdit) then
    begin
      TEdit(Sender).SelStart := 0;
      TEdit(Sender).SelLength := Length(TEdit(Sender).Text);
    end;
    Key := #0;
  end;
end;

procedure TFClient.FormClientEvent(const Event: TCClient.TEvent);
var
  Database: TCDatabase;
  Table: TCTable;
begin
  if (not (csDestroying in ComponentState)) then
    case (Event.EventType) of
      ceBuild,
      ceUpdated,
      ceCreated,
      ceDroped:
        ClientRefresh(Event);
      ceInitialize:
        Wanted.Initialize := Event.Initialize;
      ceMonitor:
        PostMessage(Handle, CM_POST_MONITOR, 0, 0)
      else
        begin
          Database := Client.DatabaseByName(SelectedDatabase);
          if (Assigned(Database) and (SelectedTable <> '')) then
          begin
            Table := Database.TableByName(SelectedTable);
            case (Event.EventType) of
              ceBeforeCancel: DataSetBeforeCancel(Table.DataSet);
              ceBeforeReceivingRecords: DataSetBeforeReceivingRecords(Table.DataSet);
              ceBeforePost: DataSetBeforePost(Table.DataSet);
              ceAfterCancel: DataSetAfterCancel(Table.DataSet);
              ceAfterClose: DataSetAfterClose(Table.DataSet);
              ceAfterOpen: DataSetAfterOpen(Table.DataSet);
              ceAfterPost: DataSetAfterPost(Table.DataSet);
              ceAfterScroll: DataSetAfterScroll(Table.DataSet);
            end;
          end;
        end;
    end;
end;

procedure TFClient.FormResize(Sender: TObject);
var
  MaxHeight: Integer;
begin
  if (PSideBar.Visible) then
  begin
    PSideBar.Constraints.MaxWidth := ClientWidth - PContent.Constraints.MinWidth - SSideBar.Width;

    MaxHeight := ClientHeight;
    if (PLog.Visible) then Dec(MaxHeight, PLog.Height);
    if (SLog.Visible) then Dec(MaxHeight, SLog.Height);
    PSideBar.Constraints.MaxHeight := MaxHeight;
    PanelResize(PSideBar);
  end;

  if (PLog.Visible) then
  begin
    PLog.Constraints.MaxHeight := ClientHeight - PHeader.Height - PContent.Constraints.MinHeight - SLog.Height;
    PLogResize(Sender);
  end;
end;

procedure TFClient.FormAccountEvent(const ClassType: TClass);
var
  I: Integer;
  NewListItem: TListItem;
begin
  if (ClassType = Client.Account.Desktop.Bookmarks.ClassType) then
  begin
    FBookmarks.Items.Clear();
    for I := 0 to Client.Account.Desktop.Bookmarks.Count - 1 do
    begin
      NewListItem := FBookmarks.Items.Add();
      NewListItem.Caption := Client.Account.Desktop.Bookmarks[I].Caption;
      NewListItem.ImageIndex := 73;
    end;

    Window.Perform(CM_BOOKMARKCHANGED, 0, 0);
  end;
end;

procedure TFClient.FQuickSearchChange(Sender: TObject);
begin
  FQuickSearchEnabled.Enabled := FQuickSearch.Text <> '';
  FQuickSearchEnabled.Down := (FQuickSearch.Text <> '') and (FGrid.DataSource.DataSet is TCTableDataSet) and (FQuickSearch.Text = TCTableDataSet(FGrid.DataSource.DataSet).QuickSearch);
end;

procedure TFClient.FQuickSearchEnabledClick(Sender: TObject);
begin
  Wanted.Clear();

  TableOpen(Sender);
  Window.ActiveControl := FQuickSearch;
end;

procedure TFClient.FQuickSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = Chr(VK_ESCAPE)) then
  begin
    FQuickSearch.Text := '';
    if ((FGrid.DataSource.DataSet is TCTableDataSet) and (TCTableDataSet(FGrid.DataSource.DataSet).QuickSearch <> '')) then
      FQuickSearchEnabled.Click();

    Key := #0;
  end
  else if ((Key = Chr(VK_RETURN)) and not FQuickSearchEnabled.Down) then
  begin
    FQuickSearchEnabled.Down := True;
    FQuickSearchEnabled.Click();

    FQuickSearch.SelStart := 0;
    FQuickSearch.SelLength := Length(FQuickSearch.Text);
    Key := #0;
  end;
end;

procedure TFClient.FRTFChange(Sender: TObject);
begin
  FRTF.ReadOnly := True;
{
  FRTF.Text ist nicht der RTF SourceCode!
  FRTF.ReadOnly := not Assigned(FGrid.DataSource.DataSet) or not FGrid.DataSource.DataSet.CanModify;
  if (not FRTF.ReadOnly and (FRTF.Text <> EditorField.OldValue)) then
    FGrid.DataSource.DataSet.Edit();
}
end;

procedure TFClient.FRTFEnter(Sender: TObject);
begin
  FRTFChange(nil);

  StatusBarRefresh();
end;

procedure TFClient.FRTFExit(Sender: TObject);
begin
{
  FRTF.Text ist nicht der RTF SourceCode!
  if (FRTF.Modified) then
    EditorField.AsString := FRTF.Text;
}

  SendMessage(FRTF.Handle, WM_VSCROLL, SB_TOP, 0);
end;

procedure TFClient.FRTFShow(Sender: TObject);
var
  TempFRTFOnChange: TNotifyEvent;
begin
  TempFRTFOnChange := FRTF.OnChange; FRTF.OnChange := nil;

  if (not Assigned(EditorField) or EditorField.IsNull) then
  begin
    FRTF.Text := '';
    FRTF.ReadOnly := False;
  end
  else
  begin
    FRTF.Text := EditorField.AsString;
    FRTF.ReadOnly := EditorField.ReadOnly or not EditorField.DataSet.CanModify;
  end;
  FRTF.SelectAll();

  FRTF.OnChange := TempFRTFOnChange;
end;

procedure TFClient.FSQLEditorCompletionClose(Sender: TObject);
begin
  FSQLEditorEnter(Sender);
end;

procedure TFClient.FSQLEditorCompletionExecute(Kind: SynCompletionType;
  Sender: TObject; var CurrentInput: string; var x, y: Integer;
  var CanExecute: Boolean);
var
  Attri: TSynHighlighterAttributes;
  Database: TCDatabase;
  DMLStmt: TSQLDMLStmt;
  I: Integer;
  Identifier: string;
  Index: Integer;
  J: Integer;
  Len: Integer;
  Owner: string;
  Parse: TSQLParse;
  QueryBuilder: TacQueryBuilder;
  S: string;
  SQL: string;
  StringList: TStringList;
  Table: TCTable;
  Tables: array of TCTable;
  Token: string;
begin
  SetLength(Tables, 0);

  Index := 1; Len := 0;
  try
    SQL := SynMemo.Text; // Sometimes this forces in exception SynGetText / GetSelAvail
    repeat
      Len := SQLStmtLength(SQL, Index);
      Inc(Index, Len);
    until (Index >= SynMemo.SelStart);
    Dec(Index, Len);
    SQL := Copy(SQL, Index, Len);
  except
    SQL := '';
  end;

  if ((Len <> 0) and not Client.InUse() and FSQLEditor.GetHighlighterAttriAtRowCol(FSQLEditor.WordStart(), Token, Attri)) then
  begin
    Index := SynMemo.SelStart - Index + 1;
    while ((Index > 0) and (Pos(SQL[Index], FSQLEditorCompletion.EndOfTokenChr) = 0)) do Dec(Index);

    Database := Client.DatabaseByName(SelectedDatabase);
    if (Assigned(Database)) then
      if (Database.Initialize()) then
        Database := nil;

    StringList := TStringList.Create();

    if (((Index > 0) and (SQL[Index] = '.')) or (Attri = MainHighlighter.DelimitedIdentifierAttri)) then
    begin
      I := Index - 1;
      Identifier := SQLUnescape(Copy(SQL, I + 1, Index - I - 1));
      if (SQL[Index] <> '.') then
        Owner := ''
      else
      begin
        Dec(I);
        while ((I > 0) and (Pos(SQL[I], FSQLEditorCompletion.EndOfTokenChr) = 0)) do Dec(I);
        Owner := SQLUnescape(Copy(SQL, I + 1, Index - I - 1 - Length(Owner)));
      end;

      if (Owner <> '') then
      begin
        Database := Client.DatabaseByName(Owner);

        if (Assigned(Database)) then
          for I := 0 to Database.Tables.Count - 1 do
            StringList.Add(Database.Tables[I].Name);
      end;

      Table := nil;
      if (Owner <> '') then
      begin
        if (Assigned(Database)) then
          Table := Database.BaseTableByName(Owner)
        else if (SelectedDatabase <> '') then
          Table := Client.DatabaseByName(SelectedDatabase).BaseTableByName(Owner);
        if (Assigned(Table)) then
        begin
          SetLength(Tables, 1);
          Tables[0] := Table;
        end
        else if (SQLCreateParse(Parse, PChar(SQL), Length(SQL),Client.ServerVersion) and SQLParseKeyword(Parse, 'SELECT') and (Owner <> '')) then
        begin
          QueryBuilder := TacQueryBuilder.Create(Window);
          QueryBuilder.Visible := False;
          QueryBuilder.Parent := SynMemo;
          QueryBuilder.SyntaxProvider := SyntaxProvider;
          QueryBuilder.MetadataProvider := MetadataProvider;
          Insert('*', SQL, Index + 1);
          try
            QueryBuilder.SQL := SQL;
            Application.ProcessMessages();
            for I := 0 to QueryBuilder.QueryStatistics.UsedDatabaseObjects.Count - 1 do
              for J := 0 to QueryBuilder.QueryStatistics.UsedDatabaseObjects[I].Aliases.Count - 1 do
              if ((Client.LowerCaseTableNames = 0) and (lstrcmp(PChar(QueryBuilder.QueryStatistics.UsedDatabaseObjects[I].Aliases[J].Token), PChar(Owner)) = 0)
                or (Client.LowerCaseTableNames > 0) and (lstrcmpi(PChar(QueryBuilder.QueryStatistics.UsedDatabaseObjects[I].Aliases[J].Token), PChar(Owner)) = 0)) then
              begin
                if (QueryBuilder.QueryStatistics.UsedDatabaseObjects[I].Database.QualifiedName = '') then
                  Database := Client.DatabaseByName(SelectedDatabase)
                else
                  Database := Client.DatabaseByName(QueryBuilder.QueryStatistics.UsedDatabaseObjects[I].Database.QualifiedName);
                if (not Assigned(Database)) then
                  Table := nil
                else
                  Table := Database.TableByName(QueryBuilder.QueryStatistics.UsedDatabaseObjects[I].Name.Token);
                if (Assigned(Table)) then
                begin
                  SetLength(Tables, 1);
                  Tables[0] := Table;
                end;
              end;
          except
          end;
          QueryBuilder.Free();
        end;
      end
      else if (SQLParseDMLStmt(DMLStmt, PChar(SQL), Length(SQL), Client.ServerVersion)) then
        for I := 0 to Length(DMLStmt.TableNames) - 1 do
        begin
          Database := Client.DatabaseByName(DMLStmt.DatabaseNames[I]);
          if (Assigned(Database)) then
          begin
            Table := Database.TableByName(DMLStmt.TableNames[I]);
            if (Assigned(Table)) then
            begin
              SetLength(Tables, Length(Tables) + 1);
              Tables[Length(Tables) - 1] := Table;
            end;
          end;
        end;
    end
    else
    begin
      if (SQLCreateParse(Parse, PChar(SQL), Length(SQL),Client.ServerVersion) and SQLParseKeyword(Parse, 'SELECT')) then
      begin
        QueryBuilder := TacQueryBuilder.Create(Window);
        QueryBuilder.Visible := False;
        QueryBuilder.Parent := SynMemo;
        QueryBuilder.SyntaxProvider := SyntaxProvider;
        QueryBuilder.MetadataProvider := MetadataProvider;
        try
          QueryBuilder.SQL := SQL;
          Application.ProcessMessages();
          for I := 0 to QueryBuilder.QueryStatistics.UsedDatabaseObjects.Count - 1 do
          begin
            if (QueryBuilder.QueryStatistics.UsedDatabaseObjects[I].Database.QualifiedName = '') then
              Database := Client.DatabaseByName(SelectedDatabase)
            else
              Database := Client.DatabaseByName(QueryBuilder.QueryStatistics.UsedDatabaseObjects[I].Database.QualifiedName);
            if (not Assigned(Database)) then
              Table := nil
            else
              Table := Database.TableByName(QueryBuilder.QueryStatistics.UsedDatabaseObjects[I].Name.Token);
            if (Assigned(Table)) then
            begin
              SetLength(Tables, Length(Tables) + 1);
              Tables[Length(Tables) - 1] := Table;
            end;
          end;
        except
        end;
        QueryBuilder.Free();
      end;

      StringList.Text
        := ReplaceStr(MainHighlighter.GetKeywords(Ord(tkKey)), ',', #13#10) + #13#10
        + ReplaceStr(MainHighlighter.GetKeywords(Ord(tkDatatype)), ',', #13#10) + #13#10
        + ReplaceStr(MainHighlighter.GetKeywords(Ord(tkFunction)), ',', #13#10) + #13#10
        + ReplaceStr(MainHighlighter.GetKeywords(Ord(tkPLSQL)), ',', #13#10);

      for I := 0 to Client.Databases.Count - 1 do
        StringList.Add(Client.Databases[I].Name);
      if (Assigned(Database)) then
        for I := 0 to Database.Tables.Count - 1 do
          StringList.Add(Database.Tables[I].Name);
    end;

    try
      for I := 0 to Length(Tables) - 1 do
        if (Tables[I].Fields.Count > 0) then
        begin
          if (Tables[I] is TCBaseTable) then
            for J := 0 to TCBaseTable(Tables[I]).Indices.Count - 1 do
              if (not TCBaseTable(Tables[I]).Indices[J].Primary) then
                StringList.Add(TCBaseTable(Tables[I]).Indices[J].Caption);
          for J := 0 to Tables[I].Fields.Count - 1 do
            StringList.Add(Tables[I].Fields[J].Name);
          if (Tables[I] is TCBaseTable) then
            for J := 0 to TCBaseTable(Tables[I]).ForeignKeys.Count - 1 do
              StringList.Add(TCBaseTable(Tables[I]).ForeignKeys[J].Name);
        end;
    except
    end;

    S := Copy(SynMemo.Lines.Strings[SynMemo.WordStart().Line - 1], SynMemo.WordStart().Char, SynMemo.CharIndexToRowCol(SynMemo.SelStart).Char - SynMemo.WordStart().Char);

    // avoid Popup, if a word has been typed completely
    I := StringList.Count - 1;
    while ((I >= 0) and (StringList.Count > 0)) do
    begin
      if (lstrcmpi(PChar(StringList[I]), PChar(S)) = 0) then
        StringList.Clear();
      Dec(I);
    end;

    StringList.Sort();
    FSQLEditorCompletion.ItemList.Text := StringList.Text;

    StringList.Free();
  end;

  CanExecute := FSQLEditorCompletion.ItemList.Count > 0;
end;

procedure TFClient.FSQLEditorCompletionPaintItem(Sender: TObject;
  Index: Integer; TargetCanvas: TCanvas; ItemRect: TRect;
  var CustomDraw: Boolean);
begin
  FSQLEditorCompletionShow(Sender);
end;

procedure TFClient.FSQLEditorCompletionShow(Sender: TObject);
begin
  MainAction('aDRun').Enabled := True;
  MainAction('aDRunSelection').Enabled := True;

  KillTimer(Handle, tiCodeCompletion);
  SetTimer(Handle, tiCodeCompletion, 1000, nil);
  FSQLEditorCompletionTimerCounter := 0;
end;

procedure TFClient.FSQLEditorCompletionTimerTimer(Sender: TObject);
begin
  Inc(FSQLEditorCompletionTimerCounter);

  if ((FSQLEditorCompletionTimerCounter = 5) or (FSQLEditorCompletion.Form.AssignedList.Count = 0)) then
  begin
    FSQLEditorCompletion.CancelCompletion();
    KillTimer(Handle, tiCodeCompletion);
  end;
end;

procedure TFClient.FSQLEditorEnter(Sender: TObject);
begin
  MainAction('aECopyToFile').OnExecute := SaveSQLFile;
  MainAction('aEPasteFromFile').OnExecute := aEPasteFromExecute;
  MainAction('aSGoto').OnExecute := TSymMemoGotoExecute;

  FSQLEditorStatusChange(Sender, [scAll]);
  StatusBarRefresh();
end;

procedure TFClient.FSQLEditorExit(Sender: TObject);
begin
  MainAction('aFImportSQL').Enabled := False;
  MainAction('aFExportSQL').Enabled := False;
  MainAction('aFPrint').Enabled := False;
  MainAction('aERedo').Enabled := False;
  MainAction('aECopyToFile').Enabled := False;
  MainAction('aEPasteFromFile').Enabled := False;
  MainAction('aSGoto').Enabled := False;
end;

procedure TFClient.FSQLEditorStatusChange(Sender: TObject; Changes: TSynStatusChanges);
var
  Attri: TSynHighlighterAttributes;
  DDLStmt: TSQLDDLStmt;
  Empty: Boolean;
  Parse: TSQLParse;
  SelSQL: string;
  SQL: string;
  Token: string;
begin
  if (not (csDestroying in ComponentState)) then
  begin
    if (((scCaretX in Changes) or (scModified in Changes) or (scAll in Changes)) and Assigned(SynMemo)) then
    begin
      SelSQL := SynMemo.SelText; // Cache, da Abfrage bei vielen Zeilen Zeit ben�tigt
      if (View = avObjectIDE) then SQL := SynMemo.Text;

      Empty := ((SynMemo.Lines.Count <= 1) and (SynMemo.Text = '')); // Ben�tigt bei vielen Zeilen Zeit

      MainAction('aFSave').Enabled := not Empty and ((SQLEditor.Filename = '') or SynMemo.Modified);
      MainAction('aFSaveAs').Enabled := not Empty;
      MainAction('aFPrint').Enabled := (SynMemo = FSQLEditor) and not Empty;
      MainAction('aERedo').Enabled := SynMemo.CanRedo;
      MainAction('aECopyToFile').Enabled := (SelSQL <> '');
      MainAction('aEPasteFromFile').Enabled := (SynMemo = FSQLEditor);
      MainAction('aSGoto').Enabled := (Sender = FSQLEditor) and not Empty;
      MainAction('aDRun').Enabled :=
        ((View = avSQLEditor)
        or ((View  = avQueryBuilder) and FBuilder.Visible)
        or ((View = avObjectIDE) and SQLSingleStmt(SQL) and (SelectedImageIndex in [iiView, iiProcedure, iiFunction, iiEvent]))) and not Empty;
      MainAction('aDRunSelection').Enabled := (((SynMemo = FSQLEditor) and not Empty) or Assigned(SynMemo) and (SynMemo.SelText <> '')) and True;
      MainAction('aDPostObject').Enabled := (View = avObjectIDE) and SynMemo.Modified and SQLSingleStmt(SQL)
        and ((SelectedImageIndex in [iiView]) and SQLCreateParse(Parse, PChar(SQL), Length(SQL),Client.ServerVersion) and (SQLParseKeyword(Parse, 'SELECT'))
          or (SelectedImageIndex in [iiProcedure, iiFunction]) and SQLParseDDLStmt(DDLStmt, PChar(SQL), Length(SQL), Client.ServerVersion) and (DDLStmt.DefinitionType = dtCreate) and (DDLStmt.ObjectType in [otProcedure, otFunction])
          or (SelectedImageIndex in [iiEvent, iiTrigger]));
    end;

    FSQLEditorCompletion.TimerInterval := 0;
    if ((SynMemo = FSQLEditor) and (FSQLEditor.SelStart > 0)
      and FSQLEditor.GetHighlighterAttriAtRowCol(FSQLEditor.WordStart(), Token, Attri) and (Attri <> MainHighlighter.StringAttri) and (Attri <> MainHighlighter.CommentAttri) and (Attri <> MainHighlighter.VariableAttri)) then
    begin
      FSQLEditorCompletion.Editor := SynMemo;
      FSQLEditorCompletion.TimerInterval := Preferences.Editor.CodeCompletionTime;
    end;

    StatusBarRefresh();
  end;
end;

procedure TFClient.FSQLHistoryChange(Sender: TObject; Node: TTreeNode);
begin
  FSQLHistoryMenuNode := Node;
end;

procedure TFClient.FSQLHistoryDblClick(Sender: TObject);
begin
  Wanted.Clear();

  FSQLHistoryMenuNode := FSQLHistory.Selected;


  if (Sender = FSQLHistory) then
  begin
    MSQLHistoryPopup(Sender);
      if (miHStatementIntoSQLEditor.Default) then
        miHStatementIntoSQLEditor.Click();
  end;
end;

procedure TFClient.FSQLHistoryEnter(Sender: TObject);
begin
  miHProperties.ShortCut := ShortCut(VK_RETURN, [ssAlt]);
end;

procedure TFClient.FSQLHistoryExit(Sender: TObject);
begin
  MainAction('aECopy').Enabled := False;

  miHProperties.ShortCut := 0;
end;

procedure TFClient.FSQLHistoryKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (not TTreeView(Sender).IsEditing()) then
    if ((Key = Ord('C')) and (Shift = [ssCtrl]) or (Key = VK_INSERT) and (Shift = [ssCtrl])) then
      begin aECopyExecute(Sender); Key := 0; end
    else if ((Key = Ord('V')) and (Shift = [ssCtrl]) or (Key = VK_INSERT) and (Shift = [ssShift])) then
      begin aEPasteExecute(Sender); Key := 0; end;
end;

procedure TFClient.FSQLHistoryKeyPress(Sender: TObject; var Key: Char);
var
  I: Integer;
  MenuItem: TMenuItem;
  TreeView: TTreeView_Ext;
begin
  TreeView := TTreeView_Ext(Sender);

  if (not TreeView.IsEditing()) then
    if ((Sender = FList) and (Ord(Key) = VK_BACK)) then
      FNavigator.Selected := FNavigator.Selected.Parent
    else if (Key = #3) then
      Key := #0
    else if (Ord(Key) = VK_RETURN) then
      if (Assigned(TreeView.Selected)) then
      begin
        MenuItem := nil;
        for I := 0 to TreeView.PopupMenu.Items.Count - 1 do
          if (TreeView.PopupMenu.Items[I].Default) then
            MenuItem := TreeView.PopupMenu.Items[I];
        if Assigned(MenuItem) then
          begin MenuItem.Click(); Key := #0; end;
      end;
end;

procedure TFClient.FSQLHistoryRefresh(Sender: TObject);
var
  Date: TDateTime;
  DateNode: TTreeNode;
  I: Integer;
  NewNode: TTreeNode;
  OldNode: TTreeNode;
  TimeNode: TTreeNode;
  XML: IXMLNode;
begin
  if (PSQLHistory.Visible) then
  begin
    DateNode := nil;

    FSQLHistory.Items.BeginUpdate();

    if (FSQLHistory.Items.Count > 0) then
      XML := IXMLNode(FSQLHistory.Items[FSQLHistory.Items.Count - 1].Data)
    else if (Client.Account.HistoryXML.ChildNodes.Count > 0) then
      XML := Client.Account.HistoryXML.ChildNodes[0]
    else
      XML := nil;

    while (Assigned(XML)) do
    begin
      if (XML.NodeName = 'sql') then
      begin
        Date := SysUtils.StrToFloat(XMLNode(XML, 'datetime').Text, FileFormatSettings);
        DateNode := nil;
        for I := 0 to FSQLHistory.Items.Count - 1 do
          if (FSQLHistory.Items[I].Text = SysUtils.DateToStr(Date, LocaleFormatSettings)) then
            DateNode := FSQLHistory.Items[I];
        if (not Assigned(DateNode)) then
        begin
          DateNode := FSQLHistory.Items.Add(nil, SysUtils.DateToStr(Date, LocaleFormatSettings));
          DateNode.HasChildren := True;
          DateNode.ImageIndex := iiCalendar;

          TTreeNode_Ext(DateNode).Bold := True;
        end;

        OldNode := FSQLHistory.Items[FSQLHistory.Items.Count - 1];
        case (OldNode.ImageIndex) of
          iiCalendar: OldNode := nil;
          iiClock: OldNode := OldNode.Parent;
        end;
        if (not Assigned(OldNode) or (OldNode.Parent <> DateNode) or (XMLNode(IXMLNode(OldNode.Data), 'sql').Text <> XMLNode(XML, 'sql').Text)) then
        begin
          NewNode := FSQLHistory.Items.AddChild(DateNode, SQLStmtToCaption(XMLNode(XML, 'sql').Text));
          if (XML.Attributes['type'] <> 'query') then
            NewNode.ImageIndex := iiStatement
          else
            NewNode.ImageIndex := iiQuery;
          NewNode.Data := Pointer(XML);
        end
        else
        begin
          if (not OldNode.HasChildren) then
          begin
            TimeNode := FSQLHistory.Items.AddChild(OldNode, TimeToStr(StrToFloat(XMLNode(IXMLNode(OldNode.Data), 'datetime').Text, FileFormatSettings), LocaleFormatSettings));
            TimeNode.ImageIndex := iiClock;
            TimeNode.Data := OldNode.Data;
          end;

          TimeNode := FSQLHistory.Items.AddChild(OldNode, TimeToStr(StrToFloat(XMLNode(XML, 'datetime').Text, FileFormatSettings), LocaleFormatSettings));
          TimeNode.ImageIndex := iiClock;
          TimeNode.Data := Pointer(XML);
        end;
      end;

      XML := XML.NextSibling();
    end;

    if (Assigned(DateNode)) then
    begin
      DateNode.Expand(False);

      PostMessage(FSQLHistory.Handle, WM_VSCROLL, SB_BOTTOM, 0);
    end;

    FSQLHistory.Items.EndUpdate();

    FSQLHistoryMenuNode := DateNode;
  end;
end;

procedure TFClient.FTextChange(Sender: TObject);
begin
  if (Assigned(EditorField) and FText.Modified) then
    case (NewLineFormat) of
      nlUnix: EditorField.AsString := ReplaceStr(FText.Text, #13#10, #10);
      nlMacintosh: EditorField.AsString := ReplaceStr(FText.Text, #13#10, #13);
      else EditorField.AsString := FText.Text;
    end;

  aVBlobRTF.Visible := Assigned(EditorField) and (EditorField.DataType = ftWideMemo) and not EditorField.IsNull and IsRTF(EditorField.AsString);
end;

procedure TFClient.FTextEnter(Sender: TObject);
begin
  if (Assigned(EditorField) and (EditorField.DataSet.State <> dsEdit)) then
    EditorField.DataSet.Edit();

  StatusBarRefresh();
end;

procedure TFClient.FTextExit(Sender: TObject);
begin
  SendMessage(FText.Handle, WM_VSCROLL, SB_TOP, 0);
end;

procedure TFClient.FTextKeyPress(Sender: TObject; var Key: Char);
begin
  if ((Window.ActiveControl = FText) and (Key = #27)) then
  begin
    Window.ActiveControl := FGrid;
    FGrid.DataSource.DataSet.Cancel();
  end
end;

procedure TFClient.FTextShow(Sender: TObject);
var
  S: string;
begin
  FText.OnChange := nil;

  if (not Assigned(EditorField) or EditorField.IsNull) then
    FText.Text := ''
  else
  begin
    S := EditorField.AsString;
    if ((Pos(#10, S) > 0) and (Pos(#13, S) > 0)) then
    begin
      if (Pos(#10, S) < Pos(#13, S)) then
        NewLineFormat := nlUnix
      else if ((Length(S) > Pos(#13, S)) and (S[Pos(#13, S) + 1] = #10)) then
        NewLineFormat := nlWindows
      else if ((Length(S) > Pos(#10, S)) and (S[Pos(#10, S) + 1] = #13)) then
        NewLineFormat := nlMacintosh;
    end
    else if (Pos(#13, S) > 0) then
      NewLineFormat := nlMacintosh
    else
      NewLineFormat := nlUnix;

    case (NewLineFormat) of
      nlUnix: FText.Text := ReplaceStr(ReplaceStr(EditorField.AsString, #10, #13#10), #13#10#10, #13#10);
      nlMacintosh: FText.Text := ReplaceStr(ReplaceStr(EditorField.AsString, #13, #13#10), #13#13#10, #13#10);
      else FText.Text := EditorField.AsString;
    end;
    FText.Modified := False;
  end;
  if (FText.Text <> '') then
    FText.SelectAll();

  FText.ReadOnly := not Assigned(EditorField) or EditorField.ReadOnly or not EditorField.DataSet.CanModify;

  FText.OnChange := FTextChange;


  aVBlobRTF.Visible := (EditorField.DataType = ftWideMemo) and not EditorField.IsNull and IsRTF(EditorField.AsString);
end;

procedure TFClient.FWorkbenchAddTable(Sender: TObject);
var
  MenuItem: TMenuItem;
  Table: TCBaseTable;
  WTable: TWTable;
begin
  if (Sender is TMenuItem) then
  begin
    MenuItem := TMenuItem(Sender);

    if ((MenuItem.GetParentMenu() is TPopupMenu) and (TObject(MenuItem.Tag) is TCTable)) then
    begin
      Table := TCBaseTable(TMenuItem(Sender).Tag);

      Workbench.BeginUpdate();
      WTable := TWTable.Create(Workbench.Tables);
      WTable.Caption := Table.Name;
      FWorkbenchValidateControl(nil, WTable);
      WTable.Move(nil, [], Workbench.ScreenToClient(TPopupMenu(MenuItem.GetParentMenu()).PopupPoint));
      Workbench.Tables.Add(WTable);
      FWorkbenchValidateForeignKeys(nil, WTable);
      Workbench.Selected := WTable;
      Window.ActiveControl := Workbench;
      Workbench.EndUpdate();
    end;
  end;
end;

procedure TFClient.FWorkbenchChange(Sender: TObject; Control: TWControl);
var
  aEPasteEnabled: Boolean;
  ClipboardData: HGLOBAL;
  Database: TCDatabase;
  DatabaseName: string;
  Index: Integer;
  S: string;
  AccountName: string;
  Table: TCBaseTable;
  TableName: string;
  Values: TStringList;
begin
  if (not Clipboard.HasFormat(CF_MYSQLTABLE) or not OpenClipboard(Handle)) then
    aEPasteEnabled := False
  else
  begin
    ClipboardData := GetClipboardData(CF_MYSQLTABLE);
    S := PChar(GlobalLock(ClipboardData));
    GlobalUnlock(ClipboardData);
    CloseClipboard();

    Values := TStringList.Create();
    Values.Text := ReplaceStr(Trim(S), ',', #13#10);

    aEPasteEnabled := Values.Count = 1;

    if (aEPasteEnabled) then
    begin
      S := Values[0];

      if (Pos('.', S) = 0) then
        AccountName := ''
      else
      begin
        Index := Pos('.', S);
        while ((Index > 1) and (S[Index - 1] = '\')) do
          Inc(Index, Pos('.', Copy(S, Index + 1, Length(S) - Index)));
        AccountName := ReplaceStr(Copy(S, 1, Index - 1), '\.', '.');
        Delete(S, 1, Index);
      end;
      if (Pos('.', S) = 0) then
        DatabaseName := ''
      else
      begin
        DatabaseName := Copy(S, 1, Pos('.', S) - 1);
        Delete(S, 1, Length(DatabaseName) + 1);
      end;
      if (Pos('.', S) = 0) then
        TableName := S
      else
        TableName := '';

      Table := Client.DatabaseByName(SelectedDatabase).BaseTableByName(TableName);

      aEPasteEnabled := (AccountName = Client.Account.Name) and (DatabaseName = SelectedDatabase)
        and Assigned(Table) and Assigned(Table.Engine) and Table.Engine.ForeignKeyAllowed
        and not Assigned(Workbench.TableByCaption(Table.Name));
    end;

    Values.Free();
  end;

  Database := Client.DatabaseByName(SelectedDatabase);

  aPOpenInNewWindow.Enabled := (Control is TWTable);
  aPOpenInNewTab.Enabled := (Control is TWTable);
  MainAction('aFImportSQL').Enabled := not Assigned(Control) or (Control is TWTable);
  MainAction('aFImportText').Enabled := not Assigned(Control) or (Control is TWTable);
  MainAction('aFImportExcel').Enabled := not Assigned(Control) or (Control is TWTable);
  MainAction('aFImportAccess').Enabled := not Assigned(Control) or (Control is TWTable);
  MainAction('aFImportSQLite').Enabled := not Assigned(Control) or (Control is TWTable);
  MainAction('aFImportODBC').Enabled := not Assigned(Control) or (Control is TWTable);
  MainAction('aFImportXML').Enabled := (Control is TWTable);
  MainAction('aFExportSQL').Enabled := not Assigned(Control) or (Control is TWTable);
  MainAction('aFExportText').Enabled := not Assigned(Control) or (Control is TWTable);
  MainAction('aFExportExcel').Enabled := not Assigned(Control) or (Control is TWTable);
  MainAction('aFExportAccess').Enabled := not Assigned(Control) or (Control is TWTable);
  MainAction('aFExportSQLite').Enabled := not Assigned(Control) or (Control is TWTable);
  MainAction('aFExportODBC').Enabled := not Assigned(Control) or (Control is TWTable);
  MainAction('aFExportXML').Enabled := not Assigned(Control) or (Control is TWTable);
  MainAction('aFExportHTML').Enabled := not Assigned(Control) or (Control is TWTable);
  MainAction('aFExportBitmap').Enabled := Assigned(Workbench) and (Workbench.ControlCount > 0);
  MainAction('aFPrint').Enabled := Assigned(Workbench) and (Workbench.ControlCount > 0);
  MainAction('aECopy').Enabled := Assigned(Control) and (not (Control is TWForeignKey) or not TWForeignKey(Control).IsLine);
  MainAction('aEPaste').Enabled := aEPasteEnabled;
  MainAction('aDCreateTable').Enabled := not Assigned(Control);
  MainAction('aDCreateView').Enabled := not Assigned(Control) and (Client.ServerVersion >= 50001);
  MainAction('aDCreateProcedure').Enabled := not Assigned(Control) and (Client.ServerVersion >= 50004);
  MainAction('aDCreateFunction').Enabled := MainAction('aDCreateProcedure').Enabled;
  MainAction('aDCreateEvent').Enabled := not Assigned(Control) and (Client.ServerVersion >= 50106);
  MainAction('aDCreateIndex').Enabled := Control is TWTable;
  MainAction('aDCreateField').Enabled := Control is TWTable;
  MainAction('aDCreateForeignKey').Enabled := (Control is TWTable) and Assigned(Database.BaseTableByName(TWTable(Control).Caption)) and Database.BaseTableByName(TWTable(Control).Caption).Engine.ForeignKeyAllowed;
  mwCreateSection.Enabled := not Assigned(Control);
  mwCreateLine.Enabled := Control is TWTable;
  MainAction('aDCreateTrigger').Enabled := (Control is TWTable) and Assigned(Database.BaseTableByName(TWTable(Control).Caption)) and Assigned(Database.Triggers);
  MainAction('aDDeleteTable').Enabled := Control is TWTable;
  MainAction('aDDeleteForeignKey').Enabled := (Control is TWForeignKey) and not TWForeignKey(Control).IsLine;
  MainAction('aDEmpty').Enabled := Control is TWTable;
  mwDProperties.Enabled := Assigned(Control) and (not (Control is TWForeignKey) or not TWForeignKey(Control).IsLine);

  aDDelete.Enabled := MainAction('aDDeleteTable').Enabled or MainAction('aDDeleteForeignKey').Enabled;
end;

procedure TFClient.FWorkbenchCursorMove(Sender: TObject; X, Y: Integer);
begin
  StatusBar.Panels.Items[sbItem].Text := IntToStr(X) + ':' + IntToStr(Y);
end;

procedure TFClient.FWorkbenchDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  Database: TCDatabase;
  SourceNode: TTreeNode;
  Table: TCBaseTable;
  WTable: TWTable;
begin
  if (Source = FNavigator) then
  begin
    SourceNode := MouseDownNode;
    Database := Client.DatabaseByName(SelectedDatabase);
    Table := Database.BaseTableByName(SourceNode.Text);

    Workbench.BeginUpdate();
    WTable := TWTable.Create(Workbench.Tables);
    WTable.Caption := Table.Name;
    FWorkbenchValidateControl(nil, WTable);
    WTable.Move(nil, [], Point(X, Y));
    Workbench.Tables.Add(WTable);
    FWorkbenchValidateForeignKeys(nil, WTable);
    Workbench.Selected := WTable;
    Window.ActiveControl := Workbench;
    Workbench.EndUpdate();
  end;
end;

procedure TFClient.FWorkbenchDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  SourceNode: TTreeNode;
  Table: TCBaseTable;
begin
  Accept := False;

  if (Source = FNavigator) then
  begin
    SourceNode := MouseDownNode;
    if ((SourceNode.ImageIndex = iiBaseTable) and (SourceNode.Parent.Text = SelectedDatabase)) then
    begin
      Table := Client.DatabaseByName(SelectedDatabase).BaseTableByName(SourceNode.Text);
      Accept := Assigned(Table) and not Assigned(Workbench.TableByCaption(SourceNode.Text));
    end;
  end;
end;

procedure TFClient.FWorkbenchEmptyExecute(Sender: TObject);
var
  Names: array of string;
begin
  if (Workbench.Selected is TWTable) then
  begin
    SetLength(Names, 1);
    Names[Length(Names) - 1] := TWTable(Workbench.Selected).Caption;

    if (MsgBox(Preferences.LoadStr(375, Names[Length(Names) - 1]), Preferences.LoadStr(101), MB_YESNOCANCEL + MB_ICONQUESTION) = IDYES) then
      Client.DatabaseByName(SelectedDatabase).EmptyTables(Names);

    SetLength(Names, 0);
  end;
end;

procedure TFClient.FWorkbenchEnter(Sender: TObject);
begin
  if (Sender is TWWorkbench) then
  begin
    MainAction('aDEmpty').OnExecute := FWorkbenchEmptyExecute;

    FWorkbenchChange(Sender, TWWorkbench(Sender).Selected);
  end;
end;

procedure TFClient.FWorkbenchExit(Sender: TObject);
begin
  MainAction('aFImportAccess').Enabled := False;
  MainAction('aFImportText').Enabled := False;
  MainAction('aFImportExcel').Enabled := False;
  MainAction('aFImportSQLite').Enabled := False;
  MainAction('aFImportODBC').Enabled := False;
  MainAction('aFImportXML').Enabled := False;
  MainAction('aFExportSQL').Enabled := False;
  MainAction('aFExportText').Enabled := False;
  MainAction('aFExportExcel').Enabled := False;
  MainAction('aFExportAccess').Enabled := False;
  MainAction('aFExportSQLite').Enabled := False;
  MainAction('aFExportODBC').Enabled := False;
  MainAction('aFExportXML').Enabled := False;
  MainAction('aFExportHTML').Enabled := False;
  MainAction('aFExportBitmap').Enabled := False;
  MainAction('aFPrint').Enabled := False;
  MainAction('aECopy').Enabled := False;
  MainAction('aDCreateTable').Enabled := False;
  MainAction('aDCreateView').Enabled := False;
  MainAction('aDCreateProcedure').Enabled := False;
  MainAction('aDCreateFunction').Enabled := False;
  MainAction('aDCreateEvent').Enabled := False;
  MainAction('aDCreateIndex').Enabled := False;
  MainAction('aDCreateField').Enabled := False;
  MainAction('aDCreateForeignKey').Enabled := False;
  MainAction('aDCreateTrigger').Enabled := False;
  MainAction('aDDeleteTable').Enabled := False;
  MainAction('aDDeleteForeignKey').Enabled := False;
  mwCreateSection.Enabled := False;
  mwCreateLine.Enabled := False;
  MainAction('aDEmpty').Enabled := False;
end;

procedure TFClient.FWorkbenchMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FWorkbenchMouseDownPoint := Point(X, Y);
end;

procedure TFClient.FWorkbenchPasteExecute(Sender: TObject);
var
  aEPasteEnabled: Boolean;
  ClipboardData: HGLOBAL;
  DatabaseName: string;
  Index: Integer;
  MenuItem: TMenuItem;
  S: string;
  AccountName: string;
  Table: TCBaseTable;
  TableName: string;
  Values: TStringList;
  WTable: TWTable;
begin
  Wanted.Clear();

  if (not Clipboard.HasFormat(CF_MYSQLTABLE) or not OpenClipboard(Handle)) then
    MessageBeep(MB_ICONERROR)
  else
  begin
    ClipboardData := GetClipboardData(CF_MYSQLTABLE);
    S := PChar(GlobalLock(ClipboardData));
    GlobalUnlock(ClipboardData);
    CloseClipboard();

    Values := TStringList.Create();
    Values.Text := ReplaceStr(Trim(S), ',', #13#10);

    aEPasteEnabled := Values.Count = 1;

    if (aEPasteEnabled) then
    begin
      S := Values[0];

      if (Pos('.', S) = 0) then
        AccountName := ''
      else
      begin
        Index := Pos('.', S);
        while ((Index > 1) and (S[Index - 1] = '\')) do
          Inc(Index, Pos('.', Copy(S, Index + 1, Length(S) - Index)));
        AccountName := ReplaceStr(Copy(S, 1, Index - 1), '\.', '.');
        Delete(S, 1, Index);
      end;
      if (Pos('.', S) = 0) then
        DatabaseName := ''
      else
      begin
        DatabaseName := Copy(S, 1, Pos('.', S) - 1);
        Delete(S, 1, Length(DatabaseName) + 1);
      end;
      if (Pos('.', S) = 0) then
        TableName := S
      else
        TableName := '';

      Table := Client.DatabaseByName(SelectedDatabase).BaseTableByName(TableName);

      Workbench.BeginUpdate();
      WTable := TWTable.Create(Workbench.Tables);
      WTable.Caption := Table.Name;
      Workbench.Tables.Add(WTable);
      FWorkbenchValidateControl(nil, WTable);

      if (Sender is TMenuItem) then
      begin
        MenuItem := TMenuItem(Sender);

        if ((MenuItem.GetParentMenu() is TPopupMenu)) then
          WTable.Move(nil, [], Workbench.ScreenToClient(TPopupMenu(MenuItem.GetParentMenu()).PopupPoint));
      end
      else
        WTable.Move(nil, [], Point(0, 0));

      FWorkbenchValidateForeignKeys(nil, WTable);
      Workbench.Selected := WTable;
      Window.ActiveControl := Workbench;
      Workbench.EndUpdate();
    end;

    Values.Free();
  end;
end;

procedure TFClient.FWorkbenchPrintExecute(Sender: TObject);
begin
  Wanted.Clear();

  PrintDialog.FromPage := 1;
  PrintDialog.ToPage := 1;
  PrintDialog.MinPage := 1;
  PrintDialog.MaxPage := 1;
  if (FSQLEditorPrint.PageCount = 1) then
    PrintDialog.Options := PrintDialog.Options - [poPageNums]
  else
    PrintDialog.Options := PrintDialog.Options + [poPageNums];
  PrintDialog.Options := PrintDialog.Options - [poSelection];
  PrintDialog.PrintRange := prAllPages;
  if (PrintDialog.Execute()) then
    Workbench.Print(SelectedDatabase);
end;

procedure TFClient.FWorkbenchValidateControl(Sender: TObject; Control: TWControl);
var
  Database: TCDatabase;
  ForeignKey: TCForeignKey;
  I: Integer;
  Objects: array of TCDBObject;
  ParentTable: TCBaseTable;
  Table: TCBaseTable;
  Workbench: TWWorkbench;
begin
  Database := Client.DatabaseByName(SelectedDatabase);
  if (Sender is TWWorkbench) then
    Workbench := TWWorkbench(Sender)
  else
    Workbench := nil;

  if (not Assigned(Control)) then
  begin
    SetLength(Objects, Workbench.Tables.Count);
    for I := 0 to Workbench.Tables.Count - 1 do
      Objects[I] := Database.BaseTableByName(Workbench.Tables[I].Caption);
    Database.Initialize();
  end
  else if (Control is TWTable) then
  begin
    Table := Database.BaseTableByName(TWTable(Control).Caption);
    if (Assigned(Table)) then
      Table.Initialize();
  end
  else if (Control is TWForeignKey) then
  begin
    Table := Database.BaseTableByName(TWForeignKey(Control).ChildTable.Caption);
    ParentTable := Database.BaseTableByName(TWForeignKey(Control).ParentTable.Caption);

    if (Assigned(Table) and Assigned(ParentTable)) then
      if (CreateLine) then
        TWForeignKey(Control).Caption := ''
      else
      begin
        for I := 0 to Table.ForeignKeys.Count - 1 do
          if ((TWForeignKey(Control).Caption = '')
            and (Table.ForeignKeys[I].Parent.DatabaseName = Database.Name)
            and (Table.ForeignKeys[I].Parent.TableName = ParentTable.Name)
            and (not Assigned(Workbench.ForeignKeyByCaption(Table.ForeignKeys[I].Name)))) then
            TWForeignKey(Control).Caption := Table.ForeignKeys[I].Name;

        if (TWForeignKey(Control).Caption <> '') then
        begin
          ForeignKey := Table.ForeignKeyByName(TWForeignKey(Control).Caption);
          ParentTable := Client.DatabaseByName(ForeignKey.Parent.DatabaseName).BaseTableByName(ForeignKey.Parent.TableName);
          if (Assigned(ForeignKey)) then
            ParentTable.Initialize();
        end
        else
        begin
          DForeignKey.Database := Client.DatabaseByName(SelectedDatabase);
          DForeignKey.Table := DForeignKey.Database.BaseTableByName(TWForeignKey(Control).ChildTable.Caption);
          DForeignKey.ParentTable := DForeignKey.Database.BaseTableByName(TWForeignKey(Control).ParentTable.Caption);
          DForeignKey.ForeignKey := nil;
          if (not DForeignKey.Execute()) then
            PostMessage(Handle, CM_REMOVE_WFOREIGENKEY, wParam(Workbench), lParam(TWForeignKey(Control)));
        end;
      end;
  end;

  CreateLine := False;
end;

function TFClient.FWorkbenchValidateForeignKeys(Sender: TObject; WTable: TWTable): Boolean;
var
  Database: TCDatabase;
  I: Integer;
  Table: TCBaseTable;
  WForeignKey: TWForeignKey;
  Workbench: TWWorkbench;
  WParentTable: TWTable;
begin
  if (Sender is TWWorkbench) then
    Workbench := TWWorkbench(Sender)
  else
    Workbench := TWWorkbench(Client.DatabaseByName(SelectedDatabase).Workbench);

  Database := Client.DatabaseByName(SelectedDatabase);
  Table := Database.BaseTableByName(WTable.Caption);
  Result := Assigned(Table);
  if (Result) then
  begin
    for I := 0 to Table.ForeignKeys.Count - 1 do
      if (Table.ForeignKeys[I].Parent.DatabaseName = Table.Database.Name) then
      begin
        WParentTable := Workbench.TableByCaption(Table.ForeignKeys[I].Parent.TableName);
        if (Assigned(WParentTable)
          and not Assigned(Workbench.ForeignKeyByCaption(Table.ForeignKeys[I].Name))) then
        begin
          WForeignKey := TWForeignKey.Create(Workbench, Point(-1, -1));
          WForeignKey.Caption := Table.ForeignKeys[I].Name;
          WForeignKey.ChildTable := WTable;
          WForeignKey.ParentTable := WParentTable;
          Workbench.ForeignKeys.Add(WForeignKey);
        end;
      end;
{
    for I := 0 to Database.Tables.Count - 1 do
      if ((Database.Tables[I] is TCBaseTable) and (Database.Tables[I] <> Table)) then
        for J := 0 to TCBaseTable(Database.Tables[I]).ForeignKeys.Count - 1 do
          if ((TCBaseTable(Database.Tables[I]).ForeignKeys[J].Parent.Database = Database)
            and (TCBaseTable(Database.Tables[I]).ForeignKeys[J].Parent.Table = Table)
            and not Assigned(Workbench.ForeignKeyByCaption(TCBaseTable(Database.Tables[I]).ForeignKeys[J].Name))) then
          begin
            WChildTable := Workbench.TableByCaption(Database.Tables[I].Name);
            if (Assigned(WChildTable)) then
            begin
              WForeignKey := Workbench.ForeignKeys.Add();
              WForeignKey.Caption := TCBaseTable(Database.Tables[I]).ForeignKeys[J].Name;
              WForeignKey.ChildTable := WChildTable;
              WForeignKey.ParentTable := WTable;
            end;
          end;
}
  end;
end;

function TFClient.GetView(): TView;
begin
  if (MainAction('aVObjectBrowser').Checked) then Result := avObjectBrowser
  else if (MainAction('aVDataBrowser').Checked) then Result := avDataBrowser
  else if (MainAction('aVObjectIDE').Checked) then Result := avObjectIDE
  else if (MainAction('aVQueryBuilder').Checked) then Result := avQueryBuilder
  else if (MainAction('aVSQLEditor').Checked) then Result := avSQLEditor
  else if (MainAction('aVDiagram').Checked) then Result := avDiagram
  else Result := UsedView;
end;

function TFClient.GetAddress(): string;
begin
  Result := NavigatorNodeToAddress(FNavigator.Selected);
end;

function TFClient.GetFocusedCItem(): TCItem;
var
  ImageIndex: Integer;
  Name: string;
  ObjectName: string;
begin
  if ((Window.ActiveControl = FList) and Assigned(FList.Selected)) then
    if (FList.SelCount > 1) then
    begin
      ImageIndex := -1;
      ObjectName := '';
      Name := '';
    end
    else
    begin
      ImageIndex := FList.Selected.ImageIndex;
      ObjectName := FNavigator.Selected.Text;
      Name := FList.Selected.Caption;
    end
  else if ((Window.ActiveControl = Workbench) and Assigned(Workbench) and Assigned(Workbench.Selected)) then
  begin
    if (Workbench.Selected is TWTable) then
    begin
      ImageIndex := iiBaseTable;
      ObjectName := FNavigator.Selected.Text;
      Name := TWTable(Workbench.Selected).Caption;
    end
    else if (Workbench.Selected is TWForeignKey) then
    begin
      ImageIndex := iiForeignKey;
      ObjectName := TWForeignKey(Workbench.Selected).ChildTable.Caption;
      Name := TWForeignKey(Workbench.Selected).Caption;
    end
    else
    begin
      ImageIndex := iiDatabase;
      ObjectName := '';
      Name := FNavigatorMenuNode.Text;
    end;
  end
  else if ((Window.ActiveControl = FList) and not Assigned(FList.Selected) or (Window.ActiveControl = Workbench) and (not Assigned(Workbench) or not Assigned(Workbench.Selected))) then
  begin
    ImageIndex := FNavigator.Selected.ImageIndex;
    if (not Assigned(FNavigator.Selected.Parent)) then
      ObjectName := ''
    else
      ObjectName := FNavigator.Selected.Parent.Text;
    Name := FNavigator.Selected.Text;
  end
  else if (Assigned(FNavigatorMenuNode)) then
  begin
    ImageIndex := FNavigatorMenuNode.ImageIndex;
    if (not Assigned(FNavigatorMenuNode.Parent)) then
      ObjectName := ''
    else
      ObjectName := FNavigatorMenuNode.Parent.Text;
    Name := FNavigatorMenuNode.Text;
  end
  else
  begin
    ImageIndex := iiServer;
    ObjectName := '';
    Name := '';
  end;

  case (ImageIndex) of
    iiServer: Result := nil;
    iiDatabase,
    iiSystemDatabase: Result := Client.DatabaseByName(Name);
    iiTable,
    iiBaseTable,
    iiSystemView,
    iiView: Result := Client.DatabaseByName(ObjectName).TableByName(Name);
    iiProcedure: Result := Client.DatabaseByName(ObjectName).ProcedureByName(Name);
    iiFunction: Result := Client.DatabaseByName(ObjectName).FunctionByName(Name);
    iiEvent: Result := Client.DatabaseByName(ObjectName).EventByName(Name);
    iiIndex: Result := Client.DatabaseByName(MenuDatabase).BaseTableByName(ObjectName).IndexByCaption(Name);
    iiField,
    iiSystemViewField,
    iiViewField: Result := Client.DatabaseByName(MenuDatabase).BaseTableByName(ObjectName).FieldByName(Name);
    iiForeignKey: Result := Client.DatabaseByName(MenuDatabase).BaseTableByName(ObjectName).ForeignKeyByName(Name);
    iiTrigger: Result := Client.DatabaseByName(MenuDatabase).TriggerByName(Name);
    iiHost: Result := Client.HostByCaption(Name);
    iiProcess: Result := Client.ProcessById(SysUtils.StrToInt(Name));
    iiStatus: Result := Client.StatusByName(Name);
    iiVariable: Result := Client.VariableByName(Name);
    iiUser: Result := Client.UserByCaption(Name);
    else Result := nil;
  end;
end;

function TFClient.GetFocusedDatabaseName(): string;
var
  I: Integer;
begin
  if (Window.ActiveControl = FNavigator) then
    Result := SelectedDatabase
  else if ((Window.ActiveControl = FList) and (SelectedImageIndex = iiServer)) then
  begin
    Result := '';
    for I := 0 to FList.Items.Count - 1 do
      if ((FList.Items[I].Selected) and (FList.Items[I].ImageIndex in [iiDatabase, iiSystemDatabase])) then
      begin
        if (Result <> '') then
          Result := Result + ',';
        Result := Result + FList.Items[I].Caption;
      end;
  end
  else
    Result := SelectedDatabase;
end;

function TFClient.GetFocusedTableName(): string;
var
  I: Integer;
begin
  if ((Window.ActiveControl = FList) and (SelectedImageIndex in [iiDatabase, iiSystemDatabase])) then
  begin
    Result := '';
    for I := 0 to FList.Items.Count - 1 do
      if ((FList.Items[I].Selected) and (FList.Items[I].ImageIndex in [iiTable, iiBaseTable, iiSystemView, iiView])) then
      begin
        if (Result <> '') then Result := Result + ',';
        Result := Result + FList.Items[I].Caption;
      end;
  end
  else if ((Window.ActiveControl is TWWorkbench) and Assigned(Workbench.Selected) and (Workbench.Selected is TWTable)) then
    Result := TWTable(Workbench.Selected).Caption
  else
    Result := SelectedTable;
end;

function TFClient.GetMenuDatabase(): string;
var
  Node: TTreeNode;
begin
  Result := '';

  if (Window.ActiveControl <> FNavigator) then
    Result := SelectedDatabase
  else
  begin
    Node := FNavigatorMenuNode;
    while (Assigned(Node) and Assigned(Node.Parent) and Assigned(Node.Parent.Parent)) do Node := Node.Parent;
    if (Assigned(Node) and (Node.ImageIndex in [iiDatabase, iiSystemDatabase])) then Result := Node.Text;
  end;
end;

function TFClient.GetResultSet(): TCResultSet;
begin
  if ((View = avObjectIDE) and (SelectedImageIndex = iiProcedure)) then
    Result := Client.DatabaseByName(SelectedDatabase).ProcedureByName(SelectedNavigator).IDEResult
  else if ((View = avObjectIDE) and (SelectedImageIndex = iiFunction)) then
    Result := Client.DatabaseByName(SelectedDatabase).FunctionByName(SelectedNavigator).IDEResult
  else if (View = avQueryBuilder) then
    Result := Client.QueryBuilderResult
  else if (View = avSQLEditor) then
    Result := Client.SQLEditorResult
  else
    Result := nil;
end;

function TFClient.GetSelectedDatabase(): string;
begin
  if (not Assigned(FNavigator.Selected)) then
    Result := ''
  else
    case (FNavigator.Selected.ImageIndex) of
      iiDatabase,
      iiSystemDatabase:
        Result := FNavigator.Selected.Text;
      iiBaseTable,
      iiSystemView,
      iiView,
      iiProcedure,
      iiFunction,
      iiEvent:
        Result := FNavigator.Selected.Parent.Text;
      iiIndex,
      iiField,
      iiSystemViewField,
      iiForeignKey,
      iiTrigger:
        Result := FNavigator.Selected.Parent.Parent.Text;
      else
        Result := '';
    end;
end;

function TFClient.GetSelectedImageIndex(): Integer;
begin
  if (not Assigned(FNavigator.Selected)) then
    Result := -1
  else
    Result := FNavigator.Selected.ImageIndex;
end;

function TFClient.GetSelectedItem(): string;
begin
  Result := '';
  case (View) of
    avObjectBrowser:
      if (Assigned(FList.ItemFocused) and FList.ItemFocused.Selected) then
        try Result := FList.ItemFocused.Caption; except end;
  end;
end;

function TFClient.GetSelectedNavigator(): string;
begin
  if (not Assigned(FNavigator.Selected)) then
    Result := ''
  else
    Result := FNavigator.Selected.Text;
end;

function TFClient.GetSelectedTable(): string;
begin
  Result := '';

  if (not Assigned(FNavigator.Selected)) then
    Result := ''
  else
    case (FNavigator.Selected.ImageIndex) of
      iiBaseTable,
      iiSystemView,
      iiView:
        Result := FNavigator.Selected.Text;
      iiIndex,
      iiField,
      iiSystemViewField,
      iiForeignKey,
      iiTrigger:
        Result := FNavigator.Selected.Parent.Text;
      else
        Result := '';
    end;
end;

function TFClient.GetSynMemo(): TSynMemo;
begin
  case (View) of
    avObjectIDE:
      case (SelectedImageIndex) of
        iiView: Result := TSynMemo(Client.DatabaseByName(SelectedDatabase).ViewByName(SelectedNavigator).SynMemo);
        iiProcedure: Result := TSynMemo(Client.DatabaseByName(SelectedDatabase).ProcedureByName(SelectedNavigator).SynMemo);
        iiFunction: Result := TSynMemo(Client.DatabaseByName(SelectedDatabase).FunctionByName(SelectedNavigator).SynMemo);
        iiEvent: Result := TSynMemo(Client.DatabaseByName(SelectedDatabase).EventByName(SelectedNavigator).SynMemo);
        iiTrigger: Result := TSynMemo(Client.DatabaseByName(SelectedDatabase).TriggerByName(SelectedNavigator).SynMemo);
        else Result := nil;
      end;
    avQueryBuilder:
      Result := FBuilderEditor;
    avSQLEditor:
      Result := FSQLEditor
    else
      Result := nil;
  end;
end;

function TFClient.GetWindow(): TForm_Ext;
begin
  if (not Assigned(Owner)) then
    raise Exception.Create('Owner not set');

  Result := TForm_Ext(Owner);
end;

function TFClient.GetWorkbench(): TWWorkbench;
begin
  if (not Assigned(Client.DatabaseByName(SelectedDatabase))) then
    Result := nil
  else
    Result := TWWorkbench(Client.DatabaseByName(SelectedDatabase).Workbench);
end;

procedure TFClient.gmFilterClearClick(Sender: TObject);
begin
  Wanted.Clear();

  if (FGrid.DataSource.DataSet.Filtered) then
  begin
    FGrid.DataSource.DataSet.Filtered := False;
    FGrid.DataSource.DataSet.Filter := '';
    StatusBarRefresh();
  end
  else if (FGrid.DataSource.DataSet is TMySQLTable) then
    FFilterEnabledClick(nil);
end;

procedure TFClient.gmFilterIntoFilterClick(Sender: TObject);
var
  FilterIndex: Integer;
  MenuItem: TMenuItem;
  Success: Boolean;
  Value: string;
begin
  Wanted.Clear();

  MenuItem := TMenuItem(Sender); FilterIndex := MenuItem.Tag;

  Success := True;
  case (Filters[FilterIndex].ValueType) of
    0: Value := '';
    1: if (FGrid.SelectedField.DataType in UnquotedDataTypes) then
         Value := FGrid.SelectedField.DisplayText
       else
         Value := SQLEscape(FGrid.SelectedField.DisplayText);
    2: Value := SQLEscape('%' + FGrid.SelectedField.DisplayText + '%');
    else
      begin
        if (Filters[FilterIndex].ValueType = 3) then
          DQuickFilter.Data := FGrid.SelectedField.DisplayText
        else
          DQuickFilter.Data := '%' + FGrid.SelectedField.DisplayText + '%';
        Success := DQuickFilter.Execute();
        if (Success) then
          if (FGrid.SelectedField.DataType in UnquotedDataTypes) then
            Value := DQuickFilter.Data
          else
            Value := SQLEscape(DQuickFilter.Data);
      end;
  end;

  if (Success) then
    if (View = avDataBrowser) then
    begin
      FFilter.Text := Format(Filters[FilterIndex].Text, [Client.EscapeIdentifier(FGrid.SelectedField.FieldName), Value]);
      FFilterEnabled.Down := True;
      FFilterEnabledClick(Sender);
    end
    else
    begin
      FGrid.DataSource.DataSet.FilterOptions := [foCaseInsensitive];
      FGrid.DataSource.DataSet.Filter := Format(Filters[FilterIndex].Text, ['[' + FGrid.SelectedField.FieldName + ']', Value]);
      FGrid.DataSource.DataSet.Filtered := True;
      StatusBarRefresh();
    end;
end;

procedure TFClient.ImportError(const Sender: TObject; const Error: TTools.TError; const Item: TTools.TItem; var Success: TDataAction);
begin
  MsgBox(Error.ErrorMessage, Preferences.LoadStr(45), MB_OK + MB_ICONERROR);

  Success := daAbort;
end;

procedure TFClient.ListViewDblClick(Sender: TObject);
var
  I: Integer;
  MenuItem: TMenuItem;
  PopupMenu: TPopupMenu;
begin
  Wanted.Clear();

  MenuItem := nil;

  if ((Sender is TListView) and Assigned(TListView(Sender).OnSelectItem)) then
    TListView(Sender).OnSelectItem(Sender, TListView(Sender).Selected, Assigned(TListView(Sender).Selected));

  if (Sender is TListView) then
    PopupMenu := TListView(Sender).PopupMenu
  else if (Sender is TWWorkbench) then
    PopupMenu := TWWorkbench(Sender).PopupMenu
  else
    PopupMenu := nil;

  if (Assigned(PopupMenu)) then
    for I := 0 to PopupMenu.Items.Count - 1 do
      if (PopupMenu.Items[I].Default and PopupMenu.Items[I].Visible and PopupMenu.Items[I].Enabled) then
        MenuItem := PopupMenu.Items[I];

  if (Assigned(MenuItem)) then MenuItem.Click();
end;

procedure TFClient.ListViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I: Integer;
  MenuItem: TMenuItem;
begin
  if (not TListView(Sender).IsEditing()) then
    if ((Sender = FList) and (Key = VK_BACK)) then
      FNavigator.Selected := FNavigator.Selected.Parent
    else if ((Key = Ord('A')) and (Shift = [ssCtrl])) then
      MainAction('aESelectAll').Execute()
    else if ((Key = Ord('C')) and (Shift = [ssCtrl]) or (Key = VK_INSERT) and (Shift = [ssCtrl])) then
      begin aECopyExecute(Sender); Key := 0; end
    else if ((Key = Ord('V')) and (Shift = [ssCtrl]) or (Key = VK_INSERT) and (Shift = [ssShift])) then
      begin aEPasteExecute(Sender); Key := 0; end
    else if (Key = VK_RETURN) then
      if (Assigned(TListView(Sender).Selected) and Assigned(TListView(Sender).PopupMenu)) then
      begin
        MenuItem := nil;
        for I := 0 to TListView(Sender).PopupMenu.Items.Count - 1 do
          if (TListView(Sender).PopupMenu.Items[I].Default) then
            MenuItem := TListView(Sender).PopupMenu.Items[I];
        if (Assigned(MenuItem)) then
          begin MenuItem.Click(); Key := 0; end;
      end;
end;

procedure TFClient.mbBOpenClick(Sender: TObject);
begin
  Wanted.Clear();

  if (Assigned(FBookmarks.Selected)) then
    Address := Client.Account.Desktop.Bookmarks.ByCaption(FBookmarks.Selected.Caption).URI;
end;

procedure TFClient.MBookmarksPopup(Sender: TObject);
begin
  ShowEnabledItems(MBookmarks.Items);
end;

procedure TFClient.MetadataProviderAfterConnect(Sender: TObject);
begin

end;

procedure TFClient.MetadataProviderGetSQLFieldNames(Sender: TacBaseMetadataProvider;
  const ASQL: WideString; AFields: TacFieldsList);
var
  Database: TCDatabase;
  DatabaseName: string;
  I: Integer;
  Parse: TSQLParse;
  Table: TCTable;
  TableName: string;
begin
  if (SQLCreateParse(Parse, PChar(ASQL[System.Pos('FROM', UpperCase(ASQL))]), Length(ASQL) - System.Pos('FROM', UpperCase(ASQL)) + 1, Client.ServerVersion) and SQLParseKeyword(Parse, 'FROM')) then
  begin
    TableName := SQLParseValue(Parse);
    if (not SQLParseChar(Parse, '.')) then
      DatabaseName := SelectedDatabase
    else
    begin
      DatabaseName := TableName;
      TableName := SQLParseValue(Parse);
    end;

    Database := Client.DatabaseByName(DatabaseName);
    Table := Database.TableByName(TableName);

    if (Assigned(Table)) then
      for I := 0 to Table.Fields.Count - 1 do
        AFields.AddField(Table.Fields[I].Name, Client.LowerCaseTableNames = 0);
  end;
end;

procedure TFClient.MGridHeaderMenuOrderClick(Sender: TObject);
var
  MenuItem: TMenuItem;
  SortDef: TIndexDef;
begin
  Wanted.Clear();

  if (not IgnoreFGridTitleClick) then
  begin
    MenuItem := TMenuItem(Sender);

    SortDef := TIndexDef.Create(nil, '', '', []);
    if (MenuItem.Checked) then
      MenuItem.Checked := False
    else
      Client.DatabaseByName(SelectedDatabase).BaseTableByName(SelectedTable).Indices[MenuItem.Tag].GetSortDef(SortDef);

    TMySQLDataSet(FGrid.DataSource.DataSet).Sort(SortDef);
    FGrid.UpdateHeader();
    SortDef.Free();
  end;

  IgnoreFGridTitleClick := False;
end;

procedure TFClient.MGridHeaderPopup(Sender: TObject);
var
  Database: TCDatabase;
  I: Integer;
  Index: TCIndex;
  J: Integer;
  SortMenuItem: TMenuItem;
  Table: TCBaseTable;
  VisibleItems: Integer;
begin
  MainAction('aVDetails').Enabled := True;

  VisibleItems := 0;
  for I := 0 to FGrid.Columns.Count - 1 do
    for J := 0 to FGrid.Columns.Count - 1 do
      if (I = FGrid.Columns[J].Field.FieldNo - 1) then
      begin
        MGridHeader.Items[I].Checked := FGrid.Columns[J].Visible;
        if (MGridHeader.Items[I].Checked) then Inc(VisibleItems);
      end;
  for I := 0 to FGrid.Columns.Count - 1 do
    MGridHeader.Items[I].Enabled := (VisibleItems > 1) or not MGridHeader.Items[I].Checked;

  if (SelectedImageIndex in [iiBaseTable, iiSystemView]) then
  begin
    Database := Client.DatabaseByName(SelectedDatabase);
    Table := Database.BaseTableByName(SelectedTable);

    SortMenuItem := nil;
    for I := 0 to MGridHeader.Items.Count - 1 do
      if (MGridHeader.Items[I].Count > 0) then
        SortMenuItem := TMenuItem(MGridHeader.Items[I]);

    if (Assigned(SortMenuItem) and (FGrid.DataSource.DataSet is TCTableDataSet)) then
    begin
      Index := Table.IndexByDataSet(TCTableDataSet(FGrid.DataSource.DataSet));
      for I := 0 to SortMenuItem.Count - 1 do
        if (SortMenuItem.Items[I].Tag >= 0) then
          SortMenuItem.Items[I].Checked := Assigned(Index) and (Index.Index = SortMenuItem.Items[I].Tag);
    end;
  end;
end;

procedure TFClient.MGridPopup(Sender: TObject);

  procedure AddFilterMenuItem(const Field: TField; const Value: string; const FilterIndex: Integer);
  var
    NewMenuItem: TMenuItem;
  begin
    NewMenuItem := TMenuItem.Create(Self);
    NewMenuItem.AutoHotkeys := maManual;
    if (FilterIndex < 0) then
      NewMenuItem.Caption := '-'
    else
    begin
      NewMenuItem.Caption := Format(Filters[FilterIndex].Text, [Field.DisplayName, Value]);
      NewMenuItem.OnClick := gmFilterIntoFilterClick;
      NewMenuItem.Tag := FilterIndex;
    end;
    gmFilter.Add(NewMenuItem);
  end;

var
  ClientCoord: TPoint;
  GridCoord: TGridCoord;
  I: Integer;
  NewMenuItem: TMenuItem;
  Value: string;
begin
  ClientCoord := FGrid.ScreenToClient(MGrid.PopupPoint);
  GridCoord := FGrid.MouseCoord(ClientCoord.X, ClientCoord.Y);

  if (GridCoord.X < 0) then
  begin
    for I := 0 to MGrid.Items.Count - 1 do
      MGrid.Items[I].Visible := False;

    ShowEnabledItems(gmFExport);
    gmFExport.Visible := not FGrid.EditorMode;
  end
  else
  begin
    gmFilter.Clear(); gmFilter.Enabled := False;

    if (not FGrid.EditorMode and not (FGrid.SelectedField.DataType in [ftWideMemo, ftBlob])) then
    begin
      gmFilter.Enabled := True;

      if (((FGrid.DataSource.DataSet is TMySQLTable) and (TMySQLTable(FGrid.DataSource.DataSet).FilterSQL <> ''))
        or not (FGrid.DataSource.DataSet is TMySQLTable) and FGrid.DataSource.DataSet.Filtered) then
      begin
        NewMenuItem := TMenuItem.Create(Self);
        NewMenuItem.Caption := Preferences.LoadStr(559);
        NewMenuItem.OnClick := gmFilterClearClick;
        gmFilter.Add(NewMenuItem);

        NewMenuItem := TMenuItem.Create(Self);
        NewMenuItem.Caption := '-';
        gmFilter.Add(NewMenuItem);
      end;

      if (not FGrid.SelectedField.Required) then
      begin
        AddFilterMenuItem(FGrid.SelectedField, Value, 0);
        AddFilterMenuItem(FGrid.SelectedField, Value, 1);
        AddFilterMenuItem(FGrid.SelectedField, '', -1);
      end;

      if (not FGrid.SelectedField.IsNull) then
      begin
        if (FGrid.SelectedField.DataType in UnquotedDataTypes) then
          Value := FGrid.SelectedField.DisplayText
        else
          Value := SQLEscape(FGrid.SelectedField.DisplayText);
        AddFilterMenuItem(FGrid.SelectedField, Value, 2);
        AddFilterMenuItem(FGrid.SelectedField, Value, 3);
        AddFilterMenuItem(FGrid.SelectedField, Value, 4);
        AddFilterMenuItem(FGrid.SelectedField, Value, 5);
        if (FGrid.SelectedField.DataType in [ftBytes, ftWideString]) then
          AddFilterMenuItem(FGrid.SelectedField, SQLEscape('%' + FGrid.SelectedField.DisplayText + '%'), 6);
        AddFilterMenuItem(FGrid.SelectedField, '', -1);
      end;

      if (FGrid.SelectedField.DataType in UnquotedDataTypes) then
        Value := '...'
      else
        Value := SQLEscape('...');
      AddFilterMenuItem(FGrid.SelectedField, Value, 7);
      AddFilterMenuItem(FGrid.SelectedField, Value, 8);
      AddFilterMenuItem(FGrid.SelectedField, Value, 9);
      AddFilterMenuItem(FGrid.SelectedField, Value, 10);
      if (FGrid.SelectedField.DataType in [ftBytes, ftWideString]) then
        AddFilterMenuItem(FGrid.SelectedField, Value, 11);
    end;

    ShowEnabledItems(MGrid.Items);

    gmDInsertRecord.Visible := gmDInsertRecord.Visible and not FGrid.EditorMode;
    gmDDeleteRecord.Visible := gmDDeleteRecord.Visible and not FGrid.EditorMode;
    gmFExport.Visible := gmFExport.Visible and not FGrid.EditorMode;
    gmFilter.Visible := gmFilter.Visible and not FGrid.EditorMode;
    gmDEditRecord.Visible := gmDEditRecord.Visible and not FGrid.EditorMode;
  end;
end;

procedure TFClient.MGridTitleMenuVisibleClick(Sender: TObject);
var
  I: Integer;
  Index: Integer;
begin
  Wanted.Clear();

  Index := -1;
  for I := 0 to FGrid.Columns.Count - 1 do
    if (FGrid.Columns[I].Field.FieldNo - 1 = MGridHeader.Items.IndexOf(TMenuItem(Sender))) then
      Index := I;
  FGrid.Columns[Index].Visible := not FGrid.Columns[Index].Visible;
end;

procedure TFClient.miHOpenClick(Sender: TObject);
begin
  Wanted.Clear();

  if (Assigned(FSQLHistoryMenuNode) and (FSQLHistoryMenuNode.ImageIndex in [iiStatement, iiQuery, iiClock])
    and Boolean(Perform(CM_CLOSE_TAB_QUERY, 0, 0))) then
  begin
    View := avSQLEditor;
    if (View = avSQLEditor) then
    begin
      FSQLEditor.Text := XMLNode(IXMLNode(FSQLHistoryMenuNode.Data), 'sql').Text;

      Window.ActiveControl := FSQLEditor;
    end;
  end;
end;

procedure TFClient.miHPropertiesClick(Sender: TObject);
var
  Node: IXMLNode;
begin
  Node := IXMLNode(FSQLHistoryMenuNode.Data);

  if (not Assigned(XMLNode(Node, 'database'))) then
    DStatement.DatabaseName := ''
  else
    DStatement.DatabaseName := XMLNode(Node, 'database').Text;
  DStatement.DateTime := StrToFloat(XMLNode(Node, 'datetime').Text, FileFormatSettings);
  if (not Assigned(XMLNode(Node, 'fields'))) then
    DStatement.FieldCount := -1
  else
    DStatement.FieldCount := SysUtils.StrToInt(XMLNode(Node, 'fields').Text);
  if (not Assigned(XMLNode(Node, 'info'))) then
    DStatement.Info := ''
  else
    DStatement.Info := XMLNode(Node, 'info').Text;
  if (not Assigned(XMLNode(Node, 'insert_id'))) then
    DStatement.Id := 0
  else
    DStatement.Id := StrToInt64(XMLNode(Node, 'insert_id').Text);
  if (not Assigned(XMLNode(Node, 'records'))) then
    DStatement.RecordCount := -1
  else
    DStatement.RecordCount := SysUtils.StrToInt(XMLNode(Node, 'records').Text);
  if (not Assigned(XMLNode(Node, 'rows_affected'))) then
    DStatement.RowsAffected := -1
  else
    DStatement.RowsAffected := SysUtils.StrToInt(XMLNode(Node, 'rows_affected').Text);
  if (not Assigned(XMLNode(Node, 'execution_time'))) then
    DStatement.StatementTime := MySQLZeroDate
  else
    DStatement.StatementTime := StrToFloat(XMLNode(Node, 'execution_time').Text, FileFormatSettings);
  DStatement.SQL := XMLNode(Node, 'sql').Text;
  if (Node.Attributes['type'] = 'query') then
    DStatement.ViewType := vtQuery
  else
    DStatement.ViewType := vtStatement;

  DStatement.Execute();
end;

procedure TFClient.miHSaveAsClick(Sender: TObject);
begin
  Wanted.Clear();

  SaveSQLFile(Sender);
end;

procedure TFClient.miHStatementIntoSQLEditorClick(Sender: TObject);
var
  SelLength: Integer;
  SelStart: Integer;
begin
  Wanted.Clear();

  if (Assigned(FSQLHistoryMenuNode) and (FSQLHistoryMenuNode.ImageIndex in [iiStatement, iiQuery, iiClock])) then
  begin
    View := avSQLEditor;
    if (View = avSQLEditor) then
    begin
      SelStart := FSQLEditor.SelStart;
      FSQLEditor.SelText := XMLNode(IXMLNode(FSQLHistoryMenuNode.Data), 'sql').Text;
      SelLength := FSQLEditor.SelStart - SelStart;

      FSQLEditor.SelStart := SelStart;
      FSQLEditor.SelLength := SelLength;

      Window.ActiveControl := FSQLEditor;
    end;
  end;
end;

procedure TFClient.MListPopup(Sender: TObject);
var
  I: Integer;
  Rect: TRect;
begin
  FListSelectItem(Sender, FList.Selected, Assigned(FList.Selected));

  if (not BOOL(Header_GetItemRect(ListView_GetHeader(FList.Handle), 0, @Rect)) or (MList.PopupPoint.Y - FList.ClientOrigin.Y < Rect.Bottom)) then
    for I := 0 to MList.Items.Count - 1 do
      MList.Items[I].Visible := False;
end;

procedure TFClient.mlOpenClick(Sender: TObject);
var
  Child: TTreeNode;
  ForeignKey: TCForeignKey;
  NewNode: TTreeNode;
  URI: TUURI;
begin
  Wanted.Clear();

  case (FList.Selected.ImageIndex) of
    iiForeignKey:
      begin
        ForeignKey := Client.DatabaseByName(SelectedDatabase).BaseTableByName(SelectedTable).ForeignKeyByName(FList.Selected.Caption);
        URI := TUURI.Create(Address);
        URI.Database := ForeignKey.Parent.DatabaseName;
        URI.Table := ForeignKey.Parent.TableName;
        Address := URI.Address;
        URI.Free();
      end;
    else
      begin
        NewNode := nil;
        FNavigator.Selected.Expand(False);
        Child := FNavigator.Selected.getFirstChild();
        while (Assigned(Child)) do
        begin
          if (lstrcmpi(PChar(Child.Text), PChar(FList.Selected.Caption)) = 0) then
            NewNode := Child;
          Child := FNavigator.Selected.getNextChild(Child);
        end;
        if (Assigned(NewNode)) then
          FNavigator.Selected := NewNode;
      end;
  end;
end;

procedure TFClient.MNavigatorPopup(Sender: TObject);
var
  AllowChange: Boolean;
  P: TPoint;
begin
  KillTimer(Handle, tiStatusBar);
  KillTimer(Handle, tiNavigator);

  AllowChange := True;
  FNavigatorChanging(Sender, FNavigator.Selected, AllowChange);

  if (Sender = FNavigator.PopupMenu) then
  begin
    // Bei einem Click auf den WhiteSpace: FNavigator.Selected zeigt den zuletzt selektierten Node an :-(
    P := GetClientOrigin();
    FNavigatorMenuNode := FNavigator.GetNodeAt(MNavigator.PopupPoint.X - P.x - (PSideBar.Left + PNavigator.Left + FNavigator.Left), MNavigator.PopupPoint.y - P.y - (PSideBar.Top + PNavigator.Top + FNavigator.Top));
  end
  else
    FNavigatorMenuNode := FNavigator.Selected;

  FNavigatorSetMenuItems(Sender, FNavigatorMenuNode);
end;

procedure TFClient.MoveToAddress(const ADiff: Integer);
begin
  if (ADiff <> 0) then
  begin
    MovingToAddress := True;
    ToolBarData.CurrentAddress := ToolBarData.CurrentAddress + ADiff;
    Address := ToolBarData.Addresses[ToolBarData.CurrentAddress];
    MovingToAddress := False;
  end;
end;

procedure TFClient.MSQLEditorPopup(Sender: TObject);
var
  I: Integer;
begin
  if ((View = avQueryBuilder) and not (Window.ActiveControl = FBuilderEditor)) then
  begin
    Window.ActiveControl := FBuilderEditor;
    FSQLEditorStatusChange(Sender, []);
  end
  else
  if ((View = avSQLEditor) and not (Window.ActiveControl = FSQLEditor)) then
  begin
    Window.ActiveControl := FSQLEditor;
    FSQLEditorStatusChange(Sender, []);
  end;

  ShowEnabledItems(MSQLEditor.Items);

  if (FSQLEditor.Gutter.Visible) then
    for I := 0 to MSQLEditor.Items.Count - 1 do
      MSQLEditor.Items[I].Visible := MSQLEditor.Items[I].Visible and (MSQLEditor.PopupPoint.X - FSQLEditor.ClientOrigin.X > FSQLEditor.Gutter.Width);
end;

procedure TFClient.MSQLHistoryPopup(Sender: TObject);
var
  P: TPoint;
begin
  if (Sender = FSQLHistory.PopupMenu) then
  begin
    // Bei einem Click auf den WhiteSpace: FNavigator.Selected zeigt den zuletzt selektierten Node an :-(
    P := GetClientOrigin();
    FSQLHistoryMenuNode := FSQLHistory.GetNodeAt(MSQLHistory.PopupPoint.x - P.x - (PSideBar.Left + PSQLHistory.Left + FSQLHistory.Left), MSQLHistory.PopupPoint.y - P.y - (PSideBar.Top + PSQLHistory.Top + FSQLHistory.Top));
  end
  else
    FSQLHistoryMenuNode := FSQLHistory.Selected;

  MainAction('aECopy').Enabled := Assigned(FSQLHistoryMenuNode) and (FSQLHistoryMenuNode.ImageIndex in [iiStatement, iiQuery]);

  miHStatementIntoSQLEditor.Enabled := Assigned(FSQLHistoryMenuNode) and (View = avSQLEditor) and (FSQLHistoryMenuNode.ImageIndex in [iiStatement, iiQuery, iiClock]);
  aPExpand.Enabled := Assigned(FSQLHistoryMenuNode) and not FSQLHistoryMenuNode.Expanded and FSQLHistoryMenuNode.HasChildren;
  aPCollapse.Enabled := Assigned(FSQLHistoryMenuNode) and FSQLHistoryMenuNode.Expanded;
  miHOpen.Enabled := Assigned(FSQLHistoryMenuNode) and (View = avSQLEditor) and (FSQLHistoryMenuNode.ImageIndex in [iiStatement, iiQuery, iiClock]);
  miHSaveAs.Enabled := Assigned(FSQLHistoryMenuNode) and (FSQLHistoryMenuNode.ImageIndex in [iiStatement, iiQuery, iiClock]);
  miHRun.Enabled := Assigned(FSQLHistoryMenuNode) and (FSQLHistoryMenuNode.ImageIndex in [iiStatement, iiQuery, iiClock]);
  miHProperties.Enabled := Assigned(FSQLHistoryMenuNode) and (FSQLHistoryMenuNode.ImageIndex in [iiStatement, iiQuery, iiClock]) and not FSQLHistoryMenuNode.HasChildren;

  miHExpand.Default := aPExpand.Enabled;
  miHCollapse.Default := aPCollapse.Enabled;
  miHStatementIntoSQLEditor.Default := not aPExpand.Enabled and not aPCollapse.Enabled and miHStatementIntoSQLEditor.Enabled;

  ShowEnabledItems(MSQLHistory.Items);
end;

procedure TFClient.MTextPopup(Sender: TObject);
begin
  ShowEnabledItems(MText.Items);

  tmECut.Visible := True;
  tmECopy.Visible := True;
  tmEPaste.Visible := True;
  tmEDelete.Visible := True;
  tmESelectAll.Visible := True;
end;

procedure TFClient.MToolBarPopup(Sender: TObject);
var
  Checked: Integer;
  I: Integer;
begin
  mtDataBrowser.Checked := ttDataBrowser in Preferences.ToolbarTabs;
  mtObjectIDE.Checked := ttObjectIDE in Preferences.ToolbarTabs;
  mtQueryBuilder.Checked := ttQueryBuilder in Preferences.ToolbarTabs;
  mtSQLEditor.Checked := ttSQLEditor in Preferences.ToolbarTabs;
  mtDiagram.Checked := ttDiagram in Preferences.ToolbarTabs;

  Checked := 0;
  for I := 0 to MToolBar.Items.Count - 1 do
    if (MToolBar.Items[I].Checked) then
      Inc(Checked);

  for I := 0 to MToolBar.Items.Count - 1 do
    MToolBar.Items[I].Enabled := (Checked > 1) or not MToolBar.Items[I].Checked;
end;

procedure TFClient.mwCreateLineExecute(Sender: TObject);
var
  MenuItem: TMenuItem;
  P: TPoint;
begin
  Wanted.Clear();

  if (Sender is TMenuItem) then
  begin
    MenuItem := TMenuItem(Sender);

    CreateLine := True;
    P := Workbench.ScreenToClient(TPopupMenu(MenuItem.GetParentMenu()).PopupPoint);
    Workbench.InsertForeignKey(P.X, P.Y);
  end;
end;

procedure TFClient.mwCreateSectionClick(Sender: TObject);
var
  MenuItem: TMenuItem;
  P: TPoint;
begin
  Wanted.Clear();

  if (Sender is TMenuItem) then
  begin
    MenuItem := TMenuItem(Sender);

    CreateLine := True;
    P := Workbench.ScreenToClient(TPopupMenu(MenuItem.GetParentMenu()).PopupPoint);
    Workbench.InsertSection(P.X, P.Y);
  end;
end;

procedure TFClient.mwDCreateForeignKeyClick(Sender: TObject);
var
  MenuItem: TMenuItem;
  P: TPoint;
begin
  Wanted.Clear();

  if (Sender is TMenuItem) then
  begin
    MenuItem := TMenuItem(Sender);

    CreateLine := False;
    P := Workbench.ScreenToClient(TPopupMenu(MenuItem.GetParentMenu()).PopupPoint);
    Workbench.InsertForeignKey(P.X, P.Y);
  end;
end;

procedure TFClient.mwEPasteClick(Sender: TObject);
begin
  FWorkbenchPasteExecute(Sender);
end;

procedure TFClient.MWorkbenchPopup(Sender: TObject);
var
  Database: TCDatabase;
  I: Integer;
  MenuItem: TMenuItem;
begin
  Database := Client.DatabaseByName(SelectedDatabase);

  mwAddTable.Clear();
  mwEPaste.Enabled := MainAction('aEPaste').Enabled;

  Workbench.UpdateAction(MainAction('aEDelete'));
  mwEDelete.Enabled := MainAction('aEDelete').Enabled;

  if (not Assigned(Workbench.Selected)) then
    for I := 0 to Database.Tables.Count - 1 do
      if ((Database.Tables[I] is TCBaseTable)
        and Assigned(TCBaseTable(Database.Tables[I]).Engine)
        and TCBaseTable(Database.Tables[I]).Engine.ForeignKeyAllowed
        and not Assigned(Workbench.TableByCaption(Database.Tables[I].Name))) then
      begin
        MenuItem := TMenuItem.Create(Self);
        MenuItem.Caption := Database.Tables[I].Name;
        MenuItem.OnClick := FWorkbenchAddTable;
        MenuItem.Tag := Integer(Database.Tables[I]);
        mwAddTable.Add(MenuItem);
      end;
  mwDProperties.Default := mwDProperties.Enabled;

  mwDCreateForeignKey.OnClick := mwDCreateForeignKeyClick;

  ShowEnabledItems(MWorkbench.Items);
end;

function TFClient.NavigatorNodeToAddress(const Node: TTreeNode): string;
var
  URI: TUURI;
begin
  URI := TUURI.Create('');

  URI.Scheme := 'mysql';
  if (Client.Host = LOCAL_HOST_NAMEDPIPE) then
    URI.Host := LOCAL_HOST
  else
    URI.Host := Client.Host;
  if (Client.Port <> MYSQL_PORT) then
    URI.Port := Client.Port;

  if (Assigned(Node)) then
  begin
    if (not (Node.ImageIndex in [iiHosts, iiProcesses, iiStati, iiUsers, iiVariables])) then
      URI.Param['view'] := ViewToParam(View);

    case (Node.ImageIndex) of
      iiServer:
        if ((URI.Param['view'] <> Null) and (URI.Param['view'] <> 'editor')) then URI.Param['view'] := Null;
      iiDatabase,
      iiSystemDatabase:
        begin
          if ((URI.Param['view'] <> Null) and (URI.Param['view'] <> 'editor') and (URI.Param['view'] <> 'builder') and (URI.Param['view'] <> 'diagram')) then URI.Param['view'] := Null;
          URI.Database := Node.Text;
        end;
      iiBaseTable,
      iiSystemView:
        begin
          if ((URI.Param['view'] <> Null) and (URI.Param['view'] <> 'browser')) then URI.Param['view'] := Null;
          URI.Database := Node.Parent.Text;
          URI.Table := Node.Text;
        end;
      iiView:
        begin
          if ((URI.Param['view'] <> Null) and (URI.Param['view'] <> 'browser') and (URI.Param['view'] <> 'ide')) then URI.Param['view'] := ViewToParam(LastTableView);
          URI.Database := Node.Parent.Text;
          URI.Table := Node.Text;
        end;
      iiProcedure:
        begin
          URI.Param['view'] := 'ide';
          URI.Database := Node.Parent.Text;
          URI.Param['objecttype'] := 'procedure';
          URI.Param['object'] := Node.Text;
        end;
      iiFunction:
        begin
          URI.Param['view'] := 'ide';
          URI.Database := Node.Parent.Text;
          URI.Param['objecttype'] := 'function';
          URI.Param['object'] := Node.Text;
        end;
      iiEvent:
        begin
          URI.Param['view'] := 'ide';
          URI.Database := Node.Parent.Text;
          URI.Param['objecttype'] := 'event';
          URI.Param['object'] := Node.Text;
        end;
      iiTrigger:
        begin
          URI.Param['view'] := 'ide';
          URI.Database := Node.Parent.Parent.Text;
          URI.Param['objecttype'] := 'trigger';
          URI.Param['object'] := Node.Text;
        end;
      iiHosts:
        URI.Param['system'] := 'hosts';
      iiProcesses:
        URI.Param['system'] := 'processes';
      iiStati:
        URI.Param['system'] := 'stati';
      iiUsers:
        URI.Param['system'] := 'users';
      iiVariables:
        URI.Param['system'] := 'variables';
    end;

    if (Node = FNavigator.Selected) then
      case (View) of
        avDataBrowser:
          if (Assigned(FGrid.DataSource.DataSet) and FGrid.DataSource.DataSet.Active and (FGrid.DataSource.DataSet is TMySQLTable)) then
          begin
             if (TMySQLTable(FGrid.DataSource.DataSet).Offset > 0) then
              URI.Param['offset'] := IntToStr(TMySQLTable(FGrid.DataSource.DataSet).Offset);

            if (TMySQLTable(FGrid.DataSource.DataSet).FilterSQL <> '') then
              URI.Param['filter'] := TMySQLTable(FGrid.DataSource.DataSet).FilterSQL;
          end;
        avSQLEditor:
          if (SQLEditor.Filename <> '') then
            URI.Param['file'] := PathToURI(SQLEditor.Filename);
      end;
  end;

  Result := URI.Address;

  URI.Free();
end;

procedure TFClient.OnConvertError(Sender: TObject; Text: string);
begin
  fBase.ConvertError(Sender, Text);
end;

procedure TFClient.OpenInNewTabExecute(const DatabaseName, TableName: string; const OpenNewWindow: Boolean = False; const Filename: TFileName = '');
var
  URI: TUURI;
begin
  URI := TUURI.Create('');
  URI.Host := Client.Account.Connection.Host;
  if (Client.Account.Connection.Port <> MYSQL_PORT) then
    URI.Port := Client.Account.Connection.Port;
  URI.Username := Client.Account.Connection.User;
  URI.Password := Client.Account.Connection.Password;
  if (Filename = '') then
  begin
    URI.Database := DatabaseName;
    URI.Table := TableName;
    case (View) of
      avDataBrowser: if (TableName <> '') then URI.Param['view'] := 'browser';
      avObjectIDE: if (TableName = '') then URI.Param['view'] := 'ide';
      avQueryBuilder: if (TableName = '') then URI.Param['view'] := 'builder';
      avSQLEditor: if (TableName = '') then URI.Param['view'] := 'editor';
      avDiagram: if (TableName = '') then URI.Param['view'] := 'diagram';
    end;
  end
  else
  begin
    URI.Param['view'] := 'editor';
    URI.Database := DatabaseName;
    URI.Param['file'] := PathToURI(Filename);
  end;

  if (not OpenNewWindow) then
    Window.Perform(CM_ADDTAB, 0, LPARAM(PChar(string(URI.Address))))
  else
    ShellExecute(Application.Handle, 'open', PChar(TFileName(Application.ExeName)), PChar(URI.Address), '', SW_SHOW);

  URI.Free();
end;

procedure TFClient.OpenSQLFile(const AFilename: TFileName; const Insert: Boolean = False);
var
  Answer: Integer;
  FileSize: TLargeInteger;
  Handle: THandle;
  Import: TTImportSQL;
  Text: string;
begin
  tbSQLEditor.Click();

  OpenDialog.Title := ReplaceStr(Preferences.LoadStr(581), '&', '');
  if (AFilename = '') then
    OpenDialog.InitialDir := Preferences.Path
  else
    OpenDialog.InitialDir := ExtractFilePath(AFilename);
  OpenDialog.FileName := AFilename;
  OpenDialog.DefaultExt := 'sql';
  OpenDialog.Filter := FilterDescription('sql') + ' (*.sql)|*.sql|' + FilterDescription('*') + ' (*.*)|*.*';
  OpenDialog.Encodings.Text := EncodingCaptions();
  OpenDialog.EncodingIndex := OpenDialog.Encodings.IndexOf(CodePageToEncoding(Client.CodePage));

  if ((OpenDialog.FileName <> '') or OpenDialog.Execute()) then
  begin
    Preferences.Path := ExtractFilePath(OpenDialog.FileName);

    Answer := ID_CANCEL;

    Handle := CreateFile(PChar(OpenDialog.FileName),
                         GENERIC_READ,
                         FILE_SHARE_READ,
                         nil,
                         OPEN_EXISTING, 0, 0);

    if (Handle <> INVALID_HANDLE_VALUE) then
      LARGE_INTEGER(FileSize).LowPart := GetFileSize(Handle, @LARGE_INTEGER(FileSize).HighPart);

    if ((Handle = INVALID_HANDLE_VALUE) or (LARGE_INTEGER(FileSize).LowPart = INVALID_FILE_SIZE) and (GetLastError() <> 0)) then
      MsgBox(SysErrorMessage(GetLastError()), Preferences.LoadStr(45), MB_OK + MB_ICONERROR)
    else if ((SynMemo <> FSQLEditor) or (FileSize < TLargeInteger(LargeSQLScriptSize))) then
      Answer := ID_NO
    else
      Answer := MsgBox(Preferences.LoadStr(751), Preferences.LoadStr(101), MB_YESNOCANCEL + MB_ICONQUESTION);
    CloseHandle(Handle);
    if (Answer = ID_YES) then
    begin
      DImport.ImportType := itSQLFile;
      DImport.Client := Client;
      DImport.Database := Client.DatabaseByName(SelectedDatabase);
      DImport.Table := nil;
      DImport.FileName := OpenDialog.FileName;
      DImport.CodePage := EncodingToCodePage(OpenDialog.Encodings[OpenDialog.EncodingIndex]);
      if (DImport.Execute()) then
        if (Assigned(DImport.Database)) then
          DImport.Database.Clear()
        else
          MainAction('aVRefresh').Execute();
    end
    else if (Answer = ID_NO) then
    begin
      Import := TTImportSQL.Create(OpenDialog.FileName, EncodingToCodePage(OpenDialog.Encodings[OpenDialog.EncodingIndex]), Client, nil);
      Import.OnError := ImportError;
      Import.Text := @Text;
      Import.Execute();

      if (Import.ErrorCount = 0) then
      begin
        FSQLEditor.Options := FSQLEditor.Options + [eoScrollPastEol];  // Speed up the performance
        if (Insert) then
          SynMemo.SelText := Text
        else
        begin
          SynMemo.Text := Text;
          if (SynMemo = FSQLEditor) then
          begin
            SQLEditor.Filename := Import.Filename;
            SQLEditor.CodePage := Import.CodePage;
            AddressChange(nil);
          end;
        end;
        if (Length(FSQLEditor.Lines.Text) < LargeSQLScriptSize) then
          FSQLEditor.Options := FSQLEditor.Options - [eoScrollPastEol]  // Slow down the performance on large content
        else
          FSQLEditor.Options := FSQLEditor.Options + [eoScrollPastEol];  // Speed up the performance
        SynMemo.ClearUndo();
        SynMemo.Modified := Import.SetCharacterSetApplied;
      end;

      Import.Free();
    end;
  end;
end;

procedure TFClient.PanelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) then
  begin
    PanelMouseDownPoint := Point(X, Y);
    PanelMouseMove(Sender, Shift, X, Y);
  end;
end;

procedure TFClient.PanelMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  Panel: TPanel_Ext;
  Rect: TRect;
begin
  if (Sender is TPanel_Ext) then
  begin
    Panel := TPanel_Ext(Sender);

    Rect.Left := Panel.Width - CloseButton.Bitmap.Width - GetSystemMetrics(SM_CXEDGE) - 1;
    Rect.Top := GetSystemMetrics(SM_CYEDGE) - 1;
    Rect.Right := Rect.Left + CloseButton.Bitmap.Width + 2;
    Rect.Bottom := Rect.Top + CloseButton.Bitmap.Height + 2;

    if (PtInRect(Rect, Point(X, Y))) then
    begin
      SetCapture(Panel.Handle);

      if (PtInRect(Rect, PanelMouseDownPoint)) then
        Frame3D(Panel.Canvas, Rect, clDkGray, clWhite, 1)
      else
        Frame3D(Panel.Canvas, Rect, clWhite, clDkGray, 1);
    end
    else if (ReleaseCapture()) then
      Frame3D(Panel.Canvas, Rect, Panel.Color, Panel.Color, 1);
  end;
end;

procedure TFClient.PanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Panel: TPanel_Ext;
  Rect: TRect;
begin
  if (Button = mbLeft) and (Sender is TPanel_Ext) then
  begin
    Panel := TPanel_Ext(Sender);

    Rect.Left := Panel.Width - CloseButton.Bitmap.Width - GetSystemMetrics(SM_CXEDGE) - 1;
    Rect.Top := GetSystemMetrics(SM_CYEDGE) - 1;
    Rect.Right := Rect.Left + CloseButton.Bitmap.Width + 2;
    Rect.Bottom := Rect.Top + CloseButton.Bitmap.Height + 2;

    if (PtInRect(Rect, Point(X, Y)) and PtInRect(Rect, PanelMouseDownPoint)) then
      if (Sender = PResultHeader) then
      begin
        SResult.Visible := False;
        PResult.Visible := False;
        Client.SQLEditorResult.Clear();
      end
      else if (Sender = PLogHeader) then
        MainAction('aVSQLLog').Execute()
      else if (Sender = PSideBarHeader) then
        if (MainAction('aVNavigator').Checked) then
          MainAction('aVNavigator').Execute()
        else if (MainAction('aVBookmarks').Checked) then
          MainAction('aVBookmarks').Execute()
        else if (MainAction('aVSQLHistory').Checked) then
          MainAction('aVSQLHistory').Execute();
    PanelMouseDownPoint := Point(-1, -1);
  end;
end;

procedure TFClient.PanelPaint(Sender: TObject);
begin
  if ((Sender is TPanel_Ext) and Assigned(CloseButton)) then
    TPanel_Ext(Sender).Canvas.Draw(TPanel_Ext(Sender).Width - CloseButton.Bitmap.Width - GetSystemMetrics(SM_CXEDGE), GetSystemMetrics(SM_CYEDGE), CloseButton.Bitmap)
end;

procedure TFClient.PanelResize(Sender: TObject);
var
  ClientControl: TWinControl;
  Control: TWinControl;
  I: Integer;
  NewHeight: Integer;
  ReduceControl: TWinControl;
  ToReduceHeight: Integer;
begin
  if (Sender is TWinControl) then
  begin
    Control := TWinControl(Sender);

    ClientControl := nil;
    NewHeight := Control.ClientHeight;
    for I := 0 to Control.ControlCount - 1 do
      if (Control.Controls[I].Visible) then
        if ((Control.Controls[I].Align = alClient) and (Control.Controls[I] is TWinControl)) then
          ClientControl := TWinControl(Control.Controls[I])
        else if (Control.Controls[I].Align in [alTop, alBottom]) then
          Dec(NewHeight, Control.Controls[I].Height);

    if (Assigned(ClientControl) and (NewHeight < ClientControl.Constraints.MinHeight)) then
    begin
      ToReduceHeight := ClientControl.Constraints.MinHeight - NewHeight;

      ReduceControl := nil;
      for I := 0 to Control.ControlCount - 1 do
        if (Control.Controls[I].Visible and (Control.Controls[I].Align = alBottom) and (Control.Controls[I].Height > Control.Controls[I].Constraints.MinHeight)) then
          if (not Assigned(ReduceControl) or (Control.Controls[I].Top > ReduceControl.Top) and (Control.Controls[I] <> SBResult) and (Control.Controls[I] <> SResult)) then
            ReduceControl := TWinControl(Control.Controls[I]);
      if (Assigned(ReduceControl)) then
        ReduceControl.Height := ReduceControl.Height - ToReduceHeight;
    end;
  end;
end;

procedure TFClient.PasteExecute(const Node: TTreeNode; const Objects: string);
var
  B: Boolean;
  Database: TCDatabase;
  Found: Boolean;
  I: Integer;
  J: Integer;
  Name: string;
  NewField: TCTableField;
  NewForeignKey: TCForeignKey;
  NewIndex: TCIndex;
  NewTable: TCBaseTable;
  SourceClient: TCClient;
  SourceClientCreated: Boolean;
  SourceDatabase: TCDatabase;
  SourceHost: TCHost;
  SourceRoutine: TCRoutine;
  SourceTable: TCBaseTable;
  SourceURI: TUURI;
  SourceUser: TCUser;
  SourceView: TCView;
  StringList: TStringList;
  Success: Boolean;
  Table: TCBaseTable;
begin
  StringList := TStringList.Create();
  StringList.Text := Objects;

  if (StringList.Count > 0) then
  begin
    SourceURI := TUURI.Create(StringList.Values['Address']);
    SourceClient := Clients.ClientByAccount(Accounts.AccountByURI(SourceURI.Address), SourceURI.Database);
    if (Assigned(SourceClient)) then
      SourceClientCreated := False
    else if (not Assigned(Accounts.AccountByURI(SourceURI.Address))) then
    begin
      SourceClient := nil;
      SourceClientCreated := False;
    end
    else
    begin
      SourceClient := Clients.CreateClient(Accounts.AccountByURI(SourceURI.Address), B);
      SourceClientCreated := Assigned(SourceClient);
    end;

    if (Assigned(SourceClient)) then
    begin
      Success := True;

      case (Node.ImageIndex) of
        iiServer:
          if (SourceClient <> Client) then
          begin
            DTransfer.MasterClient := SourceClient;
            DTransfer.MasterDatabaseName := '';
            for I := 1 to StringList.Count - 1 do
              if (Assigned(SourceClient.DatabaseByName(StringList.ValueFromIndex[I]))) then
              begin
                if (DTransfer.MasterDatabaseName <> '') then
                  DTransfer.MasterDatabaseName := DTransfer.MasterDatabaseName + ',';
                DTransfer.MasterDatabaseName := DTransfer.MasterDatabaseName + StringList.ValueFromIndex[I];
              end;
            if (DTransfer.MasterDatabaseName = '') then
              MessageBeep(MB_ICONERROR)
            else
            begin
              DTransfer.MasterTableName := '';
              DTransfer.SlaveClient := Client;
              DTransfer.SlaveDatabaseName := '';
              DTransfer.SlaveTableName := '';
              DTransfer.Execute();
            end;
          end
          else if (DPaste.Execute()) then
          begin
            DDatabase.Client := Client;
            DDatabase.Database := TCDatabase.Create(Client, Name);
            for I := 1 to StringList.Count - 1 do
            begin
              SourceDatabase := SourceClient.DatabaseByName(StringList.ValueFromIndex[I]);

              if (Success and Assigned(SourceDatabase)) then
              begin
                Name := CopyName(SourceDatabase.Name, Client.Databases);
                if (Client.LowerCaseTableNames = 1) then
                  Name := LowerCase(Name);

                DDatabase.Database.Assign(SourceDatabase);
                DDatabase.Database.Name := Name;
                Success := DDatabase.Execute();
                if (Success) then
                begin
                  SourceDatabase := SourceClient.DatabaseByName(StringList.ValueFromIndex[I]);
                  Success := Client.CloneDatabase(SourceDatabase, Client.DatabaseByName(DDatabase.Name), DPaste.Data);
                end;
              end;
            end;
            DDatabase.Database.Free();
          end;
        iiDatabase:
          begin
            SourceDatabase := SourceClient.DatabaseByName(SourceURI.Database);

            if (not Assigned(SourceDatabase)) then
              MessageBeep(MB_ICONERROR)
            else
            begin
              Database := Client.DatabaseByName(Node.Text);

              Found := False;
              for I := 1 to StringList.Count - 1 do
                Found := Found or (StringList.Names[I] = 'Table');

              if (not Assigned(SourceDatabase)) then
                MessageBeep(MB_ICONERROR)
              else if (not Found or DPaste.Execute()) then
              begin
                if (Found and (SourceClient <> Client)) then
                begin
                  DTransfer.MasterClient := SourceClient;
                  DTransfer.MasterDatabaseName := SourceURI.Database;
                  DTransfer.MasterTableName := '';
                  for I := 1 to StringList.Count - 1 do
                    if (Assigned(SourceClient.DatabaseByName(SourceURI.Database).TableByName(StringList.ValueFromIndex[I]))) then
                    begin
                      if (DTransfer.MasterTableName <> '') then
                        DTransfer.MasterTableName := DTransfer.MasterTableName + ',';
                      DTransfer.MasterTableName := DTransfer.MasterTableName + StringList.ValueFromIndex[I];
                    end;
                  if (DTransfer.MasterTableName = '') then
                    MessageBeep(MB_ICONERROR)
                  else
                  begin
                    DTransfer.SlaveClient := Client;
                    DTransfer.SlaveDatabaseName := SelectedDatabase;
                    DTransfer.SlaveTableName := '';
                    DTransfer.Execute();
                  end;
                end
                else
                  for I := 1 to StringList.Count - 1 do
                    if (Success) then
                      if (StringList.Names[I] = 'Table') then
                      begin
                        SourceTable := SourceDatabase.BaseTableByName(StringList.ValueFromIndex[I]);

                        if (not Assigned(SourceTable)) then
                          MessageBeep(MB_ICONERROR)
                        else
                        begin
                          Name := CopyName(SourceTable.Name, Database.Tables);
                          if (Client.LowerCaseTableNames = 1) then
                            Name := LowerCase(Name);

                          Success := Database.CloneTable(SourceTable, Name, DPaste.Data);
                        end;
                      end;
                for I := 1 to StringList.Count - 1 do
                  if (Success) then
                    if (StringList.Names[I] = 'View') then
                    begin
                      SourceView := SourceDatabase.ViewByName(StringList.ValueFromIndex[I]);

                      if (not Assigned(SourceView)) then
                        MessageBeep(MB_ICONERROR)
                      else
                      begin
                        Name := CopyName(SourceView.Name, Database.Tables);
                        if (Client.LowerCaseTableNames = 1) then
                          Name := LowerCase(Name);

                        Success := Database.CloneView(SourceView, Name);
                      end;
                    end;
                for I := 1 to StringList.Count - 1 do
                  if (Success) then
                    if (StringList.Names[I] = 'Procedure') then
                    begin
                      SourceRoutine := SourceDatabase.ProcedureByName(StringList.ValueFromIndex[I]);

                      if (not Assigned(SourceRoutine)) then
                        MessageBeep(MB_ICONERROR)
                      else
                      begin
                        Name := SourceRoutine.Name;
                        J := 1;
                        while (Assigned(Database.ProcedureByName(Name))) do
                        begin
                          if (J = 1) then
                            Name := Preferences.LoadStr(680, SourceRoutine.Name)
                          else
                            Name := Preferences.LoadStr(681, SourceRoutine.Name, IntToStr(J));
                          Name := ReplaceStr(Name, ' ', '_');
                          Inc(J);
                        end;

                        Success := Database.CloneRoutine(SourceRoutine, Name);
                      end;
                    end
                    else if (StringList.Names[I] = 'Function') then
                    begin
                      SourceRoutine := SourceDatabase.FunctionByName(StringList.ValueFromIndex[I]);

                      if (not Assigned(SourceRoutine)) then
                        MessageBeep(MB_ICONERROR)
                      else
                      begin
                        Name := SourceRoutine.Name;
                        J := 1;
                        while (Assigned(Database.FunctionByName(Name))) do
                        begin
                          if (J = 1) then
                            Name := Preferences.LoadStr(680, SourceRoutine.Name)
                          else
                            Name := Preferences.LoadStr(681, SourceRoutine.Name, IntToStr(J));
                          Name := ReplaceStr(Name, ' ', '_');
                          Inc(J);
                        end;

                        Success := Database.CloneRoutine(SourceRoutine, Name);
                      end;
                    end;
              end;
            end;
          end;
        iiBaseTable:
          begin
            SourceDatabase := SourceClient.DatabaseByName(SourceURI.Database);
            if (not Assigned(SourceDatabase)) then
              SourceTable := nil
            else
              SourceTable := SourceDatabase.BaseTableByName(SourceURI.Table);

            if (not Assigned(SourceTable)) then
              MessageBeep(MB_ICONERROR)
            else
            begin
              Database := Client.DatabaseByName(Node.Parent.Text);
              Table := Database.BaseTableByName(Node.Text);

              NewTable := TCBaseTable.Create(Database);
              NewTable.Assign(Table);

              for I := 1 to StringList.Count - 1 do
                if (StringList.Names[I] = 'Field') then
                begin
                  Name := CopyName(StringList.ValueFromIndex[I], NewTable.Fields);

                  NewField := TCBaseTableField.Create(NewTable.Fields);
                  NewField.Assign(SourceTable.FieldByName(StringList.ValueFromIndex[I]));
                  TCBaseTableField(NewField).OriginalName := '';
                  NewField.Name := Name;
                  NewField.FieldBefore := NewTable.Fields[NewTable.Fields.Count - 1];
                  NewTable.Fields.AddField(NewField);
                  NewField.Free();
                end;

              for I := 1 to StringList.Count - 1 do
                if (StringList.Names[I] = 'Index') then
                begin
                  Name := CopyName(StringList.ValueFromIndex[I], NewTable.Indices);

                  NewIndex := TCIndex.Create(NewTable.Indices);
                  NewIndex.Assign(SourceTable.IndexByName(StringList.ValueFromIndex[I]));
                  NewIndex.Name := Name;
                  NewTable.Indices.AddIndex(NewIndex);
                  NewIndex.Free();
                end
                else if (StringList.Names[I] = 'ForeignKey') then
                begin
                  Name := CopyName(StringList.ValueFromIndex[I], NewTable.ForeignKeys);

                  NewForeignKey := TCForeignKey.Create(NewTable.ForeignKeys);
                  NewForeignKey.Assign(SourceTable.ForeignKeyByName(StringList.ValueFromIndex[I]));
                  NewForeignKey.Name := Name;
                  NewTable.ForeignKeys.AddForeignKey(NewForeignKey);
                  NewForeignKey.Free();
                end;

              Database.UpdateTable(Table, NewTable);
              NewTable.Free();
            end;
          end;
        iiHosts:
          for I := 1 to StringList.Count - 1 do
            if (Success and (StringList.Names[I] = 'Host')) then
            begin
              SourceHost := SourceClient.HostByName(StringList.ValueFromIndex[I]);

              if (not Assigned(SourceHost)) then
                MessageBeep(MB_ICONERROR)
              else
              begin
                Name := CopyName(SourceHost.Name, Client.Hosts);

                Success := Client.CloneHost(SourceHost, Name);
              end;
            end;
        iiUsers:
          for I := 1 to StringList.Count - 1 do
            if (Success and (StringList.Names[I] = 'User')) then
            begin
              SourceUser := SourceClient.UserByName(StringList.ValueFromIndex[I]);

              if (not Assigned(SourceUser)) then
                MessageBeep(MB_ICONERROR)
              else
              begin
                Name := CopyName(SourceUser.Name, Client.Users);

                Success := Client.CloneUser(SourceUser, Name);
              end;
            end;
      end;

      if (SourceClientCreated) then
        Clients.ReleaseClient(SourceClient);
    end;

    SourceURI.Free();
  end;
  StringList.Free();
end;

procedure TFClient.PContentChange(Sender: TObject);

  procedure DisableAligns(const Control: TWinControl);
  var
    I: Integer;
  begin
    with Control do SendMessage(Handle, WM_MOVE, 0, MAKELPARAM(Left, Top));
    Control.DisableAlign();
    for I := 0 to Control.ControlCount - 1 do
      if (Control.Controls[I] is TWinControl) then
        DisableAligns(TWinControl(Control.Controls[I]));
  end;

  procedure EnableAligns(const Control: TWinControl);
  var
    I: Integer;
  begin
    for I := 0 to Control.ControlCount - 1 do
      if (Control.Controls[I] is TWinControl) then
        EnableAligns(TWinControl(Control.Controls[I]));
    if (Control.AlignDisabled) then
      Control.EnableAlign();
  end;

var
  Database: TCDatabase;
  I: Integer;
  NewTop: Integer;
  OldActiveControl: TWinControl;
  PResultVisible: Boolean;
  Routine: TCRoutine;
  Table: TCTable;
  Trigger: TCTrigger;
begin
  Database := Client.DatabaseByName(SelectedDatabase);
  if (not Assigned(Database) or (SelectedTable = '')) then
    Table := nil
  else
    Table := Database.TableByName(SelectedTable);
  if (SelectedImageIndex = iiProcedure) then
    Routine := Database.ProcedureByName(SelectedNavigator)
  else if (SelectedImageIndex = iiFunction) then
    Routine := Database.FunctionByName(SelectedNavigator)
  else
    Routine := nil;
  if (SelectedImageIndex = iiTrigger) then
    Trigger := Database.TriggerByName(SelectedNavigator)
  else
    Trigger := nil;

  for I := 0 to Client.Databases.Count - 1 do
    if (Assigned(Client.Databases[I].Workbench)) then
      TWWorkbench(Client.Databases[I].Workbench).Visible := Client.Databases[I].Name = SelectedDatabase;

  if (Sender <> Self) then
  begin
    PResultVisible := True;
    if ((View = avDataBrowser) and Assigned(Table)) then
      SetDataSource(nil, Table.DataSet)
    else if (View = avObjectIDE) then
      case (SelectedImageIndex) of
        iiView: PResultVisible := False;
        iiProcedure,
        iiFunction:
          if ((Sender is TDataSet) and TDataSet(Sender).Active) then
            SetDataSource(Routine.IDEResult, TDataSet(Sender))
          else
            SetDataSource(Routine.IDEResult, Routine.IDEResult.DataSets[Routine.IDEResult.IndexOf(Routine.IDEResult.Selected)]);
        iiTrigger,
        iiEvent: PResultVisible := False;
      end
    else if (View = avQueryBuilder) then
      if ((Sender is TDataSet) and TDataSet(Sender).Active) then
        SetDataSource(Client.QueryBuilderResult, TDataSet(Sender))
      else
        SetDataSource(Client.QueryBuilderResult, Client.QueryBuilderResult.DataSets[Client.QueryBuilderResult.IndexOf(Client.QueryBuilderResult.Selected)])
    else if (View = avSQLEditor) then
      if ((Sender is TDataSet) and TDataSet(Sender).Active) then
        SetDataSource(Client.SQLEditorResult, TDataSet(Sender))
      else
        SetDataSource(Client.SQLEditorResult, Client.SQLEditorResult.DataSets[Client.SQLEditorResult.IndexOf(Client.SQLEditorResult.Selected)])
    else
      PResultVisible := False;
    PResultVisible := PResultVisible and Assigned(FGrid.DataSource.DataSet) and FGrid.DataSource.DataSet.Active;

    if ((View = avDataBrowser) and Assigned(Table)) then
    begin
      FUDOffset.Position := 0;
      FUDLimit.Position := Table.Desktop.Limit;
      FLimitEnabled.Down := Table.Desktop.Limited;
    end;

    if (PResult.Align = alBottom) then
      PResultHeight := PResult.Height;

    OldActiveControl := Window.ActiveControl;
    DisableAligns(PContent);

    if (PList.Align = alClient) then PList.Align := alNone;
    if (PBuilder.Align = alClient) then PBuilder.Align := alNone;
    if (PSQLEditor.Align = alClient) then PSQLEditor.Align := alNone;
    if (PResult.Align = alClient) then PResult.Align := alNone;
    PList.Align := alNone;
    PDataBrowser.Align := alNone;
    PObjectIDE.Align := alNone;
    PBuilder.Align := alNone;
    PSQLEditor.Align := alNone;
    SResult.Align := alNone;
    PResult.Align := alNone;
    SBlob.Align := alNone;
    PBlob.Align := alNone;

    PBlob.Visible := False;

    EnableAligns(PContent);

    if (View = avDataBrowser) then
    begin
      PDataBrowser.Top := 0;
      PDataBrowser.Align := alTop;
      PDataBrowser.Visible := True;
    end
    else
      PDataBrowser.Visible := False;

    if ((View = avObjectIDE) and (Assigned(Routine) and Assigned(Routine.InputDataSet) or Assigned(Trigger) and Assigned(Trigger.InputDataSet))) then
    begin
      PObjectIDE.Top := 0;
      PObjectIDE.Align := alTop;
      PObjectIDE.Visible := True;
    end
    else
      PObjectIDE.Visible := False;

    FText.OnChange := nil;
    if (Assigned(OldActiveControl) and (PResultVisible or (OldActiveControl = FObjectIDEGrid)) and (OldActiveControl is TMySQLDBGrid) and (TMySQLDBGrid(OldActiveControl).SelectedField = EditorField)) then
    begin
      if ((OldActiveControl = FObjectIDEGrid) and (PBlob.Parent <> PContent)) then
        PBlob.Parent := PContent
      else if ((OldActiveControl <> FObjectIDEGrid) and (PBlob.Parent <> PResult)) then
        PBlob.Parent := PResult_2;
      NewTop := PBlob.Parent.ClientHeight - PBlob.Height;
      for I := 0 to PBlob.Parent.ControlCount - 1 do
        if (PBlob.Parent.Controls[I].Align = alBottom) then
          Dec(NewTop, PBlob.Parent.Controls[I].Height);
      PBlob.Top := NewTop;
      PBlob.Align := alBottom;
      PBlob.Visible := True;
    end
    else
    begin
      PBlob.Visible := False;
      PBlob.Parent := PContent;
    end;
    FText.OnChange := FTextChange;

    if (PBlob.Visible) then
    begin
      SBlob.Parent := PBlob.Parent;
      SBlob.Top := PBlob.Top - SBlob.Height;
      SBlob.Align := alBottom;
      SBlob.Visible := True;
    end
    else
    begin
      SBlob.Visible := False;
      SBlob.Parent := nil;
    end;

    if ((Sender is TMySQLDataSet) and (TCResultSet(TMySQLDataSet(Sender).Tag) = Client.SQLEditorResult)) then
    begin
      SBResult.Top := PContent.ClientHeight - SBResult.Height;
      SBResult.Align := alBottom;
      SBResult.Visible := True;
    end
    else
    begin
      SBResult.Align := alNone;
      SBResult.Visible := False;
    end;

    if (PResultVisible and Assigned(FGrid.DataSource.DataSet) and FGrid.DataSource.DataSet.Active) then
    begin
      TCResult.Visible := (View in [avObjectIDE, avSQLEditor]) and (TCResult.Tabs.Count > 1);

      NewTop := PContent.ClientHeight - PResult.Height;
      for I := 0 to PContent.ControlCount - 1 do
        if (PContent.Controls[I].Align = alBottom) then
          Dec(NewTop, PContent.Controls[I].Height);
      PResult.Top := NewTop;
      if (View = avDataBrowser) then
      begin
        PResult.Align := alClient;
        PResult.Left := 0;
        PResult.Height := PContent.ClientHeight - PResult.Top;
        PResult.Width := PContent.ClientWidth
      end
      else
      begin
        PResult.Align := alBottom;
        PResult.Height := PResultHeight;
      end;
      PResultHeader.Visible := View <> avDataBrowser;

      PResult.Visible := True;
    end
    else
      PResult.Visible := False;

    if (PResult.Visible and (PResult.Align = alBottom)) then
    begin
      NewTop := PContent.ClientHeight - SResult.Height;
      for I := 0 to PContent.ControlCount - 1 do
        if (PContent.Controls[I].Align = alBottom) then
          Dec(NewTop, PContent.Controls[I].Height);
      SResult.Top := NewTop;
      SResult.Align := alBottom;
      SResult.Visible := True;
    end
    else
      SResult.Visible := False;

    if (View = avDiagram) then
    begin
      PWorkbench.Align := alClient;
      PWorkbench.Visible := True;
      PWorkbench.BringToFront();
    end
    else
      PWorkbench.Visible := False;

    if ((View = avQueryBuilder) and (SelectedImageIndex in [iiServer, iiDatabase, iiSystemDatabase])) then
    begin
      PBuilder.Align := alClient;
      PBuilder.Visible := True;
    end
    else
      PBuilder.Visible := False;

    if ((View = avSQLEditor) and (SelectedImageIndex in [iiServer, iiDatabase, iiSystemDatabase]) or (View = avObjectIDE) and (SelectedImageIndex in [iiView, iiFunction, iiProcedure, iiEvent, iiTrigger])) then
    begin
      PSQLEditorRefresh(Sender);
      if (Assigned(SynMemo)) then SynMemo.BringToFront();
      PSQLEditor.Align := alClient;
      PSQLEditor.Visible := True;
    end
    else
      PSQLEditor.Visible := False;

    if ((View = avObjectBrowser) and not (SelectedImageIndex in [iiIndex, iiField, iiForeignKey]) or ((View = avDataBrowser) and (SelectedImageIndex = iiServer))) then
    begin
      PList.Align := alClient;
      PList.Visible := True;
      PList.BringToFront();
    end
    else
      PList.Visible := False;
  end;

  PObjectIDEResize(Sender);
  PanelResize(PContent);
  if (Assigned(PResult.OnResize)) then PResult.OnResize(PResult);
end;

procedure TFClient.PContentRefresh(Sender: TObject);
begin
  if (PSQLEditor.Visible) then PSQLEditorRefresh(Sender);
  if (PList.Visible) then FListRefresh(Sender);
  if (PObjectIDE.Visible) then PObjectIDERefresh(Sender);
  if (PWorkbench.Visible) then PWorkbenchRefresh(Sender);

  if ((View = avDataBrowser) and (SelectedImageIndex in [iiBaseTable, iiSystemView, iiView])) then
    if (Assigned(FGrid.DataSource.DataSet)) then
      FGridRefresh(Sender)
    else
      TableOpen(Sender)
  else if ((View in [avObjectIDE, avQueryBuilder, avSQLEditor]) and Assigned(FGrid.DataSource.DataSet) and FGrid.DataSource.DataSet.Active) then
    FGridRefresh(Sender);

  if ((Sender is TMySQLDataSet) and (TCResultSet(TMySQLDataSet(Sender).Tag) = Client.SQLEditorResult)) then
    SBResultRefresh(TMySQLDataSet(Sender));
end;

procedure TFClient.PContentResize(Sender: TObject);
begin
  PanelResize(Sender);
  PToolBar.Width := PContent.Width;
end;

procedure TFClient.PGridResize(Sender: TObject);
begin
  FGrid.Invalidate();
end;

procedure TFClient.PLogResize(Sender: TObject);
begin
  if (PLog.Visible and (FLog.Lines.Count > 0)) then
    PostMessage(FLog.Handle, WM_VSCROLL, SB_BOTTOM, 0);
end;

procedure TFClient.PObjectIDERefresh(Sender: TObject);
var
  Database: TCDatabase;
  I: Integer;
  J: Integer;
  Routine: TCRoutine;
  Trigger: TCTrigger;
begin
  Database := Client.DatabaseByName(SelectedDatabase);
  if (SelectedImageIndex = iiProcedure) then
    Routine := Database.ProcedureByName(SelectedNavigator)
  else if (SelectedImageIndex = iiFunction) then
    Routine := Database.FunctionByName(SelectedNavigator)
  else
    Routine := nil;
  if (SelectedImageIndex = iiTrigger) then
    Trigger := Database.TriggerByName(SelectedNavigator)
  else
    Trigger := nil;

  if (Assigned(Routine)) then
  begin
    FObjectIDEGrid.DataSource.DataSet := Routine.InputDataSet;

    for I := 0 to Routine.ParameterCount - 1 do
      if (Routine.Parameter[I].FieldType = mfEnum) then
        for J := 0 to Length(Routine.Parameter[I].Items) - 1 do
          FObjectIDEGrid.Columns[I].PickList.Add(Routine.Parameter[I].Items[J]);
  end
  else if (Assigned(Trigger)) then
    FObjectIDEGrid.DataSource.DataSet := Trigger.InputDataSet;

  if (Assigned(FObjectIDEGrid.DataSource.DataSet)) then
    for I := 0 to FObjectIDEGrid.DataSource.DataSet.FieldCount - 1 do
      if ((FObjectIDEGrid.Columns[I].Width > Preferences.GridMaxColumnWidth) and not (FObjectIDEGrid.Columns[I].Field.DataType in [ftSmallint, ftInteger, ftLargeint, ftWord, ftFloat, ftDate, ftDateTime, ftTime, ftCurrency])) then
        FObjectIDEGrid.Columns[I].Width := Preferences.GridMaxColumnWidth;

  PObjectIDETrigger.Visible := (SelectedImageIndex = iiTrigger);
  if (PObjectIDETrigger.Visible) then
    DBGridColExit(FObjectIDEGrid);

  PObjectIDEResize(Sender);
end;

procedure TFClient.PObjectIDEResize(Sender: TObject);
var
  I: Integer;
  NewHeight: Integer;
  Rect: TRect;
  ScrollBarInfo: TScrollBarInfo;
begin
  ZeroMemory(@ScrollBarInfo, SizeOf(ScrollBarInfo));
  ScrollBarInfo.cbSize := SizeOf(ScrollBarInfo);
  GetScrollBarInfo(FObjectIDEGrid.Handle, Integer(OBJID_HSCROLL), ScrollBarInfo);

  NewHeight := 0;

  if (BOOL(Header_GetItemRect(FObjectIDEGrid.Header, 0, @Rect))) then
    Inc(NewHeight, Rect.Bottom - Rect.Top + 1);

  Inc(NewHeight, FObjectIDEGrid.DefaultRowHeight);

  if (ScrollBarInfo.rgstate[0] <> STATE_SYSTEM_INVISIBLE) then
    Inc(NewHeight, GetSystemMetrics(SM_CYHSCROLL));

  for I := 0 to PObjectIDE.ControlCount - 1 do
    if (PObjectIDE.Controls[I].Visible and (PObjectIDE.Controls[I].Align in [alTop, alClient, alBottom]) and (PObjectIDE.Controls[I] <> FObjectIDEGrid)) then
      Inc(NewHeight, PObjectIDE.Controls[I].Height);
  PObjectIDE.Height := NewHeight;
end;

function TFClient.PostObject(Sender: TObject): Boolean;
var
  Database: TCDatabase;
  Event: TCEvent;
  NewEvent: TCEvent;
  NewRoutine: TCRoutine;
  NewTrigger: TCTrigger;
  NewView: TCView;
  Routine: TCRoutine;
  RoutineName: string;
  Trigger: TCTrigger;
  View: TCView;
begin
  Database := Client.DatabaseByName(SelectedDatabase);

  case (SelectedImageIndex) of
    iiView:
      begin
        View := Database.ViewByName(SelectedNavigator);

        NewView := TCView.Create(Database);
        NewView.Assign(View);

        NewView.Stmt := Trim(SynMemo.Text);

        Result := Database.UpdateView(View, NewView);

        NewView.Free();
      end;
    iiProcedure,
    iiFunction:
      begin
        if (SelectedImageIndex = iiProcedure) then
        begin
          Routine := Database.ProcedureByName(SelectedNavigator);
          NewRoutine := TCProcedure.Create(Database);
        end
        else
        begin
          Routine := Database.FunctionByName(SelectedNavigator);
          NewRoutine := TCFunction.Create(Database);
        end;
        NewRoutine.Assign(Routine);

        try // This will initate a ParseCreateRoutine - parsing errors are uninteressted
          NewRoutine.Source := Trim(SynMemo.Text);
        except
        end;

        RoutineName := Routine.Name;
        Result := Database.UpdateRoutine(Routine, NewRoutine);

        if (NewRoutine.Name <> SelectedNavigator) then
          FNavigator.Selected.Text := NewRoutine.Name;

        NewRoutine.Free();
      end;
    iiEvent:
      begin
        Event := Database.EventByName(SelectedNavigator);

        NewEvent := TCEvent.Create(Database);
        NewEvent.Assign(Event);

        NewEvent.Stmt := Trim(SynMemo.Text);

        Result := Database.UpdateEvent(Event, NewEvent);

        NewEvent.Free();
      end;
    iiTrigger:
      begin
        Trigger := Database.TriggerByName(SelectedNavigator);

        NewTrigger := TCTrigger.Create(Database);
        NewTrigger.Assign(Trigger);

        NewTrigger.Stmt := Trim(SynMemo.Text);

        Result := Database.UpdateTrigger(Trigger, NewTrigger);

        NewTrigger.Free();
      end;
    else
      Result := False;
  end;

  if (Result) then
  begin
    PObjectIDERefresh(Sender);
    SynMemo.Modified := False;
    FSQLEditorStatusChange(FSQLEditor, []);
  end;
end;

procedure TFClient.PropertiesServerExecute(Sender: TObject);
begin
  Wanted.Clear();

  DServer.Client := Client;
  DServer.Tab := Self;
  DServer.Execute();
end;

procedure TFClient.PSideBarResize(Sender: TObject);
begin
  SetWindowLong(FNavigator.Handle, GWL_STYLE, GetWindowLong(FNavigator.Handle, GWL_STYLE) or TVS_NOHSCROLL);
  SetWindowLong(FSQLHistory.Handle, GWL_STYLE, GetWindowLong(FSQLHistory.Handle, GWL_STYLE) or TVS_NOHSCROLL);

  PSideBarHeader.Width := PSideBar.Width;
  PToolBar.Left := PContent.Left;
end;

procedure TFClient.PSQLEditorRefresh(Sender: TObject);

  function NewSynMemo(): TSynMemo;
  begin
    Result := TSynMemo.Create(FSQLEditor.Owner);

    Result.Align := FSQLEditor.Align;
    Result.BorderStyle := FSQLEditor.BorderStyle;
    Result.HelpType := FSQLEditor.HelpType;
    Result.HelpContext := FSQLEditor.HelpContext;
    Result.Highlighter := FSQLEditor.Highlighter;
    Result.Gutter.AutoSize := FSQLEditor.Gutter.AutoSize;
    Result.Gutter.DigitCount := FSQLEditor.Gutter.DigitCount;
    Result.Gutter.LeftOffset := FSQLEditor.Gutter.LeftOffset;
    Result.Gutter.ShowLineNumbers := FSQLEditor.Gutter.ShowLineNumbers;
    Result.Keystrokes := FSQLEditor.Keystrokes;
    Result.MaxScrollWidth := FSQLEditor.MaxScrollWidth;
    Result.OnChange := FSQLEditor.OnChange;
    Result.OnDragDrop := FSQLEditor.OnDragDrop;
    Result.OnDragOver := FSQLEditor.OnDragOver;
    Result.OnEnter := FSQLEditor.OnEnter;
    Result.OnExit := FSQLEditor.OnExit;
    Result.OnSearchNotFound := FSQLEditor.OnSearchNotFound;
    Result.OnStatusChange := FSQLEditor.OnStatusChange;
    Result.PopupMenu := FSQLEditor.PopupMenu;
    Result.RightEdge := FSQLEditor.RightEdge;
    Result.ScrollHintFormat := FSQLEditor.ScrollHintFormat;
    Result.SearchEngine := FSQLEditor.SearchEngine;

    SynMemoApllyPreferences(Result);

    Result.Parent := FSQLEditor.Parent;
  end;

var
  Database: TCDatabase;
  Event: TCEvent;
  Routine: TCRoutine;
  Trigger: TCTrigger;
  View: TCView;
begin
  if (Self.View = avObjectIDE) then
  begin
    Database := Client.DatabaseByName(SelectedDatabase);

    case (SelectedImageIndex) of
      iiView:
        begin
          View := Database.ViewByName(SelectedNavigator);
          if (not Assigned(View.SynMemo)) then
            View.SynMemo := NewSynMemo();
          SynMemo.Text := Trim(SQLWrapStmt(View.Stmt, ['from', 'where', 'group by', 'having', 'order by', 'limit', 'procedure'], 0)) + #13#10
        end;
      iiProcedure,
      iiFunction:
        begin
          if (SelectedImageIndex = iiProcedure) then
            Routine := Database.ProcedureByName(SelectedNavigator)
          else if (SelectedImageIndex = iiFunction) then
            Routine := Database.FunctionByName(SelectedNavigator)
          else
            Routine := nil;
          if (not Assigned(Routine.SynMemo)) then
            Routine.SynMemo := NewSynMemo();
          SynMemo.Text := Routine.Source + #13#10;
        end;
      iiEvent:
        begin
          Event := Database.EventByName(SelectedNavigator);
          if (not Assigned(Event.SynMemo)) then
            Event.SynMemo := NewSynMemo();
          SynMemo.Text := Event.Stmt + #13#10;
        end;
      iiTrigger:
        begin
          Trigger := Database.TriggerByName(SelectedNavigator);
          if (not Assigned(Trigger.SynMemo)) then
            Trigger.SynMemo := NewSynMemo();
          SynMemo.Text := Trigger.Stmt + #13#10;
        end;
    end;
  end;

  if (Assigned(SynMemo) and Assigned(SynMemo.OnStatusChange)) then SynMemo.OnStatusChange(SynMemo, [scModified]);
end;

procedure TFClient.PWorkbenchRefresh(Sender: TObject);

  function NewWorkbench(const ADatabase: TCDatabase): TWWorkbench;
  begin
    Result := TWWorkbench.Create(PWorkbench.Owner, ADatabase);
    Result.Parent := PWorkbench;
    Result.Align := alClient;
    Result.BorderStyle := bsNone;
    Result.DoubleBuffered := True;
    Result.HelpContext := 1125;
    Result.HideSelection := True;
    Result.HorzScrollBar.Tracking := True;
    Result.MultiSelect := True;
    Result.OnChange := FWorkbenchChange;
    Result.OnDblClick := ListViewDblClick;
    Result.OnDragOver := FWorkbenchDragOver;
    Result.OnDragDrop := FWorkbenchDragDrop;
    Result.OnEnter := FWorkbenchEnter;
    Result.OnExit := FWorkbenchExit;
    Result.OnCursorMove := FWorkbenchCursorMove;
    Result.OnMouseDown := FWorkbenchMouseDown;
    Result.OnValidateControl := FWorkbenchValidateControl;
    Result.OnValidateForeignKeys := FWorkbenchValidateForeignKeys;
    Result.ParentFont := True;
    Result.PopupMenu := MWorkbench;
    Result.VertScrollBar.Tracking := True;

    if (FileExists(Client.Account.DataPath + SelectedDatabase + PathDelim + 'Diagram.xml')) then
      Result.LoadFromFile(Client.Account.DataPath + SelectedDatabase + PathDelim + 'Diagram.xml');
  end;

var
  Database: TCDatabase;
begin
  Database := Client.DatabaseByName(SelectedDatabase);
  if (Assigned(Database)) then
    if (not (Database.Workbench is TWWorkbench)) then
      Database.Workbench := NewWorkbench(Database)
    else
      TWWorkbench(Database.Workbench).Refresh();
end;

function TFClient.RenameCItem(const CItem: TCItem; const NewName: string): Boolean;
var
  BaseTable: TCBaseTable;
  Event: TCEvent;
  Host: TCHost;
  NewBaseTable: TCBaseTable;
  NewEvent: TCEvent;
  NewHost: TCHost;
  NewTrigger: TCTrigger;
  NewUser: TCUser;
  Table: TCTable;
  Trigger: TCTrigger;
  User: TCUser;
begin
  if (CItem is TCTable) then
  begin
    Table := TCTable(CItem);

    Result := Table.Database.RenameTable(Table, NewName);
  end
  else if (CItem is TCTrigger) then
  begin
    Trigger := TCTrigger(CItem);

    NewTrigger := TCTrigger.Create(Trigger.Database);
    NewTrigger.Assign(Trigger);
    NewTrigger.Name := NewName;
    Result := Trigger.Database.UpdateTrigger(Trigger, NewTrigger);
    NewTrigger.Free();
  end
  else if (CItem is TCEvent) then
  begin
    Event := TCEvent(CItem);

    NewEvent := TCEvent.Create(Event.Database);
    NewEvent.Assign(Event);
    NewEvent.Name := NewName;
    Result := Event.Database.UpdateEvent(Event, NewEvent);
    NewEvent.Free();
  end
  else if (CItem is TCBaseTableField) then
  begin
    BaseTable := TCBaseTableField(CItem).Table;

    NewBaseTable := TCBaseTable.Create(BaseTable.Database);
    NewBaseTable.Assign(BaseTable);
    NewBaseTable.FieldByName(CItem.Name).Name := NewName;
    Result := BaseTable.Database.UpdateTable(BaseTable, NewBaseTable);
    NewBaseTable.Free();
  end
  else if (CItem is TCForeignKey) then
  begin
    BaseTable := TCForeignKey(CItem).Table;

    NewBaseTable := TCBaseTable.Create(BaseTable.Database);
    NewBaseTable.Assign(BaseTable);
    NewBaseTable.ForeignKeyByName(CItem.Name).Name := NewName;
    Result := BaseTable.Database.UpdateTable(BaseTable, NewBaseTable);
    NewBaseTable.Free();
  end
  else if (CItem is TCHost) then
  begin
    Host := TCHost(CItem);

    NewHost := TCHost.Create(Client.Hosts);
    NewHost.Assign(Host);
    if (NewName = '<' + Preferences.LoadStr(327) + '>') then
      NewHost.Name := ''
    else
      NewHost.Name := NewName;
    Result := Client.UpdateHost(Host, NewHost);
    NewHost.Free();
  end
  else if (CItem is TCUser) then
  begin
    User := TCUser(CItem);

    NewUser := TCUser.Create(Client.Users);
    NewUser.Assign(User);
    if (NewName = '<' + Preferences.LoadStr(287) + '>') then
      NewUser.Name := ''
    else
      NewUser.Name := NewName;
    Result := Client.UpdateUser(User, NewUser);
    NewUser.Free();
  end
  else
    Result := False;

  if (Assigned(FGrid.DataSource.DataSet) and Result) then
    FGrid.DataSource.DataSet.Close();
end;

function TFClient.ResultSetEvent(const Connection: TMySQLConnection; const Data: Boolean): Boolean;
var
  EndingCommentLength: Integer;
  Len: Integer;
  StartingCommentLength: Integer;
  XML: IXMLNode;
begin
  if (ResultSet = Client.SQLEditorResult) then
  begin
    SelectedDatabase := Client.DatabaseName;   // Maybe a USE Database; was used ...

    if (Client.ErrorCode > 0) then
    begin
      if ((Client.CommandText <> '') and Assigned(SynMemo) and (Length(SynMemo.Text) > Length(Client.CommandText) + 5)) then
      begin
        Len := SQLStmtLength(Client.CommandText);
        SQLTrimStmt(Client.CommandText, 1, Len, StartingCommentLength, EndingCommentLength);
        SynMemo.SelStart := aDRunExecuteSelStart + Client.ExecutedSQLLength + StartingCommentLength;
        SynMemo.SelLength := Len - StartingCommentLength - EndingCommentLength;
      end
    end
    else
    begin
      if ((Client.ExecutedStmts = 1) and Assigned(Client.Account.HistoryXML)) then
      begin
        XML := Client.Account.HistoryXML.AddChild('sql');
        if ((ResultSet.Count = 0) or (ResultSet.RawDataSets[0].FieldCount = 0)) then
          XML.Attributes['type'] := 'statement'
        else
          XML.Attributes['type'] := 'query';
        XML.AddChild('database').Text := Client.DatabaseName;
        XML.AddChild('datetime').Text := FloatToStr(Client.DateTime, FileFormatSettings);
        if (ResultSet.RawDataSets[0].FieldCount >= 0) then
          XML.AddChild('fields').Text := IntToStr(ResultSet.RawDataSets[0].FieldCount);
        if ((ResultSet.RawDataSets[0].FieldCount >= 0) and (ResultSet.RawDataSets[0].RecordCount >= 0)) then
          XML.AddChild('records').Text := IntToStr(ResultSet.RawDataSets[0].RecordCount);
        if (ResultSet.RawDataSets[0].RowsAffected >= 0) then
          XML.AddChild('rows_affected').Text := IntToStr(ResultSet.RawDataSets[0].RowsAffected);
        XML.AddChild('sql').Text := ResultSet.RawDataSets[0].CommandText;
        if (Client.Info <> '') then
          XML.AddChild('info').Text := Client.Info;
        XML.AddChild('execution_time').Text := FloatToStr(Client.ExecutionTime, FileFormatSettings);
        if (Client.Connected and (Client.InsertId > 0)) then
          XML.AddChild('insert_id').Text := IntToStr(Client.InsertId);

        while (Client.Account.HistoryXML.ChildNodes.Count > 100) do
          Client.Account.HistoryXML.ChildNodes.Delete(0);

        FSQLHistoryRefresh(nil);
      end;
    end;
  end;

  Result := False;
end;

procedure TFClient.SaveSQLFile(Sender: TObject);
var
  BytesWritten: DWord;
  CodePage: Cardinal;
  FileBuffer: PAnsiChar;
  Handle: THandle;
  Len: Cardinal;
  Success: Boolean;
  Text: string;
begin
  SaveDialog.Title := ReplaceStr(Preferences.LoadStr(582), '&', '');
  SaveDialog.InitialDir := Preferences.Path;
  SaveDialog.Encodings.Text := EncodingCaptions();
  SaveDialog.EncodingIndex := SaveDialog.Encodings.IndexOf(CodePageToEncoding(Client.CodePage));
  if ((Sender = MainAction('aFSave')) or (Sender = MainAction('aFSaveAs'))) then
  begin
    if (SQLEditor.Filename = '') then
      SaveDialog.FileName := ReplaceStr(Preferences.LoadStr(6), '&', '') + '.sql'
    else
    begin
      SaveDialog.FileName := SQLEditor.Filename;
      SaveDialog.EncodingIndex := SaveDialog.Encodings.IndexOf(CodePageToEncoding(SQLEditor.CodePage));
    end;
    Text := SynMemo.Text;
  end
  else if (Sender = MainAction('aECopyToFile')) then
  begin
    if (Window.ActiveControl = SynMemo) then
    begin
      SaveDialog.FileName := '';
      Text := SynMemo.SelText;
      if (Text = '') then Text := SynMemo.Text;
    end
    else if (Window.ActiveControl = FLog) then
    begin
      SaveDialog.FileName := ReplaceStr(Preferences.LoadStr(11), '&', '') + '.sql';
      Text := FLog.SelText;
      if (Text = '') then Text := FLog.Text;
    end;
  end
  else if (Sender = miHSaveAs) then
  begin
    SaveDialog.FileName := '';
    Text := XMLNode(IXMLNode(FSQLHistoryMenuNode.Data), 'sql').Text;
  end
  else
    Exit;
  SaveDialog.DefaultExt := 'sql';
  SaveDialog.Filter := FilterDescription('sql') + ' (*.sql)|*.sql' + '|' + FilterDescription('*') + ' (*.*)|*.*';
  if (((Sender = MainAction('aFSave')) and (SQLEditor.Filename <> '')) or (Text <> '') and SaveDialog.Execute()) then
  begin
    Preferences.Path := ExtractFilePath(SaveDialog.FileName);

    Handle := CreateFile(PChar(SaveDialog.FileName),
                         GENERIC_WRITE,
                         FILE_SHARE_READ,
                         nil,
                         CREATE_ALWAYS, 0, 0);
    if (Handle = INVALID_HANDLE_VALUE) then
      MsgBox(SysErrorMessage(GetLastError()), Preferences.LoadStr(45), MB_OK + MB_ICONERROR)
    else
    begin
      CodePage := EncodingToCodePage(SaveDialog.Encodings[SaveDialog.EncodingIndex]);

      case (CodePage) of
        CP_UNICODE: Success := WriteFile(Handle, BOM_UNICODE^, Length(BOM_UNICODE), BytesWritten, nil);
        CP_UTF8: Success := WriteFile(Handle, BOM_UTF8^, Length(BOM_UTF8), BytesWritten, nil);
        else Success := True;
      end;

      if (Success) then
        case (CodePage) of
          CP_UNICODE: Success := WriteFile(Handle, Text[1], Length(Text), BytesWritten, nil);
          else
            if (Text <> '') then
            begin
              Len := WideCharToMultiByte(CodePage, 0, PChar(Text), Length(Text), nil, 0, nil, nil);
              if (Len > 0) then
              begin
                GetMem(FileBuffer, Len);
                WideCharToMultiByte(CodePage, 0, PChar(Text), Length(Text), FileBuffer, Len, nil, nil);
                Success := WriteFile(Handle, FileBuffer^, Len, BytesWritten, nil);
                FreeMem(FileBuffer);
              end
              else if (GetLastError() <> 0) then
                raise Exception.Create(SysErrorMessage(GetLastError()));
            end;
        end;

      if (not Success) then
        MsgBox(SysErrorMessage(GetLastError()), Preferences.LoadStr(45), MB_OK + MB_ICONERROR)
      else if ((Sender = MainAction('aFSave')) or (Sender = MainAction('aFSaveAs'))) then
        SynMemo.Modified := False;

      CloseHandle(Handle);
    end;
  end;
end;

procedure TFClient.SBResultRefresh(const DataSet: TMySQLDataSet);
var
  I: Integer;
begin
  SBResult.Panels[0].Text := Preferences.LoadStr(703, IntToStr(DataSet.Connection.ExecutedStmts));
  SBResult.Panels[1].Text := ExecutionTimeToStr(DataSet.Connection.ExecutionTime);
  if (DataSet.Connection.RowsAffected < 0) then
    SBResult.Panels[2].Text := Preferences.LoadStr(658, IntToStr(0))
  else
    SBResult.Panels[2].Text := Preferences.LoadStr(658, IntToStr(DataSet.Connection.RowsAffected));
  if (DataSet.Connection.WarningCount < 0) then
    SBResult.Panels[3].Text := Preferences.LoadStr(704) + ': ???'
  else
    SBResult.Panels[3].Text := Preferences.LoadStr(704) + ': ' + IntToStr(DataSet.Connection.WarningCount);
  if (DataSet.Connection.ExecutedStmts <> 1) then
  begin
    SBResult.Panels[4].Text := '';
    SBResult.Panels[5].Text := '';
  end
  else
  begin
    SBResult.Panels[4].Text := Preferences.LoadStr(124) + ': ' + IntToStr(DataSet.RecordCount);
    SBResult.Panels[5].Text := Preferences.LoadStr(253) + ': ' + IntToStr(DataSet.FieldCount);
  end;

  for I := 0 to SBResult.Panels.Count - 2 do
    SBResult.Panels[I].Width := SBResult.Canvas.TextWidth(SBResult.Panels[I].Text) + 15;
end;

procedure TFClient.SearchNotFound(Sender: TObject; FindText: string);
begin
  MsgBox(Preferences.LoadStr(533, FindText), Preferences.LoadStr(43), MB_OK + MB_ICONINFORMATION);
end;

procedure TFClient.SendQuery(Sender: TObject; const SQL: string);
begin
  if (Assigned(ResultSet)) then
  begin
    if ((Sender is TAction) and (Client.DatabaseByName(SelectedDatabase).Initialize() or Client.DatabaseByName(SelectedDatabase).InitializeSources())) then
      Wanted.Action := TAction(Sender)
    else
    begin
      ResultSet.AfterOpen := DataSetAfterOpen;
      ResultSet.AfterClose := DataSetAfterClose;
      ResultSet.AfterScroll := DataSetAfterScroll;
      ResultSet.BeforePost := DataSetBeforePost;
      ResultSet.AfterPost := DataSetAfterPost;
      ResultSet.BeforeCancel := DataSetBeforeCancel;
      ResultSet.AfterCancel := DataSetAfterCancel;
      ResultSet.BeforeReceivingRecords := DataSetBeforeReceivingRecords;

      SetDataSource();
      ResultSet.Selected := nil;
      PContentChange(Sender);

      Wanted.Action := nil;
      ResultSet.SendSQL(SQL, ResultSetEvent);
    end;
  end
  else if ((View = avObjectIDE) and (SelectedImageIndex = iiEvent)) then
    Client.SendSQL(SQL, ResultSetEvent);
end;

procedure TFClient.SetView(const AView: TView);
var
  URI: TUURI;
begin
  if (AView <> View) then
  begin
    URI := TUURI.Create(Address);

    case (AView) of
      avObjectBrowser: URI.Param['view'] := Null;
      avDataBrowser: URI.Param['view'] := 'browser';
      avObjectIDE: URI.Param['view'] := 'ide';
      avQueryBuilder: URI.Param['view'] := 'builder';
      avSQLEditor: URI.Param['view'] := 'editor';
      avDiagram: URI.Param['view'] := 'diagram';
    end;

    if ((AView = avObjectBrowser) and (SelectedImageIndex in [iiProcedure, iiFunction, iiTrigger, iiEvent])) then
    begin
      URI.Param['objecttype'] := Null;
      URI.Param['object'] := Null;
    end
    else if ((AView = avDataBrowser) and not (SelectedImageIndex in [iiBaseTable, iiSystemView, iiView])) then
    begin
      if (SelectedImageIndex = iiTrigger) then
        URI.Table := SelectedTable
      else
        URI.Table := LastSelectedTable;
    end
    else if ((AView = avObjectIDE) and not (SelectedImageIndex in [iiView, iiProcedure, iiFunction, iiEvent, iiTrigger])) then
      URI.Address := LastObjectIDEAddress
    else if ((AView = avQueryBuilder) and not (SelectedImageIndex in [iiDatabase, iiSystemDatabase])
      or (AView = avSQLEditor) and not (SelectedImageIndex in [iiServer, iiDatabase, iiSystemDatabase])) then
    begin
      if (URI.Database = '') then
        URI.Database := Client.DatabaseName;
      URI.Table := '';
      URI.Param['system'] := Null;
      URI.Param['filter'] := Null;
      URI.Param['offset'] := Null;
      URI.Param['file'] := Null;
    end
    else if ((AView = avDiagram) and not (SelectedImageIndex in [iiDatabase, iiSystemDatabase])) then
    begin
      if (URI.Database = '') then
        URI.Database := LastSelectedDatabase;
      URI.Table := '';
      URI.Param['system'] := Null;
      URI.Param['filter'] := Null;
      URI.Param['offset'] := Null;
      URI.Param['file'] := Null;
    end;

    Address := URI.Address;
    URI.Free();
  end;
end;

procedure TFClient.SetAddress(const AAddress: string);
var
  AllowChange: Boolean;
  ChangeEvent: TTVChangedEvent;
  ChangingEvent: TTVChangingEvent;
  FileName: string;
  NewView: TView;
  NewAddress: string;
  Node: TTreeNode;
  Position: Integer;
  Table: TCTable;
  URI: TUURI;
begin
  AllowChange := True;
  NewAddress := AAddress; // We need this, since in AddressChanging maybe Wanted.Address will be changed, but AAddress is Wanted.Address
  AddressChanging(nil, NewAddress, AllowChange);
  if (AllowChange) then
  begin
    URI := TUURI.Create(NewAddress);

    Node := AddressToNavigatorNode(NewAddress);

    if ((URI.Param['view'] = 'browser') and (Node.ImageIndex in [iiBaseTable, iiSystemView, iiView])) then
      NewView := avDataBrowser
    else if ((URI.Param['view'] = 'ide') and (Node.ImageIndex in [iiProcedure, iiFunction, iiTrigger, iiEvent])) then
      NewView := avObjectIDE
    else if ((URI.Param['view'] = 'builder') and (Node.ImageIndex in [iiDatabase, iiSystemDatabase])) then
      NewView := avQueryBuilder
    else if (URI.Param['view'] = 'editor') then
      NewView := avSQLEditor
    else if ((URI.Param['view'] = 'diagram') and (Node.ImageIndex in [iiDatabase, iiSystemDatabase])) then
      NewView := avDiagram
    else
      NewView := avObjectBrowser;

    ChangingEvent := FNavigator.OnChanging; FNavigator.OnChanging := nil;
    ChangeEvent := FNavigator.OnChange; FNavigator.OnChange := nil;
    FNavigator.Selected := Node;
    FNavigator.OnChanging := ChangingEvent;
    FNavigator.OnChange := ChangeEvent;

    MainAction('aVObjectBrowser').Checked := NewView = avObjectBrowser;
    MainAction('aVDataBrowser').Checked := NewView = avDataBrowser;
    MainAction('aVObjectIDE').Checked := NewView = avObjectIDE;
    MainAction('aVQueryBuilder').Checked := NewView = avQueryBuilder;
    MainAction('aVSQLEditor').Checked := NewView = avSQLEditor;
    MainAction('aVDiagram').Checked := NewView = avDiagram;

    tbObjectBrowser.Down := MainAction('aVObjectBrowser').Checked;
    tbDataBrowser.Down := MainAction('aVDataBrowser').Checked;
    tbObjectIDE.Down := MainAction('aVObjectIDE').Checked;
    tbQueryBuilder.Down := MainAction('aVQueryBuilder').Checked;
    tbSQLEditor.Down := MainAction('aVSQLEditor').Checked;
    tbDiagram.Down := MainAction('aVDiagram').Checked;

    case (NewView) of
      avDataBrowser:
        begin
          Table := Client.DatabaseByName(URI.Database).TableByName(URI.Table);

          FUDOffset.Position := 0;
          FUDLimit.Position := Table.Desktop.Limit;
          FLimitEnabled.Down := Table.Desktop.Limited;

          if (URI.Param['offset'] <> Null) then
          begin
            if (TryStrToInt(URI.Param['offset'], Position)) then FUDOffset.Position := Position else FUDOffset.Position := 0;
            FLimitEnabled.Down := URI.Param['offset'] <> '';
          end;
          if (URI.Param['filter'] <> Null) then
          begin
            FFilter.Text := URI.Param['filter'];
            FFilterEnabled.Down := URI.Param['filter'] <> '';
            FFilterEnabled.Enabled := FFilterEnabled.Down;
          end;

          if ((URI.Param['offset'] <> Null) or (URI.Param['filter'] <> Null)) then
            TableOpen(nil);
        end;
      avSQLEditor:
        if (URI.Param['file'] <> Null) then
        begin
          FileName := URIToPath(URI.Param['file']);
          if (ExtractFilePath(FileName) = '') then
            FileName := ExpandFilename(FileName);
          if (FileExists(FileName) and (FileName <> SQLEditor.Filename)) then
            OpenSQLFile(FileName);
        end;
    end;

    URI.Free();

    AddressChange(nil);
  end;
end;

procedure TFClient.SetDataSource(const ResultSet: TCResultSet = nil; const DataSet: TDataSet = nil);
var
  Database: TCDatabase;
  FieldInfo: TFieldInfo;
  FieldName: string;
  I: Integer;
  Index: Integer;
  Table: TCTable;
  TableName: string;
begin
  if ((DataSet <> LastDataSource.DataSet) and Assigned(FGrid.DataSource.DataSet) and (FGrid.DataSource.DataSet.State <> dsInactive)) then
  begin
    FGrid.DataSource.DataSet.CheckBrowseMode();
    FGrid.DataSource.DataSet.BeforeInsert := nil;
  end;

  if (Assigned(FGrid.DataSource.DataSet) and FGrid.DataSource.DataSet.Active and (DataSet <> LastDataSource.DataSet)) then
    if (FGrid.DataSource.DataSet is TMySQLTable) then
    begin
      TableName := TMySQLTable(FGrid.DataSource.DataSet).TableName;
      while (Pos('.', TableName) > 0) do Delete(TableName, 1, Pos('.', TableName));
      Database := Client.DatabaseByName(TMySQLTable(FGrid.DataSource.DataSet).DatabaseName);
      Table := Database.TableByName(TableName);

      if (Assigned(Table)) then
        for I := 0 to FGrid.Columns.Count - 1 do
        begin
          if ((Table is TCBaseTable) and GetFieldInfo(FGrid.Columns[I].Field.Origin, FieldInfo)) then
            FieldName := FieldInfo.OriginalFieldName
          else if (Table is TCView) then
            FieldName := FGrid.Columns[I].Field.DisplayName
          else
            FieldName := '';
          if (Assigned(Table.FieldByName(FieldName))) then
          begin
            Table.Desktop.GridVisible[FieldName] := FGrid.Columns[I].Visible;
            Table.Desktop.GridWidths[FieldName] := FGrid.Columns[I].Width;
            Table.Desktop.ColumnIndices[I] := FGrid.Columns[I].Field.FieldNo - 1;
          end;
        end;
    end
    else if (Assigned(LastDataSource.ResultSet)) then
    begin
      Index := LastDataSource.ResultSet.IndexOf(LastDataSource.DataSet);
      if (Index >= 0) then
      begin
        if (Index >= Length(LastDataSource.ResultSet.Columns)) then
          SetLength(LastDataSource.ResultSet.Columns, Index + 1);

        SetLength(LastDataSource.ResultSet.Columns[Index].Visible, FGrid.Columns.Count);
        for I := 0 to FGrid.Columns.Count - 1 do
          LastDataSource.ResultSet.Columns[Index].Visible[I] := FGrid.Columns[I].Visible;

        SetLength(LastDataSource.ResultSet.Columns[Index].Width, FGrid.Columns.Count);
        for I := 0 to FGrid.Columns.Count - 1 do
          LastDataSource.ResultSet.Columns[Index].Width[I] := FGrid.Columns[I].Width;

        SetLength(LastDataSource.ResultSet.Columns[Index].Index, FGrid.FieldCount);
        for I := 0 to FGrid.FieldCount - 1 do
          LastDataSource.ResultSet.Columns[Index].Index[I] := FGrid.Fields[I].FieldNo - 1;

        if (LastDataSource.DataSet is TMySQLDataSet) then
          LastDataSource.ResultSet.Selected := TMySQLDataSet(LastDataSource.DataSet);
      end;
    end;

  if (not Assigned(DataSet) or (DataSet.FieldCount = 0)) then
  begin
    FGrid.DataSource.DataSet := nil;
    TCResult.Tabs.Clear();
    TCResult.TabIndex := -1;
  end
  else if ((DataSet <> FGrid.DataSource.DataSet) and DataSet.Active) then
  begin
    FGrid.DataSource.DataSet := DataSet;
    FGrid.DataSource.DataSet.OnDeleteError := SQLError;
    FGrid.DataSource.DataSet.OnEditError := SQLError;
    FGrid.DataSource.DataSet.OnPostError := SQLError;
    FGrid.DoubleBuffered := True;

    if (Assigned(ResultSet)) then
    begin
      if  ((ResultSet <> LastDataSource.ResultSet) or (ResultSet.Count <> TCResult.Tabs.Count)) then
      begin
        TCResult.Tabs.Clear();
        for I := 0 to ResultSet.Count - 1 do
          TCResult.Tabs.Add(Preferences.LoadStr(861, IntToStr(I + 1)));
      end;
      TCResult.TabIndex := ResultSet.IndexOf(DataSet);
      if (DataSet is TMySQLDataSet) then
        ResultSet.Selected := TMySQLDataSet(DataSet);
    end;
  end;

  LastDataSource.ResultSet := ResultSet;
  LastDataSource.DataSet := DataSet;
end;

procedure TFClient.SetSelectedDatabase(const ADatabaseName: string);
var
  DatabaseNode: TTreeNode;
  Node: TTreeNode;
begin
  if (Assigned(FNavigator.Items.getFirstNode())) then
    if (ADatabaseName = '') then
      FNavigator.Items.getFirstNode().Selected := True
    else if (not Assigned(FNavigator.Selected) or not (FNavigator.Selected.ImageIndex in [iiDatabase, iiSystemDatabase]) or (FNavigator.Selected.Text <> ADatabaseName)) then
    begin
      Node := nil;
      FNavigator.Items.getFirstNode().Expand(False);
      DatabaseNode := FNavigator.Items.getFirstNode().getFirstChild();
      while (Assigned(DatabaseNode)) do
      begin
        if ((Client.LowerCaseTableNames <> 1) and (DatabaseNode.Text = ADatabaseName) or (Client.LowerCaseTableNames = 1) and (lstrcmpi(PChar(DatabaseNode.Text), PChar(ADatabaseName)) = 0)) then
          Node := DatabaseNode;
        DatabaseNode := FNavigator.Items.getFirstNode().getNextChild(DatabaseNode);
      end;
      if (Assigned(Node)) then
        FNavigator.Selected := Node;
      if (Assigned(FNavigator.Selected) and FNavigator.AutoExpand) then
        FNavigator.Selected.Expand(False);
    end;

  FNavigatorMenuNode := FNavigator.Selected;
end;

procedure TFClient.SetSelectedItem(const AItem: string);
var
  I: Integer;
begin
  case (View) of
    avObjectBrowser:
      for I := 0 to FList.Items.Count - 1 do
        if (FList.Items[I].Caption = AItem) then
        begin
          FList.Selected := FList.Items[I];
          FList.ItemFocused := FList.Selected;

          if (Assigned(FList.ItemFocused) and (FList.ItemFocused.Position.Y > FList.ClientHeight)) then
            FList.Scroll(0, (FList.ItemFocused.Index + 2) * (FList.Items[1].Top - FList.Items[0].Top) - (FList.ClientHeight - GetSystemMetrics(SM_CYHSCROLL)));
        end;
  end;
end;

procedure TFClient.SetSelectedTable(const ATableName: string);
var
  DatabaseNode: TTreeNode;
  Node: TTreeNode;
  TableNode: TTreeNode;
begin
  if (Assigned(FNavigator.Selected)) then
  begin
    if (ATableName = '') then
      SelectedDatabase := SelectedDatabase // Database im Navigator selektieren
    else
    begin
      Node := nil;
      if (SelectedImageIndex in [iiServer, iiDatabase, iiSystemDatabase]) then
        FNavigator.Selected.Expand(False);
      DatabaseNode := FNavigator.Items.getFirstNode().getFirstChild();
      while (Assigned(DatabaseNode)) do
      begin
        if (DatabaseNode.Text = SelectedDatabase) then
        begin
          TableNode := DatabaseNode.getFirstChild();
          while (Assigned(TableNode)) do
          begin
            if (TableNode.Text = ATableName) then
              Node := TableNode;
            TableNode := DatabaseNode.GetNextChild(TableNode);
          end;
          if (not Assigned(Node)) then
            FNavigator.Selected := DatabaseNode
          else
            FNavigator.Selected := Node;
        end;
        DatabaseNode := FNavigator.Items.getFirstNode().getNextChild(DatabaseNode);
      end;
      if (FNavigator.AutoExpand) then
        FNavigator.Selected.Expand(False);
    end;
  end;

  FNavigatorMenuNode := FNavigator.Selected;
end;

procedure TFClient.SLogCanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  Accept := (PLog.Constraints.MinHeight <= NewSize) and (NewSize <= ClientHeight - PToolBar.Height - SLog.Height - PContent.Constraints.MinHeight);
end;

procedure TFClient.SLogMoved(Sender: TObject);
begin
  FormResize(Sender);
end;

procedure TFClient.smEEmptyClick(Sender: TObject);
begin
  Wanted.Clear();

  Client.SQLMonitor.Clear();
  FLog.Lines.Clear();
  PLogResize(nil);
end;

procedure TFClient.SplitterCanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
var
  Control: TWinControl;
  I: Integer;
  MaxHeight: Integer;
  MinHeight: Integer;
  Splitter: TSplitter_Ext;
begin
  if (Sender is TSplitter_Ext) then
  begin
    Splitter := TSplitter_Ext(Sender); Control := nil;

    MaxHeight := Splitter.Parent.ClientHeight; MinHeight := 0;
    for I := 0 to Splitter.Parent.ControlCount - 1 do
      if (Splitter.Parent.Controls[I].Visible and (Splitter.Parent.Controls[I].Align in [alTop, alClient, alBottom])) then
      begin
        if (Splitter.Parent.Controls[I].Align = alClient) then
          Dec(MaxHeight, Splitter.Parent.Controls[I].Constraints.MinHeight)
        else if (Splitter.Parent.Controls[I].Top <> Splitter.Top + Splitter.Height) then
          Dec(MaxHeight, Splitter.Parent.Controls[I].Height);

        if (Splitter.Parent.Controls[I].Top > Splitter.Top) then
          if (Splitter.Parent.Controls[I].Constraints.MinHeight > 0) then
            Inc(MinHeight, Splitter.Parent.Controls[I].Constraints.MinHeight)
          else
            Inc(MinHeight, Splitter.Parent.Controls[I].Height);

        if ((Splitter.Parent.Controls[I].Top = Splitter.Top + Splitter.Height) and (Splitter.Parent.Controls[I] is TWinControl)) then
          Control := TWinControl(Splitter.Parent.Controls[I]);
      end;

    if (Control.Constraints.MaxHeight > 0) then
      MaxHeight := Min(MaxHeight, Control.Constraints.MaxHeight);

    Accept := (MinHeight <= NewSize) and (NewSize <= MaxHeight);
  end;
end;

procedure TFClient.SQLBuilderSQLUpdated(Sender: TObject);
var
  S: string;
  SQL: string;
begin
  FBuilderEditorPageControlCheckStyle();

  SQL := Trim(SQLBuilder.SQL);
  if (UpperCase(RightStr(SQL, 4)) = 'FROM') then
    SQL := Trim(LeftStr(SQL, Length(SQL) - 4));

  S := Trim(ReplaceStr(ReplaceStr(SQL, #13, ' '), #10, ' '));
  while (Pos('  ', S) > 0) do
    S := ReplaceStr(S, '  ', ' ');
  if (S = 'SELECT *') then
    FBuilderEditor.Lines.Text := ''
  else
  begin
    if (Length(SQL) < 80) then SQL := SQLUnwrapStmt(SQL);
    FBuilderEditor.Lines.Text := SQL + ';';
  end;

  FBuilderEditorStatusChange(FBuilder, [scModified]);
end;

procedure TFClient.SQLError(DataSet: TDataSet; E: EDatabaseError; var Action: TDataAction);
var
  Flags: Integer;
  Msg: string;
begin
  if (E is EDatabasePostError) then
    Msg := Preferences.LoadStr(675)
  else if (E is EMySQLError) then
    case (EMySQLError(E).ErrorCode) of
      CR_CONN_HOST_ERROR: if (EMySQLError(E).Connection.Host <> '') then Msg := Preferences.LoadStr(495, EMySQLError(E).Connection.Host) else Msg := Preferences.LoadStr(495);
      CR_UNKNOWN_HOST: if (EMySQLError(E).Connection.Host <> '') then Msg := Preferences.LoadStr(706, EMySQLError(E).Connection.Host) else Msg := Preferences.LoadStr(706);
      else Msg := Preferences.LoadStr(165, IntToStr(EMySQLError(E).ErrorCode), E.Message);
    end
  else
    Msg := E.Message;

  Flags := MB_CANCELTRYCONTINUE + MB_ICONERROR;
  case (MsgBox(Msg, Preferences.LoadStr(45), Flags, Handle)) of
    IDCANCEL,
    IDABORT: begin Action := daAbort; PostMessage(Handle, CM_ACTIVATEFGRID, 0, 0); end;
    IDRETRY,
    IDTRYAGAIN: Action := daRetry;
    IDCONTINUE,
    IDIGNORE: begin Action := daAbort; DataSet.Cancel(); end;
  end;
end;

procedure TFClient.SQLHelp();
var
  Cancel: Boolean;
  DataSet: TMySQLQuery;
begin
  DataSet := TMySQLQuery.Create(Self);
  DataSet.Connection := Client;
  if (SynMemo.SelText <> '') then
    DataSet.CommandText := 'HELP ' + SQLEscape(SynMemo.SelText)
  else if (SynMemo.WordAtCursor <> '') then
    DataSet.CommandText := 'HELP ' + SQLEscape(SynMemo.WordAtCursor)
  else
    DataSet.CommandText := 'HELP ' + SQLEscape('CONTENTS');
  DataSet.Open();

  if (not DataSet.Active or DataSet.IsEmpty() or not Assigned(DataSet.FindField('name'))) then
    MessageBeep(MB_ICONERROR)
  else
  begin
    Cancel := False;
    while (not Cancel and not Assigned(DataSet.FindField('description')) and not DataSet.IsEmpty()) do
    begin
      repeat
        SetLength(DSelection.Values, Length(DSelection.Values) + 1);
        DSelection.Values[Length(DSelection.Values) - 1] := DataSet.FieldByName('name').AsString;
      until (not DataSet.FindNext());
      Cancel := not DSelection.Execute();
      if (not Cancel) then
      begin
        DataSet.Close();
        DataSet.CommandText := 'HELP ' + SQLEscape(DSelection.Selected);
        DataSet.Open();
      end;
    end;

    if (Assigned(DataSet.FindField('description'))) then
    begin
      DSQLHelp.Title := DataSet.FieldByName('name').AsString;
      DSQLHelp.Description := Trim(DataSet.FieldByName('description').AsString);
      DSQLHelp.Example := Trim(DataSet.FieldByName('example').AsString);
      DSQLHelp.ManualURL := Client.Account.ManualURL;
      DSQLHelp.Refresh();
    end;
  end;

  DataSet.Free();
end;

procedure TFClient.SResultMoved(Sender: TObject);
begin
  if (SBResult.Visible and (SBResult.Align = alBottom)) then
    SBResult.Top := PContent.Height - SBResult.Height;
end;

procedure TFClient.SSideBarCanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  Accept := NewSize <= ClientWidth - SSideBar.Width - PContent.Constraints.MinWidth;
end;

procedure TFClient.SSideBarMoved(Sender: TObject);
begin
  FormResize(Sender);
end;

procedure TFClient.StatusBarRefresh(const Immediately: Boolean = False);
var
  Count: Integer;
  Database: TCDatabase;
  QueryBuilderWorkArea: TacQueryBuilderWorkArea;
  SelCount: Integer;
  Table: TCBaseTable;
  Text: string;
begin
  if (Assigned(StatusBar) and (Immediately or (tsActive in FrameState)) and not (csDestroying in ComponentState) and Assigned(Window)) then
  begin
    KillTimer(Handle, tiStatusBar);

    Count := -1;
    case (View) of
      avObjectBrowser: Count := FList.Items.Count;
      avDataBrowser: if (Assigned(FGrid.DataSource.DataSet) and FGrid.DataSource.DataSet.Active) then Count := FGrid.DataSource.DataSet.RecordCount;
      avObjectIDE,
      avSQLEditor:
        if (Assigned(Window.ActiveControl) and (Window.ActiveControl = SynMemo)) then
          Count := SynMemo.Lines.Count
        else if ((Window.ActiveControl = FGrid) and Assigned(FGrid.DataSource.DataSet)) then
          Count := FGrid.DataSource.DataSet.RecordCount;
      avQueryBuilder:
        begin
          if (Assigned(FBuilderEditorPageControl())) then
          begin
            QueryBuilderWorkArea := FBuilderActiveWorkArea();
            if (Assigned(Window.ActiveControl) and Assigned(QueryBuilderWorkArea) and IsChild(QueryBuilderWorkArea.Handle, Window.ActiveControl.Handle)) then
              Count := FBuilderActiveWorkArea().ControlCount
            else if (Window.ActiveControl = FBuilderEditor) then
              Count := FBuilderEditor.Lines.Count;
          end;
        end;
    end;

    SelCount := -1;
    if ((Window.ActiveControl = FList) and (FList.SelCount > 1)) then
      SelCount := FList.SelCount
    else if (Assigned(SynMemo) and (Window.ActiveControl = SynMemo)) then
      SelCount := 0
    else if ((Window.ActiveControl = FGrid) and (FGrid.SelectedRows.Count > 0)) then
      SelCount := FGrid.SelectedRows.Count;

    if (View <> avDataBrowser) then
      Table := nil
    else
    begin
      Database := Client.DatabaseByName(SelectedDatabase);
      if (not Assigned(Database)) then
        Table := nil
      else
        Table := Database.BaseTableByName(SelectedTable);
    end;

    if (SelCount > 0) then
      Text := Preferences.LoadStr(688, IntToStr(SelCount))
    else if ((View = avDataBrowser) and (FGrid.DataSource.DataSet is TMySQLTable) and not Client.InUse() and Assigned(Table) and TMySQLTable(FGrid.DataSource.DataSet).LimitedDataReceived and (Table.Rows >= 0)) then
      if (Assigned(Client.DatabaseByName(SelectedDatabase).BaseTableByName(SelectedTable).Engine) and (UpperCase(Client.DatabaseByName(SelectedDatabase).BaseTableByName(SelectedTable).Engine.Name) <> 'INNODB')) then
        Text := Preferences.LoadStr(691, IntToStr(Count), IntToStr(Client.DatabaseByName(SelectedDatabase).BaseTableByName(SelectedTable).Rows))
      else
        Text := Preferences.LoadStr(691, IntToStr(Count), '~' + IntToStr(Client.DatabaseByName(SelectedDatabase).BaseTableByName(SelectedTable).Rows))
    else if (Assigned(SynMemo) and (Window.ActiveControl = SynMemo) and (Count >= 0)) then
      Text := IntToStr(Count) + ' ' + ReplaceStr(Preferences.LoadStr(600), '&', '')
    else if ((View = avQueryBuilder) and (Count >= 0)) then
      if (Window.ActiveControl = FBuilderEditor) then
        Text := IntToStr(Count) + ' ' + ReplaceStr(Preferences.LoadStr(600), '&', '')
      else
        Text := Preferences.LoadStr(687, IntToStr(Count))
    else if (Count >= 0) then
      Text := Preferences.LoadStr(687, IntToStr(Count))
    else
      Text := '';
    StatusBar.Panels.Items[sbSummarize].Text := Text;

    if (not Client.InUse()) then
      if ((Window.ActiveControl = FGrid) and Assigned(FGrid.SelectedField)) then
      begin
        if (not FGrid.SelectedField.IsNull) then
          StatusBar.Panels.Items[sbMessage].Text := FGrid.SelectedField.AsString
        else if (Preferences.GridNullText and not FGrid.SelectedField.Required) then
          StatusBar.Panels.Items[sbMessage].Text := '<NULL>';
      end;


    if (not Client.Connected) then
      StatusBar.Panels.Items[sbConnected].Text := ''
    else
      StatusBar.Panels.Items[sbConnected].Text := Preferences.LoadStr(519) + ': ' + FormatDateTime(FormatSettings.ShortTimeFormat, Client.LatestConnect);

    try
      if (Window.ActiveControl = FBuilderEditor) then
        Text := IntToStr(FBuilderEditor.CaretXY.Line) + ':' + IntToStr(FBuilderEditor.CaretXY.Char)
      else if (Assigned(SynMemo) and (Window.ActiveControl = SynMemo)) then
        Text := IntToStr(SynMemo.CaretXY.Line) + ':' + IntToStr(SynMemo.CaretXY.Char)
      else if ((Window.ActiveControl = FList) and Assigned(FList.ItemFocused) and Assigned(FList.Selected) and (FList.ItemFocused.ImageIndex = iiIndex)) then
        Text := Preferences.LoadStr(377) + ': ' + IntToStr(Client.DatabaseByName(SelectedDatabase).BaseTableByName(SelectedTable).IndexByCaption(FList.ItemFocused.Caption).Key)
      else if ((Window.ActiveControl = FList) and (SelectedTable <> '') and Assigned(FList.ItemFocused) and Assigned(FList.Selected) and (FList.ItemFocused.ImageIndex = iiField)) then
        Text := ReplaceStr(Preferences.LoadStr(164), '&', '') + ': ' + IntToStr(Client.DatabaseByName(SelectedDatabase).BaseTableByName(SelectedTable).FieldByName(FList.ItemFocused.Caption).Index)
      else if ((Window.ActiveControl = FGrid) and Assigned(FGrid.SelectedField) and (FGrid.DataSource.DataSet.RecNo >= 0)) then
        Text := IntToStr(FGrid.DataSource.DataSet.RecNo + 1) + ':' + IntToStr(FGrid.SelectedField.FieldNo)
      else
        Text := '';
      StatusBar.Panels.Items[sbItem].Text := Text;
    except
      StatusBar.Panels.Items[sbItem].Text := '';
    end;
  end;
end;

procedure TFClient.StoreFListColumnWidths();
var
  I: Integer;
  Index: Integer;
begin
  if (LastSelectedImageIndex >= 0) then
  begin
    Index := ContentWidthIndexFromImageIndex(LastSelectedImageIndex);
    if ((0 <= Index) and (Index < Length(Client.Account.Desktop.ContentWidths))) then
      for I := 0 to Min(FList.Columns.Count, Length(Client.Account.Desktop.ContentWidths[Index])) - 1 do
        Client.Account.Desktop.ContentWidths[Index][I] := FList.Columns[I].Width;
  end;
end;

procedure TFClient.SynMemoApllyPreferences(const SynMemo: TSynMemo);
begin
  if (SynMemo <> FSQLEditor) then
  begin
    SynMemo.Font.Name := FSQLEditor.Font.Name;
    SynMemo.Font.Style := FSQLEditor.Font.Style;
    SynMemo.Font.Color := FSQLEditor.Font.Color;
    SynMemo.Font.Size := FSQLEditor.Font.Size;
    SynMemo.Font.Charset := FSQLEditor.Font.Charset;
    SynMemo.Gutter.Font.Name := FSQLEditor.Gutter.Font.Name;
    SynMemo.Gutter.Font.Style := FSQLEditor.Gutter.Font.Style;
    SynMemo.Gutter.Font.Color := FSQLEditor.Gutter.Font.Color;
    SynMemo.Gutter.Font.Size := FSQLEditor.Gutter.Font.Size;
    SynMemo.Gutter.Font.Charset := FSQLEditor.Gutter.Font.Charset;
    SynMemo.Gutter.Visible := FSQLEditor.Gutter.Visible;
    SynMemo.Options := FSQLEditor.Options;
    SynMemo.TabWidth := FSQLEditor.TabWidth;
    SynMemo.RightEdge := FSQLEditor.RightEdge;
    SynMemo.WantTabs := FSQLEditor.WantTabs;
    SynMemo.ActiveLineColor := FSQLEditor.ActiveLineColor;
    SynMemo.Highlighter := FSQLEditor.Highlighter;
  end;
end;

procedure TFClient.SynMemoDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  DatabaseName: string;
  S: string;
  SelStart: Integer;
begin
  if ((Source = FNavigator) and (Sender is TSynMemo)) then
  begin
    case (MouseDownNode.ImageIndex) of
      iiIndex: S := Client.DatabaseByName(MouseDownNode.Parent.Parent.Text).BaseTableByName(MouseDownNode.Parent.Text).IndexByCaption(MouseDownNode.Text).Name;
      iiForeignKey: S := Client.DatabaseByName(MouseDownNode.Parent.Parent.Text).BaseTableByName(MouseDownNode.Parent.Text).ForeignKeyByName(MouseDownNode.Text).Name;
      else S := MouseDownNode.Text;
    end;
    SelStart := TSynMemo(Sender).SelStart;
    TSynMemo(Sender).SelText := Client.EscapeIdentifier(S);
    TSynMemo(Sender).SelStart := SelStart;
    TSynMemo(Sender).SelLength := Length(Client.EscapeIdentifier(S));
    TSynMemo(Sender).AlwaysShowCaret := False;

    Window.ActiveControl := TSynMemo(Sender);
  end
  else if ((Source = FSQLHistory) and (Sender is TSynMemo)) then
  begin
    S := XMLNode(IXMLNode(MouseDownNode.Data), 'sql').Text;

    DatabaseName := XMLNode(IXMLNode(MouseDownNode.Data), 'database').Text;
    SelectedDatabase := DatabaseName;
    if (SelectedDatabase <> DatabaseName) then
      S := Client.SQLUse(SelectedDatabase) + S;
    S := ReplaceStr(ReplaceStr(S, #13#10, #10), #10, #13#10);

    SelStart := TSynMemo(Sender).SelStart;
    TSynMemo(Sender).SelText := S;
    TSynMemo(Sender).SelStart := SelStart;
    TSynMemo(Sender).SelLength := Length(S);
    TSynMemo(Sender).AlwaysShowCaret := False;

    Window.ActiveControl := TSynMemo(Sender);
  end
  else if ((Source = FGrid) and (Sender = FSQLEditor)) then
  begin
    S := FGrid.SelectedField.AsString;

    SelStart := TSynMemo(Sender).SelStart;
    TSynMemo(Sender).SelText := S;
    TSynMemo(Sender).SelStart := SelStart;
    TSynMemo(Sender).SelLength := Length(S);
    TSynMemo(Sender).AlwaysShowCaret := False;

    Window.ActiveControl := TSynMemo(Sender);
  end;
end;

procedure TFClient.SynMemoDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if (Source = FNavigator) then
    Accept := MouseDownNode.ImageIndex in [iiDatabase, iiSystemDatabase, iiBaseTable, iiSystemView, iiView, iiProcedure, iiFunction, iiEvent, iiTrigger, iiIndex, iiField, iiSystemViewField, iiViewField, iiForeignKey]
  else if (Source = FSQLHistory) then
    Accept := MouseDownNode.ImageIndex in [iiStatement, iiQuery, iiClock]
  else if (Source = FGrid) then
    Accept := Assigned(FGrid.SelectedField)
      and not FGrid.SelectedField.IsNull
      and not (FGrid.SelectedField.DataType in [ftWideMemo, ftBlob])
  else
    Accept := False;

  if (Accept) then
  begin
    if ((Sender = SynMemo) and not SynMemo.AlwaysShowCaret) then
    begin
      SynMemoBeforeDrag.SelStart := SynMemo.SelStart;
      SynMemoBeforeDrag.SelLength := SynMemo.SelLength;
      SynMemo.AlwaysShowCaret := True;
    end;

    if (not FSQLEditor.Gutter.Visible) then
      SynMemo.CaretX := (X) div SynMemo.CharWidth + 1
    else
      SynMemo.CaretX := (X - SynMemo.Gutter.RealGutterWidth(SynMemo.CharWidth)) div SynMemo.CharWidth + 1;
    SynMemo.CaretY := (Y div SynMemo.LineHeight) + 1;
  end;
end;

procedure TFClient.SynMemoPrintExecute(Sender: TObject);
var
  I: Integer;
  SynEdit: TSynEdit;
begin
  Wanted.Clear();

  if (Window.ActiveControl is TSynMemo) then
  begin
    SynEdit := TSynMemo(Window.ActiveControl);

    FSQLEditorPrint.SynEdit := SynEdit;
    FSQLEditorPrint.Highlight := Assigned(SynEdit.Highlighter);
    FSQLEditorPrint.LineNumbers := SynEdit.Gutter.Visible;
    FSQLEditorPrint.TabWidth := SynEdit.TabWidth;

    PrintDialog.FromPage := 1;
    PrintDialog.ToPage := FSQLEditorPrint.PageCount;
    PrintDialog.MinPage := 1;
    PrintDialog.MaxPage := FSQLEditorPrint.PageCount;
    if (FSQLEditorPrint.PageCount = 1) then
      PrintDialog.Options := PrintDialog.Options - [poPageNums]
    else
      PrintDialog.Options := PrintDialog.Options + [poPageNums];
    if (SynEdit.SelText = '') then
    begin
      PrintDialog.Options := PrintDialog.Options - [poSelection];
      PrintDialog.PrintRange := prAllPages;
    end
    else
    begin
      PrintDialog.Options := PrintDialog.Options + [poSelection];
      PrintDialog.PrintRange := prSelection;
    end;
    if (PrintDialog.Execute()) then
    begin
      FSQLEditorPrint.Copies := PrintDialog.Copies;
      if (SQLEditor.Filename <> '') then
        FSQLEditorPrint.Title := ExtractFileName(SQLEditor.Filename)
      else
        FSQLEditorPrint.Title := ReplaceStr(Preferences.LoadStr(6), '&', '');
      FSQLEditorPrint.Header.Clear();
      FSQLEditorPrint.Header.Add('$TITLE$', nil, taLeftJustify, 1);
      FSQLEditorPrint.Header.Add('$PAGENUM$ / $PAGECOUNT$', nil, taRightJustify, 1);
      FSQLEditorPrint.Footer.Clear();
      FSQLEditorPrint.Footer.Add(Address, nil, taLeftJustify, 1);
      FSQLEditorPrint.Footer.Add(SysUtils.DateTimeToStr(Now(), LocaleFormatSettings), nil, taRightJustify, 1);
      case (PrintDialog.PrintRange) of
        prAllPages,
        prSelection: begin FSQLEditorPrint.SelectedOnly := PrintDialog.PrintRange = prSelection; FSQLEditorPrint.Print(); end;
        prPageNums:
          for I := 0 to PrintDialog.PageRangesCount - 1 do
            FSQLEditorPrint.PrintRange(PrintDialog.PageRanges[I].FromPage, PrintDialog.PageRanges[I].ToPage);
      end;
    end;
  end;
end;

procedure TFClient.TableOpen(Sender: TObject);
var
  Database: TCDatabase;
  FilterSQL: string;
  Limit: Integer;
  Offset: Integer;
  QuickSearch: string;
  SortDef: TIndexDef;
  Table: TCTable;
begin
  PResult.Visible := False; SResult.Visible := PResult.Visible;
  TCResult.Tabs.Clear();
  TCResult.TabIndex := -1;

  Database := Client.DatabaseByName(SelectedDatabase);
  Table := Database.TableByName(SelectedTable);

  if (Assigned(Table) and Assigned(Table.Fields) and (Table.Fields.Count > 0)) then  // Terminate in Table.Fields.GetCount erkennen und Struktur vor SELECT ermitteln, damit bei UPDATE Charset bekannt ist
  begin
    if (not FLimitEnabled.Down) then
    begin
      Offset := 0;
      Limit := 0;
    end
    else
    begin
      Offset := FUDOffset.Position;
      Limit := FUDLimit.Position;
    end;

    if (not FFilterEnabled.Down) then
      FilterSQL := ''
    else
      FilterSQL := FFilter.Text;

    if (not FQuickSearchEnabled.Down) then
      QuickSearch := ''
    else
      QuickSearch := FQuickSearch.Text;

    SortDef := TIndexDef.Create(nil, '', '', []);
    if (Table.DataSet.Active) then
      SortDef.Assign(Table.DataSet.SortDef)
    else if (Client.Account.DefaultSorting and (Table is TCBaseTable) and (TCBaseTable(Table).Indices.Count > 0) and (TCBaseTable(Table).Indices[0].Name = '')) then
      TCBaseTable(Table).Indices[0].GetSortDef(SortDef);

    Table.Open(FilterSQL, QuickSearch, SortDef, Offset, Limit);

    SortDef.Free();
  end;
end;

procedure TFClient.TCResultChange(Sender: TObject);
begin
  if (Assigned(LastDataSource.ResultSet)) then
    LastDataSource.ResultSet.Selected := LastDataSource.ResultSet.DataSets[TCResult.TabIndex];
  PContentChange(Sender);
  PContentRefresh(Sender);
end;

procedure TFClient.TCResultChanging(Sender: TObject; var AllowChange: Boolean);
begin
  FNavigatorChanging(Sender, FNavigator.Selected, AllowChange);
end;

procedure TFClient.ToolBarBlobResize(Sender: TObject);
var
  I: Integer;
  Widths: Integer;
begin
  Widths := 0;
  for I := 0 to ToolBarBlob.ControlCount - 1 do
    if (ToolBarBlob.Controls[I].Visible and (ToolBarBlob.Controls[I] <> tbBlobSpacer)) then
      Inc(Widths, ToolBarBlob.Controls[I].Width);
  Inc(Widths, PBlobSpacer.Height + GetSystemMetrics(SM_CXVSCROLL));
  tbBlobSpacer.Width := ToolBarBlob.Width - Widths;
end;

procedure TFClient.ToolBarTabsClick(Sender: TObject);
begin
  Wanted.Clear();

  if (Sender = mtDataBrowser) then
    if (mtDataBrowser.Checked) then
      Exclude(Preferences.ToolbarTabs, ttDataBrowser)
    else
      Include(Preferences.ToolbarTabs, ttDataBrowser);
  if (Sender = mtObjectIDE) then
    if (mtObjectIDE.Checked) then
      Exclude(Preferences.ToolbarTabs, ttObjectIDE)
    else
      Include(Preferences.ToolbarTabs, ttObjectIDE);
  if (Sender = mtQueryBuilder) then
    if (mtQueryBuilder.Checked) then
      Exclude(Preferences.ToolbarTabs, ttQueryBuilder)
    else
      Include(Preferences.ToolbarTabs, ttQueryBuilder);
  if (Sender = mtSQLEditor) then
    if (mtSQLEditor.Checked) then
      Exclude(Preferences.ToolbarTabs, ttSQLEditor)
    else
      Include(Preferences.ToolbarTabs, ttSQLEditor);
  if (Sender = mtDiagram) then
    if (mtDiagram.Checked) then
      Exclude(Preferences.ToolbarTabs, ttDiagram)
    else
      Include(Preferences.ToolbarTabs, ttDiagram);

  PostMessage(Window.Handle, CM_CHANGEPREFERENCES, 0, 0);
end;

procedure TFClient.ToolButtonStyleClick(Sender: TObject);
begin
  Wanted.Clear();

  TToolButton(Sender).CheckMenuDropdown();
end;

procedure TFClient.TreeViewCollapsed(Sender: TObject; Node: TTreeNode);
begin
  aPExpand.Enabled := not (Node.ImageIndex in [iiServer]) and Node.HasChildren;
  aPCollapse.Enabled := False;

  if ((Sender is TTreeView_Ext) and Assigned(TTreeView_Ext(Sender).PopupMenu)) then
    ShowEnabledItems(TTreeView_Ext(Sender).PopupMenu.Items);
end;

procedure TFClient.TreeViewCollapsing(Sender: TObject;
  Node: TTreeNode; var AllowCollapse: Boolean);
begin
  if ((Sender is TTreeView_Ext) and Assigned(TTreeView_Ext(Sender).OnChange)) then
  begin
    if ((View = avDataBrowser) and not (Node.ImageIndex in [iiBaseTable, iiSystemView, iiView]) and (Node = TTreeView_Ext(Sender).Selected.Parent)) then
      TTreeView_Ext(Sender).Selected := Node;

    AllowCollapse := Node <> TTreeView_Ext(Sender).Items.getFirstNode();
  end;
end;

procedure TFClient.TreeViewEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  if (SynMemo.AlwaysShowCaret) then
  begin
    SynMemo.SelStart := SynMemoBeforeDrag.SelStart;
    SynMemo.SelLength := SynMemoBeforeDrag.SelLength;
    SynMemo.AlwaysShowCaret := False;
  end;
end;

procedure TFClient.TreeViewExpanded(Sender: TObject; Node: TTreeNode);
begin
  aPExpand.Enabled := False;
  aPCollapse.Enabled := Node.ImageIndex <> iiServer;

  if ((Sender is TTreeView_Ext) and Assigned(TTreeView_Ext(Sender).PopupMenu)) then
    ShowEnabledItems(TTreeView_Ext(Sender).PopupMenu.Items);
end;

procedure TFClient.TreeViewGetSelectedIndex(Sender: TObject; Node: TTreeNode);
begin
  Node.SelectedIndex := Node.ImageIndex;
end;

procedure TFClient.TreeViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  LeftMousePressed := (Sender is TTreeView_Ext) and (Button = mbLeft);
  if (LeftMousePressed) then
    MouseDownNode := TTreeView_Ext(Sender).GetNodeAt(X, Y);
end;

procedure TFClient.TreeViewMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  LeftMousePressed := False;
end;

procedure TFClient.TSymMemoGotoExecute(Sender: TObject);
var
  Line: Integer;
begin
  Wanted.Clear();

  if (Window.ActiveControl is TSynMemo) then
  begin
    DGoto.Captions := Preferences.LoadStr(678);
    if (DGoto.Execute()) then
      if (not TryStrToInt(DGoto.Values[0], Line) or (Line < 1) or (TSynMemo(Window.ActiveControl).Lines.Count < Line)) then
        MessageBeep(MB_ICONERROR)
      else
        TSynMemo(Window.ActiveControl).GotoLineAndCenter(Line);
  end;
end;

procedure TFClient.WMNotify(var Message: TWMNotify);
begin
  case (Message.NMHdr^.code) of
    TVN_BEGINLABELEDIT,
    LVN_BEGINLABELEDIT: BeginEditLabel(Window.ActiveControl);
    TVN_ENDLABELEDIT,
    LVN_ENDLABELEDIT: EndEditLabel(Window.ActiveControl);
    LVN_ITEMCHANGING: NMListView := PNMListView(Message.NMHdr);
  end;

  inherited;

  NMListView := nil;
end;

procedure TFClient.WMParentNotify(var Message: TWMParentNotify);
var
  Client: TPoint;
  HeaderRect: TRect;
  Screen: TPoint;
begin
  Client := Point(Message.XPos, Message.YPos);
  Screen := ClientToScreen(Client);

  if ((Message.Event = WM_RBUTTONDOWN)
    and (ControlAtPos(Client, False, True) = PContent)
    and (PContent.ControlAtPos(PContent.ScreenToClient(Screen), False, True) = PResult)
    and (PResult.ControlAtPos(PResult.ScreenToClient(Screen), False, True) = PGrid)
    and (PGrid.ControlAtPos(PGrid.ScreenToClient(Screen), False, True) = FGrid)
    and (GetWindowRect(FGrid.Header, HeaderRect) and PtInRect(HeaderRect, Screen))) then
  begin
    Window.ActiveControl := FGrid;
    FGrid.PopupMenu := MGridHeader;
  end;

  inherited;
end;

procedure TFClient.WMTimer(var Message: TWMTimer);
begin
  case (Message.TimerID) of
    tiNavigator:
      FNavigatorChange2(FNavigator, FNavigator.Selected);
    tiStatusBar:
      begin
        StatusBar.Panels.Items[sbMessage].Text := '';
        StatusBarRefresh();
      end;
  end;
end;

end.

