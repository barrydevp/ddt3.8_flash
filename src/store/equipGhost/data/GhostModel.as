package store.equipGhost.data
{
   import flash.utils.Dictionary;
   
   public final class GhostModel
   {
       
      
      private var _dataList:Vector.<GhostData>;
      
      private var _topLvDic:Dictionary;
      
      public function GhostModel()
      {
         _topLvDic = new Dictionary();
         super();
      }
      
      public function initModel(param1:Vector.<GhostData>) : void
      {
         _dataList = param1;
         var _loc3_:int = -1;
		 var _loc2_:GhostData = null;
         for each(_loc2_ in _dataList)
         {
            _loc3_ = _loc2_.categoryID;
            if(!_topLvDic[_loc3_])
            {
               _topLvDic[_loc3_] = 0;
            }
            if(_loc2_.level > _topLvDic[_loc3_])
            {
               _topLvDic[_loc3_] = _loc2_.level;
            }
         }
      }
      
      public function get topLvDic() : Dictionary
      {
         return _topLvDic;
      }
      
      public function getGhostData(param1:int, param2:int) : GhostData
      {
		 var _loc3_:GhostData = null;
         for each(_loc3_ in this._dataList)
         {
            if(_loc3_.categoryID == param1 && _loc3_.level == param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
   }
}
