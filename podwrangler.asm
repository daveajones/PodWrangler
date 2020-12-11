;+----------------------------------------------------------------------------+
;|  Title: PodWrangler      Function: Keeps an eye on your favourite podcasts
;|  Source: MASM32          License: None - Just some credit if copied
;|  Platform: Win32         Version: <see .rc file>
;|  Author: Dave Jones      
;+----------------------------------------------------------------------------+

;+----------------------------------------------------------------------------+
;|  Assembler Directives:
.486
.model  flat,stdcall
option  casemap:none
;|
;+----------------------------------------------------------------------------+

;+----------------------------------------------------------------------------+
;|  Function Prototypes:
WinMain                 proto   :DWORD,:DWORD,:DWORD,:DWORD
CheckMultiInstance      proto   :DWORD,:DWORD,:DWORD,:DWORD
GetAppTitle             proto   :DWORD,:DWORD,:DWORD,:DWORD
ClearBuffer             proto   :DWORD,:DWORD
CopyBuffer              proto   :DWORD,:DWORD,:DWORD
ShutdownApp             proto   :DWORD
GetHttpFile             proto   :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetFileName             proto   :DWORD,:DWORD,:DWORD
GetUrlParts             proto   :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetNewestMediaUrl       proto   :DWORD,:DWORD,:DWORD
GetFeedTitle            proto   :DWORD,:DWORD,:DWORD,:DWORD
GetMediaFile            proto   :DWORD
ProgressBarWndproc      proto   :DWORD,:DWORD,:DWORD,:DWORD
CheckDownloadHistory    proto   :DWORD,:DWORD,:DWORD,:DWORD
AddDownloadHistory      proto   :DWORD,:DWORD,:DWORD,:DWORD
CheckForUpdate          proto   :DWORD
Install                 proto   :DWORD,:DWORD,:DWORD,:DWORD
Uninstall               proto   :DWORD,:DWORD,:DWORD
GetUpgradeFile          proto   :DWORD
GetNewestVersionInfo    proto   :DWORD,:DWORD,:DWORD
EnableAutoRun           proto
EnablePcastHandler      proto
DisableAutoRun          proto 
SetMainWindowPosition   proto   :DWORD
ShowFeedListWindow      proto   :DWORD,:DWORD
HideFeedListWindow      proto   :DWORD,:DWORD
AddFeed                 proto   :DWORD,:DWORD,:DWORD
DelFeed                 proto   :DWORD,:DWORD,:DWORD
ShowToast               proto   :DWORD
HoursToMicros           proto   :DWORD
ListViewWndProc         proto   :DWORD,:DWORD,:DWORD,:DWORD
SetStorageDir           proto   :DWORD,:DWORD
SetFeedFilter           proto   :DWORD,:DWORD
ParsePcastFile          proto   :DWORD,:DWORD,:DWORD,:DWORD
GetBitmapDC             proto   :DWORD,:DWORD,:DWORD,:DWORD
RaiseToast              proto   :DWORD
LowerToast              proto   :DWORD
StartupActions          proto   :DWORD
ButtonWndProc           proto   :DWORD,:DWORD,:DWORD,:DWORD
ShowError               proto   :DWORD,:DWORD
FindChar				proto	:DWORD,:DWORD,:DWORD
SleepManager			proto	:DWORD
;|
;+----------------------------------------------------------------------------+

;+----------------------------------------------------------------------------+
;|  Includes:
;|      Headers:
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\userenv.inc
include \masm32\include\kernel32.inc
include \masm32\include\comdlg32.inc
include \masm32\include\wsock32.inc
include \masm32\include\version.inc
include \masm32\include\wininet.inc
include \masm32\include\masm32.inc
include \masm32\include\comctl32.inc
include \masm32\include\gdi32.inc
include \masm32\include\shell32.inc
include \masm32\include\winmm.inc
include \masm32\include\advapi32.inc
include \masm32\include\shlwapi.inc
include strsafe.inc
;|
;|      Libraries:
includelib \masm32\lib\user32.lib
includelib \masm32\lib\userenv.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\comdlg32.lib
includelib \masm32\lib\wsock32.lib
includelib \masm32\lib\version.lib
includelib \masm32\lib\wininet.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\comctl32.lib
includelib \masm32\lib\gdi32.lib
includelib \masm32\lib\shell32.lib
includelib \masm32\lib\winmm.lib
includelib \masm32\lib\advapi32.lib
includelib \masm32\lib\shlwapi.lib
;|
;|      Project:

;|
;+----------------------------------------------------------------------------+

.const
;+----------------------------------------------------------------------------+
;|  Constants:
MAX_REDIRECTS           	EQU     6
WSOCK_VERSION           	EQU     02h
IDI_DBCASTLG            	EQU     5000
IDW_ROOSTER             	EQU     5002
IDB_BKGROUNDMD          	EQU     5005

IDB_BKGCORNERTL         	EQU     5006
IDB_BKGCORNERTR         	EQU     5007
IDB_BKGCORNERBL         	EQU     5008
IDB_BKGCORNERBR         	EQU     5009
IDB_BKGTOP              	EQU     5010
IDB_BKGBOT              	EQU     5011
IDB_BKGSIDEL            	EQU     5012
IDB_BKGSIDER            	EQU     5013

IDB_BTNCORNERTL         	EQU     5014
IDB_BTNCORNERTR         	EQU     5015
IDB_BTNCORNERBL         	EQU     5016
IDB_BTNCORNERBR         	EQU     5017
IDB_BTNTOP              	EQU     5018
IDB_BTNBOT              	EQU     5019
IDB_BTNSIDEL            	EQU     5020
IDB_BTNSIDER            	EQU     5021
IDB_BTNBACKGROUND       	EQU     5022

IDB_HOVERBTNCORNERTL		EQU     5023
IDB_HOVERBTNCORNERTR        EQU     5024
IDB_HOVERBTNCORNERBL        EQU     5025
IDB_HOVERBTNCORNERBR        EQU     5026
IDB_HOVERBTNTOP             EQU     5027
IDB_HOVERBTNBOT             EQU     5028
IDB_HOVERBTNSIDEL           EQU     5029
IDB_HOVERBTNSIDER           EQU     5030
IDB_HOVERBTNBACKGROUND      EQU     5031

IDB_DOWNBTNCORNERTL         EQU     5032
IDB_DOWNBTNCORNERTR         EQU     5033
IDB_DOWNBTNCORNERBL         EQU     5034
IDB_DOWNBTNCORNERBR         EQU     5035
IDB_DOWNBTNTOP              EQU     5036
IDB_DOWNBTNBOT              EQU     5037
IDB_DOWNBTNSIDEL            EQU     5038
IDB_DOWNBTNSIDER            EQU     5039
IDB_DOWNBTNBACKGROUND       EQU     5040

WM_TRAYNOTIFY           	EQU     WM_USER+101h
CM_EXIT                 	EQU     WM_USER+102h
CM_CHECKNOW             	EQU     WM_USER+103h
CM_EVOLVE               	EQU     WM_USER+104h
CM_GOINTERNET           	EQU     WM_USER+105h
CM_ABOUT                	EQU     WM_USER+106h
CM_AUTOSTART            	EQU     WM_USER+107h
CM_UNINSTALL            	EQU     WM_USER+108h
CM_MANAGEFEEDS          	EQU     WM_USER+109h
WM_TIMER_CHECK          	EQU     WM_USER+110h
CID_BTN_ADDFEED         	EQU     WM_USER+111h
CID_BTN_FINISH          	EQU     WM_USER+112h
CID_BTN_DELFEED         	EQU     WM_USER+113h
CID_UPD_CHANGEINTERVAL  	EQU     WM_USER+114h
CM_PAUSE                	EQU     WM_USER+115h
WM_TIMER_PAUSEREMINDER  	EQU     WM_USER+116h
CID_BTN_EDITFEED        	EQU     WM_USER+117h
CID_BTN_EDITSTORAGEDIR  	EQU     WM_USER+118h
CID_EDT_FEEDURL         	EQU     WM_USER+119h
CID_BTN_EDITFILTER      	EQU     WM_USER+120h
CID_BTN_CANCELOP        	EQU     WM_USER+121h
SHGFP_TYPE_CURRENT      	EQU     0
INVALID_FILE_SIZE       	EQU     0FFFFFFFFh
MAX_CHECK_INTERVAL      	EQU     24
MIN_CHECK_INTERVAL      	EQU     3
CSIDL_PROGRAM_FILES     	EQU     026h
CSIDL_APPDATA           	EQU     01ah
;|
;|  Structs:
TOAST_MESSAGE   STRUCT
    boolWordWrap    DWORD   ?
    pMessage        DWORD   ?
    pLinkText       DWORD   ?
    pLinkAction     DWORD   ?    
TOAST_MESSAGE   ENDS
;|
;|
;+----------------------------------------------------------------------------+

.data   ;|Data section begins
;+----------------------------------------------------------------------------+
;|  Globals:
;|      Initialized:
ClassName               	db  "PodWranglerMainClass",0
ClassToastName          	db  "PodWranglerToastClass",0
ClassProgressBar        	db  "msctls_progress32",0
ClassButton             	db  "PODWRANGLERBUTTON",0
ClassDefaultButton      	db  "BUTTON",0
ClassEdit               	db  "EDIT",0
ClassStatic             	db  "STATIC",0
ClassListView           	db  "SysListView32",0
AppName                 	db  "PodWrangler",0
ModuleName              	db  "podwrangler.exe",0
clswOpen                	db  "/open",0
MutexName               	db  "PODWRANGLERIsAlreadyRunning",0
boolDownloadInProgress  	dd  FALSE
dwAppVersion            	dd  0
Menu                    	db  "WinMenu",0
strErrorWinsock         	db  "Windows Sockets Error",0
strErrorGetMediaFile    	db  "Feed Retrieval Error",0
strErrorGetUpgradeFile  	db  "Upgrade Retrieval Error",0
strErrorDownloadInProgress  db  "A management operation or download is in progress.  Please try again when it's finished.",0
strErrorFileRead        	db  "File Read Error",0
strFeedUrl              	db  INTERNET_MAX_URL_LENGTH     dup(0)
dwFeedUrlSize           	dd  0
strWindowsDir           	db  MAX_PATH    dup(0)  ;##: This holds the run-time path to the WINDOWS directory.
strTempDir              	db  MAX_PATH    dup(0)  ;##: Holds the run-time path to the current profile's temp directory.
dwFeedFileBytesWritten  	dd  0
AppTitle                	db  128         dup(0)  ;##: This is the run-time application name.  It should be used instead of AppName.
strFileName             	db  128         dup(0)
strFeedPath             	db  MAX_PATH    dup(0)  ;##: This will hold the full run-time path to the local copy of the xml feed file.
strLogPath              	db  MAX_PATH    dup(0)  ;##: This will hold the full run-time path to the download log
strDesktopPath          	db  MAX_PATH    dup(0)  ;##: The full path to the desktop directory
strDirSep               	db  "\",0
strLog                  	db  "PodWrangler.log",0     ;##: This is the filename for the download log
strActiveTag            	db  "<active/>",0
strItemTagOpen          	db  "<item>",0
strItemTagClose         	db  "</item>",0
strLinkTagOpen          	db  "<link>",0
strLinkTagClose         	db  "</link>",0
strEnclosureTagOpen     	db  "<enclosure",0
strEnclosureTagClose    	db  "/>",0
strTitleTagOpen         	db  "<title>",0
strTitleTagClose        	db  "</title>",0
strHtmlLinkOpen         	db  "<link",0
strHtmlTagEnd           	db  ">",0
strHtmlUrl              	db  "url=",0
strHtmlHref             	db  "href=",0
strHtmlType             	db  "type=",0
strHtmlTitle            	db  "title=",0
strHtmlRel              	db  "rel=",0
strHtmlValAlternate     	db  "alternate",0
strMimeTypeRss          	db  "application/rss+xml",0
strDoubleQuotes         	db  022h,0
strDoubleQuotesWithSpace   	db  022h," ",0
strSingleQuotes         	db  027h,0
strDownloadPath         	db  MAX_PATH    dup(0)  ;##: This holds the full run-time path to the downloaded mp3 file
strMenuExit             	db  "Exit",0
strMenuManageFeeds      	db  "Manage Feed List...",0
strMenuAutoStart        	db  "Autostart with Windows",0
strMenuCheckNow         	db  "Check for New Shows",0
strMenuEvolve           	db  "Check for Upgrades",0
strMenuGoInternet       	db  "http://www.southernbread.org",0
strMenuAbout            	db  "About PodWrangler",0
strMenuUninstall        	db  "Uninstall",0
strMenuPause            	db  "Pause Checking",0
strMenuUnpause          	db  "Resume Checking",0
strOpen                 	db  "open",0
strWebsite              	db  "http://www.southernbread.org",0
strPcastExtension       	db  ".pcast",0
dwDownloadTimeout       	dd  3600000             ;##: Timeout for the download thread in milliseconds (3600000=1hour)
strLogFrameOpen         	db  "-[",0
strLogFrameClose        	db  "]",0dh,0ah,0
dwUpdateInterval        	dd  10800000            ;##: Timer fire interval in milliseconds (21600000=6 hours, 10800000=3 hours)
dwCheckInterval         	dd  3
dwMainWidth             	dd  200
dwMainHeight            	dd  60
strSDS                  	db  " - ",0
strEllipse              	db  "...",0
strFirstRun             	db  "This seems to be the first time you have run PodWrangler.  Would you like it to",0dh,0ah
                        	db  "run automatically each time you start Windows? (recommended)",0
strFirstRunInfo         	db  "The program runs in your system tray by your clock in the lower-right",0dh,0ah
                        	db  "corner of the screen.  Just right-click on it's icon for options.  It",0dh,0ah
                        	db  "will periodically check all your favourite feeds and download",0dh,0ah
                       		db  "any new item's to your desktop if it finds one.  Enjoy!",0
strMyPath               	db  MAX_PATH    dup(0)
strStartupFolderPath    	db  MAX_PATH    dup(0)
strErrMsg               	db  256         dup(0)
strPcastHandlerValue    	db  "Podwrangler.pcast",0
strHKCRPcastHandler     	db  "Podwrangler.pcast\shell\open\command",0
strHKCURun              	db  "Software\Microsoft\Windows\CurrentVersion\Run",0
strHKLMApp              	db  "Software\DaveJones\PodWrangler",0
strHKLMFeeds            	db  "Software\DaveJones\PodWrangler\FeedUrls",0
strHKLMStorageDirs      	db  "Software\DaveJones\PodWrangler\StorageDirs",0
strHKLMFilters          	db  "Software\DaveJones\PodWrangler\Filters",0
strStorageDirValue      	db  "Storage Dir",0
strFeedUrlValue         	db  "FeedUrl",0
strRunValue             	db  "PodWrangler",0
strCheckIntervalValue   	db  "CheckInterval",0
strHelpAbout            	db  "Name: PodWrangler ",0A9h," - Podcast Downloader",0dh,0ah
                        	db  "Author: Dave Jones",0dh,0ah
                        	db  "Homepage: http://www.southernbread.org",0dh,0ah
                        	db  "Language: 100% Pure Assembly Language",0dh,0ah,0dh,0ah
                        	db  "Function: ",0dh,0ah
                        	db  "Maintains a list of podcast feeds and periodically",0dh,0ah
                        	db  "checks them for new items and downloads any new",0dh,0ah
                        	db  "items it finds since the last check.",0
boolManualCheck        		db  FALSE
strAlertNoNewDownload   	db  "Sorry, there were no new items to download.",0
strAlertSoft404         	db  "The feed was updated but the file referenced by the feed was not found.  This "
                        	db  "is usually self correcting after a short while.",0
strTaskbarRestart       	db  "TaskbarCreated",0
strEvolveCheckUrl       	db  "http://www.southernbread.org/podwrangler.xml",0
strStart                	db  "start",0
strCDrive               	db  "c:\",0
dwRegSz                 	dd  REG_SZ
dwRegDw                 	dd  REG_DWORD
strChooseDirectory      	db  "Where should we save this podcast's files...",0
strTmpNewDownloadDir    	db  022h,"%s",022h," podcasts will now be saved in ",022h,"%s",022h,0
strNotifyMessage        	db  512                         dup(0)
strUrlToGet             	db  INTERNET_MAX_URL_LENGTH     dup(0)
strBadUrlToGet          	db  INTERNET_MAX_URL_LENGTH     dup(0)
fontTrebuchet           	db  "Trebuchet MS",0  
strCurrentlyChecking    	db  255                         dup(0)
strUninstallConfirm     	db  "Are you sure you want to uninstall PodWrangler?",0
strFeedUrlLabel         	db  "Feed Url:",0
strErrNoFeedsFound      	db  "It doesn't appear that you have any feeds defined.  You can add some "
                        	db  "from the Manage Feeds option on the menu.  I added one for you to start with.",0dh,0ah,0dh,0ah
                        	db  "Also, don't forget to check for updates occasionally "
                        	db  "since new versions are released often.",0
strNoNewVersionFound    	db  "No newer version of PodWrangler was found.",0
strChangeIntervalLabel  	db  "Check Interval (hrs):",0
boolPaused              	dd  FALSE
dwTimerChecksCount      	dd  0
dwPauseReminderInterval 	dd  86400000    ;(86400000=24 hrs.)
strPauseReminder        	db  "PodWrangler has been paused for 24 hours.  This is just a "
                        	db  "reminder in case you forgot.  To unpause PodWrangler just "
                        	db  "go to the menu and click",022h,"Resume Checking",022h,".",0
strDefaultFilter        	db  ".mp3",0
boolPcastFile           	dd  FALSE
strPercentOne           	db  "%1",0
strBadUrlSuffix         	db  "s404-detect",0
strErrorFeed404         	db  "PodWrangler:",0dh,0ah
                        	db  "There was an error downloading the RSS feed for the feed listed in the caption of",0dh,0ah
                        	db  "this message.  Please check it to make sure it is correct and hasn't changed.",0
strTemplateErrorCode    	db  "%d",0
strErrorCode            	db  255         dup(0)   
strBtnCancelOperation   	db  "X",0          
hThreadCurrentOp        	dd  0
boolCancelDownload      	dd  FALSE
strStandToReasonPodcast		db	"http://www.str.org/podcast/weekly/rss.xml",0        
;|
;+----------------------------------------------+

.data?
;+----------------------------------------------+
;|      Uninitialized:
wctoast                 	WNDCLASSEX          <>
hInstance               	HINSTANCE           ?
CommandLine             	LPSTR               ?
hwndProgressBar         	HWND                ?
dwThreadId              	DWORD               ?
hThread                 	DWORD               ?
pWndprocProgressBar     	DWORD               ?
debugBuffer             	BYTE    255         dup(?)
nid                     	NOTIFYICONDATA      <>
hTrayIcon               	DWORD               ?
hContextMenu            	DWORD               ?
keyHKCURun              	DWORD               ?
dwTaskbarRestart        	DWORD               ?
hwndLVFeeds             	DWORD               ?
hwndBtnAddFeeds         	DWORD               ?
hwndBtnFinish           	DWORD               ?
hwndBtnDelFeeds         	DWORD               ?
hwndEdtFeedUrl          	DWORD               ?
hwndStcTitleBar         	DWORD               ?
systime                 	SYSTEMTIME          <>
dwNewDownloads          	DWORD               ?
hwndStcToastTitleBar    	DWORD               ?
hwndStcToastMessage     	DWORD               ?
hwndStcFeedUrlLabel     	DWORD               ?
hFont12                 	DWORD               ?
hFont14                 	DWORD               ?
hFont16                 	DWORD               ?
hFont18                 	DWORD               ?
strAlertNewDownload     	BYTE    512         dup(?)
dwToastThreadId         	DWORD               ?
hwndUpdChangeInterval   	DWORD               ?
hwndEdtChangeInterval   	DWORD               ?
hwndStcChangeIntervalLabel  DWORD           ?
pWndprocListView        	DWORD               ?
pWndprocButtons         	DWORD               ?
hwndBtnEditFeeds        	DWORD               ?
hwndBtnEditStorageDir   	DWORD               ?
hwndBtnEditFilter       	DWORD               ?
hwndBtnCancelOperation  	DWORD               ?
strToastMessage         	BYTE    255         dup(?)
strPcastFilePath        	BYTE    MAX_PATH    dup(?)
pStartCLArg             	DWORD               ?
pEndCLArg               	DWORD               ?
dwCLArgLength           	DWORD               ?
strPcastFeedUrl         	BYTE    INTERNET_MAX_URL_LENGTH     dup(?)
hBrshBackground         	DWORD               ?
hBmpBkgCornerTL         	DWORD               ?
hBmpBkgCornerTR         	DWORD               ?
hBmpBkgCornerBL         	DWORD               ?
hBmpBkgCornerBR         	DWORD               ?
hBmpBkgTop              	DWORD               ?
hBmpBkgBot              	DWORD               ?
hBmpBkgSideL            	DWORD               ?
hBmpBkgSideR            	DWORD               ?
hDCBkgCornerTL          	DWORD               ?
hDCBkgCornerTR          	DWORD               ?
hDCBkgCornerBL          	DWORD               ?
hDCBkgCornerBR          	DWORD               ?
hDCBkgTop               	DWORD               ?
hDCBkgBot               	DWORD               ?
hDCBkgSideL             	DWORD               ?
hDCBkgSideR             	DWORD               ?
hBmpBtnCornerTL         	DWORD               ?
hBmpBtnCornerTR         	DWORD               ?
hBmpBtnCornerBL         	DWORD               ?
hBmpBtnCornerBR         	DWORD               ?
hBmpBtnTop              	DWORD               ?
hBmpBtnBot              	DWORD               ?
hBmpBtnSideL            	DWORD               ?
hBmpBtnSideR            	DWORD               ?
hBmpBtnBackground       	DWORD               ?
hDCBtnCornerTL          	DWORD               ?
hDCBtnCornerTR          	DWORD               ?
hDCBtnCornerBL          	DWORD               ?
hDCBtnCornerBR          	DWORD               ?
hDCBtnTop               	DWORD               ?
hDCBtnBot               	DWORD               ?
hDCBtnSideL             	DWORD               ?
hDCBtnSideR             	DWORD               ?
hBmpHoverBtnCornerTL    	DWORD               ?
hBmpHoverBtnCornerTR    	DWORD               ?
hBmpHoverBtnCornerBL    	DWORD               ?
hBmpHoverBtnCornerBR    	DWORD               ?
hBmpHoverBtnTop         	DWORD               ?
hBmpHoverBtnBot         	DWORD               ?
hBmpHoverBtnSideL       	DWORD               ?
hBmpHoverBtnSideR       	DWORD               ?
hBmpHoverBtnBackground  	DWORD               ?
hDCHoverBtnCornerTL     	DWORD               ?
hDCHoverBtnCornerTR     	DWORD               ?
hDCHoverBtnCornerBL     	DWORD               ?
hDCHoverBtnCornerBR     	DWORD               ?
hDCHoverBtnTop          	DWORD               ?
hDCHoverBtnBot          	DWORD               ?
hDCHoverBtnSideL        	DWORD               ?
hDCHoverBtnSideR        	DWORD               ?
hBmpDownBtnCornerTL     	DWORD               ?
hBmpDownBtnCornerTR     	DWORD               ?
hBmpDownBtnCornerBL     	DWORD               ?
hBmpDownBtnCornerBR     	DWORD               ?
hBmpDownBtnTop          	DWORD               ?
hBmpDownBtnBot          	DWORD               ?
hBmpDownBtnSideL        	DWORD               ?
hBmpDownBtnSideR        	DWORD               ?
hBmpDownBtnBackground   	DWORD               ?
hDCDownBtnCornerTL      	DWORD               ?
hDCDownBtnCornerTR      	DWORD               ?
hDCDownBtnCornerBL      	DWORD               ?
hDCDownBtnCornerBR      	DWORD               ?
hDCDownBtnTop           	DWORD               ?
hDCDownBtnBot           	DWORD               ?
hDCDownBtnSideL         	DWORD               ?
hDCDownBtnSideR         	DWORD               ?
strHttpHdrUserAgent     	BYTE    255         dup(?)
dwFeedUrlLength         	DWORD               ?
hwndButtonDown          	DWORD               ?
osv                     	OSVERSIONINFO       <>
dwHKEY_BRANCH				DWORD               ?
;|
;+----------------------------------------------------------------------------+




.code   ;|Code section begins
;+----------------------------------------------------------------------------+
;|  Startup:
start:
    invoke  GetModuleHandle, NULL
    mov     hInstance, eax

    ;##: Do any pre-run stuff
    ;;;| Get OS version info
    mov     osv.dwOSVersionInfoSize, SIZEOF osv
    invoke  GetVersionEx, ADDR osv
    .IF (osv.dwMajorVersion>=6)
        mov     dwHKEY_BRANCH, HKEY_CURRENT_USER
        invoke  SHGetSpecialFolderPath, NULL, ADDR strWindowsDir, CSIDL_APPDATA, 0 
        invoke  PathAddBackslash, ADDR strWindowsDir
        invoke  StringCbCat, ADDR strWindowsDir, SIZEOF strWindowsDir, ADDR AppName
        invoke  CreateDirectory, ADDR strWindowsDir, NULL         
    .ELSE
        mov     dwHKEY_BRANCH, HKEY_LOCAL_MACHINE
        invoke  GetWindowsDirectory, ADDR strWindowsDir, MAX_PATH
    .ENDIF
    
    invoke  StringCbCopy, ADDR strLogPath, SIZEOF strLogPath, ADDR strWindowsDir
    invoke  PathAddBackslash, ADDR strLogPath
    invoke  StringCbCat, ADDR strLogPath, SIZEOF strLogPath, ADDR strLog
    
    invoke  SHGetSpecialFolderPath, NULL, ADDR strDesktopPath, CSIDL_DESKTOPDIRECTORY, 0 
    invoke  PathAddBackslash, ADDR strDesktopPath
    
    invoke  GetTempPath, SIZEOF strTempDir, ADDR strTempDir
    invoke  GetModuleFileName, hInstance, ADDR strMyPath, SIZEOF strMyPath    
    ;##: --------------------

    invoke  GetCommandLine
    mov     CommandLine, eax

    ;##: Check if a .pcast file was specified on the command line
    invoke  InString, 1, CommandLine, ADDR clswOpen
    .IF(eax>0)
        add     eax, CommandLine
        add     eax, (SIZEOF clswOpen - 1)
        mov     pStartCLArg, eax
        mov     esi, eax
        lodsb        
        .IF(al==022h)   ;##: Check for quotes
            inc     pStartCLArg
        .ENDIF
        invoke  InString, 1, CommandLine, ADDR strPcastExtension
        .IF(eax>0)
            dec     eax     ;##: Because InString is 1-based
            add     eax, CommandLine
            add     eax, (SIZEOF strPcastExtension - 1)
            mov     pEndCLArg, eax
            sub     eax, pStartCLArg
            mov     dwCLArgLength, eax
            .IF(dwCLArgLength<MAX_PATH)
                mov     boolPcastFile, TRUE
                invoke  StringCbCopyN, ADDR strPcastFilePath, SIZEOF strPcastFilePath, pStartCLArg, dwCLArgLength
                invoke  ParsePcastFile, NULL, ADDR strPcastFilePath, ADDR strPcastFeedUrl, INTERNET_MAX_URL_LENGTH
                invoke  AddFeed, NULL, NULL, ADDR strPcastFeedUrl
                ;##: Check if we're already running
                invoke  CheckMultiInstance, hInstance, ADDR AppName, ADDR ClassName, ADDR MutexName
                .IF(eax!=TRUE)
                    xor     eax, eax
                    invoke  ExitProcess, eax
                .ENDIF                
            .ENDIF
        .ENDIF
        ;invoke  MessageBox, NULL, CommandLine, ADDR strPcastFilePath, MB_OK                        
    .ELSE
        ;##: Check if we're already running
        invoke  CheckMultiInstance, hInstance, ADDR AppName, ADDR ClassName, ADDR MutexName
        .IF(eax!=TRUE)
            xor     eax, eax
            invoke  ExitProcess, eax
        .ENDIF
    .ENDIF

    invoke  WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
    invoke  ExitProcess, eax
