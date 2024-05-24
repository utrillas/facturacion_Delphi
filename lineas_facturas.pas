unit lineas_facturas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.WinXPickers, Vcl.Mask, Vcl.DBCtrls, Vcl.Buttons, Data.DB, Vcl.Grids,
  Data.Win.ADODB,
  Vcl.DBGrids;

type
  TFacturas = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Image1: TImage;
    Panel2: TPanel;
    Label2: TLabel;
    ENumFactura: TDBEdit;
    NowDateFac: TDatePicker;
    Label3: TLabel;
    Label4: TLabel;
    DBEdit3: TDBEdit;
    Label5: TLabel;
    DBEdit4: TDBEdit;
    Panel3: TPanel;
    btnAgregarFactura: TSpeedButton;
    BtnBorrarFac: TSpeedButton;
    btnSalirFac: TSpeedButton;
    ETotalFactura: TDBEdit;
    DBGridFacturas: TDBGrid;
    LDescuento: TLabel;
    CBPago: TComboBox;
    EDescuento: TEdit;
    CheckPagado: TDBCheckBox;
    Precio: TLabel;
    EdNumLineaFa: TDBEdit;
    EdNumero_Al: TDBEdit;
    EDTPrecio: TEdit;
    btnCalcularFac: TSpeedButton;
    CBMetodo: TCheckBox;
    Panel4: TPanel;
    Lmetodo: TLabel;
    Factura: TLabel;
    DBEjercicio: TDBEdit;
    Label6: TLabel;
    DBNombre: TDBEdit;
    Label7: TLabel;
    DBSerie: TDBEdit;
    btnRefrescarLFac: TSpeedButton;
    procedure BtnBorrarFacClick(Sender: TObject);
    procedure btnSalirFacClick(Sender: TObject);
    procedure btnAgregarFacturaClick(Sender: TObject);
    procedure ENumFacturaChange(Sender: TObject);
    procedure btnCalcularFacClick(Sender: TObject);
    procedure CBMetodoClick(Sender: TObject);
    procedure CheckPagadoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function RefrescarLineasFactura():String;
    procedure btnRefrescarLFacClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Facturas: TFacturas;
  precioTotal: Double;

implementation

{$R *.dfm}

uses Facturacion, DatosDM, Albaran;
 // refrescar lineas de las facturas
 function TFacturas.RefrescarLineasFactura: String;
var Ejercicio, Serie, numero_Fac:  String;

var conexion: TADOQuery;
begin
  Ejercicio := DBEjercicio.Text;
  Serie:= DBSerie.Text;
  numero_Fac:= ENumFactura.Text;
  conexion:= DMDatos.ADOQueryLiFa;

  if DBEjercicio.Text <> '' then
  begin
    conexion.SQL.Clear;
    conexion.SQL.Text:= 'SELECT * FROM linea_factura WHERE Ejercicio = ' + Ejercicio +
                              ' AND Serie = '+ Serie +
                              ' AND numero_factura= ' + numero_Fac;
    conexion.Open;
  end;
end;
// Cambio para mostrar el grid correcto
procedure TFacturas.ENumFacturaChange(Sender: TObject);
var numero_Al: String;

begin
  numero_Al:= EdNumero_Al.Text;

  if numero_Al <> '' then
  begin
    RefrescarLineasFactura();
  end
end;

procedure TFacturas.FormCreate(Sender: TObject);
begin
  NowDateFac.date:= now;
end;

// Agregamos datos a la factura y a la linea de factura
procedure TFacturas.btnAgregarFacturaClick(Sender: TObject);
var
  numero_Fa, iva, codigo_producto, num_linea: Integer;
var
  Precio, ETotalFactura, Descuento, PrecioT, cantidad, total_facturaQ: Double;
var
  Precio_Str, Descuento_str, PrecioT_str, total_factura_str, numero_Al,
    PrecioT_Sstr, cantidad_str, eleccion, total_factura: String;
