#
# Be sure to run `pod lib lint EasyKits.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'EasyKits'
    s.version          = '0.6.0'
    s.summary          = '使用简单的工具集合'
    
    s.description      = <<-DESC
    开源日常开发中常用的简单工具，目标-使用简单，后续不断完善
    DESC
    
    s.homepage         = 'https://github.com/MengLiMing/EasyKits'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'MengLiMing' => '920459250@qq.com' }
    s.source           = { :git => 'https://github.com/MengLiMing/EasyKits.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '10.0'
    s.swift_version = '5.0'
    
    # 一行代码实现弹窗逻辑
    s.subspec "EasyPopup" do |ss|
        ss.dependency 'SnapKit'
        
        ss.source_files = 'Sources/EasyPopup/*.swift'
    end
    
    # 简单的事件传递，解决某些情况下多重嵌套代理，莫种意义上也降低了耦合性
    s.subspec "EasyResponder" do |ss|
        ss.source_files = 'Sources/EasyResponder/*.swift'
    end
    
    # 处理复杂列表 - 电商类首页/商品详情/朋友圈等
    s.subspec "EasyListView" do |ss|
        ss.source_files = 'Sources/EasyListView/**/*'
    end
    
    # 处理首页嵌套 - 简书个人中心/电商类首页等
    s.subspec "EasySyncScroll" do |ss|
        ss.dependency 'RxSwift'
        ss.dependency 'RxCocoa'
        
        ss.source_files = 'Sources/EasySyncScroll/*.swift'
        
        ss.frameworks = 'WebKit'
    end
    
    # 轮播 - 支持左右 上下轮播
    s.subspec "EasyCarouseView" do |ss|
        ss.dependency 'RxSwift'
        ss.dependency 'RxCocoa'
        
        ss.source_files = 'Sources/EasyCarouseView/*.swift'
    end
    
    # 分段选择器
    s.subspec "EasySegmentedView" do |ss|
        ss.source_files = 'Sources/EasySegmentedView/**/*'
    end
    
    # 页面切换
    s.subspec "EasyPagingContainerView" do |ss|
        ss.source_files = 'Sources/EasyPagingContainerView/*.swift'
    end
    
    # 一些日常使用的扩展
    s.subspec "EasyExtension" do |ss|
        ss.dependency 'RxSwift'
        ss.dependency 'RxCocoa'
        
        ss.source_files = 'Sources/EasyExtension/**/*'
    end
    
    # IGListKit+RxSwift封装
    s.subspec "EasyIGListKit" do |ss|
        ss.dependency 'RxSwift'
        ss.dependency 'RxCocoa'
        ss.dependency 'IGListKit'
        ss.dependency 'Then'
        ss.dependency 'SnapKit'
        ss.dependency 'EasyKits/EasyResponder'
        ss.dependency 'EasyKits/EasyExtension'
        ss.dependency 'EasyKits/EasySyncScroll'

        ss.source_files = 'Sources/EasyIGListKit/**/*'
    end
    
    # 路由
    s.subspec 'EasyMediator' do |ss|
        ss.dependency 'EasyKits/EasyExtension'
        
        ss.source_files = 'Sources/EasyMediator/**/*'
    end
    
    # 设备权限简单封装
    s.subspec 'EasyPermission' do |ss|
        ss.subspec 'Core' do |core|
            core.source_files = 'Sources/EasyPermission/Core/*.swift'
        end
        
        ss.subspec 'EasyCamera' do |ec|
            ec.source_files = 'Sources/EasyPermission/EasyCamera/*.swift'
            ec.dependency 'EasyKits/EasyPermission/Core'
            ec.pod_target_xcconfig = {
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS" => "PERMISSION_EASYCAMERA"
            }
        end
        
        ss.subspec 'EasyLocation' do |el|
            el.source_files = 'Sources/EasyPermission/EasyLocation/*.swift'
            el.dependency 'EasyKits/EasyPermission/Core'
            el.pod_target_xcconfig = {
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS" => "PERMISSION_EASYLOCATION"
            }
        end
        
        ss.subspec 'EasyMicrophone' do |em|
            em.source_files = 'Sources/EasyPermission/EasyMicrophone/*.swift'
            em.dependency 'EasyKits/EasyPermission/Core'
            em.pod_target_xcconfig = {
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS" => "PERMISSION_EASYMICROPHONE"
            }
        end
        
        ss.subspec 'EasyNotification' do |en|
            en.source_files = 'Sources/EasyPermission/EasyNotification/*.swift'
            en.dependency 'EasyKits/EasyPermission/Core'
            en.pod_target_xcconfig = {
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS" => "PERMISSION_EASYNOTIFICATION"
            }
        end
        
        ss.subspec 'EasyPhoto' do |ep|
            ep.dependency 'EasyKits/EasyPermission/Core'
            ep.source_files = 'Sources/EasyPermission/EasyPhoto/*.swift'
            ep.pod_target_xcconfig = {
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS" => "PERMISSION_EASYPHOTO"
            }
        end
        
        ss.subspec 'EasyPermissionRx' do |rx|
            rx.dependency 'RxSwift'
            rx.dependency 'RxCocoa'
            rx.dependency 'EasyKits/EasyPermission/Core'
            rx.source_files = 'Sources/EasyPermission/Rx/*.swift'
        end
    end
    
    s.frameworks = 'UIKit'
    
end
