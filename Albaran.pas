unit Albaran;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  Vcl.WinXPickers, Vcl.Mask, Vcl.DBCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, Data.Win.ADODB;

type
  TLineaAlbaran = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Panel2: TPanel;
    btnSalir: TSpeedButton;
    Image1: TImage;
    Panel4: TPanel;
    Label7: TLabel;
    EdCantidad: TDBEdit;
    GridLAL: TDBGrid;
    btnDeleteLineaAl: TSpeedButton;
    Label3: TLabel;
    CBProducto: TDBLookupComboBox;
    Label5: TLabel;
    btnAgregar: TSpeedButton;
    LbnLineas: TLabel;
    DBEdit1: TDBEdit;
    CheckFacturar: TCheckBox;
    btnReAl: TSpeedButton;
    Panel3: TPanel;
    Label2: TLabel;
    Label4: TLabel;
    nAlbaran: TLabel;
    Albaran: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    DPAlbaran: TDatePicker;
    DBEdit2: TDBEdit;
    EDnAlbaran: TDBEdit;
    EdCodigo: TDBEdit;
    EdNombreCliente: TDBEdit;
    DBCheckBox1: TDBCheckBox;
    DBEjercicioAl: TDBEdit;
    DBNombreAl: TDBEdit;
    DBSerieAl: TDBEdit;
    procedure btnSalirClick(Sender: TObject);
    procedure EdNombreClienteChange(Sender: TObject);
    procedure btnDeleteLineaAlClick(Sender: TObject);
    procedure btnAgregarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EDnAlbaranChange(Sender: TObject);
    function HayRegistros(numeroAl : Integer) : Boolean;
    function UltimoRegistro(numeroAl : Integer) : Integer;
    procedure btnReAlClick(Sender: TObject);
    procedure CheckFacturarClick(Sender: TObject);
    function CodigoProducto(descripcion_pro : String) : Integer;
    function RefrescarLineas(): String;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LineaAlbaran: TLineaAlbaran;
  num: Integer;
  cantidad: Double;

implementation

{$R *.dfm}

uses DatosDM, Facturacion, NumeroFac, lineas_facturas;

//Bot�n para salir de la pantalla
procedure TLineaAlbaran.btnSalirClick(Sender: TObject);
begin
  Close;
end;



//Cambiamos el Grid segun el numero de albaran
procedure TLineaAlbaran.EDnAlbaranChange(Sender: TObject);
var numero_Al: Integer;
begin
  if TryStrToInt(EDnAlbaran.Text,numero_Al) then
  begin
    RefrescarLineas();
  end
  else
  begin
    RefrescarLineas();
  end;
end;

//Cambia el nombre del cliente segun el c�digo
procedure TLineaAlbaran.EdNombreClienteChange(Sender: TObject);
var CodigoCliente: string;
begin
  CodigoCliente := EdCodigo.Text;
  if CodigoCliente <> '' then
  begin
    if DMDatos.ADOQueryCliente.Locate('numero_cliente', CodigoCliente,[]) then
    begin
      EdNombreCliente.Text := DMDatos.ADOQueryCliente.FieldByName('nombre_cliente').AsString;
    end
    else
    begin
       EdNombreCliente.Text:= '';
    end;
  end;
end;

//OnCreate
procedure TLineaAlbaran.FormCreate(Sender: TObject);
begin
  DPAlbaran.Date:= now;
end;

//Funci�n que nos dice si hay lineas
function TLineaAlbaran.HayRegistros(numeroAl: Integer): Boolean;
var texto: string;
begin
  if Screen.ActiveForm = LineaAlbaran then
  begin
    texto :=  'SELECT COUNT(*) as Lineas FROM lineas_albaran WHERE numero_Al = ' + IntToStr(numeroAl) + ' AND ' +
              'Ejercicio = ' + DBEjercicioAl.Text;
  end
  else
  begin
    texto :=  'SELECT COUNT(*) as Lineas FROM linea_factura WHERE numero_Al = ' + IntToStr(numeroAl) + ' AND ' +
              'Ejercicio = ' + DBEjercicioAl.Text;
  end;

  DMDatos.ADOQHayLineas.Close;
  DMDatos.ADOQHayLineas.SQL.Clear;
  DMDatos.ADOQHayLineas.SQL.Text := texto;
  DMDatos.ADOQHayLineas.Open;

  if DMDatos.ADOQHayLineas.FieldByName('Lineas').AsInteger <= 0 then
    Result := True
  else
    Result := False;
end;

