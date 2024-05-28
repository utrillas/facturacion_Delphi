unit NumeroFac;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  Data.Win.ADODB;

type
  TFNumeroFac = class(TForm)
    LEjercicioFac: TLabel;
    EdEjercicio: TEdit;
    LNombreFac: TLabel;
    LSerieFac: TLabel;
    CBSerieFac: TComboBox;
    Panel1: TPanel;
    Panel2: TPanel;
    ChechEjercicio: TPanel;
    btnAceptarNFac: TSpeedButton;
    Label1: TLabel;
    EdCodigoCliente: TEdit;
    AlbaranTexto: TLabel;
    procedure btnAceptarNFacClick(Sender: TObject);
    function NumeroContador(Ejercicio, Nombre, Serie: String): Integer;
    function BorrarUnContador():Integer;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FNumeroFac: TFNumeroFac;

implementation

{$R *.dfm}

uses Albaran, DatosDM, Facturacion, lineas_facturas;

procedure TFNumeroFac.btnAceptarNFacClick(Sender: TObject);
var
  conexion, conexion2: TADOQuery;
var
  numero_Fac, Cliente: Integer;
var
  Ejercicio, NombreFac, Serie, numero_FacStr, currentDate, cliente_Str: String;
begin
  Ejercicio := EdEjercicio.Text;
  NombreFac := AlbaranTexto.Caption;
  Serie := CBSerieFac.Text;
  conexion := DMDatos.ADOQueryAlbaran;
  cliente:=  StrToInt(EdCodigoCliente.Text);
  conexion2:= DMDatos.ADOQCalculos;


  // insertar nuevo Albaran

    numero_Fac:= NumeroContador(Ejercicio, NombreFac, Serie);
    if IntToStr(numero_Fac) <> '' then
    begin
      if TryStrToInt(EdCodigoCliente.Text, cliente) then
      begin
          currentDate := FormatDateTime ('yyyy-mm-dd', Now);
          numero_FacStr := IntToStr(numero_Fac);
          cliente_Str:= IntToStr(cliente);
          conexion2.SQL.Clear;
          conexion2.SQL.Text :=
                'INSERT INTO Albaran (Ejercicio, Nombre, Serie, numero_Al, fecha, numero_cliente) ' +
                'VALUES (' +
                QuotedStr(Ejercicio) + ', ' +
                QuotedStr(NombreFac) + ', ' +
                QuotedStr(Serie) + ', ' +
                numero_FacStr + ', ' +
                QuotedStr(currentDate) + ', ' +
                cliente_Str + ')';
                showmessage(conexion2.SQL.Text);
          conexion2.ExecSQL;
          showmessage('Se ha introducido correctamente el albarán');
          form2.VisibilizarTabla();
      end
      else
      begin
        showmessage('El numero de cliente no existe');
      end;

    end
    else
    begin
      Showmessage('El número de albarán no es válido');
      close;
    end;


  CBSerieFac.Text := '';
  EdCodigoCliente.Text:= '';
  exit;
end;


function TFNumeroFac.NumeroContador(Ejercicio, Nombre, Serie: String): Integer;
var
  numero_Fac, numero_Fac_New: Integer;
  conexion: TADOQuery;
begin
conexion:= DMDatos.ADOQueryContador;
  if not conexion.Active then
    conexion.Open;

  if conexion.Locate('Ejercicio; Nombre; Serie',
    VarArrayOf([Ejercicio, Nombre, Serie]), []) then
  begin
    numero_Fac := conexion.FieldByName('numero').AsInteger;
  end
  else
  begin
    numero_Fac := 1;
    conexion.SQL.Clear;
    conexion.SQL.Text :=
      'INSERT INTO Contador (Ejercicio, Nombre, Serie, numero) VALUES (' +
      QuotedStr(Ejercicio) + ' , ' + QuotedStr(Nombre) + ' , ' + QuotedStr(Serie) + ' , ' +
      IntToStr(numero_Fac) + ')';
    conexion.ExecSQL;
  end;

  Result := numero_Fac;

  // Sumar un 1 al contador
  numero_Fac_New := numero_Fac + 1;

 conexion.SQL.Clear;
 conexion.SQL.Text := 'UPDATE Contador SET numero = ' + IntToStr(numero_Fac_New) +
                                       ' WHERE Ejercicio = ' + QuotedStr(Ejercicio) +
                                       ' AND Nombre = ' + QuotedStr(Nombre) +
                                       ' AND Serie = ' + QuotedStr(Serie);
  conexion.ExecSQL;
end;


function TFNumeroFac.BorrarUnContador: Integer;
var Ejercicio, NombreFac, Serie : String;
var numero_Fac, numero_Fac_New: Integer;
    conexion, conexion2: TADOQuery;
begin
 Ejercicio := EdEjercicio.Text;
 NombreFac := AlbaranTexto.Caption;
 Serie := CBSerieFac.Text;
 conexion:= DMDatos.ADOQueryContador;
 conexion2:= DMDatos.ADOQCalculos;
  if DMDatos.ADOQueryContador.Locate('Ejercicio; Nombre; serie',
    VarArrayOf([Ejercicio, NombreFac, Serie]), []) then
  begin
    conexion.Last;
    numero_Fac := conexion.FieldByName('numero').AsInteger;

    if MessageDlg('¿Quiere borrar la factura número ' + numero_Fac.ToString + '?',mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        Form2.DarConexion.Delete;
        ShowMessage('Se ha borrado la factura número : '+ numero_Fac.ToString);
        numero_Fac_new := numero_Fac -1;
        conexion2.SQL.Clear;
        conexion2.SQL.Text := 'UPDATE contador ' + 'SET numero = ' + IntToStr(numero_Fac_New) +
                                             ' WHERE Ejercicio = '+ EdEjercicio.Text +
                                             ' AND Nombre = ' + QuotedStr(NombreFac) +
                                             ' AND Serie = ' + CBSerieFac.Text;
        conexion2.ExecSQL;
      end
      else
      begin
        close;
      end;
  end;
end;
end.
