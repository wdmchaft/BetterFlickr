//
//  QuartzViews.m
//  BetterFlickr
//
//  Created by Johan Attali on 11/27/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import "QuartzViews.h"

#pragma mark -
#pragma mark Quartz General

@implementation QuartzView

-(id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self != nil)
	{
		self.backgroundColor = [UIColor blackColor];
		self.opaque = YES;
		self.clearsContextBeforeDrawing = YES;
	}
	return self;
}

-(void)drawInContext:(CGContextRef)context
{
	// Default is to do nothing!
}

-(void)drawRect:(CGRect)rect
{
	// Since we use the CGContextRef a lot, it is convienient for our demonstration classes to do the real work
	// inside of a method that passes the context as a parameter, rather than having to query the context
	// continuously, or setup that parameter for every subclass.
	[self drawInContext:UIGraphicsGetCurrentContext()];
}

@end

#pragma mark -
#pragma mark Quartz Line

@implementation QuartzLineView

-(void)drawInContext:(CGContextRef)context
{
	// Drawing lines with a white stroke color
	CGContextSetRGBStrokeColor(context, 0.3, 0.3, 0.3, 1.0);
	// Draw them with a 2.0 stroke width so they are a bit more visible.
	CGContextSetLineWidth(context, 3.0);
	
	// Draw a single line from left to right
	CGContextMoveToPoint(context, 0, 0);
	CGContextAddLineToPoint(context, self.frame.size.width, 0);
	CGContextStrokePath(context);
	
//	// Draw a connected sequence of line segments
//	CGPoint addLines[] =
//	{
//		CGPointMake(10.0, 90.0),
//		CGPointMake(70.0, 60.0),
//		CGPointMake(130.0, 90.0),
//		CGPointMake(190.0, 60.0),
//		CGPointMake(250.0, 90.0),
//		CGPointMake(310.0, 60.0),
//	};
//	// Bulk call to add lines to the current path.
//	// Equivalent to MoveToPoint(points[0]); for(i=1; i<count; ++i) AddLineToPoint(points[i]);
//	CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));
//	CGContextStrokePath(context);
//	
//	// Draw a series of line segments. Each pair of points is a segment
//	CGPoint strokeSegments[] =
//	{
//		CGPointMake(10.0, 150.0),
//		CGPointMake(70.0, 120.0),
//		CGPointMake(130.0, 150.0),
//		CGPointMake(190.0, 120.0),
//		CGPointMake(250.0, 150.0),
//		CGPointMake(310.0, 120.0),
//	};
//	// Bulk call to stroke a sequence of line segments.
//	// Equivalent to for(i=0; i<count; i+=2) { MoveToPoint(point[i]); AddLineToPoint(point[i+1]); StrokePath(); }
//	CGContextStrokeLineSegments(context, strokeSegments, sizeof(strokeSegments)/sizeof(strokeSegments[0]));
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
