{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit exp_button;

{$warn 5023 off : no warning about unused units}
interface

uses
  BCExpandingButton, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('BCExpandingButton', @BCExpandingButton.Register);
end;

initialization
  RegisterPackage('exp_button', @Register);
end.
