package com.konlab.TileMatching
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Konstantinos Egkarchos
	 */
	public class GameStage extends Sprite
	{
		static public const COLUMNS:int = 8;
		static public const ROWS:int = 8;
		private var _array:Vector.<Vector.<Item>>;
		/** Contains x and y about the tile selected at the start. */
		private var _clickedTile:Vector.<int>;
		/** Contains x and y about the tile selected at the start. */
		private var _upClickedTile:Vector.<int>;
		
		// Ids to split matches in rows or columns
		static private const COLUMN_ID:int = 0;
		static private const ROW_ID:int = 1;
		
		public function GameStage()
		{
			super();
			
			initializeArray();
		}
		
		/**
		 * Initializes array.
		 */
		private function initializeArray():void
		{
			_array = new Vector.<Vector.<Item>>(COLUMNS, true);
			for (var i:int = 0; i < _array.length; i++)
			{
				_array[i] = new Vector.<Item>(ROWS, true);
				for (var j:int = 0; j < _array[i].length; j++)
				{
					_array[i][j] = new Item();
					_array[i][j].ChangeColumnRow(i, j);
					_array[i][j].ChangeId(Math.round(Math.random() * (ItemColors.COLORS.length + 0.5) - 0.5));
					_array[i][j].x = Item.SIZE * i;
					_array[i][j].y = Item.SIZE * j;
					addChild(_array[i][j]);
					_array[i][j].addEventListener(ItemEvent.CLICKED_DOWN, onItemClickedDown);
					_array[i][j].addEventListener(ItemEvent.CLICKED_UP, onItemClickedUp);
				}
			}
			
			CheckAndReshuffleMatches();
		}
		
		private function onItemClickedUp(e:ItemEvent):void 
		{
			_clickedTile = new Vector.<int> [ e.tileRow, e.tileColumn ];
		}
		
		private function onItemClickedDown(e:ItemEvent):void 
		{
			_upClickedTile = new Vector.<int> [ e.tileRow, e.tileColumn ];
			
			CheckToSwap();
		}
		
		/**
		 * Check if the tiles to their new positions will create a match.
		 * If yes commit the swap. If not cancel it.
		 */
		private function CheckToSwap():void 
		{
			//TODO: implement this
		}
		
		/**
		 * Reshuffles all tiles, and then checks for matches and reshuffles them.
		 */
		public function reshuffle():void
		{
			for (var i:int = 0; i < COLUMNS; i++)
			{
				for (var j:int = 0; j < ROWS; j++)
				{
					reshuffleTile(i, j);
				}
			}
			
			CheckAndReshuffleMatches();
		}
		
		/**
		 * Changes the type of a tile to a random one.
		 */
		[Inline]
		
		private function reshuffleTile(x:int, y:int):void
		{
			_array[x][y].ChangeId(Math.round(Math.random() * (ItemColors.COLORS.length + 0.5) - 0.5));
		}
		
		/**
		 * Indicates provided line.
		 * First two variables indicate the starting tile.
		 * The type variable indicates if it's a row or column.
		 * Finally length indicates how big is the line.
		 */
		private function MarkToDestroy(row, column, type, length):void
		{
			var finalIndex:int;
			
			if (type == ROW_ID)
			{
				finalIndex = row + length;
				for (var i:int = row; i < finalIndex; i++)
				{
					_array[i][column].ShowDebugShape(true);
				}
			}
			else if (type == COLUMN_ID)
			{
				finalIndex = column + length;
				for (var j:int = column; j < finalIndex; j++)
				{
					_array[row][j].ShowDebugShape(true);
				}
			}
		}
		
		/**
		 * Finds matches and reshuffles the tiles. Then rechecks again recursively until no match is found.
		 * If no match is found function just returns.
		 */
		public function CheckAndReshuffleMatches():void
		{
			var matchesFound:Array = CheckMatches();
			
			if (matchesFound.length > 0)
			{
				for (var i:int = 0; i < matchesFound.length; i++)
				{
					var finalIndex:int;
					
					if (matchesFound[i][2] == ROW_ID)
					{
						finalIndex = matchesFound[i][0] + matchesFound[i][3];
						for (var k:int = matchesFound[i][0]; k < finalIndex; k++)
						{
							reshuffleTile(k, matchesFound[i][1]);
						}
					}
					else if (matchesFound[i][2] == COLUMN_ID)
					{
						finalIndex = matchesFound[i][1] + matchesFound[i][3];
						for (var j:int = matchesFound[i][1]; j < finalIndex; j++)
						{
							reshuffleTile(matchesFound[i][0], j);
						}
					}
				}
				
				CheckAndReshuffleMatches();
			}
		}
		
		/**
		 * Checks if matches exist and indicates them.
		 */
		public function CheckAndShowMatches():void
		{
			var matchesFound:Array = CheckMatches();
			for (var k:int = 0; k < matchesFound.length; k++)
			{
				MarkToDestroy(matchesFound[k][0], matchesFound[k][1], matchesFound[k][2], matchesFound[k][3]);
			}
		}
		
		/**
		 * Checks for matches of 3 and more tiles horizontally and vertically.
		 * Then returns a formatted array with all these matches.
		 * The array is 2D and formats as [row, column, type (horizontal or vertical), length].
		 * @return
		 */
		public function CheckMatches():Array
		{
			var matchesFound:Array = [];
			
			var row:int;
			var column:int;
			/** Place of row or column of the first match. */
			var firstMatch:int;
			var prevColor:int;
			var matchLength:int;
			
			// First check columns
			for (row = 0; row < ROWS; row++)
			{
				firstMatch = -1;
				prevColor = -1;
				for (column = 0; column < COLUMNS; column++)
				{
					_array[row][column].ShowDebugShape(false);
					// We have a match
					if (_array[row][column].id == prevColor)
					{
						// Add to current match
						if (firstMatch != -1)
						{
							matchLength++;
						}
						else
						{
							firstMatch = column - 1;
							matchLength = 2;
						}
					}
					// No previous or current match
					else
					{
						// Check previous match if exists and register it
						if (firstMatch != -1)
						{
							if (matchLength >= 3)
							{
								matchesFound.push([row, firstMatch, COLUMN_ID, matchLength]);
							}
							firstMatch = -1;
							matchLength = 0;
						}
						
						// Register last id
						prevColor = _array[row][column].id;
					}
				}
				
				// check for previous match and register it
				if (firstMatch != -1)
				{
					if (matchLength >= 3)
					{
						matchesFound.push([row, firstMatch, COLUMN_ID, matchLength]);
					}
				}
			}
			
			// Check rows
			for (column = 0; column < COLUMNS; column++)
			{
				firstMatch = -1;
				prevColor = -1;
				for (row = 0; row < ROWS; row++)
				{
					_array[row][column].ShowDebugShape(false);
					// We have a match
					if (_array[row][column].id == prevColor)
					{
						// Add to current match
						if (firstMatch != -1)
						{
							matchLength++;
						}
						else
						{
							firstMatch = row - 1;
							matchLength = 2;
						}
					}
					// No previous or current match
					else
					{
						// Check previous match if exists and register it
						if (firstMatch != -1)
						{
							if (matchLength >= 3)
							{
								matchesFound.push([firstMatch, column, ROW_ID, matchLength]);
							}
							firstMatch = -1;
							matchLength = 0;
						}
						
						// Register last id
						prevColor = _array[row][column].id;
					}
				}
				
				// check for previous match and register it
				if (firstMatch != -1)
				{
					if (matchLength >= 3)
					{
						matchesFound.push([firstMatch, column, ROW_ID, matchLength]);
					}
				}
			}
			
			trace("[GameStage] Found " + matchesFound.length + " matches");
			
			return matchesFound;
		}
	}

}