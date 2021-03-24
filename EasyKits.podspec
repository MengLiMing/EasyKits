#
# Be sure to run `pod lib lint EasyKits.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'EasyKits'
    s.version          = '0.1.2'
    s.summary          = '使用简单的工具集合'
    
    s.description      = <<-DESC
    开源日常开发中常用的简单工具，目标-使用简单，后续不断完善
    DESC
    
    s.homepage         = 'https://github.com/MengLiMing/EasyKits'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'MengLiMing' => '920459250@qq.com' }
    s.source           = { :git => 'https://github.com/MengLiMing/EasyKits.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '9.0'
    s.swift_version = '5.0'
    
    # 一行代码实现弹窗逻辑
    s.subspec "EasyPopup" do |ss|
        ss.dependency 'SnapKit', '~> 4.2.0'
        
        ss.source_files = 'EasyKits/EasyPopup/*.swift'
    end
    
    # 简单的事件传递，解决某些情况下多重嵌套代理，莫种意义上也降低了耦合性
    s.subspec "EasyResponder" do |ss|
        ss.source_files = 'EasyKits/EasyResponder/*.swift'
    end
    
    # 处理复杂列表 - 电商类首页/商品详情/朋友圈等
    s.subspec "EasyListView" do |ss|
        ss.source_files = 'EasyKits/EasyListView/**/*'
    end
    
    # 处理首页嵌套 - 简书个人中心/电商类首页等
    s.subspec "EasySyncScroll" do |ss|
        ss.dependency 'RxSwift'
        ss.dependency 'RxCocoa'
        
        ss.source_files = 'EasyKits/EasySyncScroll/*.swift'
        
        ss.frameworks = 'WebKit'
    end
    
    # 轮播 - 支持左右 上下轮播
    s.subspec "EasyCarouseView" do |ss|
        ss.source_files = 'EasyKits/EasyCarouseView/*.swift'
    end
    
    # 分段选择器
    s.subspec "EasySegmentedView" do |ss|
        ss.source_files = 'EasyKits/EasySegmentedView/**/*'
    end
    
    # 页面切换
    s.subspec "EasyPagingContainerView" do |ss|
        ss.source_files = 'EasyKits/EasyPagingContainerView/*.swift'
    end
    
    # 一些日常使用的扩展
    s.subspec "EasyExtension" do |ss|
        ss.source_files = 'EasyKits/EasyExtension/*.swift'
    end
    
    
    s.frameworks = 'UIKit'
    
end
