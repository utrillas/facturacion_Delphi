object DMDatos: TDMDatos
  Height = 600
  Width = 800
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=GRUPOCIE-2024;Persist Security Info' +
      '=True;User ID=sa;Initial Catalog=Pescaderia;Data Source=CARMEN-U' +
      'TRILLAS\SQLEXPRESS'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 237
    Top = 26
  end
  object DataSourceProducto: TDataSource
    DataSet = ADOQueryProducto
    Left = 58
    Top = 122
  end
  object DataSourceCliente: TDataSource
    DataSet = ADOQueryCliente
    Left = 166
    Top = 122
  end
  object DataSourceFactura: TDataSource
    DataSet = ADOQueryFactura
    Left = 275
    Top = 122
  end
  object DataSourceAlbaran: TDataSource
    DataSet = ADOQueryAlbaran
    Left = 384
    Top = 122
  end
  object DataSourceLineaAlbaran: TDataSource
    DataSet = ADOQueryLiAl
    Left = 512
    Top = 122
  end
  object DataSourceLineaFactura: TDataSource
    DataSet = ADOQueryLiFa
    Left = 653
    Top = 122
  end
  object ADOQueryProducto: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'Select * from Producto')
    Left = 51
    Top = 230
  end
  object ADOQueryCliente: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'Select * from Cliente')
    Left = 160
    Top = 230
  end
  object ADOQueryFactura: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'Select * from Factura')
    Left = 275
    Top = 230
  end
  object ADOQueryAlbaran: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'Select * from Albaran')
    Left = 384
    Top = 230
  end
  object ADOQueryLiAl: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'Select * from lineas_albaran')
    Left = 518
    Top = 230
  end
  object ADOQueryLiFa: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'Select * from linea_factura')
    Left = 614
    Top = 230
  end
  object ADOQCalculos: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 294
    Top = 365
  end
  object DataSourceContador: TDataSource
    DataSet = ADOQueryContador
    Left = 493
    Top = 352
  end
  object ADOQueryContador: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from Contador')
    Left = 627
    Top = 352
  end
  object ADOQHayLineas: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'Select * from lineas_albaran')
    Left = 717
    Top = 230
  end
end
