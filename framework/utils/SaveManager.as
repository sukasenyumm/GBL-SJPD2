package framework.utils
{
	import flash.net.SharedObject;
	import flash.errors.IllegalOperationError;
	
	public class SaveManager 
	{
		private static var _instance:SaveManager = new SaveManager();
		private var saveDataObject:SharedObject;
		
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
			
			saveDataObject = SharedObject.getLocal("5v67575vdstd6sd"); // give the save data a location
			saveDataObject.data.score = 0;
			saveDataObject.data.distance = 0;
			saveDataObject.data.stars = 0;
			saveDataObject.data.item = false;
		
		}
		
		//saving score
		public function saveDataScore(score:uint):void
		{
     		if(saveDataObject.data.score == 0)
				saveDataObject.data.score = score; // set the saved score to the current score
     		else
				saveDataObject.data.score = 0;
				
			saveDataObject.flush(); // immediately save to the local drive
		}
		
		//loading score
		public function loadDataScore():uint
		{
     		return saveDataObject.data.score;
     	}
		
		//saving distance
		public function saveDataDistance(distance:uint):void
		{
     		if(saveDataObject.data.distance == 0)
				saveDataObject.data.distance = distance; // set the saved score to the current score
     		else
				saveDataObject.data.distance = 0;
				
			saveDataObject.flush(); // immediately save to the local drive
		}
		
		//loading distance
		public function loadDataDistance():uint
		{
     		return saveDataObject.data.distance;
     	}
		
		//saving stars
		public function saveDataStars(stars:uint):void
		{
     		if(saveDataObject.data.stars < 3)
			{
				if(saveDataObject.data.stars == 0)
					saveDataObject.data.stars = stars; // set the saved score to the current score
				else
					saveDataObject.data.stars = 0;
			}
			else
			{
				saveDataObject.data.stars = 0;
			}
				
			saveDataObject.flush(); // immediately save to the local drive
		}
		
		//loading distance
		public function loadDataStars():uint
		{
     		return saveDataObject.data.stars;
     	}
		
		
		public function saveDataItemSingle(item:Boolean):void
		{
     		saveDataObject.data.item = item; // set the saved score to the current score
     		saveDataObject.flush(); // immediately save to the local drive
		}
 
		public function loadDataItemSingle():Boolean
		{
     		if(saveDataObject.data.item == true)
				return true;
			else
				return false;
     	}
	}
}