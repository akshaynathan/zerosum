//
//  ZSGod.h
//  ZeroSum
//
//  Created by Akshay Nathan on 6/16/14.
//  Copyright (c) 2014 AkshayNathan. All rights reserved.
//

#import <Foundation/Foundation.h>

// Game Dynamics
#define STARTING_TILES 6
#define GRACE_PERIOD 5.0
#define SUGGEST_BUFFER 9

@class ZSBoardNode;
@class ZSTileNode;
@class ZSNewTileNode;
@class ZSScoreNode;
@class ZSLevelManager;
@class ZSChain;
@class ZSGameScene;

@interface ZSGod : NSObject

enum STATE { PAUSED, STOPPED, RUNNING };

@property(atomic, readonly) ZSChain *chain;
@property(atomic, readonly) ZSBoardNode *gameboard;
@property(atomic, readonly) ZSScoreNode *score;
@property(atomic, readonly) ZSLevelManager *levelMan;
@property(atomic, readonly) enum STATE state;

/**
 *  Create a God object with a given board.
 *
 *  @param board The game board.
 *  @param gamescene The Scene the game board belongs to.
 *
 *  @return The constructed ZSGod.
 */
- (ZSGod *)initWithBoard:(ZSBoardNode *)board inScene:(ZSGameScene *)gamescene;

/**
 *  Start the game.
 */
- (void)start;

/**
 *  Adds the tile to the chain if its a valid next tile.
 *  Returns the tile or nil if it cant be added.
 */
- (ZSTileNode *)addTileToChain:(ZSTileNode *)tile;

/**
 *  Clears the chain, updates the score if the sum is 0.
 *  Returns the sum of the chain.
 */
- (int)clearChain;

/**
 *  Makes a new tile node into a real tile.
 *  Also adds tiles out of the queue if possible.
 *
 *  @param t The new tile to emerge.
 *
 *  @return The tile that the new tile becomes.
 */
- (ZSTileNode *)transitionNewTile:(ZSNewTileNode *)t;

/**
 *  Suggests a new tile value given the current board state.
 *
 *  @return The value for the tile.
 */
- (int)suggestNewTileValue;

@end
