unit uAssembler;

// Developed using Delphi for Windows and Mac platforms.

// *** Ths source is distributed under Apache 2.0 ***

// Copyright (C) 2019-2020 Herbert M Sauro

// Author Contact Information:
// email: hsauro@gmail.com

interface

Uses Classes, System.SysUtils, System.StrUtils, System.Types, IOUtils, uSymbolTable, uOpCodes;

function assembleCode (const srcCode : string) : TProgram;
function dissassemble (myProgram : TProgram) : string;


implementation

Uses uConstantTable;

var labels : TStringList;

// From stackoverflow (35158485) Alex James
function RemoveDupSpaces(const Input : String) : String;
var
  P : Integer;
begin
  Result := Input;
  repeat
    P := Pos('  ', Result);  // that's two spaces
    if P > 0 then
      Delete(Result, P + 1, 1);
  until P = 0;
end;


procedure collectLabels (srcCode : string);
var sl  : TStringList;
    i : integer;
    s, alabel : string;
    splitted: TArray<string>;
    instCounter : integer;
begin
   labels := TStringList.Create;
   sl := TStringList.Create;
   sl.text := srcCode;
   instCounter := 0;
   for i := 0 to sl.Count - 1 do
       begin
       s := sl[i].TrimLeft;

       // Ignore comment lines and empty lines
       if (s <> '') then
          if (s[1] <> '#') then
             begin
             s := RemoveDupSpaces(s);
             splitted := s.Split([' ']);
             if rightStr(splitted[0], 1) = ':' then
                begin
                // get label
                alabel := leftStr (splitted[0], length (splitted[0])-1);
                labels.AddObject(alabel, TObject (instCounter));
                end;
             inc (instCounter);
             end;
       end;
end;


procedure tokenize (srcStr : string; var dest1, dest2, dest3 : string);
var index : integer;
begin
  dest1 := ''; dest2 := ''; dest3 := '';
  index := pos (':', srcStr);
  if index <> 0 then
     begin
     dest1 := leftstr (srcStr, index-1);
     srcStr := trim (rightStr (srcStr, length (srcStr) - index ));
     end;
  index := pos (' ', srcStr);
  if index <> 0 then
     begin
     dest2 := leftStr (srcStr, index-1);
     dest3 := rightStr (srcStr, length (srcStr) - index);
     end
  else
     dest2 := srcStr;
  dest1 := trim (dest1);
  dest2 := trim (dest2);
  dest3 := trim (dest3);
end;


function assembleCode (const srcCode : string) : TProgram;
var sl  : TStringList;
    i : integer;
    s, alabel, astr : string;
    instCounter, labelInt, index : integer;
    opCodeStr, opCodeArgument : string;
