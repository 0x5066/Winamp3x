@echo off
echo ----------------------------------------------------
echo +                                                  +
echo +      The compile all script for this skin.       +
echo +          Well... almost all that is...           +
echo +         You obviously need the WaSDP             +
echo +        (WinAmp Skin Development Pack)            +
echo +              and Winamp or WACUP                 +
echo +               for this to work                   +
echo +             Version 1.1 by 0x5066                +
echo +                                                  +
echo ----------------------------------------------------
set /p ask= Do you use Winamp or WACUP? 
echo.
IF /I "%ask%" == "WACUP" (CALL :WACUP) ELSE (CALL :WINAMP)
timeout 2
:WACUP
"C:\Program Files (x86)\WACUP\mc.exe" about.m
"C:\Program Files (x86)\WACUP\mc.exe" albumart.m
"C:\Program Files (x86)\WACUP\mc.exe" eq.m
"C:\Program Files (x86)\WACUP\mc.exe" eq_animated_bars.m
"C:\Program Files (x86)\WACUP\mc.exe" meters.m
"C:\Program Files (x86)\WACUP\mc.exe" play_pause.m
"C:\Program Files (x86)\WACUP\mc.exe" playlist_editor.m
"C:\Program Files (x86)\WACUP\mc.exe" progbarswitch.m
"C:\Program Files (x86)\WACUP\mc.exe" standardframe.m
"C:\Program Files (x86)\WACUP\mc.exe" system.m
"C:\Program Files (x86)\WACUP\mc.exe" titlebar.m
"C:\Program Files (x86)\WACUP\mc.exe" tooltips.m
"C:\Program Files (x86)\WACUP\mc.exe" visualizer.m
"C:\Program Files (x86)\WACUP\mc.exe" winampvisualizer.m
exit
:WINAMP
"C:\Program Files (x86)\Winamp\mc.exe" about.m
"C:\Program Files (x86)\Winamp\mc.exe" albumart.m
"C:\Program Files (x86)\Winamp\mc.exe" eq.m
"C:\Program Files (x86)\Winamp\mc.exe" eq_animated_bars.m
"C:\Program Files (x86)\Winamp\mc.exe" meters.m
"C:\Program Files (x86)\Winamp\mc.exe" play_pause.m
"C:\Program Files (x86)\Winamp\mc.exe" playlist_editor.m
"C:\Program Files (x86)\Winamp\mc.exe" progbarswitch.m
"C:\Program Files (x86)\Winamp\mc.exe" standardframe.m
"C:\Program Files (x86)\Winamp\mc.exe" system.m
"C:\Program Files (x86)\Winamp\mc.exe" titlebar.m
"C:\Program Files (x86)\Winamp\mc.exe" tooltips.m
"C:\Program Files (x86)\Winamp\mc.exe" visualizer.m
"C:\Program Files (x86)\Winamp\mc.exe" winampvisualizer.m
exit