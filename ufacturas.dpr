program ufacturas;

uses
  Vcl.Forms,
  Facturacion in 'Facturacion.pas' {Form2},
  DatosDM in 'DatosDM.pas' {DMDatos: TDataModule},
  Albaran in 'Albaran.pas' {LineaAlbaran},
  lineas_facturas in 'lineas_facturas.pas' {Facturas},
  NumeroFac in 'NumeroFac.pas' {FNumeroFac};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TDMDatos, DMDatos);
  Application.CreateForm(TLineaAlbaran, LineaAlbaran);
  Application.CreateForm(TFacturas, Facturas);
  Application.CreateForm(TFNumeroFac, FNumeroFac);
  Application.Run;
end.
