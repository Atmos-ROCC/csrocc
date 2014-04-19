;AutoHotKey script designed to help streamline common tasks
;Written by Daniel Kolkena

#InstallMouseHook
#Hotstring NoMouse

#IfWinActive ahk_class PuTTY	; Only activate within a PuTTY window

; Hotkeys 

^+p::Send <password>{enter}	; Ctrl+Shift+P
^+o::Send <password>{enter}	; Ctrl+Shift+O


; Hotstrings

:o:~tools::
(
cd /var/service/AET/workdir/tools/; ls -l;		
)

:o:~scan::
(
cd /var/service/; chmod +x show_offline_disks.sh; ./show_offline_disks.sh -l;
)

:o:~mds::
(
rmsview -l mauimds | grep -v up; mauictl status | grep -v running;		
)


#IfWinActive			; Global hotkeys