;|
;|
szErrWinsockStartup    db  "Error starting winsock, WSAStartup()",0
;|  WinMain:
WinMain proc    hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
    LOCAL   wc:WNDCLASSEX
    LOCAL   msg:MSG
    LOCAL   hwnd:HWND
    LOCAL   wsad:WSADATA
   

    ;##: Crank up winsock
    invoke  WSAStartup, WSOCK_VERSION, ADDR wsad
    .IF eax!=0
        invoke  MessageBox, NULL, ADDR szErrWinsockStartup, ADDR strErrorWinsock, MB_OK+MB_ICONSTOP
        mov     eax, 1
        ret
    .ENDIF               

    ;##: Class for toaster popup
    mov     wctoast.cbSize,SIZEOF WNDCLASSEX
    mov     wctoast.style, CS_HREDRAW or CS_VREDRAW
    mov     wctoast.lpfnWndProc, OFFSET WndProcToast
    mov     wctoast.cbClsExtra, NULL
    mov     wctoast.cbWndExtra, NULL
    push    hInst           ;| Push hInst on to the stack
    pop     wctoast.hInstance    ;| Pop it back off into hInstance
    mov     wctoast.hbrBackground, NULL    
    mov     wctoast.lpszMenuName, OFFSET Menu
    mov     wctoast.lpszClassName, OFFSET ClassToastName
    invoke  LoadImage, hInst, IDI_DBCASTLG, IMAGE_ICON, NULL, NULL, LR_DEFAULTCOLOR
    mov     wctoast.hIcon, eax
    invoke  LoadImage, hInst, IDI_DBCASTLG, IMAGE_ICON, NULL, NULL, LR_DEFAULTCOLOR    
    mov     wctoast.hIconSm, eax
    invoke  LoadCursor, NULL, IDC_ARROW
    mov     wctoast.hCursor, eax
    invoke  RegisterClassEx, ADDR wctoast    ;| Register the window class    

    ;##: Class for the main window
    mov     wc.cbSize,SIZEOF WNDCLASSEX
    mov     wc.style, CS_HREDRAW or CS_VREDRAW
    mov     wc.lpfnWndProc, OFFSET WndProc
    mov     wc.cbClsExtra, NULL
    mov     wc.cbWndExtra, NULL
    push    hInst           ;| Push hInst on to the stack
    pop     wc.hInstance    ;| Pop it back off into hInstance    
    mov     wc.hbrBackground, NULL
    mov     wc.lpszMenuName, OFFSET Menu
    mov     wc.lpszClassName, OFFSET ClassName
    invoke  LoadImage, hInst, IDI_DBCASTLG, IMAGE_ICON, NULL, NULL, LR_DEFAULTCOLOR
    mov     wc.hIcon, eax
    invoke  LoadImage, hInst, IDI_DBCASTLG, IMAGE_ICON, NULL, NULL, LR_DEFAULTCOLOR    
    mov     wc.hIconSm, eax
    mov     hTrayIcon, eax
    invoke  LoadCursor, NULL, IDC_ARROW
    mov     wc.hCursor, eax
    invoke  RegisterClassEx, ADDR wc    ;| Register the window class

    invoke  GetAppTitle, hInst, ADDR AppName, ADDR AppTitle, ADDR strHttpHdrUserAgent
    mov     dwAppVersion, eax

    invoke  CreateWindowEx, NULL, ADDR ClassName, ADDR AppTitle,\
            WS_POPUP,0,0,dwMainWidth,dwMainHeight,NULL,NULL,hInst,NULL
    mov     hwnd, eax

    ;##: Create a static control to fill in for the missing title bar
    mov     eax, dwMainWidth
    sub     eax, 32
    invoke  CreateWindowEx, WS_EX_TRANSPARENT, ADDR ClassStatic, ADDR AppTitle,\
            WS_CHILD+WS_VISIBLE+SS_LEFT,8,7,eax,20,hwnd,NULL,hInst,NULL
    mov     hwndStcTitleBar, eax
    invoke  CreateFont, 16, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, OEM_CHARSET, OUT_DEFAULT_PRECIS, \
            CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH+FF_DONTCARE, ADDR fontTrebuchet
    mov     hFont16, eax        
    invoke  SendMessage, hwndStcTitleBar, WM_SETFONT, hFont16, TRUE   

    ;##: Create a smaller font for other uses
    invoke  CreateFont, 14, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, OEM_CHARSET, OUT_DEFAULT_PRECIS, \
            CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH+FF_DONTCARE, ADDR fontTrebuchet
    mov     hFont12, eax    
    invoke  CreateFont, 14, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, OEM_CHARSET, OUT_DEFAULT_PRECIS, \
            CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH+FF_DONTCARE, ADDR fontTrebuchet
    mov     hFont14, eax

    ;##: Create a bigger font for other uses
    invoke  CreateFont, 18, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, OEM_CHARSET, OUT_DEFAULT_PRECIS, \
            CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH+FF_DONTCARE, ADDR fontTrebuchet
    mov     hFont18, eax

    invoke  InitCommonControls
   
    invoke  SetMainWindowPosition, hwnd

    ;##: Enter the main message loop
    .WHILE TRUE
        invoke  GetMessage, ADDR msg, NULL, 0, 0
        .BREAK .IF (!eax)
        invoke  TranslateMessage, ADDR msg
        invoke  DispatchMessage, ADDR msg
    .ENDW

    invoke  DeleteObject, hFont12
    invoke  DeleteObject, hFont14
    invoke  DeleteObject, hFont16
    invoke  DeleteObject, hFont18
    invoke  WSACleanup
    invoke  DestroyWindow, hwnd  
    invoke  UnregisterClass, OFFSET ClassName, OFFSET hInstance
    
    mov     eax, msg.wParam

    ret
WinMain endp    ;| End of WinMain procedure
;|
;|
szErrAddingFeed         db  "There was an error adding the feed.  Please check the address: AddFeed()",0
szErrDeletingFeed       db  "There was an error deleting the feed: DelFeed()",0
szErrNoFeedSelected     db  "You must select a feed from the list before you click delete.",0
szErrEditingStorageDir  db  "There was an error editing the storage location for this feed: SetStorageDir()",0
;|  WndProc:
WndProc proc    hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    LOCAL   rect:RECT
    LOCAL   cursPos:POINT
    LOCAL   hFile:DWORD
    LOCAL   strNewFeedUrl[INTERNET_MAX_URL_LENGTH]:BYTE
    LOCAL   dwNewFeedUrlSize:DWORD
    LOCAL   lvi:LV_ITEM
    LOCAL   strFeedName[255]:BYTE
    LOCAL   dwItemIndex:DWORD
    LOCAL   dwCheckIntervalSize:DWORD
    LOCAL   hDCWin:DWORD
    LOCAL   hDCCopy:DWORD
    LOCAL   hBmpCopy:DWORD
    LOCAL   hRegion:DWORD
    LOCAL   hFont:DWORD
    LOCAL   ps:PAINTSTRUCT
    LOCAL   hDCBackbuffer:DWORD
    LOCAL   hBmpBackbuffer:DWORD
    LOCAL   wc:WNDCLASSEX
    
    .IF uMsg==WM_CREATE
        ;##: Superclass the standard button class to make graphical buttons
        mov     wc.cbSize, SIZEOF WNDCLASSEX
        invoke  GetClassInfoEx, NULL, ADDR ClassDefaultButton, ADDR wc
        push    wc.lpfnWndProc
        pop     pWndprocButtons
        lea     eax, ButtonWndProc
        mov     wc.lpfnWndProc, eax
        lea     eax, ClassButton
        mov     wc.lpszClassName, eax
        push    hInstance
        pop     wc.hInstance
        invoke  RegisterClassEx, ADDR wc

        ;##: Load up the background bitmaps
        invoke  GetBitmapDC, ADDR hDCBkgTop, IDB_BKGTOP, ADDR hBmpBkgTop, hWnd
        invoke  GetBitmapDC, ADDR hDCBkgBot, IDB_BKGBOT, ADDR hBmpBkgBot, hWnd
        invoke  GetBitmapDC, ADDR hDCBkgSideR, IDB_BKGSIDER, ADDR hBmpBkgSideR, hWnd
        invoke  GetBitmapDC, ADDR hDCBkgSideL, IDB_BKGSIDEL, ADDR hBmpBkgSideL, hWnd
        invoke  GetBitmapDC, ADDR hDCBkgCornerTL, IDB_BKGCORNERTL, ADDR hBmpBkgCornerTL, hWnd
        invoke  GetBitmapDC, ADDR hDCBkgCornerTR, IDB_BKGCORNERTR, ADDR hBmpBkgCornerTR, hWnd
        invoke  GetBitmapDC, ADDR hDCBkgCornerBL, IDB_BKGCORNERBL, ADDR hBmpBkgCornerBL, hWnd
        invoke  GetBitmapDC, ADDR hDCBkgCornerBR, IDB_BKGCORNERBR, ADDR hBmpBkgCornerBR, hWnd

        ;##: Load up the standard button bitmaps
        invoke  GetBitmapDC, ADDR hDCBtnTop, IDB_BTNTOP, ADDR hBmpBtnTop, hWnd
        invoke  GetBitmapDC, ADDR hDCBtnBot, IDB_BTNBOT, ADDR hBmpBtnBot, hWnd
        invoke  GetBitmapDC, ADDR hDCBtnSideR, IDB_BTNSIDER, ADDR hBmpBtnSideR, hWnd
        invoke  GetBitmapDC, ADDR hDCBtnSideL, IDB_BTNSIDEL, ADDR hBmpBtnSideL, hWnd
        invoke  GetBitmapDC, ADDR hDCBtnCornerTL, IDB_BTNCORNERTL, ADDR hBmpBtnCornerTL, hWnd
        invoke  GetBitmapDC, ADDR hDCBtnCornerTR, IDB_BTNCORNERTR, ADDR hBmpBtnCornerTR, hWnd
        invoke  GetBitmapDC, ADDR hDCBtnCornerBL, IDB_BTNCORNERBL, ADDR hBmpBtnCornerBL, hWnd
        invoke  GetBitmapDC, ADDR hDCBtnCornerBR, IDB_BTNCORNERBR, ADDR hBmpBtnCornerBR, hWnd
        invoke  LoadBitmap, hInstance, IDB_BTNBACKGROUND 
        mov     hBmpBtnBackground, eax

        ;##: Load up the hover button bitmaps
        invoke  GetBitmapDC, ADDR hDCHoverBtnTop, IDB_HOVERBTNTOP, ADDR hBmpHoverBtnTop, hWnd
        invoke  GetBitmapDC, ADDR hDCHoverBtnBot, IDB_HOVERBTNBOT, ADDR hBmpHoverBtnBot, hWnd
        invoke  GetBitmapDC, ADDR hDCHoverBtnSideR, IDB_HOVERBTNSIDER, ADDR hBmpHoverBtnSideR, hWnd
        invoke  GetBitmapDC, ADDR hDCHoverBtnSideL, IDB_HOVERBTNSIDEL, ADDR hBmpHoverBtnSideL, hWnd
        invoke  GetBitmapDC, ADDR hDCHoverBtnCornerTL, IDB_HOVERBTNCORNERTL, ADDR hBmpHoverBtnCornerTL, hWnd
        invoke  GetBitmapDC, ADDR hDCHoverBtnCornerTR, IDB_HOVERBTNCORNERTR, ADDR hBmpHoverBtnCornerTR, hWnd
        invoke  GetBitmapDC, ADDR hDCHoverBtnCornerBL, IDB_HOVERBTNCORNERBL, ADDR hBmpHoverBtnCornerBL, hWnd
        invoke  GetBitmapDC, ADDR hDCHoverBtnCornerBR, IDB_HOVERBTNCORNERBR, ADDR hBmpHoverBtnCornerBR, hWnd
        invoke  LoadBitmap, hInstance, IDB_HOVERBTNBACKGROUND 
        mov     hBmpHoverBtnBackground, eax

        ;##: Load up the down button bitmaps
        invoke  GetBitmapDC, ADDR hDCDownBtnTop, IDB_DOWNBTNTOP, ADDR hBmpDownBtnTop, hWnd
        invoke  GetBitmapDC, ADDR hDCDownBtnBot, IDB_DOWNBTNBOT, ADDR hBmpDownBtnBot, hWnd
        invoke  GetBitmapDC, ADDR hDCDownBtnSideR, IDB_DOWNBTNSIDER, ADDR hBmpDownBtnSideR, hWnd
        invoke  GetBitmapDC, ADDR hDCDownBtnSideL, IDB_DOWNBTNSIDEL, ADDR hBmpDownBtnSideL, hWnd
        invoke  GetBitmapDC, ADDR hDCDownBtnCornerTL, IDB_DOWNBTNCORNERTL, ADDR hBmpDownBtnCornerTL, hWnd
        invoke  GetBitmapDC, ADDR hDCDownBtnCornerTR, IDB_DOWNBTNCORNERTR, ADDR hBmpDownBtnCornerTR, hWnd
        invoke  GetBitmapDC, ADDR hDCDownBtnCornerBL, IDB_DOWNBTNCORNERBL, ADDR hBmpDownBtnCornerBL, hWnd
        invoke  GetBitmapDC, ADDR hDCDownBtnCornerBR, IDB_DOWNBTNCORNERBR, ADDR hBmpDownBtnCornerBR, hWnd
        invoke  LoadBitmap, hInstance, IDB_DOWNBTNBACKGROUND 
        mov     hBmpDownBtnBackground, eax
        
        ;##: Create a brush for the background color
        invoke  CreateSolidBrush, 0ffeec1h
        mov     hBrshBackground, eax    

        ;##: Create the progress bar
        invoke  CreateWindowEx, WS_EX_CLIENTEDGE+WS_EX_TRANSPARENT, ADDR ClassProgressBar, NULL, \
                WS_VISIBLE+WS_CHILD+PBS_SMOOTH, 7, 25, 185, 23, \
                hWnd, NULL, hInstance, NULL
        mov     hwndProgressBar, eax
        invoke  SendMessage, hwndProgressBar, PBM_SETBARCOLOR, 0, 0
        invoke  SendMessage, hwndProgressBar, PBM_SETBKCOLOR, 0, 0ffeec1h

        ;##: Hook the progress bar's and frames' wndproc
        invoke  GetWindowLong, hwndProgressBar, GWL_WNDPROC
        mov     pWndprocProgressBar, eax
        invoke  SetWindowLong, hwndProgressBar, GWL_WNDPROC, ADDR ProgressBarWndproc

        ;##: Create a button that cancels the current operation
        invoke  CreateWindowEx, NULL, ADDR ClassButton, \               ;| Cancel operation button
                ADDR strBtnCancelOperation, WS_CHILD+WS_VISIBLE, 8, 7, 8, 8, \ 
                hWnd, CID_BTN_CANCELOP, hInstance, NULL
        mov     hwndBtnCancelOperation, eax
        invoke  SendMessage, eax, WM_SETFONT, hFont16, TRUE

        ;##: Create a tray icon
        mov     nid.cbSize, SIZEOF NOTIFYICONDATA                   ;Fill out a notifyicondata structure
        push    hWnd
        pop     nid.hwnd
        push    hTrayIcon           
        pop     nid.hIcon
        mov     nid.uID, WM_TRAYNOTIFY
        mov     nid.uFlags, NIF_ICON+NIF_MESSAGE+NIF_TIP
        mov     nid.uCallbackMessage, WM_TRAYNOTIFY
        invoke  StringCbCopy, ADDR nid.szTip, SIZEOF nid.szTip, ADDR AppTitle               ;Put the AppTitle address in the tool tip
        invoke  Shell_NotifyIcon, NIM_ADD, ADDR nid                                         ;Add an icon to the system tray 
        invoke  RegisterWindowMessage, ADDR strTaskbarRestart
        mov     dwTaskbarRestart, eax        

        ;##: Create a popup menu for the tray icon
        invoke  CreatePopupMenu
        mov     hContextMenu, eax
        invoke  AppendMenu, hContextMenu, MF_STRING, CM_MANAGEFEEDS, ADDR strMenuManageFeeds                                
        invoke  AppendMenu, hContextMenu, MF_STRING, CM_CHECKNOW, ADDR strMenuCheckNow
        invoke  AppendMenu, hContextMenu, MF_STRING, CM_PAUSE, ADDR strMenuPause
        invoke  AppendMenu, hContextMenu, MF_SEPARATOR, NULL, NULL        
        invoke  AppendMenu, hContextMenu, MF_STRING, CM_EVOLVE, ADDR strMenuEvolve
        invoke  AppendMenu, hContextMenu, MF_STRING, CM_AUTOSTART, ADDR strMenuAutoStart
        invoke  AppendMenu, hContextMenu, MF_STRING, CM_UNINSTALL, ADDR strMenuUninstall        
        invoke  AppendMenu, hContextMenu, MF_SEPARATOR, NULL, NULL
        invoke  AppendMenu, hContextMenu, MF_STRING, CM_GOINTERNET, ADDR strMenuGoInternet        
        invoke  AppendMenu, hContextMenu, MF_STRING, CM_ABOUT, ADDR strMenuAbout                                                        
        invoke  AppendMenu, hContextMenu, MF_STRING, CM_EXIT, ADDR strMenuExit

        ;##: Check if this is the first time the program has been run
        invoke  CreateFile, ADDR strLogPath, GENERIC_READ+GENERIC_WRITE, FILE_SHARE_READ, NULL, OPEN_EXISTING, NULL, NULL
        mov     hFile, eax
        .IF (eax==INVALID_HANDLE_VALUE)
            invoke  CreateFile, ADDR strLogPath, GENERIC_READ+GENERIC_WRITE, FILE_SHARE_READ, NULL, CREATE_ALWAYS, NULL, NULL
            mov     hFile, eax
            invoke  CloseHandle, hFile
            invoke	AddFeed, hWnd, NULL, ADDR strStandToReasonPodcast                    
            invoke  MessageBox, NULL, ADDR strFirstRun, ADDR AppName, MB_YESNO+MB_ICONINFORMATION
            .IF (eax==IDYES)
                invoke  EnablePcastHandler
                invoke  EnableAutoRun
                .IF (eax==0)
                    invoke  ShutdownApp, NULL
                    xor     eax, eax
                    ret
                .ENDIF            
            .ENDIF            
        .ELSE
            invoke  CloseHandle, hFile
        .ENDIF    

        ;##: See if there has been a timer interval specified in the registry
        mov     dwCheckIntervalSize, SIZEOF strCheckIntervalValue
        invoke  SHGetValue, dwHKEY_BRANCH, ADDR strHKLMApp, ADDR strCheckIntervalValue, ADDR dwRegDw,\
                ADDR dwCheckInterval, ADDR dwCheckIntervalSize
        .IF(eax==ERROR_SUCCESS)
            invoke  HoursToMicros, dwCheckInterval
            mov     dwUpdateInterval, eax
        .ENDIF
        
        ;##: Create the timer
        invoke  SetTimer, hWnd, WM_TIMER_CHECK, dwUpdateInterval, NULL

        ;##: Execute any asynchronous startup actions
        invoke  CreateThread, NULL, NULL, ADDR StartupActions, hWnd, NULL, ADDR dwThreadId
        mov     hThread, eax

    .ELSEIF uMsg==WM_TIMER
        .IF(wParam==WM_TIMER_CHECK)
            .IF((boolDownloadInProgress==FALSE) && (boolPaused==FALSE))                
                mov     boolManualCheck, FALSE
                invoke  CreateThread, NULL, NULL, ADDR CheckForUpdate, hWnd, NULL, ADDR dwThreadId
                mov     hThread, eax
                mov     hThreadCurrentOp, eax
            .ENDIF
        .ELSEIF(wParam==WM_TIMER_PAUSEREMINDER)
            invoke  CreateThread, NULL, NULL, ADDR ShowToast, ADDR strPauseReminder, NULL, ADDR dwToastThreadId
        .ENDIF

	.ELSEIF uMsg==WM_POWERBROADCAST	
		.IF((wParam==PBT_APMRESUMESTANDBY) || (wParam==PBT_APMRESUMESUSPEND) || (wParam==PBT_APMRESUMECRITICAL))
			mov		boolPaused, TRUE		
            invoke  CreateThread, NULL, NULL, ADDR SleepManager, 60000, NULL, ADDR dwThreadId			
		.ENDIF		
		.IF((wParam==PBT_APMSUSPEND) || (wParam==PBT_APMSTANDBY))
			mov		boolPaused, TRUE
		.ENDIF

    .ELSEIF uMsg==WM_LBUTTONDOWN
        invoke  ReleaseCapture
        invoke  SendMessage, hWnd, WM_NCLBUTTONDOWN, HTCAPTION, 0

    .ELSEIF uMsg==WM_TRAYNOTIFY
        .IF wParam==WM_TRAYNOTIFY
            .IF (lParam==WM_RBUTTONUP) || (lParam==WM_LBUTTONDOWN)  ;| Show the context menu
                invoke  SetForegroundWindow, hWnd   
                invoke  GetCursorPos, ADDR cursPos
                invoke  TrackPopupMenu, hContextMenu, TPM_RIGHTALIGN+TPM_LEFTBUTTON+TPM_RIGHTBUTTON,\
                        cursPos.x, cursPos.y, 0, hWnd, NULL
                invoke  PostMessage, hWnd, WM_NULL, 0, 0
            .ELSEIF (lParam==WM_LBUTTONDBLCLK)
                xor     eax, eax
                mov     ax, CM_MANAGEFEEDS
                invoke  PostMessage, hWnd, WM_COMMAND, eax, NULL 
            .ENDIF
        .ENDIF

    .ELSEIF uMsg==WM_SYSCOMMAND
        .IF (wParam==SC_CLOSE)
            xor     eax, eax
            ret
        .ELSE
            mov     eax, 1
            ret
        .ENDIF

    .ELSEIF uMsg==WM_COMMAND
        mov     eax, wParam
        .IF ax==CM_EXIT             ;| Exit command on context menu was chosen
            invoke  ShutdownApp, NULL
        .ELSEIF ax==CM_CHECKNOW     ;| Check now command on context menu was chosen
            .IF (boolDownloadInProgress==FALSE)                
                mov     boolManualCheck, TRUE
                invoke  CreateThread, NULL, NULL, ADDR CheckForUpdate, hWnd, NULL, ADDR dwThreadId
                mov     hThread, eax
                mov     hThreadCurrentOp, eax
            .ELSE
                invoke  MessageBox, hWnd, ADDR strErrorDownloadInProgress, ADDR AppTitle, MB_OK+MB_ICONWARNING
            .ENDIF
            ;##: Reset the timer.  We do this becuase a manual check indicates the user is ready for the file
            ;##: and that is a good indicator of when a check should be made so that now the timer fires
            ;##: nicely at this time each day.
            invoke  KillTimer, hWnd, WM_TIMER_CHECK            
            invoke  SetTimer, hWnd, WM_TIMER_CHECK, dwUpdateInterval, NULL            
        .ELSEIF ax==CM_GOINTERNET   ;| Go Internet command on context menu was chosen
            invoke  ShellExecute, hWnd, ADDR strOpen, ADDR strWebsite, NULL, NULL, SW_SHOW
        .ELSEIF ax==CM_ABOUT        ;| About option on the context menu was chosen
            invoke  MessageBox, hWnd, ADDR strHelpAbout, ADDR AppTitle, MB_OK+MB_ICONINFORMATION
        .ELSEIF ax==CM_EVOLVE
            .IF (boolDownloadInProgress==FALSE)
                mov     boolManualCheck, TRUE
                invoke  CreateThread, NULL, NULL, ADDR GetUpgradeFile, hWnd, NULL, ADDR dwThreadId
                mov     hThread, eax                
            .ELSE
                invoke  MessageBox, hWnd, ADDR strErrorDownloadInProgress, ADDR AppTitle, MB_OK+MB_ICONWARNING
            .ENDIF
        .ELSEIF ax==CM_AUTOSTART
            invoke  EnablePcastHandler
            invoke  EnableAutoRun
            .IF (eax==0)
                invoke  ShutdownApp, NULL
            .ENDIF
        .ELSEIF ax==CM_UNINSTALL
            invoke  MessageBox, NULL, ADDR strUninstallConfirm, ADDR AppTitle, MB_YESNO+MB_ICONWARNING
            .IF (eax==IDYES)
                invoke  DisableAutoRun
                .IF (eax==0)
                    invoke  Uninstall, NULL, ADDR strWindowsDir, ADDR strMyPath 
                    invoke  ShutdownApp, NULL
                    xor     eax, eax
                    ret
                .ENDIF            
            .ENDIF
        .ELSEIF ax==CM_MANAGEFEEDS
            .IF (boolDownloadInProgress==FALSE)        
                invoke  ShowFeedListWindow, hWnd, hwndProgressBar
            .ELSE
                invoke  MessageBox, hWnd, ADDR strErrorDownloadInProgress, ADDR AppTitle, MB_OK+MB_ICONWARNING
            .ENDIF
        .ELSEIF ax==CM_PAUSE
            .IF(boolPaused==FALSE)
                mov     boolPaused, TRUE
                invoke  ModifyMenu, hContextMenu, CM_PAUSE, MF_BYCOMMAND+MF_STRING, CM_PAUSE, ADDR strMenuUnpause            
                invoke  SetTimer, hWnd, WM_TIMER_PAUSEREMINDER, dwPauseReminderInterval, NULL
            .ELSE
                mov     boolPaused, FALSE
                invoke  ModifyMenu, hContextMenu, CM_PAUSE, MF_BYCOMMAND+MF_STRING, CM_PAUSE, ADDR strMenuPause
                invoke  KillTimer, hWnd, WM_TIMER_PAUSEREMINDER
                .IF(boolDownloadInProgress==FALSE)                
                    invoke  CreateThread, NULL, NULL, ADDR CheckForUpdate, hWnd, NULL, ADDR dwThreadId
                    mov     hThread, eax
                    mov     hThreadCurrentOp, eax
                .ENDIF                                
            .ENDIF                                            
        .ELSEIF eax==CID_BTN_FINISH
            invoke  SendMessage, hwndUpdChangeInterval, UDM_GETPOS, 0, 0
            mov     dwCheckInterval, eax
            invoke  HoursToMicros, dwCheckInterval
            mov     dwUpdateInterval, eax
            invoke  SHSetValue, dwHKEY_BRANCH, ADDR strHKLMApp, ADDR strCheckIntervalValue, REG_DWORD,\
                    ADDR dwCheckInterval, SIZEOF DWORD
            invoke  HideFeedListWindow, hWnd, hwndProgressBar
            ;##: Editing is finished so fire off another update check
            invoke  CreateThread, NULL, NULL, ADDR CheckForUpdate, hWnd, NULL, ADDR dwThreadId
            mov     hThread, eax
            mov     hThreadCurrentOp, eax
            ;##: Reset the timer to assume the new interval
            invoke  KillTimer, hWnd, WM_TIMER_CHECK            
            invoke  SetTimer, hWnd, WM_TIMER_CHECK, dwUpdateInterval, NULL                        
        .ELSEIF eax==CID_BTN_DELFEED
            invoke  SendMessage, hwndLVFeeds, LVM_GETNEXTITEM, -1, LVNI_ALL+LVNI_SELECTED
            mov     dwItemIndex, eax
            .IF(eax!=-1)
                mov     lvi.iSubItem, 0
                lea     edx, strFeedName
                mov     lvi.pszText, edx
                mov     lvi.cchTextMax, SIZEOF strFeedName
                invoke  SendMessage, hwndLVFeeds, LVM_GETITEMTEXT, dwItemIndex, ADDR lvi                
                invoke  DelFeed, hWnd, hwndLVFeeds, ADDR strFeedName
                .IF(eax==1)
                    invoke  MessageBox, hWnd, ADDR szErrDeletingFeed, ADDR AppTitle, MB_OK+MB_ICONSTOP
                .ELSE
                    invoke  HideFeedListWindow, hWnd, hwndProgressBar
                    invoke  ShowFeedListWindow, hWnd, hwndProgressBar
                .ENDIF 
            .ELSE
                invoke  MessageBox, hWnd, ADDR szErrNoFeedSelected, ADDR AppTitle, MB_OK+MB_ICONWARNING
            .ENDIF
        .ELSEIF eax==CID_BTN_ADDFEED
            invoke  GetWindowText, hwndEdtFeedUrl, ADDR strFeedUrl, SIZEOF strFeedUrl
            invoke  StringCbLength, ADDR strFeedUrl, SIZEOF strFeedUrl, ADDR dwFeedUrlLength
            .IF(dwFeedUrlLength==0)
                invoke  MessageBox, hWnd, ADDR szErrAddingFeed, ADDR AppTitle, MB_OK+MB_ICONSTOP
            .ELSE
                invoke  AddFeed, hWnd, hwndLVFeeds, ADDR strFeedUrl
                .IF(eax==1)
                    invoke  MessageBox, hWnd, ADDR szErrAddingFeed, ADDR AppTitle, MB_OK+MB_ICONSTOP
                .ELSE
                    invoke  HideFeedListWindow, hWnd, hwndProgressBar
                    invoke  ShowFeedListWindow, hWnd, hwndProgressBar
                .ENDIF
            .ENDIF
        .ELSEIF eax==CID_BTN_EDITFEED
            invoke  SendMessage, hwndLVFeeds, LVM_GETNEXTITEM, -1, LVNI_ALL+LVNI_SELECTED
            mov     dwItemIndex, eax
            .IF(eax!=-1)
                mov     lvi.iSubItem, 1
                lea     edx, strFeedName
                mov     lvi.pszText, edx
                mov     lvi.cchTextMax, SIZEOF strFeedName
                invoke  SendMessage, hwndLVFeeds, LVM_GETITEMTEXT, dwItemIndex, ADDR lvi                
                invoke  SetWindowText, hwndEdtFeedUrl, ADDR strFeedName
            .ELSE
                invoke  MessageBox, hWnd, ADDR szErrNoFeedSelected, ADDR AppTitle, MB_OK+MB_ICONWARNING
            .ENDIF
        .ELSEIF eax==CID_BTN_EDITSTORAGEDIR
            invoke  SendMessage, hwndLVFeeds, LVM_GETNEXTITEM, -1, LVNI_ALL+LVNI_SELECTED
            mov     dwItemIndex, eax
            .IF(eax!=-1)
                mov     lvi.iSubItem, 0
                lea     edx, strFeedName
                mov     lvi.pszText, edx
                mov     lvi.cchTextMax, SIZEOF strFeedName
                invoke  SendMessage, hwndLVFeeds, LVM_GETITEMTEXT, dwItemIndex, ADDR lvi                
                invoke  SetStorageDir, hWnd, ADDR strFeedName
                .IF(eax==0)
                    invoke  HideFeedListWindow, hWnd, hwndProgressBar
                    invoke  ShowFeedListWindow, hWnd, hwndProgressBar
                .ENDIF                 
            .ELSE
                invoke  MessageBox, hWnd, ADDR szErrNoFeedSelected, ADDR AppTitle, MB_OK+MB_ICONWARNING
            .ENDIF            
        .ELSEIF ax==CID_EDT_FEEDURL
            invoke  GetWindowTextLength, hwndEdtFeedUrl
            .IF(eax>0)
                invoke  EnableWindow, hwndBtnAddFeeds, TRUE
            .ELSE
                invoke  EnableWindow, hwndBtnAddFeeds, FALSE
            .ENDIF
        .ELSEIF ax==CID_BTN_EDITFILTER
            invoke  SendMessage, hwndLVFeeds, LVM_GETNEXTITEM, -1, LVNI_ALL+LVNI_SELECTED
            mov     dwItemIndex, eax
            .IF(eax!=-1)
                mov     lvi.iSubItem, 0
                lea     edx, strFeedName
                mov     lvi.pszText, edx
                mov     lvi.cchTextMax, SIZEOF strFeedName
                invoke  SendMessage, hwndLVFeeds, LVM_GETITEMTEXT, dwItemIndex, ADDR lvi                
                invoke  SetFeedFilter, hWnd, ADDR strFeedName
                .IF(eax==0)
                    invoke  HideFeedListWindow, hWnd, hwndProgressBar
                    invoke  ShowFeedListWindow, hWnd, hwndProgressBar
                .ENDIF                 
            .ELSE
                invoke  MessageBox, hWnd, ADDR szErrNoFeedSelected, ADDR AppTitle, MB_OK+MB_ICONWARNING
            .ENDIF
        .ELSEIF ax==CID_BTN_CANCELOP
            invoke  TerminateThread, hThreadCurrentOp, 0
            mov     boolCancelDownload, TRUE
            mov     boolDownloadInProgress, FALSE
            invoke  SetMainWindowPosition, hWnd
            invoke  ShowWindow, hWnd, SW_HIDE
        .ENDIF

    .ELSEIF uMsg==WM_CTLCOLORSTATIC
        invoke  SetTextColor,wParam,00131313h    ;TextColor
        invoke  SetBkMode,wParam,TRANSPARENT    ;Background of Text
        invoke  GetStockObject,NULL_BRUSH          ;BackgroundColor == there is no
        ret       

    .ELSEIF uMsg==WM_PAINT
        ;##: Check for an update region
        invoke  GetUpdateRect, hWnd, ADDR rect, TRUE
        .IF(eax==0)
            xor     eax, eax
            ret
        .ENDIF
        
        ;##: Setting the batch helps prevent flickering from the background erase
        invoke  GdiSetBatchLimit ,25

        ;##: Start the painting operation        
        invoke  BeginPaint, hWnd, ADDR ps

        ;##: Create a backbuffer
        invoke  GetDesktopWindow
        push    eax
        invoke  GetWindowDC, eax
        push    eax
        invoke  CreateCompatibleDC, eax
        mov     hDCBackbuffer, eax
        pop     eax
        invoke  CreateCompatibleBitmap, eax, rect.right, rect.bottom
        push    eax
        mov     hBmpBackbuffer, eax
        invoke  SelectObject, hDCBackbuffer, hBmpBackbuffer
        mov     hBmpBackbuffer, eax
        pop     eax
        pop     edx
        invoke  ReleaseDC, edx, eax

        ;##: Get the coordinates of the window
        invoke  GetClientRect, hWnd, ADDR rect
        invoke  FillRect, hDCBackbuffer, ADDR rect, hBrshBackground        

        ;##: Paint Top Row
        mov eax, rect.right
        mov ecx, 2
        xor edx, edx
        div ecx
        mov ebx, eax
        xor edi, edi
        .WHILE ebx != 0
            invoke BitBlt,hDCBackbuffer, edi,0,2,32,hDCBkgTop,0,0,SRCCOPY
            add edi, 2
            dec ebx
        .ENDW
        
        ;##: Paint Bottom Row
        mov eax, rect.right
        mov ecx, 2
        xor edx, edx
        div ecx
        mov ebx, eax
        xor edi, edi
        mov esi, rect.bottom
        sub esi, 32
        .WHILE ebx != 0
            invoke BitBlt,hDCBackbuffer, edi,esi,2,32,hDCBkgBot,0,0,SRCCOPY
            add edi, 2
            dec ebx
        .ENDW
        
        ;##: Paint Left Side
        mov eax, rect.bottom
        mov ecx, 2
        xor edx, edx
        div ecx
        mov ebx, eax
        xor edi, edi
        .WHILE ebx != 0
            invoke BitBlt,hDCBackbuffer, 0,edi,32,2,hDCBkgSideL,0,0,SRCCOPY
            add edi, 2
            dec ebx
        .ENDW
        
        ;##: Paint Right Side
        mov eax, rect.bottom
        mov ecx, 2
        xor edx, edx
        div ecx
        mov ebx, eax
        xor edi, edi
        mov esi, rect.right
        sub esi, 32
        .WHILE ebx != 0
            invoke BitBlt,hDCBackbuffer, esi,edi,32,2,hDCBkgSideR,0,0,SRCCOPY
            add edi, 2
            dec ebx
        .ENDW
        
        ;##: Paint Top Left Corner
        invoke BitBlt,hDCBackbuffer,0,0,32,32,hDCBkgCornerTL,0,0,SRCCOPY

        ;##: Paint Top Right Corner        
        mov eax, rect.right
        sub eax, 32
        invoke BitBlt,hDCBackbuffer,eax,0,32,32,hDCBkgCornerTR,0,0,SRCCOPY

        ;##: Paint Bottom Left Corner
        sub rect.bottom,32
        invoke BitBlt,hDCBackbuffer,0,rect.bottom,32,32,hDCBkgCornerBL,0,0,SRCCOPY

        ;##: Paint Bottom Right Corner        
        sub rect.right,32
        invoke BitBlt,hDCBackbuffer,rect.right,rect.bottom,32,32,hDCBkgCornerBR,0,0,SRCCOPY

        ;##: Now blt the whole thing onto the visible DC
        add     rect.right, 32
        add     rect.bottom, 32
        invoke  BitBlt,ps.hdc,0,0,rect.right,rect.bottom,hDCBackbuffer,0,0,SRCCOPY        

        ;##: Flush the GDI cache to finish drawing onto the control
        invoke  GdiFlush
        invoke  EndPaint, hWnd, ADDR ps

        ;##: Cleanup
        invoke  SelectObject, hDCBackbuffer, hBmpBackbuffer
        mov     hBmpBackbuffer, eax
        invoke  DeleteObject, hBmpBackbuffer
        invoke  ReleaseDC, hWnd, hDCBackbuffer

        xor     eax, eax
        ret

    .ELSEIF uMsg==WM_SIZE
        ;##: Force a redraw
        invoke InvalidateRect,hWnd,0,TRUE
        
    .ELSEIF uMsg==WM_DESTROY
        invoke  ShutdownApp, NULL 
    .ELSE
        push    eax
        mov     eax, uMsg
        .IF eax==dwTaskbarRestart                               ;##: Means that explorer.exe restarted(uMsg in edi for now)
            invoke  StringCbCopy, ADDR nid.szTip, SIZEOF nid.szTip, ADDR AppTitle
            invoke  Shell_NotifyIcon, NIM_ADD, ADDR nid         ;##: Add the icon back to the system tray
        .ENDIF
        pop     eax    
        invoke  DefWindowProc, hWnd, uMsg, wParam, lParam
        ret
    .ENDIF
    xor     eax, eax

    ret
