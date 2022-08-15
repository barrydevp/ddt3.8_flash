package store.forge.fineGhost
{
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class FineGhostProgressBar extends Sprite implements Disposeable
   {
       
      
      private var _luckyTxt:FilterFrameText;
      
      private var _tips:FilterFrameText;
      
      private var _progressTxt:FilterFrameText;
      
      private var _progressBarBG:Bitmap;
      
      private var _progressBar:Bitmap;
      
      private var _mask:Shape;
      
      private var _currentProgress:Number;
      
      private var _maxWidth:int;
      
      private var _maxProgress:Number;
      
      public function FineGhostProgressBar()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         _luckyTxt = UICreatShortcut.creatTextAndAdd("ddt.store.equipGhost.luckyText",LanguageMgr.GetTranslation("tank.equipGhost.lucky"),this);
         _tips = UICreatShortcut.creatTextAndAdd("ddt.store.equipGhost.tipsText",LanguageMgr.GetTranslation("tank.equipGhost.tips"),this);
         _progressBarBG = UICreatShortcut.creatAndAdd("asset.equipGhost.progressBg",this);
         _progressBar = UICreatShortcut.creatAndAdd("asset.equipGhost.progressBar",this);
         _mask = new Shape();
         _mask.graphics.beginFill(16777215,1);
         _mask.graphics.drawRect(0,0,_progressBar.width,_progressBar.height);
         _mask.graphics.endFill();
         _mask.x = _progressBar.x;
         _mask.y = _progressBar.y;
         _progressBar.mask = _mask;
         addChild(_mask);
         _maxWidth = _progressBar.width;
         _progressTxt = UICreatShortcut.creatTextAndAdd("ddt.store.equipGhost.progress","100",this);
      }
      
      public function progress(param1:Number, param2:Number) : void
      {
         _currentProgress = param1;
         _maxProgress = param2;
         update();
      }
      
      private function update() : void
      {
         if(_maxProgress != 0)
         {
            _mask.width = _maxWidth * (_currentProgress / _maxProgress);
         }
         else
         {
            _mask.width = 0;
         }
         _progressTxt.text = _currentProgress + "/" + _maxProgress;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(_luckyTxt);
         _luckyTxt = null;
         ObjectUtils.disposeObject(_progressTxt);
         _progressTxt = null;
         ObjectUtils.disposeObject(_tips);
         _tips = null;
         ObjectUtils.disposeObject(_progressBarBG);
         _progressBarBG = null;
         ObjectUtils.disposeObject(_progressBar);
         _progressBar = null;
         ObjectUtils.disposeObject(_mask);
         _mask = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
