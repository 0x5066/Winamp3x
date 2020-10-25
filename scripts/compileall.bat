@echo off
echo ----------------------------------------------------
echo +                                                  +
echo +      The compile all script for this skin.       +
echo +         Well... almost all that is...            +
echo +         You obviously need the WaSDP             +
echo +        (WinAmp Skin Development Pack)            +
echo +               for this to work                   +
echo +             Version 1.0 by 0x5066                +
echo +                                                  +
echo ----------------------------------------------------
timeout 2
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