ILButton(hBtn, image, cx=16, cy=16, align=4, margin="1,1,1,1")
{
	StringSplit, v, image, :
	if not v1
		v1 := v3
	v3 := v1
	;HIL := IL_Create(1,1,1)
	HIL := DllCall("ImageList_Create", "UInt",cx, "UInt",cy, "UInt",0x20, "UInt",1, "UInt",5)
	IL_Add(HIL, v1, v2)
	
	; Create a BUTTON_IMAGELIST structure
	VarSetCapacity(BIL, 20 + (A_PtrSize ? A_PtrSize : 4), 0)
	NumPut(HIL, BIL, 0, "UInt")
	;Loop, Parse, margin, `,
		;NumPut(A_LoopField, BIL, A_Index * (A_PtrSize ? A_PtrSize : 4), "UInt")
	NumPut(align, BIL, (A_PtrSize ? A_PtrSize : 4)*(A_PtrSize=8 ? 3 : 5), "UInt")

   SendMessage, 0x1602, 0, &BIL, , ahk_id %hBtn%
}