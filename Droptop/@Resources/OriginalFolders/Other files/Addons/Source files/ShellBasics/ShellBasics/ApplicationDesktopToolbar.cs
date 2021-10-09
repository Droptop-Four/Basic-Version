using System;
using System.Runtime.InteropServices;
using System.ComponentModel;
using System.Drawing;
using System.Windows.Forms;

namespace ShellLib
{

	public class ApplicationDesktopToolbar : Form
	{

		#region Enums
		public enum AppBarMessages
		{
			/// <summary>
			/// Registers a new appbar and specifies the message identifier
			/// that the system should use to send notification messages to 
			/// the appbar. 
			/// </summary>
			New					= 0x00000000,	
			/// <summary>
			/// Unregisters an appbar, removing the bar from the system's 
			/// internal list.
			/// </summary>
			Remove				= 0x00000001,
			/// <summary>
			/// Requests a size and screen position for an appbar.
			/// </summary>
			QueryPos			= 0x00000002,	
			/// <summary>
			/// Sets the size and screen position of an appbar. 
			/// </summary>
			SetPos				= 0x00000003,	
			/// <summary>
			/// Retrieves the autohide and always-on-top states of the 
			/// Microsoft® Windows® taskbar. 
			/// </summary>
			GetState			= 0x00000004,	
			/// <summary>
			/// Retrieves the bounding rectangle of the Windows taskbar. 
			/// </summary>
			GetTaskBarPos		= 0x00000005,	
			/// <summary>
			/// Notifies the system that an appbar has been activated. 
			/// </summary>
			Activate			= 0x00000006,	
			/// <summary>
			/// Retrieves the handle to the autohide appbar associated with
			/// a particular edge of the screen. 
			/// </summary>
			GetAutoHideBar		= 0x00000007,	
			/// <summary>
			/// Registers or unregisters an autohide appbar for an edge of 
			/// the screen. 
			/// </summary>
			SetAutoHideBar		= 0x00000008,	
			/// <summary>
			/// Notifies the system when an appbar's position has changed. 
			/// </summary>
			WindowPosChanged	= 0x00000009,	
			/// <summary>
			/// Sets the state of the appbar's autohide and always-on-top 
			/// attributes.
			/// </summary>
			SetState			= 0x0000000a	
		}
		

		public enum AppBarNotifications
		{
			/// <summary>
			/// Notifies an appbar that the taskbar's autohide or 
			/// always-on-top state has changed—that is, the user has selected 
			/// or cleared the "Always on top" or "Auto hide" check box on the
			/// taskbar's property sheet. 
			/// </summary>
			StateChange			= 0x00000000,	
			/// <summary>
			/// Notifies an appbar when an event has occurred that may affect 
			/// the appbar's size and position. Events include changes in the
			/// taskbar's size, position, and visibility state, as well as the
			/// addition, removal, or resizing of another appbar on the same 
			/// side of the screen.
			/// </summary>
			PosChanged			= 0x00000001,	
			/// <summary>
			/// Notifies an appbar when a full-screen application is opening or
			/// closing. This notification is sent in the form of an 
			/// application-defined message that is set by the ABM_NEW message. 
			/// </summary>
			FullScreenApp		= 0x00000002,	
			/// <summary>
			/// Notifies an appbar that the user has selected the Cascade, 
			/// Tile Horizontally, or Tile Vertically command from the 
			/// taskbar's shortcut menu.
			/// </summary>
			WindowArrange		= 0x00000003	
		}
		
		[Flags]
		public enum AppBarStates
		{
			AutoHide			= 0x00000001,
			AlwaysOnTop			= 0x00000002
		}

				
		public enum AppBarEdges
		{
			Left				= 0,
			Top					= 1,
			Right				= 2,
			Bottom				= 3,
			Float				= 4
		}
	
		// Window Messages		
		public enum WM
		{
			ACTIVATE				= 0x0006,
			WINDOWPOSCHANGED		= 0x0047,
			NCHITTEST				= 0x0084
		}

