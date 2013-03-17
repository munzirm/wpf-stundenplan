//
//  TimetableCell.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "TimetableCell.h"

@implementation TimetableCell

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		UIPanGestureRecognizer* panGestures = [[UIPanGestureRecognizer alloc] init];
		[panGestures addTarget:self action:@selector(handlePanGestureRecognizer:)];
		[self addGestureRecognizer:panGestures];
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Handle Gestures

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer {
	NSLog(@"handlePanGestureRecognizer:");
	
	UIGestureRecognizerState state = gestureRecognizer.state;
	CGPoint translation = [gestureRecognizer translationInView:self];
	CGPoint velocity = [gestureRecognizer velocityInView:self];
	
	if (state == UIGestureRecognizerStateChanged) {
		
		[self setCenter:CGPointMake(self.center.x + translation.x, self.center.y)];
		[gestureRecognizer setTranslation:CGPointZero inView:self];
		
	} else if (state == UIGestureRecognizerStateCancelled ||
			   state == UIGestureRecognizerStateEnded ||
			   state == UIGestureRecognizerStateFailed) {
		
		// TODO animation
		CGRect frame = self.frame;
		frame.origin.x = 0;
		self.frame = frame;
		
		NSLog(@"cancel/ended/failed: %i", state);
		
	}
	
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	NSLog(@"gestureRecognizerShouldBegin:");
	return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	NSLog(@"gestureRecognizer: shouldRecognizeSimultaneouslyWithGestureRecognizer:");
	return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	NSLog(@"gestureRecognizer: shouldReceiveTouch:");
	return YES;
}

@end
