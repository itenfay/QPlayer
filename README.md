[If you think it can help you, please give it a star. Thanks!](https://github.com/dgynfi/QPlayer)


## QPlayer

&emsp; `QPlayer` is a powerful video player that you can't miss, supports `m4v, wmv, 3gp, mp4, mov, avi, mkv, mpeg, mpg, flv, rm, rmvb, mp3` format. Enter any `HTTP, RTSP, RTMP, HLS` address play network streaming or live. QPlayer use ffmpeg，you can transfer files via wifi. It aggregates several live, video and short video platforms, and you can watch live, video and short video online. (`QPlayer` 是一款你不容错过的强大的视频播放器，支持 `M4V、WMV、MP4、MOV、AVI、MKV、MPEG、MPG、FLV、RM、RMVB、MP3` 等主流媒体格式。输入任何 `HTTP、RTMP、RTSP、HLS` 地址播放网络流或直播。`QPlayer` 使用 `ffmpeg`，支持 `WiFi` 文件传输。聚合了多个直播、视频和短视频平台，可在线观看直播、视频和短视频。)

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE)&nbsp;


## Usage

&emsp; 在 `App` 设置中打开 `WiFi` 文件传输的开关，即可享用 WiFi 文件传输服务。在电脑浏览器中访问：如 “[http://192.168.6.6:8888](http://192.168.6.6:8888)” ，打开网页后，选择文件，点击 `Upload` 上传。在上传媒体文件时，确保电脑和手机在同一 `WiFi` 环境并且不要关闭本应用也不要锁屏。


## Group (ID:15535338)

<div align=center>
&emsp; <img src="https://github.com/dgynfi/QPlayer/raw/master/images/qq155353383.jpg" width="26%" />
</div>


## Preview

- Local videos

<div align=center>
<img src="https://github.com/dgynfi/QPlayer/raw/master/images/local_video.png" width="80%" />
</div>

- TV and radio

<div align=center>
<img src="https://github.com/dgynfi/QPlayer/raw/master/images/tv_radio.png" width="80%" />
</div>

- Lives 

<div align=center>
<img src="https://github.com/dgynfi/QPlayer/raw/master/images/mainstream_live.png" width="80%" />
</div>

- Web videos

<div align=center>
<img src="https://github.com/dgynfi/QPlayer/raw/master/images/web_video.png" width="80%" />
</div>

- App introduce

<div align=center>
<img src="https://github.com/dgynfi/QPlayer/raw/master/images/app_intro.png" width="80%" />
</div>
 
 
## Requirements

&emsp; iOS 8.0+, iPhone and iPad, Xcode10+.


## Open Source Components

- [AFNetworking](https://github.com/AFNetworking/AFNetworking)

&emsp; A delightful networking framework for iOS, macOS, watchOS, and tvOS. 

- [SDWebImage](https://github.com/SDWebImage/SDWebImage)

&emsp; This library provides an async image downloader with cache support. For convenience, we added categories for UI elements like UIImageView, UIButton, MKAnnotationView.

- [ijkplayer](https://github.com/bilibili/ijkplayer) 

&emsp; Android/iOS video player based on FFmpeg n3.4, with MediaCodec, VideoToolbox support. 

&emsp; [IJKMediaFramework.framework Download](https://pan.baidu.com/s/1WCZzdCUiaQL3a1yJSD22QQ) - 链接: https://pan.baidu.com/s/1WCZzdCUiaQL3a1yJSD22QQ 提取码: mxqq

- [MBProgressHUD](https://github.com/jdg/MBProgressHUD)

&emsp; MBProgressHUD is an iOS drop-in class that displays a translucent HUD with an indicator and/or labels while work is being done in a background thread. The HUD is meant as a replacement for the undocumented, private UIKit UIProgressHUD with some additional features.

- [MJRefresh](https://github.com/CoderMJLee/MJRefresh)

&emsp; An easy way to use pull-to-refresh.

- [FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture) 

&emsp; A UINavigationController's category to enable fullscreen pop gesture with iOS7+ system style.

- [PYSearch](https://github.com/ko1o/PYSearch)

&emsp; 🔍 An elegant search controller which replaces the UISearchController for iOS (iPhone & iPad) .

- [CocoaWebResource](https://github.com/robin/cocoa-web-resource)

&emsp; A file transfer solution for iPhone and iPod Touch. Support uploading, download and delete files via browser.

- [ZFPlayer](https://github.com/renzifeng/ZFPlayer) 

&emsp; Support customization of any player SDK and control layer(支持定制任何播放器SDK和控制层)

- [KSYMediaPlayer_iOS](ttps://github.com/ksvc/KSYMediaPlayer_iOS)

&emsp; 金山云iOS播放SDK（KSYUN Live Streaming player SDK），支持RTMP HTTP-FLV HLS 协议（supporting RTMP HTTP-FLV HLS protocol）。与系统播放器MPMoviePlayerController接口一致，可以无缝快速切换至KSYMediaPlayer；本地全媒体格式支持, 并对主流的媒体格式(mp4, avi, wmv, flv, mkv, mov, rmvb 等 )进行优化；支持广泛的流式视频格式, HLS, RTMP, HTTP Rseudo-Streaming 等；低延时直播体验，配合金山云推流sdk，可以达到全程直播稳定的4秒内延时；实现快速满屏播放，为用户带来更快捷优质的播放体验；支持画面旋转，音量调节等各种功能。

- [SVBlurView](https://github.com/TransitApp/SVBlurView)

&emsp; SVBlurView is a simple reimplementation of FXBlurView for iOS 7. It uses Apple's UIImage+ImageEffects category as well as the new drawViewHierarchyInRect: UIView API. It doesn't do dynamic blurs yet.

- [MBProgressHUD-JDragon](https://github.com/lyc59621/MBProgressHUD-JDragon)

&emsp; 封装MBProgressHUD的一个类别。


## Pods for QPlayer

```
# Pods for QPlayer
pod 'AFNetworking'
pod 'SDWebImage'
pod 'MJRefresh', '~> 3.1.12'

pod 'ZFPlayer'
pod 'ZFPlayer/ControlView'
pod 'ZFPlayer/AVPlayer'
#pod 'KSYMediaPlayer_iOS/KSYMediaPlayer_vod' # Conflicts with ijkplayer.

pod 'MBProgressHUD+JDragon', '~> 0.0.3'
pod 'PYSearch', '~> 0.8.8'
pod 'SVBlurView', '~> 0.0.1'
pod 'FDFullscreenPopGesture', '~> 1.1'
```


## JianShu

- [QPlayer一款你不容错过的视频播放器](https://www.jianshu.com/p/df5af1d079d6)

