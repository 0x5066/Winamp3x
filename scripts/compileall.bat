@echo off
echo ----------------------------------------------------
echo +                                                  +
echo +      The compile all script for this skin.       +
echo +          Well... almost all that is...           +
echo +         You obviously need the WaSDP             +
echo +        (WinAmp Skin Development Pack)            +
echo +              and Winamp or WACUP                 +
echo +               for this to work                   +
echo +             Version 1.2 by 0x5066                +
echo +                                                  +
echo ----------------------------------------------------
set /p ask= Do you use Winamp or WACUP? 
echo.
IF /I "%ask%" == "WACUP" (CALL :WACUP) ELSE (CALL :WINAMP)
timeout 2
:WACUP
"C:\Program Files (x86)\WACUP\mc.exe" about.m /debugfile
ren debug.sym about_debug.sym
"C:\Program Files (x86)\WACUP\mc.exe" albumart.m /debugfile
ren debug.sym albumart_debug.sym
"C:\Program Files (x86)\WACUP\mc.exe" eq.m /debugfile
ren debug.sym eq_debug.sym
"C:\Program Files (x86)\WACUP\mc.exe" eq_animated_bars.m /debugfile
ren debug.sym eq_animated_bars_debug.sym
"C:\Program Files (x86)\WACUP\mc.exe" meters.m /debugfile
ren debug.sym meters_debug.sym
"C:\Program Files (x86)\WACUP\mc.exe" play_pause.m /debugfile
ren debug.sym play_pause_debug.sym
"C:\Program Files (x86)\WACUP\mc.exe" playlist_editor.m /debugfile
ren debug.sym playlist_editor_debug.sym
"C:\Program Files (x86)\WACUP\mc.exe" progbarswitch.m /debugfile
ren debug.sym progbarswitch_debug.sym
"C:\Program Files (x86)\WACUP\mc.exe" standardframe.m /debugfile
ren debug.sym standardframe_debug.sym
"C:\Program Files (x86)\WACUP\mc.exe" system.m /debugfile
ren debug.sym system_debug.sym
"C:\Program Files (x86)\WACUP\mc.exe" titlebar.m /debugfile
ren debug.sym titlebar_debug.sym
"C:\Program Files (x86)\WACUP\mc.exe" tooltips.m /debugfile
ren debug.sym tooltips_debug.sym
"C:\Program Files (x86)\WACUP\mc.exe" visualizer.m /debugfile
ren debug.sym visualizer_debug.sym
"C:\Program Files (x86)\WACUP\mc.exe" winampvisualizer.m /debugfile
ren debug.sym winampvisualizer_debug.sym
exit
:WINAMP
"C:\Program Files (x86)\Winamp\mc.exe" about.m /debugfile
ren debug.sym about_debug.sym
"C:\Program Files (x86)\Winamp\mc.exe" albumart.m /debugfile
ren debug.sym albumart_debug.sym
"C:\Program Files (x86)\Winamp\mc.exe" eq.m /debugfile
ren debug.sym eq_debug.sym
"C:\Program Files (x86)\Winamp\mc.exe" eq_animated_bars.m /debugfile
ren debug.sym eq_animated_bars_debug.sym
"C:\Program Files (x86)\Winamp\mc.exe" meters.m /debugfile
ren debug.sym meters_debug.sym
"C:\Program Files (x86)\Winamp\mc.exe" play_pause.m /debugfile
ren debug.sym play_pause_debug.sym
"C:\Program Files (x86)\Winamp\mc.exe" playlist_editor.m /debugfile
ren debug.sym playlist_editor_debug.sym
"C:\Program Files (x86)\Winamp\mc.exe" progbarswitch.m /debugfile
ren debug.sym progbarswitch_debug.sym
"C:\Program Files (x86)\Winamp\mc.exe" standardframe.m /debugfile
ren debug.sym standardframe_debug.sym
"C:\Program Files (x86)\Winamp\mc.exe" system.m /debugfile
ren debug.sym system_debug.sym
"C:\Program Files (x86)\Winamp\mc.exe" titlebar.m /debugfile
ren debug.sym titlebar_debug.sym
"C:\Program Files (x86)\Winamp\mc.exe" tooltips.m /debugfile
ren debug.sym tooltips_debug.sym
"C:\Program Files (x86)\Winamp\mc.exe" visualizer.m /debugfile
ren debug.sym visualizer_debug.sym
"C:\Program Files (x86)\Winamp\mc.exe" winampvisualizer.m /debugfile
ren debug.sym winampvisualizer_debug.sym
exit