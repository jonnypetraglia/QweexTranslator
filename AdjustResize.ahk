/*
 AdjustResize is a function to help with resizing windows in Autohotkey
 Copyright 2010 Jon Petraglia

    This script is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This script is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/


AdjustResize(controlname,options="wh")
{
 static
 ;Do what you will if the GUI is not a positive integer.
 ifnotinstring, A_ThisLabel,guisize
  return, 404
 Stringreplace, guinum,A_ThisLabel,guisize
 if(guinum="")
  guinum=1
 if !(guinum>0)
  return, 405
 gui %guinum%: +lastfound
 GUI_ID:=WinExist()

 ;If this control hasn't been initialized yet....
 if !%controlname%_start
 {
  Wingetpos, %controlname%_win_last_X,%controlname%_win_last_Y,%controlname%_win_last_W,%controlname%_win_last_H, ahk_id %GUI_ID%
  guicontrolget, %controlname%_last_, pos,%controlname%
  %controlname%_start=1
  return
 }

 ;Get the current positions and adjust them.
 Wingetpos, %controlname%_win_X,%controlname%_win_Y,%controlname%_win_W,%controlname%_win_H, ahk_id %GUI_ID%
 guicontrolget, %controlname%_, pos,%controlname%
 ifinstring, options, w
  %controlname%_w := %controlname%_win_w - ( %controlname%_win_last_w - %controlname%_last_w )
 ifinstring, options, h
  %controlname%_h := %controlname%_win_h - ( %controlname%_win_last_h - %controlname%_last_h )
 ifinstring, options, x
  %controlname%_x := %controlname%_win_w - ( %controlname%_win_last_w - %controlname%_last_x - %controlname%_last_w ) - %controlname%_w
 ifinstring, options, y
 {
;~   ifinstring, options, h
   %controlname%_y := %controlname%_win_h - ( %controlname%_win_last_h - %controlname%_last_y - %controlname%_last_h ) - %controlname%_h
;~   Else
;~    %controlname%_y := %controlname%_win_h - ( %controlname%_win_last_h - %controlname%_last_y)
 }

 ;Aaaaaand move it.
 guicontrol, move,%controlname%,% "w" %controlname%_w . " h" . %controlname%_h . " x" . %controlname%_x . " y" . %controlname%_y

 ;Sets the new parameters of this time to be the old parameters of next time
 %controlname%_win_last_w := %controlname%_win_w
 %controlname%_last_w := %controlname%_w
 %controlname%_win_last_h := %controlname%_win_h
 %controlname%_last_h := %controlname%_h
 %controlname%_win_last_x := %controlname%_win_x
 %controlname%_last_x := %controlname%_x
 %controlname%_win_last_y := %controlname%_win_y
 %controlname%_last_y := %controlname%_y
}