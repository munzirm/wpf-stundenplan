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

- (void)prepareForReuse {
	[super prepareForReuse];
	
	[self removeOptionView];
	self.contentView.hidden = NO;
	
	CGRect frame = self.frame;
	frame.origin.x = 0;
	self.frame = frame;
}

#pragma mark - Handle Gestures

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer {
	UIGestureRecognizerState state = gestureRecognizer.state;
	
	if (state == UIGestureRecognizerStateBegan) {
		
		if (!_optionView) {
			[self createOptionView];
		} else {
			// Move the orignal back again to the right side of the option.
			CGFloat width = self.frame.size.width;
			self.center = CGPointMake(self.center.x - width, self.center.y);
			_optionView.center = CGPointMake(_optionView.center.x + width, _optionView.center.y);
			
			// Ensure also we show all content
			_optionView.hidden = NO;
			self.contentView.hidden = NO;
		}
		
	} else if (state == UIGestureRecognizerStateChanged) {
		
		// Handle the pan and implement drag n drop here:
		
		CGPoint translation = [gestureRecognizer translationInView:self];
		[self moveTranslation:translation.x];
		
		// Reset gesture translation
		[gestureRecognizer setTranslation:CGPointZero inView:self];
		
	} else if (state == UIGestureRecognizerStateCancelled ||
			   state == UIGestureRecognizerStateEnded ||
			   state == UIGestureRecognizerStateFailed) {
		
		// Calculate velocity
		CGFloat velocity = [gestureRecognizer velocityInView:self].x;
		CGFloat position = self.center.x + velocity;
		NSLog(@"center %f + velocity %f = %f", self.center.x, velocity, position);
		NSLog(@"option view ursprung: %f", _optionView.frame.origin.x);
		if (position < 0 && _optionView.frame.origin.x > 0) {
			[self animateToOptionWithDirection:UISwipeGestureRecognizerDirectionLeft];
		} else if (position > self.frame.size.width && _optionView.frame.origin.x < 0) {
			[self animateToOptionWithDirection:UISwipeGestureRecognizerDirectionRight];
		} else {
			[self animateToOrigin];
		}
	}
	
}

- (void) moveTranslation: (CGFloat) x {
	CGFloat width = self.frame.size.width;
	CGRect originalFrame = self.frame;
	CGRect optionFrame = _optionView.frame;
	
	originalFrame.origin.x += x;
	
	if (originalFrame.origin.x > 0 && optionFrame.origin.x > 0) {
		// Move option frame on the left side of the original.
		NSLog(@"option jumps to the left side of the original.");
		optionFrame.origin.x -= originalFrame.size.width + optionFrame.size.width;
	} else if (originalFrame.origin.x < 0 && optionFrame.origin.x < 0) {
		// Move option frame to the right side of the original.
		NSLog(@"option jumps to the right side of the original.");
		optionFrame.origin.x += originalFrame.size.width + optionFrame.size.width;
	} else if (originalFrame.origin.x > width) {
		// Original is on the right side and will be pushed out by the option.
		NSLog(@"original jumps to the left side of the option.");
		originalFrame.origin.x -= width * 2;
		optionFrame.origin.x += width * 2;
	} else if (originalFrame.origin.x < -width) {
		// Original is on the left side and will be pushed out by the option
		NSLog(@"original jumps to the right side of the option.");
		originalFrame.origin.x += width * 2;
		optionFrame.origin.x -= width * 2;
	}
	
	self.frame = originalFrame;
	_optionView.frame = optionFrame;
}

- (void) animateToOrigin {
	// TODO Animationsdauer abhängig von Velocity und/oder dem Abstand machen?
	[UIView animateWithDuration:0.4 animations:^{
		CGRect frame = self.frame;
		frame.origin.x = 0;
		self.frame = frame;
	} completion:^(BOOL finished) {
		[self removeOptionView];
	}];
}

- (void) animateToOptionWithDirection: (UISwipeGestureRecognizerDirection) direction {
	// TODO Animationsdauer abhängig von Velocity und/oder dem Abstand machen?
	
	// Animate original out and options in
	[UIView animateWithDuration:0.4 animations:^{
		CGRect originalFrame = self.frame;
		CGPoint optionCenter = _optionView.center;
		
		if (direction == UISwipeGestureRecognizerDirectionLeft) {
			NSLog(@"detect to left swipe.");
			originalFrame.origin.x = -originalFrame.size.width;
			optionCenter.x = _optionView.frame.size.width * 1.5;
		} else if (direction == UISwipeGestureRecognizerDirectionRight) {
			NSLog(@"detect to right swipe.");
			originalFrame.origin.x = originalFrame.size.width;
			optionCenter.x = _optionView.frame.size.width * -0.5;
		}
		
		self.frame = originalFrame;
		_optionView.center = optionCenter;
	} completion:^(BOOL finished) {
		[self showOption];
	}];
}

- (void) showOption {
	_optionView.hidden = NO;
	self.contentView.hidden = YES;
	
	CGRect frame = self.frame;
	frame.origin.x = 0;
	self.frame = frame;
	
	_optionView.center = CGPointMake(
			_optionView.frame.size.width * 0.5,
			_optionView.center.y);
}

- (void) createOptionView {
	if (!_optionView) {
		static NSString *CellIdentifier = @"TimetableOptionCell";
		_optionView = [(UITableView*) self.superview dequeueReusableCellWithIdentifier:CellIdentifier];
		_optionView.center = CGPointMake(_optionView.center.x + _optionView.frame.size.width, _optionView.center.y);
		[self addSubview:_optionView];
	}
}

- (void) removeOptionView {
	// TODO wieder in die queue legen oder oben initialisieren statt reusen?
	[_optionView removeFromSuperview];
	_optionView = nil;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	if (_optionView) {
		return YES;
	}
	
	CGFloat x = [gestureRecognizer locationInView:self].x;
	return (x > 40 && x < 100) || x > (320 - 100);
}

@end
