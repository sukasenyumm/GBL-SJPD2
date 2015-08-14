package framework.utils
{
	import flash.net.SharedObject;
	import flash.errors.IllegalOperationError;
	
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
		
		public function Initialize():void
		{
			
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
			
		}
		
		//saving score
		public function saveDataScore(score:int):void
		{
			var saveDataObject:SharedObject = SharedObject.getLocal("5v67575vd77d6sd");
			if(saveDataObject.data.score != null)
			{
				trace("berhasil"+String(saveDataObject.data.score)+score);
				if(saveDataObject.data.score == "0")
					saveDataObject.data.score = score; // set the saved score to the current score
				else
					saveDataObject.data.score = int(saveDataObject.data.score)+score;
					
				saveDataObject.flush(); // immediately save to the local drive
			}
			else
			trace("gagaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaal")
		}
		
		//loading score
		public function loadDataScore():int
		{
			var saveDataObject:SharedObject = SharedObject.getLocal("5v67575vd77d6sd");
			trace(saveDataObject.data.score)
     		return saveDataObject.data.score;
     	}
		
		
	}
}