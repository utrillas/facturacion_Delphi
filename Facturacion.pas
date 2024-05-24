unit Facturacion;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, Vcl.StdCtrls,
  Data.DB, Vcl.Mask, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, System.UITypes, Data.Win.ADODB;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    ImageLogo: TImage;
    btnSiguiente: TSpeedButton;
    btnUltimo: TSpeedButton;
    btnRetroceder: TSpeedButton;
    btnPrimero: TSpeedButton;
    Panel2: TPanel;
    Panel3: TPanel;
    btnAgregarLinea: TSpeedButton;
    btnDelete: TSpeedButton;
    btnRefrescar: TSpeedButton;
    RBBusqueda: TRadioGroup;
    EdBusqueda: TEdit;
    btnBuscar: TSpeedButton;
    Panel4: TPanel;
    DBEdit2: TDBEdit;
    Label2: TLabel;
    Panel5: TPanel;
    GridPage: TPageControl;
    PAlbaranes: TTabSheet;
    PFacturas: TTabSheet;
    DBGridFacturas: TDBGrid;
    DBGridAlbaranes: TDBGrid;
    btnSalir: TSpeedButton;
    Label4: TLabel;
    btnMasAlb: TSpeedButton;
    btnCheck: TSpeedButton;
    btnAgregar: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    function IniciarConexion():String;
    procedure btnPrimeroClick(Sender: TObject);
    procedure btnRetrocederClick(Sender: TObject);
    procedure btnSiguienteClick(Sender: TObject);
    procedure btnUltimoClick(Sender: TObject);
    function DarConexion(): TADOQuery;
    procedure btnDeleteClick(Sender: TObject);
    procedure btnRefrescarClick(Sender: TObject);
    function VisibilizarTabla(): String;
    function DarTabla(): String;
    procedure btnSalirClick(Sender: TObject);
    procedure btnAgregarLineaClick(Sender: TObject);
    procedure btnMasAlbClick(Sender: TObject);
    procedure btnCheckClick(Sender: TObject);
    procedure RBBusquedaClick(Sender: TObject);
    function DarBusqueda(): String;
    function DatoBusqueda(): String;
    procedure btnBuscarClick(Sender: TObject);
    procedure btnAgregarClick(Sender: TObject);
    //function BorrarUltimo():Boolean;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses DatosDM, Albaran, lineas_facturas, NumeroFac;

//A la creación del programa
procedure TForm2.FormCreate(Sender: TObject);
begin
  IniciarConexion();
  DarConexion();
  VisibilizarTabla();
end;
//Busqueda de parámetros
function TForm2.DarBusqueda: String;
var busqueda : String;
var tabla: string;
begin
  busqueda := '-1';
  tabla :=  DarTabla();
  if RbBusqueda.ItemIndex = 0 then
    begin
      if tabla = 'Albaran' then
        begin
          busqueda := 'numero_Al';
        end
      else if tabla = 'Factura' then
        begin
          busqueda :=  'numero_factura';
        end;
    end
  else if RbBusqueda.ItemIndex = 1 then
    begin
      busqueda := 'fecha';
    end
  else if RbBusqueda.ItemIndex = 2 then
    begin
      busqueda := 'numero_cliente';
    end;
  Result := busqueda;
end;
//Dar dato para la busqueda
function TForm2.DatoBusqueda: String;
var dato : String;
begin
  dato := '';
  if EdBusqueda.Text <> '' then
    begin
      dato := QuotedSTR(EdBusqueda.Text);
    end;
    Result := dato;
end;

//Dar conexion a cada pestaña
function TForm2.DarConexion: TADOQuery;
begin
  Result := nil;
  if GridPage.ActivePage = PAlbaranes then
    begin
      Result :=  DMDatos.ADOQueryAlbaran;
    end
  else if GridPage.ActivePage = PFacturas then
    begin
      Result :=  DMDatos.ADOQueryFactura;
    end;
end;
//Función para saber en que tabla estamos
function TForm2.DarTabla: String;
begin
if GridPage.ActivePage = PAlbaranes then
    begin
      Result := 'Albaran';
    end
    else if GridPage.ActivePage  = PFacturas then
    begin
      Result := 'Factura';
    end;
end;
//Iniciar la conexion con la BBDD
function TForm2.IniciarConexion: String;
begin
  DMDatos.ADOConnection1.Open;
  DMDatos.ADOQueryAlbaran.Open;
  DMDatos.ADOQueryFactura.Open;
  DMDatos.ADOQueryProducto.Open;
  DMDatos.ADOQueryCliente.Open;
  DMDatos.ADOQueryLiAl.Open;
  DMDatos.ADOQueryLiFa.Open;
