//
//  ZXPushControlView.m
//  ZXLivePlayer
//
//  Created by zhaoxin on 2018/3/29.
//  Copyright © 2018年 zhaoxin. All rights reserved.
//

#import "ZXPushControlView.h"
#import "ZXMediaPlayer.h"
#import "ZXBeautySettingPanel.h"

@interface ZXPushControlView()<BeautySettingPanelDelegate,BeautyLoadPituDelegate>
@property (strong, nonatomic) UIButton *backButton;//返回
@property (strong, nonatomic) UIButton *cameraButton;//照相机

@property (strong, nonatomic) UILabel *titleLab;//标题

@property (strong, nonatomic) UIButton *beautyButton;//美颜按钮
@property (strong, nonatomic) ZXBeautySettingPanel *beautySettingPanel;//美颜设置界面

@property (strong, nonatomic) UIButton *publishButton;
@property (strong, nonatomic) UIButton *directionButton;//推流方向
@property (strong, nonatomic) UIButton *settingButton;//设置

@end

@implementation ZXPushControlView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.backButton];
        [self addSubview:self.cameraButton];
        [self addSubview:self.beautyButton];
        [self addSubview:self.beautySettingPanel];

        [self addSubview:self.publishButton];
        [self addSubview:self.titleLab];
        [self addSubview:self.directionButton];
        [self addSubview:self.settingButton];
        
        //设置控件约束
        [self makeSubViewsConstraints];
    }
    return self;
}

//设置控件约束
-(void)makeSubViewsConstraints{
    CGFloat buttonWH = 40;
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(10);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backButton);
        make.leading.equalTo(self.backButton.mas_trailing).offset(5);
        make.trailing.equalTo(self);
        make.height.mas_equalTo(buttonWH);
    }];
    
    [self.publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.width.height.mas_equalTo(buttonWH);
    }];
    
    [self.cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.publishButton);
        make.leading.equalTo(self.publishButton.mas_trailing).offset(5);
        make.width.height.mas_equalTo(buttonWH);
    }];
    
    [self.beautyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.publishButton);
        make.leading.equalTo(self.cameraButton.mas_trailing).offset(5);
        make.width.height.mas_equalTo(buttonWH);
    }];
    
    NSUInteger controlHeight = [ZXBeautySettingPanel getHeight];
    [self.beautySettingPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.bottom.equalTo(self.publishButton.mas_top).offset(-3);
        make.width.mas_equalTo(kMediaPlayerScreenWidth);
        make.height.mas_equalTo(controlHeight);
    }];
    
    [self.directionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.publishButton);
        make.leading.equalTo(self.beautyButton.mas_trailing).offset(5);
        make.width.height.mas_equalTo(buttonWH);
    }];
    
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.publishButton);
        make.leading.equalTo(self.directionButton.mas_trailing).offset(5);
        make.width.height.mas_equalTo(buttonWH);
    }];
}

-(void)setPublishButtonState:(BOOL)selected{
    if (selected) {
        [self.publishButton setImage:[UIImage imageNamed:@"MediaPlayer_pause"] forState:UIControlStateSelected];
    }else{
        [self.publishButton setImage:[UIImage imageNamed:@"MediaPlayer_play"] forState:UIControlStateNormal];
    }
}

#pragma -mark - 控件点击事件
-(void)backBtnClick:(UIButton*)button{
    if ([self.delegate respondsToSelector:@selector(backAction)]) {
        [self.delegate backAction];
    }
}

-(void)clickPublishButton:(UIButton*)button{
    if ([self.delegate respondsToSelector:@selector(publishAction:)]) {

        [self.delegate publishAction:button.selected];
        button.selected = !button.selected;

    }
}

-(void)clickCameraButton:(UIButton*)button{
    if ([self.delegate respondsToSelector:@selector(switchCamera:)]) {
        [self.delegate switchCamera:button.selected];
        
        button.selected = !button.selected;
    }
}

-(void)clickBeautyButton:(UIButton*)button{
    self.beautySettingPanel.hidden = !button.selected;
    
    button.selected = !button.selected;

}

-(void)clickDirectionButton:(UIButton*)button{
    if ([self.delegate respondsToSelector:@selector(directionAction:)]) {
        [self.delegate directionAction:button.selected];
        
        button.selected = !button.selected;
    }
}

-(void)clickSettingButton:(UIButton*)button{
    button.selected = !button.selected;
    
    if ([self.delegate respondsToSelector:@selector(settingAction:)]) {
        [self.delegate settingAction:button.selected];
    }
}

#pragma -mark - BeautySettingPanelDelegate
- (void)onSetBeautyStyle:(int)beautyStyle beautyLevel:(float)beautyLevel whitenessLevel:(float)whitenessLevel ruddinessLevel:(float)ruddinessLevel{
    if ([self.delegate respondsToSelector:@selector(onSetBeautyStyle:beautyLevel:whitenessLevel:ruddinessLevel:)]) {
        [self.delegate onSetBeautyStyle:beautyStyle beautyLevel:beautyLevel whitenessLevel:whitenessLevel ruddinessLevel:ruddinessLevel];
    }
}