WndProc endp    ;| End the Wndproc procedure
;|
;|
szErrOnlyOneInstance    db  "You can only run one instance at a time.",0
CheckMultiInstance  proc    hInst:DWORD, pAppName:DWORD, pClassName:DWORD, pMutexName:DWORD

    invoke  CreateMutex, NULL, FALSE, pMutexName
    invoke  GetLastError
    .IF eax==ERROR_ALREADY_EXISTS
        ;invoke  MessageBox, NULL, ADDR szErrOnlyOneInstance, ADDR AppName, MB_OK+MB_ICONSTOP
        invoke  FindWindow, ADDR ClassName, NULL
        invoke  SendMessage, eax, WM_TIMER, WM_TIMER_CHECK, 0                
        mov     eax, FALSE
        ret
    .ENDIF


    mov     eax, TRUE
    
    ret
CheckMultiInstance  endp
;|
;|
szVerSubBlock           db  "\",0
szVerProductName        db  "\\StringFileInfo\\040904E4\\ProductName",0
szTmpAppTitle           db  "%s, v%lu.%lu.%lu.%lu",0
szTmpAppVersion         db  "%lu%lu%lu%lu",0
szTmpHttpHdrUserAgent   db  "User-Agent: PodWrangler/1.1 (%s/%lu.%lu.%lu.%lu)",0dh,0ah,0
GetAppTitle proc    hInst:DWORD,pAppName:DWORD,pBufferTitle:DWORD,pUserAgent:DWORD   
    LOCAL   ModuleFileName[MAX_PATH]:BYTE
    LOCAL   VersionInfo[256]:BYTE
    LOCAL   pVersionBlock:DWORD
    LOCAL   VersionBlockSize:DWORD
    LOCAL   StrVerMS:DWORD
    LOCAL   StrVerLS:DWORD
    LOCAL   Ver1:DWORD
    LOCAL   Ver2:DWORD
    LOCAL   Ver3:DWORD
    LOCAL   Ver4:DWORD
    LOCAL   strAppVersion[16]:BYTE

    ;//Get the name of this file
    invoke  GetModuleFileName, hInst, ADDR ModuleFileName, MAX_PATH

    ;//Get the version info block
    invoke  GetFileVersionInfo, ADDR ModuleFileName, 0, 256, ADDR VersionInfo
    invoke  VerQueryValue, ADDR VersionInfo, ADDR szVerSubBlock, ADDR pVersionBlock, ADDR VersionBlockSize

    ;//Parse the info we need
    mov     edx, pVersionBlock
    assume  edx:ptr VS_FIXEDFILEINFO
    push    [edx].dwFileVersionLS
    push    [edx].dwFileVersionMS
    assume  edx:nothing
    pop     StrVerMS
    pop     StrVerLS

    xor     edx, edx
    mov     eax, StrVerMS
    mov     dx, ax
    mov     Ver2, edx
    xor     edx, edx
    shr     eax, 16
    mov     dx, ax
    mov     Ver1, edx   

    xor     edx, edx
    mov     eax, StrVerLS
    mov     dx, ax
    mov     Ver4, edx
    xor     edx, edx
    shr     eax, 16
    mov     dx, ax
    mov     Ver3, edx   

    ;//Put it into the app title buffer
    invoke  wsprintf, pBufferTitle, ADDR szTmpAppTitle, pAppName, Ver1, Ver2, Ver3, Ver4

    ;##: Create a user-agent string for http requests
    invoke  wsprintf, pUserAgent, ADDR szTmpHttpHdrUserAgent, pAppName, Ver1, Ver2, Ver3, Ver4

    ;//Create a DWORD out of the version number
    invoke  wsprintf, ADDR strAppVersion, ADDR szTmpAppVersion, Ver1, Ver2, Ver3, Ver4

    ;//Return the version number as a DWORD value in eax
    invoke  atodw, ADDR strAppVersion
    ret
GetAppTitle endp
;|
;|
ClearBuffer     proc  uses edi esi  ptrBuffer:DWORD, lenBuffer:DWORD

    pushf

    cld
    mov     edi, ptrBuffer
    mov     eax, 0
    mov     ecx, lenBuffer
    rep     stosb

    popf


    ret
ClearBuffer     endp
;|
;|
CopyBuffer     proc  uses edi esi  pBufferFrom:DWORD, pBufferTo:DWORD, lenBuffer:DWORD

    pushf

    cld
    mov     esi, pBufferFrom
    mov     edi, pBufferTo
    mov     ecx, lenBuffer
    xor     eax, eax
    rep     movsb


    popf


    ret
CopyBuffer     endp
;|
;|
ShutdownApp     proc    dwReturnValue:DWORD

    ;##: Destroy all the open GDI handles
    invoke  DeleteObject,hBrshBackground
    invoke  DeleteDC,hDCBkgTop
    invoke  DeleteDC,hDCBkgBot
    invoke  DeleteDC,hDCBkgSideR
    invoke  DeleteDC,hDCBkgSideL
    invoke  DeleteObject,hBmpBkgTop
    invoke  DeleteObject,hBmpBkgBot
    invoke  DeleteObject,hBmpBkgSideR
    invoke  DeleteObject,hBmpBkgSideL
    invoke  DeleteDC,hDCBkgCornerTR
    invoke  DeleteDC,hDCBkgCornerTL
    invoke  DeleteDC,hDCBkgCornerBR
    invoke  DeleteDC,hDCBkgCornerBL
    invoke  DeleteObject,hBmpBkgCornerTR
    invoke  DeleteObject,hBmpBkgCornerTL
    invoke  DeleteObject,hBmpBkgCornerBR
    invoke  DeleteObject,hBmpBkgCornerBL      

    invoke  UnregisterClass, hInstance, ADDR ClassButton

    invoke  Shell_NotifyIcon, NIM_DELETE, ADDR nid
    invoke  PostQuitMessage, dwReturnValue    

    mov     eax, dwReturnValue
    ret
ShutdownApp     endp
;|
;|
szTmpErrBadResponse             db  "The server returned a response code indicating a problem with the download: GetHttpFile(%d)",0dh,0ah
                                db  "The next 2 popups will tell you what URL was being retrieved and what type of download it was.",0dh,0ah
                                db  "If the error code is 404 and the 3rd box says 'Feed Retrieval Error' then the rss feed URL",0dh,0ah
                                db  "for that podcast has probably changed and you need to update it with the new URL.",0
szErrInternetOpen               db  "There was an error opening your internet connection: InternetOpen()",0
szErrInternetConnect            db  "There was an error connecting to the internet server: InternetConnect()",0
szErrHttpOpenRequest            db  "There was an error preparing the HTTP request: HttpOpenRequest()",0
szErrHttpSendRequest            db  "There was an error sending the HTTP request: HttpSendRequest()",0dh,0ah
                                db  "Make sure your internet connection isn't down.",0
szErrCreateFile                 db  "There was an error creating the file that was downloaded: CreateFile()",0
szErrInternetQueryDataAvailable db  "There was an error querying for available data: InternetQueryDataAvailable()",0
szErrGlobalAlloc                db  "There was an error allocating memory for the incoming data: GlobalAlloc()",0
szErrGlobalLock                 db  "There was an error obtaining a memory pointer for the incoming data: GlobalLock()",0
szErrInternetReadFile           db  "There was an error reading the file data from Wininet: InternetReadFile()",0
szErrTooManyRedirects           db  "The server keeps redirecting us over and over: GetHttpFile(too many 30x's)",0
GetHttpFile     proc    hWnd:DWORD,pUrl:DWORD,pFilename:DWORD,hProgress:DWORD,dwFileSize:DWORD
    LOCAL   hInternet:DWORD
    LOCAL   hConnect:DWORD
    LOCAL   hRequest:DWORD
    LOCAL   dwResponseSize:DWORD
    LOCAL   dwResponseReadSize:DWORD
    LOCAL   hMemory:DWORD
    LOCAL   pMemory:DWORD
    LOCAL   hFile:DWORD
    LOCAL   dwReadData:DWORD
    LOCAL   dwContext:DWORD
    LOCAL   url:URL_COMPONENTS
    LOCAL   strHostName[255]:BYTE
    LOCAL   strUserName[64]:BYTE
    LOCAL   strPassword[64]:BYTE
    LOCAL   dwContentLength:DWORD
    LOCAL   dwContentLengthSize:DWORD
    LOCAL   i:DWORD
    LOCAL   dwCurrentPos:DWORD
    LOCAL   dwStatusCode:DWORD
    LOCAL   dwBufferSize:DWORD
    LOCAL   strUrlPath[INTERNET_MAX_URL_LENGTH]:BYTE
    LOCAL   strExtraInfo[INTERNET_MAX_URL_LENGTH]:BYTE
    LOCAL   strUrl[INTERNET_MAX_URL_LENGTH]:BYTE   
    LOCAL   dwRedirectCount:DWORD
    LOCAL   strErrBadResponse[512]:BYTE
    LOCAL   dwHttpHdrUserAgentLength:DWORD
    LOCAL   dwUrlLength:DWORD

    
    ;##: Debugging
    ;invoke	MessageBox, hWnd, pUrl, ADDR AppTitle, MB_OK+MB_ICONINFORMATION

    ;##: Zero out the file size variable if one was wanted
    .IF (dwFileSize!=NULL)
        mov     edx, dwFileSize
        xor     eax, eax
        mov     [edx], eax
    .ENDIF

    ;##: Open an internet session through the Wininet API
    mov     dwContext, 1
    invoke  InternetOpen, ADDR AppTitle, INTERNET_OPEN_TYPE_DIRECT, NULL, NULL, NULL
    .IF (eax==NULL)
        invoke  MessageBox, hWnd, ADDR szErrInternetOpen, ADDR AppTitle, MB_OK+MB_ICONSTOP
        mov     eax, 1
        ret            
    .ENDIF
    mov     hInternet, eax
    
    ;##: Parse the given URL
    invoke  StringCbCopy, ADDR strUrl, INTERNET_MAX_URL_LENGTH, pUrl

    mov     dwRedirectCount, 0
    mov     dwStatusCode, 399


    ;##: We keep modifying and resending until we get a firm response and not a redirect
    .WHILE((dwRedirectCount<MAX_REDIRECTS) && ((dwStatusCode>300) && (dwStatusCode<400)))
        ;##: Fill out the structure to crack the URL with
        mov     url.dwStructSize, SIZEOF URL_COMPONENTS
        mov     url.lpszScheme, NULL
        mov     url.dwSchemeLength, 0
        mov     url.nScheme, INTERNET_SCHEME_HTTP
        lea     eax, strHostName
        mov     url.lpszHostName, eax
        mov     url.dwHostNameLength, SIZEOF strHostName
        mov     url.nPort, NULL    
        lea     eax, strUserName    
        mov     url.lpszUserName, eax
        mov     url.dwUserNameLength, SIZEOF strUserName
        lea     eax, strPassword
        mov     url.lpszPassword, eax
        mov     url.dwPasswordLength, SIZEOF strPassword
        lea     eax, strUrlPath
        mov     url.lpszUrlPath, eax
        mov     url.dwUrlPathLength, SIZEOF strUrlPath
        lea     eax, strExtraInfo
        mov     url.lpszExtraInfo, eax
        mov     url.dwExtraInfoLength, SIZEOF strExtraInfo

        ;##: Parse the URL into manageable parts
        invoke  InternetCrackUrl, ADDR strUrl, 0, NULL, ADDR url
        .IF (url.dwExtraInfoLength>0)
            invoke  StringCbCat, ADDR strUrlPath, SIZEOF strUrlPath, ADDR strExtraInfo
        .ENDIF
        
        ;##: Set up some rudimentary details about the connection        
        invoke  InternetConnect, hInternet, ADDR strHostName, INTERNET_DEFAULT_HTTP_PORT, \
                ADDR strUserName, ADDR strPassword, INTERNET_SERVICE_HTTP, NULL, ADDR dwContext
        .IF (eax==NULL)
            invoke  InternetCloseHandle, hInternet    
            invoke  MessageBox, hWnd, ADDR szErrInternetConnect, ADDR AppTitle, MB_OK+MB_ICONSTOP
            mov     eax, 1
            ret            
        .ENDIF
        mov     hConnect, eax
    
        ;##: Here we set up the specifics about the HTTP nature of the request        
        invoke  HttpOpenRequest, hConnect, NULL, ADDR strUrlPath, NULL, NULL, NULL, \
                INTERNET_FLAG_KEEP_CONNECTION+INTERNET_FLAG_PRAGMA_NOCACHE+INTERNET_FLAG_RELOAD+INTERNET_FLAG_NO_AUTO_REDIRECT,\
                ADDR dwContext
        .IF (eax==NULL)
            invoke  InternetCloseHandle, hConnect
            invoke  InternetCloseHandle, hInternet    
            invoke  MessageBox, hWnd, ADDR szErrHttpOpenRequest, ADDR AppTitle, MB_OK+MB_ICONSTOP
            mov     eax, 1
            ret            
        .ENDIF
        mov     hRequest, eax

        ;##: Add a custom user-agent header to the request
        invoke  StringCbLength, ADDR strHttpHdrUserAgent, SIZEOF strHttpHdrUserAgent, ADDR dwHttpHdrUserAgentLength
        invoke  HttpAddRequestHeaders, hRequest, ADDR strHttpHdrUserAgent, dwHttpHdrUserAgentLength, HTTP_ADDREQ_FLAG_ADD+HTTP_ADDREQ_FLAG_REPLACE

        ;##: Here is where the request actually gets sent to the server
        invoke  HttpSendRequest, hRequest, NULL, NULL, NULL, NULL
        .IF ((eax==FALSE) || (eax==ERROR_FILE_NOT_FOUND))
            invoke  HttpEndRequest, hRequest, NULL, 0, 0
            invoke  InternetCloseHandle, hRequest
            invoke  InternetCloseHandle, hConnect
            invoke  InternetCloseHandle, hInternet    
            invoke  MessageBox, hWnd, ADDR szErrHttpSendRequest, ADDR AppTitle, MB_OK+MB_ICONSTOP
            mov     eax, 1
            ret            
        .ENDIF
    
    
        ;##: Check the response code we got back
        mov     dwBufferSize, SIZEOF dwStatusCode
        invoke  HttpQueryInfo, hRequest, HTTP_QUERY_STATUS_CODE+HTTP_QUERY_FLAG_NUMBER, ADDR dwStatusCode, ADDR dwBufferSize, NULL
        .IF ((dwStatusCode>300) && (dwStatusCode<400))          ;##: This means the server is redirecting us to a different location                
            mov     dwBufferSize, INTERNET_MAX_URL_LENGTH
            invoke  HttpQueryInfo, hRequest, HTTP_QUERY_LOCATION, ADDR strUrl, ADDR dwBufferSize, NULL
            invoke  StringCbLength, ADDR strUrl, SIZEOF strUrl, ADDR dwUrlLength    ;##: Check the length of the redirection URL to make sure it's
            .IF (dwUrlLength>12)                                                    ;##: a sane value before keeping it (i.e. http://z.com)
                invoke  StringCbCopy, pUrl, INTERNET_MAX_URL_LENGTH, ADDR strUrl    ;##: Keep the passed in URL up to date with the redirection
            .ENDIF
            invoke  HttpEndRequest, hRequest, NULL, 0, 0
            invoke  InternetCloseHandle, hRequest
            invoke  InternetCloseHandle, hConnect
        .ENDIF        
        inc     dwRedirectCount

        ;##: Debug for response codes
        ;invoke  wsprintf, ADDR strErrBadResponse, ADDR szTmpErrBadResponse, dwStatusCode
        ;invoke  MessageBox, hWnd, ADDR strErrBadResponse, ADDR strUrl, MB_OK+MB_ICONSTOP                    
    .ENDW

    ;##: Check exactly why we broke out of the loop
    .IF (dwRedirectCount>=MAX_REDIRECTS)        ;##: This keeps us safe from broken server redirects
        invoke  HttpEndRequest, hRequest, NULL, 0, 0

        invoke  InternetCloseHandle, hRequest
        invoke  InternetCloseHandle, hConnect
        invoke  InternetCloseHandle, hInternet    
        invoke  MessageBox, hWnd, ADDR szErrTooManyRedirects, ADDR AppTitle, MB_OK+MB_ICONSTOP
        mov     eax, 1
        ret
    .ENDIF
    .IF (dwStatusCode==404)  ;##: This means we got a hard 404
        invoke  HttpEndRequest, hRequest, NULL, 0, 0

        invoke  InternetCloseHandle, hRequest
        invoke  InternetCloseHandle, hConnect
        invoke  InternetCloseHandle, hInternet
        mov     eax, 404
        ret
    .ENDIF    
    .IF ((dwStatusCode<200) || (dwStatusCode>399))  ;##: This means we got response we aren't equipped to handle
        invoke  HttpEndRequest, hRequest, NULL, 0, 0

        invoke  InternetCloseHandle, hRequest
        invoke  InternetCloseHandle, hConnect
        invoke  InternetCloseHandle, hInternet
        invoke  wsprintf, ADDR strErrBadResponse, ADDR szTmpErrBadResponse, dwStatusCode
        invoke  MessageBox, hWnd, ADDR strErrBadResponse, ADDR AppTitle, MB_OK+MB_ICONSTOP
        invoke  MessageBox, hWnd, ADDR strUrl, ADDR strCurrentlyChecking, MB_OK+MB_ICONSTOP
        mov     eax, 1
        ret
    .ENDIF

    ;##: At this point everything is looking good so we create the file to store the incoming data in        
    invoke  CreateFile, pFilename, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, NULL, NULL
    .IF (eax==INVALID_HANDLE_VALUE)
        invoke  HttpEndRequest, hRequest, NULL, 0, 0

        invoke  InternetCloseHandle, hRequest
        invoke  InternetCloseHandle, hConnect
        invoke  InternetCloseHandle, hInternet    
        invoke  MessageBox, hWnd, ADDR szErrCreateFile, ADDR AppTitle, MB_OK+MB_ICONSTOP
        mov     eax, 1
        ret
    .ENDIF
    mov     hFile, eax

    ;##: Set up the progress bar and display it if needed
    .IF (hProgress!=NULL)
        invoke  ShowWindow, hWnd, SW_SHOWNORMAL    
    .ENDIF        
    mov     dwContentLengthSize, SIZEOF dwContentLength
    invoke  HttpQueryInfo, hRequest, HTTP_QUERY_CONTENT_LENGTH+HTTP_QUERY_FLAG_NUMBER, ADDR dwContentLength, ADDR dwContentLengthSize, NULL
    invoke  SendMessage, hProgress, PBM_SETPOS, 0, NULL    


    ;##: Since everything is cool until this point let's start reading the data into a file
    mov     dwReadData, TRUE
    mov     i, 0
    .WHILE (dwReadData==TRUE)
        .BREAK .IF (boolCancelDownload==TRUE)        
        invoke  InternetQueryDataAvailable, hRequest, ADDR dwResponseSize, 0, 0
        .IF (eax==FALSE)
            invoke  HttpEndRequest, hRequest, NULL, 0, 0

            invoke  InternetCloseHandle, hRequest
            invoke  InternetCloseHandle, hConnect
            invoke  InternetCloseHandle, hInternet    
            invoke  MessageBox, hWnd, ADDR szErrInternetQueryDataAvailable, ADDR AppTitle, MB_OK+MB_ICONSTOP
            mov     eax, 1
            ret            
        .ENDIF
        .BREAK .IF (dwResponseSize==0) 

        ;//Increment the index for a total current byte count
        mov     eax, i
        add     eax, dwResponseSize
        mov     i, eax

        invoke  GlobalAlloc, GMEM_FIXED+GMEM_ZEROINIT, dwResponseSize
        .IF (eax==NULL)
            invoke  HttpEndRequest, hRequest, NULL, 0, 0

            invoke  InternetCloseHandle, hRequest
            invoke  InternetCloseHandle, hConnect
            invoke  InternetCloseHandle, hInternet    
            invoke  MessageBox, hWnd, ADDR szErrGlobalAlloc, ADDR AppTitle, MB_OK+MB_ICONSTOP
            mov     eax, 1
            ret            
        .ENDIF
        mov     hMemory, eax
        
        invoke  GlobalLock, hMemory
        .IF (eax==NULL)
            invoke  GlobalFree, hMemory
            invoke  HttpEndRequest, hRequest, NULL, 0, 0

            invoke  InternetCloseHandle, hRequest
            invoke  InternetCloseHandle, hConnect
            invoke  InternetCloseHandle, hInternet    
            invoke  MessageBox, hWnd, ADDR szErrGlobalLock, ADDR AppTitle, MB_OK+MB_ICONSTOP
            mov     eax, 1
            ret            
        .ENDIF        
        mov     pMemory, eax
        
        invoke  InternetReadFile, hRequest, pMemory, dwResponseSize, ADDR dwResponseReadSize
        .IF (eax==FALSE)
            invoke  GlobalUnlock, hMemory        
            invoke  GlobalFree, hMemory
            invoke  HttpEndRequest, hRequest, NULL, 0, 0

            invoke  InternetCloseHandle, hRequest
            invoke  InternetCloseHandle, hConnect
            invoke  InternetCloseHandle, hInternet    
            invoke  MessageBox, hWnd, ADDR szErrGlobalLock, ADDR AppTitle, MB_OK+MB_ICONSTOP
            mov     eax, 1
            ret
        .ELSEIF ((eax==TRUE) && (dwResponseReadSize==0))
            mov     dwReadData, FALSE
        .ENDIF
        invoke  SetFilePointer, hFile, 0, NULL, FILE_END
        invoke  WriteFile, hFile, pMemory, dwResponseSize, ADDR dwFeedFileBytesWritten, NULL

        ;##: Set progress bar position on a 0-100 scale
        ;//Divide the original total by 100 to get a usable answer
        ;//by bringing the decimal point back 2 spaces
        xor     edx, edx
        mov     eax, dwContentLength
        mov     ecx, 100
        div     ecx
        push    eax
               
        ;//Now get the percentage
        xor     edx, edx
        mov     eax, i
        pop     ecx              
        .IF(ecx>0)                                               ;| Here is the problem in this block
            div     ecx
            mov     dwCurrentPos, eax
        .ENDIF
        invoke  SendMessage, hProgress, PBM_SETPOS, dwCurrentPos, 0

        invoke  GlobalUnlock, hMemory
        invoke  GlobalFree, hMemory
    .ENDW

    ;##: Put the file size in the variable if one was requested
    .IF (dwFileSize!=NULL)
        mov     edx, dwFileSize
        mov     eax, i
        mov     [edx], eax
    .ENDIF     
        
    invoke  CloseHandle, hFile
    invoke  ShowWindow, hWnd, SW_HIDE

    xor     eax, eax
    ret