function TLineaAlbaran.RefrescarLineas: String;
var Ejercicio, Serie:  String;
var numero_Al: Integer;
var conexion: TADOQuery;
begin
  Ejercicio := DBEjercicioAl.Text;
  Serie := DBSerieAl.Text;
  numero_Al:= StrToInt(EDnAlbaran.text);
  conexion:= DMDatos.ADOQueryLiAl;

  if DBEjercicioAl.Text <> '' then
  begin
    conexion.SQL.Clear;
    conexion.SQL.Text:= 'SELECT * FROM lineas_albaran WHERE Ejercicio = ' + Ejercicio +
                              ' AND Serie = '+ Serie +
                              ' AND numero_Al = ' + numero_Al.ToString  ;
    conexion.Open;
  end;
end;

//funci�n que nos dice el numero total de lineas
function TLineaAlbaran.UltimoRegistro(numeroAl: Integer): Integer;
begin

  DMDatos.ADOQHayLineas.Close;
  DMDatos.ADOQHayLineas.SQL.Clear;
  DMDatos.ADOQHayLineas.SQL.Text := 'SELECT COUNT(*) as Lineas FROM lineas_albaran WHERE numero_Al = ' + IntToStr(numeroAl) + 'AND ' +
  'Ejercicio = ' + DBEjercicioAl.Text;
  DMDatos.ADOQHayLineas.Open;

  Result := DMDatos.ADOQHayLineas.FieldByName('Lineas').AsInteger;
end;

//funcion para conseguir el codigo de una descripcion de un producto
function TLineaAlbaran.CodigoProducto(descripcion_pro : String): Integer;
var conexion: TADOQuery;
var codigo_producto: Integer;
begin
   conexion:=  DMDatos.ADOQueryProducto;
    if DMDatos.ADOQueryProducto.Locate('descripcion', descripcion_pro, []) then
       begin
         codigo_producto := DMDatos.ADOQueryProducto.FieldByName('codigo_producto').AsInteger;
       end;
    Result:= codigo_producto;
end;


//A�adir linea
procedure TLineaAlbaran.btnAgregarClick(Sender: TObject);
var conexion: TADOQuery;
var codigo_producto, numero_Al, contador, numero_lineas: Integer;
var descripcion_pro, cantidad_str, Ejercicio, Nombre, Serie: string;
var cantidad: Double;
var HayLineas : Boolean;
begin

  conexion:= DMDatos.ADOQueryLiAl;
  descripcion_pro :=CBProducto.Text;
  cantidad:= StrToFloat(EdCantidad.Text);
  cantidad_str:= StringReplace(EdCantidad.Text,',','.',[rfReplaceAll]);
  numero_Al:= StrToInt(EDnAlbaran.Text);
  Nombre := DBNombreAl.Text;
  Ejercicio := DBEjercicioAl.Text;
  Serie := DBSerieAl.Text;
  EdCantidad.Text:= '';
  begin
    //conseguir codigo producto
    codigo_producto:= CodigoProducto(descripcion_pro);
    //determinar las lineas que hay en el pedido
    HayLineas := HayRegistros(numero_Al);
    if HayLineas then
      numero_lineas := 1
    else
    begin
        numero_lineas := UltimoRegistro(numero_Al) + 1;
    end;
    //insertar linea en el albaran
    if ejercicio <> null then
      begin
        conexion.SQL.Clear;
        conexion.SQL.Text := 'INSERT INTO lineas_albaran (Ejercicio, Serie, numero_Al, numero_linea, codigo_producto, descripcion, cantidad)' +
                              'VALUES ( ' +
                              QuotedStr(Ejercicio) + ', '+
                              Serie + ' , ' +
                              numero_Al.ToString + ' , ' +
                              numero_lineas.ToString + ' , ' +
                              codigo_producto.ToString + ' , ' +
                              QuotedStr(descripcion_pro) + ' , ' +
                              QuotedStr(cantidad_str) + ') ';
          conexion.ExecSQL;
      end
    else
      begin
        showMessage('Numero de ejercicio no encontrado');
      end;

   //contar el n�mero de lineas que hay
   if numero_Al <> 0 then
      begin
         conexion.SQL.Clear;
         conexion.SQL.Text:= 'UPDATE Albaran ' +
                              'SET numero_lineas = (SELECT COUNT(*) FROM lineas_albaran WHERE Ejercicio = ' + Ejercicio +
                              ' AND Serie = '+ Serie +
                              ' and numero_Al = ' + numero_Al.ToString   + ' ) ' +
                              'WHERE Ejercicio = ' + Ejercicio +
                              ' AND Serie = '+ Serie +
                              ' and numero_Al = ' + numero_Al.ToString ;
         conexion.ExecSQL;
      end;
    //volver a ense�ar el listado completo del albaran
   RefrescarLineas();
  end;
  //limpiar los edits
  EdNombreCliente.Text:= '';
  EdCantidad.Text:= '';
