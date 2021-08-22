Dim WshS
Set WshS = WScript.CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

usrProfile = WshS.ExpandEnvironmentStrings("%UserProfile%")

arg = WScript.Arguments.Item(0)

'strMessage = "Icons have been updated."

'Msgbox strMessage, 0, ""



Const DESKTOP = &H10&

Set objShell = CreateObject("Shell.Application")

Set objFolder = objShell.NameSpace(arg & "Droptop Folders\Bookmarks")

Set objFolder2 = objShell.NameSpace(arg & "Droptop Folders\Games\Browser games")

Set objFolder3 = objShell.NameSpace(arg & "Droptop Folders\Bookmarks\Podcasts\Crime & Drama")

Set objFolder4 = objShell.NameSpace(arg & "Droptop Folders\Bookmarks\Podcasts\Politics")

Set objFolder5 = objShell.NameSpace(arg & "Droptop Folders\Bookmarks\Podcasts\Science & Technology")

Set objFolder6 = objShell.NameSpace(arg & "Droptop Folders\Bookmarks\Podcasts\Sex & Psychology")

Set objFolder7 = objShell.NameSpace(arg & "Droptop Folders\Bookmarks\Podcasts\Sports")

Set objFolder8 = objShell.NameSpace(arg & "Droptop Folders\Bookmarks\Podcasts\Talk Shows")

Set objFolder9 = objShell.NameSpace(arg & "Droptop Folders\Bookmarks\Shopping")

Set objFolder10 = objShell.NameSpace(arg & "Droptop Folders\Bookmarks\Online tools")

Set objFolder11 = objShell.NameSpace(arg & "Droptop Folders\Bookmarks\Online tools\Diagnostic")

Set objFolder12 = objShell.NameSpace(arg & "Droptop Folders\Bookmarks\News & Media\Far-Left")

Set objFolder13 = objShell.NameSpace(arg & "Droptop Folders\Bookmarks\News & Media\Far-Right")

Set objFolder14 = objShell.NameSpace(arg & "Droptop Folders\Bookmarks\News & Media\International")

Set objFolder15 = objShell.NameSpace(arg & "Droptop Folders\Bookmarks\News & Media\US Conservative")

Set objFolder16 = objShell.NameSpace(arg & "Droptop Folders\Bookmarks\News & Media\US Democrat")

Set objFolder17 = objShell.NameSpace(arg & "Droptop Folders\Bookmarks\News & Media\US Moderate")




Set objFolderItem1 = objFolder.ParseName("Facebook.url")

Set objShortcut1 = objFolderItem1.GetLink

objShortcut1.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Facebook.ico", 0




Set objFolderItem2 = objFolder.ParseName("Google Photos.url")

Set objShortcut2 = objFolderItem2.GetLink

objShortcut2.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Google Photos.ico", 0




Set objFolderItem3 = objFolder.ParseName("Hulu.url")

Set objShortcut3 = objFolderItem3.GetLink

objShortcut3.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Hulu.ico", 0




Set objFolderItem4 = objFolder.ParseName("Gmail.url")

Set objShortcut4 = objFolderItem4.GetLink

objShortcut4.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Inbox.ico", 0




Set objFolderItem5 = objFolder.ParseName("Netflix.url")

Set objShortcut5 = objFolderItem5.GetLink

objShortcut5.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Netflix.ico", 0




Set objFolderItem6 = objFolder.ParseName("Google Keep.url")

Set objShortcut6 = objFolderItem6.GetLink

objShortcut6.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Google Keep.ico", 0




Set objFolderItem7 = objFolder.ParseName("Reddit.url")

Set objShortcut7 = objFolderItem7.GetLink

objShortcut7.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Reddit.ico", 0




Set objFolderItem8 = objFolder.ParseName("Steam.url")

Set objShortcut8 = objFolderItem8.GetLink

objShortcut8.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Steam.ico", 0




Set objFolderItem9 = objFolder.ParseName("Google Maps.url")

Set objShortcut9 = objFolderItem9.GetLink

objShortcut9.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Google Maps.ico", 0




Set objFolderItem10 = objFolder.ParseName("Twitch.url")

Set objShortcut10 = objFolderItem10.GetLink

objShortcut10.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Twitch.ico", 0




Set objFolderItem11 = objFolder.ParseName("YouTube.url")

Set objShortcut11 = objFolderItem11.GetLink

objShortcut11.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\YouTube.ico", 0





'Games folder ###############################################################################################




Set objFolderItem20 = objFolder2.ParseName("Quest Of Graal.url")

Set objShortcut20 = objFolderItem20.GetLink