GetHttpFile     endp
;|
;|
GetFileName proc pUrl:DWORD,pFileName:DWORD,dwLength:DWORD
    LOCAL   url:URL_COMPONENTS
    LOCAL   strHostName[255]:BYTE
    LOCAL   strUserName[64]:BYTE
    LOCAL   strPassword[64]:BYTE
    LOCAL   strUrlPath[INTERNET_MAX_URL_LENGTH]:BYTE
    LOCAL   strExtraInfo[INTERNET_MAX_URL_LENGTH]:BYTE
    LOCAL   dwUrlPathLength:DWORD    

    ;##: Parse the given URL
    mov     url.dwStructSize, SIZEOF URL_COMPONENTS
    mov     url.lpszScheme, NULL
    mov     url.dwSchemeLength, 0
    mov     url.nScheme, INTERNET_SCHEME_HTTP
    lea     eax, strHostName
    mov     url.lpszHostName, eax
    mov     url.dwHostNameLength, SIZEOF strHostName
    mov     url.nPort, NULL    
    lea     eax, strUserName    
    mov     url.lpszUserName, eax
    mov     url.dwUserNameLength, SIZEOF strUserName
    lea     eax, strPassword
    mov     url.lpszPassword, eax
    mov     url.dwPasswordLength, SIZEOF strPassword
    lea     eax, strUrlPath
    mov     url.lpszUrlPath, eax
    mov     url.dwUrlPathLength, SIZEOF strUrlPath
    lea     eax, strExtraInfo
    mov     url.lpszExtraInfo, eax
    mov     url.dwExtraInfoLength, SIZEOF strExtraInfo
    invoke  InternetCrackUrl, pUrl, 0, NULL, ADDR url

    invoke  RtlFillMemory, pFileName, dwLength, 0
    invoke  StringCbLength, ADDR strUrlPath, INTERNET_MAX_URL_LENGTH, ADDR dwUrlPathLength
    mov     eax, dwUrlPathLength 
    std
    lea     edi, strUrlPath
    add     edi, eax
    dec     edi
    mov     ecx, eax
    mov     al, "/"
    repne   scasb
    cld
    jne     No_name
    cmp     byte ptr [edi], "/"
    je      No_name
    inc     edi
    inc     edi
    dec     dwLength
    invoke  StringCbCopy, pFileName, dwLength, edi
No_name:

    xor     eax, eax
    ret
GetFileName endp
;|
;|
GetUrlParts proc pUrl:DWORD,pHostName:DWORD,pPath:DWORD,pExtraInfo:DWORD,pFileName:DWORD,dwLength:DWORD
    LOCAL   url:URL_COMPONENTS
    LOCAL   strHostName[255]:BYTE
    LOCAL   strUserName[64]:BYTE
    LOCAL   strPassword[64]:BYTE
    LOCAL   strUrlPath[INTERNET_MAX_URL_LENGTH]:BYTE
    LOCAL   strExtraInfo[INTERNET_MAX_URL_LENGTH]:BYTE
    LOCAL   dwBufferLength:DWORD    

    ;##: Parse the given URL
    mov     url.dwStructSize, SIZEOF URL_COMPONENTS
    mov     url.lpszScheme, NULL
    mov     url.dwSchemeLength, 0
    mov     url.nScheme, INTERNET_SCHEME_HTTP
    
    lea     eax, strHostName
    mov     url.lpszHostName, eax
    mov     url.dwHostNameLength, SIZEOF strHostName
    mov     url.nPort, NULL
        
    lea     eax, strUserName    
    mov     url.lpszUserName, eax
    mov     url.dwUserNameLength, SIZEOF strUserName
    
    lea     eax, strPassword
    mov     url.lpszPassword, eax
    mov     url.dwPasswordLength, SIZEOF strPassword
    
    lea     eax, strUrlPath
    mov     url.lpszUrlPath, eax
    mov     url.dwUrlPathLength, SIZEOF strUrlPath
    
    lea     eax, strExtraInfo
    mov     url.lpszExtraInfo, eax
    mov     url.dwExtraInfoLength, SIZEOF strExtraInfo
    
    invoke  InternetCrackUrl, pUrl, 0, NULL, ADDR url

    invoke  StringCbCopy, pHostName, 255, ADDR strHostName
    invoke  StringCbCopy, pPath, INTERNET_MAX_URL_LENGTH, ADDR strUrlPath    
    invoke  StringCbCopy, pExtraInfo, INTERNET_MAX_URL_LENGTH, ADDR strExtraInfo

    invoke  RtlFillMemory, pFileName, dwLength, 0
    invoke  StringCbLength, ADDR strUrlPath, INTERNET_MAX_URL_LENGTH, ADDR dwBufferLength
    mov     eax, dwBufferLength
    std
    lea     edi, strUrlPath
    add     edi, eax
    dec     edi
    mov     ecx, eax
    mov     al, "/"
    repne   scasb
    cld
    jne     @1533
    cmp     byte ptr [edi], "/"
    je      @1533
    inc     edi
    inc     edi
    dec     dwLength
    invoke  StringCbLength, pFileName, dwLength, edi
@1533:

    xor     eax, eax
    ret
GetUrlParts endp
;|
;|
szErrFileCouldntOpen        db  "Error trying to open file: CreateFile()",0
szErrFileCouldntMap         db  "Error mapping file into memory, CreateFileMapping()",0
szErrFileCouldntPoint       db  "Error obtaining pointer to file map, MapViewOfFile()",0
szErrFileParseFeed          db  "Error parsing RSS feed file. Please check URL, GetNewestMediaUrl()",0
szErrFileParseFeedLinkOpen  db  "Error parsing RSS feed file. Please check URL, GetNewestMediaUrl():Couldn't find <link> tag.",0
szErrFileParseFeedLinkClose db  "Error parsing RSS feed file. Please check URL, GetNewestMediaUrl():Couldn't find </link> tag.",0
szErrFileParseFeedItemOpen  db  "Error parsing RSS feed file. Please check URL, GetNewestMediaUrl():Couldn't find <item> tag.",0
GetNewestMediaUrl  proc    hWnd:DWORD,pFileName:DWORD,pUrl:DWORD
    LOCAL   hFile:DWORD
    LOCAL   dwFileSize:DWORD
    LOCAL	dwBytesLeft:DWORD
    LOCAL   hMap:DWORD
    LOCAL   pMap:DWORD
    LOCAL   pStartLink:DWORD
    LOCAL   pStartEnclosure:DWORD
    LOCAL   pStartUrl:DWORD
    LOCAL   dwUrlLength:DWORD
    LOCAL   pStartItem:DWORD


    ;##: Open the file for mapping
    invoke  CreateFile, pFileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, NULL, NULL
    .IF (eax==INVALID_HANDLE_VALUE)
        invoke      MessageBox, hWnd, ADDR szErrFileCouldntOpen, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        invoke      MessageBox, hWnd, pFileName, ADDR strErrorFileRead, MB_OK+MB_ICONINFORMATION
        mov         eax, 1
        ret
    .ENDIF
    mov     hFile, eax

    ;##: Get its size
    invoke  GetFileSize, hFile, NULL
    mov     dwFileSize, eax

    ;##: Map the file and get a pointer
    invoke  CreateFileMapping, hFile, NULL, PAGE_READONLY, NULL, NULL, NULL
    .IF (eax==NULL)
        invoke      GetLastError
        invoke      ShowError, hWnd, eax
        invoke      CloseHandle, hFile
        invoke      MessageBox, hWnd, ADDR szErrFileCouldntMap, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        mov         eax, 1
        ret
    .ENDIF
    mov     hMap, eax    
    invoke  MapViewOfFile, hMap, FILE_MAP_READ, NULL, NULL, NULL
    .IF (eax==NULL)
        invoke      CloseHandle, hMap    
        invoke      CloseHandle, hFile    
        invoke      MessageBox, hWnd, ADDR szErrFileCouldntPoint, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        mov         eax, 1
        ret
    .ENDIF
    mov     pMap, eax

    ;##: First we have to find the newest <item> in the RSS feed
    ;invoke  InString, 1, pMap, ADDR strItemTagOpen
    invoke	lstrlen, ADDR strItemTagOpen
    invoke  BinSearch, 0, pMap, dwFileSize, ADDR strItemTagOpen, eax
    .IF (eax!=-1)
        sub			dwFileSize, eax       
        add         eax, pMap
        mov         pStartItem, eax
        invoke      lstrlen, ADDR strItemTagOpen
        add         pStartItem, eax
        sub         dwFileSize, eax                
    .ELSE
        invoke      UnmapViewOfFile, pMap    
        invoke      CloseHandle, hMap    
        invoke      CloseHandle, hFile    
        invoke      MessageBox, hWnd, ADDR szErrFileParseFeedItemOpen, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        mov         eax, 1
        ret
    .ENDIF    

    ;##: Now see if their is an <enclosure> tag in this item node
    ;invoke  InString, 1, pStartItem, ADDR strEnclosureTagOpen
    invoke	lstrlen, ADDR strEnclosureTagOpen
    invoke  BinSearch, 0, pStartItem, dwFileSize, ADDR strEnclosureTagOpen, eax
    .IF (eax!=-1)    
        sub     dwFileSize, eax     
        add     eax, pStartItem
        mov     pStartEnclosure, eax
        invoke  lstrlen, ADDR strEnclosureTagOpen
        add     pStartEnclosure, eax
        sub     dwFileSize, eax        

        ;##: Find where the url property begins
        push    pStartEnclosure
        pop     pStartUrl
        ;invoke  InString, 1, pStartEnclosure, ADDR strHtmlUrl
        invoke	lstrlen, ADDR strHtmlUrl
        invoke  BinSearch, 0, pStartEnclosure, dwFileSize, ADDR strHtmlUrl, eax        
        .IF (eax!=-1)
        	sub	    dwFileSize, eax             
            add     eax, pStartEnclosure
            mov     pStartUrl, eax            
            invoke  lstrlen, ADDR strHtmlUrl
            inc		eax				;## Skip the opening quotes            
            add     pStartUrl, eax            
            sub     dwFileSize, eax            
        .ELSE
            invoke      UnmapViewOfFile, pMap
            invoke      CloseHandle, hMap    
            invoke      CloseHandle, hFile    
            invoke      MessageBox, hWnd, ADDR szErrFileParseFeed, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
            mov         eax, 1
            ret
        .ENDIF

        ;##: Now extract the url from the quotes in the tag
        ;invoke  InString, 1, pStartUrl, ADDR strDoubleQuotes
        mov		al, 022h
        invoke  FindChar, pStartUrl, eax, dwFileSize        
        .IF (eax!=-1)
        	inc		eax					;##: 1-based since we're calcing length now instead of position
            sub		dwFileSize, eax
            mov     dwUrlLength, eax
            invoke  lstrcpyn, pUrl, pStartUrl, dwUrlLength
            sub     dwFileSize, eax            
        .ELSE
            ;##: Didn't find double-quotes so let's look for single quotes
            ;invoke  InString, 1, pStartUrl, ADDR strSingleQuotes
        	mov		al, 027h
        	invoke  FindChar, pStartUrl, eax, dwFileSize           
            .IF (eax!=-1)
            	inc		eax					;##: 1-based since we're calcing length now instead of position
                sub		dwFileSize, eax         
                mov     dwUrlLength, eax
                invoke  lstrcpyn, pUrl, pStartUrl, dwUrlLength
                sub     dwFileSize, eax                
            .ELSE
                invoke      UnmapViewOfFile, pMap            
                invoke      CloseHandle, hMap    
                invoke      CloseHandle, hFile    
                invoke      MessageBox, hWnd, ADDR szErrFileParseFeed, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
                mov         eax, 2
                ret
            .ENDIF          
        .ENDIF
    .ELSE
        ;##: Since their isn't an <enclosure> tag then we extract the url from the <link> tag
        ;invoke  InString, 1, pStartItem, ADDR strLinkTagOpen
        invoke	lstrlen, ADDR strLinkTagOpen
        invoke  BinSearch, 0, pStartItem, dwFileSize, ADDR strLinkTagOpen, eax        
        .IF (eax!=-1)
			sub			dwFileSize, eax
            add         eax, pStartItem
            mov         pStartLink, eax
            mov         pStartUrl, eax
            invoke      lstrlen, ADDR strLinkTagOpen
            add         pStartUrl, eax
            sub         dwFileSize, eax            
        .ELSE
            invoke      UnmapViewOfFile, pMap    
            invoke      CloseHandle, hMap    
            invoke      CloseHandle, hFile    
            invoke      MessageBox, hWnd, ADDR szErrFileParseFeedLinkOpen, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
            mov         eax, 1
            ret
        .ENDIF
    
        ;##: Now extract the url from in between the link tags
        ;invoke  InString, 1, pStartUrl, ADDR strLinkTagClose
        invoke	lstrlen, ADDR strLinkTagClose
        invoke  BinSearch, 0, pStartUrl, dwFileSize, ADDR strLinkTagClose, eax        
        .IF (eax!=-1)
        	inc			eax			;##: 1-based since we are calcing size instead of position
			sub			dwFileSize, eax
            mov         dwUrlLength, eax
            invoke      lstrcpyn, pUrl, pStartUrl, dwUrlLength           
        .ELSE
            invoke      UnmapViewOfFile, pMap    
            invoke      CloseHandle, hMap    
            invoke      CloseHandle, hFile    
            invoke      MessageBox, hWnd, ADDR szErrFileParseFeedLinkClose, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
            mov         eax, 2
            ret
        .ENDIF
    .ENDIF
    
    ;##: Debug       
    ;invoke	MessageBox, hWnd, pUrl, ADDR AppTitle, MB_OK          
             
    ;##: Cleanup open handles
    invoke  UnmapViewOfFile, pMap
    invoke  CloseHandle, hMap  
    invoke  CloseHandle, hFile      

    xor     eax, eax
    ret
GetNewestMediaUrl  endp
;|
;|
szErrFileParseFeedTitleOpen     db  "Error parsing upgrade feed file, GetNewestVersionInfo():Couldn't find <title> tag.",0
szErrFileParseFeedTitleClose    db  "Error parsing upgrade feed file, GetNewestVersionInfo():Couldn't find </title> tag.",0
szErrFileParseFeedTitleTooLong  db  "Error parsing RSS feed file, GetFeedTitle():Title is longer than 255 characters.",0
GetFeedTitle    proc    hWnd:DWORD,pFileName:DWORD,pFeedTitle:DWORD,dwMaxTitleSize:DWORD
    LOCAL   hFile:DWORD
    LOCAL   dwFileSize:DWORD
    LOCAL   hMap:DWORD
    LOCAL   pMap:DWORD
    LOCAL   pStartLink:DWORD
    LOCAL   pStartEnclosure:DWORD
    LOCAL   pStartUrl:DWORD
    LOCAL   dwUrlLength:DWORD
    LOCAL   pStartItem:DWORD

    ;##: Open the file for mapping
    invoke  CreateFile, pFileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, NULL, NULL
    .IF (eax==INVALID_HANDLE_VALUE)
        invoke      MessageBox, hWnd, ADDR szErrFileCouldntOpen, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        invoke      MessageBox, hWnd, pFileName, ADDR strErrorFileRead, MB_OK+MB_ICONINFORMATION        
        mov         eax, 1
        ret
    .ENDIF
    mov     hFile, eax

    ;##: Get its size
    invoke  GetFileSize, hFile, NULL
    mov     dwFileSize, eax

    ;##: Map the file and get a pointer
    invoke  CreateFileMapping, hFile, NULL, PAGE_READONLY, NULL, NULL, NULL
    .IF (eax==NULL)
        invoke      CloseHandle, hFile
        invoke      MessageBox, hWnd, ADDR szErrFileCouldntMap, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        mov         eax, 1
        ret
    .ENDIF
    mov     hMap, eax
    invoke  MapViewOfFile, hMap, FILE_MAP_READ, NULL, NULL, NULL
    .IF (eax==NULL)
        invoke      CloseHandle, hMap    
        invoke      CloseHandle, hFile    
        invoke      MessageBox, hWnd, ADDR szErrFileCouldntPoint, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        mov         eax, 1
        ret
    .ENDIF
    mov     pMap, eax

    

    ;##: Look for the <title> tag
    ;invoke  InString, 1, pMap, ADDR strTitleTagOpen
    invoke	lstrlen, ADDR strTitleTagOpen
    invoke  BinSearch, 0, pMap, dwFileSize, ADDR strTitleTagOpen, eax     
    .IF (eax!=-1)
        sub			dwFileSize, eax
        add         eax, pMap
        mov         pStartLink, eax
        mov         pStartUrl, eax
        invoke      lstrlen, ADDR strTitleTagOpen
        add         pStartUrl, eax
        sub			dwFileSize, eax
    .ELSE
        invoke      UnmapViewOfFile, pMap    
        invoke      CloseHandle, hMap    
        invoke      CloseHandle, hFile    
        invoke      MessageBox, hWnd, ADDR szErrFileParseFeedTitleOpen, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        mov         eax, 1
        ret
    .ENDIF

    ;##: Now extract the url from in between the link tags
    ;invoke  InString, 1, pStartUrl, ADDR strTitleTagClose
    invoke	lstrlen, ADDR strTitleTagClose
    invoke  BinSearch, 0, pStartUrl, dwFileSize, ADDR strTitleTagClose, eax      
    .IF (eax!=-1)
    	sub			dwFileSize, eax
        mov         dwUrlLength, eax
        .IF (eax<dwMaxTitleSize)
            invoke      lstrcpyn, pFeedTitle, pStartUrl, dwUrlLength
        .ELSE
            invoke      UnmapViewOfFile, pMap    
            invoke      CloseHandle, hMap    
            invoke      CloseHandle, hFile        
            invoke      MessageBox, hWnd, ADDR szErrFileParseFeedTitleTooLong, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
            mov         eax, 1
            ret
        .ENDIF
    .ELSE
        invoke      UnmapViewOfFile, pMap    
        invoke      CloseHandle, hMap    
        invoke      CloseHandle, hFile    
        invoke      MessageBox, hWnd, ADDR szErrFileParseFeedTitleClose, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        mov         eax, 2
        ret
    .ENDIF
                
 
    ;##: Cleanup open handles
    invoke  UnmapViewOfFile, pMap
    invoke  CloseHandle, hMap  
    invoke  CloseHandle, hFile      

    xor     eax, eax
    ret
GetFeedTitle    endp
;|
;|
szDateFormat            db  "ddd, MMM. dd",0
szTimeFormat            db  "hh:mm tt",0
szDownloadingFile       db  "Downloading new podcast...",0
szTmpAlertNewDownload   db  "A new podcast item has been downloaded:",0dh,0ah,0dh,0ah
                        db  "-Feed: %s",0dh,0ah
                        db  "-Time: %s, %s",0dh,0ah
                        db  "-Dir: %s",0dh,0ah
                        db  "-File: %s",0dh,0ah
                        db  "-Size: %lu",0
