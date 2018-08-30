//
//  MyTempView.m
//  DemoDemo
//
//  Created by fumi on 2018/8/27.
//  Copyright © 2018年 fumi. All rights reserved.
//

#import "MyTempView.h"
#import "UILabel+Utils.h"

@interface MyTempView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonContainerHeight;
@property (weak, nonatomic) IBOutlet UIView *buttonContainer;

@end

@implementation MyTempView

+ (instancetype)loadFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (void)setTitles:(NSString *)titles
{
    _titles = titles;
    self.titleLabel.text = _titles;
    NSLog(@"line number is :%zd",self.titleLabel.lineNum);
    BOOL showButtonContainer = self.titleLabel.lineNum < 2;
    self.buttonContainerHeight.constant = showButtonContainer ? 80 : 0;
    self.buttonContainer.hidden = !showButtonContainer;
    

//    [self sizeToFit];
//   CGSize rect = [self sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT)];
//    NSLog(@"%@",NSStringFromCGSize(rect));
}

//- (CGSize)sizeThatFits:(CGSize)size
//{
//    CGSize superSize = [super sizeThatFits:size];
////    return superSize;
//    CGSize oldSize = self.titleLabel.frame.size;
//    CGSize labelSize = [self.titleLabel sizeThatFits:CGSizeMake(self.titleLabel.frame.size.width, MAXFLOAT)];
//    return CGSizeMake(superSize.width, superSize.height + (labelSize.height - oldSize.height));
//}

@end