- (void)onSetEyeScaleLevel:(float)eyeScaleLevel {
    if ([self.delegate respondsToSelector:@selector(onSetEyeScaleLevel:)]) {
        [self.delegate onSetEyeScaleLevel:eyeScaleLevel];
    }
}

- (void)onSetFaceScaleLevel:(float)faceScaleLevel {
    if ([self.delegate respondsToSelector:@selector(onSetFaceScaleLevel:)]) {
        [self.delegate onSetFaceScaleLevel:faceScaleLevel];
    }
}

- (void)onSetFilter:(UIImage *)filterImage {
    if ([self.delegate respondsToSelector:@selector(onSetFilter:)]) {
        [self.delegate onSetFilter:filterImage];
    }
}


- (void)onSetGreenScreenFile:(NSURL *)file {
    if ([self.delegate respondsToSelector:@selector(onSetGreenScreenFile:)]) {
        [self.delegate onSetGreenScreenFile:file];
    }
}

- (void)onSelectMotionTmpl:(NSString *)tmplName inDir:(NSString *)tmplDir {
    if ([self.delegate respondsToSelector:@selector(onSelectMotionTmpl:inDir:)]) {
        [self.delegate onSelectMotionTmpl:tmplName inDir:tmplDir];
    }
}

- (void)onSetFaceVLevel:(float)vLevel{
    if ([self.delegate respondsToSelector:@selector(onSetFaceVLevel:)]) {
        [self.delegate onSetFaceVLevel:vLevel];
    }
}

- (void)onSetFaceShortLevel:(float)shortLevel{
    if ([self.delegate respondsToSelector:@selector(onSetFaceShortLevel:)]) {
        [self.delegate onSetFaceShortLevel:shortLevel];
    }
}

- (void)onSetNoseSlimLevel:(float)slimLevel{
    if ([self.delegate respondsToSelector:@selector(onSetNoseSlimLevel:)]) {
        [self.delegate onSetNoseSlimLevel:slimLevel];
    }
}

- (void)onSetChinLevel:(float)chinLevel{
    if ([self.delegate respondsToSelector:@selector(onSetChinLevel:)]) {
        [self.delegate onSetChinLevel:chinLevel];
    }
}

- (void)onSetMixLevel:(float)mixLevel{
    if ([self.delegate respondsToSelector:@selector(onSetMixLevel:)]) {
        [self.delegate onSetMixLevel:mixLevel];
    }
}

#pragma -mark - 懒加载控件
-(UIButton *)backButton{
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:MediaPlayerImage(@"MediaPlayer_back_full") forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
-(UIButton*)cameraButton{
    if (_cameraButton == nil) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        [_cameraButton setImage:[UIImage imageNamed:@"camera2"] forState:UIControlStateSelected];
        
        [_cameraButton addTarget:self action:@selector(clickCameraButton:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _cameraButton;
}
-(UIButton*)publishButton{
    if (_publishButton == nil) {
        _publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_publishButton setImage:MediaPlayerImage(@"MediaPlayer_play") forState:UIControlStateNormal];
        [_publishButton setImage:MediaPlayerImage(@"MediaPlayer_pause") forState:UIControlStateSelected];
        [_publishButton addTarget:self action:@selector(clickPublishButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishButton;
}

-(UILabel*)titleLab{
    if (_titleLab == nil) {
        _titleLab = [UILabel new];
        _titleLab.text = @"测试标题";
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.font = [UIFont systemFontOfSize:15];
    }
    return _titleLab;
}

-(UIButton *)beautyButton{
    if (_beautyButton == nil) {
        _beautyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_beautyButton setImage:[UIImage imageNamed:@"beauty"] forState:UIControlStateNormal];
        [_beautyButton setImage:[UIImage imageNamed:@"beauty_dis"] forState:UIControlStateSelected];
        [_beautyButton addTarget:self action:@selector(clickBeautyButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beautyButton;
}

-(ZXBeautySettingPanel*)beautySettingPanel{
    if (_beautySettingPanel == nil) {
        NSUInteger controlHeight = [ZXBeautySettingPanel getHeight];
        _beautySettingPanel = [[ZXBeautySettingPanel alloc] initWithFrame:CGRectMake(0, kMediaPlayerScreenHeight - controlHeight - 40, kMediaPlayerScreenWidth, controlHeight)];
        _beautySettingPanel.delegate = self;
        _beautySettingPanel.pituDelegate = self;
    }
    return _beautySettingPanel;
}

-(UIButton*)directionButton{
    if (_directionButton == nil) {
        _directionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_directionButton setImage:[UIImage imageNamed:@"landscape"] forState:UIControlStateNormal];
        [_directionButton setImage:[UIImage imageNamed:@"portrait"] forState:UIControlStateSelected];
        [_directionButton addTarget:self action:@selector(clickDirectionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _directionButton;
}

-(UIButton*)settingButton{
    if (_settingButton == nil) {
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingButton setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
        [_settingButton addTarget:self action:@selector(clickSettingButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingButton;
}

@end
