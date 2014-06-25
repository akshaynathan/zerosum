//
//  ZSLevelManager.m
//  ZeroSum
//
//  Created by Akshay Nathan on 6/24/14.
//  Copyright (c) 2014 AkshayNathan. All rights reserved.
//

#import "ZSLevelManager.h"

@implementation ZSLevelManager

static LevelData levelData[] = {{10.0, 5.0},
                                {8.0, 5.0},
                                {8.0, 4.0},
                                {6.0, 4.0},
                                {6.0, 3.0},
                                {4.0, 3.0},
                                {4.0, 2.0},
                                {2.0, 2.0},
                                {2.0, 1.0},
                                {2.0, 1.0}};

- (id)init {
  if (self = [super init]) {
    _level = 1;
  }
  return self;
}

- (LevelData)updateLevelWithScore:(int)score andChains:(int)chains {
  _level = [self calculateNewLevelForScore:score andChains:chains];
  return levelData[_level - 1];
}

/**
 *  Calculate the new level.
 *
 *  @param score  The current score.
 *  @param chains Total number of chains.
 *
 *  @return The correct level.
 */
- (int)calculateNewLevelForScore:(int)score andChains:(int)chains {
  int c = 1 + chains / 10;
  int s = 1 + log2(score) / 5;
  return ceil((c + s) / 2);
}

@end
