unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynHighlighterTeX, SynEdit, SynHighlighterSQL,
  ZConnection, ZSqlProcessor, ZDataset, ZSqlUpdate, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, DBCtrls, StdCtrls, Buttons, Menus, inifiles, dbf, DB,
  resource, versiontypes, versionresource;

type
  Tables_Ctrl = object
    Ignore_Table: boolean;
    Ignore_Field: boolean;
  end;

type

  { TfMain }

  TfMain = class(TForm)
    oCmd_Orig: TZSQLProcessor;
    oDbf_Ctr: TDbf;
    oDS_Orig: TDataSource;
    oDS_Dest: TDataSource;
    oDbf_Orig: TDbf;
    Image1: TImage;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    oBtn_Pausa: TBitBtn;
    oBtn_Play: TBitBtn;
    olEstatus: TLabel;
    oBtn_Exit: TBitBtn;
    oQry_GenDes: TZQuery;
    oQry_Orig: TZQuery;
    oSysTrayMenu: TPopupMenu;
    oTimer1: TTimer;
    oConn_Orig: TZConnection;
    oConn_Dest: TZConnection;
    oTrayIcon1: TTrayIcon;
    oQry_Dest: TZQuery;
    oLog: TSynEdit;
    SynSQLSyn1: TSynSQLSyn;
    oCmd_Dest: TZSQLProcessor;
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure oBtn_ExitClick(Sender: TObject);
    procedure oBtn_PausaClick(Sender: TObject);
    procedure oBtn_PlayClick(Sender: TObject);
    function query_selectg(oConn: TZConnection; var oQry_Gen: Tzquery; cSql_Cmd: string): boolean;
    procedure oTimer1Timer(Sender: TObject);
    procedure Start_Connections(iIndex: integer = 0);
    procedure Dataset_To_MySql_Header_Send(var pSqlInsert: WideString; cTblName: string);
    procedure Dataset_To_MySql_Values_Send(var pSqlInsert: WideString; iLimitInserts: integer);
    procedure LogFile(Info: string);
    function IIF(Condition: boolean; TrueResult, FalseResult: variant): variant;
    procedure Dataset_To_DBF_Values_Send(iLimitInserts: integer = 20);
    procedure Dataset_To_Mysql_Create(iIndexTable: integer; cTblName: string);
    function Dest_query_selectgen_result(oConn: TZConnection; cSql_Cmd: string): string;
    function Dest_DatabaseExists(DBName: string): boolean;
    function Dest_TableExists(DBName: string; TableName: string): boolean;
    function Dest_FieldExists2(var field: string; Full_DB_Table_Name: string): boolean;
    function Dest_FieldExists(field: string; Full_DB_Table_Name: string): boolean;
    function Dest_Fields_Counts(Full_DB_Table_Name: string): integer;
    procedure Dest_Add_Ctrl_Field(cTableName: string);
    function Dest_query_updateg(cSql_Cmd: string; bShow_QryMessage: boolean = False): boolean;
    procedure Dest_Connections(bFlag: boolean; cDatabase: string);

    function Orig_TableExists(cTableName: string): boolean;
    function Orig_FieldExists(oTable: TDbf; cField: string): boolean;
    function Orig_Fields_Counts(oTable: TDbf): integer;
    function resourceVersionInfo: string;
  private
    oINI: TINIFile;
    cSrv_Orig, cSrv_Dest: string;
    iAtoplay: integer;
    oSL_Orig: TStringList;
    oSL_Dest: TStringList;
    oMa_Orig: TStringList;
    oMa_Dest: TStringList;
    cDBF_PATHO, cDBF_NAMEO: string;
    cDBF_NAMED: string;
    cDBF_CTRL_DB, cLIMITSELO: string;
    cDatabaseD, cPROTOCOLD, cHOSTNAMED, cUSERNAMED, cPASSWORDD, cLIMITSELD: string;
    cDBF_CTRL_FLD_STOP, cDBF_CTRL_FLD_WAIT: string;
    iPORT_NUMD: integer;
    iDelayTab: integer;
    iTimerDoi: integer;
    iMasterIdx: integer;
    bCheck_CTRL_DB: boolean;
    bCheck_MySqlDb: boolean;
    cMessE_CTRL_DB: string;
    cMessaje_Mant: string;
    oTables_Ctrl: array of Tables_Ctrl;
  public

  end;

var
  fMain: TfMain;
  cPath: string;

implementation

{$R *.frm}

{ TfMain }

procedure TfMain.FormCreate(Sender: TObject);
var
  cPath, cFile: string;
begin
  self.bCheck_CTRL_DB := True;
  self.bCheck_MySqlDb := True;
  self.cMessE_CTRL_DB := '';
  self.cMessaje_Mant := '';

  ShortDateFormat := 'dd/mm/yyyy';
  DateSeparator := '/';
  DecimalSeparator := '.';
  ThousandSeparator := ',';

  cPath := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  cFile := cPath + 'config_sync.ini';

  self.oSL_Orig := TStringList.Create;
  self.oSL_Orig.StrictDelimiter := True;
  self.oMa_Orig := TStringList.Create;
  self.oMa_Orig.StrictDelimiter := True;

  self.oSL_Dest := TStringList.Create;
  self.oSL_Dest.StrictDelimiter := True;
  self.oMa_Dest := TStringList.Create;
  self.oMa_Dest.StrictDelimiter := True;

  oINI := TINIFile.Create(cFile);
  self.cSrv_Orig := oINI.ReadString('GENERAL', 'SRV_ORIGEN', 'CONN_ORIG');
  self.cSrv_Dest := oINI.ReadString('GENERAL', 'SRV_DESTIN', 'CONN_DEST');
  self.iAtoplay := oINI.ReadInteger('GENERAL', 'AUTOPLAY', 1);
  self.iDelayTab := oINI.ReadInteger('GENERAL', 'DELAY_TABL', 0);
  self.iTimerDoi := oINI.ReadInteger('GENERAL', 'TIMER_DOIT', 3);

  self.oMa_Orig.CommaText := oINI.ReadString(cSrv_Orig, 'MASTER_FIELD', '');
  self.oSL_Orig.CommaText := oINI.ReadString(cSrv_Orig, 'TABLES_NAMES', '');
  self.cDBF_PATHO := oINI.ReadString(cSrv_Orig, 'DBF_PATH', '');
  self.cLIMITSELO := oIni.ReadString(cSrv_Orig, 'LIMITSEL', '25');

  self.cDBF_CTRL_DB := oIni.ReadString(cSrv_Orig, 'STOP_CTRL_DB', '');
  self.cDBF_CTRL_FLD_STOP := oIni.ReadString(cSrv_Orig, 'STOP_CTRL_FLD_STOP', 'stop');
  self.cDBF_CTRL_FLD_WAIT := oIni.ReadString(cSrv_Orig, 'STOP_CTRL_FLD_WAIT', 'eng_stoped');

  self.oMa_Dest.CommaText := oINI.ReadString(cSrv_Dest, 'MASTER_FIELD', '');
  self.oSL_Dest.CommaText := oINI.ReadString(cSrv_Dest, 'TABLES_NAMES', '');
  self.cDatabaseD := oINI.ReadString(cSrv_Dest, 'DB_NAME', 'cas');
  self.cPROTOCOLD := oINI.ReadString(cSrv_Dest, 'PROTOCOL', 'mysql');
  self.cHOSTNAMED := oINI.ReadString(cSrv_Dest, 'HOSTNAME', '127.0.0.1');
  self.cUSERNAMED := oINI.ReadString(cSrv_Dest, 'USERNAME', 'root');
  self.cPASSWORDD := oINI.ReadString(cSrv_Dest, 'PASSWORD', '');
  self.iPORT_NUMD := oIni.ReadInteger(cSrv_Dest, 'PORT_NUM', 3306);
  self.cLIMITSELD := oIni.ReadString(cSrv_Dest, 'LIMITSEL', '25');

  oINI.Free;
  self.oTimer1.Interval := (iTimerDoi * 1000);
  self.oTimer1.Enabled := False;

  SetLength(oTables_Ctrl, self.oSL_Orig.Count);
