using System;

namespace ShellLib
{
	public class ShellExecute
	{
		public enum ShowWindowCommands
		{
			SW_HIDE             = 0,	// Hides the window and activates another window.
			SW_SHOWNORMAL       = 1,	// Sets the show state based on the SW_ flag specified in the STARTUPINFO 
			SW_NORMAL           = 1,	// structure passed to the CreateProcess function by the program that started 
			// the application.
			SW_SHOWMINIMIZED    = 2,	// Activates the window and displays it as a minimized window.
			SW_SHOWMAXIMIZED    = 3,	// Maximizes the specified window.
			SW_MAXIMIZE         = 3,	// Activates the window and displays it as a maximized window.
			SW_SHOWNOACTIVATE   = 4,	// Displays a window in its most recent size and position. The active window remains active.
			SW_SHOW             = 5,	// Activates the window and displays it in its current size and position.
			SW_MINIMIZE         = 6,	// Minimizes the specified window and activates the next top-level window in the z-order.
			SW_SHOWMINNOACTIVE  = 7,	// Displays the window as a minimized window. The active window remains active.
			SW_SHOWNA           = 8,	// Displays the window in its current state. The active window remains active.
			SW_RESTORE          = 9,	// Activates and displays the window.
			SW_SHOWDEFAULT      = 10,
		}
		
		public enum ShellExecuteReturnCodes
		{
			ERROR_OUT_OF_MEMORY			= 0,	// The operating system is out of memory or resources.
			ERROR_FILE_NOT_FOUND		= 2,	// The specified file was not found. 
			ERROR_PATH_NOT_FOUND		= 3,	// The specified path was not found. 
			ERROR_BAD_FORMAT			= 11,	// The .exe file is invalid (non-Microsoft Win32® .exe or error in .exe image). 
			SE_ERR_ACCESSDENIED			= 5,	// The operating system denied access to the specified file.  
			SE_ERR_ASSOCINCOMPLETE		= 27,	// The file name association is incomplete or invalid. 
			SE_ERR_DDEBUSY				= 30,	// The Dynamic Data Exchange (DDE) transaction could not be completed because other DDE transactions were being processed. 
			SE_ERR_DDEFAIL				= 29,	// The DDE transaction failed. 
			SE_ERR_DDETIMEOUT			= 28,	// The DDE transaction could not be completed because the request timed out. 
			SE_ERR_DLLNOTFOUND			= 32,	// The specified dynamic-link library (DLL) was not found.  
			SE_ERR_FNF					= 2,	// The specified file was not found.  
			SE_ERR_NOASSOC				= 31,	// There is no application associated with the given file name extension. This error will also be returned if you attempt to print a file that is not printable. 
			SE_ERR_OOM					= 8,	// There was not enough memory to complete the operation. 
			SE_ERR_PNF					= 3,	// The specified path was not found. 
			SE_ERR_SHARE				= 26,	// A sharing violation occurred. 
		}

		[Flags]
		public enum ShellExecuteFlags
		{
			SEE_MASK_CLASSNAME			= 0x00000001,		// Use the class name given by the lpClass member. 
			SEE_MASK_CLASSKEY			= 0x00000003,		// Use the class key given by the hkeyClass member.
			SEE_MASK_IDLIST				= 0x00000004,		// Use the item identifier list given by the lpIDList member. 
			// The lpIDList member must point to an ITEMIDLIST structure.
			SEE_MASK_INVOKEIDLIST		= 0x0000000c,		// Use the IContextMenu interface of the selected item's 
			// shortcut menu handler.
			SEE_MASK_ICON				= 0x00000010,		// Use the icon given by the hIcon member.
			SEE_MASK_HOTKEY				= 0x00000020,		// Use the hot key given by the dwHotKey member.
			SEE_MASK_NOCLOSEPROCESS		= 0x00000040,		// Use to indicate that the hProcess member receives the 
			// process handle. 
			SEE_MASK_CONNECTNETDRV		= 0x00000080,		// Validate the share and connect to a drive letter.
			SEE_MASK_FLAG_DDEWAIT		= 0x00000100,		// Wait for the Dynamic Data Exchange (DDE) conversation to 
			// terminate before returning
			SEE_MASK_DOENVSUBST			= 0x00000200,		// Expand any environment variables specified in the string 
			// given by the lpDirectory or lpFile member. 
			SEE_MASK_FLAG_NO_UI			= 0x00000400,		// Do not display an error message box if an error occurs. 
			SEE_MASK_UNICODE			= 0x00004000,		// Use this flag to indicate a Unicode application.
			SEE_MASK_NO_CONSOLE			= 0x00008000,		// Use to create a console for the new process instead of 
			// having it inherit the parent's console.
			SEE_MASK_ASYNCOK			= 0x00100000,
			SEE_MASK_HMONITOR			= 0x00200000,		// Use this flag when specifying a monitor on 
			// multi-monitor systems.
			SEE_MASK_NOQUERYCLASSSTORE	= 0x01000000,
			SEE_MASK_WAITFORINPUTIDLE	= 0x02000000,
			SEE_MASK_FLAG_LOG_USAGE		= 0x04000000		// Keep track of the number of times this application has 
			// been launched. 
		}


		// Common verbs
		public const string OpenFile		= "open";		// Opens the file specified by the lpFile parameter. 
															// The file can be an executable file, a document file, 
															// or a folder.
		public const string EditFile		= "edit";		// Launches an editor and opens the document for editing.
															// If lpFile is not a document file, the function 
															// will fail.
		public const string ExploreFolder	= "explore";	// Explores the folder specified by lpFile.
		public const string FindInFolder	= "find";		// Initiates a search starting from the specified 
															// directory.
		public const string PrintFile		= "print";		// Prints the document file specified by lpFile. If 
															// lpFile is not a document file, the function will fail.
		

		// properties
		public IntPtr OwnerHandle;			// Handle to the owner window
		public string Verb;					// The requested operation to make on the file
		public string Path;					// String that specifies the file or object on which to execute the 
											// specified verb.
		public string Parameters;			// String that specifies the parameters to be passed to the application.
		public string WorkingFolder;		// pecifies the default directory
		public ShowWindowCommands ShowMode;	// Flags that specify how an application is to be displayed 
														// when it is opened.

		public ShellExecute()
		{
			// Set default values
			OwnerHandle = IntPtr.Zero;
			Verb = OpenFile;
			Path = "";
			Parameters = "";
			WorkingFolder = "";
			ShowMode = ShowWindowCommands.SW_SHOWNORMAL;
		}

		public bool Execute()
		{
			int iRetVal;
			iRetVal = (int)ShellLib.ShellApi.ShellExecute(
				OwnerHandle,
				Verb,
				Path,
				Parameters,
				WorkingFolder,
				(int)ShowMode);

			return (iRetVal > 32) ? true : false;
		}


	}
}