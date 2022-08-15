package ddt.view.tips
{
   import ddt.data.goods.ItemTemplateInfo;
   
   public class GoodTipInfo
   {
       
      
      public var itemInfo:ItemTemplateInfo;
      
      public var typeIsSecond:Boolean = true;
      
      public var isBalanceTip:Boolean;
	  
	  public var latentEnergyItemId:int;
	  
	  public var ghostLv:int = -1;
      
      public function GoodTipInfo()
      {
         super();
      }
   }
}