		public enum MousePositionCodes
		{
			HTERROR             = (-2),
			HTTRANSPARENT       = (-1),
			HTNOWHERE           = 0,
			HTCLIENT            = 1,
			HTCAPTION           = 2,
			HTSYSMENU           = 3,
			HTGROWBOX           = 4,
			HTSIZE              = HTGROWBOX,
			HTMENU              = 5,
			HTHSCROLL           = 6,
			HTVSCROLL           = 7,
			HTMINBUTTON         = 8,
			HTMAXBUTTON         = 9,
			HTLEFT              = 10,
			HTRIGHT             = 11,
			HTTOP               = 12,
			HTTOPLEFT           = 13,
			HTTOPRIGHT          = 14,
			HTBOTTOM            = 15,
			HTBOTTOMLEFT        = 16,
			HTBOTTOMRIGHT       = 17,
			HTBORDER            = 18,
			HTREDUCE            = HTMINBUTTON,
			HTZOOM              = HTMAXBUTTON,
			HTSIZEFIRST         = HTLEFT,
			HTSIZELAST          = HTBOTTOMRIGHT,
			HTOBJECT            = 19,
			HTCLOSE             = 20,
			HTHELP              = 21
		}

		#endregion Enums
        
		#region AppBar Functions

		private Boolean AppbarNew()
		{
			if (CallbackMessageID == 0)
				throw new Exception("CallbackMessageID is 0");

			if (IsAppbarMode)
				return true;

			m_PrevSize = Size;
			m_PrevLocation = Location;

			// prepare data structure of message
			ShellApi.APPBARDATA msgData = new ShellApi.APPBARDATA();
			msgData.cbSize = (UInt32)Marshal.SizeOf(msgData);
			msgData.hWnd = Handle;
			msgData.uCallbackMessage = CallbackMessageID;

			// install new appbar
			UInt32 retVal = ShellApi.SHAppBarMessage((UInt32)AppBarMessages.New,ref msgData);
			IsAppbarMode = (retVal!=0);
			
			SizeAppBar();
			
			return IsAppbarMode;
		}
		
		private Boolean AppbarRemove()
		{
			// prepare data structure of message
			ShellApi.APPBARDATA msgData = new ShellApi.APPBARDATA();
			msgData.cbSize = (UInt32)Marshal.SizeOf(msgData);
			msgData.hWnd = Handle;
					
			// remove appbar
			UInt32 retVal = ShellApi.SHAppBarMessage((UInt32)AppBarMessages.Remove,ref msgData);
			
			IsAppbarMode = false;

			Size = m_PrevSize;
			Location = m_PrevLocation;

			return (retVal!=0) ? true : false;
		}
		
		private void AppbarQueryPos(ref ShellApi.RECT appRect)
		{
			// prepare data structure of message
			ShellApi.APPBARDATA msgData = new ShellApi.APPBARDATA();
			msgData.cbSize = (UInt32)Marshal.SizeOf(msgData);
			msgData.hWnd = Handle;
			msgData.uEdge = (UInt32)m_Edge;
			msgData.rc = appRect;

			// query postion for the appbar
			ShellApi.SHAppBarMessage((UInt32)AppBarMessages.QueryPos, ref msgData);
			appRect	= msgData.rc;
		}
		
		private void AppbarSetPos(ref ShellApi.RECT appRect)
		{
			// prepare data structure of message
			ShellApi.APPBARDATA msgData = new ShellApi.APPBARDATA();
			msgData.cbSize = (UInt32)Marshal.SizeOf(msgData);
			msgData.hWnd = Handle;
			msgData.uEdge = (UInt32)m_Edge;
			msgData.rc = appRect;

			// set postion for the appbar
			ShellApi.SHAppBarMessage((UInt32)AppBarMessages.SetPos, ref msgData);
			appRect	= msgData.rc;
		}

		private void AppbarActivate()
		{
			// prepare data structure of message
			ShellApi.APPBARDATA msgData = new ShellApi.APPBARDATA();
			msgData.cbSize = (UInt32)Marshal.SizeOf(msgData);
			msgData.hWnd = Handle;
			
			// send activate to the system
			ShellApi.SHAppBarMessage((UInt32)AppBarMessages.Activate, ref msgData);
		}

		private void AppbarWindowPosChanged()
		{
			// prepare data structure of message
			ShellApi.APPBARDATA msgData = new ShellApi.APPBARDATA();
			msgData.cbSize = (UInt32)Marshal.SizeOf(msgData);
			msgData.hWnd = Handle;
			
			// send windowposchanged to the system 
			ShellApi.SHAppBarMessage((UInt32)AppBarMessages.WindowPosChanged, ref msgData);
		}

		private Boolean AppbarSetAutoHideBar(Boolean hideValue)
		{
			// prepare data structure of message
			ShellApi.APPBARDATA msgData = new ShellApi.APPBARDATA();
			msgData.cbSize = (UInt32)Marshal.SizeOf(msgData);
			msgData.hWnd = Handle;
			msgData.uEdge = (UInt32)m_Edge;
			msgData.lParam = (hideValue) ? 1 : 0;
					
			// set auto hide
			UInt32 retVal = ShellApi.SHAppBarMessage((UInt32)AppBarMessages.SetAutoHideBar,ref msgData);
			return (retVal!=0) ? true : false;
		}

