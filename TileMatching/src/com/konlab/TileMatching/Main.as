package com.konlab.TileMatching
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Konstantinos Egkarchos
	 */
	public class Main extends Sprite 
	{
		private var _gameStage:GameStage;
		private var _recheck:TextField;
		private var _shuffle:TextField;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_gameStage = new GameStage();
			_gameStage.x = stage.stageWidth / 2 - _gameStage.width / 2;
			_gameStage.y = stage.stageHeight / 2 - _gameStage.height / 2;
			addChild(_gameStage);
			
			_recheck = new TextField();
			_recheck.selectable = false;
			_recheck.background = true;
			_recheck.backgroundColor = 0x0;
			_recheck.textColor = 0xffffff;
			_recheck.text = "Check";
			_recheck.width = 100;
			_recheck.height = 20;
			
			_shuffle = new TextField();
			_shuffle.selectable = false;
			_shuffle.background = true;
			_shuffle.backgroundColor = 0x0;
			_shuffle.textColor = 0xffffff;
			_shuffle.text = "Shuffle";
			_shuffle.width = 100;
			_shuffle.height = 20;
			_shuffle.y = 20;
			
			addChild(_recheck);
			addChild(_shuffle);
			
			_recheck.addEventListener(MouseEvent.MOUSE_DOWN, onRecheckClicked);
			_shuffle.addEventListener(MouseEvent.MOUSE_DOWN, onShuffleClicked);
		}
		
		private function onShuffleClicked(e:MouseEvent):void 
		{
			_gameStage.reshuffle();
		}
		
		private function onRecheckClicked(e:MouseEvent):void 
		{
			_gameStage.CheckAndShowMatches();
		}
	}
}