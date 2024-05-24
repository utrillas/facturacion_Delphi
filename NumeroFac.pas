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
    CBNombreFac: TComboBox;
    LSerieFac: TLabel;
    CBSerieFac: TComboBox;
    Panel1: TPanel;
    Panel2: TPanel;
    ChechEjercicio: TPanel;
    btnAceptarNFac: TSpeedButton;
    CheckEjercicio: TCheckBox;
    Label1: TLabel;
    EdCodigoCliente: TEdit;
    procedure btnAceptarNFacClick(Sender: TObject);
    procedure CheckEjercicioClick(Sender: TObject);
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
  conexion: TADOQuery;
var
  numero_Fac: Integer;
var
  Ejercicio, NombreFac, Serie, Cliente, numero_FacStr, currentDate : String;
begin
  Ejercicio := EdEjercicio.Text;
  NombreFac := CBNombreFac.Text;
  Serie := CBSerieFac.Text;
  conexion := DMDatos.ADOQueryAlbaran;
  cliente:=  EdCodigoCliente.Text;
  currentDate := FormatDateTime ('yyyy-mm-dd', Now);
  numero_Fac:= NumeroContador(Ejercicio, NombreFac, Serie);
  numero_FacStr := IntToStr(numero_Fac);

  // insertar nuevo Albaran
  if CBNombreFac.ItemIndex = 0 then
  begin
    if numero_FacStr <> '' then
    begin
      ShowMessage(Ejercicio +'/' +NombreFac+'/'+ Serie+'/'+ numero_FacStr+'/'+ cliente);
      conexion.SQL.Clear;
      conexion.SQL.Text :=
        'INSERT INTO Albaran (Ejercicio, Nombre, Serie, numero_Al, fecha, numero_cliente)' + 'VALUES (' +
        QuotedStr(Ejercicio) + ', ' +
        QuotedStr(NombreFac) + ' , ' +
        QuotedStr(Serie) + ', ' +
        QuotedStr(numero_FacStr) + ',' +
        QuotedStr(currentDate) + ', ' +
        QuotedStr(cliente) + ' ) ';
      showmessage(conexion.SQL.Text);
      conexion.ExecSQL;
      form2.VisibilizarTabla();
    end
    else
    begin
      Showmessage('El n�mero de albar�n no es v�lido');
      close;
    end;
  end;

  CBSerieFac.Text := '';
  EdCodigoCliente.Text:= '';
end;

// para que solamente se quede la fecha permamente
procedure TFNumeroFac.CheckEjercicioClick(Sender: TObject);
begin
  if CheckEjercicio.Checked = True then
  begin
    EdEjercicio.ReadOnly := True;
  end;
end;

function TFNumeroFac.NumeroContador(Ejercicio, Nombre, Serie: String): Integer;
var
  numero_Fac, numero_Fac_New: Integer;
  conexion, conexion2: TADOQuery;
begin
conexion:= DMDatos.ADOQueryContador;
conexion2:= DMDatos.ADOQueryContador;
  if not conexion.Active then
    conexion.Open;

  if conexion2.Locate('Ejercicio; Nombre; Serie',
    VarArrayOf([Ejercicio, Nombre, Serie]), []) then
  begin
    numero_Fac := conexion2.FieldByName('numero').AsInteger;
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
begin
 Ejercicio := EdEjercicio.Text;
 NombreFac := CBNombreFac.Text;
 Serie := CBSerieFac.Text;
  if DMDatos.ADOQueryContador.Locate('Ejercicio; Nombre; serie',
    VarArrayOf([Ejercicio, NombreFac, Serie]), []) then
  begin
    DMDatos.ADOQueryContador.Last;
    numero_Fac := DMDatos.ADOQueryContador.FieldByName('numero').AsInteger;

    if MessageDlg('�Quiere borrar la factura n�mero ' + numero_Fac.ToString + '?',mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        Form2.DarConexion.Delete;
        ShowMessage('Se ha borrado la factura n�mero : '+ numero_Fac.ToString);
        numero_Fac := numero_Fac -1;
        DMDatos.ADOQueryContador.SQL.Clear;
        DMDatos.ADOQueryContador.SQL.Text := 'UPDATE contador ' + 'SET numero = ' + IntToStr(numero_Fac_New) +
                                             ' WHERE Ejercicio = '+ EdEjercicio.Text +
                                             ' AND Nombre = ' + QuotedStr(NombreFac) +
                                             ' AND Serie = ' + CBSerieFac.Text;
        DMDatos.ADOQueryContador.ExecSQL;
      end
      else
      begin
        close;
      end;

  end;


end;

end.