begin
   collectLabels (srcCode);

   result := TProgram.Create;
   sl := TStringList.Create;
   try
     sl.text := srcCode;
     instCounter := 0;
     for i := 0 to sl.Count - 1 do
         begin
         s := sl[i].TrimLeft;

         // Ignore comment lines and empty lines
         if (s <> '') then
            if (s[1] <> '#') then
               begin
               s := RemoveDupSpaces(s);
               tokenize(s, alabel, opcodeStr, opCodeArgument);

               if opCodeStr = opCodeNames[oNop]     then begin result.addByteCode (oNop);     inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oAdd]     then begin result.addByteCode (oAdd);     inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oSub]     then begin result.addByteCode (oSub);     inc (instCounter); continue end;
               if opCodeStr = opcodeNames[oMult]    then begin result.addByteCode (oMult);    inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oDivide]  then begin result.addByteCode (oDivide);  inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oMod]     then begin result.addByteCode (oMod);     inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oDivi]    then begin result.addByteCode (oDivi);    inc (instCounter); continue end;

               if opCodeStr = opCodeNames[oInc]     then begin result.addByteCode (oInc);     inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oDec]     then begin result.addByteCode (oDec);     inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oLocalInc] then begin result.addByteCode (oLocalInc);  inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oLocalDec] then begin result.addByteCode (oLocalDec);  inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oNot]     then begin result.addByteCode (oNot);     inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oAnd]     then begin result.addByteCode (oAnd);     inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oOr]      then begin result.addByteCode (oOr);      inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oXor]     then begin result.addByteCode (oXor);     inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oPop]     then begin result.addByteCode (oPop);     inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oIsGt]    then begin result.addByteCode (oIsGt);    inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oIsGte]   then begin result.addByteCode (oIsGte);   inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oIsLt]    then begin result.addByteCode (oIsLt);    inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oIsLte]   then begin result.addByteCode (oIsLte);   inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oIsEq]    then begin result.addByteCode (oIsEq);    inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oIsNotEq] then begin result.addByteCode (oIsNotEq); inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oPrint]   then begin result.addByteCode (oPrint);   inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oPrintln] then begin result.addByteCode (oPrintln); inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oHalt]    then begin result.addByteCode (oHalt);    inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oRet]     then begin result.addByteCode (oRet);     inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oLvecIdx] then begin result.addByteCode (oLvecIdx); inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oSvecIdx] then begin result.addByteCode (oSvecIdx); inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oLocalLvecIdx] then begin result.addByteCode (oLocalLvecIdx); inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oLocalSvecIdx] then begin result.addByteCode (oLocalSvecIdx); inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oCall]    then begin result.addByteCode (oCall);    inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oBuiltin] then begin result.addByteCode (oBuiltin); inc (instCounter); continue end;
               if opCodeStr = opCodeNames[oLoad] then
                  begin
                  result.addByteCode (oLoad, strtoint (opCodeArgument));
                  inc (instCounter);
                  continue;
                  end;
               if opCodeStr = opCodeNames[oStore] then begin
                  result.addByteCode (oStore, strtoint (opCodeArgument));
                  inc (instCounter);
                  continue;
                  end;
                if opCodeStr = opCodeNames[oCreateList] then
                  begin
                  result.addByteCode (oCreateList, strtoint (opCodeArgument));
                  inc (instCounter);
                  continue
                  end;
               if opCodeStr = opCodeNames[oPushi] then
                  begin
                  result.addByteCode (oPushi, strtoint (opCodeArgument));
                  inc (instCounter);
                  continue;
                  end;
               if opCodeStr = opCodeNames[oPushd] then
                  begin
                  result.addByteCode (oPushd, strtofloat (opCodeArgument));
                  inc (instCounter);
                  continue;
                  end;
               if opCodeStr = opCodeNames[oPushb] then
                  begin
                  if opCodeArgument = 'true' then
                     result.addByteCode (oPushb, true);
                  if opCodeArgument = 'false' then
                    result.addByteCode (oPushb, false);
                  if (opCodeArgument <> 'false') and (opCodeArgument <> 'true') then
                    raise Exception.Create('Expecting boolean true or false in pushb');
                  inc (instCounter);
                  continue;
                  end;
               if opCodeStr = opCodeNames[oPushs] then
                  begin
                  astr := opCodeArgument;
                  // Check for double quotes at start and end of string
                  if (astr[1] = '"') and (astr[length (astr)] = '"') then
                     begin
                     // Strip double quotes from the string
                     astr := astr.Substring (0, astr.Length - 1);
                     delete (astr, 1, 1);
                     result.addByteCode (oPUSHs, astr);
                     inc (instCounter);
                     continue;
                     end
                  else
                     raise Exception.Create('Expecting string as argument to pushs');
                  end;
                if opCodeStr = opCodeNames[oJmp]   then
                  begin
                  index := labels.IndexOf (opCodeArgument);
                  if index <> -1 then
                     begin
                     labelInt := integer (labels.Objects[index]);
                     result.addByteCode (oJMP, labelInt - instCounter);
                     end
                  else
                     raise Exception.Create ('Unable to locate label specificed in jmp opcode');
                  inc (instCounter);
                  continue;
                  end;
               if opCodeStr = opCodeNames[oJmpIfTrue]   then
                  begin
                  index := labels.IndexOf (opCodeArgument);
                  if index <> -1 then
                     begin
                     labelInt := integer (labels.Objects[index]);
                     result.addByteCode (oJmpIfTrue, labelInt - instCounter);
                     end
                  else
                     raise Exception.Create ('Unable to locate label specificed in jmpIfTrue opcode');

                  inc (instCounter);
                  continue;
                  end;
               if opCodeStr = opCodeNames[oJmpIfFalse] then
                  begin
                  index := labels.IndexOf (opCodeArgument);
                  if index <> -1 then
                     begin
                     labelInt := integer (labels.Objects[index]);
                     result.addByteCode (oJmpIfFalse, labelInt - instCounter);
                     end
                  else
                     raise Exception.Create ('Unable to locate label specificed in jmpIfFalse opcode');
                  inc (instCounter);
                  continue;
                  end;

                 raise Exception.Create ('Error: Unknown op code in program: ' + opCodeStr);
                 end;
              end;
   finally
     sl.Free;
     labels.Free;
   end;
end;