		private IntPtr AppbarGetAutoHideBar(AppBarEdges edge)
		{
			// prepare data structure of message
			ShellApi.APPBARDATA msgData = new ShellApi.APPBARDATA();
			msgData.cbSize = (UInt32)Marshal.SizeOf(msgData);
			msgData.uEdge = (UInt32)edge;
					
			// get auto hide
			IntPtr retVal = (IntPtr)ShellApi.SHAppBarMessage((UInt32)AppBarMessages.GetAutoHideBar,ref msgData);
			return retVal;
		}

		private AppBarStates AppbarGetTaskbarState()
		{
			// prepare data structure of message
			ShellApi.APPBARDATA msgData = new ShellApi.APPBARDATA();
			msgData.cbSize = (UInt32)Marshal.SizeOf(msgData);
					
			// get taskbar state
			UInt32 retVal = ShellApi.SHAppBarMessage((UInt32)AppBarMessages.GetState, ref msgData);
			return (AppBarStates)retVal;
		}

		private void AppbarSetTaskbarState(AppBarStates state)
		{
			// prepare data structure of message
			ShellApi.APPBARDATA msgData = new ShellApi.APPBARDATA();
			msgData.cbSize = (UInt32)Marshal.SizeOf(msgData);
			msgData.lParam = (Int32)state;
					
			// set taskbar state
			ShellApi.SHAppBarMessage((UInt32)AppBarMessages.SetState, ref msgData);
		}

		private void AppbarGetTaskbarPos(out ShellApi.RECT taskRect)
		{
			// prepare data structure of message
			ShellApi.APPBARDATA msgData = new ShellApi.APPBARDATA();
			msgData.cbSize = (UInt32)Marshal.SizeOf(msgData);
					
			// get taskbar position
			ShellApi.SHAppBarMessage((UInt32)AppBarMessages.GetTaskBarPos, ref msgData);
			taskRect = msgData.rc;
		}

		#endregion AppBar Functions
		
		#region Private Variables
		
		// saves the current edge
		private AppBarEdges m_Edge = AppBarEdges.Float;

		// saves the callback message id
		private UInt32 CallbackMessageID = 0;

		// are we in dock mode?
		private Boolean IsAppbarMode = false;

		// save the floating size and location
		private Size m_PrevSize;
		private Point m_PrevLocation;
		
		#endregion Private Variables
		
		public ApplicationDesktopToolbar()
		{
			FormBorderStyle = FormBorderStyle.SizableToolWindow;
		    
			// Register a unique message as our callback message
			CallbackMessageID = RegisterCallbackMessage();
			if (CallbackMessageID == 0)
				throw new Exception("RegisterCallbackMessage failed");
		}
			
		private UInt32 RegisterCallbackMessage()
		{
			String uniqueMessageString = Guid.NewGuid().ToString();
			return ShellApi.RegisterWindowMessage(uniqueMessageString);
		}

		private void SizeAppBar()
		{
			ShellApi.RECT rt = new ShellApi.RECT();

			if ((m_Edge == AppBarEdges.Left) ||
				(m_Edge == AppBarEdges.Right))
			{
				rt.top = 0;
				rt.bottom = SystemInformation.PrimaryMonitorSize.Height;
				if (m_Edge == AppBarEdges.Left)
				{
					rt.right = m_PrevSize.Width;
				}
				else
				{
					rt.right = SystemInformation.PrimaryMonitorSize.Width;
					rt.left = rt.right - m_PrevSize.Width;
				}
			}
			else
			{
				rt.left = 0;
				rt.right = SystemInformation.PrimaryMonitorSize.Width;
				if (m_Edge == AppBarEdges.Top)
				{
					rt.bottom = m_PrevSize.Height;
				}
				else
				{
					rt.bottom = SystemInformation.PrimaryMonitorSize.Height;
					rt.top = rt.bottom - m_PrevSize.Height;
				}
			}

			AppbarQueryPos(ref rt);
			switch (m_Edge) 
			{
				case AppBarEdges.Left: 
					rt.right = rt.left + m_PrevSize.Width;
					break; 
				case AppBarEdges.Right: 
					rt.left= rt.right - m_PrevSize.Width;
					break; 
				case AppBarEdges.Top:
					// gets commandline arguments, (argument 0 when referenced this way is the app path/name)
					// sents argument 1 as variable, uses variable to set bar reservation size
					string[] args = Environment.GetCommandLineArgs();
					int val = Convert.ToInt32(args[1]);
					// rt.bottom = rt.top + val;
					rt.bottom = val;
					break; 
				case AppBarEdges.Bottom: 
					rt.top = rt.bottom - m_PrevSize.Height;
					break; 
			}

			AppbarSetPos(ref rt);

			Location = new Point(rt.left,rt.top);
			Size = new Size(rt.right - rt.left,rt.bottom - rt.top);
		}
		
		
		#region Message Handlers

