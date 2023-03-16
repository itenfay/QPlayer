platform :ios, '8.0'

#source 'https://github.com/CocoaPods/Specs.git'
#source 'https://gitee.com/mirrors/CocoaPods-Specs.git'
source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

target 'QPlayer' do
  # use_frameworks!
  
  # Pods for QPlayer
  pod 'AFNetworking'
  pod 'SDWebImage'
  pod 'MJRefresh'
  
  pod 'ZFPlayer'
  pod 'ZFPlayer/ControlView'
  pod 'ZFPlayer/AVPlayer'
  pod 'ZFPlayer/ijkplayer'
  #pod 'ZFPlayer/KSYMediaPlayer' # Conflicts with ijkplayer.
  # 用于直播的静态库
  #pod 'KSYMediaPlayer_iOS' # <=> pod 'KSYMediaPlayer_iOS/KSYMediaPlayer_live'
  # 用于点播的静态库, 点播支持更多的格式
  #pod 'KSYMediaPlayer_iOS/KSYMediaPlayer_vod'
  
  pod 'MBProgressHUD+JDragon', '~> 0.0.5'
  pod 'PYSearch'
  pod 'SVBlurView', '~> 0.0.1'
  pod 'FDFullscreenPopGesture', '~> 1.1'
  
end

post_install do |installer|
  # Cocoapods optimization, always clean project after pod updating
  Dir.glob(installer.sandbox.target_support_files_root + "Pods-*/*.sh").each do |script|
    flag_name = File.basename(script, ".sh") + "-Installation-Flag"
    folder = "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
    file = File.join(folder, flag_name)
    content = File.read(script)
    content.gsub!(/set -e/, "set -e\nKG_FILE=\"#{file}\"\nif [ -f \"$KG_FILE\" ]; then exit 0; fi\nmkdir -p \"#{folder}\"\ntouch \"$KG_FILE\"")
    File.write(script, content)
  end
  
  # Enable tracing resources
  installer.pods_project.targets.each do |target|
    if target.name == 'RxSwift'
      target.build_configurations.each do |config|
        if config.name == 'Debug'
          config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
        end
      end
    end
  end
  
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.name == 'Debug'
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      end
    end
  end
end
