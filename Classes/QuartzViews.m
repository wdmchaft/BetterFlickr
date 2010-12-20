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


// Override - (id)initWithCoder:(NSCoder *)decoder as well since it the function
// called instead of -(id)initWithFrame:(CGRect)frame when loading from a nib file
- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
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
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super initWithCoder:decoder])) {
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
