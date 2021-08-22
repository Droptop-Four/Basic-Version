using System;

namespace ShellLib
{

	public class ShellAddRecent
	{
		public enum ShellAddRecentDocs
		{
			SHARD_PIDL			= 0x00000001,	// The pv parameter points to a null-terminated string with the path 
												// and file name of the object.
			SHARD_PATHA			= 0x00000002,	// The pv parameter points to a pointer to an item identifier list 
												// (PIDL) that identifies the document's file object. PIDLs that 
												// identify nonfile objects are not allowed.
			SHARD_PATHW			= 0x00000003	// same as SHARD_PATHA but unicode string
		}

		public static void AddToList(String path)
		{
			ShellApi.SHAddToRecentDocs((uint)ShellAddRecentDocs.SHARD_PATHW,path);	
		}

		public static void ClearList()
		{
			ShellApi.SHAddToRecentDocs((uint)ShellAddRecentDocs.SHARD_PIDL,IntPtr.Zero);
		}
	}

}