// You may need to install the 32-bit AccessDatabaseEngine:
//  https://download.microsoft.com/download/2/4/3/24375141-E08D-4803-AB0E-10F2E3A07AAA/AccessDatabaseEngine.exe
unit MyTables_Decl;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

const
  c_CnStr2 = 'Provider=%s;Data Source=%s;Persist Security Info=False';


  MDB_EXT = 'mdb';
  ACCDB_EXT = 'accdb';

  ACCESS_2000_PROVIDER = 'Microsoft.Jet.OLEDB.4.0';
  ACCESS_2007_PROVIDER = 'Microsoft.ACE.OLEDB.12.0';
  ACCESS_2019_PROVIDER = 'Microsoft.ACE.OLEDB.16.0'; // not implemented

  ACCESS_2000_CONNECTION_STRING = 'Provider=%s;Data Source=%s;Jet OLEDB:Engine Type=5';
  ACCESS_2007_CONNECTION_STRING = 'Provider=%s;Data Source=%s';
  ACCESS_2019_CONNECTION_STRING = 'Provider=%s;Data Source=%s;Jet OLEDB:Database'; // not implemented

type
  TDBVersion = (dv_Unknown, dv_Access2000, dv_Access2007, dv_Access2019);

const
  DBVersion: TDBVersion = dv_Access2007;

type

  TPhotoTableOption = (optNoSyncFilePathTable,  // <== This is probably obsolete!
                       optReadOnly, optUseClient,
                       optSortByPathName,
                       optNoFilePathsTable, optNoCopyRightsTable,
                       optLevel12, optNoUpdateDate, optNoConfirmDelete,
                       optNoSyncFilePaths, optNoSyncCopyrights);
  TPhotoTableOptions = set of TPhotoTableOption;


implementation

end.



