#NoTrayIcon

ConvertNum = %1%

if (ConvertNum = 1)
{                                                            					    ; Convert text to lower case
 StringLower Clipboard, Clipboard
}

if (ConvertNum = 2)
{                                                           			   	        ; Convert text to UPPER CASE
 StringUpper Clipboard, Clipboard
}

if (ConvertNum = 3)                                    						        ; Convert text to Sentence case
{
StringLower, Clipboard, Clipboard
Clipboard := RegExReplace(Clipboard, "((?:^|[.!?]\s+)[a-z])", "$u1")
}

if (ConvertNum = 4)                                                          	    ; Convert text to Capitalized Case
{
 StringUpper Clipboard, Clipboard, T
}

if (ConvertNum = 5)                                                                 ; Convert text to oPPOSITE cASE
{
 Lab_Invert_Char_Out:= ""
 Loop % Strlen(Clipboard) {
    Lab_Invert_Char:= Substr(Clipboard, A_Index, 1)
    if Lab_Invert_Char is upper
       Lab_Invert_Char_Out:= Lab_Invert_Char_Out Chr(Asc(Lab_Invert_Char) + 32)
    else if Lab_Invert_Char is lower
       Lab_Invert_Char_Out:= Lab_Invert_Char_Out Chr(Asc(Lab_Invert_Char) - 32)
    else
       Lab_Invert_Char_Out:= Lab_Invert_Char_Out Lab_Invert_Char
 }	
 clipboard := Lab_Invert_Char_Out
}

if (ConvertNum = 6)                                                                 ; Convert text to AlTeRnAtInG CaSe
{
Lab_Invert_Char_Out:= ""
StringLower,Clipboard,Clipboard
Loop % Strlen(Clipboard) {
    Lab_Invert_Char:= Substr(Clipboard, A_Index, 1)
    Lab_Aux:=!Lab_Aux
    if Lab_Aux
       Lab_Invert_Char_Out .= Chr(Asc(Lab_Invert_Char) - 32)
    else
       Lab_Invert_Char_Out .= Lab_Invert_Char
}
 clipboard := Lab_Invert_Char_Out
}
 
if (ConvertNum = 7)                                                                 ; Convert text to snake_case
{
	Clipboard := StrReplace(Clipboard, " ", "_")
}
 
if (ConvertNum = 8)                                                                 ; Convert text to kebab-case
{
	Clipboard := StrReplace(Clipboard, " ", "-")
}
return