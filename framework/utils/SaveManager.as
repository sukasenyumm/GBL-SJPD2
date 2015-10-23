package framework.utils
{
	import flash.net.SharedObject;
	import flash.errors.IllegalOperationError;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.errors.IOError;
	
	public class SaveManager 
	{
		private static var _instance:SaveManager = new SaveManager();
		
		public function SaveManager() 
		{
			if (_instance != null) {
                throw new IllegalOperationError("SingletonClass can't be instantiated because is a Singleton. Use getInstance() to retrieve a class reference.");
            }
		}
		
		public static function getInstance():SaveManager
		{
			return _instance;
		}
		
		//initialize all save data
		public function initialize():void
		{
			if(GameSettings.isAndroid){
				var saveDataObject:SharedObject = SharedObject.getLocal("5v67575vd77d6sd");
				var temp:int = int(saveDataObject.data.score);
				if(saveDataObject.data.score != null)
				{
					if ( int(saveDataObject.data.score) >= 0)
					{
						//do nothing
					}
					else
					{
						saveDataObject.data.score = 0;
					}
				}
				else
				{
					saveDataObject.data.score = 0;
				}
				if(saveDataObject.data.godlike != null)
				{
					if ( int(saveDataObject.data.godlike) >= 0)
					{
						//do nothing
					}
					else
					{
						saveDataObject.data.godlike = 0;
					}
				}
				else
				{
					saveDataObject.data.godlike = 0;
				}
				if(saveDataObject.data.galInfo1 != null && 
				   saveDataObject.data.galInfo2 != null &&
				   saveDataObject.data.galInfo3 != null &&
				   saveDataObject.data.galInfo4 != null &&
				   saveDataObject.data.galInfo5 != null &&
				   saveDataObject.data.galInfo6 != null &&
				   saveDataObject.data.galInfo7 != null &&
				   saveDataObject.data.galInfo8 != null &&
				   saveDataObject.data.galInfo9 != null &&
				   saveDataObject.data.galInfo10 != null)
				{
					if ( int(saveDataObject.data.score) >= 0)
					{
						//do nothing
					}
					else
					{
						saveDataObject.data.galInfo1 = 0;
						saveDataObject.data.galInfo2 = 0;
						saveDataObject.data.galInfo3 = 0;
						saveDataObject.data.galInfo4 = 0;
						saveDataObject.data.galInfo5 = 0;
						saveDataObject.data.galInfo6 = 0;
						saveDataObject.data.galInfo7 = 0;
						saveDataObject.data.galInfo8 = 0;
						saveDataObject.data.galInfo9 = 0;
						saveDataObject.data.galInfo10 = 0;
					}
				}
				else
				{
					saveDataObject.data.galInfo1 = 0;
					saveDataObject.data.galInfo2 = 0;
					saveDataObject.data.galInfo3 = 0;
					saveDataObject.data.galInfo4 = 0;
					saveDataObject.data.galInfo5 = 0;
					saveDataObject.data.galInfo6 = 0;
					saveDataObject.data.galInfo7 = 0;
					saveDataObject.data.galInfo8 = 0;
					saveDataObject.data.galInfo9 = 0;
					saveDataObject.data.galInfo10 = 0;
				}
			}
			
			if(GameSettings.isIOS)
			{
				var f:File = File.desktopDirectory.resolvePath("score.conf");
				var fs:FileStream = new FileStream();
					
				//score
				try {
					fs.open(f, FileMode.READ);
					var objReader:int = fs.readInt();
					var temporary:int = objReader;
					fs.close();
				} catch(e:IOError) {
					var temporary:int = -1;
					fs.open(f, FileMode.WRITE);
				}
				
				if(temporary == 0)
				{
					if ( temporary >= 0)
					{
						//do nothing
					}
					else
					{
						fs.writeInt(0);
						fs.close();
					}
				}
				else
				{
						fs.writeInt(0);
						fs.close();
				}
				
				//godlike
				var fg:File = File.applicationStorageDirectory.resolvePath("godlike.conf");
				var fsg:FileStream = new FileStream();
				
				fsg.open(fg, FileMode.READ);
				var objReaderg:int = fsg.readInt();
				var temporaryg:int = objReaderg;
				fsg.close();
				
				fsg.open(fg, FileMode.WRITE);
				if(temporaryg == 0)
				{
					if ( temporaryg >= 0)
					{
						//do nothing
					}
					else
					{
						fsg.writeInt(0);
						fsg.close();
					}
				}
				else
				{
						fsg.writeInt(0);
						fsg.close();
				}
				
				//item
				var fi:File = File.applicationStorageDirectory.resolvePath("items.conf");
				var fsi:FileStream = new FileStream();
				
				fsi.open(f, FileMode.READ);
				var objReaderi:Object = fsi.readObject();
				var temporaryi:Object = objReaderi;
				fsi.close();
				
				fsi.open(fi, FileMode.WRITE);
				var obj:Object = {	galInfo1:0, 
									galInfo2:0,
									galInfo3:0,
									galInfo4:0,
									galInfo5:0,
									galInfo6:0,
									galInfo7:0,
									galInfo8:0,
									galInfo9:0,
									galInfo10:0}; 
						
				if(temporaryi != null)
				{
					if ( temporaryi >= 0)
					{
						//do nothing
					}
					else
					{
						fsi.writeObject(obj);
						fsi.close();
					}
				}
				else
				{
						fsi.writeObject(obj);
						fsi.close();
				}
			}
			
		}
		
		//saving score
		public function saveDataScore(score:int):void
		{
			var saveDataObject:SharedObject = SharedObject.getLocal("5v67575vd77d6sd");
			if(saveDataObject.data.score != null)
			{
				//trace("berhasil"+String(saveDataObject.data.score)+score);
				if(saveDataObject.data.score == "0")
					saveDataObject.data.score = score; // set the saved score to the current score
				else
					saveDataObject.data.score = int(saveDataObject.data.score)+score;
					
				saveDataObject.flush(); // immediately save to the local drive
			}
			else{}
			//trace("gagaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaal")
		}
		
		//loading score
		public function loadDataScore():int
		{
			var saveDataObject:SharedObject = SharedObject.getLocal("5v67575vd77d6sd");
			//trace(saveDataObject.data.score)
     		return saveDataObject.data.score;
     	}
		
		//saving gal info
		public function saveGalInfo(x:Boolean,index:int):void
		{
			var saveDataObject:SharedObject = SharedObject.getLocal("5v67575vd77d6sd");
			if(saveDataObject.data.galInfo1 != null && 
			   saveDataObject.data.galInfo2 != null &&
			   saveDataObject.data.galInfo3 != null &&
			   saveDataObject.data.galInfo4 != null &&
			   saveDataObject.data.galInfo5 != null &&
			   saveDataObject.data.galInfo6 != null &&
			   saveDataObject.data.galInfo7 != null &&
			   saveDataObject.data.galInfo8 != null &&
			   saveDataObject.data.galInfo9 != null &&
			   saveDataObject.data.galInfo10 != null)
			{
				switch(index)
				{
					case 1:
					saveDataObject.data.galInfo1 = uint(x); // set the saved score to the current score
					saveDataObject.flush(); // immediately save to the local drive
					break;
					case 2:
					saveDataObject.data.galInfo2 = uint(x); // set the saved score to the current score
					saveDataObject.flush(); // immediately save to the local drive
					break;
					case 3:
					saveDataObject.data.galInfo3 = uint(x); // set the saved score to the current score
					saveDataObject.flush(); // immediately save to the local drive
					break;
					case 4:
					saveDataObject.data.galInfo4 = uint(x); // set the saved score to the current score
					saveDataObject.flush(); // immediately save to the local drive
					break;
					case 5:
					saveDataObject.data.galInfo5 = uint(x); // set the saved score to the current score
					saveDataObject.flush(); // immediately save to the local drive
					break;
					case 6:
					saveDataObject.data.galInfo6 = uint(x); // set the saved score to the current score
					saveDataObject.flush(); // immediately save to the local drive
					break;
					case 7:
					saveDataObject.data.galInfo7 = uint(x); // set the saved score to the current score
					saveDataObject.flush(); // immediately save to the local drive
					break;
					case 8:
					saveDataObject.data.galInfo8 = uint(x); // set the saved score to the current score
					saveDataObject.flush(); // immediately save to the local drive
					break;
					case 9:
					saveDataObject.data.galInfo9 = uint(x); // set the saved score to the current score
					saveDataObject.flush(); // immediately save to the local drive
					break;
					case 10:
					saveDataObject.data.galInfo10 = uint(x); // set the saved score to the current score
					saveDataObject.flush(); // immediately save to the local drive
					break;
				}
			}
			else{}
			//trace("gagaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaal")
		}
		
		//loading score
		public function loadGalInfo(index:int):int
		{
			var saveDataObject:SharedObject = SharedObject.getLocal("5v67575vd77d6sd");
			switch(index)
			{
				case 1:
				return saveDataObject.data.galInfo1;
				break;
				case 2:
				return saveDataObject.data.galInfo2;
				break;
				case 3:
				return saveDataObject.data.galInfo3;
				break;
				case 4:
				return saveDataObject.data.galInfo4;
				break;
				case 5:
				return saveDataObject.data.galInfo5;
				break;
				case 6:
				return saveDataObject.data.galInfo6;
				break;
				case 7:
				return saveDataObject.data.galInfo7;
				break;
				case 8:
				return saveDataObject.data.galInfo8;
				break;
				case 9:
				return saveDataObject.data.galInfo9;
				break;
				case 10:
				return saveDataObject.data.galInfo10;
				break;
				default:
				return saveDataObject.data.galInfo1;
				break;
			} 		
     	}
		
		public function saveDataGodlike(x:Boolean):void
		{
			var saveDataObject:SharedObject = SharedObject.getLocal("5v67575vd77d6sd");
			if(saveDataObject.data.godlike != null)
			{
				saveDataObject.data.godlike = uint(x); // set the saved score to the current score
				saveDataObject.flush(); // immediately save to the local drive
			}
			else{}
			//trace("gagaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaal")
		}
		
		//loading score
		public function loadDataGodlike():int
		{
			var saveDataObject:SharedObject = SharedObject.getLocal("5v67575vd77d6sd");
			return saveDataObject.data.godlike;
     	}
		
		public function resetData():void
		{
			var saveDataObject:SharedObject = SharedObject.getLocal("5v67575vd77d6sd");
			saveDataObject.data.score = 0;
			saveDataObject.data.galInfo1 = 0;
			saveDataObject.data.galInfo2 = 0;
			saveDataObject.data.galInfo3 = 0;
			saveDataObject.data.galInfo4 = 0;
			saveDataObject.data.galInfo5 = 0;
			saveDataObject.data.galInfo6 = 0;
			saveDataObject.data.galInfo7 = 0;
			saveDataObject.data.galInfo8 = 0;
			saveDataObject.data.galInfo9 = 0;
			saveDataObject.data.galInfo10 = 0;
			saveDataObject.data.godlike = 0;
		}
		
		public function cheatMode():void
		{
			var saveDataObject:SharedObject = SharedObject.getLocal("5v67575vd77d6sd");
			saveDataObject.data.score = 9999999999;
			saveDataObject.data.galInfo1 = 1;
			saveDataObject.data.galInfo2 = 1;
			saveDataObject.data.galInfo3 = 1;
			saveDataObject.data.galInfo4 = 1;
			saveDataObject.data.galInfo5 = 1;
			saveDataObject.data.galInfo6 = 1;
			saveDataObject.data.galInfo7 = 1;
			saveDataObject.data.galInfo8 = 1;
			saveDataObject.data.galInfo9 = 1;
			saveDataObject.data.galInfo10 = 1;
			saveDataObject.data.godlike = 1;
		}
		
	}
}