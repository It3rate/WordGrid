#import <UIKit/UIKit.h>
#import "GridProtocol.h"
#import "Tile.h"

@interface TileGrid : UIView <GridProtocol>
{    
    int gw;
    int gh;
    int margin;
    float slotWidth;
    float slotHeight;
    NSMutableArray *tiles;
    UIInterfaceOrientation io;
    int lastHoverTileIndex;
    float animationDelay;
    Boolean hasGap;
}

- (void)    genericSetup;
- (void)    setup;
- (void)    createLetters;
- (void)    clearAllHovers;
- (Tile *)  insertTile:(Tile *)tile At:(int) index;
- (void)    removeVerticalGaps;
- (CGPoint)  getPointFromIndex:(int)index;
- (void)    setSelectableAroundIndex:(int) index;
- (void)    onSelectTile:(NSNotification *)notification;
- (void)    ownTileSelected:(Tile *)tile;
- (Tile *)  getTileAtIndex:(int) index;
- (NSString *) serializeGridLetters;
- (void)    setSelectableByLetter:(NSString *)let;
- (void)    resetAnimationDelay:(int) delay;
- (void)    insertLastVerticalGaps;
- (void)    moveColumn:(int)src toColumn:(int)dest;
- (void)    clearAllSelections;

@end
