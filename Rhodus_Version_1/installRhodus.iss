; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Rhodus"
#define MyAppVersion "1.03"
#define MyAppPublisher "Ambrosius Publishing"
#define MyAppURL "objectpascalinterpreter.com"
#define MyAppExeName "RhodusConsole.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{8E4FABEB-7315-4098-8E6F-B5E9E00A83D4}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName=Rhodus
DisableProgramGroupPage=yes
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputBaseFilename=rhodusSetup
OutputDir=c:\tmp
Compression=lzma
SolidCompression=yes
WizardStyle=modern
UninstallDisplayIcon={app}\Uninstall-Tool.ico

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[INI]
Filename: {userappdata}\rhodus\rhodus.ini; Section: Path; Key: RHODUSPATH; String: {userdocs}\rhodus

[Files]
Source: "U:\Delphi\InstallationFiles_Part2\bin\RhodusConsole.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "U:\Delphi\InstallationFiles_Part2\SampleScripts\*"; DestDir: "{userdocs}\rhodus\SampleScripts"; Flags: ignoreversion
Source: "U:\Delphi\InstallationFiles_Part2\TestScripts\*"; DestDir: "{userdocs}\rhodus\TestScripts"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "U:\Delphi\InstallationFiles_Part2\rhodus.ini"; DestDir: "{userappdata}\rhodus"; Flags: uninsneveruninstall onlyifdoesntexist
Source: "U:\Delphi\InstallationFiles_Part2\Uninstall-Tool.ico"; DestDir: "{app}"
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: {group}\{cm:UninstallProgram, Rhodus}; Filename: {uninstallexe}; IconFilename: {app}\Uninstall-Tool.ico;
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

