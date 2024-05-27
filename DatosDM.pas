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

end.
