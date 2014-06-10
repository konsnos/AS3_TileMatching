package com.konlab.TileMatching 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Konstantinos Egkarchos
	 */
	public class Item extends Sprite 
	{
		private var _id:int;
		private var _row:int;
		private var _column:int;
		private var _shape:Shape;
		private var _debugShape:Shape;
		
		/** Size of the item. */
		static public const SIZE:int = 30;
		
		public function get id():int 
		{
			return _id;
		}
		
		public function Item()
		{
			super();
			
			_shape = new Shape();
			DrawShape();
			
			_debugShape = new Shape();
			_debugShape.graphics.beginFill(0x0, 1);
			_debugShape.graphics.drawCircle(SIZE / 2, SIZE / 2, SIZE / 2);
			_debugShape.graphics.endFill();
			_debugShape.alpha = 0.5;
			_debugShape.visible = false;
			
			addChild(_shape);
			addChild(_debugShape);
		}
		
		public function ChangeId(newId:int):void 
		{
			_id = newId;
			if (_id < 0) 
			{
				_id = 0;
			}
			else if (_id >= ItemColors.COLORS.length) 
			{
				_id = ItemColors.COLORS.length - 1;
			}
			
			DrawShape();
			ShowDebugShape(false);
		}
		
		public function ChangeColumnRow(newColumn:int, newRow:int):void 
		{
			_column = newColumn;
			_row = newRow;
		}
		
		private function DrawShape():void 
		{
			_shape.graphics.clear();
			
			_shape.graphics.lineStyle(2, 0x00000);
			_shape.graphics.beginFill(ItemColors.COLORS[_id], 1);
			_shape.graphics.drawRect(0, 0, SIZE, SIZE);
			_shape.graphics.endFill();
		}
		
		public function ShowDebugShape(show:Boolean):void 
		{
			_debugShape.visible = show;
		}
	}
}