//
//  PlayModel.m
//  ChuangRtcDemo
//
//  Created by wzh on 2021/5/18.
//

#import "PlayModel.h"
#import "CYPublishTopicConfigManager.h"

@implementation PlayModel
- (void)setAudioMute:(BOOL)audioMute {
    _audioMute = audioMute;
    
    self.playView.muteAudioButton.selected = audioMute;
}

- (void)setVideoMute:(BOOL)videoMute {
    _videoMute = videoMute;
    self.playView.muteVideoButton.selected = videoMute;
}

- (void)setQuality:(ChuangPlayStreamQuality *)quality {
    _quality = quality;
    NSMutableString *muStr = [[NSMutableString alloc] initWithString:@""];
    if (self.isShowVideoDetail) {
        if ([[CYPublishTopicConfigManager sharedInstance] audioOnlyState]) {
            quality.videoFps = 0;
        }
        NSString *qualityStr = [NSString stringWithFormat:@"bitrate：%d\nvideofps：%d\naudiofps: %d\nlost:%.2f\ndelay：%d\n",quality.videoBitrateKbps,quality.videoFps,0, quality.publisherLPacketLostRate, quality.publisherRtt];
       // self.playView.qualityLabel.text = qualityStr;
        [muStr appendString:qualityStr];
        
        if (self.isOpenSoundLevel) {
            NSString *volumeStr = [NSString stringWithFormat:@"volume: %d\n",self.soundLevel];
            [muStr appendString:volumeStr];
        }
        if (self.playView.showBig) {
            if (self.isOpenSpeedtest) {
                NSString *speedStr = [NSString stringWithFormat:@"network: %d",self.networkSpeedtest];
                [muStr appendString:speedStr];
            }
        }
    }
    
    self.playView.qualityLabel.text = muStr;
}

- (void)setShowVideoDetail:(BOOL)showVideoDetail {
    _showVideoDetail = showVideoDetail;
    
   // self.playView.qualityLabel.hidden = !showVideoDetail;
}

- (void)setSoundLevel:(int)soundLevel {
    _soundLevel = soundLevel;
   // self.playView.soundLevelLabel.text = [NSString stringWithFormat:@"音量：%d",soundLevel];
}
@end