strAlertFileFiltered    db  "New files were found but your filter excluded them from download.",0                        
szErrMoveFile           db  "Error moving downloaded file to your Desktop: GetMediaFile(CopyFile)",0
szTmpBadUrl             db  "http://%s%s%s",0
GetMediaFile     proc    hWnd:DWORD
    LOCAL   strDesktopFilePath[MAX_PATH]:BYTE
    LOCAL   strWindowCaption[128]:BYTE
    LOCAL   strUrlFromFeedItem[INTERNET_MAX_URL_LENGTH]:BYTE
    LOCAL   strDate[32]:BYTE
    LOCAL   strTime[32]:BYTE
    LOCAL   strDownload[32]:BYTE
    LOCAL   dwLocalThreadId:DWORD
    LOCAL   strFilter[MAX_PATH]:BYTE
    LOCAL   dwFilterSize:DWORD
    LOCAL   dwBadFileSize:DWORD
    LOCAL   dwGoodFileSize:DWORD
    LOCAL   strUrlHostName[INTERNET_MAX_URL_LENGTH]:BYTE
    LOCAL   strUrlPath[INTERNET_MAX_URL_LENGTH]:BYTE
    LOCAL   strUrlExtraInfo[INTERNET_MAX_URL_LENGTH]:BYTE
    LOCAL   strUrlFileName[INTERNET_MAX_URL_LENGTH]:BYTE
    

    ;##: Flag the rest of the program that a download is in progress
    mov     boolDownloadInProgress, TRUE

    ;##: Reset the main window if it had been moved around
    invoke  SetMainWindowPosition, hWnd

    ;##: Create a path for the feed file download
    invoke  GetFileName, ADDR strFeedUrl, ADDR strFileName, SIZEOF strFileName
    invoke  StringCbCopy, ADDR strFeedPath, SIZEOF strFeedPath, ADDR strWindowsDir            
    invoke  PathAddBackslash, ADDR strFeedPath    
    invoke  StringCbCat, ADDR strFeedPath, SIZEOF strFeedPath, ADDR strFileName

    ;##: Download a fresh copy of the RSS feed file
    .IF(boolManualCheck==TRUE)
        ;##: Change to a more descriptive window caption
        invoke  SetWindowText, hwndStcTitleBar, ADDR strCurrentlyChecking    
        invoke  GetHttpFile, hWnd, ADDR strFeedUrl, ADDR strFeedPath, hwndProgressBar, NULL    
    .ELSE
        invoke  GetHttpFile, hWnd, ADDR strFeedUrl, ADDR strFeedPath, NULL, NULL
    .ENDIF
    .IF (eax==404)
        invoke  MessageBox, hWnd, ADDR strErrorFeed404, ADDR strCurrentlyChecking, MB_OK+MB_ICONSTOP
        mov     boolDownloadInProgress, FALSE       
        mov     eax, 1
        ret
    .ENDIF
    .IF (eax==1)
        invoke  MessageBox, hWnd, ADDR strErrorGetMediaFile, ADDR AppTitle, MB_OK+MB_ICONSTOP
        mov     boolDownloadInProgress, FALSE       
        mov     eax, 1
        ret 
    .ENDIF  
    
    ;##: Find the full URL for the latest media file in the given RSS feed file
    invoke  GetNewestMediaUrl, hWnd, ADDR strFeedPath, ADDR strUrlFromFeedItem
    invoke  StringCbCopy, ADDR strUrlToGet, SIZEOF strUrlToGet, ADDR strUrlFromFeedItem

    ;##: Create a temporary filename for the download and create a full download path
    invoke  GetTempFileName, ADDR strTempDir, ADDR AppTitle, 0, ADDR strDownloadPath       

    ;##: Check to see if this URL has been downloaded previously
    invoke  CheckDownloadHistory, hWnd, ADDR strLogPath, ADDR strUrlFromFeedItem, INTERNET_MAX_URL_LENGTH    
    .IF (eax==FALSE)
        ;##: Change to a more descriptive window caption
        invoke  SetWindowText, hwndStcTitleBar, ADDR strCurrentlyChecking

        ;##: First grab a likely non-existent file to get a baseline for soft-404 detection
        invoke  GetUrlParts, ADDR strUrlToGet, ADDR strUrlHostName, ADDR strUrlPath, ADDR strUrlExtraInfo,\
                ADDR strUrlFileName, INTERNET_MAX_URL_LENGTH
        invoke  wsprintf, ADDR strBadUrlToGet, ADDR szTmpBadUrl, ADDR strUrlHostName, ADDR strUrlPath, ADDR strBadUrlSuffix                        
        invoke  GetHttpFile, hWnd, ADDR strBadUrlToGet, ADDR strDownloadPath, hwndProgressBar, ADDR dwBadFileSize
        .IF(eax==404)
            mov     dwBadFileSize, 0
        .ENDIF

        ;##: This is the call that does all the work of downloading the desired file
        invoke  GetHttpFile, hWnd, ADDR strUrlToGet, ADDR strDownloadPath, hwndProgressBar, ADDR dwGoodFileSize
        .IF (eax==1)
            invoke  SetWindowText, hwndStcTitleBar, ADDR AppTitle
            invoke  MessageBox, hWnd, ADDR strErrorGetMediaFile, ADDR AppTitle, MB_OK+MB_ICONSTOP
            mov     boolDownloadInProgress, FALSE
            mov     eax, 1
            ret             
        .ENDIF

        .IF (boolCancelDownload==TRUE)
            invoke  SetWindowText, hwndStcTitleBar, ADDR AppTitle
            mov     boolDownloadInProgress, FALSE
            mov     eax, 1
            ret            
        .ENDIF

        ;##: Now compare the file sizes between the good and bad URL's
        ;##: If they are the same then this is likely a soft-404 scenario
        mov     eax, dwBadFileSize
        mov     edx, dwGoodFileSize
        .IF (eax==edx)
            invoke  SetWindowText, hwndStcTitleBar, ADDR AppTitle
            .IF(boolManualCheck==TRUE)
                invoke  CreateThread, NULL, NULL, ADDR ShowToast, ADDR strAlertSoft404, NULL, ADDR dwToastThreadId                                   
            .ENDIF
            invoke  DeleteFile, ADDR strDownloadPath                
            mov     boolDownloadInProgress, FALSE
            xor     eax, eax
            ret
        .ENDIF        

        ;##: Check the feed's filter to see whether we want this kind of file or not
        mov     dwFilterSize, SIZEOF strFilter
        invoke  SHGetValue, dwHKEY_BRANCH, ADDR strHKLMFilters, ADDR strCurrentlyChecking, ADDR dwRegSz,\
                ADDR strFilter, ADDR dwFilterSize
        .IF(eax==ERROR_SUCCESS)
            invoke  GetFileName, ADDR strUrlToGet, ADDR strFileName, SIZEOF strFileName        
            invoke  InString, 1, ADDR strFileName, ADDR strFilter
            .IF(eax==0)
                invoke  SetWindowText, hwndStcTitleBar, ADDR AppTitle
                .IF(boolManualCheck==TRUE)
                    invoke  CreateThread, NULL, NULL, ADDR ShowToast, ADDR strAlertFileFiltered, NULL, ADDR dwToastThreadId                                   
                .ENDIF
                invoke  DeleteFile, ADDR strDownloadPath                
                mov     boolDownloadInProgress, FALSE
                xor     eax, eax
                ret        
            .ENDIF
        .ENDIF
    
        ;##: Find out where the desktop is and move the file there
        invoke  GetFileName, ADDR strUrlToGet, ADDR strFileName, SIZEOF strFileName                
        invoke  StringCbCopy, ADDR strDesktopFilePath, MAX_PATH, ADDR strDesktopPath
        invoke  StringCbCat, ADDR strDesktopFilePath, MAX_PATH, ADDR strFileName
        invoke  CopyFile, ADDR strDownloadPath, ADDR strDesktopFilePath, FALSE
        .IF (eax==0)
            invoke  SetWindowText, hwndStcTitleBar, ADDR AppTitle        
            invoke  MessageBox, hWnd, ADDR szErrMoveFile, ADDR AppTitle, MB_OK+MB_ICONSTOP
            mov     boolDownloadInProgress, FALSE
            mov     eax, 1
            ret            
        .ELSE
            ;##: Since everything was successful we can add this filename to the log and delete the temp copy
            inc     dwNewDownloads
            invoke  AddDownloadHistory, hWnd, ADDR strLogPath, ADDR strUrlFromFeedItem, INTERNET_MAX_URL_LENGTH

            ;##: Alert the user that a new download happened
            invoke  GetDateFormat, NULL, 0, ADDR systime, ADDR szDateFormat, ADDR strDate, SIZEOF strDate 
            invoke  GetTimeFormat, NULL, 0, ADDR systime, ADDR szTimeFormat, ADDR strTime, SIZEOF strTime
            invoke  ClearBuffer, ADDR strDownload, SIZEOF strDownload
            invoke  lstrlen, ADDR strDesktopPath
            .IF(eax<18)
                invoke  StringCbCopy, ADDR strDownload, 32, ADDR strDesktopPath
            .ELSE
                invoke  lstrcpyn, ADDR strDownload, ADDR strDesktopPath, 17
                invoke  StringCbCat, ADDR strDownload, SIZEOF strDownload, ADDR strEllipse
            .ENDIF
            invoke  wsprintf, ADDR strAlertNewDownload, ADDR szTmpAlertNewDownload, \
                    ADDR strCurrentlyChecking, \
                    ADDR strDate, \
                    ADDR strTime, \
                    ADDR strDownload, \
                    ADDR strFileName, \
                    ADDR dwGoodFileSize 
            .IF(boolManualCheck==TRUE)
                invoke  CreateThread, NULL, NULL, ADDR ShowToast, ADDR strAlertNewDownload, NULL, ADDR dwToastThreadId                                   
            .ELSE 
                invoke  CreateThread, NULL, NULL, ADDR ShowToast, ADDR strAlertNewDownload, NULL, ADDR dwToastThreadId                       
            .ENDIF

            ;##: Delete the copied source file            
            invoke  DeleteFile, ADDR strDownloadPath    
        .ENDIF        
    .ENDIF

    ;##: Delete any temp files we made
    invoke  DeleteFile, ADDR strDownloadPath

    ;##: Reset everything back to normal and finish
    invoke  SetWindowText, hwndStcTitleBar, ADDR AppTitle
    mov     boolDownloadInProgress, FALSE

    xor     eax, eax
    ret
GetMediaFile     endp  
;|
;|
szTemplateProgress      db      "%lu%%",0
ProgressBarWndproc  proc hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
    LOCAL   textBuffer[128]:BYTE
    LOCAL   rect:RECT
    LOCAL   hDC:DWORD
    LOCAL   hDCBackbuffer:DWORD
    LOCAL   hBmpBackbuffer:DWORD
    LOCAL   hFont:DWORD
    LOCAL   hDCDesktop:DWORD
    LOCAL   hWndDesktop:DWORD

    ;##: Prep the window
    .IF (uMsg==WM_PAINT)
        invoke  GdiSetBatchLimit, 25
    
        invoke  GetClientRect, hWnd, ADDR rect       
        invoke  GetDC, hWnd
        mov     hDC, eax

        ;##: Erase the background        
        invoke  GetStockObject, WHITE_BRUSH        
        invoke  FillRect, hDC, ADDR rect, eax
        
        invoke  ReleaseDC, hWnd, hDC        
    .ENDIF

    ;##: Let the progress bar's real wndproc do anything it needs to do
    invoke  CallWindowProc, pWndprocProgressBar, hWnd, uMsg, wParam, lParam
    push    eax

    ;##: Draw the text
    .IF (uMsg==WM_PAINT)    
        invoke  GetClientRect, hWnd, ADDR rect
        invoke  GetDC, hWnd
        mov     hDC, eax

        ;##: Get the desktop DC to make sure we get the right display caps
        invoke  GetDesktopWindow
        mov     hWndDesktop, eax
        invoke  GetDC, hWndDesktop
        mov     hDCDesktop, eax
        
        ;##: Create a backbuffer
        invoke  CreateCompatibleDC, hDCDesktop
        mov     hDCBackbuffer, eax
    
        invoke  CreateCompatibleBitmap, hDCDesktop, rect.right, rect.bottom
        mov     hBmpBackbuffer, eax
        
        invoke  SelectObject, hDCBackbuffer, hBmpBackbuffer
        mov     hBmpBackbuffer, eax        
    
        ;##: Set up the font
        invoke  SelectObject, hDCBackbuffer, hFont16
        mov     hFont, eax        

        ;##: Set the foreground and background properties
        invoke  SetTextColor, hDCBackbuffer, 0ffffffh
        invoke  SetBkColor, hDCBackbuffer, 0000000h

        ;##: Erase the background
        ;invoke  GetStockObject, BLACK_BRUSH        
        ;invoke  FillRect, hDC, ADDR rect, eax
        
        ;##: Calculate percentage and draw it
        invoke  SendMessage, hWnd, PBM_GETPOS, NULL, NULL
        invoke  wsprintf, ADDR textBuffer, ADDR szTemplateProgress, eax
        invoke  lstrlen, ADDR textBuffer
        lea     edx, rect
        invoke  DrawTextEx, hDCBackbuffer, ADDR textBuffer, eax, edx, DT_CENTER+DT_SINGLELINE+DT_VCENTER, NULL
        invoke  BitBlt, hDC, 0, 0, rect.right, rect.bottom, hDCBackbuffer, 0, 0, SRCINVERT
    
        ;##: Clean up
        invoke  SelectObject, hDCBackbuffer, hFont
        invoke  SelectObject, hDCBackbuffer, hBmpBackbuffer
        invoke  DeleteObject, eax
        invoke  DeleteDC, hDCBackbuffer
        invoke  ReleaseDC, hWnd, hDC
        invoke  GdiFlush
    .ENDIF

    pop     eax
    ret
ProgressBarWndproc endp
;|
;|
szErrLogCouldntOpen     db  "Error opening log file for checking: CheckDownloadHistory(CreateFile)",0
szErrLogCouldntMap      db  "Error mapping log file into memory: CheckDownloadHistory(CreateFileMapping)",0
szErrLogCouldntPoint    db  "Error getting a pointer to mapped file: CheckDownloadHistory(MapViewOfFile)",0
szErrLogBadSearch       db  "Error searching the log file: CheckDownloadHistory(InString)",0
CheckDownloadHistory    proc    hWnd:DWORD,pLogFile:DWORD,pCheckFor:DWORD,dwCheckForLength:DWORD
    LOCAL   hFile:DWORD
    LOCAL   hMap:DWORD
    LOCAL   pMap:DWORD
    LOCAL   dwRetVal:DWORD
    LOCAL   dwFileSize:DWORD
    LOCAL   dwBufferLength:DWORD


    ;##: Open the file for mapping
    invoke  CreateFile, pLogFile, GENERIC_READ+GENERIC_WRITE, 0, NULL, OPEN_ALWAYS, NULL, NULL
    .IF (eax==INVALID_HANDLE_VALUE)
        invoke      MessageBox, hWnd, ADDR szErrLogCouldntOpen, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        mov         eax, TRUE
        ret
    .ENDIF
    mov     hFile, eax
    invoke  GetLastError
    .IF (eax==0)  ;##: That means the file was created by the CreateFile call
        invoke  CloseHandle, hFile
        mov     eax, FALSE
        ret
    .ENDIF

    ;##: Make sure file size isn't less than the size of what to check for
    invoke  GetFileSize, hFile, NULL
    push    eax
    mov     dwFileSize, eax
    invoke  StringCbLength, pCheckFor, dwCheckForLength, ADDR dwBufferLength
    mov     eax, dwBufferLength
    pop     edx
    .IF (eax>edx)
        invoke  CloseHandle, hFile
        mov     eax, FALSE
        ret        
    .ENDIF    

    ;##: Map the file and get a pointer
    invoke  CreateFileMapping, hFile, NULL, PAGE_READONLY, NULL, NULL, NULL
    .IF (eax==NULL)
        invoke      CloseHandle, hFile
        invoke      MessageBox, hWnd, ADDR szErrLogCouldntMap, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        mov         eax, TRUE
        ret
    .ENDIF
    mov     hMap, eax
    invoke  MapViewOfFile, hMap, FILE_MAP_READ, NULL, NULL, NULL
    .IF (eax==NULL)
        invoke      CloseHandle, hMap    
        invoke      CloseHandle, hFile    
        invoke      MessageBox, hWnd, ADDR szErrLogCouldntPoint, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        mov         eax, TRUE
        ret
    .ENDIF
    mov     pMap, eax

    ;##: Now search for the filename in the log file
    invoke  BinSearch, 0, pMap, dwFileSize, pCheckFor, dwBufferLength
    .IF (eax==-1)
        mov     dwRetVal, FALSE
    .ELSEIF (eax>=0)
        mov     dwRetVal, TRUE
    .ENDIF      
            
    ;##: Cleanup open handles
    invoke  UnmapViewOfFile, pMap
    invoke  CloseHandle, hMap  
    invoke  CloseHandle, hFile          

    mov     eax, dwRetVal
    ret
CheckDownloadHistory    endp  
;|
;|
szErrLogCouldntWrite    db  "Error writing to the log file: AddDownloadHistory(WriteFile)",0
AddDownloadHistory      proc    hWnd:DWORD,pLogFile:DWORD,pFileName:DWORD,dwFileNameLength:DWORD
    LOCAL   hFile:DWORD
    LOCAL   dwLogBytesWritten:DWORD
    LOCAL   dwFileNameSize:DWORD
    LOCAL   strLogEntry[MAX_PATH]:BYTE
    LOCAL   dwTicks:DWORD
    LOCAL   dwLogEntryLength:DWORD

    invoke  CreateFile, pLogFile, GENERIC_WRITE, 0, NULL, OPEN_ALWAYS, NULL, NULL
    .IF (eax==INVALID_HANDLE_VALUE)    
        invoke  MessageBox, hWnd, ADDR szErrLogCouldntOpen, ADDR AppTitle, MB_OK+MB_ICONSTOP
        mov     eax, 1
        ret
    .ENDIF
    mov     hFile, eax

    invoke  GetTickCount
    mov     dwTicks, eax
    invoke  dwtoa, dwTicks, ADDR strLogEntry
    invoke  StringCbCopy, ADDR strLogEntry, MAX_PATH, ADDR strLogFrameOpen
    invoke  StringCbCat, ADDR strLogEntry, MAX_PATH, pFileName
    invoke  StringCbCat, ADDR strLogEntry, MAX_PATH, ADDR strLogFrameClose

    invoke  StringCbLength, ADDR strLogEntry, MAX_PATH, ADDR dwLogEntryLength
    invoke  SetFilePointer, hFile, 0, NULL, FILE_END

    invoke  WriteFile, hFile, ADDR strLogEntry, dwLogEntryLength, ADDR dwLogBytesWritten, NULL
    .IF (eax==0)  
        invoke  CloseHandle, hFile      
        invoke  MessageBox, hWnd, ADDR szErrLogCouldntWrite, ADDR AppTitle, MB_OK+MB_ICONSTOP
        mov     eax, 1
        ret
    .ENDIF

    invoke  CloseHandle, hFile

    xor     eax, eax
    ret
AddDownloadHistory      endp
;|
;|
CheckForUpdate      proc    hWnd:DWORD
    LOCAL   hKeyFeeds:DWORD
    LOCAL   dwKeyIndex:DWORD
    LOCAL   strFeedName[128]:BYTE
    LOCAL   dwFeedNameSize:DWORD
    LOCAL   dwFeedKeyType:DWORD
    LOCAL   dwReturnValue:DWORD
    LOCAL   dwLocalThreadId:DWORD
    LOCAL   hLocalThread:DWORD
    LOCAL   dwStoragePathSize:DWORD
    LOCAL   strStoragePath[MAX_PATH]:BYTE
    LOCAL   dwValidFeeds:DWORD


    mov     boolCancelDownload, FALSE
    
    ;##: If this is W2k or above then we need to call SetThreadExecutionState to make sure the computer doesn't go to sleep
    .IF (osv.dwMajorVersion>=5)
        invoke  SetThreadExecutionState, ES_CONTINUOUS+ES_SYSTEM_REQUIRED
    .ENDIF    

    mov     dwNewDownloads, 0
    mov     dwValidFeeds, 0
    .IF (boolDownloadInProgress==FALSE)
        invoke  RegOpenKeyEx, dwHKEY_BRANCH, ADDR strHKLMFeeds, 0, KEY_ALL_ACCESS, ADDR hKeyFeeds
        .IF(eax!=ERROR_SUCCESS)
            mov     dwReturnValue, ERROR_NO_MORE_ITEMS
        .ELSE 
            mov     dwKeyIndex, 0
            mov     dwReturnValue, ERROR_SUCCESS
        .ENDIF
        
        .WHILE(dwReturnValue!=ERROR_NO_MORE_ITEMS)
            mov     dwFeedNameSize, SIZEOF strFeedName
            mov     dwFeedUrlSize, SIZEOF strFeedUrl        
            invoke  RegEnumValue, hKeyFeeds, dwKeyIndex, ADDR strFeedName, ADDR dwFeedNameSize, NULL, ADDR dwFeedKeyType,\
                    ADDR strFeedUrl, ADDR dwFeedUrlSize
            mov     dwReturnValue, eax

            ;##: Check for a registry defined place to store downloads other than the desktop
            mov     dwStoragePathSize, MAX_PATH
            invoke  SHGetValue, dwHKEY_BRANCH, ADDR strHKLMStorageDirs, ADDR strFeedName, ADDR dwRegSz,\
                    ADDR strStoragePath, ADDR dwStoragePathSize
            .IF(eax==ERROR_SUCCESS)
                invoke  StringCbCopy, ADDR strDesktopPath, SIZEOF strDesktopPath, ADDR strStoragePath
            .ELSE
                invoke  SHGetSpecialFolderPath, NULL, ADDR strDesktopPath, CSIDL_DESKTOPDIRECTORY, 0 
                invoke  PathAddBackslash, ADDR strDesktopPath
            .ENDIF
           
            .IF((dwFeedUrlSize>12) && (dwReturnValue!=ERROR_NO_MORE_ITEMS))
                inc     dwValidFeeds
                invoke  StringCbCopy, ADDR strCurrentlyChecking, SIZEOF strCurrentlyChecking, ADDR strFeedName
                invoke  GetSystemTime, ADDR systime             
                invoke  CreateThread, NULL, NULL, ADDR GetMediaFile, hWnd, NULL, ADDR dwLocalThreadId
                mov     hLocalThread, eax            
                invoke  WaitForSingleObject, hLocalThread, dwDownloadTimeout
            .ENDIF

            .BREAK .IF (boolCancelDownload==TRUE)

            inc     dwKeyIndex
        .ENDW

        .IF(dwValidFeeds==0)
            invoke  CreateThread, NULL, NULL, ADDR ShowToast, ADDR strErrNoFeedsFound, NULL, ADDR dwToastThreadId       
        .ENDIF

        invoke  RegCloseKey, hKeyFeeds           
    .ENDIF    

    ;##: Alert the user that nothing new was found since they manually asked us to check
    .IF((boolManualCheck==TRUE) && (dwNewDownloads==0))
        invoke  CreateThread, NULL, NULL, ADDR ShowToast, ADDR strAlertNoNewDownload, NULL, ADDR dwToastThreadId                            
    .ENDIF

    ;##: Reset the manual check flag
    mov     boolManualCheck, FALSE

    ;##: If this is W2k or above now we unset the thread execution state flag
    .IF (osv.dwMajorVersion>=5)
        invoke  SetThreadExecutionState, ES_CONTINUOUS
    .ENDIF    

    xor     eax, eax
    ret
CheckForUpdate      endp
;|
;|
szInstallScriptName     db  "podwrngi.bat",0
szInstallScriptTemplate db  "@echo off",0dh,0ah
                        db  "echo Installing %s ...",0dh,0ah
                        db  ":INSTALL",0dh,0ah
                        db  "PING 1.1.1.1 -n 5 -w 1000 >NUL",0dh,0ah
                        db  "move /Y ",022h,"%s",022h," ",022h,"%s",022h,0dh,0ah
                        db  "IF ERRORLEVEL 1 GOTO INSTALL",0dh,0ah
                        db  "start ",022h," ",022h," ",022h,"%s",022h,0dh,0ah
                        db  "@cls",0dh,0ah
                        db  "exit",0dh,0ah,0
Install     proc    hWnd:DWORD, pTempDir:DWORD, pFromPath:DWORD, pToPath:DWORD
    LOCAL   hFile:DWORD
    LOCAL   dwBytesWritten:DWORD
    LOCAL   strScriptBuffer[4096]:BYTE
    LOCAL   strScriptPath[MAX_PATH]:BYTE
    LOCAL   dwScriptLen:DWORD


    ;##: Clear the script buffer
    invoke  ClearBuffer, ADDR strScriptBuffer, SIZEOF strScriptBuffer

    ;##: Create a temporary path for the installer script
    invoke  StringCbCopy, ADDR strScriptPath, MAX_PATH, pTempDir
    invoke  PathAddBackslash, ADDR strScriptPath
    invoke  StringCbCat, ADDR strScriptPath, MAX_PATH, ADDR szInstallScriptName

    ;##: Create the installer batch file
    invoke  CreateFile, ADDR strScriptPath, GENERIC_READ+GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
    .IF (eax==INVALID_HANDLE_VALUE)
        mov     eax, -1
        ret
    .ENDIF
    mov     hFile, eax

    ;##: Construct installer script
    invoke  wsprintf, ADDR strScriptBuffer, ADDR szInstallScriptTemplate, ADDR AppName, pFromPath, pToPath, pToPath

    ;##: Determine length
    invoke  StringCbLength, ADDR strScriptBuffer, 4096, ADDR dwScriptLen

    ;##: Write the data into the file
    invoke  WriteFile, hFile, ADDR strScriptBuffer, dwScriptLen, ADDR dwBytesWritten, NULL
    .IF (eax==FALSE)
        invoke  CloseHandle, hFile
        mov     eax, -1
        ret
    .ENDIF

    ;##: Close the file
    invoke  CloseHandle, hFile

    ;##: Start the installation
    ;##: Once this thing starts the main process exits and leaves total control in the hands of the batch file.  are you feeling lucky?!
    invoke  ShellExecute, hWnd, NULL, ADDR strScriptPath, NULL, pTempDir, SW_SHOWNORMAL
    

    ret
Install     endp
;|
;|
szUninstallScriptName       db  "podwrngu.bat",0
szUninstallScriptTemplate   db  "@echo off",0dh,0ah
                            db  "echo Uninstalling...",0dh,0ah
                            db  ":UNINSTALL",0dh,0ah
                            db  "PING 1.1.1.1 -n 5 -w 1000 >NUL",0dh,0ah
                            db  "del ",022h,"%s",022h,0dh,0ah
                            db  "IF ERRORLEVEL 1 GOTO UNINSTALL",0dh,0ah
                            db  "echo.%s is now uninstalled.",0dh,0ah
                            db  "pause",0dh,0ah
                            db  "@cls",0dh,0ah
                            db  "exit",0dh,0ah,0
