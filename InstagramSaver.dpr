program InstagramSaver;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Vcl.Forms,
  UnitMain in 'Forms\UnitMain.pas' {MainForm},
  UnitSettings in 'Forms\UnitSettings.pas' {SettingsForm},
  UnitAbout in 'Forms\UnitAbout.pas' {AboutForm},
  windows7taskbar in 'Units\windows7taskbar.pas',
  UnitLog in 'Forms\UnitLog.pas' {LogForm},
  UnitImageTypeExtractor in 'Units\UnitImageTypeExtractor.pas',
  UnitDownloadThread in 'Units\UnitDownloadThread.pas',
  UnitPhotoDownloaderThread in 'Units\UnitPhotoDownloaderThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'InstagramSaver';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TLogForm, LogForm);
  Application.Run;
end.