var
  conexion, conexion2: TADOQuery;
var
  puntero: Tbookmark;
var
  fecha: TDate;
begin
  codigo_producto := StrToInt(LineaAlbaran.EdCodigo.Text);
  numero_Fa := StrToInt(ENumFactura.Text);
  Descuento := StrToFloat(EDescuento.Text);
  Precio := StrToFloat(EDTPrecio.Text);
  Precio_Str := StringReplace(EDTPrecio.Text, ',', '.', [rfReplaceAll]);
  conexion := DMDatos.ADOQueryLiFa;
  conexion2 := DMDatos.ADOQCalculos;
  num_linea := StrToInt(EdNumLineaFa.Text);
  numero_Al := EdNumero_Al.Text;
  puntero := conexion.GetBookmark;
  total_facturaQ := 0;

  // Insertar datos en la tabla linea_factura
  if DMDatos.ADOQueryProducto.Locate('codigo_producto', codigo_producto, [])
  then
  begin
    iva := DMDatos.ADOQueryProducto.FieldByName('iva').AsInteger;
  end;

  // buscar la cantidad de producto
  DMDatos.ADOQueryLiAl.SQL.Text :=
    'SELECT cantidad from linea_factura where codigo_producto = ' +
    IntToStr(codigo_producto);
  DMDatos.ADOQueryLiAl.Open;

  if not DMDatos.ADOQueryLiAl.IsEmpty then
  begin
    cantidad := DMDatos.ADOQueryLiAl.FieldByName('cantidad').AsFloat;
  end
  else
  begin
    ShowMessage('No se encontro la cantidad');
  end;

  // cambiar el formato del descueto
  if Descuento <> 0 then
  begin

    Descuento_str := StringReplace(EDescuento.Text, ',', '.', [rfReplaceAll]);
  end
  else
  begin
    ShowMessage('No se aplica ning�n descuento');
  end;

  // Hallar el precio de cada producto.
  PrecioT := (Precio * cantidad) * (1 - (Descuento / 100)) * (1 + (iva / 100));

  if PrecioT <> 0 then
  begin
    PrecioT_str := FloatToStr(PrecioT);
    PrecioT_Sstr := StringReplace(PrecioT_str, ',', '.', [rfReplaceAll]);
  end
  else
  begin
    ShowMessage('El total da 0');
  end;

  // introducir datos en linea_factura
  if numero_Fa <> 0 then
  begin
    conexion.SQL.Clear;
    conexion.SQL.Text := 'UPDATE linea_factura  ' +
                          'SET numero_factura = ' + ENumFactura.Text + ', ' +
                          ' precio_unidad = ' + Precio_Str + ' , ' +
                          ' precio_total = ' + PrecioT_Sstr + ', ' +
                          ' descuento = ' + Descuento_str   +
                          ' WHERE linea_factura = ' + IntToStr(num_linea);
    conexion.ExecSQL;

    // introducir metodo de pago
    if CBPago.ItemIndex = 1 then
    begin
      eleccion := 'Al contado';
    end
    else if CBPago.ItemIndex = 2 then
    begin
      eleccion := 'Tarjeta';
    end
    else if CBPago.ItemIndex = 3 then
    begin
      eleccion := 'Pagare 30';
    end
    else if CBPago.ItemIndex = 4 then
    begin
      eleccion := 'Pagare 60';
    end
    else if CBPago.ItemIndex = 5 then
    begin
      eleccion := 'Pagare 90';
    end;



    // introducir datos en factura

    conexion2.SQL.Clear;
    conexion2.SQL.Text := 'UPDATE factura ' + ' SET ' +
      ' fecha = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', NowDateFac.Date)) + ', ' +
      ' modo_de_pago = ' + QuotedStr(eleccion) +
      ' WHERE numero_factura = ' + numero_Fa.ToString;
    conexion2.ExecSQL;
    // sumar linea

    conexion2.SQL.Clear;
    conexion2.SQL.Text := 'UPDATE factura ' +
      'SET numero_lineas = (SELECT COUNT(*) FROM linea_factura WHERE numero_factura = '
      + numero_Fa.ToString + ' ) ' + 'WHERE numero_factura = ' +
      numero_Fa.ToString;

    conexion2.ExecSQL;
    conexion.SQL.Clear;
    conexion.SQL.Text := 'select * from linea_factura where numero_factura = ' +
      numero_Fa.ToString;
    conexion.Open;
  end;
