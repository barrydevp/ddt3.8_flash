package ddt.view.tips
{
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.core.Disposeable;
	import com.pickgliss.ui.image.Image;
	import com.pickgliss.ui.image.MovieImage;
	import com.pickgliss.ui.image.ScaleFrameImage;
	import com.pickgliss.ui.text.FilterFrameText;
	import com.pickgliss.ui.tip.BaseTip;
	import com.pickgliss.ui.tip.ITip;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	import spark.effects.Scale;
	
	import bagAndInfo.info.PlayerInfoViewControl;
	
	import ddt.bagStore.BagStore;
	import ddt.data.EquipType;
	import ddt.data.goods.InventoryItemInfo;
	import ddt.data.goods.ItemTemplateInfo;
	import ddt.data.goods.QualityType;
	import ddt.data.goods.ShopItemInfo;
	import ddt.data.player.PlayerInfo;
	import ddt.manager.ItemManager;
	import ddt.manager.LanguageMgr;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.TimeManager;
	import ddt.utils.PositionUtils;
	import ddt.utils.StaticFormula;
	import ddt.utils.UIUtils;
	import ddt.view.SimpleItem;
	
	import gemstone.GemstoneManager;
	import gemstone.items.GemstonTipItem;
	
	import latentEnergy.LatentEnergyTipItem;
	
	import road7th.utils.DateUtils;
	import road7th.utils.StringHelper;
	
	import store.data.StoreEquipExperience;
	import store.equipGhost.EquipGhostManager;
	import store.equipGhost.data.EquipGhostData;
	import store.equipGhost.data.GhostPropertyData;
	
	public class GoodTip extends BaseTip implements Disposeable, ITip
	{
		
		public static const BOUND:uint = 1;
		
		public static const UNBOUND:uint = 2;
		
		public static const ITEM_NORMAL_COLOR:uint = 16777215;
		
		public static const ITEM_NECKLACE_COLOR:uint = 16750899;
		
		public static const ITEM_BADGE_COLOR:uint = 65280;
		
		public static const ITEM_PROPERTIES_COLOR:uint = 16750899;
		
		public static const ITEM_HOLES_COLOR:uint = 16777215;
		
		public static const ITEM_HOLE_RESERVE_COLOR:uint = 16776960;
		
		public static const ITEM_HOLE_GREY_COLOR:uint = 6710886;
		
		public static const ITEM_FIGHT_PROP_CONSUME_COLOR:uint = 14520832;
		
		public static const ITEM_NEED_LEVEL_COLOR:uint = 13421772;
		
		public static const ITEM_NEED_LEVEL_FAILED_COLOR:uint = 16711680;
		
		public static const ITEM_UPGRADE_TYPE_COLOR:uint = 10092339;
		
		public static const ITEM_NEED_SEX_COLOR:uint = 10092339;
		
		public static const ITEM_NEED_SEX_FAILED_COLOR:uint = 16711680;
		
		public static const ITEM_ETERNAL_COLOR:uint = 16776960;
		
		public static const ITEM_PAST_DUE_COLOR:uint = 16711680;
		
		public static const PET_SPECIAL_FOOD:int = 334100;
		
		public static const GREEN_TEXT_COLOR:uint = 6084882;
		public static const YELLOW_TEXT_COLOR:uint = 14077211;
		
		private var _strengthenLevelImage:MovieImage;
		
		private var _fusionLevelImage:MovieImage;
		
		private var _boundImage:ScaleFrameImage;
		
		private var _nameTxt:FilterFrameText;
		
		private var _qualityItem:SimpleItem;
		
		private var _typeItem:SimpleItem;
		
		private var _mainPropertyItem:SimpleItem;
		
		private var _armAngleItem:SimpleItem;
		
		private var _otherHp:SimpleItem;
		
		private var _necklaceItem:FilterFrameText;
		
		private var _attackTxt:FilterFrameText;
		
		private var _defenseTxt:FilterFrameText;
		
		private var _agilityTxt:FilterFrameText;
		
		private var _luckTxt:FilterFrameText;
		
		private var _needLevelTxt:FilterFrameText;
		
		private var _needSexTxt:FilterFrameText;
		
		private var _holes:Vector.<FilterFrameText>;
		
		private var _upgradeType:FilterFrameText;
		
		private var _descriptionTxt:FilterFrameText;
		
		private var _bindTypeTxt:FilterFrameText;
		
		private var _remainTimeTxt:FilterFrameText;
		
		private var _goldRemainTimeTxt:FilterFrameText;
		
		private var _fightPropConsumeTxt:FilterFrameText;
		
		private var _boxTimeTxt:FilterFrameText;
		
		private var _info:ItemTemplateInfo;
		
		private var _bindImageOriginalPos:Point;
		
		private var _maxWidth:int;
		
		private var _minWidth:int = 196;
		
		private var _isArmed:Boolean;
		
		private var _displayList:Vector.<DisplayObject>;
		
		private var _displayIdx:int;
		
		private var _lines:Vector.<Image>;
		
		private var _lineIdx:int;
		
		private var _isReAdd:Boolean;
		
		private var _remainTimeBg:Bitmap;
		
		private var _gp:FilterFrameText;
		
		private var _maxGP:FilterFrameText;
		
		private var _levelTxt:FilterFrameText;
		
		private var _laterEquipmentView:LaterEquipmentGoodView;
		
		private var _itemStarBack:Sprite;
		private var _itemStarFront:Sprite;
		private var _ghostPropertyData:GhostPropertyData;
		
		public var _noShowHole: Boolean = false;
		
		public function GoodTip()
		{
			this._holes = new Vector.<FilterFrameText>();
			super();
		}
		
		override protected function init() : void
		{
			this._lines = new Vector.<Image>();
			this._displayList = new Vector.<DisplayObject>();
			_tipbackgound = ComponentFactory.Instance.creat("core.GoodsTipBg");
			this._strengthenLevelImage = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameMc");
			this._fusionLevelImage = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTrinketLevelMc");
			this._boundImage = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.BoundImage");
			this._bindImageOriginalPos = new Point(this._boundImage.x,this._boundImage.y);
			this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameTxt");
			this._qualityItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.QualityItem");
			this._typeItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.TypeItem");
			this._mainPropertyItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.MainPropertyItem");
			this._armAngleItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.armAngleItem");
			this._otherHp = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.otherHp");
			this._necklaceItem = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
			this._attackTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
			this._defenseTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
			this._agilityTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
			this._luckTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
			this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.LimitGradeTxt");
			this._gp = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
			this._maxGP = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
			this._holes = new Vector.<FilterFrameText>();
			var _loc1_:int = 0;
			while(_loc1_ < 6)
			{
				this._holes.push(ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt"));
				_loc1_++;
			}
			this._needLevelTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
			this._needSexTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
			this._upgradeType = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
			this._descriptionTxt = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.DescriptionTxt");
			this._bindTypeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
			this._remainTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemDateTxt");
			this._goldRemainTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipGoldItemDateTxt");
			this._remainTimeBg = ComponentFactory.Instance.creatBitmap("asset.core.tip.restTime");
			this._fightPropConsumeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
			this._boxTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
			
			this._itemStarBack = new Sprite();
			this._itemStarFront = new Sprite();
			_loc1_ = 0;
			while(_loc1_ < uint(EquipGhostManager.MAX_STAR_LEVEL / 2)) // 5 stars
			{
				var _back:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtcoreii.ghostGrayStar");
				var _front:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtcoreii.ghostStar");
				_back.x = _loc1_ * _back.width;
				_front.x = _loc1_ * _front.width;
				this._itemStarBack.addChild(_back);
				this._itemStarFront.addChild(_front);
				_loc1_++;
			}
			// add mask for toggle gray and non-gray star
			var _maskItemStar:Sprite = new Sprite();
			_maskItemStar.graphics.beginFill(16777215,1);
			_maskItemStar.graphics.drawRect(0,0,this._itemStarFront.width,this._itemStarFront.height);
			_maskItemStar.graphics.endFill();
			this._itemStarFront.mask = _maskItemStar;
			this._itemStarFront.addChild(_maskItemStar);
			
			this._laterEquipmentView = new LaterEquipmentGoodView();
			this._laterEquipmentView.visible = false;
		}
		
		override public function get tipData() : Object
		{
			return _tipData;
		}
		
		override public function set tipData(param1:Object) : void
		{
			if(param1)
			{
				if(param1 is GoodTipInfo)
				{
					_tipData = param1 as GoodTipInfo;
					this.showTip(_tipData.itemInfo,_tipData.typeIsSecond);
					if(PathManager.suitEnable)
					{
						this.showSuitTip(_tipData.itemInfo);
					}
					else
					{
						this._laterEquipmentView.visible = false;
					}
				}
				else if(param1 is ShopItemInfo)
				{
					_tipData = param1 as ShopItemInfo;
					this.showTip(_tipData.TemplateInfo);
					this._laterEquipmentView.visible = false;
				}
				visible = true;
			}
			else
			{
				_tipData = null;
				visible = false;
				this._laterEquipmentView.visible = false;
			}
		}
		
		private function getGhostPropertyData() : GhostPropertyData
		{
			var _loc4_:GhostPropertyData = null;
			var _loc2_:InventoryItemInfo = _info as InventoryItemInfo;
			if(_loc2_ == null)
			{
				return null;
			}
			var _loc3_:PlayerInfo = PlayerInfoViewControl.currentPlayer || PlayerManager.Instance.Self;
			var _loc5_:Boolean = _loc3_.ID != PlayerManager.Instance.Self.ID;
			var _loc1_:Boolean = _loc2_.BagType == 0 && _loc2_.Place <= 30;
			if(_loc5_) // if it's not (player) self
			{
				_loc4_ = !!_loc1_ ? EquipGhostManager.getInstance().getPorpertyData(_loc2_,_loc3_) : null;
			}
			else
			{
				_loc4_ = _loc2_.fromBag && (_loc1_ || EquipGhostManager.getInstance().isEquipGhosting()) ? EquipGhostManager.getInstance().getPorpertyData(_loc2_,_loc3_) : null;
			}
			return _loc4_;
		}
		
		public function showTip(param1:ItemTemplateInfo, param2:Boolean = false) : void
		{
			this._displayIdx = 0;
			this._displayList = new Vector.<DisplayObject>();
			this._lineIdx = 0;
			this._isReAdd = false;
			this._maxWidth = 0;
			this._info = param1;
			_ghostPropertyData = getGhostPropertyData();
			this.updateView();
		}
		
		public function showSuitTip(param1:ItemTemplateInfo) : void
		{
			param1 = _tipData.itemInfo;
			if(param1 is InventoryItemInfo)
			{
				if(param1.SuitId != 0)
				{
					this._laterEquipmentView.visible = true;
					if(param1["Place"] < 20 && param1["Place"] > -1)
					{
						if(BagStore.instance._isStoreOpen)
						{
							this._laterEquipmentView.x = -250;
						}
						else
						{
							this._laterEquipmentView.x = _width + 5;
						}
					}
					else
					{
						this._laterEquipmentView.x = -250;
					}
					this.laterEquipment(param1);
				}
				else
				{
					this._laterEquipmentView.visible = false;
				}
			}
			else
			{
				this._laterEquipmentView.visible = false;
			}
			this._laterEquipmentView.y = _tipbackgound.height - this._laterEquipmentView.height;
		}
		
		private function updateView() : void
		{
			if(this._info == null)
			{
				return;
			}
			this.clear();
			this._isArmed = false;
			this.createItemName();
			this.createQualityItem();
			this.createCategoryItem();
			this.createMainProperty();
			this.seperateLine();
			this.createNecklaceItem();
			this.createProperties();
			this.seperateLine();
			this.creatGemstone();
			this.seperateLine();
			this.creatLevel();
			this.seperateLine();
			this.createLatentEnergy();
			this.seperateLine();
			this.createHoleItem();
			this.createOperationItem();
			this.seperateLine();
			this.createDescript();
			this.createBindType();
			this.createRemainTime();
			this.createGoldRemainTime();
			this.createFightPropConsume();
			this.createBoxTimeItem();
			this.addChildren();
			this.createStrenthLevel();
			this.createGhostItemStar();
		}
		
		private function laterEquipment(param1:ItemTemplateInfo) : void
		{
			if(!this._laterEquipmentView)
			{
				this._laterEquipmentView = new LaterEquipmentGoodView();
			}
			this._laterEquipmentView.tipData = param1;
		}
		
		private function clear() : void
		{
			var _loc1_:DisplayObject = null;
			while(numChildren > 0)
			{
				_loc1_ = getChildAt(0) as DisplayObject;
				if(_loc1_.parent)
				{
					_loc1_.parent.removeChild(_loc1_);
				}
			}
		}
		
		override protected function addChildren() : void
		{
			var _loc4_:DisplayObject = null;
			var _loc1_:int = this._displayList.length;
			var _loc2_:Point = new Point(4,4);
			var _loc5_:int = this._maxWidth;
			var _loc6_:int = 0;
			while(_loc6_ < _loc1_)
			{
				_loc4_ = this._displayList[_loc6_] as DisplayObject;
				if(this._lines.indexOf(_loc4_) < 0 && _loc4_ != this._descriptionTxt)
				{
					_loc5_ = Math.max(_loc4_.width,_loc5_);
				}
				PositionUtils.setPos(_loc4_,_loc2_);
				addChild(_loc4_);
				_loc2_.y = _loc4_.y + _loc4_.height + 6;
				_loc6_++;
			}
			this._maxWidth = Math.max(this._minWidth,_loc5_);
			if(this._descriptionTxt.width != this._maxWidth)
			{
				this._descriptionTxt.width = this._maxWidth;
				this._descriptionTxt.height = this._descriptionTxt.textHeight + 10;
				this.addChildren();
				return;
			}
			if(!this._isReAdd)
			{
				_loc6_ = 0;
				while(_loc6_ < this._lines.length)
				{
					this._lines[_loc6_].width = this._maxWidth;
					if(_loc6_ + 1 < this._lines.length && this._lines[_loc6_ + 1].parent != null && Math.abs(this._lines[_loc6_ + 1].y - this._lines[_loc6_].y) <= 10)
					{
						this._displayList.splice(this._displayList.indexOf(this._lines[_loc6_ + 1]),1);
						this._lines[_loc6_ + 1].parent.removeChild(this._lines[_loc6_ + 1]);
						this._isReAdd = true;
					}
					_loc6_++;
				}
				if(this._isReAdd)
				{
					this.addChildren();
					return;
				}
			}
			if(_loc1_ > 0)
			{
				_width = _tipbackgound.width = this._maxWidth + 8;
				_height = _tipbackgound.height = _loc4_.y + _loc4_.height + 8;
			}
			if(_tipbackgound)
			{
				addChildAt(_tipbackgound,0);
			}
			if(this._remainTimeBg.parent)
			{
				this._remainTimeBg.x = this._remainTimeTxt.x + 2;
				this._remainTimeBg.y = this._remainTimeTxt.y + 2;
				this._remainTimeBg.parent.addChildAt(this._remainTimeBg,1);
			}
			if(this._remainTimeBg.parent)
			{
				this._goldRemainTimeTxt.x = this._remainTimeTxt.x + 2;
				this._goldRemainTimeTxt.y = this._remainTimeTxt.y + 22;
				this._remainTimeBg.parent.addChildAt(this._goldRemainTimeTxt,1);
			}
			addChild(this._laterEquipmentView);
		}
		
		private function createItemName() : void
		{
			var _loc3_:TextFormat = null;
			this._nameTxt.text = String(this._info.Name);
			var _loc1_:InventoryItemInfo = this._info as InventoryItemInfo;
			if(_loc1_ && _loc1_.StrengthenLevel > 0)
			{
				if(_loc1_.isGold)
				{
					if(_loc1_.StrengthenLevel > PathManager.solveStrengthMax())
					{
						this._nameTxt.text += LanguageMgr.GetTranslation("store.view.exalt.goodTips",_loc1_.StrengthenLevel - 12);
					}
					else
					{
						this._nameTxt.text += LanguageMgr.GetTranslation("wishBead.StrengthenLevel");
					}
				}
				else if(_loc1_.StrengthenLevel <= PathManager.solveStrengthMax())
				{
					this._nameTxt.text += "(+" + (this._info as InventoryItemInfo).StrengthenLevel + ")";
				}
				else if(_loc1_.StrengthenLevel > PathManager.solveStrengthMax())
				{
					this._nameTxt.text += LanguageMgr.GetTranslation("store.view.exalt.goodTips",_loc1_.StrengthenLevel - 12);
				}
			}
			var _loc2_:int = this._nameTxt.text.indexOf("+");
			if(_loc2_ > 0)
			{
				_loc3_ = ComponentFactory.Instance.model.getSet("core.goodTip.ItemNameNumTxtFormat");
				this._nameTxt.setTextFormat(_loc3_,_loc2_,_loc2_ + 1);
			}
			if(PlayerInfoViewControl.currentPlayer)
			{
				if(_loc1_ && _loc1_.Place == 12 && _loc1_.UserID == PlayerInfoViewControl.currentPlayer.ID && PlayerInfoViewControl.currentPlayer.necklaceLevel > 0 && _loc1_.CategoryID == EquipType.NECKLACE)
				{
					this._nameTxt.text += LanguageMgr.GetTranslation("bagAndInfo.bag.NecklacePtetrochemicalView.goodTip",PlayerInfoViewControl.currentPlayer.necklaceLevel);
				}
			}
			this._nameTxt.textColor = QualityType.QUALITY_COLOR[this._info.Quality];
			var _loc4_:* = this._displayIdx++;
			this._displayList[_loc4_] = this._nameTxt;
		}
		
		private function createQualityItem() : void
		{
			var _loc1_:FilterFrameText = this._qualityItem.foreItems[0] as FilterFrameText;
			_loc1_.text = QualityType.QUALITY_STRING[this._info.Quality];
			_loc1_.textColor = QualityType.QUALITY_COLOR[this._info.Quality];
			var _loc2_:* = this._displayIdx++;
			this._displayList[_loc2_] = this._qualityItem;
		}
		
		private function createCategoryItem() : void
		{
			var _loc1_:FilterFrameText = this._typeItem.foreItems[0] as FilterFrameText;
			var _loc2_:Array = EquipType.PARTNAME;
			_loc1_.text = EquipType.PARTNAME[this._info.CategoryID];
			var _loc3_:* = this._displayIdx++;
			this._displayList[_loc3_] = this._typeItem;
		}
		
		private function _setPropertyValueTxt(txtField:FilterFrameText, base: String, additional: String="", color:uint=GREEN_TEXT_COLOR):void {
			var _startIdx:uint = base.length;
			txtField.text = base + additional;
			UIUtils.setTextFieldColor(txtField, color, _startIdx, txtField.text.length);
		}
		
		private function createMainProperty() : void
		{
			var _loc1_:String = "";
			var _loc2_:int = 0;
			var _loc6_:int = 0;
			var _loc7_:int = 0;
			var _loc3_:FilterFrameText = this._mainPropertyItem.foreItems[0] as FilterFrameText;
			var _loc4_:ScaleFrameImage = this._mainPropertyItem.backItem as ScaleFrameImage;
			var _loc5_:InventoryItemInfo = this._info as InventoryItemInfo;
			if(EquipType.isArm(this._info)){
				_loc4_.setFrame(1);
				
				var addHert: uint = 0
				if(_loc5_){
					addHert = _loc5_.getAdditionalPropertyByStrenLvl("hert") + (!!_ghostPropertyData ? _ghostPropertyData.mainProperty : 0);
				}
				if(addHert > 0){
					_loc1_ = "(+" + addHert + ")";
				}
				this._setPropertyValueTxt(_loc3_, this._info.Property7.toString(), _loc1_, GREEN_TEXT_COLOR);
				
				FilterFrameText(this._armAngleItem.foreItems[0]).text = " " + this._info.Property5 + "°~" + this._info.Property6 + "°";
				_loc6_ = this._displayIdx++;
				this._displayList[_loc6_] = this._mainPropertyItem;
				_loc7_ = this._displayIdx++;
				this._displayList[_loc7_] = this._armAngleItem;
			}
			else if(EquipType.isHead(this._info) || EquipType.isCloth(this._info))
			{
				_loc4_.setFrame(2);
				
				var addDef: uint = 0
				if(_loc5_){
					addDef = _loc5_.getAdditionalPropertyByStrenLvl("armor") + (!!_ghostPropertyData ? _ghostPropertyData.mainProperty : 0);
				}
				if(addDef > 0){
					_loc1_ = "(+" + addDef + ")";
				}
				this._setPropertyValueTxt(_loc3_, this._info.Property7.toString(), _loc1_, GREEN_TEXT_COLOR);
				
				_loc6_ = this._displayIdx++;
				this._displayList[_loc6_] = this._mainPropertyItem;
				if(_loc5_ && _loc5_.isGold)
				{
					FilterFrameText(this._otherHp.foreItems[0]).text = _loc5_.Boold.toString();
					_loc7_ = this._displayIdx++;
					this._displayList[_loc7_] = this._otherHp;
				}
			} else if(StaticFormula.isDeputyWeapon(this._info)){
				var addVal: uint = 0
				if(this._info.Property3 == "32"){
					if(_loc5_){
						addVal = _loc5_.getAdditionalPropertyByStrenLvl("recoverhp");
					}
					_loc4_.setFrame(3);
				} else {
					if(_loc5_){
						addVal = _loc5_.getAdditionalPropertyByStrenLvl("armor");
					}
					_loc4_.setFrame(4);
				}
				if(addVal > 0){
					_loc1_ = "(+" + addVal + ")";
				}
				this._setPropertyValueTxt(_loc3_, this._info.Property7.toString(), _loc1_, GREEN_TEXT_COLOR);
				_loc6_ = this._displayIdx++;
				this._displayList[_loc6_] = this._mainPropertyItem;
			}
		}
		
		private function createNecklaceItem() : void
		{
			var _loc3_:* = undefined;
			var _loc1_:InventoryItemInfo = null;
			var _loc2_:int = 0;
			if(this._info.CategoryID == 14)
			{
				this._necklaceItem.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.life") + ":" + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.advance") + this._info.Property1 + "%";
				_loc1_ = this._info as InventoryItemInfo;
				if(_loc1_ && _loc1_.Place == 12 && PlayerInfoViewControl.currentPlayer && _loc1_.UserID == PlayerInfoViewControl.currentPlayer.ID && PlayerInfoViewControl.currentPlayer.necklaceLevel > 0)
				{
					_loc2_ = StoreEquipExperience.getNecklaceStrengthPlus(PlayerInfoViewControl.currentPlayer.necklaceLevel);
					this._necklaceItem.text += LanguageMgr.GetTranslation("bagAndInfo.bag.NecklacePtetrochemicalView.goodTipII",_loc2_);
				}
				this._necklaceItem.textColor = ITEM_NECKLACE_COLOR;
				_loc3_ = this._displayIdx++;
				this._displayList[_loc3_] = this._necklaceItem;
			}
			else if(this._info.CategoryID == EquipType.HEALSTONE)
			{
				this._necklaceItem.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.life") + ":" + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.reply") + this._info.Property2;
				this._necklaceItem.textColor = ITEM_NECKLACE_COLOR;
				_loc3_ = this._displayIdx++;
				this._displayList[_loc3_] = this._necklaceItem;
			}
		}
		
		private function createProperties() : void
		{
			var _loc5_:InventoryItemInfo = null;
			var _loc6_:int = 0;
			var _loc1_:String = "";
			var _loc2_:String = "";
			var _loc3_:String = "";
			var _loc4_:String = "";
			if(this._info is InventoryItemInfo)
			{
				_loc5_ = this._info as InventoryItemInfo;
				if(_loc5_.AttackCompose > 0)
				{
					_loc1_ = "(+" + String(_loc5_.AttackCompose) + ")";
				}
				if(_loc5_.DefendCompose > 0)
				{
					_loc2_ = "(+" + String(_loc5_.DefendCompose) + ")";
				}
				if(_loc5_.AgilityCompose > 0)
				{
					_loc3_ = "(+" + String(_loc5_.AgilityCompose) + ")";
				}
				if(_loc5_.LuckCompose > 0)
				{
					_loc4_ = "(+" + String(_loc5_.LuckCompose) + ")";
				}
			}
			if(this._info.Attack != 0)
			{
				var base1:String = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.fire") + ":" + String(this._info.Attack) + _loc1_;
				var additional1:String = "";
				if(_ghostPropertyData && _ghostPropertyData.attack > 0)
				{
					additional1 = "(+" + _ghostPropertyData.attack + ")";
				}
				this._attackTxt.text = base1 + additional1;
				UIUtils.setTextFieldColor(this._attackTxt, ITEM_PROPERTIES_COLOR, 0, base1.length);
				UIUtils.setTextFieldColor(this._attackTxt, YELLOW_TEXT_COLOR, base1.length, this._attackTxt.text.length);
				_loc6_ = this._displayIdx++;
				this._displayList[_loc6_] = this._attackTxt;
			}
			if(this._info.Defence != 0)
			{
				var base2:String = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.recovery") + ":" + String(this._info.Defence) + _loc2_;
				var additional2:String = "";
				if(_ghostPropertyData && _ghostPropertyData.defend > 0)
				{
					additional2 = "(+" + _ghostPropertyData.defend + ")";
				}
				
				this._defenseTxt.text = base2 + additional2;
				UIUtils.setTextFieldColor(this._defenseTxt, ITEM_PROPERTIES_COLOR, 0, base2.length);
				UIUtils.setTextFieldColor(this._defenseTxt, YELLOW_TEXT_COLOR, base2.length, this._defenseTxt.text.length);
				_loc6_ = this._displayIdx++;
				this._displayList[_loc6_] = this._defenseTxt;
			}
			if(this._info.Agility != 0)
			{
				var base3:String = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.agility") + ":" + String(this._info.Agility) + _loc3_;
				var additional3:String = "";
				if(_ghostPropertyData && _ghostPropertyData.agility > 0)
				{
					additional3 = "(+" + _ghostPropertyData.agility + ")";
				}
				
				this._agilityTxt.text = base3 + additional3;
				UIUtils.setTextFieldColor(this._agilityTxt, ITEM_PROPERTIES_COLOR, 0, base3.length);
				UIUtils.setTextFieldColor(this._agilityTxt, YELLOW_TEXT_COLOR, base3.length, this._agilityTxt.text.length);
				_loc6_ = this._displayIdx++;
				this._displayList[_loc6_] = this._agilityTxt;
			}
			if(this._info.Luck != 0)
			{
				var base4:String = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.lucky") + ":" + String(this._info.Luck) + _loc4_;
				var additional4:String = "";
				if(_ghostPropertyData && _ghostPropertyData.lucky > 0)
				{
					additional4 = "(+" + _ghostPropertyData.lucky + ")";
				}
				
				this._luckTxt.text = base4 + additional4;
				UIUtils.setTextFieldColor(this._luckTxt, ITEM_PROPERTIES_COLOR, 0, base4.length);
				UIUtils.setTextFieldColor(this._luckTxt, YELLOW_TEXT_COLOR, base4.length, this._luckTxt.text.length);
				_loc6_ = this._displayIdx++;
				this._displayList[_loc6_] = this._luckTxt;
			}
			if(this._info.TemplateID == PET_SPECIAL_FOOD)
			{
				this._gp.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.gp") + ":" + InventoryItemInfo(this._info).DefendCompose;
				this._gp.textColor = ITEM_PROPERTIES_COLOR;
				_loc6_ = this._displayIdx++;
				this._displayList[_loc6_] = this._gp;
				this._maxGP.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.maxGP") + ":" + InventoryItemInfo(this._info).AgilityCompose;
				this._maxGP.textColor = ITEM_PROPERTIES_COLOR;
				var _loc7_:* = this._displayIdx++;
				this._displayList[_loc7_] = this._maxGP;
			}
			
		}
		
		private function createHoleItem() : void
		{
			var _loc1_:Array = null;
			var _loc2_:Array = null;
			var _loc3_:InventoryItemInfo = null;
			var _loc4_:int = 0;
			var _loc5_:String = null;
			var _loc6_:Array = null;
			var _loc7_:FilterFrameText = null;
			var _loc8_:int = 0;
			if(!this._noShowHole && !StringHelper.isNullOrEmpty(this._info.Hole))
			{
				_loc1_ = [];
				_loc2_ = this._info.Hole.split("|");
				_loc3_ = this._info as InventoryItemInfo;
				if(_loc2_.length > 0 && String(_loc2_[0]) != "" && _loc3_ != null)
				{
					_loc4_ = 0;
					while(_loc4_ < _loc2_.length)
					{
						_loc5_ = String(_loc2_[_loc4_]);
						_loc6_ = _loc5_.split(",");
						if(_loc4_ < 4)
						{
							if(int(_loc6_[0]) > 0 && int(_loc6_[0]) - _loc3_.StrengthenLevel <= 3 || this.getHole(_loc3_,_loc4_ + 1) >= 0)
							{
								_loc8_ = int(_loc6_[0]);
								_loc7_ = this.createSingleHole(_loc3_,_loc4_,_loc8_,_loc6_[1]);
								var _loc9_:* = this._displayIdx++;
								this._displayList[_loc9_] = _loc7_;
							}
						}
						else if(_loc3_["Hole" + (_loc4_ + 1) + "Level"] >= 1 || _loc3_["Hole" + (_loc4_ + 1)] > 0)
						{
							_loc7_ = this.createSingleHole(_loc3_,_loc4_,int.MAX_VALUE,_loc6_[1]);
							_loc9_ = this._displayIdx++;
							this._displayList[_loc9_] = _loc7_;
						}
						_loc4_++;
					}
				}
			}
		}
		
		private function creatLevel() : void
		{
			if(this._info.CategoryID == 50 || this._info.CategoryID == 51 || this._info.CategoryID == 52)
			{
				this._levelTxt.text = LanguageMgr.GetTranslation("ddt.petEquipLevel",this._info.Property2);
				var _loc1_:* = this._displayIdx++;
				this._displayList[_loc1_] = this._levelTxt;
			}
		}
		
		private function createSingleHole(param1:InventoryItemInfo, param2:int, param3:int, param4:int) : FilterFrameText
		{
			var _loc6_:ItemTemplateInfo = null;
			var _loc8_:int = 0;
			var _loc5_:FilterFrameText = this._holes[param2];
			var _loc7_:int = this.getHole(param1,param2 + 1);
			if(param1.StrengthenLevel >= param3)
			{
				if(_loc7_ <= 0)
				{
					_loc5_.text = this.getHoleType(param4) + ":" + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holeenable");
					_loc5_.textColor = ITEM_HOLES_COLOR;
				}
				else
				{
					_loc6_ = ItemManager.Instance.getTemplateById(_loc7_);
					if(_loc6_)
					{
						_loc5_.text = _loc6_.Data;
						_loc5_.textColor = ITEM_HOLE_RESERVE_COLOR;
					}
				}
			}
			else if(param2 >= 4)
			{
				_loc8_ = param1["Hole" + (param2 + 1) + "Level"];
				if(_loc7_ > 0)
				{
					_loc6_ = ItemManager.Instance.getTemplateById(_loc7_);
					_loc5_.text = _loc6_.Data + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holeLv",param1["Hole" + (param2 + 1) + "Level"]);
					if(Math.floor(_loc6_.Level + 1 >> 1) <= _loc8_)
					{
						_loc5_.textColor = ITEM_HOLE_RESERVE_COLOR;
					}
					else
					{
						_loc5_.textColor = ITEM_HOLE_GREY_COLOR;
					}
				}
				else
				{
					_loc5_.text = this.getHoleType(param4) + StringHelper.format(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holeLv",param1["Hole" + (param2 + 1) + "Level"]));
					_loc5_.textColor = ITEM_HOLES_COLOR;
				}
			}
			else if(_loc7_ <= 0)
			{
				_loc5_.text = this.getHoleType(param4) + StringHelper.format(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holerequire"),param3.toString());
				_loc5_.textColor = ITEM_HOLE_GREY_COLOR;
			}
			else
			{
				_loc6_ = ItemManager.Instance.getTemplateById(_loc7_);
				if(_loc6_)
				{
					_loc5_.text = _loc6_.Data + StringHelper.format(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holerequire"),param3.toString());
					_loc5_.textColor = ITEM_HOLE_GREY_COLOR;
				}
			}
			return _loc5_;
		}
		
		public function getHole(param1:InventoryItemInfo, param2:int) : int
		{
			return int(param1["Hole" + param2.toString()]);
		}
		
		private function getHoleType(param1:int) : String
		{
			switch(param1)
			{
				case 1:
					return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.trianglehole");
				case 2:
					return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.recthole");
				case 3:
					return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.ciclehole");
				default:
					return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.unknowhole");
			}
		}
		
		private function createOperationItem() : void
		{
			var _loc2_:uint = 0;
			if(this._info.NeedLevel > 1)
			{
				if(PlayerManager.Instance.Self.Grade >= this._info.NeedLevel)
				{
					_loc2_ = ITEM_NEED_LEVEL_COLOR;
				}
				else
				{
					_loc2_ = ITEM_NEED_LEVEL_FAILED_COLOR;
				}
				this._needLevelTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.need") + ":" + String(this._info.NeedLevel);
				this._needLevelTxt.textColor = _loc2_;
				var _loc3_:* = this._displayIdx++;
				this._displayList[_loc3_] = this._needLevelTxt;
			}
			if(this._info.NeedSex == 1)
			{
				this._needSexTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.man");
				this._needSexTxt.textColor = !!PlayerManager.Instance.Self.Sex ? uint(uint(ITEM_NEED_SEX_COLOR)) : uint(uint(ITEM_NEED_SEX_FAILED_COLOR));
				_loc3_ = this._displayIdx++;
				this._displayList[_loc3_] = this._needSexTxt;
			}
			else if(this._info.NeedSex == 2)
			{
				this._needSexTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.woman");
				this._needSexTxt.textColor = !!PlayerManager.Instance.Self.Sex ? uint(uint(ITEM_NEED_SEX_FAILED_COLOR)) : uint(uint(ITEM_NEED_SEX_COLOR));
				_loc3_ = this._displayIdx++;
				this._displayList[_loc3_] = this._needSexTxt;
			}
			var _loc1_:String = "";
			if(this._info.CanStrengthen && this._info.CanCompose)
			{
				_loc1_ = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.may");
				if(EquipType.isRongLing(this._info))
				{
					_loc1_ += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.melting");
				}
				this._upgradeType.text = _loc1_;
				this._upgradeType.textColor = ITEM_UPGRADE_TYPE_COLOR;
				_loc3_ = this._displayIdx++;
				this._displayList[_loc3_] = this._upgradeType;
			}
			else if(this._info.CanCompose)
			{
				_loc1_ = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.compose");
				if(EquipType.isRongLing(this._info))
				{
					_loc1_ += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.melting");
				}
				this._upgradeType.text = _loc1_;
				this._upgradeType.textColor = ITEM_UPGRADE_TYPE_COLOR;
				_loc3_ = this._displayIdx++;
				this._displayList[_loc3_] = this._upgradeType;
			}
			else if(this._info.CanStrengthen)
			{
				_loc1_ = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.strong");
				if(EquipType.isRongLing(this._info))
				{
					_loc1_ += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.melting");
				}
				this._upgradeType.text = _loc1_;
				this._upgradeType.textColor = ITEM_UPGRADE_TYPE_COLOR;
				_loc3_ = this._displayIdx++;
				this._displayList[_loc3_] = this._upgradeType;
			}
			else if(EquipType.isRongLing(this._info))
			{
				_loc1_ += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.canmelting");
				this._upgradeType.text = _loc1_;
				this._upgradeType.textColor = ITEM_UPGRADE_TYPE_COLOR;
				_loc3_ = this._displayIdx++;
				this._displayList[_loc3_] = this._upgradeType;
			}
		}
		
		private function createDescript() : void
		{
			if(this._info.Description == "")
			{
				return;
			}
			this._descriptionTxt.text = this._info.Description;
			this._descriptionTxt.height = this._descriptionTxt.textHeight + 10;
			var _loc1_:* = this._displayIdx++;
			this._displayList[_loc1_] = this._descriptionTxt;
		}
		
		private function ShowBound(param1:InventoryItemInfo) : Boolean
		{
			return param1.CategoryID != EquipType.SEED && param1.CategoryID != EquipType.MANURE && param1.CategoryID != EquipType.VEGETABLE;
		}
		
		private function createBindType() : void
		{
			var _loc1_:InventoryItemInfo = this._info as InventoryItemInfo;
			if(_loc1_ && this.ShowBound(_loc1_))
			{
				if(_loc1_.IsVisleBound == true)
				{
					this._boundImage.setFrame(!!_loc1_.IsBinds ? int(int(BOUND)) : int(int(UNBOUND)));
					// set boundImage position next to typeItem text and margin with offset = 30
					var _typeItemTxt:FilterFrameText = this._typeItem.foreItems[0] as FilterFrameText;
					this._bindImageOriginalPos.x = _typeItemTxt.x + _typeItemTxt.width + 30;
					PositionUtils.setPos(this._boundImage,this._bindImageOriginalPos);
					this._minWidth = this._boundImage.x + this._boundImage.width > this._minWidth ? (this._boundImage.x + this._boundImage.width) : this._minWidth;
					addChild(this._boundImage);
				}
				if(!_loc1_.IsBinds)
				{
					if(_loc1_.BindType == 3)
					{
						this._bindTypeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.bangding");
						this._bindTypeTxt.textColor = ITEM_NORMAL_COLOR;
						var _loc2_:* = this._displayIdx++;
						this._displayList[_loc2_] = this._bindTypeTxt;
					}
					else if(this._info.BindType == 2)
					{
						this._bindTypeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.zhuangbei");
						this._bindTypeTxt.textColor = ITEM_NORMAL_COLOR;
						_loc2_ = this._displayIdx++;
						this._displayList[_loc2_] = this._bindTypeTxt;
					}
					else if(this._info.BindType == 4)
					{
						if(this._boundImage.parent)
						{
							this._boundImage.parent.removeChild(this._boundImage);
						}
					}
				}
			}
			else if(this._boundImage.parent)
			{
				this._boundImage.parent.removeChild(this._boundImage);
			}
			
			if(this._maxWidth < this._boundImage.x + this._boundImage.width)
			{
				this._maxWidth = this._boundImage.x + this._boundImage.width + 50;
				_tipbackgound.width = this._maxWidth;
			}
		}
		
		private function createRemainTime() : void
		{
			var _loc1_:Number = NaN;
			var _loc2_:InventoryItemInfo = null;
			var _loc3_:Number = NaN;
			var _loc4_:Number = NaN;
			var _loc5_:String = null;
			var _loc6_:Number = NaN;
			var _string1:String = null;
			var _string2:String = null;
			var _int1:uint = 0;
			if(this._remainTimeBg.parent)
			{
				this._remainTimeBg.parent.removeChild(this._remainTimeBg);
			}
			if(this._info is InventoryItemInfo)
			{
				_loc2_ = this._info as InventoryItemInfo;
				_loc3_ = _loc2_.getRemainDate();
				_loc4_ = _loc2_.getColorValidDate();
				_loc5_ = _loc2_.CategoryID == EquipType.ARM ? LanguageMgr.GetTranslation("bag.changeColor.tips.armName") : "";
				if(_loc4_ > 0 && _loc4_ != int.MAX_VALUE)
				{
					if(_loc4_ >= 1)
					{
						this._remainTimeTxt.text = (!!_loc2_.IsUsed ? LanguageMgr.GetTranslation("bag.changeColor.tips.name") + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + Math.ceil(_loc4_) + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
						this._remainTimeTxt.textColor = ITEM_NORMAL_COLOR;
						var _loc7_:* = this._displayIdx++;
						this._displayList[_loc7_] = this._remainTimeTxt;
					}
					else
					{
						_loc6_ = Math.floor(_loc4_ * 24);
						if(_loc6_ < 1)
						{
							_loc6_ = 1;
						}
						this._remainTimeTxt.text = (!!_loc2_.IsUsed ? LanguageMgr.GetTranslation("bag.changeColor.tips.name") + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + _loc6_ + LanguageMgr.GetTranslation("hours");
						this._remainTimeTxt.textColor = ITEM_NORMAL_COLOR;
						_loc7_ = this._displayIdx++;
						this._displayList[_loc7_] = this._remainTimeTxt;
					}
				}
				if(_loc3_ == int.MAX_VALUE)
				{
					this._remainTimeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.use");
					this._remainTimeTxt.textColor = ITEM_ETERNAL_COLOR;
					_loc7_ = this._displayIdx++;
					this._displayList[_loc7_] = this._remainTimeTxt;
				}
				else if(_loc3_ > 0)
				{
					if(_loc3_ > 1)
					{
						_loc1_ = Math.ceil(_loc3_);
						this._remainTimeTxt.text = (!!_loc2_.IsUsed ? _loc5_ + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + "  " + _loc1_ + "  " + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
						this._remainTimeTxt.textColor = ITEM_NORMAL_COLOR;
						_loc7_ = this._displayIdx++;
						this._displayList[_loc7_] = this._remainTimeTxt;
					}
					else
					{
						_loc1_ = Math.floor(_loc3_ * 24);
						_loc1_ = _loc1_ < 1 ? Number(Number(1)) : Number(Number(_loc1_));
						this._remainTimeTxt.text = (!!_loc2_.IsUsed ? _loc5_ + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + "  " + _loc1_ + "  " + LanguageMgr.GetTranslation("hours");
						this._remainTimeTxt.textColor = ITEM_NORMAL_COLOR;
						_loc7_ = this._displayIdx++;
						this._displayList[_loc7_] = this._remainTimeTxt;
					}
					addChild(this._remainTimeBg);
				}
				else if(!isNaN(_loc3_))
				{
					this._remainTimeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.over");
					this._remainTimeTxt.textColor = ITEM_PAST_DUE_COLOR;
					_loc7_ = this._displayIdx++;
					this._displayList[_loc7_] = this._remainTimeTxt;
				}
				if(_loc2_.isHasLatentEnergy)
				{
					_string1 = TimeManager.Instance.getMaxRemainDateStr(_loc2_.latentEnergyEndTime,2);
					_string2 = this._remainTimeTxt.text;
					_string2 = _string2 + LanguageMgr.GetTranslation("ddt.latentEnergy.tipRemainDateTxt",_string1);
					_int1 = this._remainTimeTxt.textColor;
					this._remainTimeTxt.text = _string2;
					this._remainTimeTxt.textColor = _int1;
				}
			}
		}
		
		private function createGoldRemainTime() : void
		{
			var _loc1_:Number = NaN;
			var _loc2_:InventoryItemInfo = null;
			var _loc3_:Number = NaN;
			var _loc4_:Number = NaN;
			var _loc5_:String = null;
			if(this._remainTimeBg.parent)
			{
				this._remainTimeBg.parent.removeChild(this._remainTimeBg);
			}
			if(this._info is InventoryItemInfo)
			{
				_loc2_ = this._info as InventoryItemInfo;
				_loc3_ = _loc2_.getGoldRemainDate();
				_loc4_ = _loc2_.goldValidDate;
				_loc5_ = _loc2_.goldBeginTime;
				if((this._info as InventoryItemInfo).isGold)
				{
					if(_loc3_ >= 1)
					{
						_loc1_ = Math.ceil(_loc3_);
						this._goldRemainTimeTxt.text = LanguageMgr.GetTranslation("wishBead.GoodsTipPanel.txt1") + _loc1_ + LanguageMgr.GetTranslation("wishBead.GoodsTipPanel.txt2");
					}
					else
					{
						_loc1_ = Math.floor(_loc3_ * 24);
						_loc1_ = _loc1_ < 1 ? Number(Number(1)) : Number(Number(_loc1_));
						this._goldRemainTimeTxt.text = LanguageMgr.GetTranslation("wishBead.GoodsTipPanel.txt1") + _loc1_ + LanguageMgr.GetTranslation("wishBead.GoodsTipPanel.txt3");
					}
					addChild(this._remainTimeBg);
					this._goldRemainTimeTxt.textColor = ITEM_NORMAL_COLOR;
					var _loc6_:* = this._displayIdx++;
					this._displayList[_loc6_] = this._goldRemainTimeTxt;
				}
			}
		}
		
		private function createFightPropConsume() : void
		{
			if(this._info.CategoryID == EquipType.FRIGHTPROP)
			{
				this._fightPropConsumeTxt.text = " " + LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip.consume") + this._info.Property4;
				this._fightPropConsumeTxt.textColor = ITEM_FIGHT_PROP_CONSUME_COLOR;
				var _loc1_:* = this._displayIdx++;
				this._displayList[_loc1_] = this._fightPropConsumeTxt;
			}
		}
		
		private function createBoxTimeItem() : void
		{
			var _loc1_:Date = null;
			var _loc2_:int = 0;
			var _loc3_:int = 0;
			var _loc4_:int = 0;
			if(EquipType.isTimeBox(this._info))
			{
				_loc1_ = DateUtils.getDateByStr((this._info as InventoryItemInfo).BeginDate);
				_loc2_ = int(this._info.Property3) * 60 - (TimeManager.Instance.Now().getTime() - _loc1_.getTime()) / 1000;
				if(_loc2_ > 0)
				{
					_loc3_ = _loc2_ / 3600;
					_loc4_ = _loc2_ % 3600 / 60;
					_loc4_ = _loc4_ > 0 ? int(int(_loc4_)) : int(int(1));
					this._boxTimeTxt.text = LanguageMgr.GetTranslation("ddt.userGuild.boxTip",_loc3_,_loc4_);
					this._boxTimeTxt.textColor = ITEM_NORMAL_COLOR;
					var _loc5_:* = this._displayIdx++;
					this._displayList[_loc5_] = this._boxTimeTxt;
				}
			}
		}
		
		private function createStrenthLevel() : void
		{
			var _loc1_:InventoryItemInfo = this._info as InventoryItemInfo;
			if(_loc1_ && _loc1_.StrengthenLevel > 0)
			{
				if(_loc1_.isGold)
				{
					this._strengthenLevelImage.setFrame(16);
				}
				else
				{
					this._strengthenLevelImage.setFrame(_loc1_.StrengthenLevel);
				}
				addChild(this._strengthenLevelImage);
				if(this._boundImage.parent)
				{
					this._boundImage.x = this._strengthenLevelImage.x + this._strengthenLevelImage.displayWidth / 2 - this._boundImage.width / 2;
					this._boundImage.y = this._lines[0].y + 4;
				}
				this._maxWidth = Math.max(this._strengthenLevelImage.x + this._strengthenLevelImage.displayWidth,this._maxWidth);
				_width = _tipbackgound.width = this._maxWidth + 8;
			}
		}
		
		private function createGhostItemStar(): void {
			var ivenInfo:InventoryItemInfo = this._info as InventoryItemInfo;
			var curPlayer:PlayerInfo = PlayerInfoViewControl.currentPlayer || PlayerManager.Instance.Self;
			
			if(_ghostPropertyData && curPlayer){
				var _curLevel:uint = curPlayer.getGhostDataByCategoryID(_info.CategoryID).level;
				
				// get the y-axis base on the first this._lines (above the first line)
				var _y:int = this._lines[0].y - 2 - this._itemStarBack.height;
				this._itemStarBack.y = _y;
				this._itemStarFront.y = _y;
				// get the x-axis base on the _mainPropertyItem (next to mainPropertyItem with padding = width + 30)
				var _paddingX:int = Math.max(this._mainPropertyItem.width, 120) + 30;
				var _x:int = this._mainPropertyItem.x + _paddingX;
				this._itemStarBack.x = _x;
				this._itemStarFront.x = _x;
				
				// mask for hide front of star line (yellow star)
				this._itemStarFront.mask.width = _curLevel / EquipGhostManager.MAX_STAR_LEVEL * this._itemStarFront.width;
				
				this._itemStarBack.visible = true;
				this._itemStarFront.visible = true;
				addChild(this._itemStarBack);
				addChild(this._itemStarFront);
				
				// TODO: adjust this._maxWitdh and this._minWitdh
			}
		}
		
		private function seperateLine() : void
		{
			var _loc1_:Image = null;
			++this._lineIdx;
			if(this._lines.length < this._lineIdx)
			{
				_loc1_ = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
				this._lines.push(_loc1_);
			}
			var _loc2_:* = this._displayIdx++;
			this._displayList[_loc2_] = this._lines[this._lineIdx - 1];
		}
		
		private function createLatentEnergy() : void
		{
			var _loc1_:InventoryItemInfo = null;
			var _loc2_:Array = null;
			var _loc3_:int = 0;
			var _loc4_:LatentEnergyTipItem = null;
			var _loc5_:LatentEnergyTipItem = null;
			if(this._info is InventoryItemInfo)
			{
				_loc1_ = this._info as InventoryItemInfo;
				if(_loc1_.isHasLatentEnergy)
				{
					_loc2_ = _loc1_.latentEnergyCurList;
					_loc3_ = 0;
					while(_loc3_ < 4)
					{
						_loc4_ = new LatentEnergyTipItem();
						_loc4_.setView(_loc3_, _loc2_[_loc3_]);
						this._displayList[this._displayIdx++] = _loc4_;
						_loc3_++;
					}
				}
			}
		}
		
		private function creatGemstone() : void
		{
			var _loc1_:InventoryItemInfo = null;
			var _loc2_:int = 0;
			var _loc3_:FilterFrameText = null;
			var _loc4_:GemstonTipItem = null;
			var _loc5_:int = 0;
			var _loc6_:String = null;
			var _loc7_:int = 0;
			var _loc8_:Object = null;
			var _loc9_:String = null;
			var _loc10_:String = null;
			if(this._info is InventoryItemInfo)
			{
				_loc1_ = this._info as InventoryItemInfo;
				if(_loc1_.gemstoneList)
				{
					if(_loc1_.gemstoneList.length == 0)
					{
						return;
					}
					_loc9_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.GoldenAddAttack");
					_loc10_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.GoldenReduceDamage");
					_loc2_ = 0;
					while(_loc2_ < 3)
					{
						if(_loc1_.gemstoneList[_loc2_].level > 0)
						{
							_loc3_ = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameTxtString");
							_loc4_ = new GemstonTipItem();
							this._displayList[this._displayIdx++] = _loc4_;
							_loc5_ = _loc1_.gemstoneList[_loc2_].level;
							if(_loc1_.gemstoneList[_loc2_].fightSpiritId == 100001)
							{
								if(_loc1_.gemstoneList[_loc2_].level == 6)
								{
									_loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstoneAtc",GemstoneManager.Instance.redInfoList[_loc5_].attack + _loc9_);
								}
								else
								{
									_loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.redGemstoneAtc",_loc5_,GemstoneManager.Instance.redInfoList[_loc5_].attack);
								}
								_loc7_ = GemstoneManager.Instance.redInfoList[_loc5_].attack;
							}
							else if(_loc1_.gemstoneList[_loc2_].fightSpiritId == 100002)
							{
								if(_loc1_.gemstoneList[_loc2_].level == 6)
								{
									_loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstoneDef",GemstoneManager.Instance.bluInfoList[_loc5_].defence + _loc10_);
								}
								else
								{
									_loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.bluGemstoneDef",_loc5_,GemstoneManager.Instance.bluInfoList[_loc5_].defence);
								}
								_loc7_ = GemstoneManager.Instance.bluInfoList[_loc5_].defence;
							}
							else if(_loc1_.gemstoneList[_loc2_].fightSpiritId == 100003)
							{
								if(_loc1_.gemstoneList[_loc2_].level == 6)
								{
									_loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstoneAgi",GemstoneManager.Instance.greInfoList[_loc5_].agility + _loc9_);
								}
								else
								{
									_loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.gesGemstoneAgi",_loc5_,GemstoneManager.Instance.greInfoList[_loc5_].agility);
								}
								_loc7_ = GemstoneManager.Instance.greInfoList[_loc5_].agility;
							}
							else if(_loc1_.gemstoneList[_loc2_].fightSpiritId == 100004)
							{
								if(_loc1_.gemstoneList[_loc2_].level == 6)
								{
									_loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstoneLuk",GemstoneManager.Instance.yelInfoList[_loc5_].luck + _loc10_);
								}
								else
								{
									_loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.yelGemstoneLuk",_loc5_,GemstoneManager.Instance.yelInfoList[_loc5_].luck);
								}
								_loc7_ = GemstoneManager.Instance.yelInfoList[_loc5_].luck;
							}
							else if(_loc1_.gemstoneList[_loc2_].fightSpiritId == 100005)
							{
								if(_loc1_.gemstoneList[_loc2_].level == 6)
								{
									_loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.goldenGemstoneHp",GemstoneManager.Instance.purpleInfoList[_loc5_].blood + _loc10_);
								}
								else
								{
									_loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.purpleGemstoneLuk",_loc5_,GemstoneManager.Instance.purpleInfoList[_loc5_].blood);
								}
								_loc7_ = GemstoneManager.Instance.purpleInfoList[_loc5_].blood;
							}
							_loc8_ = new Object();
							_loc8_.id = _loc1_.gemstoneList[_loc2_].fightSpiritId;
							_loc8_.str = _loc6_;
							_loc4_.setInfo(_loc8_);
						}
						_loc2_++;
					}
				}
			}
		}
		
		private function createGhostSkillitem() : void
		{
			var _loc3_:* = null;
			if(!_ghostPropertyData)
			{
				return;
			}
			var _loc1_:PlayerInfo = !!PlayerInfoViewControl.currentPlayer ? PlayerInfoViewControl.currentPlayer : PlayerManager.Instance.Self;
			var _loc2_:EquipGhostData = _loc1_.getGhostDataByCategoryID(_info.CategoryID);
			if(_loc2_)
			{
				_loc3_ = EquipGhostManager.getInstance().model.getGhostData(_info.CategoryID == 27 ? 7 : _info.CategoryID,_loc2_.level);
				if(_loc3_)
				{
//					_ghostSkillDesc.text = StringHelper.format(PetSkillManager.getSkillByID(_loc3_.skillId).Description);
//					_displayList[_displayIdx++] = _ghostSkillDesc;
				}
			}
		}
	}
}