function dissassemble (myProgram : TProgram) : string;
var i : integer;
begin
  result := '';
  for i := 0 to myProgram.count - 1 do
      begin
      result := result + format ('%3d', [i]);
      case myProgram.code[i].opCode of
        oNop        : result := result + '  ' + opCodeNames[oNop]    + ' ' + sLineBreak;
        oHalt       : result := result + '  ' + opCodeNames[oHalt]   + sLineBreak;

        oPushi      : result := result + '  ' + opCodeNames[oPushi] + ' ' + inttostr (myProgram.code[i].index) + sLineBreak;
        oPushb      : result := result + '  ' + opCodeNames[oPushb] + ' ' + inttostr (myProgram.code[i].index) + sLineBreak;
        oPushd      : result := result + '  ' + opCodeNames[oPushd] + ' ' + floattostr (constantValueTable[myProgram.code[i].index].dValue) + sLineBreak;
        oPushs      : result := result + '  ' + opCodeNames[oPushs] + ' "' + constantValueTable[myProgram.code[i].index].sValue.value + '"' + sLineBreak;
        oPushNone   : result := result + '  ' + opCodeNames[oPushNone] + sLineBreak;

        oAdd        : result := result + '  ' + opCodeNames[oAdd]    + sLineBreak;
        oSub        : result := result + '  ' + opCodeNames[oSub]    + sLineBreak;
        oMult       : result := result + '  ' + opCodeNames[oMult]   + sLineBreak;
        oDivide     : result := result + '  ' + opCodeNames[oDivide] + sLineBreak;
        oDivi       : result := result + '  ' + opCodeNames[oDivI]   + sLineBreak;
        oMod        : result := result + '  ' + opCodeNames[oMod]    + sLineBreak;
        oPower      : result := result + '  ' + opCodeNames[oPower]  + sLineBreak;
        oUmi        : result := result + '  ' + opCodeNames[oUmi]    + sLineBreak;
        oInc        : result := result + '  ' + opCodeNames[oInc]    + ' ' + inttostr (myProgram.code[i].index) + sLineBreak;
        oDec        : result := result + '  ' + opCodeNames[oDec]    + sLineBreak;
        oLocalInc   : result := result + '  ' + opCodeNames[oLocalInc] + sLineBreak;
        oLocalDec   : result := result + '  ' + opCodeNames[oLocalDec] + sLineBreak;
        oOr         : result := result + '  ' + opCodeNames[oOr]     + sLineBreak;
        oAnd        : result := result + '  ' + opCodeNames[oAnd]    + sLineBreak;
        oXor        : result := result + '  ' + opCodeNames[oXor]    + sLineBreak;
        oNot        : result := result + '  ' + opCodeNames[oNot]    + sLineBreak;
        oPop        : result := result + '  ' + opCodeNames[oPop]    + sLineBreak;

        oIsGt       : result := result + '  ' + opCodeNames[oIsGt]   + sLineBreak;
        oIsLt       : result := result + '  ' + opCodeNames[oIsLt]   + sLineBreak;
        oIsGte      : result := result + '  ' + opCodeNames[oIsGte]   + sLineBreak;
        oIsLte      : result := result + '  ' + opCodeNames[oIsLte]   + sLineBreak;
        oIsEq       : result := result + '  ' + opCodeNames[oIsEq]   + sLineBreak;
        oIsNotEq    : result := result + '  ' + opCodeNames[oIsNotEq]   + sLineBreak;

        oPrint      : result := result + '  ' + opCodeNames[oPrint]  + sLineBreak;
        oPrintln    : result := result + '  ' + opCodeNames[oPrintln]  + sLineBreak;
        oAssertTrue : result := result + '  ' + opCodeNames[oAssertTrue]  + sLineBreak;
        oAssertFalse: result := result + '  ' + opCodeNames[oAssertFalse]  + sLineBreak;

        oJmp        : result := result + '  ' + opCodeNames[oJmp]   + ' ' + inttostr (myProgram.code[i].index) + sLineBreak;
        oJmpIfTrue  : result := result + '  ' + opCodeNames[ojmpIfTrue] + ' ' + inttostr (myProgram.code[i].index) + sLineBreak;
        oJmpIfFalse : result := result + '  ' + opCodeNames[oJmpIfFalse] + ' ' + inttostr (myProgram.code[i].index) + sLineBreak;

        oStore      : result := result + '  ' + opCodeNAmes[oStore] + ' ' + inttostr (myProgram.code[i].index) + sLineBreak;
        oLoad       : result := result + '  ' + opCodeNames[oLoad]  + ' ' + inttostr (myProgram.code[i].index) + sLineBreak;
        oStoreLocal : result := result + '  ' + opCodeNAmes[oStoreLocal] + ' ' + inttostr (myProgram.code[i].index) + sLineBreak;
        oLoadLocal  : result := result + '  ' + opCodeNames[oLoadLocal]  + ' ' + inttostr (myProgram.code[i].index) + sLineBreak;

        oCall       : result := result + '  ' + opCodeNames[oCall] + sLineBreak;
        oBuiltin    : result := result + '  ' + opCodeNames[oBuiltin] + ' ' + inttostr (myProgram.code[i].index) + sLineBreak;
        oRet        : result := result + '  ' + opCodeNames[oRet]     + ' ' + sLineBreak;
        oLvecIdx    : result := result + '  ' + opCodeNames[oLvecIdx] + sLineBreak;
        oSvecIdx    : result := result + '  ' + opCodeNames[oSvecIdx] + sLineBreak;
        oLocalLvecIdx    : result := result + '  ' + opCodeNames[oLocalLvecIdx] + ' ' + inttostr (myProgram.code[i].index) + sLineBreak;
        oLocalSvecIdx    : result := result + '  ' + opCodeNames[oLocalSvecIdx] + ' ' + inttostr (myProgram.code[i].index) + sLineBreak;
        oCreateList : result := result + '  ' + opCodeNames[oCreateList] + ' ' + inttostr (myProgram.code[i].index) + sLineBreak;
      else
        writeln ('Unknown opcode during dissassembly: ', myProgram.code[i].opCode);
      end;
      end;
end;

end.

