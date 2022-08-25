using System;
using System.Collections.Generic;
using System.IO;
using System.Windows.Forms;


namespace RobvanderWoude
{
	class OpenFolderBox
	{
		static string progver = "1.03";

		[STAThread]
		static int Main( string[] args )
		{
			string startfolder = Directory.GetCurrentDirectory( );
			string description = String.Format( "OpenFolderBox,  Version {0}", progver );
			bool startfolderset = false;
			bool descriptionset = false;
			bool allowmakedir = false;

			#region Command Line Parsing

			foreach ( string arg in args )
			{
				if ( arg == "/?" )
				{
					return ShowHelp( );
				}
			}
			if ( args.Length > 3 )
			{
				return ShowHelp( "Too many command line arguments" );
			}
			if ( args.Length > 0 )
			{
				foreach ( string arg in args )
				{
					switch ( arg.ToUpper( ) )
					{
						case "/?":
							return ShowHelp( );
						case "/MD":
							if ( allowmakedir )
							{
								return ShowHelp( "Duplicate command line switch /MD" );
							}
							allowmakedir = true;
							break;
						default:
							if ( startfolderset )
							{
								if ( descriptionset )
								{
									return ShowHelp( "Invalid or duplicate command line argument \"{0}\"", arg );
								}
								description = arg.Replace( "\\n", "\n" ).Replace( "\\t", "\t" );
								descriptionset = true;
							}
							else
							{
								try
								{
									startfolder = Path.GetFullPath( arg );
								}
								catch ( ArgumentException )
								{
									// Assuming the error was caused by a trailing bacslash in doublequotes
									startfolder = arg.Substring( 0, arg.IndexOf( '"' ) );
									startfolder = Path.GetFullPath( startfolder + "." );
								}
								if ( !Directory.Exists( startfolder ) )
								{
									return ShowHelp( "Invalid folder \"{0}\"", startfolder );
								}
								startfolderset = true;
							}
							break;
					}
				}
			}

			#endregion Command Line Parsing

			using ( FolderBrowserDialog dialog = new FolderBrowserDialog( ) )
			{
				dialog.SelectedPath = startfolder;
				dialog.Description = description;
				dialog.ShowNewFolderButton = allowmakedir;
				if ( dialog.ShowDialog( ) == DialogResult.OK )
				{
					Console.WriteLine( dialog.SelectedPath );
					return 0;
				}
				else
				{
					// Cancel was clicked
					return 2;
				}
			}
		}

		static int ShowHelp( params string[] errmsg )
		{
			/*
			OpenFolderBox.exe,  Version 1.02
			Batch tool to present a Browse Folders Dialog and return the selected path

			Usage:  OPENFOLDERBOX  [ "startfolder"  [ "description" ] ]  [ /MD ]

			Where:  "startfolder"  is the initial folder the dialog will show on opening
			                       (default: current directory)
			        "description"  is the text above the dialog's tree view
			                       (default: program name and version)
			        /MD            display the "Make New Folder" button
			                       (default: hide the button)

			Notes:  Though the "Make New Folder" button is hidden by default, this does
			        not inhibit manipulating folders using right-click or Shift+F10.
			        The full path of the selected folder is written to Standard Output
			        if OK was clicked, or an empty string if Cancel was clicked.
			        The return code will be 0 on success, 1 in case of (command line)
			        errors, or 2 if Cancel was clicked.

			Written by Rob van der Woude
			http://www.robvanderwoude.com
			*/

			#region Error Message

			if ( errmsg.Length > 0 )
			{
				List<string> errargs = new List<string>( errmsg );
				errargs.RemoveAt( 0 );
				Console.Error.WriteLine( );
				Console.ForegroundColor = ConsoleColor.Red;
				Console.Error.Write( "ERROR:\t" );
				Console.ForegroundColor = ConsoleColor.White;
				Console.Error.WriteLine( errmsg[0], errargs.ToArray( ) );
				Console.ResetColor( );
			}

			#endregion Error Message

			Console.Error.WriteLine( );

			Console.Error.WriteLine( "OpenFolderBox.exe,  Version {0}", progver );

			Console.Error.WriteLine( "Batch tool to present a Browse Folders Dialog and return the selected path" );

			Console.Error.WriteLine( );

			Console.Error.Write( "Usage:  " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.WriteLine( "OPENFOLDERBOX  [ \"startfolder\"  [ \"description\" ] ]  [ /MD ]" );
			Console.ResetColor( );

			Console.Error.WriteLine( );

			Console.Error.Write( "Where:  " );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "\"startfolder\"" );
			Console.ResetColor( );
			Console.Error.WriteLine( "  is the initial folder the dialog will show on opening" );

			Console.Error.WriteLine( "                       (default: current directory)" );

			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "        \"description\"" );
			Console.ResetColor( );
			Console.Error.WriteLine( "  is the text above the dialog's tree view" );

			Console.Error.WriteLine( "                       (default: \"OpenFolderBox,  Version {0}\")", progver );

			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "        /MD" );
			Console.ResetColor( );
			Console.Error.Write( "            display the \"" );
			Console.ForegroundColor = ConsoleColor.White;
			Console.Error.Write( "M" );
			Console.ResetColor( );
			Console.Error.WriteLine( "ake New Folder\" button" );

			Console.Error.WriteLine( "                       (default: hide the button)" );

			Console.Error.WriteLine( );

			Console.Error.WriteLine( "Notes:  Though the \"Make New Folder\" button is hidden by default, this does" );

			Console.Error.WriteLine( "        not inhibit manipulating folders using right-click or Shift+F10." );

			Console.Error.WriteLine( "        The full path of the selected folder is written to Standard Output" );

			Console.Error.WriteLine( "        if OK was clicked, or an empty string if Cancel was clicked." );

			Console.Error.WriteLine( "        The return code will be 0 on success, 1 in case of (command line)" );

			Console.Error.WriteLine( "        errors, or 2 if Cancel was clicked." );

			Console.Error.WriteLine( );

			Console.Error.WriteLine( "Written by Rob van der Woude" );

			Console.Error.WriteLine( "http://www.robvanderwoude.com" );

			return 1;
		}
	}
}