Uninstall     proc    hWnd:DWORD, pTempDir:DWORD, pFromPath:DWORD
    LOCAL   hFile:DWORD
    LOCAL   dwBytesWritten:DWORD
    LOCAL   strScriptBuffer[4096]:BYTE
    LOCAL   strScriptPath[MAX_PATH]:BYTE
    LOCAL   dwScriptLen:DWORD

    ;//Clear the script buffer
    invoke  ClearBuffer, ADDR strScriptBuffer, SIZEOF strScriptBuffer

    ;##: Create a temporary path for the uninstaller script
    invoke  StringCbCopy, ADDR strScriptPath, MAX_PATH, pTempDir
    invoke  StringCbCat, ADDR strScriptPath, MAX_PATH, ADDR szInstallScriptName

    ;//Create the uninstaller batch file
    invoke  CreateFile, ADDR strScriptPath, GENERIC_READ+GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
    .IF (eax==INVALID_HANDLE_VALUE)
        mov     eax, -1
        ret
    .ENDIF
    mov     hFile, eax

    ;//Construct uninstaller script
    invoke  wsprintf, ADDR strScriptBuffer, ADDR szUninstallScriptTemplate, pFromPath, ADDR AppName

    ;//Determine length
    invoke  StringCbLength, ADDR strScriptBuffer, 4096, ADDR dwScriptLen

    ;//Write the data into the file
    invoke  WriteFile, hFile, ADDR strScriptBuffer, dwScriptLen, ADDR dwBytesWritten, NULL
    .IF (eax==FALSE)
        invoke  CloseHandle, hFile
        mov     eax, -1
        ret
    .ENDIF

    ;//Close the file
    invoke  CloseHandle, hFile

    ;//Start the installation
    ;//Once this thing starts the main process exits and leaves total control in the hands of the batch file.  are you feeling lucky?!
    invoke  ShellExecute, hWnd, NULL, ADDR strScriptPath, NULL, pTempDir, SW_SHOWNORMAL
    

    ret
Uninstall     endp
;|
;|
szDownloadingUpgrade    db  "Downloading upgrade...",0
szNewerVersionFound     db  "A newer version of PodWrangler(%s) is available.",0dh,0ah
                        db  "Would you like to download it?",0                        
GetUpgradeFile  proc    hWnd:DWORD
    LOCAL   strTempFeedPath[MAX_PATH]:BYTE
    LOCAL   strUpgradeFileName[MAX_PATH]:BYTE
    LOCAL   strUpgradeFilePath[MAX_PATH]:BYTE
    LOCAL   strNewestVersion[64]:BYTE
    LOCAL	strNewVersionNotice[256]:BYTE

    ;##: Flag the rest of the program that a download is in progress
    mov     boolDownloadInProgress, TRUE

    ;##: Reset the main window if it had been moved around
    invoke  SetMainWindowPosition, hWnd

    ;##: Download a fresh copy of the evolver feed file
    invoke  GetTempFileName, ADDR strTempDir, ADDR AppTitle, 0, ADDR strTempFeedPath
    invoke  GetHttpFile, hWnd, ADDR strEvolveCheckUrl, ADDR strTempFeedPath, NULL, NULL
    .IF (eax==1)
        invoke  MessageBox, hWnd, ADDR strErrorGetUpgradeFile, ADDR AppTitle, MB_OK+MB_ICONSTOP
        invoke  DeleteFile, ADDR strTempFeedPath        
        mov     boolDownloadInProgress, FALSE
        mov     boolManualCheck, FALSE       
        mov     eax, 1
        ret 
    .ENDIF

    ;##: Find out what the latest version is in the upgrade feed file and see if our's is older
    invoke  GetNewestVersionInfo, hWnd, ADDR strTempFeedPath, ADDR strNewestVersion
    .IF (eax==1)
        .IF(boolManualCheck==TRUE)
            invoke  CreateThread, NULL, NULL, ADDR ShowToast, ADDR strNoNewVersionFound, NULL, ADDR dwToastThreadId        
        .ENDIF
        invoke  DeleteFile, ADDR strTempFeedPath        
        mov     boolDownloadInProgress, FALSE
        mov     boolManualCheck, FALSE               
        mov     eax, 1
        ret
    .ENDIF        

    ;##: Turn the extracted version string into a number and compare it to our own  
    invoke  atodw, ADDR strNewestVersion
    .IF (eax<=dwAppVersion)
        ;##: We are running either the same or a newer version than the server has
        .IF(boolManualCheck==TRUE)        
            invoke  CreateThread, NULL, NULL, ADDR ShowToast, ADDR strNoNewVersionFound, NULL, ADDR dwToastThreadId
        .ENDIF
        invoke  DeleteFile, ADDR strTempFeedPath        
        mov     boolDownloadInProgress, FALSE
        mov     boolManualCheck, FALSE               
        mov     eax, 1
        ret        
    .ENDIF
    invoke	wsprintf, ADDR strNewVersionNotice, ADDR szNewerVersionFound, ADDR strNewestVersion
    invoke  MessageBox, hWnd, ADDR strNewVersionNotice, ADDR AppTitle, MB_YESNO+MB_ICONINFORMATION
    .IF (eax==IDNO)
        invoke  DeleteFile, ADDR strTempFeedPath        
        mov     boolDownloadInProgress, FALSE
        mov     boolManualCheck, FALSE               
        mov     eax, 1
        ret
    .ENDIF    
        
    ;##: Find the full URL for the latest upgrade file in the downloaded feed
    invoke  GetNewestMediaUrl, hWnd, ADDR strTempFeedPath, ADDR strUrlToGet
    
    ;##: Debug
    ;invoke	MessageBox, hWnd, ADDR strTempFeedPath, ADDR AppTitle, MB_OK
    ;invoke	MessageBox, hWnd, ADDR strUrlToGet, ADDR AppTitle, MB_OK

    ;##: Extract the filename from the returned URL and create a full download path
    invoke  GetFileName, ADDR strUrlToGet, ADDR strUpgradeFileName, SIZEOF strUpgradeFileName
    invoke  StringCbCopy, ADDR strUpgradeFilePath, MAX_PATH, ADDR strTempDir    
    invoke  StringCbCat, ADDR strUpgradeFilePath, MAX_PATH, ADDR strUpgradeFileName

    ;##: This is the call that does all the work of downloading the desired file
    invoke  SetWindowText, hwndStcTitleBar, ADDR szDownloadingUpgrade
    invoke  GetHttpFile, hWnd, ADDR strUrlToGet, ADDR strUpgradeFilePath, hwndProgressBar, NULL
    .IF (eax==1)
        invoke  SetWindowText, hwndStcTitleBar, ADDR AppTitle
        invoke  MessageBox, hWnd, ADDR strErrorGetUpgradeFile, ADDR AppTitle, MB_OK+MB_ICONSTOP
        invoke  DeleteFile, ADDR strTempFeedPath        
        mov     boolDownloadInProgress, FALSE
        mov     boolManualCheck, FALSE        
        mov     eax, 1
        ret             
    .ELSE
        invoke  DeleteFile, ADDR strTempFeedPath    
        invoke  Install, hWnd, ADDR strWindowsDir, ADDR strUpgradeFilePath, ADDR strMyPath
        invoke  SendMessage, hWnd, WM_DESTROY, NULL, NULL        
    .ENDIF
        
    ;##: Reset everything back to normal and finish
    invoke  DeleteFile, ADDR strTempFeedPath
    invoke  SetWindowText, hwndStcTitleBar, ADDR AppTitle
    mov     boolDownloadInProgress, FALSE
    mov     boolManualCheck, FALSE

    xor     eax,eax
    ret
GetUpgradeFile  endp
;|
;|
GetNewestVersionInfo  proc    hWnd:DWORD,pFileName:DWORD,pVersion:DWORD
    LOCAL   hFile:DWORD
    LOCAL   dwFileSize:DWORD
    LOCAL   hMap:DWORD
    LOCAL   pMap:DWORD
    LOCAL   pStartTitle:DWORD
    LOCAL   pStartVersion:DWORD
    LOCAL   dwVersionLength:DWORD
    LOCAL   pStartItem:DWORD

    ;##: Open the file for mapping
    invoke  CreateFile, pFileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, NULL, NULL
    .IF (eax==INVALID_HANDLE_VALUE)
        invoke      MessageBox, hWnd, ADDR szErrFileCouldntOpen, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        invoke      MessageBox, hWnd, pFileName, ADDR strErrorFileRead, MB_OK+MB_ICONINFORMATION        
        mov         eax, 1
        ret
    .ENDIF
    mov     hFile, eax

    ;##: Get its size
    invoke  GetFileSize, hFile, NULL
    mov     dwFileSize, eax

    ;##: Map the file and get a pointer
    invoke  CreateFileMapping, hFile, NULL, PAGE_READONLY, NULL, NULL, NULL
    .IF (eax==NULL)
        invoke      CloseHandle, hFile
        invoke      MessageBox, hWnd, ADDR szErrFileCouldntMap, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        mov         eax, 1
        ret
    .ENDIF
    mov     hMap, eax
    invoke  MapViewOfFile, hMap, FILE_MAP_READ, NULL, NULL, NULL
    .IF (eax==NULL)
        invoke      CloseHandle, hMap    
        invoke      CloseHandle, hFile    
        invoke      MessageBox, hWnd, ADDR szErrFileCouldntPoint, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        mov         eax, 1
        ret
    .ENDIF
    mov     pMap, eax

    ;##: If we can't find the <active/> boolean tag then we should just bail
    ;invoke  InString, 1, pMap, ADDR strActiveTag
    invoke	lstrlen, ADDR strActiveTag
    invoke  BinSearch, 0, pMap, dwFileSize, ADDR strActiveTag, eax      
    .IF (eax==-1)
        invoke      UnmapViewOfFile, pMap    
        invoke      CloseHandle, hMap    
        invoke      CloseHandle, hFile
        mov         eax, 1
        ret        
    .ENDIF

    ;##: First we have to find the newest <item> in the RSS feed    
    ;invoke  InString, 1, pMap, ADDR strItemTagOpen
    invoke	lstrlen, ADDR strItemTagOpen
    invoke  BinSearch, 0, pMap, dwFileSize, ADDR strItemTagOpen, eax      
    .IF (eax!=-1)
    	sub			dwFileSize, eax
        add         eax, pMap
        mov         pStartItem, eax
        invoke      lstrlen, ADDR strItemTagOpen
        add         pStartItem, eax
        sub			dwFileSize, eax
    .ELSE
        invoke      UnmapViewOfFile, pMap    
        invoke      CloseHandle, hMap    
        invoke      CloseHandle, hFile    
        invoke      MessageBox, hWnd, ADDR szErrFileParseFeedItemOpen, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        mov         eax, 1
        ret
    .ENDIF    

    ;##: Now search for the tag in the feed file that gives the version string
    ;invoke  InString, 1, pStartItem, ADDR strTitleTagOpen
    invoke	lstrlen, ADDR strTitleTagOpen
    invoke  BinSearch, 0, pStartItem, dwFileSize, ADDR strTitleTagOpen, eax      
    .IF (eax!=-1)
		sub			dwFileSize, eax
        add         eax, pStartItem
        mov         pStartTitle, eax
        mov         pStartVersion, eax
        invoke      lstrlen, ADDR strTitleTagOpen
        add         pStartVersion, eax
        sub			dwFileSize, eax
    .ELSE
        invoke      UnmapViewOfFile, pMap    
        invoke      CloseHandle, hMap    
        invoke      CloseHandle, hFile    
        invoke      MessageBox, hWnd, ADDR szErrFileParseFeedTitleOpen, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        mov         eax, 1
        ret
    .ENDIF

    ;##: Now extract the version string from between the title tags
    ;invoke  InString, 1, pStartVersion, ADDR strTitleTagClose
    invoke	lstrlen, ADDR strTitleTagClose
    invoke  BinSearch, 0, pStartVersion, dwFileSize, ADDR strTitleTagClose, eax      
    .IF (eax!=-1)
    	inc			eax			;##: 1-based because we need length instead of position
        mov         dwVersionLength, eax
        invoke      lstrcpyn, pVersion, pStartVersion, dwVersionLength
    .ELSE
        invoke      UnmapViewOfFile, pMap    
        invoke      CloseHandle, hMap    
        invoke      CloseHandle, hFile    
        invoke      MessageBox, hWnd, ADDR szErrFileParseFeedTitleClose, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        mov         eax, 2
        ret
    .ENDIF                
 
    ;##: Cleanup open handles
    invoke  UnmapViewOfFile, pMap
    invoke  CloseHandle, hMap  
    invoke  CloseHandle, hFile      

    xor     eax, eax
    ret
GetNewestVersionInfo  endp
;|
;|
EnableAutoRun   proc
    LOCAL   dwStringLen:DWORD
    LOCAL   strOpenValue[MAX_PATH]:BYTE

    ;##: Create the appropriate paths
    invoke  StringCbCopy, ADDR strStartupFolderPath, SIZEOF strStartupFolderPath, ADDR strWindowsDir
    invoke  PathAddBackslash, ADDR strStartupFolderPath
    invoke  StringCbCat, ADDR strStartupFolderPath, SIZEOF strStartupFolderPath, ADDR ModuleName

    ;##: Put the program in the current user run key in the reg    
    invoke  StringCbLength, ADDR strStartupFolderPath, SIZEOF strStartupFolderPath, ADDR dwStringLen    
    invoke  SHSetValue, HKEY_CURRENT_USER, ADDR strHKCURun, ADDR strRunValue, REG_SZ,\
            ADDR strStartupFolderPath, dwStringLen

    ;invoke  MessageBox, NULL, ADDR strMyPath, ADDR strCDrive, MB_OK
    ;invoke  MessageBox, NULL, ADDR strStartupFolderPath, ADDR strWindowsDir, MB_OK    

    invoke  lstrcmpi, ADDR strStartupFolderPath, ADDR strMyPath
    .IF (eax!=0)
        ;##: Call out to install and cross your fingers
        invoke  Install, NULL, ADDR strWindowsDir, ADDR strMyPath, ADDR strStartupFolderPath
    .ELSE
        mov     eax, 1
        ret
    .ENDIF

    xor     eax,eax
    ret
EnableAutoRun   endp
;|
;|
szTmpPcastHandler       db  022h,"%s",022h," /open ",022h,"%s",022h,0
EnablePcastHandler  proc
    LOCAL   dwStringLen:DWORD
    LOCAL   strOpenValue[MAX_PATH]:BYTE

    ;##: Create the appropriate paths
    invoke  StringCbCopy, ADDR strStartupFolderPath, SIZEOF strStartupFolderPath, ADDR strWindowsDir
    invoke  PathAddBackslash, ADDR strStartupFolderPath
    invoke  StringCbCat, ADDR strStartupFolderPath, SIZEOF strStartupFolderPath, ADDR ModuleName

    ;##: Set the value for the open command in a custom key
    invoke  wsprintf, ADDR strOpenValue, ADDR szTmpPcastHandler, ADDR strStartupFolderPath, ADDR strPercentOne
    invoke  StringCbLength, ADDR strOpenValue, MAX_PATH, ADDR dwStringLen
    invoke  SHSetValue, HKEY_CLASSES_ROOT, ADDR strHKCRPcastHandler, NULL, REG_SZ,\
            ADDR strOpenValue, dwStringLen

    ;##: Now set the pcast extension to reference that custom key
    invoke  StringCbLength, ADDR strPcastHandlerValue, SIZEOF strPcastHandlerValue, ADDR dwStringLen
    invoke  SHSetValue, HKEY_CLASSES_ROOT, ADDR strPcastExtension, NULL, REG_SZ,\
            ADDR strPcastHandlerValue, dwStringLen
            
    xor     eax,eax
    ret
EnablePcastHandler  endp
;|
;|
szErrMsgRemovingAutorun     db      "Error removing the autorun registry setting.",0
DisableAutoRun   proc
    LOCAL   dwStringLen:DWORD

    ;##: Put the program in the current user run key in the reg       
    invoke  SHDeleteValue, HKEY_CURRENT_USER, ADDR strHKCURun, ADDR strRunValue    
    .IF (eax!=ERROR_SUCCESS)
        invoke  MessageBox, NULL, ADDR szErrMsgRemovingAutorun, ADDR AppName, MB_OK+MB_ICONSTOP
        mov     eax, 1
        ret
    .ENDIF

    xor     eax,eax
    ret
DisableAutoRun   endp
;|
;|
SetMainWindowPosition   proc    hWnd:DWORD
    LOCAL   dwScreenWidth:DWORD
    LOCAL   dwScreenHeight:DWORD
    LOCAL   abd:APPBARDATA
    LOCAL   dwWinPosX:DWORD
    LOCAL   dwWinPosY:DWORD
    

    ;##: Make this a toolwindow so we don't show a taskbar button
    invoke  SetWindowLong, hWnd, GWL_EXSTYLE, WS_EX_TOOLWINDOW

    ;##: Make the corners transparent
    invoke  CreateRoundRectRgn, 0, 0, dwMainWidth, dwMainHeight, 12, 12
    invoke  SetWindowRgn, hWnd, eax, TRUE

    ;##: Trigger a repaint
    invoke  UpdateWindow, hWnd

    ;##: Move the window to the bottom right corner by the system tray
    invoke  GetDesktopWindow
    push    eax
    invoke  GetWindowDC, eax
    push    eax
    invoke  GetDeviceCaps, eax, HORZRES
    mov     dwScreenWidth, eax
    pop     eax
    push    eax
    invoke  GetDeviceCaps, eax, VERTRES
    mov     dwScreenHeight, eax
    pop     eax
    pop     edx
    invoke  ReleaseDC, edx, eax
    mov     abd.cbSize, SIZEOF abd
    push    hWnd
    pop     abd.hwnd
    invoke  SHAppBarMessage, ABM_GETTASKBARPOS, ADDR abd
    mov     eax, abd.rc.top
    sub     eax, dwMainHeight
    sub     eax, 1
    mov     edx, abd.rc.right
    sub     edx, dwMainWidth
    sub     edx, 1
    mov     dwWinPosX, edx
    mov     dwWinPosY, eax
    invoke  SetWindowPos, hWnd, HWND_TOPMOST, dwWinPosX, dwWinPosY, dwMainWidth, dwMainHeight, NULL

    ;##: Change the title bar
    invoke  MoveWindow, hwndStcTitleBar, 27, 7, 170, 20, TRUE    
    invoke  SetWindowText, hwndStcTitleBar, ADDR AppTitle

    ;##: Make sure the progress bar is visible
    invoke  ShowWindow, hwndProgressBar, SW_SHOW

    ;##: Make sure the cancel button is visible
    invoke  MoveWindow, hwndBtnCancelOperation, 8, 7, 15, 15, TRUE    
    invoke  ShowWindow, hwndBtnCancelOperation, SW_SHOW

    xor     eax,eax
    ret
SetMainWindowPosition   endp
;|
;|
szTitleManageFeeds  db  " - Manage feeds...",0
szbtnDelFeed        db  "Delete Feed",0
szbtnAddFeed        db  "Add Feed",0
szbtnFinish         db  "Finished",0
szLVIFeedName       db  "Feed Name:",0
szLVIFeedUrl        db  "Feed Url:",0
szLVIFeedStorageDir db  "Download Dir:",0
szLVIFeedFilter     db  "Filter:",0
szbtnEditStorageDir db  "Change Dir.",0
szbtnEditFeed       db  "Edit Url",0
szbtnEditFilter     db  "Edit Filter",0
ShowFeedListWindow  proc    hWnd:DWORD,hProgressBar:DWORD
    LOCAL   hwndDesktop:DWORD
    LOCAL   wrect:RECT
    LOCAL   lvc:LV_COLUMN
    LOCAL   lvi:LV_ITEM   
    LOCAL   hKeyFeeds:DWORD
    LOCAL   dwKeyIndex:DWORD
    LOCAL   strFeedName[128]:BYTE
    LOCAL   dwFeedNameSize:DWORD
    LOCAL   dwFeedKeyType:DWORD
    LOCAL   dwReturnValue:DWORD
    LOCAL   dwLVIndex:DWORD
    LOCAL   strTitleBar[255]:BYTE
    LOCAL   strStorageDir[MAX_PATH]:BYTE
    LOCAL   dwStorageDirSize:DWORD
    LOCAL   strFilter[MAX_PATH]:BYTE
    LOCAL   dwFilterSize:DWORD    


    ;##: Make sure we won't be disturbed
    mov     boolDownloadInProgress, TRUE

    ;##: Make this just a normal window, not a toolwindow
    invoke  SetWindowLong, hWnd, GWL_EXSTYLE, NULL

    ;##: Make the corners transparent
    invoke  CreateRoundRectRgn, 0, 0, 640, 480, 12, 12
    invoke  SetWindowRgn, hWnd, eax, TRUE

    ;##: Trigger a repaint
    invoke  UpdateWindow, hWnd

    ;##: Center the window and adjust it's size
    invoke  GetDesktopWindow
    mov     hwndDesktop, eax
    invoke  GetClientRect, hwndDesktop, ADDR wrect
    mov     edx, 0
    mov     eax, wrect.right
    push    ebx
    mov     ebx, 2
    div     ebx
    pop     ebx
    sub     eax, 320
    push    eax
    mov     edx, 0
    mov     eax, wrect.bottom
    push    ebx
    mov     ebx, 2
    div     ebx
    pop     ebx
    sub     eax, 240
    push    eax     
    ;| Now we put the xpos in edx and ypos in eax
    pop     eax     
    pop     edx     
    invoke  SetWindowPos, hWnd, HWND_BOTTOM, edx, eax, 640, 480, NULL

    ;##: Change the title bar
    invoke  MoveWindow, hwndStcTitleBar, 8, 7, 600, 20, TRUE    
    invoke  StringCbCopy, ADDR strTitleBar, 255, ADDR AppTitle
    invoke  StringCbCat, ADDR strTitleBar, 255, ADDR szTitleManageFeeds
    invoke  SetWindowText, hwndStcTitleBar, ADDR strTitleBar

    ;##: Hide the progress bar
    invoke  ShowWindow, hProgressBar, SW_HIDE  

    ;##: Hide the cancel button
    invoke  ShowWindow, hwndBtnCancelOperation, SW_HIDE      

    ;##: Create the controls needed to manage the feed list
    invoke  CreateWindowEx, NULL, ADDR ClassStatic, ADDR strChangeIntervalLabel,\       ;| Interval change static label
            WS_CHILD+WS_VISIBLE+SS_LEFT,8,402,200,20,hWnd,NULL,hInstance,NULL
    mov     hwndStcChangeIntervalLabel, eax
    invoke  SendMessage, hwndStcChangeIntervalLabel, WM_SETFONT, hFont16, NULL

    invoke  CreateWindowEx, WS_EX_CLIENTEDGE, ADDR ClassEdit, \                         ;| UpDown buddy edit box
            NULL, WS_CHILD+WS_VISIBLE+ES_NUMBER, 140, 401, 39, 22, \ 
            hWnd, NULL, hInstance, NULL
    mov     hwndEdtChangeInterval, eax    
    invoke  CreateUpDownControl, WS_CHILD+WS_BORDER+WS_VISIBLE+UDS_ALIGNRIGHT+UDS_SETBUDDYINT,\ ;| UpDown control for interval
            8, 410, 10, 10, hWnd, CID_UPD_CHANGEINTERVAL, hInstance, \
            hwndEdtChangeInterval, MAX_CHECK_INTERVAL, \
            MIN_CHECK_INTERVAL, dwCheckInterval
    mov     hwndUpdChangeInterval, eax
    invoke  SendMessage, hwndEdtChangeInterval, EM_SETBKGNDCOLOR, 0, 00ffffffh

    invoke  CreateWindowEx, NULL, ADDR ClassButton, \               ;| Delete feed button
            ADDR szbtnDelFeed, WS_CHILD+WS_VISIBLE+WS_DISABLED, 541, 401, 90, 24, \ 
            hWnd, CID_BTN_DELFEED, hInstance, NULL
    mov     hwndBtnDelFeeds, eax
    invoke  SendMessage, eax, WM_SETFONT, hFont16, TRUE

    invoke  CreateWindowEx, NULL, ADDR ClassButton, \               ;| Edit feed button
            ADDR szbtnEditFeed, WS_CHILD+WS_VISIBLE+WS_DISABLED, 459, 401, 80, 24, \ 
            hWnd, CID_BTN_EDITFEED, hInstance, NULL
    mov     hwndBtnEditFeeds, eax
    invoke  SendMessage, eax, WM_SETFONT, hFont16, TRUE    
    
    invoke  CreateWindowEx, NULL, ADDR ClassButton, \               ;| Edit storage dir button
            ADDR szbtnEditStorageDir, WS_CHILD+WS_VISIBLE+WS_DISABLED, 367, 401, 90, 24, \ 
            hWnd, CID_BTN_EDITSTORAGEDIR, hInstance, NULL
    mov     hwndBtnEditStorageDir, eax
    invoke  SendMessage, eax, WM_SETFONT, hFont16, TRUE    

    invoke  CreateWindowEx, NULL, ADDR ClassButton, \               ;| Edit storage dir button
            ADDR szbtnEditFilter, WS_CHILD+WS_VISIBLE+WS_DISABLED, 272, 401, 90, 24, \ 
            hWnd, CID_BTN_EDITFILTER, hInstance, NULL
    mov     hwndBtnEditFilter, eax
    invoke  SendMessage, eax, WM_SETFONT, hFont16, TRUE    

    invoke  CreateWindowEx, NULL, ADDR ClassStatic, ADDR strFeedUrlLabel,\      ;| Feed Url static label
            WS_CHILD+WS_VISIBLE+SS_LEFT,8,431,60,24,hWnd,NULL,hInstance,NULL
    mov     hwndStcFeedUrlLabel, eax
    invoke  SendMessage, hwndStcFeedUrlLabel, WM_SETFONT, hFont16, NULL
    
    invoke  CreateWindowEx, NULL, ADDR ClassEdit, \                             ;| Feed Url Edit box
            NULL, WS_CHILD+WS_VISIBLE+ES_AUTOHSCROLL+WS_BORDER, 68, 429, 393, 22, \ 
            hWnd, CID_EDT_FEEDURL, hInstance, NULL
    mov     hwndEdtFeedUrl, eax

    invoke  CreateWindowEx, NULL, ADDR ClassButton, \               ;| Add feed button
            ADDR szbtnAddFeed, WS_CHILD+WS_VISIBLE+WS_DISABLED, 469, 428, 80, 24, \ 
            hWnd, CID_BTN_ADDFEED, hInstance, NULL
    mov     hwndBtnAddFeeds, eax

    invoke  CreateWindowEx, NULL, ADDR ClassButton, \               ;| Finish button
            ADDR szbtnFinish, WS_CHILD+WS_VISIBLE, 551, 428, 80, 24, \ 
            hWnd, CID_BTN_FINISH, hInstance, NULL
    mov     hwndBtnFinish, eax            
                
    invoke  CreateWindowEx, WS_EX_CLIENTEDGE, ADDR ClassListView, NULL, \       ;| List view for feeds
            WS_CHILD+LVS_REPORT+\;LVS_SORTASCENDING+\
            LVS_SHOWSELALWAYS+LVS_SINGLESEL+WS_VISIBLE, 8, 27, \
            623, 370, hWnd, NULL, hInstance, NULL
    mov     hwndLVFeeds, eax
    invoke  SendMessage, hwndLVFeeds, LVM_SETBKCOLOR, 0, 00000000h
    invoke  SendMessage, hwndLVFeeds, LVM_SETTEXTCOLOR, 0, 00FFFFFFh
    invoke  SendMessage, hwndLVFeeds, LVM_SETTEXTBKCOLOR, 0, 00000000h

    ;##: Hook the list view control's wndproc
    invoke  GetWindowLong, hwndLVFeeds, GWL_WNDPROC
    mov     pWndprocListView, eax
    invoke  SetWindowLong, hwndLVFeeds, GWL_WNDPROC, ADDR ListViewWndProc
    
    ;| Set up the structure of the List View Control
    mov         lvc.imask, LVCF_TEXT+LVCF_WIDTH
    mov         lvc.lx, 100
    mov         lvc.pszText, OFFSET szLVIFeedName
    invoke      SendMessage, hwndLVFeeds, LVM_INSERTCOLUMN, 0, ADDR lvc
    mov         lvc.lx, 100    
    mov         lvc.pszText, OFFSET szLVIFeedUrl
    invoke      SendMessage, hwndLVFeeds, LVM_INSERTCOLUMN, 1, ADDR lvc
    mov         lvc.lx, 100    
    mov         lvc.pszText, OFFSET szLVIFeedStorageDir
    invoke      SendMessage, hwndLVFeeds, LVM_INSERTCOLUMN, 2, ADDR lvc
    mov         lvc.lx, 100    
    mov         lvc.pszText, OFFSET szLVIFeedFilter
    invoke      SendMessage, hwndLVFeeds, LVM_INSERTCOLUMN, 3, ADDR lvc        

    ;| Populate the list view with feeds from the registry
    invoke  RegOpenKeyEx, dwHKEY_BRANCH, ADDR strHKLMFeeds, 0, KEY_ALL_ACCESS, ADDR hKeyFeeds
    .IF(eax!=ERROR_SUCCESS)
        mov     dwReturnValue, ERROR_NO_MORE_ITEMS
    .ELSE
        mov     dwReturnValue, ERROR_SUCCESS    
    .ENDIF
    mov     dwKeyIndex, 0
    mov     dwLVIndex, 0
    .WHILE(dwReturnValue!=ERROR_NO_MORE_ITEMS)
        mov     dwFeedNameSize, SIZEOF strFeedName
        mov     dwFeedUrlSize, SIZEOF strFeedUrl        
        invoke  RegEnumValue, hKeyFeeds, dwKeyIndex, ADDR strFeedName, ADDR dwFeedNameSize, NULL, ADDR dwFeedKeyType,\
                ADDR strFeedUrl, ADDR dwFeedUrlSize
        mov     dwReturnValue, eax

        .IF((dwFeedUrlSize>12) && (dwReturnValue!=ERROR_NO_MORE_ITEMS))
            mov     lvi.imask, LVIF_TEXT
            mov     eax, dwLVIndex
            mov     lvi.iItem, eax
            
            mov     lvi.iSubItem, 0
            lea     eax, strFeedName
            mov     lvi.pszText, eax
            invoke  SendMessage, hwndLVFeeds, LVM_INSERTITEM, NULL, ADDR lvi
            
            mov     lvi.iSubItem, 1
            lea     eax, strFeedUrl
            mov     lvi.pszText, eax
            invoke  SendMessage, hwndLVFeeds, LVM_SETITEM, NULL, ADDR lvi
            
            mov     lvi.iSubItem, 2
            lea     eax, strStorageDir
            mov     lvi.pszText, eax            
            mov     dwStorageDirSize, SIZEOF strStorageDir
            invoke  SHGetValue, dwHKEY_BRANCH, ADDR strHKLMStorageDirs, ADDR strFeedName, ADDR dwRegSz,\
                    ADDR strStorageDir, ADDR dwStorageDirSize
            .IF(eax==ERROR_SUCCESS)
                invoke  SendMessage, hwndLVFeeds, LVM_SETITEM, NULL, ADDR lvi
            .ENDIF

            mov     lvi.iSubItem, 3
            lea     eax, strFilter
            mov     lvi.pszText, eax            
            mov     dwFilterSize, SIZEOF strFilter
            invoke  SHGetValue, dwHKEY_BRANCH, ADDR strHKLMFilters, ADDR strFeedName, ADDR dwRegSz,\
                    ADDR strFilter, ADDR dwFilterSize
            .IF(eax==ERROR_SUCCESS)
                invoke  SendMessage, hwndLVFeeds, LVM_SETITEM, NULL, ADDR lvi
            .ELSE
                lea     eax, strDefaultFilter
                mov     lvi.pszText, eax
                invoke  SendMessage, hwndLVFeeds, LVM_SETITEM, NULL, ADDR lvi
            .ENDIF                

            inc     dwLVIndex
        .ENDIF               

        inc     dwKeyIndex
    .ENDW
    invoke  RegCloseKey, hKeyFeeds         

    ;##: Adjust the size of the listview columns to look nice
    invoke  SendMessage, hwndLVFeeds, LVM_SETCOLUMNWIDTH, 0, -2    
    invoke  SendMessage, hwndLVFeeds, LVM_SETCOLUMNWIDTH, 1, 200
    invoke  SendMessage, hwndLVFeeds, LVM_SETCOLUMNWIDTH, 2, 200
    invoke  SendMessage, hwndLVFeeds, LVM_SETCOLUMNWIDTH, 3, -2        

    ;##: Show the window to the user
    invoke  ShowWindow, hWnd, SW_SHOWNORMAL
    invoke  SetFocus, hwndEdtFeedUrl

    xor     eax, eax
    ret
