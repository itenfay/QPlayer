//
//  jsquery_video_srcx.js
//
//  Created by Tenfay on 2023/3/9.
//  Copyright © 2023 Tenfay. All rights reserved.
//

(function (){ var iframes = document.querySelectorAll('iframe'); var frame; for (var i = 0; i < iframes.length; i++) { frame = iframes[i]; }; if(frame) { var videos = frame.contentWindow.document.documentElement.getElementsByTagName('video'); var video; if (videos.length > 0) { video = videos[0]; }; if (video) { video.pause(); return video.src; }; }; var videos2 = document.querySelectorAll('video'); var video2; for (var i = 0; i < videos2.length; i++) { video2 = videos2[i]; }; if (video2) { video2.pause(); return video2.src; }; var video3 = document.getElementsByTagName('video'); if (video3) { video3.pause(); return video3.src; }; var video4 = document.querySelector('video'); if(video4) { video4.pause(); return video4.src; }; var frame2 = document.querySelector('iframe'); if(frame2) { var videos5 = frame2.contentWindow.document.documentElement.getElementsByTagName('video'); var video5; if (videos5.length > 0) { video5 = videos5[0]; }; if (video5) { video5.pause(); return video5.src; }; }; return;})();

 // 查询最后一个iframe
 function queryLastIFrame() {
    try {
        var iframes = document.querySelectorAll('iframe');
        var frame = null;
        for (var i = 0; i < iframes.length; i++) {
            frame = iframes[i];
        }
        return frame;
    } catch (e) {
        console.log('无法访问iframe内容:', e);
        return [];
    }
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
            console.log("src=" + video.src);
            return video.src;
        }
    }

    var video2 = queryLastVideo();
    if (video2 != null) {
        video2.pause();
        console.log("src2=" + video2.src);
        return video2.src;
    }

    var video3 = document.getElementsByTagName('video');
    if (video3 != null) {
        video3.pause();
        console.log("src3=" + video3.src);
        return video3.src;
    }

    var video4 = document.querySelector('video');
    if (video4 != null) {
        video4.pause();
        console.log("src4=" + video4.src);
        return video4.src;
    }

    try {
        var frame2 = document.querySelector('iframe');
        if (frame2 != null) {
            var video5 = frame2.contentWindow.document.documentElement.getElementsByTagName('video')[0];
            if (video5 != null) {
                video5.pause();
                console.log("src5=" + video5.src);
                return video5.src;
            }
        }
    } catch (e) {
        console.log('无法访问iframe内容:', e);
    }

    return null;
}