objShortcut20.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Graal.ico", 0




Set objFolderItem21 = objFolder2.ParseName("Magical Pet Swap.url")

Set objShortcut21 = objFolderItem21.GetLink

objShortcut21.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Pet Swap.ico", 0




Set objFolderItem22 = objFolder2.ParseName("Quick, Draw!.url")

Set objShortcut22 = objFolderItem22.GetLink

objShortcut22.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Quick Draw.ico", 0




Set objFolderItem23 = objFolder2.ParseName("Itch.io.url")

Set objShortcut23 = objFolderItem23.GetLink

objShortcut23.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Itchio.ico", 0




'Podcasts folder ###############################################################################################


'Crime & Drama folder

Set objFolderItem30 = objFolder3.ParseName("Crimetown.url")

Set objShortcut30 = objFolderItem30.GetLink

objShortcut30.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Podcasts.ico", 0




Set objFolderItem31 = objFolder3.ParseName("First Day Back.url")

Set objShortcut31 = objFolderItem31.GetLink

objShortcut31.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Podcasts.ico", 0




Set objFolderItem32 = objFolder3.ParseName("Homecoming.url")

Set objShortcut32 = objFolderItem32.GetLink

objShortcut32.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Podcasts.ico", 0




Set objFolderItem33 = objFolder3.ParseName("S-Town Podcast.url")

Set objShortcut33 = objFolderItem33.GetLink

objShortcut33.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Podcasts.ico", 0


'Politics folder

Set objFolderItem40 = objFolder4.ParseName("NPR Morning Edition.url")

Set objShortcut40 = objFolderItem40.GetLink

objShortcut40.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Podcasts.ico", 0




Set objFolderItem41 = objFolder4.ParseName("Pod Save America.url")

Set objShortcut41 = objFolderItem41.GetLink

objShortcut41.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Podcasts.ico", 0




Set objFolderItem42 = objFolder4.ParseName("The Daily.url")

Set objShortcut42 = objFolderItem42.GetLink

objShortcut42.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Podcasts.ico", 0


'Science & Technology folder

Set objFolderItem50 = objFolder5.ParseName("TED Talks Daily.url")

Set objShortcut50 = objFolderItem50.GetLink

objShortcut50.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Podcasts.ico", 0




Set objFolderItem51 = objFolder5.ParseName("This Is Only A Test.url")

Set objShortcut51 = objFolderItem51.GetLink

objShortcut51.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Podcasts.ico", 0


'Sex & Psychology folder

Set objFolderItem60 = objFolder6.ParseName("Food 4 Thot.url")

Set objShortcut60 = objFolderItem60.GetLink

objShortcut60.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Podcasts.ico", 0




Set objFolderItem61 = objFolder6.ParseName("How to Be a Girl.url")

Set objShortcut61 = objFolderItem61.GetLink

objShortcut61.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Podcasts.ico", 0




Set objFolderItem63 = objFolder6.ParseName("Terrible, Thanks for Asking.url")

Set objShortcut63 = objFolderItem63.GetLink

objShortcut63.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Podcasts.ico", 0




Set objFolderItem64 = objFolder6.ParseName("The Hilarious World of Depression.url")

Set objShortcut64 = objFolderItem64.GetLink

objShortcut64.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Podcasts.ico", 0


'Sports folder

Set objFolderItem70 = objFolder7.ParseName("Fantasy Football Podcast.url")

Set objShortcut70 = objFolderItem70.GetLink

objShortcut70.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Podcasts.ico", 0




Set objFolderItem71 = objFolder7.ParseName("The Ringer.url")

Set objShortcut71 = objFolderItem71.GetLink

objShortcut71.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Podcasts.ico", 0


'Talk Shows folder

Set objFolderItem80 = objFolder8.ParseName("2 Dope Queens.url")

Set objShortcut80 = objFolderItem80.GetLink

objShortcut80.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Podcasts.ico", 0




Set objFolderItem81 = objFolder8.ParseName("Gilmore Guys.url")

Set objShortcut81 = objFolderItem81.GetLink

objShortcut81.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Podcasts.ico", 0




Set objFolderItem82 = objFolder8.ParseName("The Read.url")

Set objShortcut82 = objFolderItem82.GetLink

objShortcut82.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Podcasts.ico", 0




'Shopping folder ###############################################################################################




Set objFolderItem100 = objFolder9.ParseName("Amazon.url")

Set objShortcut100 = objFolderItem100.GetLink

objShortcut100.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Amazon.ico", 0




Set objFolderItem101 = objFolder9.ParseName("Ebay.com.url")