ShowFeedListWindow  endp
;|
;|
HideFeedListWindow  proc    hWnd:DWORD, hProgressBar:DWORD

    ;##: Hide the main window
    invoke  ShowWindow, hWnd, SW_HIDE

    ;##: Destroy the list view and buttons
    invoke  DestroyWindow, hwndLVFeeds
    invoke  DestroyWindow, hwndBtnAddFeeds
    invoke  DestroyWindow, hwndBtnFinish
    invoke  DestroyWindow, hwndBtnDelFeeds
    invoke  DestroyWindow, hwndEdtFeedUrl
    invoke  DestroyWindow, hwndStcFeedUrlLabel
    invoke  DestroyWindow, hwndUpdChangeInterval
    invoke  DestroyWindow, hwndEdtChangeInterval
    invoke  DestroyWindow, hwndStcChangeIntervalLabel
    invoke  DestroyWindow, hwndBtnEditFilter    

    ;##: Unhide the progress bar
    invoke  ShowWindow, hProgressBar, SW_SHOW

    ;##: Put the window back where it belongs
    invoke  SetMainWindowPosition, hWnd

    ;##: Relenquish control
    mov     boolDownloadInProgress, FALSE

    xor     eax, eax
    ret
HideFeedListWindow  endp
;|
;|
AddFeed     proc    hWnd:DWORD, hFeeds:DWORD, pUrl:DWORD
    LOCAL   strTempFilePath[MAX_PATH]:DWORD    
    LOCAL   strFeedTitle[255]:DWORD
    LOCAL   bi:BROWSEINFO
    LOCAL   strStoragePath[MAX_PATH]:BYTE
    LOCAL   dwStoragePathSize:DWORD
    LOCAL   dwBufferLength:DWORD    

    ;##: Make a temporary download location
    invoke  GetTempFileName, ADDR strTempDir, ADDR AppTitle, 0, ADDR strTempFilePath

    ;##: Get the feed file
    invoke  GetHttpFile, hWnd, pUrl, ADDR strTempFilePath, NULL, NULL
    .IF(eax!=0)
        mov     eax, 1
        ret
    .ENDIF

    ;##: Search for the feed's title in the file
    invoke  GetFeedTitle, hWnd, ADDR strTempFilePath, ADDR strFeedTitle, SIZEOF strFeedTitle
    .IF(eax!=0)
        mov     eax, 1
        ret
    .ENDIF    

    ;##: Set the feed's storage location in the registry
    invoke  SetStorageDir, NULL, ADDR strFeedTitle

    ;##: Set any filters for the feed
    invoke  SetFeedFilter, NULL, ADDR strFeedTitle
    
    ;##: Add the feed to the registry
    invoke  StringCbLength, pUrl, INTERNET_MAX_URL_LENGTH, ADDR dwBufferLength
    invoke  SHSetValue, dwHKEY_BRANCH, ADDR strHKLMFeeds, ADDR strFeedTitle, REG_SZ,\
            pUrl, dwBufferLength

    xor     eax, eax
    ret
AddFeed     endp
;|
;|
DelFeed     proc    hWnd:DWORD, hFeeds:DWORD, pFeedName:DWORD
    LOCAL   strTempFilePath[MAX_PATH]:DWORD
    LOCAL   strFeedTitle[255]:DWORD

    ;##: Remove the feed from the registry
    invoke  SHDeleteValue, dwHKEY_BRANCH, ADDR strHKLMFeeds, pFeedName
    .IF(eax!=ERROR_SUCCESS)
        mov     eax, 1
        ret
    .ENDIF

    ;##: Remove the feed's filter string from the registry
    invoke  SHDeleteValue, dwHKEY_BRANCH, ADDR strHKLMFilters, pFeedName
    .IF(eax!=ERROR_SUCCESS)
        mov     eax, 1
        ret
    .ENDIF

    ;##: Remove the feed's storage dir from the registry
    invoke  SHDeleteValue, dwHKEY_BRANCH, ADDR strHKLMStorageDirs, pFeedName
    .IF(eax!=ERROR_SUCCESS)
        mov     eax, 1
        ret
    .ENDIF

    xor     eax, eax
    ret
DelFeed     endp
;|
;|
ShowToast   proc    pMessage:DWORD
    LOCAL   msg:MSG
    LOCAL   hwnd:HWND


    ;##: Create the toaster popup window
    invoke  CreateWindowEx, WS_EX_TOOLWINDOW, ADDR ClassToastName, ADDR AppTitle,\
            WS_POPUP,0,0,200,200,NULL,NULL,hInstance,NULL
    mov     hwnd, eax

    ;##: Make the corners transparent
    invoke  CreateRoundRectRgn, 0, 0, 200, 200, 12, 12
    invoke  SetWindowRgn, hwnd, eax, FALSE
    
    ;##: Create a static control to fill in for the missing title bar
    invoke  CreateWindowEx, NULL, ADDR ClassStatic, ADDR AppTitle,\
            WS_CHILD+WS_VISIBLE+SS_LEFT,8,7,190,20,hwnd,NULL,hInstance,NULL
    mov     hwndStcToastTitleBar, eax        
    invoke  SendMessage, hwndStcToastTitleBar, WM_SETFONT, hFont16, TRUE

    ;##: Create a static control to hold the toaster's message
    invoke  CreateWindowEx, NULL, ADDR ClassStatic, pMessage,\
            WS_CHILD+WS_VISIBLE+SS_LEFT,12,33,175,138,hwnd,NULL,hInstance,NULL
    mov     hwndStcToastMessage, eax        
    invoke  SendMessage, hwndStcToastMessage, WM_SETFONT, hFont12, TRUE
    
    ;##: Enter the main message loop
    .WHILE TRUE
        invoke  GetMessage, ADDR msg, NULL, 0, 0
        .BREAK .IF (!eax)
        invoke  TranslateMessage, ADDR msg
        invoke  DispatchMessage, ADDR msg
    .ENDW

    invoke  DestroyWindow, hwnd

    xor     eax, eax
    ret
ShowToast   endp
;|
;|
WndProcToast    proc    hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    LOCAL   ps:PAINTSTRUCT
    LOCAL   rect:RECT
    LOCAL   hLocalThread:DWORD
    LOCAL   dwLocalThreadId:DWORD
    LOCAL   hDCBackbuffer:DWORD
    LOCAL   hBmpBackbuffer:DWORD    


    .IF uMsg==WM_CREATE
        ;##: Animate the toaster window rising out of the taskbar    
        invoke  CreateThread, NULL, NULL, ADDR RaiseToast, hWnd, NULL, ADDR dwLocalThreadId
        mov     hLocalThread, eax            

    .ELSEIF uMsg==WM_LBUTTONUP
        ;##: Close the toaster window
        invoke  SendMessage, hWnd, WM_DESTROY, NULL, NULL
        
    .ELSEIF uMsg==WM_CTLCOLORSTATIC
        ;##: Give the static control on the toaster a transparent background
        invoke  SetTextColor,wParam,00131313h   ;TextColor
        invoke  SetBkMode,wParam,TRANSPARENT    ;Background of Text
        invoke  GetStockObject,NULL_BRUSH       ;BackgroundColor == there is no
        ret
        
    .ELSEIF uMsg==WM_PAINT
        ;##: Check for an update region
        invoke  GetUpdateRect, hWnd, ADDR rect, TRUE
        .IF(eax==0)
            xor     eax, eax
            ret
        .ENDIF
        
        ;##: Setting the batch helps prevent flickering from the background erase
        invoke  GdiSetBatchLimit ,25

        ;##: Start the painting operation        
        invoke  BeginPaint, hWnd, ADDR ps

        ;##: Create a backbuffer
        invoke  GetDesktopWindow
        push    eax
        invoke  GetWindowDC, eax
        push    eax
        invoke  CreateCompatibleDC, eax
        mov     hDCBackbuffer, eax
        pop     eax
        invoke  CreateCompatibleBitmap, eax, rect.right, rect.bottom
        push    eax
        mov     hBmpBackbuffer, eax
        invoke  SelectObject, hDCBackbuffer, hBmpBackbuffer
        mov     hBmpBackbuffer, eax
        pop     eax
        pop     edx
        invoke  ReleaseDC, edx, eax

        ;##: Get the coordinates of the window
        invoke  GetClientRect, hWnd, ADDR rect
        invoke  FillRect, hDCBackbuffer, ADDR rect, hBrshBackground        

        ;##: Paint Top Row
        mov eax, rect.right
        mov ecx, 2
        xor edx, edx
        div ecx
        mov ebx, eax
        xor edi, edi
        .WHILE ebx != 0
            invoke BitBlt,hDCBackbuffer, edi,0,2,32,hDCBkgTop,0,0,SRCCOPY
            add edi, 2
            dec ebx
        .ENDW
        
        ;##: Paint Bottom Row
        mov eax, rect.right
        mov ecx, 2
        xor edx, edx
        div ecx
        mov ebx, eax
        xor edi, edi
        mov esi, rect.bottom
        sub esi, 32
        .WHILE ebx != 0
            invoke BitBlt,hDCBackbuffer, edi,esi,2,32,hDCBkgBot,0,0,SRCCOPY
            add edi, 2
            dec ebx
        .ENDW
        
        ;##: Paint Left Side
        mov eax, rect.bottom
        mov ecx, 2
        xor edx, edx
        div ecx
        mov ebx, eax
        xor edi, edi
        .WHILE ebx != 0
            invoke BitBlt,hDCBackbuffer, 0,edi,32,2,hDCBkgSideL,0,0,SRCCOPY
            add edi, 2
            dec ebx
        .ENDW
        
        ;##: Paint Right Side
        mov eax, rect.bottom
        mov ecx, 2
        xor edx, edx
        div ecx
        mov ebx, eax
        xor edi, edi
        mov esi, rect.right
        sub esi, 32
        .WHILE ebx != 0
            invoke BitBlt,hDCBackbuffer, esi,edi,32,2,hDCBkgSideR,0,0,SRCCOPY
            add edi, 2
            dec ebx
        .ENDW
        
        ;##: Paint Top Left Corner
        invoke BitBlt,hDCBackbuffer,0,0,32,32,hDCBkgCornerTL,0,0,SRCCOPY

        ;##: Paint Top Right Corner        
        mov eax, rect.right
        sub eax, 32
        invoke BitBlt,hDCBackbuffer,eax,0,32,32,hDCBkgCornerTR,0,0,SRCCOPY

        ;##: Paint Bottom Left Corner
        sub rect.bottom,32
        invoke BitBlt,hDCBackbuffer,0,rect.bottom,32,32,hDCBkgCornerBL,0,0,SRCCOPY

        ;##: Paint Bottom Right Corner        
        sub rect.right,32
        invoke BitBlt,hDCBackbuffer,rect.right,rect.bottom,32,32,hDCBkgCornerBR,0,0,SRCCOPY

        ;##: Now blt the whole thing onto the visible DC
        add     rect.right, 32
        add     rect.bottom, 32
        invoke  BitBlt,ps.hdc,0,0,rect.right,rect.bottom,hDCBackbuffer,0,0,SRCCOPY        

        ;##: Flush the GDI cache to finish drawing onto the control
        invoke  GdiFlush
        invoke  EndPaint, hWnd, ADDR ps

        ;##: Cleanup
        invoke  SelectObject, hDCBackbuffer, hBmpBackbuffer
        mov     hBmpBackbuffer, eax
        invoke  DeleteObject, hBmpBackbuffer
        invoke  ReleaseDC, hWnd, hDCBackbuffer
        
        xor     eax, eax
        ret

    .ELSEIF uMsg==WM_SIZE
        ;##: Force a redraw
        invoke  InvalidateRect,hWnd,0,TRUE
                
    .ELSEIF uMsg==WM_DESTROY
        ;##: Animate the toaster window sinking into the taskbar
        invoke  CreateThread, NULL, NULL, ADDR LowerToast, hWnd, NULL, ADDR dwLocalThreadId
        mov     hLocalThread, eax
    .ELSE    
        invoke  DefWindowProc, hWnd, uMsg, wParam, lParam
        ret
    .ENDIF
    xor     eax, eax

    ret
WndProcToast    endp    ;| End the Wndproc procedure
;|
;|
HoursToMicros   proc    dwHours:DWORD

    ;##: Multiply by 60 to get minutes
    mov     eax, dwHours
    xor     edx, edx
    mov     ecx, 60
    mul     ecx

    ;##: Multiply by 60 again to get seconds
    xor     edx, edx
    mov     ecx, 60
    mul     ecx

    ;##: Multiply by 1000 again to get microseconds
    xor     edx, edx
    mov     ecx, 1000
    mul     ecx

    ret
HoursToMicros   endp
;|
;|
ListViewWndProc proc    hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    LOCAL   dwItemIndex:DWORD

    .IF(uMsg==WM_SETFOCUS)
        invoke  SendMessage, hwndLVFeeds, LVM_GETNEXTITEM, -1, LVNI_ALL+LVNI_SELECTED
        mov     dwItemIndex, eax
        .IF(eax!=-1)
            invoke  EnableWindow, hwndBtnEditFeeds, TRUE
            invoke  EnableWindow, hwndBtnEditStorageDir, TRUE
            invoke  EnableWindow, hwndBtnDelFeeds, TRUE 
            invoke  EnableWindow, hwndBtnEditFilter, TRUE                   
        .ENDIF
    .ELSEIF(uMsg==WM_KILLFOCUS)
        invoke  SendMessage, hwndLVFeeds, LVM_GETNEXTITEM, -1, LVNI_ALL+LVNI_SELECTED
        mov     dwItemIndex, eax
        .IF(eax==-1)    
            invoke  EnableWindow, hwndBtnEditFeeds, FALSE
            invoke  EnableWindow, hwndBtnEditStorageDir, FALSE    
            invoke  EnableWindow, hwndBtnDelFeeds, FALSE
            invoke  EnableWindow, hwndBtnEditFilter, FALSE            
        .ENDIF
    .ENDIF

    ; Allow the list view to process any other messages
    invoke  CallWindowProc, pWndprocListView, hWnd, uMsg, wParam, lParam
    ret
ListViewWndProc endp
;|
;|
SetStorageDir   proc    hWnd:DWORD, pFeedName:DWORD
    LOCAL   strTempFilePath[MAX_PATH]:BYTE
    LOCAL   strStoragePath[MAX_PATH]:BYTE
    LOCAL   bi:BROWSEINFO
    LOCAL   dwStoragePathSize:DWORD 
    LOCAL   dwBufferLength:DWORD   

    ;##: If hWnd is NULL just set the default storage dir and be done with it
    .IF(hWnd==NULL)
        invoke  SHGetSpecialFolderPath, NULL, ADDR strStoragePath, CSIDL_DESKTOPDIRECTORY, 0 
        invoke  PathAddBackslash, ADDR strStoragePath    
        invoke  StringCbLength, ADDR strStoragePath, MAX_PATH, ADDR dwBufferLength
        invoke  SHSetValue, dwHKEY_BRANCH, ADDR strHKLMStorageDirs, pFeedName, REG_SZ,\
                ADDR strStoragePath, dwBufferLength 
        xor     eax, eax
        ret 
    .ENDIF

    ;##: Ask the user where to store files for this feed
    mov     eax, hWnd
    mov     bi.hwndOwner, eax
    mov     bi.pidlRoot, NULL
    lea     eax, strTempFilePath
    mov     bi.pszDisplayName, eax
    lea     eax, strChooseDirectory
    mov     bi.lpszTitle, eax 
    mov     bi.ulFlags, BIF_RETURNONLYFSDIRS
    mov     bi.lpfn, NULL
    mov     bi.lParam, NULL
    mov     bi.iImage, NULL
    invoke  SHBrowseForFolder, ADDR bi
    .IF(eax!=NULL)
        mov     edx, eax
        invoke  SHGetPathFromIDList, edx, ADDR strStoragePath
        invoke  PathAddBackslash, ADDR strStoragePath
        invoke  ClearBuffer, ADDR strNotifyMessage, 512
        invoke  wsprintf, ADDR strNotifyMessage, ADDR strTmpNewDownloadDir, pFeedName, ADDR strStoragePath
        invoke  MessageBox, hWnd, ADDR strNotifyMessage, ADDR AppTitle, MB_OK+MB_ICONINFORMATION
        invoke  StringCbLength, ADDR strStoragePath, MAX_PATH, ADDR dwBufferLength
        invoke  SHSetValue, dwHKEY_BRANCH, ADDR strHKLMStorageDirs, pFeedName, REG_SZ,\
                ADDR strStoragePath, dwBufferLength              
    .ELSE
        mov     eax, 1
        ret
    .ENDIF

    xor     eax, eax
    ret
SetStorageDir   endp
;|
;|
szFilterExplain     db  "Do you want to set a filter for this feed? (example: .mp3)",0
SetFeedFilter   proc    hWnd:DWORD, pFeedName:DWORD
    LOCAL   strFilter[128]:BYTE
    LOCAL   dwBufferLength:DWORD

    ;##: If hWnd is NULL just set the default filter and be done with it
    .IF(hWnd==NULL)
        invoke  lstrlen, ADDR strDefaultFilter
        invoke  SHSetValue, dwHKEY_BRANCH, ADDR strHKLMFilters, pFeedName, REG_SZ,\
                ADDR strDefaultFilter, eax 
        xor     eax, eax
        ret 
    .ENDIF

    invoke  ClearBuffer, ADDR strFilter, SIZEOF strFilter
    invoke  GetTextInput, hWnd, hInstance, hTrayIcon, ADDR AppTitle, ADDR szFilterExplain, ADDR strFilter
    lea     eax, strFilter
    mov     eax, [eax]
    .IF(eax==0)
        invoke  lstrlen, ADDR strDefaultFilter
        invoke  SHSetValue, dwHKEY_BRANCH, ADDR strHKLMFilters, pFeedName, REG_SZ,\
                ADDR strDefaultFilter, eax  
    .ELSE
        invoke  StringCbLength, ADDR strFilter, 128, ADDR dwBufferLength
        invoke  SHSetValue, dwHKEY_BRANCH, ADDR strHKLMFilters, pFeedName, REG_SZ,\
                ADDR strFilter, dwBufferLength
    .ENDIF

    xor     eax, eax
    ret
SetFeedFilter   endp
;|
;|
ParsePcastFile  proc    hWnd:DWORD, pFileName:DWORD, pFeedUrl:DWORD, dwMaxUrlSize:DWORD
    LOCAL   hFile:DWORD
    LOCAL   dwFileSize:DWORD
    LOCAL   hMap:DWORD
    LOCAL   pMap:DWORD
    LOCAL   pStartLink:DWORD
    LOCAL   pStartEnclosure:DWORD
    LOCAL   pStartUrl:DWORD
    LOCAL   dwUrlLength:DWORD
    LOCAL   pStartItem:DWORD


    ;##: Open the file for mapping
    invoke  CreateFile, pFileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, NULL, NULL
    .IF (eax==INVALID_HANDLE_VALUE)
        invoke      MessageBox, hWnd, ADDR szErrFileCouldntOpen, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        invoke      MessageBox, hWnd, pFileName, ADDR strErrorFileRead, MB_OK+MB_ICONINFORMATION        
        mov         eax, 1
        ret
    .ENDIF
    mov     hFile, eax

    ;##: Get its size
    invoke  GetFileSize, hFile, NULL
    mov     dwFileSize, eax

    ;##: Map the file and get a pointer
    invoke  CreateFileMapping, hFile, NULL, PAGE_READONLY, NULL, NULL, NULL
    .IF (eax==NULL)
        invoke      CloseHandle, hFile
        invoke      MessageBox, hWnd, ADDR szErrFileCouldntMap, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        mov         eax, 1
        ret
    .ENDIF
    mov     hMap, eax
    invoke  MapViewOfFile, hMap, FILE_MAP_READ, NULL, NULL, NULL
    .IF (eax==NULL)
        invoke      CloseHandle, hMap    
        invoke      CloseHandle, hFile    
        invoke      MessageBox, hWnd, ADDR szErrFileCouldntPoint, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        mov         eax, 1
        ret
    .ENDIF
    mov     pMap, eax

    ;##: We extract the URL from the <link> tag's href value
    ;##: Start by finding the start of the <link> tag
    ;invoke  InString, 1, pMap, ADDR strHtmlLinkOpen
    invoke	lstrlen, ADDR strHtmlLinkOpen
    invoke  BinSearch, 0, pMap, dwFileSize, ADDR strHtmlLinkOpen, eax      
    .IF (eax!=-1)
        sub			dwFileSize, eax
        add         eax, pMap
        mov         pStartLink, eax
        mov         pStartUrl, eax
        invoke      lstrlen, ADDR strHtmlLinkOpen
        add         pStartUrl, eax
        sub			dwFileSize, eax
    .ELSE
        invoke      UnmapViewOfFile, pMap    
        invoke      CloseHandle, hMap    
        invoke      CloseHandle, hFile    
        invoke      MessageBox, hWnd, ADDR szErrFileParseFeedTitleOpen, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        mov         eax, 1
        ret
    .ENDIF

    ;##: Now move up and find the start of the href value
    ;invoke  InString, 1, pMap, ADDR strHtmlHref
    invoke	lstrlen, ADDR strHtmlHref
    invoke  BinSearch, 0, pMap, dwFileSize, ADDR strHtmlHref, eax      
    .IF (eax!=-1)
        sub			dwFileSize, eax
        add         eax, pMap
        mov         pStartLink, eax
        mov         pStartUrl, eax
        invoke      lstrlen, ADDR strHtmlHref
        inc         eax       					;##: Don't dec the pointer so we skip the opening quotes        
        add         pStartUrl, eax
        sub			dwFileSize, eax
    .ELSE
        invoke      UnmapViewOfFile, pMap    
        invoke      CloseHandle, hMap    
        invoke      CloseHandle, hFile    
        invoke      MessageBox, hWnd, ADDR szErrFileParseFeedTitleOpen, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        mov         eax, 1
        ret
    .ENDIF

    ;##: Now extract the url from in between the link tags
    ;invoke  InString, 1, pStartUrl, ADDR strDoubleQuotes
    mov		al, 022h
    invoke  FindChar, pStartUrl, eax, dwFileSize      
    .IF (eax!=-1)
    	inc			eax		;##: 1-based since we are calcing length now instead of position
        mov         dwUrlLength, eax
        .IF (eax<dwMaxUrlSize)
            invoke      lstrcpyn, pFeedUrl, pStartUrl, dwUrlLength
        .ELSE
            invoke      UnmapViewOfFile, pMap    
            invoke      CloseHandle, hMap    
            invoke      CloseHandle, hFile        
            invoke      MessageBox, hWnd, ADDR szErrFileParseFeedTitleTooLong, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
            mov         eax, 1
            ret
        .ENDIF
    .ELSE
        invoke      UnmapViewOfFile, pMap    
        invoke      CloseHandle, hMap    
        invoke      CloseHandle, hFile    
        invoke      MessageBox, hWnd, ADDR szErrFileParseFeedTitleClose, ADDR strErrorFileRead, MB_OK+MB_ICONSTOP
        mov         eax, 2
        ret
    .ENDIF
                
 
    ;##: Cleanup open handles
    invoke  UnmapViewOfFile, pMap
    invoke  CloseHandle, hMap  
    invoke  CloseHandle, hFile         


    xor     eax, eax
    ret
