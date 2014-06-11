package com.konlab.TileMatching 
{
	import flash.events.Event;
	
	/**
	 * Events for tiles.
	 * @author Konstantinos Egkarchos
	 */
	public class ItemEvent extends Event 
	{
		/** Row the tile is in. */
		private var _tileRow:int;
		/** Column the tile is in. */
		private var _tileColumn:int;
		
		static public const CLICKED_DOWN:String = "clickDown";
		static public const CLICKED_UP:String = "clickUp";
		
		public function ItemEvent(type:String, row:int, column:int) 
		{
			_tileRow = row;
			_tileColumn = column;
			
			super(type);
		}
		
		public function get tileRow():int 
		{
			return _tileRow;
		}
		
		public function get tileColumn():int 
		{
			return _tileColumn;
		}
	}
}