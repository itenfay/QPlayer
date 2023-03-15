//
//  jsquery_video_src.js
//  QPlayer
//
//  Created by chenxing on 2023/3/9.
//  Copyright © 2023 chenxing. All rights reserved.
//

// 查询最后一个iframe
function queryLastIFrame() {
    var iframes = document.querySelectorAll('iframe');
    var frame = null;
    for (var i = 0; i < iframes.length; i++) {
        frame = iframes[i];
    }
    return frame;
}

// 查询最后一个视频标签
function queryLastVideo() {
    var videos = document.querySelectorAll('video');
    var video = null;
    for (var i = 0; i < videos.length; i++) {
        video = videos[i];
    }
    return video;
}

// 查询视频的url播放地址
function queryVideoSrc() {
    // src: 既可以设置又可以返回视频地址
    // currentSrc: 只能返回视频地址，不能设置，并且要等到视频加载好了并且可以播放时才能获取到
    var frame = queryLastIFrame();
    if (frame != null) {
        var video = frame.contentWindow.document.documentElement.getElementsByTagName('video')[0];
        if (video != null) {
            video.pause();
            console.log(":: src=" + video.src);
            return video.src;
        }
    }
    
    var video2 = queryLastVideo();
    if (video2 != null) {
        video2.pause();
        console.log(":: src2=" + video2.src);
        return video2.src;
    }
    
    var video3 = document.getElementsByTagName('video');
    if (video3 != null) {
        video3.pause();
        console.log(":: src3=" + video3.src);
        return video3.src;
    }
    
    var video4 = document.querySelector('video');
    if (video4 != null) {
        video4.pause();
        console.log(":: src4=" + video4.src);
        return video4.src;
    }
    
    var frame2 = document.querySelector('iframe');
    if (frame2 != null) {
        var video5 = frame2.contentWindow.document.documentElement.getElementsByTagName('video')[0];
        if (video5 != null) {
            video5.pause();
            console.log(":: src5=" + video5.src);
            return video5.src;
        }
    }
    
    return null;
}