ParsePcastFile  endp
;|
;|
RaiseToast  proc    hWnd:DWORD
    LOCAL   dwScreenWidth:DWORD
    LOCAL   dwScreenHeight:DWORD
    LOCAL   dwWinPosX:DWORD
    LOCAL   dwWinPosY:DWORD
    LOCAL   abd:APPBARDATA
    LOCAL   dwCurrentX:DWORD
    LOCAL   dwCurrentY:DWORD
    LOCAL   dwToasterHeight:DWORD
    

    ;##: Find the final resting place the toaster should stop at
    invoke  GetDesktopWindow
    push    eax
    invoke  GetWindowDC, eax
    push    eax
    invoke  GetDeviceCaps, eax, HORZRES
    mov     dwScreenWidth, eax
    pop     eax
    push    eax
    invoke  GetDeviceCaps, eax, VERTRES
    mov     dwScreenHeight, eax
    pop     eax
    pop     edx
    invoke  ReleaseDC, edx, eax
    mov     abd.cbSize, SIZEOF abd
    push    hWnd
    pop     abd.hwnd
    invoke  SHAppBarMessage, ABM_GETTASKBARPOS, ADDR abd
    mov     eax, abd.rc.top
    sub     eax, 200
    sub     eax, 1
    mov     edx, abd.rc.right
    sub     edx, 200
    sub     edx, 1
    mov     dwWinPosX, edx
    mov     dwWinPosY, eax
    invoke  SetWindowPos, hWnd, HWND_TOPMOST, dwWinPosX, dwScreenHeight, 200, 200, NULL    

    ;##: Show the toaster popup
    invoke  ShowWindow, hWnd, SW_SHOW

    ;##: Play an alert wav
    invoke  PlaySound, IDW_ROOSTER, hInstance, SND_RESOURCE+SND_NOWAIT+SND_ASYNC
        
    ;##: Now raise the window up from the task bar to it's final position
    mov     dwToasterHeight, 0
    push    dwWinPosY
    pop     dwCurrentY
    add     dwCurrentY, 200
    mov     eax, dwCurrentY
    .WHILE(eax>dwWinPosY)
        sub     dwCurrentY, 4
        add     dwToasterHeight, 4
        invoke  MoveWindow, hWnd, dwWinPosX, dwCurrentY, 200, dwToasterHeight, TRUE 
        invoke  Sleep, 10

        mov     eax, dwCurrentY
    .ENDW
    

    xor     eax, eax
    ret
RaiseToast  endp
;|
;|
LowerToast  proc    hWnd:DWORD
    LOCAL   dwScreenWidth:DWORD
    LOCAL   dwScreenHeight:DWORD
    LOCAL   dwWinPosX:DWORD
    LOCAL   dwWinPosY:DWORD
    LOCAL   abd:APPBARDATA
    LOCAL   dwCurrentX:DWORD
    LOCAL   dwCurrentY:DWORD
    LOCAL   dwToasterHeight:DWORD
    LOCAL   rect:RECT
    

    ;##: Now lower the window down through the task bar out of sight
    invoke  GetDesktopWindow
    push    eax
    invoke  GetWindowDC, eax
    push    eax
    invoke  GetDeviceCaps, eax, HORZRES
    mov     dwScreenWidth, eax
    pop     eax
    push    eax
    invoke  GetDeviceCaps, eax, VERTRES
    mov     dwScreenHeight, eax
    pop     eax
    pop     edx
    invoke  ReleaseDC, edx, eax
    mov     abd.cbSize, SIZEOF abd
    push    hWnd
    pop     abd.hwnd
    invoke  SHAppBarMessage, ABM_GETTASKBARPOS, ADDR abd
    mov     eax, abd.rc.top
    sub     eax, 200
    sub     eax, 1
    mov     edx, abd.rc.right
    sub     edx, 200
    sub     edx, 1
    mov     dwWinPosX, edx
    mov     dwWinPosY, eax        
    invoke  GetWindowRect, hWnd, ADDR rect
    mov     eax, rect.top
    mov     edx, rect.bottom
    sub     edx, eax
    mov     dwToasterHeight, edx
    push    rect.top
    pop     dwCurrentY        
    mov     eax, dwCurrentY
    .WHILE(eax<dwScreenHeight)
        add     dwCurrentY, 5
        sub     dwToasterHeight, 5
        invoke  MoveWindow, hWnd, dwWinPosX, dwCurrentY, 200, dwToasterHeight, TRUE
        invoke  Sleep, 10
        mov     eax, dwCurrentY
    .ENDW    

    invoke  GetWindowThreadProcessId, hWnd, NULL
    invoke  PostThreadMessage, eax, WM_QUIT, 0, 0    

    xor     eax, eax
    ret
LowerToast  endp
;|
;|
StartupActions  proc   hWnd:DWORD

    ;##: Check to see if there is an updated program file
    mov     boolManualCheck, FALSE
    ;invoke  GetUpgradeFile, hWnd             
    ;.IF(eax!=0)
        ;##: No newer version found so fire off the first new media check
        mov     boolManualCheck, FALSE        
        invoke  CreateThread, NULL, NULL, ADDR CheckForUpdate, hWnd, NULL, ADDR dwThreadId
        mov     hThread, eax
        mov     hThreadCurrentOp, eax     
    ;.ENDIF    

    xor     eax, eax
    ret
StartupActions  endp
;|
;|
;======================================================================== 
;                           GetBitmapDC
;                           by JimmyClif w/Permission
;======================================================================== 
;  Usage: 
;  invoke GetBitmapDC, ADDR BitmapDC, ResourceIdOfBitmap, ADDR hBitmap, hwnd 
;======================================================================== 
GetBitmapDC proc    AnotherDC:DWORD,BitmapID:DWORD,HandleOfBitmap:DWORD,hwnd:DWORD

    ;##: Delete existing DC
    mov     edx, AnotherDC
    mov     edx, [edx]
    invoke  DeleteDC, edx

    ;##: Delete existing bitmap
    mov     edx, HandleOfBitmap
    mov     edx, [edx]
    invoke  DeleteObject, edx
 
    invoke  GetDC, hwnd 
    push    eax                         ;1 push DC for release later 
    invoke  CreateCompatibleDC, eax 
    mov     edx, AnotherDC 
    push    eax                         ;2 push DC for SelectObject 
    mov     [edx], eax
     
    invoke  LoadBitmap, hInstance, BitmapID 
    mov     edx, HandleOfBitmap 
    pop     ecx                         ;2 pop Created DC 
    mov     [edx], eax 
    invoke  SelectObject, ecx, eax 
    pop     eax                         ;1 pop DC to release 
    invoke  ReleaseDC, hwnd, eax
 
    ret 
GetBitmapDC endp
;|
;|
ButtonWndProc   proc    hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
    LOCAL   ps:PAINTSTRUCT
    LOCAL   rect:RECT
    LOCAL   hLocalThread:DWORD
    LOCAL   dwLocalThreadId:DWORD
    LOCAL   hDCBackbuffer:DWORD
    LOCAL   hBmpBackbuffer:DWORD
    LOCAL   sizel:SIZEL
    LOCAL   bmpi:BITMAP
    LOCAL   strButtonText[255]:BYTE
    LOCAL   dwButtonTextLength:DWORD
    LOCAL   xMousePos:DWORD
    LOCAL   yMousePos:DWORD
    LOCAL   hLocalBmpBtnTop:DWORD
    LOCAL   hLocalBmpBtnBot:DWORD
    LOCAL   hLocalBmpBtnSideR:DWORD
    LOCAL   hLocalBmpBtnSideL:DWORD
    LOCAL   hLocalBmpBtnCornerTL:DWORD
    LOCAL   hLocalBmpBtnCornerTR:DWORD
    LOCAL   hLocalBmpBtnCornerBL:DWORD
    LOCAL   hLocalBmpBtnCornerBR:DWORD
    LOCAL   hLocalBmpBtnBackground:DWORD
    LOCAL   hLocalDCBtnTop:DWORD   
    LOCAL   hLocalDCBtnBot:DWORD
    LOCAL   hLocalDCBtnSideR:DWORD
    LOCAL   hLocalDCBtnSideL:DWORD
    LOCAL   hLocalDCBtnCornerTL:DWORD
    LOCAL   hLocalDCBtnCornerTR:DWORD
    LOCAL   hLocalDCBtnCornerBL:DWORD
    LOCAL   hLocalDCBtnCornerBR:DWORD


    .IF uMsg==WM_CREATE
        ;##: Force a redraw
        invoke  RedrawWindow, hWnd, NULL, NULL, RDW_INTERNALPAINT+RDW_INVALIDATE    

        ;##: Change the window style
        invoke  GetWindowLong, hWnd, GWL_STYLE
        or      eax, BS_OWNERDRAW
        or      eax, WS_CLIPCHILDREN
        invoke  SetWindowLong, hWnd, GWL_STYLE, eax
        
        ;##: Set the button shape
        ;invoke  GetClientRect, hWnd, ADDR rect
        ;invoke  CreateRoundRectRgn, 0, 0, rect.right, rect.bottom, 6, 6
        ;invoke  SetWindowRgn, hWnd, eax, TRUE

    .ELSEIF uMsg==WM_LBUTTONDOWN
        push    hWnd
        pop     hwndButtonDown

        ;##: Force a redraw
        invoke  RedrawWindow, hWnd, NULL, NULL, RDW_INTERNALPAINT+RDW_INVALIDATE

        ;##: Call the real BUTTON wndproc to let it do it's thing
        invoke  CallWindowProc, pWndprocButtons, hWnd, uMsg, wParam, lParam 

    .ELSEIF uMsg==WM_LBUTTONUP
        mov     hwndButtonDown, NULL

        ;##: Force a redraw
        invoke  RedrawWindow, hWnd, NULL, NULL, RDW_INTERNALPAINT+RDW_INVALIDATE

        ;##: Call the real BUTTON wndproc to let it do it's thing
        invoke  CallWindowProc, pWndprocButtons, hWnd, uMsg, wParam, lParam 

    .ELSEIF uMsg==WM_ENABLE
        ;##: Force a redraw
        invoke  RedrawWindow, hWnd, NULL, NULL, RDW_INTERNALPAINT+RDW_INVALIDATE

        ;##: Call the real BUTTON wndproc to let it do it's thing
        invoke  CallWindowProc, pWndprocButtons, hWnd, uMsg, wParam, lParam            
        
    .ELSEIF uMsg==WM_MOUSEMOVE
        ;##: Once a movement is detected we should capture the mouse so we can tell
        ;##: when the cursor is no longer hovering
        invoke  GetCapture
        .IF(eax!=hWnd)
            invoke  SetCapture, hWnd                        
        .ENDIF

        ;##: Get the mouse position
        mov     eax, lParam
        shr     eax, 16
        xor     edx, edx
        mov     dx, ax
        mov     yMousePos, edx
        
        mov     eax, lParam
        xor     edx, edx
        mov     dx, ax
        mov     xMousePos, edx

        ;##: Release the capture if the mouse is outside the client area
        invoke  GetClientRect, hWnd, ADDR rect
        mov     edx, xMousePos
        mov     eax, yMousePos
        .IF((edx>rect.right) || (eax>rect.bottom))        
            invoke  ReleaseCapture
            mov     hwndButtonDown, NULL                        
        .ENDIF

        ;##: Force a redraw
        invoke  RedrawWindow, hWnd, NULL, NULL, RDW_INTERNALPAINT+RDW_INVALIDATE

        ;##: Call the real BUTTON wndproc to let it do it's thing
        invoke  CallWindowProc, pWndprocButtons, hWnd, uMsg, wParam, lParam                
                
    .ELSEIF uMsg==WM_PAINT
        ;##: Check for an update region
        invoke  GetUpdateRect, hWnd, ADDR rect, TRUE
        .IF(eax==0)
            xor     eax, eax
            ret
        .ENDIF

        ;##: Bring in the correct bitmaps and DC's for the button state
        invoke  GetCapture
        mov     edx, hwndButtonDown
        .IF(edx==hWnd)
            push    hBmpDownBtnTop
            pop     hLocalBmpBtnTop
            push    hBmpDownBtnBot
            pop     hLocalBmpBtnBot
            push    hBmpDownBtnSideL
            pop     hLocalBmpBtnSideL
            push    hBmpDownBtnSideR
            pop     hLocalBmpBtnSideR
            push    hBmpDownBtnCornerTL
            pop     hLocalBmpBtnCornerTL
            push    hBmpDownBtnCornerTR
            pop     hLocalBmpBtnCornerTR
            push    hBmpDownBtnCornerBL
            pop     hLocalBmpBtnCornerBL
            push    hBmpDownBtnCornerBR
            pop     hLocalBmpBtnCornerBR
            push    hBmpDownBtnBackground
            pop     hLocalBmpBtnBackground
            
            push    hDCDownBtnTop
            pop     hLocalDCBtnTop
            push    hDCDownBtnBot
            pop     hLocalDCBtnBot
            push    hDCDownBtnSideL
            pop     hLocalDCBtnSideL
            push    hDCDownBtnSideR
            pop     hLocalDCBtnSideR
            push    hDCDownBtnCornerTL
            pop     hLocalDCBtnCornerTL
            push    hDCDownBtnCornerTR
            pop     hLocalDCBtnCornerTR
            push    hDCDownBtnCornerBL
            pop     hLocalDCBtnCornerBL
            push    hDCDownBtnCornerBR
            pop     hLocalDCBtnCornerBR        
        .ELSEIF(eax==hWnd)
            push    hBmpHoverBtnTop
            pop     hLocalBmpBtnTop
            push    hBmpHoverBtnBot
            pop     hLocalBmpBtnBot
            push    hBmpHoverBtnSideL
            pop     hLocalBmpBtnSideL
            push    hBmpHoverBtnSideR
            pop     hLocalBmpBtnSideR
            push    hBmpHoverBtnCornerTL
            pop     hLocalBmpBtnCornerTL
            push    hBmpHoverBtnCornerTR
            pop     hLocalBmpBtnCornerTR
            push    hBmpHoverBtnCornerBL
            pop     hLocalBmpBtnCornerBL
            push    hBmpHoverBtnCornerBR
            pop     hLocalBmpBtnCornerBR
            push    hBmpHoverBtnBackground
            pop     hLocalBmpBtnBackground
            
            push    hDCHoverBtnTop
            pop     hLocalDCBtnTop
            push    hDCHoverBtnBot
            pop     hLocalDCBtnBot
            push    hDCHoverBtnSideL
            pop     hLocalDCBtnSideL
            push    hDCHoverBtnSideR
            pop     hLocalDCBtnSideR
            push    hDCHoverBtnCornerTL
            pop     hLocalDCBtnCornerTL
            push    hDCHoverBtnCornerTR
            pop     hLocalDCBtnCornerTR
            push    hDCHoverBtnCornerBL
            pop     hLocalDCBtnCornerBL
            push    hDCHoverBtnCornerBR
            pop     hLocalDCBtnCornerBR
        .ELSE
            push    hBmpBtnTop
            pop     hLocalBmpBtnTop
            push    hBmpBtnBot
            pop     hLocalBmpBtnBot
            push    hBmpBtnSideL
            pop     hLocalBmpBtnSideL
            push    hBmpBtnSideR
            pop     hLocalBmpBtnSideR
            push    hBmpBtnCornerTL
            pop     hLocalBmpBtnCornerTL
            push    hBmpBtnCornerTR
            pop     hLocalBmpBtnCornerTR
            push    hBmpBtnCornerBL
            pop     hLocalBmpBtnCornerBL
            push    hBmpBtnCornerBR
            pop     hLocalBmpBtnCornerBR
            push    hBmpBtnBackground
            pop     hLocalBmpBtnBackground

            push    hDCBtnTop
            pop     hLocalDCBtnTop
            push    hDCBtnBot
            pop     hLocalDCBtnBot
            push    hDCBtnSideL
            pop     hLocalDCBtnSideL
            push    hDCBtnSideR
            pop     hLocalDCBtnSideR
            push    hDCBtnCornerTL
            pop     hLocalDCBtnCornerTL
            push    hDCBtnCornerTR
            pop     hLocalDCBtnCornerTR
            push    hDCBtnCornerBL
            pop     hLocalDCBtnCornerBL
            push    hDCBtnCornerBR
            pop     hLocalDCBtnCornerBR
        .ENDIF              
        
        ;##: Setting the batch helps prevent flickering from the background erase
        invoke  GdiSetBatchLimit ,25

        ;##: Start the painting operation        
        invoke  BeginPaint, hWnd, ADDR ps

        ;##: Create a backbuffer
        invoke  GetDesktopWindow
        push    eax
        invoke  GetWindowDC, eax
        push    eax
        invoke  CreateCompatibleDC, eax
        mov     hDCBackbuffer, eax
        pop     eax
        invoke  CreateCompatibleBitmap, eax, rect.right, rect.bottom
        push    eax
        mov     hBmpBackbuffer, eax
        invoke  SelectObject, hDCBackbuffer, hBmpBackbuffer
        mov     hBmpBackbuffer, eax
        pop     eax
        pop     edx
        invoke  ReleaseDC, edx, eax

        ;##: Get the coordinates of the window
        invoke  CreatePatternBrush, hLocalBmpBtnBackground
        push    eax
        invoke  GetClientRect, hWnd, ADDR rect
        pop     eax
        push    eax
        invoke  FillRect, hDCBackbuffer, ADDR rect, eax
        pop     eax
        invoke  DeleteObject, eax

        ;##: Paint Top Row
        invoke  GetObject, hLocalBmpBtnTop, SIZEOF BITMAP, ADDR bmpi
        mov     eax, rect.right
        mov     ecx, bmpi.bmWidth
        xor     edx, edx
        div     ecx
        mov     ebx, eax
        xor     edi, edi
        .WHILE ebx != 0
            invoke  BitBlt,hDCBackbuffer, edi,0,bmpi.bmWidth,bmpi.bmHeight,hLocalDCBtnTop,0,0,SRCCOPY
            add     edi, bmpi.bmWidth
            dec     ebx
        .ENDW
        
        ;##: Paint Bottom Row
        invoke  GetObject, hLocalBmpBtnBot, SIZEOF BITMAP, ADDR bmpi        
        mov     eax, rect.right
        mov     ecx, bmpi.bmWidth
        xor     edx, edx
        div     ecx
        mov     ebx, eax
        xor     edi, edi
        mov     esi, rect.bottom
        sub     esi, bmpi.bmHeight
        .WHILE ebx != 0
            invoke  BitBlt,hDCBackbuffer, edi, esi, bmpi.bmWidth, bmpi.bmHeight, hLocalDCBtnBot, 0, 0, SRCCOPY
            add     edi, bmpi.bmWidth
            dec     ebx
        .ENDW
        
        ;##: Paint Left Side
        invoke  GetObject, hLocalBmpBtnSideL, SIZEOF BITMAP, ADDR bmpi         
        mov     eax, rect.bottom
        mov     ecx, bmpi.bmHeight
        xor     edx, edx
        div     ecx
        mov     ebx, eax
        xor     edi, edi
        .WHILE ebx != 0
            invoke  BitBlt,hDCBackbuffer, 0,edi,bmpi.bmWidth,bmpi.bmHeight,hLocalDCBtnSideL,0,0,SRCCOPY
            add     edi, bmpi.bmHeight
            dec     ebx
        .ENDW
        
        ;##: Paint Right Side
        invoke  GetObject, hLocalBmpBtnSideR, SIZEOF BITMAP, ADDR bmpi         
        mov     eax, rect.bottom
        mov     ecx, bmpi.bmHeight
        xor     edx, edx
        div     ecx
        mov     ebx, eax
        xor     edi, edi
        mov     esi, rect.right
        sub     esi, bmpi.bmWidth
        .WHILE ebx != 0
            invoke  BitBlt,hDCBackbuffer, esi,edi,bmpi.bmWidth,bmpi.bmHeight,hLocalDCBtnSideR,0,0,SRCCOPY
            add     edi, bmpi.bmHeight
            dec     ebx
        .ENDW
        
        ;##: Paint Top Left Corner
        invoke  GetObject, hLocalBmpBtnCornerTL, SIZEOF BITMAP, ADDR bmpi        
        invoke  BitBlt,hDCBackbuffer,0,0,bmpi.bmWidth,bmpi.bmHeight,hLocalDCBtnCornerTL,0,0,SRCCOPY

        ;##: Paint Top Right Corner
        invoke  GetObject, hLocalBmpBtnCornerTR, SIZEOF BITMAP, ADDR bmpi                
        mov     eax, rect.right
        sub     eax, bmpi.bmWidth
        invoke  BitBlt,hDCBackbuffer,eax,0,bmpi.bmWidth,bmpi.bmHeight,hLocalDCBtnCornerTR,0,0,SRCCOPY

        ;##: Paint Bottom Left Corner
        invoke  GetObject, hLocalBmpBtnCornerBL, SIZEOF BITMAP, ADDR bmpi        
        mov     eax, rect.bottom
        sub     eax, bmpi.bmHeight
        push    eax
        invoke  BitBlt,hDCBackbuffer,0,eax,bmpi.bmWidth,bmpi.bmHeight,hLocalDCBtnCornerBL,0,0,SRCCOPY

        ;##: Paint Bottom Right Corner
        invoke  GetObject, hLocalBmpBtnCornerBR, SIZEOF BITMAP, ADDR bmpi        
        mov     eax, rect.right        
        sub     eax, bmpi.bmWidth
        pop     edx
        invoke  BitBlt,hDCBackbuffer,eax,edx,bmpi.bmWidth,bmpi.bmHeight,hLocalDCBtnCornerBR,0,0,SRCCOPY

        ;##: Draw the button's text onto the DC
        invoke  SetBkMode, hDCBackbuffer, TRANSPARENT
        invoke  GetStockObject, DEFAULT_GUI_FONT
        invoke  SelectObject, hDCBackbuffer, eax
        invoke  IsWindowEnabled, hWnd
        .IF(eax==TRUE)
            invoke  SetTextColor, hDCBackbuffer, 0000000h
        .ELSE
            invoke  SetTextColor, hDCBackbuffer, 0666666h
        .ENDIF
        invoke  GetWindowText, hWnd, ADDR strButtonText, 255
        invoke  GetWindowTextLength, hWnd
        mov     dwButtonTextLength, eax
        .IF(dwButtonTextLength > 0)        
            invoke  DrawText, hDCBackbuffer, ADDR strButtonText, dwButtonTextLength, ADDR rect, DT_CENTER+DT_VCENTER+DT_SINGLELINE
        .ENDIF

        ;##: Now blt the whole thing onto the visible DC
        invoke  BitBlt,ps.hdc,0,0,rect.right,rect.bottom,hDCBackbuffer,0,0,SRCCOPY        

        ;##: Flush the GDI cache to finish drawing onto the control
        invoke  GdiFlush
        invoke  EndPaint, hWnd, ADDR ps

        ;##: Cleanup
        invoke  SelectObject, hDCBackbuffer, hBmpBackbuffer
        mov     hBmpBackbuffer, eax
        invoke  DeleteObject, hBmpBackbuffer
        invoke  ReleaseDC, hWnd, hDCBackbuffer

        xor     eax, eax
        ret

    .ELSE
        ;##: Call the real BUTTON wndproc to let it do it's thing
        invoke  CallWindowProc, pWndprocButtons, hWnd, uMsg, wParam, lParam
        ret
    .ENDIF
                
    xor     eax, eax
    ret
ButtonWndProc   endp
;|
;|
ShowError		proc    hWnd:DWORD, dwErrorCode:DWORD

    invoke  ClearBuffer, ADDR strErrorCode, SIZEOF strErrorCode
    invoke  wsprintf, ADDR strErrorCode, ADDR strTemplateErrorCode, dwErrorCode
    invoke  MessageBox, hWnd, ADDR strErrorCode, ADDR AppTitle, MB_OK+MB_ICONWARNING

    xor     eax, eax
    ret
ShowError		endp
;|
;|
FindChar		proc	uses esi edi	pStart:DWORD, dwChar:DWORD, dwMaxLength:DWORD
	LOCAL	dwRetVal:DWORD
	LOCAL	boolFound:DWORD
	
    pushf
    cld
    mov     esi, pStart
    mov     ecx, dwMaxLength
    xor     eax, eax
    mov		dwRetVal, eax
    .WHILE (ecx>0)
        mov		boolFound, TRUE
    	lodsb
    	mov		edx, dwChar
    	.BREAK .IF (al==dl)
    	inc		dwRetVal
    	mov		boolFound, FALSE
    .ENDW
    popf
	
	.IF (boolFound==TRUE)
		mov		eax, dwRetVal
		ret
	.ENDIF
	
	.IF (boolFound==FALSE)
		mov		eax, -1
		ret
	.ENDIF
	
	ret
FindChar		endp
;|
;|
szSleepMessage	db	"PodWrangler has resumed normal operations.",0
SleepManager	proc	dwDuration:DWORD
	
	invoke	Sleep, dwDuration
	mov		boolPaused, FALSE
	invoke	ShowToast, ADDR szSleepMessage
	
	xor		eax, eax
	ret
SleepManager endp  
;|
;+----------------------------------------------------------------------------+
include strsafe.asm
end start       ;| End of code section

;+----------------------------------------------------------------------------+
;|  End
;+----------------------------------------------------------------------------+