end;

procedure TfMain.FormShow(Sender: TObject);
begin
  self.Caption := 'Sincronizador de datos ' + self.resourceVersionInfo();
  self.oLog.Lines.Clear;

  self.oDbf_Ctr.Close;
  self.oDbf_Ctr.FilePathFull := self.cDBF_PATHO;
  self.oDbf_Ctr.TableName := self.cDBF_CTRL_DB;
  self.oDbf_Ctr.Exclusive := False;
  self.oDbf_Ctr.Filter := '';
  self.oDbf_Ctr.Filtered := False;
  self.oDbf_Ctr.ShowDeleted := False;
  try
    self.oDbf_Ctr.Open;
    self.oDbf_Ctr.First;

    self.oLog.Lines.Insert(0, 'Apertura de tabla de control [' + self.cDBF_CTRL_DB + '] exitosa.');
    self.oLog.Repaint;
  except
    self.oLog.Lines.Insert(0, 'Error al tratar de abrir la tabla de control [' + self.cDBF_CTRL_DB + '].');
    self.oLog.Repaint;
  end;

end;

procedure TfMain.Dest_Connections(bFlag: boolean; cDatabase: string);
begin
  if (bFlag = False) then
  begin
    self.oConn_Dest.Connected := False;
  end
  else
  begin
    self.oConn_Dest.Connected := False;
    self.oConn_Dest.Protocol := self.cPROTOCOLD;
    self.oConn_Dest.HostName := self.cHOSTNAMED;
    self.oConn_Dest.User := self.cUSERNAMED;
    self.oConn_Dest.Password := self.cPASSWORDD;
    self.oConn_Dest.Port := self.iPORT_NUMD;
    self.oConn_Dest.Catalog := cDatabase;
    self.oConn_Dest.Database := cDatabase;
    self.oConn_Dest.Connected := True;
  end;
end;

procedure TfMain.Start_Connections(iIndex: integer = 0);
begin
  self.cDBF_NAMEO := Trim(self.oSL_Orig[iIndex]);
  self.oLog.Lines.AddStrings('Iniciando apertura de origen:' + self.cDBF_NAMEO);
  self.oLog.Repaint;

  self.oLog.Lines.Insert(0, '[' + self.cDBF_NAMED + '], Es un DBF el origen.');
  self.oLog.Repaint;

  self.oDbf_Orig.Close;
  self.oDbf_Orig.FilePathFull := self.cDBF_PATHO;
  self.oDbf_Orig.TableName := self.cDBF_NAMEO;
  self.oDbf_Orig.Exclusive := False;
  self.oDbf_Orig.Filter := '';
  self.oDbf_Orig.Filtered := False;
  self.oDbf_Orig.ShowDeleted := False;
  //self.oDbf_Orig.ReadOnly := True;
  try
    self.oDbf_Orig.Open;
    self.oDbf_Orig.First;

    self.oLog.Lines.Insert(0, 'Apertura de origen [' + self.cDBF_NAMED + '] exitosa.');
    self.oLog.Repaint;
  except
    self.oLog.Lines.Insert(0, 'Error al tratar de abrir el origen [' + self.cDBF_NAMED + '].');
    self.oLog.Repaint;
  end;
  SELF.oDS_Orig.DataSet := self.oDbf_Orig;

  self.cDBF_NAMED := Trim(self.oSL_Dest[iIndex]);

  self.oConn_Dest.Connected := False;
  self.oConn_Dest.Protocol := self.cPROTOCOLD;
  self.oConn_Dest.HostName := self.cHOSTNAMED;
  self.oConn_Dest.User := self.cUSERNAMED;
  self.oConn_Dest.Password := self.cPASSWORDD;
  self.oConn_Dest.Port := self.iPORT_NUMD;
  self.oConn_Dest.Catalog := self.cDatabaseD;
  self.oConn_Dest.Database := self.cDatabaseD;
  self.oConn_Dest.Connected := True;

  self.oQry_Dest.Connection := self.oConn_Dest;
  self.oQry_Dest.Close;
  self.oQry_Dest.Filter := '';
  self.oQry_Dest.Filtered := False;
end;

procedure TfMain.Dataset_To_DBF_Values_Send(iLimitInserts: integer = 20);
var
  i: integer;
  cField: string;
  vValue: variant;
  sValue: string;
  wValue: WideString;
  cField_Value: string;
  iType: TFieldType;
  iCount: integer;
  iRegs_Count: integer;
  bFindDbf, bExit: boolean;
  cFilter: string;
  cFldMasOrig: string;
  cValMasOrig: string;

  cFldMasDest: string;
