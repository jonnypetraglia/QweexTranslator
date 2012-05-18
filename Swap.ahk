;++++++++++++++++++Available in AHK help
InsertInteger(pInteger,ByRef pDest,pOffset=0,pSize=4)
{
loop %pSize%  ; Copy each byte in the integer into the structure as raw binary data.
	DllCall("RtlFillMemory",UInt,&pDest+pOffset+A_Index-1,UInt,1,UChar,pInteger>>8*(A_Index-1) & 0xFF)
}

;By PhiLho 		http://www.autohotkey.com/forum/topic13062.html
; Swap two columns of the list view # _lvID, given by their index, starting at 1
Swap(_col1, _col2, _colNb, _lvID)
{
   local colOrder, pos

   VarSetCapacity(colOrder, _colNb * 4, 0)
   Loop %_colNb%
   {
      pos := A_Index - 1
      If (A_Index = _col1)
         InsertInteger(_col2 - 1, colOrder, pos * 4)
      Else If (A_Index = _col2)
         InsertInteger(_col1 - 1, colOrder, pos * 4)
      Else
         InsertInteger(pos, colOrder, pos * 4)
   }
   SendMessage 0x1000 + 58   ; LVM_SETCOLUMNORDERARRAY
         , _colNb, &colOrder, SysListView32%_lvId%, A
   SendMessage 0x1000 + 21   ; LVM_REDRAWITEMS
         , 0, _colNb - 1, SysListView32%_lvId%, A
}