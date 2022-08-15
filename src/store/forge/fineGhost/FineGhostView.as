package store.forge.fineGhost
{
   import com.greensock.TweenMax;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   import bagAndInfo.cell.BagCell;
   
   import baglocked.BaglockedManager;
   
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.events.CEvent;
   import ddt.events.CellEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.HelpFrameUtils;
   import ddt.utils.PositionUtils;
   import ddt.view.common.BuyItemButton;
   
   import road7th.utils.MathUtils;
   
   import store.IStoreViewBG;
   import store.StoreBagBgWHPoint;
   import store.StoreCell;
   import store.StoreController;
   import store.StoreDragInArea;
   import store.StoreMainView;
   import store.data.StoreModel;
   import store.equipGhost.EquipGhostManager;
   import store.equipGhost.data.EquipGhostData;
   import store.equipGhost.data.GhostData;
   import store.events.StoreDargEvent;
   import store.view.StoneCellFrame;
   import store.view.storeBag.StoreBagCell;
   import store.view.storeBag.StoreBagController;
   import store.view.storeBag.StoreBagView;
   
   public final class FineGhostView extends Sprite implements Disposeable, IStoreViewBG
   {
       
      
      private var _area:StoreDragInArea;
      
      private var _items:Array;
      
      private var _luckyStoneCell:StoneCellFrame;
      
      private var _ghostStoneCell:StoneCellFrame;
      
      private var _equipmentCell:StoneCellFrame;
      
      private var _ghostBtn:SimpleBitmapButton;
      
      private var _ghostHelpBtn:BaseButton;
      
      private var _cBuyluckyBtn:BuyItemButton;
      
      private var _buyStoneBtn:BuyItemButton;
      
      private var _ratioTxt:FilterFrameText;
      
      private var _continuesBtn:SelectedCheckButton;
      
      private var _progressBar:FineGhostProgressBar;
      
      private var _controller:StoreBagController;
      
      private var _view:DisplayObject;
      
      private var _moveSprite:Sprite;
      
      private var _successBit:Bitmap;
      
      private var _failBit:Bitmap;
	  
      
      public function FineGhostView(param1:StoreBagController)
      {
         super();
		 _controller = param1;
//         _controller = new StoreBagController(param1.Model);
//         _controller.model.currentPanel = StoreMainView.EQUIPGHOST;
         initView();
         initEvent();
      }
	  
	  private function initView() : void
	  {
		  var _loc3_:int = 0;
		  var _loc1_:* = null;
		  _luckyStoneCell = ComponentFactory.Instance.creatCustomObject("equipGhost.LuckySymbolCell");
		  _luckyStoneCell.label = LanguageMgr.GetTranslation("equipGhost.luck");
		  addChild(_luckyStoneCell);
		  _ghostStoneCell = ComponentFactory.Instance.creatCustomObject("equipGhost.StrengthenStoneCell");
		  _ghostStoneCell.label = LanguageMgr.GetTranslation("equipGhost.stone");
		  addChild(_ghostStoneCell);
		  _equipmentCell = ComponentFactory.Instance.creatCustomObject("equipGhost.EquipmentCell");
		  _equipmentCell.label = LanguageMgr.GetTranslation("store.Strength.StrengthenEquipmentCellText");
		  addChild(_equipmentCell);
		  _ghostBtn = ComponentFactory.Instance.creatComponentByStylename("equipGhost.ghostButton");
		  addChild(_ghostBtn);
		  _ghostHelpBtn = HelpFrameUtils.Instance.simpleHelpButton(this,"ddtstore.HelpButton",null,LanguageMgr.GetTranslation("store.StoreIIGhost.say"),"ddtstore.HelpFrame.GhostText",404,484);
		  PositionUtils.setPos(_ghostHelpBtn,"equipGhost.helpBtnPos");
		  _cBuyluckyBtn = ComponentFactory.Instance.creatComponentByStylename("equipGhost.buyLock");
//		  _cBuyluckyBtn.text = LanguageMgr.GetTranslation("store.Strength.BuyButtonText");
		  _cBuyluckyBtn.setup(EquipType.GHOST_LUCK,2,true);
		  addChild(_cBuyluckyBtn);
		  _buyStoneBtn = ComponentFactory.Instance.creatComponentByStylename("equipGhost.buyStone");
//		  _buyStoneBtn.text = LanguageMgr.GetTranslation("store.Strength.BuyButtonText");
		  _buyStoneBtn.setup(EquipType.GHOST_STONE1,2,true);
		  addChild(_buyStoneBtn);
		  var _loc4_:Point = null;
		  _items = [];
		  _loc3_ = 0;
		  while(_loc3_ < 3)
		  {
			  if(_loc3_ == 0)
			  {
				  _loc1_ = new GhostStoneCell(["117"],_loc3_);
			  }
			  else if(_loc3_ == 1)
			  {
				  _loc1_ = new GhostItemCell(_loc3_);
			  }
			  else if(_loc3_ == 2)
			  {
				  _loc1_ = new GhostStoneCell(["118"],_loc3_);
			  }
			  _loc4_ = ComponentFactory.Instance.creatCustomObject("equipGhost.ghostPos" + _loc3_);
			  _loc1_.x = _loc4_.x;
			  _loc1_.y = _loc4_.y;
			  addChild(_loc1_);
			  _items.push(_loc1_);
			  _loc3_++;
		  }
		  _ratioTxt = ComponentFactory.Instance.creatComponentByStylename("equipGhost.successRatioTxt");
		  _ratioTxt.htmlText = LanguageMgr.GetTranslation("equipGhost.ratioLowTxt");
		  addChild(_ratioTxt);
		  _continuesBtn = ComponentFactory.Instance.creatComponentByStylename("equipGhost.continuousBtn");
		  addChild(_continuesBtn);
//		  _view = _controller.getView();
//		  _view.visible = true;
//		  (_view as StoreBagView).EquipList.setData(_controller.model.canGhostEquipList);
//		  (_view as StoreBagView).PropList.setData(_controller.model.canGhostPropList);
//		  (_view as StoreBagView).enableCellDoubleClick(true,dragDrop);
//		  PositionUtils.setPos(_view,"equipGhost.rightViewPos");
//		  addChild(_view);
//		  _progressBar = UICreatShortcut.creatAndAdd("store.view.exalt.fineGhostProgressBar",this);
//		  _progressBar.progress(0,0);
	  }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.StoreBag.addEventListener(BagEvent.UPDATE,__updateStoreBag);
         PlayerManager.Instance.Self.StoreBag.addEventListener("clearStoreBag",updateData);
         EquipGhostManager.getInstance().addEventListener("equip_ghost_result",onEquipGhostResult);
         EquipGhostManager.getInstance().addEventListener("equip_ghost_ratio",onEquipGhostRatio);
         EquipGhostManager.getInstance().addEventListener("equip_ghost_state",onEquipGhostState);
         EquipGhostManager.getInstance().addEventListener("equip_ghost_data",onEquipGhostData);
         _ghostBtn.addEventListener(MouseEvent.CLICK,equipGhost);
//         addEventListener("startDarg",startShine);
//         addEventListener("stopDarg",stopShine);
      }
      
      private function removeEvent() : void
      {
         var _loc1_:int = 0;
         PlayerManager.Instance.Self.StoreBag.removeEventListener("update",__updateStoreBag);
         PlayerManager.Instance.Self.StoreBag.removeEventListener("clearStoreBag",updateData);
         if(_items)
         {
            _loc1_ = 0;
            while(_loc1_ < _items.length)
            {
               _items[_loc1_].dispose();
               _items[_loc1_] = null;
               _loc1_++;
            }
         }
         _ghostBtn.removeEventListener("click",equipGhost);
         EquipGhostManager.getInstance().removeEventListener("equip_ghost_result",onEquipGhostResult);
         EquipGhostManager.getInstance().removeEventListener("equip_ghost_ratio",onEquipGhostRatio);
         EquipGhostManager.getInstance().removeEventListener("equip_ghost_state",onEquipGhostState);
         EquipGhostManager.getInstance().removeEventListener("equip_ghost_data",onEquipGhostData);
//         removeEventListener("startDarg",startShine);
//         removeEventListener("stopDarg",stopShine);
      }
      
      private function onEquipGhostData(param1:CEvent) : void
      {
//         updateLuckyProgressBar();
      }
      
      private function updateLuckyProgressBar() : void
      {
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc1_:int = 0;
         var _loc5_:* = null;
         var _loc6_:InventoryItemInfo = PlayerManager.Instance.Self.StoreBag.items[1];
         if(_loc6_)
         {
            _loc3_ = PlayerManager.Instance.Self.getGhostDataByCategoryID(_loc6_.CategoryID);
            _loc4_ = !!_loc3_ ? _loc3_.totalGhost : 0;
            _loc1_ = !!_loc3_ ? _loc3_.level + 1 : 1;
			_loc5_ = EquipGhostManager.getInstance().model.getGhostData(_loc6_.CategoryID == 27 ? 7 : _loc6_.CategoryID,_loc1_);
            if(_loc5_)
            {
               _progressBar.progress(int(_loc4_ / 10),int(_loc5_.mustGetTimes / 10));
            }
            else
            {
               _progressBar.progress(int(_loc4_ / 10),0);
            }
         }
         else
         {
            _progressBar.progress(0,0);
         }
      }
      
      private function startShine(param1:StoreDargEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:ItemTemplateInfo = param1.sourceInfo;
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:int = 1;
         if(_loc3_.CategoryID == 11)
         {
            if(_loc3_.Property1 == "117")
            {
               _loc4_ = 0;
            }
            else
            {
               if(_loc3_.Property1 != "118")
               {
                  return;
               }
               _loc4_ = 2;
            }
         }
         if(_items != null && _items.length > _loc4_)
         {
            _loc2_ = _items[_loc4_];
            if(_loc2_)
            {
               _loc2_.startShine();
            }
         }
      }
      
      private function stopShine(param1:StoreDargEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_items && _loc2_ < _items.length)
         {
            _items[_loc2_].stopShine();
            _loc2_++;
         }
      }
      
      
      public function dragDrop(param1:BagCell) : void
      {
         var _loc6_:* = null;
         var _loc5_:* = null;
         var _loc4_:* = false;
         var _loc2_:BagCell = param1;
         if(_loc2_ == null)
         {
            return;
         }
         var _loc7_:InventoryItemInfo;
         if((_loc7_ = _loc2_.info as InventoryItemInfo) == null)
         {
            return;
         }
         for each(_loc6_ in _items)
         {
            if(_loc6_.info == _loc7_)
            {
               _loc6_.info = null;
               _loc2_.locked = false;
               return;
            }
         }
         var _loc3_:int = 1;
         if(_loc7_.CategoryID == 11)
         {
            if(_loc7_.Property1 == "117")
            {
               _loc3_ = 0;
            }
            else
            {
               if(_loc7_.Property1 != "118")
               {
                  return;
               }
               _loc3_ = 2;
            }
         }
         if(_loc3_ == 1)
         {
			 _loc5_ = PlayerManager.Instance.Self.getGhostDataByCategoryID(_loc7_.CategoryID);
            if(_loc5_)
            {
				_loc4_ = _loc5_.level;
               if(_loc4_ >= EquipGhostManager.getInstance().model.topLvDic[_loc7_.CategoryID])
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("equipGhost.upLevel"));
                  return;
               }
            }
            SocketManager.Instance.out.sendMoveGoods(_loc7_.BagType,_loc7_.Place,12,_loc3_,_loc7_.Count,true);
            EquipGhostManager.getInstance().chooseEquip(_loc7_);
         }
         else
         {
            SocketManager.Instance.out.sendMoveGoods(_loc7_.BagType,_loc7_.Place,12,_loc3_,_loc7_.Count,true);
            if(_loc3_ == 0)
            {
               EquipGhostManager.getInstance().chooseLuckyMaterial(_loc7_);
            }
            else
            {
               EquipGhostManager.getInstance().chooseStoneMaterial(_loc7_);
            }
         }
      }
      
	  private function __updateStoreBag(param1:BagEvent) : void
	  {
		  this.refreshData(param1.changedSlots);
	  }
	  
      public function refreshData(param1:Dictionary) : void
      {
         var _loc2_:Boolean = false;
         var _loc4_:int = 0;
         var _loc6_:* = null;
		 var _loc5_:*;
         var _loc3_:Dictionary = param1;
         for(_loc5_ in _loc3_)
         {
            if((_loc4_ = _loc5_) == 1)
            {
               _loc2_ = true;
            }
            if((_loc6_ = _loc3_[_loc5_]).Property1 == "117" || _loc6_.Property1 == "118" || _loc4_ == 1)
            {
               if(_loc4_ < _items.length)
               {
                  _items[_loc4_].info = PlayerManager.Instance.Self.StoreBag.items[_loc4_];
                  if(_loc4_ == 0)
                  {
                     EquipGhostManager.getInstance().chooseLuckyMaterial(_items[_loc4_].info);
                  }
                  else if(_loc4_ == 2)
                  {
                     EquipGhostManager.getInstance().chooseStoneMaterial(_items[_loc4_].info);
                  }
               }
            }
         }
//         if(visible == true && _loc2_)
//         {
//            updateLuckyProgressBar();
//         }
      }
      
      public function updateData() : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            _items[_loc2_].info = PlayerManager.Instance.Self.StoreBag.items[_loc2_];
            _loc2_++;
         }
         _ratioTxt.htmlText = LanguageMgr.GetTranslation("equipGhost.ratioLowTxt");
      }
      
      private function equipGhost(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(checkMaterial())
         {
            EquipGhostManager.getInstance().requestEquipGhost();
         }
      }
      
      private function checkMaterial() : Boolean
      {
         var _loc1_:Boolean = true;
         if(_items[1].info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("equipGhost.material1"));
            _loc1_ = false;
         }
         else if(_items[2].info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("equipGhost.material2"));
            _loc1_ = false;
         }
         return _loc1_;
      }
      
      public function show() : void
      {
         this.visible = true;
      }
	  
	  override public function set visible(param1:Boolean) : void
	  {
		  super.visible = param1;
		  updateData();
//		  if(param1)
//		  {
//			  if(!this._isDispose)
//			  {
//				  this.refreshListData();
//				  PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.propInfoChangeHandler);
//				  PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.bagInfoChangeHandler);
//			  }
//		  }
//		  else
//		  {
//			  this.clearCellInfo();
//			  PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.propInfoChangeHandler);
//			  PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.bagInfoChangeHandler);
//		  }
	  }
	  
      public function dispose() : void
      {
         TweenMax.killTweensOf(_moveSprite);
         SoundManager.instance.resumeMusic();
         SoundManager.instance.stop("063");
         SoundManager.instance.stop("064");
         removeEvent();
         EquipGhostManager.getInstance().clearEquip();
         EquipGhostManager.getInstance().chooseStoneMaterial(null);
         EquipGhostManager.getInstance().chooseLuckyMaterial(null);
         _items = null;
         if(_area)
         {
            _area.dispose();
         }
         _area = null;
         if(_luckyStoneCell)
         {
            ObjectUtils.disposeObject(_luckyStoneCell);
         }
         _luckyStoneCell = null;
         if(_ghostStoneCell)
         {
            ObjectUtils.disposeObject(_ghostStoneCell);
         }
         _ghostStoneCell = null;
         if(_ghostBtn)
         {
            ObjectUtils.disposeObject(_ghostBtn);
         }
         _ghostBtn = null;
         if(_ghostHelpBtn)
         {
            ObjectUtils.disposeObject(_ghostHelpBtn);
         }
         _ghostHelpBtn = null;
         if(_cBuyluckyBtn)
         {
            ObjectUtils.disposeObject(_cBuyluckyBtn);
         }
         _cBuyluckyBtn = null;
         if(_buyStoneBtn)
         {
            ObjectUtils.disposeObject(_buyStoneBtn);
         }
         _buyStoneBtn = null;
         if(_progressBar)
         {
            ObjectUtils.disposeObject(_progressBar);
         }
         _progressBar = null;
         if(_equipmentCell)
         {
            ObjectUtils.disposeObject(_equipmentCell);
         }
         _equipmentCell = null;
//         (_view as StoreBagView).enableCellDoubleClick(false,dragDrop);
         if(_view)
         {
            ObjectUtils.disposeObject(_view);
         }
         _view = null;
         if(_ratioTxt)
         {
            ObjectUtils.disposeObject(_ratioTxt);
         }
         _ratioTxt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function onEquipGhostResult(param1:CEvent) : void
      {
         var _loc2_:Boolean = param1.data;
         if(!_loc2_)
         {
            showResultEffect(false);
         }
         else
         {
            showResultEffect();
         }
      }
      
      private function showResultEffect(param1:Boolean = true) : void
      {
         _ghostBtn.enable = true;
         if(!_moveSprite)
         {
            _moveSprite = new Sprite();
            _moveSprite.mouseEnabled = false;
            _moveSprite.mouseChildren = false;
            addChild(_moveSprite);
         }
         if(param1)
         {
            _successBit = _successBit || ComponentFactory.Instance.creatBitmap("asset.ddtstore.StoreIISuccessBitAsset");
            _successBit.visible = true;
            if(_failBit)
            {
               _failBit.visible = false;
            }
            _moveSprite.addChild(_successBit);
            SoundManager.instance.pauseMusic();
            SoundManager.instance.play("063",false,false);
         }
         else
         {
            _failBit = _failBit || ComponentFactory.Instance.creatBitmap("asset.ddtstore.StoreIIFailBitAsset");
            _failBit.visible = true;
            if(_successBit)
            {
               _successBit.visible = false;
            }
            _moveSprite.addChild(_failBit);
            SoundManager.instance.pauseMusic();
            SoundManager.instance.play("064",false,false);
         }
         TweenMax.killTweensOf(_moveSprite);
//		 TweenMax.from(this._moveSprite,0.4,{
//			 "y":170,
//			 "alpha":0
//		 });
         _moveSprite.y = 170;
         _moveSprite.alpha = 1;
         TweenMax.to(_moveSprite,0.4,{
            "delay":1.4,
            "y":160,
            "alpha":0,
            "onComplete":continueGhost,
            "onCompleteParams":[param1]
         });
      }
      
      private function continueGhost(param1:Boolean) : void
      {
         SoundManager.instance.resumeMusic();
         SoundManager.instance.stop("063");
         SoundManager.instance.stop("064");
         var _loc2_:Boolean = _items && _items.length > 2 && _items[2].info != null;
         if(!param1 && _continuesBtn.selected && _loc2_)
         {
            EquipGhostManager.getInstance().requestEquipGhost();
         }
      }
      
      private function onEquipGhostRatio(param1:CEvent) : void
      {
         var _loc2_:Number = MathUtils.getValueInRange(Number(param1.data),1,99);
         if(_loc2_ < 5)
         {
            _ratioTxt.htmlText = LanguageMgr.GetTranslation("equipGhost.ratioLowTxt");
         }
         else
         {
            _ratioTxt.htmlText = LanguageMgr.GetTranslation("equipGhost.ratioTxt",_loc2_);
         }
      }
      
      private function onEquipGhostState(param1:CEvent) : void
      {
         var _loc2_:Boolean = param1.data as Boolean;
         if(_ghostBtn)
         {
            _ghostBtn.enable = _loc2_;
         }
      }
	  
	  public function hide() : void
	  {
		  this.visible = false;
//		  this._items[0].info = null;
//		  this._items[1].info = null;
//		  this.disposeTimer();
	  }
	  
   }
}