		void OnAppbarNotification(ref Message msg)
		{
			AppBarStates state;
			AppBarNotifications msgType = (AppBarNotifications)(Int32)msg.WParam;
					
			switch (msgType)
			{
				case AppBarNotifications.PosChanged:
					SizeAppBar();
					break;
						
				case AppBarNotifications.StateChange:
					state = AppbarGetTaskbarState();
					if ((state & AppBarStates.AlwaysOnTop) !=0)
					{
						TopMost = true;
						BringToFront();
					}
					else
					{
						TopMost = false;
						SendToBack();
					}
					break;

				case AppBarNotifications.FullScreenApp:
					if ((int)msg.LParam !=0)
					{
						TopMost = false;
						SendToBack();
					}
					else
					{
						state = AppbarGetTaskbarState();
						if ((state & AppBarStates.AlwaysOnTop) !=0)
						{
							TopMost = true;
							BringToFront();
						}
						else
						{
							TopMost = false;
							SendToBack();
						}
					}
							
					break;

				case AppBarNotifications.WindowArrange:
					if ((int)msg.LParam != 0)	// before
						Visible = false;
					else						// after
						Visible = true;
							
					break;
			}
		}

		void OnNcHitTest(ref Message msg)
		{
			DefWndProc(ref msg);
			if ((m_Edge == AppBarEdges.Top) && ((int)msg.Result == (int)MousePositionCodes.HTBOTTOM))
				0.ToString();	
			else if ((m_Edge == AppBarEdges.Bottom) && ((int)msg.Result == (int)MousePositionCodes.HTTOP))
				0.ToString();	
			else if ((m_Edge == AppBarEdges.Left) && ((int)msg.Result == (int)MousePositionCodes.HTRIGHT))
				0.ToString();	
			else if ((m_Edge == AppBarEdges.Right) && ((int)msg.Result == (int)MousePositionCodes.HTLEFT))
				0.ToString();	
			else if ((int)msg.Result == (int)MousePositionCodes.HTCLOSE)
				0.ToString();	
			else
			{
				msg.Result = (IntPtr)MousePositionCodes.HTCLIENT;
				return;
			}
			base.WndProc(ref msg);
		}


		#endregion Message Handlers

		#region Window Procedure

		protected override void WndProc(ref Message msg)
		{
			if (IsAppbarMode)
			{
				if (msg.Msg == CallbackMessageID)
				{
					OnAppbarNotification(ref msg);
				}
				else if (msg.Msg == (int)WM.ACTIVATE)
				{
					AppbarActivate();
				}
				else if (msg.Msg == (int)WM.WINDOWPOSCHANGED)
				{
					AppbarWindowPosChanged();
				}
				else if (msg.Msg == (int)WM.NCHITTEST)
				{
					OnNcHitTest(ref msg);
					return;
				}
			}
				
			base.WndProc(ref msg);
		}
		
		#endregion Window Procedure

		protected override void OnLoad(EventArgs e)
		{
			m_PrevSize = Size;
			m_PrevLocation = Location;
			base.OnLoad(e);
		}

		protected override void OnClosing(CancelEventArgs e)
		{
			AppbarRemove();
			base.OnClosing(e);
		}
		
		protected override void OnSizeChanged(EventArgs e)
		{
			if (IsAppbarMode)
			{
				if (m_Edge == AppBarEdges.Top || m_Edge == AppBarEdges.Bottom)
					m_PrevSize.Height = Size.Height;
				else
					m_PrevSize.Width = Size.Width;

				SizeAppBar();
			}
			
			base.OnSizeChanged(e);
		}
		

		public AppBarEdges Edge 
		{
			get 
			{
				return m_Edge;
			}
			set 
			{
				m_Edge = value;
				if (value == AppBarEdges.Float)
					AppbarRemove();
				else
					AppbarNew();

				if (IsAppbarMode)
					SizeAppBar();
				
			}
		}
	}
}