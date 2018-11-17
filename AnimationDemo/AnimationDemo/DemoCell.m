//
//  DemoCell.m
//  AnimationDemo
//
//  Created by fumi on 2018/11/17.
//  Copyright © 2018 fumi. All rights reserved.
//

#import "DemoCell.h"
#import "AudioView.h"

@interface DemoCell()
@property (weak, nonatomic) IBOutlet UIView *audioView;

@end

@implementation DemoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self testAudioView];
}


- (void)testAudioView
{
    AudioView *audioView = [[AudioView alloc] initWithFrame:CGRectMake(0, 20, 20, 20) audioLineCount:3 color:[UIColor whiteColor] lineOffset:2];
    audioView.backgroundColor = [UIColor purpleColor];
    [self.audioView addSubview:audioView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
