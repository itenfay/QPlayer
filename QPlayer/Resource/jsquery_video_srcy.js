//
//  jsquery_video_srcy.js
//
//  Created by Tenfay on 2025/11/25.
//  Copyright © 2023 Tenfay. All rights reserved.
//

/**
 * DeepSeek
 * 优化版网页视频解析脚本
 * 增强视频检测能力，支持更多视频平台和嵌入方式
 */
function parseWebVideos() {
    const videoSources = new Set();
    const videoElements = [];
    
    console.log('开始解析网页视频...');
    
    // 工具函数：检查URL是否是视频文件
    function isVideoFile(url) {
        if (!url || typeof url !== 'string') return false;
        
        const videoExtensions = [
            '.mp4', '.webm', '.ogg', '.mov', '.avi', '.wmv', '.flv', '.mkv',
            '.m4v', '.3gp', '.mpeg', '.mpg', '.ts', '.m3u8'
        ];
        
        const videoPatterns = [
            /\.mp4(\?|$)/i,
            /\.webm(\?|$)/i,
            /\.mov(\?|$)/i,
            /\.m3u8(\?|$)/i,
            /\/video\//i,
            /\/videos?\//i,
            /blob:/i,
            /video|stream|live|m3u8|mp4|flv/i
        ];
        
        const urlLower = url.toLowerCase();
        
        // 检查文件扩展名
        const hasExtension = videoExtensions.some(ext => urlLower.includes(ext));
        if (hasExtension) return true;
        
        // 检查视频相关模式
        const hasVideoPattern = videoPatterns.some(pattern => pattern.test(urlLower));
        if (hasVideoPattern) return true;
        
        return false;
    }
    
    // 工具函数：从视频元素提取所有可能的源
    function extractVideoSources(videoElement) {
        const sources = new Set();
        
        // 主要src属性
        if (videoElement.src) {
            sources.add(videoElement.src);
        }
        
        // currentSrc属性（当前实际播放的源）
        if (videoElement.currentSrc && videoElement.currentSrc !== videoElement.src) {
            sources.add(videoElement.currentSrc);
        }
        
        // 查找<source>子元素
        const sourceElements = videoElement.querySelectorAll('source');
        sourceElements.forEach(source => {
            if (source.src) {
                sources.add(source.src);
            }
        });
        
        // 检查dataset中的视频信息
        if (videoElement.dataset) {
            for (let key in videoElement.dataset) {
                const value = videoElement.dataset[key];
                if (typeof value === 'string' && isVideoFile(value)) {
                    sources.add(value);
                }
            }
        }
        
        return Array.from(sources);
    }
    
    // 1. 增强的主文档视频查找
    function findMainDocumentVideos() {
        console.log('查找主文档中的视频元素...');
        
        // 多种选择器查找video元素
        const selectors = [
            'video',
            'div[data-video]',
            'div[class*="video"]',
            'video source',
            'div video',
            'video[src]',
            'div[data-src] video'
        ];
        
        selectors.forEach(selector => {
            try {
                const elements = document.querySelectorAll(selector);
                console.log(`选择器 "${selector}" 找到 ${elements.length} 个元素`);
                
                elements.forEach(element => {
                    if (element.tagName.toLowerCase() === 'video') {
                        videoElements.push(element);
                        const sources = extractVideoSources(element);
                        sources.forEach(src => {
                            if (isVideoFile(src)) {
                                videoSources.add(src);
                                console.log('找到视频源:', src);
                            }
                        });
                    } else if (element.tagName.toLowerCase() === 'source') {
                        if (element.src && isVideoFile(element.src)) {
                            videoSources.add(element.src);
                            console.log('找到source视频源:', element.src);
                        }
                    } else {
                        // 检查元素的data属性
                        const dataSrc = element.getAttribute('data-src') ||
                        element.getAttribute('data-video') ||
                        element.getAttribute('data-url');
                        if (dataSrc && isVideoFile(dataSrc)) {
                            videoSources.add(dataSrc);
                            console.log('找到data属性视频源:', dataSrc);
                        }
                    }
                });
            } catch (e) {
                console.warn(`选择器 ${selector} 执行错误:`, e);
            }
        });
        
        // 额外检查：通过getElementsByTagName
        try {
            const videosByTag = document.getElementsByTagName('video');
            console.log(`getElementsByTagName找到 ${videosByTag.length} 个video元素`);
            
            Array.from(videosByTag).forEach(video => {
                if (!videoElements.includes(video)) {
                    const sources = extractVideoSources(video);
                    sources.forEach(src => {
                        if (isVideoFile(src)) {
                            videoSources.add(src);
                            console.log('找到视频源(getElementsByTagName):', src);
                        }
                    });
                }
            });
        } catch (e) {
            console.warn('getElementsByTagName错误:', e);
        }
    }
    
    // 2. 增强的iframe视频查找
    function findIframeVideos() {
        console.log('查找iframe中的视频...');
        
        const iframes = document.querySelectorAll('iframe');
        console.log(`找到 ${iframes.length} 个iframe`);
        
        iframes.forEach((iframe, index) => {
            console.log(`检查iframe ${index + 1}:`, iframe.src);
            
            try {
                // 首先检查iframe的src是否包含视频
                if (iframe.src && isVideoFile(iframe.src)) {
                    videoSources.add(iframe.src);
                    console.log('iframe src是视频:', iframe.src);
                }
                
                // 尝试访问iframe内容
                if (iframe.contentDocument) {
                    const iframeVideos = iframe.contentDocument.querySelectorAll('video');
                    console.log(`iframe ${index + 1} 中找到 ${iframeVideos.length} 个视频`);
                    
                    iframeVideos.forEach(video => {
                        const sources = extractVideoSources(video);
                        sources.forEach(src => {
                            if (isVideoFile(src)) {
                                videoSources.add(src);
                                console.log('找到iframe内视频源:', src);
                            }
                        });
                    });
                } else {
                    console.log(`iframe ${index + 1} 无法访问内容 (可能跨域)`);
                }
            } catch (e) {
                console.warn(`访问iframe ${index + 1} 时出错:`, e);
            }
        });
    }
    
    // 3. 查找隐藏的视频URL
    function findHiddenVideoUrls() {
        console.log('查找隐藏的视频URL...');
        
        // 检查script标签中的视频URL
        const scripts = document.querySelectorAll('script');
        const videoRegex = /(https?:[^"'\s]*\.(mp4|webm|ogg|mov|avi|wmv|flv|mkv|m3u8))[^"'\s]*/gi;
        
        scripts.forEach((script, index) => {
            const content = script.innerHTML || script.textContent || '';
            const matches = content.match(videoRegex);
            if (matches) {
                matches.forEach(url => {
                    if (isVideoFile(url)) {
                        videoSources.add(url);
                        console.log('在script中找到视频URL:', url);
                    }
                });
            }
        });
        
        // 检查JSON数据中的视频URL
        const jsonRegex = /"src":\s*"([^"]*\.(mp4|webm|ogg|mov|avi|wmv|flv|mkv|m3u8)[^"]*)"/gi;
        scripts.forEach(script => {
            const content = script.innerHTML || script.textContent || '';
            let match;
            while ((match = jsonRegex.exec(content)) !== null) {
                const url = match[1];
                if (url && isVideoFile(url)) {
                    videoSources.add(url);
                    console.log('在JSON数据中找到视频URL:', url);
                }
            }
        });
    }
    
    // 4. 检查媒体资源
    function checkMediaResources() {
        console.log('检查媒体资源...');
        
        // 检查link标签（可能是视频资源）
        const links = document.querySelectorAll('link[rel="preload"], link[as="video"]');
        links.forEach(link => {
            const href = link.href;
            if (href && isVideoFile(href)) {
                videoSources.add(href);
                console.log('在link标签中找到视频:', href);
            }
        });
        
        // 检查object和embed标签
        const objects = document.querySelectorAll('object, embed');
        objects.forEach(obj => {
            const src = obj.src || obj.data;
            if (src && isVideoFile(src)) {
                videoSources.add(src);
                console.log('在object/embed中找到视频:', src);
            }
        });
    }
    
    // 执行所有查找方法
    try {
        findMainDocumentVideos();
        findIframeVideos();
        findHiddenVideoUrls();
        checkMediaResources();
    } catch (error) {
        console.error('解析视频时发生错误:', error);
    }
    
    // 最终结果
    const results = Array.from(videoSources).filter(url => url && url.trim() !== '');
    console.log(`视频解析完成！共找到 ${results.length} 个视频源:`, results);
    
    return results;
}

// 提供多种调用方式
//window.parseWebVideos = parseWebVideos;

// 自动执行（可选）
// setTimeout(() => {
//     const videos = parseWebVideos();
//     if (videos.length === 0) {
//         console.warn('未找到任何视频源，可能的原因：');
//         console.warn('1. 页面使用动态加载');
//         console.warn('2. 视频在Shadow DOM中');
//         console.warn('3. 使用特殊的视频播放器');
//         console.warn('4. 需要用户交互后才能加载视频');
//     }
// }, 1000);

(function () {
    const videos = parseWebVideos();
    return videos;
})();