end;
procedure TForm2.RBBusquedaClick(Sender: TObject);
begin
  DarBusqueda();
end;
procedure TForm2.btnAgregarClick(Sender: TObject);
begin
  if GridPage.ActivePage = PAlbaranes then
    begin
      DMDatos.ADOQueryAlbaran.Append;
    end
  else if GridPage.ActivePage = PFacturas then
    begin
      DMDatos.ADOQueryFactura.Append;
    end;
end;

//Buscar un dato
procedure TForm2.btnBuscarClick(Sender: TObject);
var tabla, busqueda, dato: String;
var conexion: TADOQuery;
begin
    conexion := DarConexion();
    tabla := DarTabla();
    busqueda := DarBusqueda();
    dato := DatoBusqueda();
    if (busqueda <> '') AND (dato <> '') then
      begin
        conexion.SQL.Clear;
        conexion.SQL.Text := 'SELECT * FROM ' + tabla + ' WHERE '
        +  busqueda + ' = ' + dato;
        conexion.Open;
      end
    else
       showmessage('Por favor, introduzca datos válidos para la búsqueda.');
    EdBusqueda.Clear;
end;

//Función para que nos muestre las tablas
function TForm2.VisibilizarTabla: String;
var conexion: TADOQuery;
var tabla : String;
    puntero:Tbookmark;
begin
    conexion := DarConexion();
    tabla := DarTabla();

    puntero:=conexion.GetBookmark;

     begin
      conexion.SQL.Clear;
      conexion.SQL.Text:='SELECT * FROM ' + tabla;
      conexion.Open;
      conexion.GotoBookmark(Puntero);
     end;
end;
//Abre el Form de las lineas
procedure TForm2.btnAgregarLineaClick(Sender: TObject);
begin
  if GridPage.ActivePage = PAlbaranes then
    begin
      lineaAlbaran.RefrescarLineas();
      LineaAlbaran.Show;
    end
  else if GridPage.ActivePage = PFacturas then
    begin
      Facturas.RefrescarLineasFactura();
      Facturas.Show;
    end;
end;

procedure TForm2.btnCheckClick(Sender: TObject);
begin
  if GridPage.ActivePage = PAlbaranes then
    begin
       DMDatos.ADOQueryAlbaran.Post;
    end
  else if GridPage.ActivePage = PFacturas then
    begin
       DMDatos.ADOQueryFactura.Post;
    end;
end;
//Borra un registro
procedure TForm2.btnDeleteClick(Sender: TObject);
var conexion: TADOQuery;
begin
   conexion := DarConexion();
   if MessageDlg('¿seguro que quiere borrar el registro?',mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        conexion.Delete;
        ShowMessage('Se ha borrado correctamente el/los registro/s');
      end;

end;

//Función para agregar una linea nueva
procedure TForm2.btnMasAlbClick(Sender: TObject);
begin
  if GridPage.ActivePage = PAlbaranes then
    begin
      FNumeroFac.Show;
    end
end;

//va al primer dato
procedure TForm2.btnPrimeroClick(Sender: TObject);
begin
  if GridPage.ActivePage = PAlbaranes then
    begin
       DMDatos.ADOQueryAlbaran.First;
    end
  else if GridPage.ActivePage = PFacturas then
    begin
       DMDatos.ADOQueryFactura.First;
    end;
end;
//Botón para refrescar la tabla
procedure TForm2.btnRefrescarClick(Sender: TObject);
begin
    VisibilizarTabla();
end;
//va a un dato anterior
procedure TForm2.btnRetrocederClick(Sender: TObject);
begin
  if GridPage.ActivePage = PAlbaranes then
    begin
       DMDatos.ADOQueryAlbaran.Prior;
    end
  else if GridPage.ActivePage = PFacturas then
    begin
       DMDatos.ADOQueryFactura.Prior;
    end;
end;
//Salir del programa.
procedure TForm2.btnSalirClick(Sender: TObject);
begin
  Close;
end;
//va al dato siguiente
procedure TForm2.btnSiguienteClick(Sender: TObject);
begin
  if GridPage.ActivePage = PAlbaranes then
    begin
       DMDatos.ADOQueryAlbaran.Next;
    end
  else if GridPage.ActivePage = PFacturas then
    begin
       DMDatos.ADOQueryFactura.Next;
    end;
end;
//va al ultimo dato
procedure TForm2.btnUltimoClick(Sender: TObject);
begin
  if GridPage.ActivePage = PAlbaranes then
    begin
       DMDatos.ADOQueryAlbaran.Last;
    end
  else if GridPage.ActivePage = PFacturas then
    begin
       DMDatos.ADOQueryFactura.Last;
    end;
end;

end.
