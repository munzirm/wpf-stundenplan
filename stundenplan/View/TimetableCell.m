//
//  TimetableCell.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "TimetableCell.h"

@implementation TimetableCell {
	UIPanGestureRecognizer* _panGestures;
	UITableView* _optionView;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		_panGestures = [[UIPanGestureRecognizer alloc] init];
		_panGestures.delegate = self;
		[_panGestures addTarget:self action:@selector(handlePanGestureRecognizer:)];
		[self addGestureRecognizer:_panGestures];
	}
	return self;
}

- (void)dealloc {
	[self removeOptionView];
	[self removeGestureRecognizer:_panGestures];
	_panGestures.delegate = nil;
	_panGestures = nil;
}

#pragma mark - Handle Gestures

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer {
	UIGestureRecognizerState state = gestureRecognizer.state;
	
	// Handle the pan and move or animate the views:
	if (state == UIGestureRecognizerStateChanged) {
		
		// Drag n drop
		CGPoint translation = [gestureRecognizer translationInView:self];
		self.center = CGPointMake(
				self.center.x + translation.x,
				self.center.y);
		[self updateOptionViewPosition];
		
		// Reset gesture translation
		[gestureRecognizer setTranslation:CGPointZero inView:self];
		
	} else if (state == UIGestureRecognizerStateCancelled ||
			   state == UIGestureRecognizerStateEnded ||
			   state == UIGestureRecognizerStateFailed) {
		
		// Calculate velocity
		CGPoint velocity = [gestureRecognizer velocityInView:self];
		
		NSLog(@"velocity: %f", velocity.x);
		NSLog(@"velocity: %f", velocity.x);

		[self bounceToOrigin];
		
	}
	
}

- (void) bounceToOrigin {
	[UIView animateWithDuration:0.3 animations:^{
		CGRect frame = self.frame;
		frame.origin.x = 0;
		self.frame = frame;
	} completion:^(BOOL finished) {
		[self removeOptionView];
	}];
}

- (void) createOptionView {
	if (!_optionView) {
		static NSString *CellIdentifier = @"TimetableOptionCell";
		_optionView = [(UITableView*) self.superview dequeueReusableCellWithIdentifier:CellIdentifier];
		[self addSubview:_optionView];
	}
}

- (void) updateOptionViewPosition {
	[self createOptionView];
	if (self.frame.origin.x < 0) {
		// Use schiebt view nach LINKS -- optionview von RECHTS
		_optionView.center = CGPointMake(
										 _optionView.frame.size.width * 1.5,
										 _optionView.center.y);
	} else {
		// Use schiebt view nach RECHTS -- optionview von LINKS
		_optionView.center = CGPointMake(
										 _optionView.frame.size.width * -0.5,
										 _optionView.center.y);
	}
}

- (void) removeOptionView {
	// TODO wieder in die queue legen oder oben initialisieren statt reusen?
	[_optionView removeFromSuperview];
	_optionView = nil;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	return [gestureRecognizer locationInView:self].x > 40;
}

@end
