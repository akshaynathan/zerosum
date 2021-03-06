//
//  ZSTileNodeTest.m
//  ZeroSum
//
//  Created by Akshay Nathan on 5/27/14.
//  Copyright (c) 2014 AkshayNathan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZSTileNode.h"
#import "ZSUtility.h"

@interface ZSTileNodeTest : XCTestCase

@end

@implementation ZSTileNodeTest {
  ZSTileNode *node;
}

- (void)setUp {
  [super setUp];

  node = [ZSTileNode nodeWithValue:5];
  node.row = 3;
  node.column = 4;
}

- (void)tearDown {
  [super tearDown];
}

- (void)testInit {
  XCTAssert(node.value == 5, "Tile value not set correctly.");
  XCTAssert(node.row == 3 && node.column == 4,
            "Tile position not set correctly.");
}

- (void)testNeighbors {
  ZSTileNode *other = [ZSTileNode nodeWithValue:4];

  other.row = 3;
  other.column = 5;

  XCTAssert([node isNeighborsWith:other], "Unable to detect row neighbor.");

  other.row = 3;
  other.column = 3;

  XCTAssert([node isNeighborsWith:other], "Unable to detect row neighbor.");

  other.row = 4;
  other.column = 4;

  XCTAssert([node isNeighborsWith:other], "Unable to detect row neighbor.");

  other.row = 2;
  other.column = 4;

  XCTAssert([node isNeighborsWith:other], "Unable to detect column neighbor.");

  other.row = 4;
  other.column = 5;

  XCTAssert([node isNeighborsWith:other],
            "Unable to detect diagonal neighbor.");

  other.row = 4;
  other.column = 3;

  XCTAssert([node isNeighborsWith:other],
            "Unable to detect diagonal neighbor.");

  other.row = 2;
  other.column = 5;

  XCTAssert([node isNeighborsWith:other],
            "Unable to detect diagonal neighbor.");

  other.row = 2;
  other.column = 3;

  XCTAssert([node isNeighborsWith:other],
            "Unable to detect diagonal neighbor.");
}

- (void)testConnections {
  ZSTileNode *other = [ZSTileNode nodeWithValue:3];
  other.row = 4;
  other.column = 1;

  [node connectTo:other];
  XCTAssertFalse([node isConnected], "Non-neighbor connections should fail.");

  other.row = 4;
  other.column = 4;
  [node connectTo:other];
  XCTAssertTrue([node isConnected], "Neighboring connection should succeed.");

  [node disconnect];
  XCTAssertFalse([node isConnected], "Node should disconnect.");

  [node disconnect];  // This should not do anything
}

- (void)testIsCentered {
  CGPoint k = CGPointMake(TILE_SIZE / 2, TILE_SIZE / 2);
  ZSTileNode *f = [ZSTileNode nodeWithValue:5];
  XCTAssert([f isCentered:k], "isCentered should return YES for real center.");
  CGPoint l = CGPointMake(0, 0);
  XCTAssertFalse([f isCentered:l], "isCentered should return NO for origin.");
}

@end
