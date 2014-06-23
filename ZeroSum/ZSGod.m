//
//  ZSGod.m
//  ZeroSum
//
//  Created by Akshay Nathan on 6/16/14.
//  Copyright (c) 2014 AkshayNathan. All rights reserved.
//

#import "ZSGod.h"
#import "ZSUtility.h"
#import "ZSBoardNode.h"
#import "ZSTileNode.h"
#import "ZSChain.h"
#import "ZSNewTileNode.h"

@implementation ZSGod {
    ZSBoardNode *gameboard;
    ZSChain *chain;
    NSTimer *tileAdderTimer;
    NSMutableArray *tilesBackLog;
    double addInterval;
}

-(ZSGod*)initWithBoard:(ZSBoardNode*)board {
    self = [super init];
    gameboard = board;
    chain = [[ZSChain alloc] init];
    tilesBackLog = [[NSMutableArray alloc] init];
    addInterval = 10.0;
    return self;
}

-(void)start {
    // Create starting tiles
    [self initStartingTiles];
    
    // Add initial timer
    tileAdderTimer = [NSTimer scheduledTimerWithTimeInterval:GRACE_PERIOD
                                                      target:self
                                                    selector:@selector(addNewTile)
                                                    userInfo:nil
                                                     repeats:NO];
}

/**
 *  Add the starting tiles to each row.
 */
-(void)initStartingTiles {
    for(int i = 0; i < BOARD_COLUMNS; i++) {
        for(int k = 0; k < STARTING_TILES; k++) {
            ZSTileNode *t = [ZSTileNode nodeWithValue:[ZSUtility randomValue]];
            [gameboard addTile:t atColumn:i andRow:k];
        }
    }
}

-(ZSTileNode*)addTileToChain:(ZSTileNode*)tile {
    // No repeats
    if(tile == [chain lastTile])
        return nil;
    // No non neighbors
    if(!([tile isNeighborsWith:[chain lastTile]])
       && [chain lastTile] != nil)
        return nil;
    // No cycles
    if([tile isConnected])
        return nil;
    [[chain lastTile] connectTo:tile];
    [chain addTile:tile];
    return tile;
}

-(int)clearChain {
    int sum = [chain runningSum];
    if(sum == 0) {
        while([chain lastTile] != nil) {
            ZSTileNode *t = [chain popTile];
            [gameboard removeTileAtColumn:t.column andRow:t.row];
        }
    } else {
        while([chain lastTile] != nil) {
            ZSTileNode *t = [chain popTile];
            [t disconnect];
        }
    }
    return sum;
}

-(ZSNewTileNode*)addNewTile {
    ZSNewTileNode *n = [ZSNewTileNode nodeWithValue:[ZSUtility randomValue]];
    int new_column = [gameboard getFreeColumn];
    if(new_column == -1) {
        // Add tile to queue for later
        // TODO: Add tests for the queue.
        [tilesBackLog addObject:n];
    } else {
        [gameboard addNewTile:n atColumn:new_column];
    }
    
    // Reset timer
    // TODO: Add tests for timer
    tileAdderTimer = [NSTimer scheduledTimerWithTimeInterval:addInterval
                                                      target:self
                                                    selector:@selector(addNewTile)
                                                    userInfo:nil
                                                     repeats:NO];
    return n;
}

-(ZSTileNode*)transitionNewTile:(ZSNewTileNode*)t {
    // Do not transition a tile that is already emerging
    if(t.isEmerging == YES)
        return nil;
    
    ZSTileNode *ret = [t toRealTile];
    
    // Add the real tile.
    [gameboard addTile:ret atColumn:ret.column andRow:0];
    
    // TODO: Add tests for this animation
    // Animate the new tile away
    [t runAction:[SKAction fadeOutWithDuration:NEW_TILE_FADE_DURATION]
      completion:^() {
          [gameboard removeNewTileAtColumn:ret.column];
          [self clearQueue:ret.column];
      }];
    return ret;
}

/**
 *  If the queue has items, this will add the first new tile
 *  to the newly opened position.
 *
 *  @param column The column to add the new tile to.
 */
-(void)clearQueue:(int)column {
    if([tilesBackLog count] != 0) {
        ZSNewTileNode *k = [tilesBackLog objectAtIndex:0];
        [tilesBackLog removeObjectAtIndex:0];
        [gameboard addNewTile:k atColumn:column];
    }
}
@end
