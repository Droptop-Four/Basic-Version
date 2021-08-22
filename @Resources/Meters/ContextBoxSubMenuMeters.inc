[Rainmeter]
OnFocusAction=[!SetVariable FocusedGroup #FocusGroup# "Droptop\Other\BackgroundProcesses"][!UpdateMeasure CompareFocused "Droptop\Other\BackgroundProcesses"]
OnUnfocusAction=[!SetVariable FocusedGroupPrev #FocusGroup# "Droptop\Other\BackgroundProcesses"][!UpdateMeasure MeasureIsFullScreen "Droptop\Other\BackgroundProcesses"]
Group=DroptopSuite | Toolbars | Tray | ContextBox | Submenus
MouseActionCursor=Arrow
; SkinHeight=(#DropdownMenuHeight#*#NumberOfItems#+(9*#DroptopSize#)-(#DropdownCutout#*2)+(((10*#DroptopSize#)+(3*#DroptopSize#))*#NumberOfDividers#)+#DropdownItemYOffset#)
SkinWidth=(#MiniMenuWidth#+2)
RightMouseDownAction=[]
Blur=#DropdownBlur#
Update=-1

DefaultSavePosition=1
DefaultAlwaysOnTop=1
DefaultDraggable=1
DefaultSnapEdges=1
DefaultStartHidden=1
DefaultAlphaValue=255
DefaultHideOnMouseOver=0
DefaultFadeDuration=105
DefaultClickThrough=0
DefaultKeepOnScreen=0
DefaultAutoSelectScreen=0

[Metadata]
Name=Droptop Four
Author=Cariboudjan / Thomas Sven Whittaker
Information=The frogurt is also cursed
License=Creative Commons Attribution-Non-Commercial-Share Alike 3.0

[Variables]
;-----------------------------------
Padding0=(#HideIcons#=1?#NoIconPadding#:#DropdownPadding#),#DropdownPaddingY#,#DropdownPadding2#,(#DropdownPaddingY#*-1)
Padding1=(#DropdownPadding#*2),#DropdownPaddingY#,#NoIconPadding#,(#DropdownPaddingY#*-1)
;---
; Padding0B=(#HideIcons#=1?#NoIconPadding#:#DropdownPadding#),#DropdownPaddingY#,#DropdownPadding2#,(#DropdownPaddingY#*-1)
Padding0B=(#HideIcons#=1?#NoIconPadding#:#DropdownPadding#),#DropdownPaddingY#,(#NoIconPadding#*2),(#DropdownPaddingY#*-1)
; Padding1B=#DropdownPadding2#,#DropdownPaddingY#,(#HideIcons#=1?#NoIconPadding#:#DropdownPadding#),(#DropdownPaddingY#*-1)
Padding1B=(#NoIconPadding#*2),#DropdownPaddingY#,(#HideIcons#=1?#NoIconPadding#:#DropdownPadding#),(#DropdownPaddingY#*-1)
;-----------------------------------

;----------------------------------------------------

[BlurBehind]
Measure=Plugin
Plugin=FrostedGlass
BlurEnabled=#MenuBlur#
Type=[#BlurType[#BlurTypeNum]]
Border=[#DropdownShadow[#ShadowsON]]
DynamicVariables=1

;----------------------------------------------------
; Styles
;----------------------------------------------------

[InfoStyle]
StringAlign=#TextDirection#Center
FontColor=#SuperColor#,#DropdownItemOpacity#
FontFace=[#FontName[#ThemeNum][#AltFont[#LanguageNum]]]
FontSize=#DropdownMenuFontSize#
InlineSetting=CharacterSpacing | #DropdownCharacterSpacing#
X=(1+(#DropdownMenuWidth#*#RTLText#))
Y=R
W=(#DropdownMenuWidth#-(#NoIconPadding#*2)-#DropdownPadding#+((#DropdownPadding#-#NoIconPadding#)*#HideIcons#))
H=#DropdownMenuHeight#
FontWeight=#FontWeight#
Padding=[#Padding[#RTLText]B]
AntiAlias=#DropdownAntiAlias#
MouseOverAction=[!SetOption #CURRENTSECTION#Icon ImageTint "#*SuperColor2*#,(255-(255*#HideIcons#))"][!SetOption #CURRENTSECTION#Folder FontColor #*SuperColor2*#][!SetOption #CURRENTSECTION# FontColor "#*SuperColor2*#"][!ShowMeterGroup Highlight][!SetOptionGroup Highlight Y [#CURRENTSECTION#:Y]][!SetOptionGroup Highlight W [#CURRENTSECTION#:W]][!UpdateMeterGroup Highlight][!UpdateMeter #CURRENTSECTION#Icon][!UpdateMeter #CURRENTSECTION#][!Redraw]
MouseLeaveAction=[!HideMeterGroup Highlight][!SetOption #CURRENTSECTION#Icon ImageTint "#*SuperColor*#,(#DropdownItemOpacity#-(#DropdownItemOpacity#*#HideIcons#))"][!SetOption #CURRENTSECTION#Folder FontColor #*SuperColor*#][!SetOption #CURRENTSECTION# FontColor "#*SuperColor*#,#DropdownItemOpacity#"][!UpdateMeter #CURRENTSECTION#Icon][!UpdateMeter #CURRENTSECTION#][!Redraw]
MouseScrollUpAction=[!SetVariable ScrollTracker (#ScrollTracker#-(#ScrollTracker#-#MaxItem#<=#MaxItem#?(#ScrollTracker#-#MaxItem#):#MaxItem#))][!CommandMeasure ScrollbarScript UpdateCurrentPos(-#MaxItem#)][!CommandMeasure mPath "PageUp"][!DeactivateConfigGroup Toolbar02][!HideMeter HighlightSelected][!UpdateMeasure *][!UpdateMeter *][!Redraw]
MouseScrollDownAction=[!SetVariable ScrollTracker (#ScrollTracker#+([AnalyzeTotal]>#MaxItem#?(#ScrollTracker#+#MaxItem#>=[AnalyzeTotal]?([AnalyzeTotal]-#ScrollTracker#):#MaxItem#):0))][!CommandMeasure ScrollbarScript UpdateCurrentPos(#MaxItem#)][!CommandMeasure mPath "PageDown"][!DeactivateConfigGroup Toolbar02][!HideMeter HighlightSelected][!UpdateMeasure *][!UpdateMeter *][!Redraw]
DynamicVariables=1
ClipString=1
Group=Items

[IconStyle]
ImageTint=#SuperColor#,(#DropdownItemOpacity#-(#DropdownItemOpacity#*#HideIcons#))
X=(#DropdownIconXoffset#+((#DropdownMenuWidth#-#DropdownIconXoffset#-#IconW#-#HighlightXOffset#-(#DropdownIconPadding#*2))*#RTLText#))
Y=#DropdownIconSpacing#R
Padding=#DropdownIconPadding#,#DropdownIconPadding#,#DropdownIconPadding#,(#DropdownIconPadding#+(#DropdownIconPadding#%1))
Greyscale=#Greyscale#
Hidden=#HideIcons#
DynamicVariables=1
Group=Items

[CheckmarkStyle]
ImageTint=#SuperColor#
ImageName=#@#FixedIcons\#IconSize#\checkmark.png
X=(#DropdownIconXoffset#+((#DropdownMenuWidth#-#DropdownIconXoffset#-#IconW#-#HighlightXOffset#-(#DropdownIconPadding#*2))*#RTLText#))
Y=#DropdownIconSpacing#R
Padding=#DropdownIconPadding#,#DropdownIconPadding#,#DropdownIconPadding#,(#DropdownIconPadding#+(#DropdownIconPadding#%1))
Greyscale=#Greyscale#
DynamicVariables=1
Group=Items

[BackgroundStyle]
LeftMouseDownAction=[]
UpdateDivider=-1

;----------------------------------------------------
; Background Meters
;----------------------------------------------------

[Background]
Meter=Shape
MeterStyle=BackgroundStyle
Shape=Rectangle #DropdownCutout#,#DropdownCutout#,(#DropdownMenuWidth#+2-(#DropdownCutout#*2)),((#DropdownMenuHeight#*#NumberOfItems#)+(((10*#DroptopSize#)+(3*#DroptopSize#))*#NumberOfDividers#)+((#DropdownIconYoffset#+#DropdownItemYOffset#)*2)-#DropdownCutout#),#BGCorner# | Fill Color #ToolbarBG1#,(#ToolbarOpacity1#<1?1:#ToolbarOpacity1#) | StrokeWidth #StrokeWidth2# | Stroke Color #StrokeColor2#
UpdateDivider=-1

;----------------------------------------------------
; Item highlight

[HighlightContainer]
Meter=Shape
MeterStyle=BackgroundStyle
Shape=Rectangle (#DropdownCutout#+#HighlightCutout#),(#DropdownIconYoffset#-((#DropdownIconYoffset#+(#DropdownMenuHeight#/2))%1)+#DropdownItemYOffset#),(#DropdownMenuWidth#+2-(#DropdownCutout#*2)-(#HighlightCutout#*2)),(#DropdownMenuHeight#*#NumberOfItems#+(((10*#DroptopSize#)+(3*#DroptopSize#))*#NumberOfDividers#)),#HLContainerCorner# | Fill Color 255,0,0 | StrokeWidth 0
UpdateDivider=-1

[HighlightBackground]
Meter=Shape
Shape=Rectangle (#DropdownCutout#+#HighlightXOffset#),0,((#DropdownMenuWidth#-(#DropdownCutout#*2))-((#DropdownMenuWidth#-(#DropdownCutout#*2))%1)-(#HighlightXOffset#*2)),#DropdownMenuHeight#,#HLCorner# | Fill Color #ToolbarHL#,#ToolbarHLO# | StrokeWidth 0
UpdateDivider=-1
Group=Highlight
Hidden=1
X=1
Container=HighlightContainer

[HighlightSelected]
Meter=Shape
Shape=Rectangle 1,1,18,(#DropdownMenuHeight#-2),#BGCorner# | Fill Color #ToolbarHL#,55 | StrokeWidth 2 | Stroke Color #StrokeColor1#
Group=HighlightSelected
DynamicVariables=1
Hidden=1
Container=HighlightContainer