Set objShortcut101 = objFolderItem101.GetLink

objShortcut101.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Ebay.ico", 0




Set objFolderItem102 = objFolder9.ParseName("Etsy.url")

Set objShortcut102 = objFolderItem102.GetLink

objShortcut102.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Etsy.ico", 0




Set objFolderItem103 = objFolder9.ParseName("Newegg.url")

Set objShortcut103 = objFolderItem103.GetLink

objShortcut103.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Newegg.ico", 0




Set objFolderItem104 = objFolder9.ParseName("Steam.url")

Set objShortcut104 = objFolderItem104.GetLink

objShortcut104.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Steam.ico", 0




Set objFolderItem105 = objFolder9.ParseName("Walmart.com.url")

Set objShortcut105 = objFolderItem105.GetLink

objShortcut105.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Walmart.ico", 0




'Online tools folder ###############################################################################################




Set objFolderItem110 = objFolder10.ParseName("CloudConvert.url")

Set objShortcut110 = objFolderItem110.GetLink

objShortcut110.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\CloudConvert.ico", 0




Set objFolderItem111 = objFolder10.ParseName("Dictionary.com.url")

Set objShortcut111 = objFolderItem111.GetLink

objShortcut111.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Dictionary.ico", 0




Set objFolderItem112 = objFolder10.ParseName("DropBox.url")

Set objShortcut112 = objFolderItem112.GetLink

objShortcut112.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\DropBox.ico", 0




Set objFolderItem113 = objFolder10.ParseName("Google Drive.url")

Set objShortcut113 = objFolderItem113.GetLink

objShortcut113.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Google Drive.ico", 0




Set objFolderItem114 = objFolder10.ParseName("RTINGS.com.url")

Set objShortcut114 = objFolderItem114.GetLink

objShortcut114.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\RTINGS.ico", 0




Set objFolderItem115 = objFolder10.ParseName("PCPartPicker.url")

Set objShortcut115 = objFolderItem115.GetLink

objShortcut115.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\PCPartPicker.ico", 0




Set objFolderItem116 = objFolder10.ParseName("ReviewMeta.url")

Set objShortcut116 = objFolderItem116.GetLink

objShortcut116.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\ReviewMeta.ico", 0




Set objFolderItem117 = objFolder10.ParseName("Thesaurus.com.url")

Set objShortcut117 = objFolderItem117.GetLink

objShortcut117.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Thesaurus.ico", 0




Set objFolderItem118 = objFolder10.ParseName("Urban Dictionary.url")

Set objShortcut118 = objFolderItem118.GetLink

objShortcut118.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Urban Dictionary.ico", 0




Set objFolderItem119 = objFolder10.ParseName("WolframAlpha.url")

Set objShortcut119 = objFolderItem119.GetLink

objShortcut119.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\WolframAlpha.ico", 0




'Diagnostic folder ###############################################################################################




Set objFolderItem120 = objFolder11.ParseName("Bottleneck Calculator.url")

Set objShortcut120 = objFolderItem120.GetLink

objShortcut120.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Hammer.ico", 0




Set objFolderItem121 = objFolder11.ParseName("DPI Calculator.url")

Set objShortcut121 = objFolderItem121.GetLink

objShortcut121.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Hammer.ico", 0




Set objFolderItem122 = objFolder11.ParseName("Mouse Rate Checker.url")

Set objShortcut122 = objFolderItem122.GetLink

objShortcut122.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Hammer.ico", 0




Set objFolderItem123 = objFolder11.ParseName("UFO Test.url")

Set objShortcut123 = objFolderItem123.GetLink

objShortcut123.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Hammer.ico", 0




Set objFolderItem124 = objFolder11.ParseName("VirusTotal by Google.url")

Set objShortcut124 = objFolderItem124.GetLink

objShortcut124.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\Hammer.ico", 0




'Far-Left folder ###############################################################################################




Set objFolderItem130 = objFolder12.ParseName("CounterPunch.url")

Set objShortcut130 = objFolderItem130.GetLink

objShortcut130.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\News.ico", 0




Set objFolderItem131 = objFolder12.ParseName("It's Going Down.url")

Set objShortcut131 = objFolderItem131.GetLink

objShortcut131.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\News.ico", 0




Set objFolderItem132 = objFolder12.ParseName("Truthout.url")

Set objShortcut132 = objFolderItem132.GetLink

objShortcut132.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\News.ico", 0




'Far-Right folder ###############################################################################################




Set objFolderItem140 = objFolder13.ParseName("Breitbart.url")

Set objShortcut140 = objFolderItem140.GetLink