end;


 //procedimiento para eliminar las lineas.
procedure TLineaAlbaran.btnDeleteLineaAlClick(Sender: TObject);
var conexion: TADOQuery;
var numero_Al: Integer;
begin
conexion:= DMDatos.ADOQueryLiAl;
numero_Al:= StrToInt(EDnAlbaran.Text);

   if MessageDlg('�seguro que quiere borrar el registro?',mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        DMDatos.ADOQueryLiAl.Delete;
        ShowMessage('Se ha borrado correctamente el/los registro/s');
      end;
    //volver a contar las lineas para ajustarlas despues de borrarlas
   if numero_Al <> 0 then
    begin
      conexion.SQL.Clear;
      conexion.SQL.Text:= 'UPDATE Albaran ' +
                          'SET numero_lineas = (SELECT COUNT(*) FROM lineas_albaran WHERE numero_Al = '+
                          IntToStr(numero_Al) + ' ) ' +
                          'WHERE numero_Al = ' +
                          IntToStr(numero_Al);
      conexion.ExecSQL;
    end;
    //refrescar la tabla

end;

//refrescar tablas
procedure TLineaAlbaran.btnReAlClick(Sender: TObject);
begin
  RefrescarLineas();
end;

//crear nueva factura
procedure TLineaAlbaran.CheckFacturarClick(Sender: TObject);
var codigo_producto, numero_Al, numero_Fac : Integer;
var conexionF, conexionLAl: TADOQuery;
var descripcion_pro, Ejercicio, Serie, NombreFac: String;
begin
   conexionF:= DMDatos.ADOQueryFactura;
   conexionLAl:= DMDatos.ADOQueryLiAl;
   Ejercicio:= DBEjercicioAl.Text;
   Serie:=  DBSerieAl.Text;
   NombreFac := 'Factura';
   numero_Al:= StrToInt(EDnAlbaran.text);
   numero_Fac := FNumeroFac.NumeroContador(Ejercicio, NombreFac, Serie);
  //conseguir la descripcion por el codigo del producto
  codigo_producto:= CodigoProducto(descripcion_pro);

  //insertar nueva factura
  conexionF.SQL.Clear;
  conexionF.SQL.Text :='INSERT INTO  factura (Ejercicio, Nombre, Serie, numero_factura, numero_cliente, numero_Al) VALUES ('
                    + QuotedStr(Ejercicio) +
                    ', ' + QuotedStr(NombreFac)  +
                    ', ' +  QuotedStr(Serie) +
                    ' , ' + IntToStr(numero_Fac) +
                    ', ' +EdCodigo.Text +
                    ', ' + IntToStr(numero_Al) + ' )';
  conexionF.ExecSQL;

   //Crear las lineas de factura
   conexionLAl.SQL.Clear;
  conexionLAl.SQL.Text := 'INSERT INTO linea_factura (Ejercicio, Serie, numero_factura, codigo_producto, descripcion, cantidad, iva) ' +
                          'SELECT ' + QuotedStr(Ejercicio) + ', '
                                  + QuotedStr(Serie) + ', '
                                  + IntToStr(numero_Fac) + ', '
                                  + 'codigo_producto, descripcion, cantidad, 0 ' +  // Insertar con iva como 0 inicialmente
                          'FROM lineas_albaran ' +
                          'WHERE Ejercicio = ' + QuotedStr(Ejercicio) + ' AND ' +
                          'Serie = ' + QuotedStr(Serie) + ' AND ' +
                          'numero_Al = ' + IntToStr(numero_Al);

   conexionLAl.ExecSQL;
   //updatear desde la tabla producto el iva del producto
   conexionLAl.SQL.Clear;
   conexionLAl.SQL.Text := 'UPDATE linea_factura ' +
                            ' SET iva = p.iva ' +
                            ' FROM linea_factura ' +
                            ' INNER JOIN Producto p ' +
                            ' ON p.codigo_producto = linea_factura.codigo_producto ' +
                            ' WHERE linea_factura.numero_factura = ' + IntToStr(numero_Fac);

   conexionLAl.ExecSQL;

   if numero_Fac <> 0 then
    begin
      conexionLAl.SQL.Clear;
      conexionLAl.SQL.Text := 'SELECT * FROM factura';
      conexionLAl.Open;
    end;

end;
end.