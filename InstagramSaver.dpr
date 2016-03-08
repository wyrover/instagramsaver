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
  UnitFavs in 'Forms\UnitFavs.pas' {FavForm},
  UnitPhotoPageLinkExtractorLauncher in 'Units\UnitPhotoPageLinkExtractorLauncher.pas',
  UnitMediaLinkExtLauncher in 'Units\UnitMediaLinkExtLauncher.pas',
  UnitPhotoDownloadLauncher in 'Units\UnitPhotoDownloadLauncher.pas',
  UnitFileCheckerLauncher in 'Units\UnitFileCheckerLauncher.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'InstagramSaver';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TFavForm, FavForm);
  Application.Run;
end.