objShortcut140.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\News.ico", 0




Set objFolderItem141 = objFolder13.ParseName("Drudge Report.url")

Set objShortcut141 = objFolderItem141.GetLink

objShortcut141.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\News.ico", 0




Set objFolderItem142 = objFolder13.ParseName("TheBlaze.url")

Set objShortcut142 = objFolderItem142.GetLink

objShortcut142.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\News.ico", 0




'International folder ###############################################################################################




Set objFolderItem150 = objFolder14.ParseName("BBC News.url")

Set objShortcut150 = objFolderItem150.GetLink

objShortcut150.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\News.ico", 0




Set objFolderItem151 = objFolder14.ParseName("The Guardian.url")

Set objShortcut151 = objFolderItem151.GetLink

objShortcut151.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\News.ico", 0




Set objFolderItem152 = objFolder14.ParseName("Yahoo World News.url")

Set objShortcut152 = objFolderItem152.GetLink

objShortcut152.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\News.ico", 0




'US Conservative folder ###############################################################################################




Set objFolderItem160 = objFolder15.ParseName("Fox News.url")

Set objShortcut160 = objFolderItem160.GetLink

objShortcut160.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\News.ico", 0




Set objFolderItem161 = objFolder15.ParseName("National Review.url")

Set objShortcut161 = objFolderItem161.GetLink

objShortcut161.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\News.ico", 0




Set objFolderItem162 = objFolder15.ParseName("The Economist.url")

Set objShortcut162 = objFolderItem162.GetLink

objShortcut162.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\News.ico", 0




'US Democrat folder ###############################################################################################




Set objFolderItem170 = objFolder16.ParseName("The Atlantic.url")

Set objShortcut170 = objFolderItem170.GetLink

objShortcut170.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\News.ico", 0




Set objFolderItem171 = objFolder16.ParseName("The New York Times.url")

Set objShortcut171 = objFolderItem171.GetLink

objShortcut171.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\News.ico", 0




Set objFolderItem172 = objFolder16.ParseName("Washington Post.url")

Set objShortcut172 = objFolderItem172.GetLink

objShortcut172.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\News.ico", 0




'US Moderate folder ###############################################################################################




Set objFolderItem180 = objFolder17.ParseName("NPR National Public Radio.url")

Set objShortcut180 = objFolderItem180.GetLink

objShortcut180.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\News.ico", 0




Set objFolderItem181 = objFolder17.ParseName("PBS NewsHour.url")

Set objShortcut181 = objFolderItem181.GetLink

objShortcut181.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\News.ico", 0




Set objFolderItem182 = objFolder17.ParseName("Reuters Politics.url")

Set objShortcut182 = objFolderItem182.GetLink

objShortcut182.SetIconLocation arg & "Droptop\@Resources\PresetIcons\Color\News.ico", 0







objShortcut1.Save

objShortcut2.Save

objShortcut3.Save

objShortcut4.Save

objShortcut5.Save

objShortcut6.Save

objShortcut7.Save

objShortcut8.Save

objShortcut9.Save

objShortcut10.Save

objShortcut11.Save




objShortcut20.Save

objShortcut21.Save

objShortcut22.Save

objShortcut23.Save



objShortcut30.Save

objShortcut31.Save

objShortcut32.Save

objShortcut33.Save




objShortcut40.Save

objShortcut41.Save

objShortcut42.Save




objShortcut50.Save

objShortcut51.Save




objShortcut60.Save

objShortcut61.Save

objShortcut63.Save

objShortcut64.Save




objShortcut70.Save

objShortcut71.Save




objShortcut80.Save

objShortcut81.Save

objShortcut82.Save




objShortcut100.Save

objShortcut101.Save

objShortcut102.Save

objShortcut103.Save

objShortcut104.Save

objShortcut105.Save




objShortcut110.Save

objShortcut111.Save

objShortcut112.Save

objShortcut113.Save

objShortcut114.Save

objShortcut115.Save

objShortcut116.Save

objShortcut117.Save

objShortcut118.Save

objShortcut119.Save




objShortcut120.Save

objShortcut121.Save

objShortcut122.Save

objShortcut123.Save

objShortcut124.Save




objShortcut130.Save

objShortcut131.Save

objShortcut132.Save




objShortcut140.Save

objShortcut141.Save

objShortcut142.Save




objShortcut150.Save

objShortcut151.Save

objShortcut152.Save




objShortcut160.Save

objShortcut161.Save

objShortcut162.Save




objShortcut170.Save

objShortcut171.Save

objShortcut172.Save




objShortcut180.Save

objShortcut181.Save

objShortcut182.Save