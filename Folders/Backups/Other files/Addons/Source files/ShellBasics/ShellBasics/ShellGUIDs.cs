using System;
using System.Runtime.InteropServices;

namespace ShellLib
{
	public class ShellGUIDs
	{
		public static Guid IID_IMalloc = 
			new Guid("{00000002-0000-0000-C000-000000000046}");
		public static Guid IID_IShellFolder = 
			new Guid("{000214E6-0000-0000-C000-000000000046}");
		public static Guid IID_IFolderFilterSite = 
			new Guid("{C0A651F5-B48B-11d2-B5ED-006097C686F6}");
		public static Guid IID_IFolderFilter = 
			new Guid("{9CC22886-DC8E-11d2-B1D0-00C04F8EEB3E}");
	}
}