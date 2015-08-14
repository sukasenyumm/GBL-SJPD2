﻿/**
 *
 * Hungry Hero Game
 * http://www.hungryherogame.com
 * 
 * Copyright (c) 2012 Hemanth Sharma (www.hsharma.com). All rights reserved.
 * 
 * This ActionScript source code is free.
 * You can redistribute and/or modify it in accordance with the
 * terms of the accompanying Simplified BSD License Agreement.
 *  
 */

package framework.screenstates
{

	import starling.display.Button;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.VAlign;
	import framework.events.NavigationEvent;
	import framework.utils.GameAssets;
	import framework.utils.SaveManager;
	
	public class GameOverScreen extends Sprite
	{
		/** Background image. */
		private var bg:Quad;
		
		/** Message text field. */
		private var messageText:TextField;
		private var messageTextWin:TextField;
		
		/** Score container. */
		private var scoreContainer:Sprite;
		
		/** Score display - distance. */
		private var distanceText:TextField;
		
		/** Score display - score. */
		private var scoreText:TextField;
		
		/** Play again button. */
		private var playAgainBtn:Button;
		
		/** Main Menu button. */
		private var mainBtn:Button;
		
		/** About button. */
		private var aboutBtn:Button;
		
		/** Score value - distance. */
		private var _distance:int;
		
		/** Score value - score. */
		private var _score:int;
		
		public function GameOverScreen()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/**
		 * On added to stage. 
		 * @param event
		 * 
		 */
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			drawGameOver();
		}
		
		/**
		 * Draw game over screen. 
		 * 
		 */
		private function drawGameOver():void
		{
			
			// Background quad.
			bg = new Quad(stage.stageWidth, stage.stageHeight, 0x000000);
			bg.alpha = 0.75;
			this.addChild(bg);
			
			// Message text field.
			messageText = new TextField(stage.stageWidth, stage.stageHeight * 0.5, "MISI GAGAL!", "nulshock", 18, 0xf3e75f);
			messageText.vAlign = VAlign.TOP;
			messageText.height = messageText.textBounds.height;
			messageText.y = (stage.stageHeight * 20)/100;
			this.addChild(messageText);
			messageText.visible = false;
			
			messageTextWin = new TextField(stage.stageWidth, stage.stageHeight * 0.5, "MISI BERHASIL!", "nulshock", 18, 0xf3e75f);
			messageTextWin.vAlign = VAlign.TOP;
			messageTextWin.height = messageTextWin.textBounds.height;
			messageTextWin.y = (stage.stageHeight * 20)/100;
			this.addChild(messageTextWin);
			messageTextWin.visible = false;
			
			// Score container.
			scoreContainer = new Sprite();
			scoreContainer.y = (stage.stageHeight * 40)/100;
			this.addChild(scoreContainer);
			
			distanceText = new TextField(stage.stageWidth, 100, "DISTANCE TRAVELLED: 0000000", "nulshock", 18, 0xffffff);
			distanceText.vAlign = VAlign.TOP;
			distanceText.height = distanceText.textBounds.height;
			scoreContainer.addChild(distanceText);
			
			scoreText = new TextField(stage.stageWidth, 100, "SCORE: 0000000", "nulshock", 18, 0xffffff);
			scoreText.vAlign = VAlign.TOP;
			scoreText.height = scoreText.textBounds.height;
			scoreText.y = distanceText.bounds.bottom + scoreText.height * 0.5;
			scoreContainer.addChild(scoreText);
			
			// Navigation buttons.
			mainBtn = new Button(GameAssets.getAtlasFix().getTexture("btn_home"));
			mainBtn.y = (stage.stageHeight * 70)/100;
			mainBtn.addEventListener(Event.TRIGGERED, onMainClick);
			this.addChild(mainBtn);
			
			playAgainBtn = new Button(GameAssets.getAtlasFix().getTexture("btn_back"));
			playAgainBtn.y = mainBtn.y + mainBtn.height * 0.5 - playAgainBtn.height * 0.5;
			playAgainBtn.addEventListener(Event.TRIGGERED, onPlayAgainClick);
			this.addChild(playAgainBtn);
			playAgainBtn.visible = false;
			
			aboutBtn = new Button(GameAssets.getAtlasFix().getTexture("btn_credits"));
			aboutBtn.y = playAgainBtn.y + playAgainBtn.height * 0.5 - aboutBtn.height * 0.5;
			aboutBtn.addEventListener(Event.TRIGGERED, onAboutClick);
			this.addChild(aboutBtn);
			
			mainBtn.x = stage.stageWidth * 0.5 - (mainBtn.width + playAgainBtn.width + aboutBtn.width + 30) * 0.5;
			playAgainBtn.x = mainBtn.bounds.right + 10;
			aboutBtn.x = playAgainBtn.bounds.right + 10;
		}
		
		/**
		 * On play-again button click. 
		 * @param event
		 * 
		 */
		private function onPlayAgainClick(event:Event):void
		{
			//if (!Sounds.muted) Sounds.sndMushroom.play();
			
			this.dispatchEvent(new NavigationEvent(NavigationEvent.SWITCH_STATE, {id: "playAgain"}));
		}
		
		/**
		 * On main menu button click. 
		 * @param event
		 * 
		 */
		private function onMainClick(event:Event):void
		{
			//if (!Sounds.muted) Sounds.sndMushroom.play();
			
			this.dispatchEvent(new NavigationEvent(NavigationEvent.SWITCH_STATE, {id: "mainMenu"}, true));
		}
		
		/**
		 * On about button click. 
		 * @param event
		 * 
		 */
		private function onAboutClick(event:Event):void
		{
			//if (!Sounds.muted) Sounds.sndMushroom.play();
			
			this.dispatchEvent(new NavigationEvent(NavigationEvent.SWITCH_STATE, {id: "about"}, true));
		}
		
		/**
		 * Initialize Game Over container. 
		 * @param _score
		 * @param _distance
		 * 
		 */
		public function initialize(_score:int, _distance:int, win:Boolean):void
		{
			SaveManager.getInstance().saveDataScore(_distance);
			
			if(win)
			{
				messageTextWin.visible = true;
				playAgainBtn.visible = false;
			}
			else
			{
				messageText.visible = true;
				playAgainBtn.visible = true;
			}
			
			this._distance = _distance;
			this._score = _score;

			distanceText.text = "DISTANCE TRAVELLED: " + this._distance.toString();
			scoreText.text = "SCORE: " + this._score.toString();
			
			this.alpha = 0;
			this.visible = true;
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
		}
		
		/**
		 * Score. 
		 * @return 
		 * 
		 */
		public function get score():int { return _score; }
		
		/**
		 * Distance. 
		 * @return 
		 * 
		 */
		public function get distance():int { return _distance; }
	}
}