begin
  //ShortDateFormat := 'yyyy-mm-dd';
  iRegs_Count := 0;
  wValue := '';
  wValue := wValue + 'SELECT ' + SELF.oSL_Dest[self.iMasterIdx] + ' '#13;
  cField_Value := '';

  self.oQry_Dest.First;
  while not (self.oQry_Dest.EOF) and (iRegs_Count <= iLimitInserts) do
  begin
    cFldMasOrig := self.oMa_Orig[self.iMasterIdx];
    cFldMasDest := self.oMa_Dest[self.iMasterIdx];
    cValMasOrig := self.oQry_Dest.FieldByName(cFldMasDest).AsString;
    cFilter := cFldMasOrig + '="' + cValMasOrig + '"';

    //bFindDbf := self.oDbf_Orig.Locate(cFldMasOrig, cValMasOrig, []);
    //if (bFindDbf = True) then
    begin
      self.oDbf_Orig.Filter := cFilter;
      self.oDbf_Orig.Filtered := True;
      self.oDbf_Orig.First;

      bFindDbf := False;
      bExit := False;
      while not (self.oDbf_Orig.EOF) and (bExit = False) do
      begin
        bFindDbf := True;
        bExit := True;
      end;
    end;

    if (bFindDbf = True) then
    begin
      self.oDbf_Orig.Edit;
    end
    else
    begin
      wValue := wValue + 'APPEND BLANK ' + #13;
      self.oDbf_Orig.Insert;
    end;

    wValue := wValue + 'REPLACE ' + #13;

    for i := 0 to (self.oQry_Dest.FieldCount - 1) do
    begin
      cField := self.oQry_Dest.Fields[i].FieldName;
      vValue := self.oQry_Dest.Fields[i].Value;
      sValue := self.oQry_Dest.Fields[i].AsString;
      iType := self.oQry_Dest.Fields[i].DataType;
      if (LOWERCASE(TRIM(cField)) <> 'autoin') then
      begin
        if (self.oQry_Dest.Fields[i].IsNull = True) then
        begin
          self.oDbf_Orig.FieldByName(cField).Value := null;
          wValue := wValue + cField + ' WITH .NULL.,' + #13;
        end
        else
        begin
          if iType in [ftDate, ftDateTime, ftTimeStamp] then
          begin
            if ((sValue = '0000-00-00') or (sValue = '0000-00-00 00:00:00')) then
              cField_Value := '"1900/01/01"'
            else
            begin
              cField_Value := formatdatetime('dd/mm/yyyy', self.oQry_Dest.Fields[i].AsDateTime);
              self.oDbf_Orig.FieldByName(cField).AsString := cField_Value;
              wValue := wValue + cField + ' WITH "' + cField_Value + '",' + #13;
              //self.oDbf_Orig.FieldByName(cField).AsDateTime := self.oQry_Dest.Fields[i].AsDateTime;
            end;
          end
          else if iType in [ftString, ftMemo, ftWideString] then
          begin
            self.oDbf_Orig.FieldByName(cField).AsString := self.oQry_Dest.Fields[i].AsString;
            wValue := wValue + cField + ' WITH "' + self.oQry_Dest.Fields[i].AsString + '",' + #13;
          end
          else if iType in [ftFloat, ftCurrency] then
          begin
            self.oDbf_Orig.FieldByName(cField).AsFloat := self.oQry_Dest.Fields[i].AsFloat;
            wValue := wValue + cField + ' WITH ' + formatfloat('####0.00', self.oQry_Dest.Fields[i].AsFloat) + ',' + #13;
          end
          else if iType in [ftUnknown] then
          begin
            self.oDbf_Orig.FieldByName(cField).Value := null;
            wValue := wValue + cField + ' WITH .NULL.,' + #13;
          end
          else if iType in [ftInteger, ftSmallint, ftWord, ftLargeint] then
          begin
            self.oDbf_Orig.FieldByName(cField).Value := self.oQry_Dest.Fields[i].Value;
            wValue := wValue + cField + ' WITH ' + formatfloat('####0', self.oQry_Dest.Fields[i].Value) + ',' + #13;
          end
          else
          begin
            self.oDbf_Orig.FieldByName(cField).AsString := self.oQry_Dest.Fields[i].AsString;
            wValue := wValue + cField + ' WITH "' + self.oQry_Dest.Fields[i].AsString + '",' + #13;
          end;
        end;
        //self.oDbf_Orig.FieldByName(cField).AsString := cField_Value;
        //wValue := wValue + cField + ' WITH "' + self.oQry_Dest.Fields[i].AsString + '",' + #13;
      end;
    end;

    if (RightStr(trim(wValue), 1) = ',') then
    begin
      wValue := copy(trim(wValue), 1, length(trim(wValue)) - 1);
    end;

    self.oLog.Lines.Insert(0, 'INSERTANDO:' + #10 + wValue + #10);
    self.oLog.Repaint;
    self.LogFile(wValue);

    self.oDbf_Orig.FieldByName('flag_modif').Value := 0;
    self.oDbf_Orig.Post;

    self.oQry_Dest.Edit;
    self.oQry_Dest.FieldByName('flag_modif').Value := 0;
    self.oQry_Dest.Post;

    iRegs_Count := iRegs_Count + 1;
    self.oQry_Dest.Next;

    self.oDbf_Orig.filter := '';

  end;
end;

procedure TfMain.FormActivate(Sender: TObject);
begin
  if (self.iAtoplay = 1) then
  begin
    self.oBtn_PlayClick(self);
  end;
end;

procedure TfMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  self.oSL_Orig.Free;
  self.oSL_Dest.Free;
  self.oDbf_Orig.Close;
  self.oDbf_Orig.Free;
end;

procedure TfMain.MenuItem3Click(Sender: TObject);
begin
  self.WindowState := wsMinimized;
end;

procedure TfMain.MenuItem4Click(Sender: TObject);
begin
  self.WindowState := wsNormal;
end;

procedure TfMain.oBtn_ExitClick(Sender: TObject);
begin
  self.olEstatus.Caption := 'ESTATUS: FINALIZADO';
  self.oTimer1.Enabled := False;
  Close;
end;

procedure TfMain.oBtn_PausaClick(Sender: TObject);
begin
  self.olEstatus.Caption := 'ESTATUS: EN PAUSA';
  self.oTimer1.Enabled := False;
  self.oBtn_Play.Enabled := True;
  self.oBtn_Pausa.Enabled := False;
end;

procedure TfMain.oBtn_PlayClick(Sender: TObject);
begin
  self.olEstatus.Caption := 'ESTATUS: PROCESANDO';
  self.oTimer1.Enabled := True;
  self.oBtn_Play.Enabled := False;
  self.oBtn_Pausa.Enabled := True;
end;

function TfMain.query_selectg(oConn: TZConnection; var oQry_Gen: Tzquery; cSql_Cmd: string): boolean;
begin
  if (oQry_Gen = nil) then
  begin
    oQry_Gen := Tzquery.Create(self);
  end;

  if (oQry_Gen.Connection = nil) then
  begin
    oQry_Gen.Connection := oConn;
  end;

  oQry_Gen.Close;
  oQry_Gen.SQL.Clear;
  oQry_Gen.SQL.Text := cSql_Cmd;
  oQry_Gen.Open;
  if (oQry_Gen.Fields[0].AsWideString = '') then
    Result := False
  else
    Result := True;
end;

function TfMain.Dest_query_selectgen_result(oConn: TZConnection; cSql_Cmd: string): string;
begin
  try
    self.oQry_GenDes.Close;
    self.oQry_GenDes.SQL.Clear;
    self.oQry_GenDes.SQL.Text := cSql_Cmd;
    self.oQry_GenDes.Open;
    if (self.oQry_GenDes.Fields[0].Text <> '') then
      Result := self.oQry_GenDes.Fields[0].Text
    else
      Result := self.oQry_GenDes.Fields[0].Text;
    self.oQry_GenDes.Close;
  except
    Result := '';
  end;
end;

{ --------------------------------------------------------------------------------------------
  Esta función devuelve true si la tabla existe en la base de datos y false si no existe.
  ---------------------------------------------------------------------------------------------- }
function TfMain.Dest_TableExists(DBName: string; TableName: string): boolean;
var
  cSqlCmdl: string;
begin
  cSqlCmdl := 'SHOW TABLES FROM ' + DBName + ' LIKE "' + TableName + '" ';
  self.oQry_GenDes.Close;
  self.query_selectg(self.oConn_Dest, self.oQry_GenDes, cSqlCmdl);
  if not self.oQry_GenDes.EOF then
  begin
    if (self.oQry_GenDes.RecordCount > 0) then
      Result := True
    else
      Result := False;
  end
  else
    Result := False;
  self.oQry_GenDes.Close;
end;

{ --------------------------------------------------------------------------------------------
  Esta función devuelve true si la base de datos existe en mysql.
  ---------------------------------------------------------------------------------------------- }
function TfMain.Dest_DatabaseExists(DBName: string): boolean;
var
  cSqlCmdl: string;
begin
  self.oQry_GenDes.Close;
  cSqlCmdl := 'SHOW DATABASES LIKE "' + DBName + '" ';
  self.query_selectg(self.oConn_Dest, self.oQry_GenDes, cSqlCmdl);
  if not self.oQry_GenDes.EOF then
  begin
    if (self.oQry_GenDes.RecordCount > 0) then
      Result := True
    else
      Result := False;
  end
  else
    Result := False;
  self.oQry_GenDes.Close;
end;

{ --------------------------------------------------------------------------------------------
  Esta función devuelve true si el campo existe en la tabla y false si no existe.
  ---------------------------------------------------------------------------------------------- }
function TfMain.Dest_FieldExists(field: string; Full_DB_Table_Name: string): boolean;
var
  cSqlCmdl: string;
begin
  self.oQry_GenDes.Close;
  cSqlCmdl := 'SHOW COLUMNS FROM ' + Full_DB_Table_Name + ' WHERE UCASE(field)=UCASE("' + trim(field) + '") ';
  if self.query_selectg(self.oConn_Dest, self.oQry_GenDes, cSqlCmdl) = True then
  begin
    if self.oQry_GenDes.RecordCount > 0 then
    begin
      Result := True;
    end
    else
      Result := False;
  end
  else
    Result := False;
  self.oQry_GenDes.Close;
end;

{ --------------------------------------------------------------------------------------------
  Esta función devuelve true si el campo existe en la tabla y false si no existe.
  ---------------------------------------------------------------------------------------------- }
function TfMain.Dest_FieldExists2(var field: string; Full_DB_Table_Name: string): boolean;
var
  cSqlCmdl: string;
begin
  cSqlCmdl := 'SHOW COLUMNS FROM ' + Full_DB_Table_Name + ' WHERE UCASE(field)=UCASE("' + trim(field) + '") ';
  self.oQry_GenDes.Close;
  if self.query_selectg(self.oConn_Dest, self.oQry_GenDes, cSqlCmdl) = True then
  begin
    if self.oQry_GenDes.RecordCount > 0 then
    begin
      field := self.oQry_GenDes.FieldByName('field').AsString;
      Result := True;
    end
    else
      Result := False;
  end
  else
    Result := False;
  self.oQry_GenDes.Close;
end;

{ --------------------------------------------------------------------------------------------
  Esta función devuelve el numero de campos de una tabla, es necesarios especificada la tabla .
  ---------------------------------------------------------------------------------------------- }
function TfMain.Dest_Fields_Counts(Full_DB_Table_Name: string): integer;
var
  cSqlCmdl: string;
begin
  Result := 0;
  cSqlCmdl := 'SHOW COLUMNS FROM ' + Full_DB_Table_Name + ' ';
  self.oQry_GenDes.Close;
  self.query_selectg(self.oConn_Dest, self.oQry_GenDes, cSqlCmdl);
  if not self.oQry_GenDes.EOF then
    Result := self.oQry_GenDes.RecordCount;
  self.oQry_GenDes.Close;
end;

{ --------------------------------------------------------------------------------------------
  Esta función ejecuta comandos sql en una coneccion.
  ---------------------------------------------------------------------------------------------- }
function TfMain.Dest_query_updateg(cSql_Cmd: string; bShow_QryMessage: boolean = False): boolean;
var
  ex_query: tzquery;
  bShowMessage: boolean;
begin

  if (bShow_QryMessage = True) then
  begin
    if (bShowMessage = False) then
    begin
      bShowMessage := True;
    end;
  end;

  ex_query := tzquery.Create(nil);
  ex_query.Connection := self.oConn_Dest;

  ex_query.Close;
  ex_query.SQL.Clear;
  ex_query.SQL.Text := cSql_Cmd;

  try
    ex_query.ExecSQL;
    Result := True;
  except
    on E: Exception do
    begin
      if (bShowMessage = True) then
        application.ShowException(E);
      Result := False;
    end;
  end;
  FreeAndNil(ex_query);
end;

procedure TfMain.oTimer1Timer(Sender: TObject);
var
  I, iCount: integer;
  cSql_Ln: WideString;
  cMessage: string;
  iField1, iField2: integer;
  bSkip_Table: boolean;
begin
  cMessage := '';
  bSkip_Table := False;

  //1.0-------------------------------------VERIFICA SI LA BASE DE DATOS DESTINO EXISTE-------------------------------------
  if (self.bCheck_MySqlDb = True) then
  begin
    self.Dest_Connections(True, 'mysql');
    if (self.Dest_DatabaseExists(self.cDatabaseD) = False) then
    begin
      cMessage := 'ERR-> BASE DE DATOS DESTINO [' + self.cSrv_Dest + '->`' + trim(self.cDatabaseD) + '`] NO EXISTE.';
      self.oLog.Lines.Insert(0, cMessage);
      self.oLog.Repaint;

      cSql_Ln := 'CREATE DATABASE IF NOT EXISTS `' + trim(self.cDatabaseD) + '` /*!40100 COLLATE "utf8_general_ci" */;';
      self.Dest_query_updateg(cSql_Ln);

      self.oLog.Lines.Insert(0, cSql_Ln);
      self.oLog.Repaint;
    end;
    self.Dest_Connections(False, '');
    self.bCheck_MySqlDb := False;
  end;
  //----------------------------------------------------------------------------------------------------------------------

  //2.0---------------------------------------VERIFICA TABLA DE CONTROL DE CLICOS-----------------------------------------
  self.oDbf_Ctr.Refresh;
  if (self.bCheck_CTRL_DB = True) then
  begin
    self.cMessE_CTRL_DB := '';
    if (self.Orig_TableExists(self.cDBF_CTRL_DB) = False) then
    begin
      self.bCheck_CTRL_DB := False;
      self.cMessE_CTRL_DB := 'ERR-> TABLA DE CONTROL(' + self.cDBF_PATHO + '/' + self.cDBF_CTRL_DB + '), NO EXISTE!!!' + #13;
    end
    else
    begin
      if ((self.Orig_FieldExists(self.oDbf_Ctr, self.cDBF_CTRL_FLD_STOP) = False) or
        (self.Orig_FieldExists(self.oDbf_Ctr, self.cDBF_CTRL_FLD_WAIT) = False)) then
      begin
        self.bCheck_CTRL_DB := False;
        self.cMessE_CTRL_DB := self.cMessE_CTRL_DB + 'ERR-> TABLA DE CONTROL (' + self.cDBF_PATHO + '/' +
          self.cDBF_CTRL_DB + '), LA ESTRUCTURA LE FANTAN LOS CAMPOS ("' + self.cDBF_CTRL_FLD_STOP + '" ó "' + self.cDBF_CTRL_FLD_WAIT + '").';
      end;
    end;
  end;

  if (trim(self.cMessE_CTRL_DB) = '') then
  begin
    //2.1-------------------------------------VERIFICA ORDENES DEL LA TABLA DE CONTROL---------------------------------------
    if not self.oDbf_Ctr.FieldByName(self.cDBF_CTRL_FLD_STOP).IsNull then
    begin
      if (self.oDbf_Ctr.FieldByName(self.cDBF_CTRL_FLD_STOP).AsInteger = 1) then
      begin
        self.oDbf_Ctr.Edit;
        self.oDbf_Ctr.FieldByName(self.cDBF_CTRL_FLD_WAIT).AsInteger := 1;
        self.oDbf_Ctr.Post;
        if (self.cMessaje_Mant = '') then
        begin
          self.cMessaje_Mant := 'SE RECIBIO UNA ORDEN DE SUSPENCION POR MANTENIMIENTO!!!';
          self.oLog.Lines.Insert(0, self.cMessaje_Mant);
          self.oLog.Repaint;
        end;
        exit;
      end
      else
        self.cMessaje_Mant := '';
    end;
  end
  else
  begin
    self.oLog.Lines.Insert(0, self.cMessE_CTRL_DB);
    self.oLog.Repaint;
  end;
  //-------------------------------------------------------------------------------------------------------------------------

  self.oTimer1.Enabled := False;
  if (self.oLog.Lines.Count > 100) then
  begin
    self.LogFile(self.oLog.Text);
    self.oLog.Lines.Clear;
  end;
  self.iMasterIdx := -1;
  if (self.oSL_Orig.Count > -1) then
  begin

    for I := 0 to self.oSL_Orig.Count - 1 do
    begin
      bSkip_Table := False;
      self.iMasterIdx := I;

      //------------------------------------------*ENVIO DE INFORMACION AL ESTINO*-----------------------------------------//
      self.Start_Connections(I);

      //3.0---------------------------------------VERIFICA CAMPOS DE CONTROL EN ORIGEN-------------------------------------
      if (self.Orig_FieldExists(self.oDbf_Orig, 'flag_modif') = False) then
      begin
        cMessage := 'ERR-> TABLA ORIGEN [' + self.cDBF_PATHO + '\' + self.oSL_Orig[I] + '] NO CONTIENE CAMPO DE CONTROL ("flag_modif")';
        self.oLog.Lines.Insert(0, cMessage);
        self.oLog.Repaint;
        bSkip_Table := True;
      end;

      //3.0---------------------------------------VERIFICA TABLA DESTINO EXISTE -------------------------------------------
      if (self.oTables_Ctrl[I].Ignore_Table = False) then
      begin
        if (self.Dest_TableExists(self.cDatabaseD, self.oSL_Dest[I]) = False) then
        begin
          cMessage := 'ERR-> TABLE DESTINO [' + self.cSrv_Dest + '->`' + trim(self.cDatabaseD) + '`.`' + self.oSL_Dest[I] + '] NO EXISTE.';
          self.oLog.Lines.Insert(0, cMessage);
          self.oLog.Repaint;

          cSql_Ln := '';
          cSql_Ln := cSql_Ln + 'CREATE TABLE IF NOT EXISTS `' + trim(self.cDatabaseD) + '`.`' + trim(self.oSL_Dest[I]) + '` ';
          cSql_Ln := cSql_Ln + '( `autoin` BIGINT NOT NULL AUTO_INCREMENT, PRIMARY KEY (`autoin`) ) COLLATE="utf8_general_ci";';
          self.Dest_query_updateg(cSql_Ln);

          self.oLog.Lines.Insert(0, cSql_Ln);
          self.oLog.Repaint;

        end;
        self.oTables_Ctrl[I].Ignore_Table := True;
      end;

      //4.0-------------------------------VERIFICA SI LOS CAMPOS DE LA TABLA DESTINO EXISTEN-------------------------------
      if (self.oTables_Ctrl[I].Ignore_Field = False) then
      begin
        iField1 := self.Orig_Fields_Counts(self.oDbf_Orig);
        iField2 := self.Dest_Fields_Counts(self.oSL_Dest[I]);

        if (self.Dest_FieldExists('autoin', trim(self.cDatabaseD) + '.' + trim(self.oSL_Dest[I])) = False) then
        begin
          cSql_Ln := '';
          cSql_Ln := cSql_Ln + 'ALTER  TABLE `' + trim(self.cDatabaseD) + '`.`' + trim(self.oSL_Dest[I]) + '` ';
          cSql_Ln := cSql_Ln + 'ADD COLUMN `autoin` BIGINT(20) NOT NULL AUTO_INCREMENT FIRST,';
          cSql_Ln := cSql_Ln + 'ADD PRIMARY KEY (`autoin`);';
          self.Dest_query_updateg(cSql_Ln);

          self.oLog.Lines.Insert(0, cSql_Ln);
          self.oLog.Repaint;
        end;

        iField2 := iField2 + self.iif(self.Dest_FieldExists('autoin', trim(self.cDatabaseD) + '.' + trim(self.oSL_Dest[I])) = True, -1, 0);

        if (iField1 > iField2) then
        begin
          SELF.Dataset_To_Mysql_Create(self.iMasterIdx, trim(self.oSL_Dest[I]));
        end;

        self.oTables_Ctrl[I].Ignore_Field := True;
      end;

      if (self.Dest_FieldExists('flag_modif', trim(self.cDatabaseD) + '.' + trim(self.oSL_Dest[I])) = False) then
      begin
        cMessage := 'ERR-> TABLA DESTINO [' + self.cHOSTNAMED + '>' + trim(self.cDatabaseD) + '.' + trim(self.oSL_Dest[I]) +
          '] NO CONTIENE CAMPO DE CONTROL ("flag_modif")';
        self.oLog.Lines.Insert(0, cMessage);
        self.oLog.Repaint;

        self.Dest_Add_Ctrl_Field(trim(self.oSL_Dest[I]));
        cMessage := 'AÑADIENDO CAMPO DE CONTROL DE AUTOMATICAMENTE A  TABLA DESTINO [' + self.cHOSTNAMED + '>' +
          self.cDatabaseD + '.' + self.oSL_Dest[I] + '].';
        self.oLog.Lines.Insert(0, cMessage);
        self.oLog.Repaint;

        bSkip_Table := False;
      end;

      //5.0---------------------VERIFICA SI LA TABLA DE DESTINO TIENE MAS CAMPOS QUE EL ORIGEN-----------------------------
      iField1 := self.Orig_Fields_Counts(self.oDbf_Orig);
      iField2 := self.Dest_Fields_Counts(self.oSL_Dest[I]);
      iField2 := iField2 + self.iif(self.Dest_FieldExists('autoin', trim(self.cDatabaseD) + '.' + trim(self.oSL_Dest[I])) = True, -1, 0);
      if (iField1 < iField2) then
      begin
        cMessage := 'ERR-> TABLA [' + self.cDBF_PATHO + '\' + self.oSL_Orig[I] + '] TIENE MENOS CAMPOS (' +
          trim(IntToStr(iField1)) + ') QUE [' + self.cHOSTNAMED + '>' + self.cDatabaseD + '.' + self.oSL_Dest[I] +
          '] (' + trim(IntToStr(iField2)) + ')';
        self.oLog.Lines.Insert(0, cMessage);
        self.oLog.Repaint;
        bSkip_Table := True;
      end;
      //---------------------------------------------------------------//

      cSql_Ln := '';
      if (bSkip_Table = False) then
      begin
        self.oDbf_Orig.Filter := 'flag_modif=1';
        self.oDbf_Orig.Filtered := True;

        self.query_selectg(self.oConn_Dest, self.oQry_Dest, 'SELECT * FROM ' + self.cDBF_NAMED + ' WHERE flag_modif=1 LIMIT ' + self.cLIMITSELD);
        SELF.oDS_Orig.DataSet := self.oQry_Dest;

        self.Dataset_To_MySql_Header_Send(cSql_Ln, self.oSL_Dest[I]);
        self.Dataset_To_MySql_Values_Send(cSql_Ln, 20);
        self.oLog.Lines.Insert(0, cSql_Ln);
        self.oLog.Repaint;

        if (trim(cSql_Ln) <> '') then
        begin
          self.oCmd_Dest.Clear;
          self.oCmd_Dest.Script.Clear;
          self.oCmd_Dest.Script.Text := cSql_Ln;
          self.oCmd_Dest.Parse;
          try
            self.oCmd_Dest.Execute;
            self.oLog.Lines.Insert(0, 'Comando ejecutado correctamente.');
            self.oLog.Repaint;

          except
            self.oLog.Lines.Insert(0, 'ERROR al ejecutar el comando.');
            self.oLog.Repaint;
          end;
        end;
        //Sleep(3000);
        //--------------*ENVIO DE INFORMACION AL ORGEN*------------------//
        //---------------------------------------------------------------//
        SELF.Dataset_To_DBF_Values_Send(20);
        //SELF.do_process_to_dest;
      end
      else
        self.oDbf_Orig.Close;
    end;
  end;
  self.oTimer1.Enabled := True;
end;

procedure TfMain.Dataset_To_MySql_Header_Send(var pSqlInsert: WideString; cTblName: string);
var
  iIdx: integer;
  cStr_Fields: string;
  cSql_Insert_Cab: string;
  cColumnName: string;
  iFields_Cnt: integer;
begin
  iIdx := 0;
  cStr_Fields := '';
  cColumnName := '';
  iFields_Cnt := 0;
  cSql_Insert_Cab := '';

  self.oDbf_Orig.Filter := 'flag_modif=1';
  self.oDbf_Orig.Filtered := True;
  self.oDbf_Orig.First;

  iFields_Cnt := self.oDbf_Orig.FieldCount;

  while not (self.oDbf_Orig.EOF) do
  begin
    cSql_Insert_Cab := 'INSERT INTO ' + cTblName + ' ';
    for iIdx := 0 to (iFields_Cnt - 1) do
    begin
      cColumnName := self.oDbf_Orig.Fields[iIdx].FieldName;

      if (cColumnName <> '') then
      begin
        cStr_Fields := cStr_Fields + '`' + cColumnName + '`';
        if (iIdx <> iFields_Cnt) then
        begin
          cStr_Fields := cStr_Fields + ',';
        end;
      end;
    end;
    if (RightStr(trim(cStr_Fields), 1) = ',') then
    begin
      cStr_Fields := copy(trim(cStr_Fields), 1, length(cStr_Fields) - 1);
    end;

    cSql_Insert_Cab := cSql_Insert_Cab + '(' + cStr_Fields + ') VALUES ' + #13;
    self.oDbf_Orig.Last;
  end;
  pSqlInsert := pSqlInsert + cSql_Insert_Cab;

end;

procedure TfMain.Dataset_To_MySql_Values_Send(var pSqlInsert: WideString; iLimitInserts: integer);
var
  iIdx: integer;

  cField_Value: string;
  cField_Updat: string;
  cStr_Fields: string;
  cColumnName: string;
  cSql_Insert_Val: string;

  iRegs_Count: integer;
  iFields_Cnt: integer;
  iType: TFieldType;
begin
  iIdx := 0;
  iRegs_Count := 0;
  cField_Value := '';
  cStr_Fields := '';
  cField_Updat := '';
  cSql_Insert_Val := '';

  iFields_Cnt := 0;

  self.oDbf_Orig.Filter := 'flag_modif=1';
  self.oDbf_Orig.Filtered := True;
  self.oDbf_Orig.First;

  iFields_Cnt := self.oDbf_Orig.FieldCount;

  cField_Updat := '';
  iRegs_Count := 0;
  cField_Updat := '';
  while not (self.oDbf_Orig.EOF) and (iRegs_Count <= iLimitInserts) do
  begin

    for iIdx := 0 to (iFields_Cnt - 1) do
    begin
      iType := self.oDbf_Orig.Fields[iIdx].DataType;
      cColumnName := self.oDbf_Orig.Fields[iIdx].FieldName;

      if (iRegs_Count = 0) then
      begin

        if (iIdx < (iFields_Cnt - 1)) then
          cField_Updat := cField_Updat + ' ' + cColumnName + '=VALUES(' + cColumnName + '),' + #13
        else
          cField_Updat := cField_Updat + ' ' + cColumnName + '=VALUES(' + cColumnName + ');' + #13;
      end;

      if (self.oDbf_Orig.Fields[iIdx].IsNull = True) then
      begin
        cField_Value := 'NULL';
      end
      else
      begin
        if iType in [ftDate, ftDateTime, ftTimeStamp] then
        begin
          cField_Value := '"' + formatdatetime('yyyy-mm-dd', self.oDbf_Orig.Fields[iIdx].AsDateTime) + '"';
        end
        else if iType in [ftString, ftMemo, ftWideString] then
        begin
          cField_Value := '"' + self.oDbf_Orig.Fields[iIdx].AsString + '"';
        end
        else if iType in [ftFloat, ftCurrency] then
        begin
          cField_Value := FormatFloat('0.00', self.oDbf_Orig.Fields[iIdx].AsFloat);
        end
        else if iType in [ftUnknown] then
        begin
          cField_Value := 'NULL';
        end
        else if iType in [ftInteger, ftSmallint, ftWord, ftLargeint] then
        begin
          cField_Value := self.oDbf_Orig.Fields[iIdx].AsString;
        end
        else
        begin
          cField_Value := self.oDbf_Orig.Fields[iIdx].AsString;
        end;
      end;
      if (UPPERCASE(cColumnName) = 'FLAG_MODIF') then
      begin
        cField_Value := '0';
      end;

      cStr_Fields := cStr_Fields + cField_Value;
      if (iIdx < (iFields_Cnt - 1)) then
        cStr_Fields := cStr_Fields + ','
      else
        cStr_Fields := cStr_Fields;

    end;
    cSql_Insert_Val := cSql_Insert_Val + '(' + cStr_Fields + '),' + #13;
    iRegs_Count := iRegs_Count + 1;

    self.oDbf_Orig.Edit;
    self.oDbf_Orig.FieldByName('flag_modif').Value := 0;
    self.oDbf_Orig.Post;

    self.oDbf_Orig.Next;
    cStr_Fields := '';
  end;

  if (iRegs_Count > 0) then
  begin
    pSqlInsert := pSqlInsert + cSql_Insert_Val;
    if (RightStr(trim(pSqlInsert), 1) = ',') then
    begin
      pSqlInsert := copy(trim(pSqlInsert), 1, length(trim(pSqlInsert)) - 1);
    end;
    pSqlInsert := pSqlInsert + #13 + ' ON DUPLICATE KEY UPDATE ' + #13 + cField_Updat;
  end
  else
    pSqlInsert := '';
end;

procedure TfMain.LogFile(Info: string);
var
  slSave: TStringList;
  cPath, cFile: string;
begin
  cPath := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  cFile := cPath + 'debug.log';

  try
    slSave := TStringList.Create;
    try
      if FileExists(cFile) then
      begin
        try
          slSave.LoadFromFile(cFile);
        except
        end;
      end;
      slSave.Add(DateTimeToStr(Now) + #13#10 + Info + #13#10 + '' + #13#10);
      slSave.SaveToFile(cFile);
    finally
      slSave.Free;
    end;
  except
  end;
end;

function TfMain.IIF(Condition: boolean; TrueResult, FalseResult: variant): variant;
begin
  if Condition then
    Result := TrueResult
  else
    Result := FalseResult;
end;

function TfMain.Orig_TableExists(cTableName: string): boolean;
begin
  Result := FileExists(trim(self.cDBF_PATHO) + '\' + trim(cTableName));
end;

function TfMain.Orig_FieldExists(oTable: TDbf; cField: string): boolean;
var
  oFindField: TField;
begin
  oFindField := nil;
  //if (oTable.FieldDefs.IndexOf(cField) > -1) then

  //oFindField := oTable.Fields.FindField(cField);
  //if (Assigned(oFindField)=false) then

  if (oTable.Fields.FindField(cField) = nil) then
    Result := False
  else
    Result := True;
  FreeAndNil(oFindField);
end;

function TfMain.Orig_Fields_Counts(oTable: TDbf): integer;
begin
  Result := oTable.FieldCount;
end;

procedure TfMain.Dest_Add_Ctrl_Field(cTableName: string);
var
  cSql_Ln: string;
begin
  cSql_Ln := 'ALTER TABLE `' + trim(self.cDatabaseD) + '`.' + cTableName + ' ADD COLUMN `flag_modif` INT(1) NULL DEFAULT 0;';
  self.Dest_query_updateg(cSql_Ln);
  self.oLog.Lines.Insert(0, cSql_Ln);
  self.oLog.Repaint;

  cSql_Ln := 'ALTER TABLE `' + trim(self.cDatabaseD) + '`.' + cTableName + '` ADD INDEX `flag_modif` (`flag_modif`);';
  self.Dest_query_updateg(cSql_Ln);
  self.oLog.Lines.Insert(0, cSql_Ln);
  self.oLog.Repaint;
end;

procedure TfMain.Dataset_To_Mysql_Create(iIndexTable: integer; cTblName: string);
var
  iIdx, iFields_Cnt: integer;
  iType: TFieldType;
  iSize: integer;
  cColumnName, cSql_Ln: string;
  cType, cPres, cDefa: string;
  cField_Ant: string;
begin
  cField_Ant := '';
  iFields_Cnt := self.oDbf_Orig.FieldCount;
  for iIdx := 0 to (iFields_Cnt - 1) do
  begin
    iType := self.oDbf_Orig.Fields[iIdx].FieldDef.DataType;
    iSize := self.oDbf_Orig.Fields[iIdx].FieldDef.Size;
    cColumnName := TRIM(self.oDbf_Orig.Fields[iIdx].FieldName);

    if (self.Dest_FieldExists(cColumnName, trim(cTblName)) = False) then
    begin
      //ftUnknown,
      if (iType in [ftString, ftWideString]) then
      begin
        cType := ' CHAR';
        cPres := '(' + trim(IntToStr(iSize)) + ')';
        cDefa := '""';
      end;

      if (iType in [ftSmallint, ftInteger]) then
      begin
        cType := ' INT';
        cPres := '(' + trim(IntToStr(iSize)) + ')';
        cDefa := '0';
      end;

      if (iType in [ftFloat, ftCurrency]) then
      begin
        cType := ' DECIMAL';
        cPres := '(12,4)';
        cDefa := '0.00';
      end;

      if (iType in [ftDate]) then
      begin
        cType := ' DATE';
        cPres := '';
        cDefa := 'NULL';
      end;

      if (iType in [ftDateTime]) then
      begin
        cType := ' DATETIME';
        cPres := '';
        cDefa := 'NULL';
      end;

      if (iType in [ftTime]) then
      begin
        cType := ' TIME';
        cPres := '';
        cDefa := 'NULL';
      end;

      if (iType in [ftTimeStamp]) then
      begin
        cType := ' TIMESTAMP';
        cPres := '';
        cDefa := 'NULL';
      end;

      if (iType in [ftLargeint]) then
      begin
        cType := ' BIGINT';
        cPres := '(20)';
        cDefa := '0';
      end;

      if (iType in [ftBlob, ftDataSet]) then
      begin
        cType := ' BLOB';
        cPres := '';
        cDefa := 'NULL';
      end;

      if (iType in [ftWideString]) then
      begin
        cType := ' TEXT';
        cPres := '';
        cDefa := 'NULL';
      end;

      if (iType in [ftMemo]) then
      begin
        cType := ' MEDIUMTEXT';
        cPres := '';
        cDefa := 'NULL';
      end;

      if (iType in [ftWideMemo]) then
      begin
        cType := ' LONGTEXT';
        cPres := '';
        cDefa := 'NULL';
      end;

      cSql_Ln := 'ALTER TABLE `' + trim(self.cDatabaseD) + '`.`' + trim(cTblName) + '` ADD COLUMN `' + LOWERCASE(cColumnName) +
        '` ' + cType + ' ' + cPres + ' NULL DEFAULT ' + cDefa + ' ' + iif(cField_Ant <> '', 'AFTER ' + cField_Ant, '') + ';';
      self.Dest_query_updateg(cSql_Ln);

      if (Lowercase(oMa_Dest[iIndexTable]) = Lowercase(cColumnName)) then
      begin
        cSql_Ln := 'ALTER TABLE `' + trim(self.cDatabaseD) + '`.`' + trim(cTblName) + '` ADD INDEX `' + cColumnName + '` (`' + cColumnName + '`);';
        self.Dest_query_updateg(cSql_Ln);
      end;

      if (Lowercase(cColumnName) = 'flag_modif') then
      begin
        cSql_Ln := 'ALTER TABLE `' + trim(self.cDatabaseD) + '`.`' + trim(cTblName) + '` ADD INDEX `' + cColumnName + '` (`' + cColumnName + '`);';
        self.Dest_query_updateg(cSql_Ln);
      end;

      self.oLog.Lines.Insert(0, cSql_Ln);
      self.oLog.Repaint;

    end;
    cField_Ant := cColumnName;
  end;

end;

function TfMain.resourceVersionInfo: string;

  (* Unlike most of AboutText (below), this takes significant activity at run-    *)
  (* time to extract version/release/build numbers from resource information      *)
  (* appended to the binary.                                                      *)

var
  Stream: TResourceStream;
  vr: TVersionResource;
  fi: TVersionFixedInfo;

begin
  Result := '';
  try

    (* This raises an exception if version info has not been incorporated into the  *)
    (* binary (Lazarus Project -> Project Options -> Version Info -> Version        *)
    (* numbering).                                                                  *)

    Stream := TResourceStream.CreateFromID(HINSTANCE, 1, PChar(RT_VERSION));
    try
      vr := TVersionResource.Create;
      try
        vr.SetCustomRawDataStream(Stream);
        fi := vr.FixedInfo;
        Result := 'Versión: ' + IntToStr(fi.FileVersion[0]) + '.' + IntToStr(fi.FileVersion[1]) +' build ' + IntToStr(fi.FileVersion[3]);
        vr.SetCustomRawDataStream(nil)
      finally
        vr.Free
      end
    finally
      Stream.Free
    end
  except
  end;

end;

end.