end;

// Borramos y contamos el numero de lineas
procedure TFacturas.BtnBorrarFacClick(Sender: TObject);
begin
  var
    conexion: TADOQuery;
  var
    numero_Fa: Integer;
  begin
    conexion := DMDatos.ADOQueryLiFa;
    numero_Fa := StrToInt(ENumFactura.Text);
    if MessageDlg('�seguro que quiere borrar el registro?', mtConfirmation,
      [mbYes, mbNo], 0) = mrYes then
    begin
      DMDatos.ADOQueryLiFa.Delete;
      ShowMessage('Se ha borrado correctamente el/los registro/s');
    end;
    if numero_Fa <> 0 then
    begin
      conexion.SQL.Clear;
      conexion.SQL.Text := 'UPDATE factura ' +
        'SET numero_lineas = (SELECT COUNT(*) FROM linea_factura WHERE numero_factura = '
        + IntToStr(numero_Fa) + ' ) ' + 'WHERE numero_factura = ' +
        IntToStr(numero_Fa);
    end;
  end;
end;

//Calcular el total de la factura
procedure TFacturas.btnCalcularFacClick(Sender: TObject);
var
  numero_Fa: Integer;
var
  conexion2, conexion: TADOQuery;
var
  total_factura: Double;
var
  total_factura_str: String;

begin
    conexion2 := DMDatos.ADOQCalculos;
    conexion := DMDatos.ADOQueryFactura;
    numero_Fa := StrToInt(ENumFactura.Text);
    if numero_Fa <> 0 then
    begin
      conexion2.SQL.Clear;
      conexion2.SQL.Text :=
        'SELECT SUM(precio_total) AS total_factura FROM linea_factura where numero_factura= '
        + numero_Fa.ToString;
      conexion2.Open;

      total_factura := conexion2.FieldByName('total_factura').AsFloat;
      total_factura_str := FormatFloat('0.00', total_factura);
    end;
  if total_factura_str <> '' then
    begin
        total_factura_str := StringReplace(total_factura_str, ',', '.', [rfReplaceAll]);
       conexion2.SQL.Clear;
       conexion2.SQL.Text := 'UPDATE factura ' + ' SET total_factura = ' +
                              total_factura_str +
                              ' WHERE numero_factura = ' + numero_Fa.ToString;
        conexion2.ExecSQL;
    end;
  Form2.VisibilizarTabla();
end;
 procedure TFacturas.btnRefrescarLFacClick(Sender: TObject);
begin
  RefrescarLineasFactura();
end;

// cerrar la pesta�a
procedure TFacturas.btnSalirFacClick(Sender: TObject);
begin
  Form2.VisibilizarTabla();
  close;
end;
//para que el metodo de pago sea fijo
procedure TFacturas.CBMetodoClick(Sender: TObject);
begin
  if CBMetodo.Checked = true then
    begin
       CBPago.Enabled := False;
    end
  else
    begin
      CBPago.Enabled := True;
    end;
end;
// pone todos los edits cerrados
procedure TFacturas.CheckPagadoClick(Sender: TObject);
begin
  if CheckPagado.Checked = True then
    begin
      CBPago.Enabled := False;
      EDTPrecio.ReadOnly := True;
      EDescuento.ReadOnly := True;
    end;
end;

end.
