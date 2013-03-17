//
//  TimetableCell.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "TimetableCell.h"

@implementation TimetableCell {
	UITableView* _optionView;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		UIPanGestureRecognizer* panGestures = [[UIPanGestureRecognizer alloc] init];
		panGestures.delegate = self;
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
	
	NSLog(@"cell: %@  contentView: %@", self, self.contentView);
	
	UIGestureRecognizerState state = gestureRecognizer.state;
	
	// HANDLE OPTION VIEW
	if (state == UIGestureRecognizerStateBegan) {
		
		static NSString *CellIdentifier = @"TimetableCellOption";
		_optionView = [(UITableView*) self.superview dequeueReusableCellWithIdentifier:CellIdentifier];
		_optionView.backgroundColor = [UIColor redColor];
		_optionView.center = CGPointMake(
										 _optionView.frame.size.width / 2 + self.frame.size.width,
										 _optionView.center.y);
		
		[self addSubview:_optionView];
		
	} else if (state == UIGestureRecognizerStateCancelled ||
			   state == UIGestureRecognizerStateEnded ||
			   state == UIGestureRecognizerStateFailed) {
		
		// TODO wieder in die queue legen oder oben initialisieren statt reusen?
		[_optionView removeFromSuperview];
		_optionView = nil;
		
	}
	
	// HANDLE PAN
	CGPoint translation = [gestureRecognizer translationInView:self];
	CGPoint velocity = [gestureRecognizer velocityInView:self];
	
	if (state == UIGestureRecognizerStateChanged) {
		
		self.center = CGPointMake(
				self.center.x + translation.x,
				self.center.y);
		
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
	return [gestureRecognizer locationInView:self].x > 40;
	//return YES;
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
