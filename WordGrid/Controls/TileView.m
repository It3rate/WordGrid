//
//  TileView.m
//  WordGrid
//
//  Created by admin on 12-12-01.
//
//

#import "TileView.h"
#import "Tile.h"
#import "GameRating.h"

@interface TileView()
{
    UIImage *image;
    CGRect scaleNormalRect;
    CGRect scaleMidRect;
    CGRect scaleUpRect;
    Boolean errorMarkVisible;
}

@end

@implementation TileView

@synthesize tile = _tile;
@synthesize isHovering = _isHovering;
@synthesize isSelectable  = _isSelectable;

static NSArray *imageStates;
static UIImage *errorImage;
static UIImage *checkImage;
static float hoverScale = 1.5;
//static SystemSoundID tickSoundID;

- (id) initWithFrame:(CGRect)frame andTile:(Tile *) t
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _tile = t;
        [self setup];
    }
    return self;
}

-(Tile *)tile
{
    return _tile;
}

-(void)setTile:(Tile *)t
{
    _tile = t;
    if(t == (id)[NSNull null])
    {        
        self.isHidden = YES;
        self.isSelectable = NO;
        self.isSelected = NO;
    }
}

-(void) setIsHovering:(Boolean)hovering
{
    if(_isHovering != hovering)
    {
        _isHovering = hovering;
        
        if(_isHovering)
        {        
            [self.superview bringSubviewToFront:self];
            if(_tile.isSelectable)
            {
                self.bounds = scaleUpRect;
            }
            else
            {
                self.bounds = scaleMidRect;
            }
        }
        else
        {
            self.bounds = scaleNormalRect;        
        }
        
        [self setNeedsDisplay];
    }
}

- (void) setup
{
    image = [imageStates objectAtIndex:0];
    self.animatingFrom = CGRectNull;
    _isHovering = NO;
    _currentIndex = IntPointMake(-1, -1);
    _isSelected = NO;
    _isSelectable = NO;
    _isHidden = YES;
    _isOffScreen = NO;
    
    CGRect f = [self frame];
    float xBorder = ((f.size.width * hoverScale) - f.size.width) / 2.0;
    float yBorder = ((f.size.height * hoverScale) - f.size.height) / 2.0;
    scaleNormalRect = f;    
    scaleMidRect = CGRectInset(f, -xBorder / 3.0f, -yBorder / 3.0f);
    scaleUpRect = CGRectInset(f, -xBorder, -yBorder);
}

+ (void) load
{
    @autoreleasepool
    {
        errorImage = [UIImage imageNamed:@"errorTile.png"];
        checkImage = [UIImage imageNamed:@"checkTile.png"];
        
        imageStates = [[NSArray alloc] initWithObjects:
                       [UIImage imageNamed:@"let_norm.png"],
                       [UIImage imageNamed:@"let_sel0.png"],
                       [UIImage imageNamed:@"let_sel1.png"],
                       [UIImage imageNamed:@"let_sel2.png"], nil];
    }
}

- (void)drawRect:(CGRect)rect
{
    if(_tile == (id)[NSNull null] || _tile.isHidden)
    {
        self.hidden = YES;
    }
    else if(_isOffScreen)
    {
        self.hidden = YES;
    }
    else
    {
        //self.clipsToBounds = NO;
        
        self.hidden = NO;
        CGRect r = self.bounds;
        
        //[image drawAtPoint:(CGPointMake(0.0f, 0.0f))];
        [image drawInRect:r];
        
        if(errorMarkVisible)
        {
            [errorImage drawInRect:r];
        }
        
        float fontSize = r.size.width * 0.8;
        UIFont *f = [UIFont fontWithName:@"VTC Letterer Pro" size:fontSize];
        CGSize stringSize = [_tile.letter sizeWithAttributes:@{NSFontAttributeName:f}];
        CGRect letR = CGRectOffset(r, 0.0, ((r.size.height - stringSize.height) / 2.0));

        if(_tile.isSelected)
        {
            [[UIColor lightGrayColor] set];
        }
        else
        {
            [[UIColor whiteColor] set];
        }
        
        [_tile.letter drawInRect:letR withFont:f lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
        
        CGContextRef context;
        if(_tile.isSelectable && (_tile.rating == nil || _tile.rating.roundRating < inProgress))
        {
            context = UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(context, 4);
            CGContextSetRGBStrokeColor(context, 0.2, 0.5, 1.0, 1);
            CGContextStrokeRect(context, r);
        }
        
        if(_tile.rating)
        {
            switch (_tile.rating.roundRating)
            {
                case notStarted:
                    break;
                    
                case inProgress:
                    context = UIGraphicsGetCurrentContext();
                    CGContextSetLineWidth(context, 8);
                    CGContextSetRGBStrokeColor(context, 1.0, 0.3, 0.3, 0.3);
                    CGContextStrokeRect(context, CGRectInset(r, 4, 4));
                    break;
                    
                case complete0:
                case complete1:
                case complete2:
                    context = UIGraphicsGetCurrentContext();
                    CGContextSetLineWidth(context, 8);
                    CGContextSetRGBStrokeColor(context, 0.2, 1.0, 0.5, 0.3);
                    CGContextStrokeRect(context, CGRectInset(r, 4, 4));
                    
                    [checkImage drawInRect:r];
                    break;
                    
                default:
                    break;
            }
        }
    }
}

//- (NSString *)description
//{
//    return [NSString stringWithFormat:@"canSel:%@t%@ sel:%@t%@, let:%@, pt:%d,%d ptt:%d,%d fr:%d,%d,%d,%d",
//            _isSelectable ? @"Y" : @"N",
//            _tile.isSelectable ? @"Y" : @"N",
//            _isSelected ? @"Y" : @"N",
//            _tile.isSelected ? @"Y" : @"N",
//            _tile.letter,
//            (int)_currentIndex.x,
//            (int)_currentIndex.y,
//            (int)_tile.currentIndex.x,
//            (int)_tile.currentIndex.y,
//    
//            (int)self.frame.origin.x, (int)self.frame.origin.y,
//            (int)self.frame.size.width, (int)self.frame.size.height];
//}


//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    // move hover to grid
//    self.isHovering = YES;
//}
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesMoved:touches withEvent:event];
//}
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesEnded:touches withEvent:event];
//    self.isHovering = NO;
//    //NSLog(@"%i", gridIndex);
//    if(_tile.isSelectable)
//    {
//        AudioServicesPlaySystemSound(tickSoundID);
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"onTileSelected" object:self];
//    }
//    [self setNeedsDisplay];
//}
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesEnded:touches withEvent:event];
//}

@end
