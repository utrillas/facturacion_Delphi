unit DatosDM;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TDMDatos = class(TDataModule)
    ADOConnection1: TADOConnection;
    DataSourceProducto: TDataSource;
    DataSourceCliente: TDataSource;
    DataSourceFactura: TDataSource;
    DataSourceAlbaran: TDataSource;
    DataSourceLineaAlbaran: TDataSource;
    DataSourceLineaFactura: TDataSource;
    ADOQueryProducto: TADOQuery;
    ADOQueryCliente: TADOQuery;
    ADOQueryFactura: TADOQuery;
    ADOQueryAlbaran: TADOQuery;
    ADOQueryLiAl: TADOQuery;
    ADOQueryLiFa: TADOQuery;
    ADOQCalculos: TADOQuery;
    DataSourceContador: TDataSource;
    ADOQueryContador: TADOQuery;
    ADOQHayLineas: TADOQuery;
    //procedure ADOQueryAlbaranNewRecord(DataSet: TDataSet);
    //procedure ADOQueryAlbaranBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMDatos: TDMDatos;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses facturacion, Albaran;

{$R *.dfm}
{
procedure TDMDatos.ADOQueryAlbaranNewRecord(DataSet: TDataSet);
var
  FieldValue: string;
begin
  FieldValue := ADOQueryAlbaran.FieldByName('numero_Al').AsString;
  // Verificar si el campo est� vac�o y asignar Null si es necesario
  if FieldValue = '' then
    ADOQueryAlbaran.FieldByName('numero_Al').Value := nil;
  else
  begin
    // Intentar convertir el valor a entero, asignar Null si falla
    try
      ADOQueryAlbaran.FieldByName('numero_Al').AsInteger := StrToInt(FieldValue);
    except
      on E: EConvertError do
      begin
        ADOQueryAlbaran.FieldByName('MiCampoEntero').Value := Null;
      end;
    end;
  end;
end;

procedure TDMDatos.ADOQueryAlbaranNewRecord(DataSet: TDataSet);
begin
  // DataSet.FieldByName('numero_Al').AsString :=
end;
     }
end.
