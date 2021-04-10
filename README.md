# EasyKits

[![CI Status](https://img.shields.io/travis/MengLiMing/EasyKits.svg?style=flat)](https://travis-ci.org/MengLiMing/EasyKits)
[![Version](https://img.shields.io/cocoapods/v/EasyKits.svg?style=flat)](https://cocoapods.org/pods/EasyKits)
[![License](https://img.shields.io/cocoapods/l/EasyKits.svg?style=flat)](https://cocoapods.org/pods/EasyKits)
[![Platform](https://img.shields.io/cocoapods/p/EasyKits.svg?style=flat)](https://cocoapods.org/pods/EasyKits)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

EasyKits is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:
```ruby
pod 'EasyKits'
```

如果你不想整体使用，选择想要添加的功能添加进你的Podfile:
```ruby
pod 'EasyKits/EasySegmentedView'
pod 'EasyKits/EasyPagingContainerView'

pod 'EasyKits/EasyPopup'
pod 'EasyKits/EasyResponder'
pod 'EasyKits/EasyListView'
pod 'EasyKits/EasySyncScroll'
pod 'EasyKits/EasyCarouseView'
pod 'EasyKits/EasyExtension'
pod 'EasyKits/EasyRxExtension'
```


## 组件列表
- EasyListView: 复杂列表的简单实现，可用于快速构建电商类首页、商品详情、朋友圈等复杂列表
- EasyResponder：简单的事件传递策略，方便图层嵌套多层时的事件传递
- EasyPopup: 协议实现简单弹窗
- EasySyncScroll：快速实现UIScrollView嵌套，实现类似简书个人信息页面效果，低耦合 易使用
- EasyCarouseView：轮播视图，支持横竖两个方向、自定义视图
- EasySegmentedView：分类导航栏实现，可自定义任何样式的导航栏效果(指示器和Item均可自定义)
- EasyPagingContainerView：横向滑动切换实现，支持最大显示个数

## DEMO演示
|EasySyncScroll|EasyCarouseView|
|:---:|:---:|
|![](https://raw.githubusercontent.com/MengLiMing/EasyKits/master/demo_gif/syncScroll.gif)|![](https://raw.githubusercontent.com/MengLiMing/EasyKits/master/demo_gif/carouseView.gif)|
|EasyListView|EasySegmentedView|
|![](https://raw.githubusercontent.com/MengLiMing/EasyKits/master/demo_gif/easylistview.gif)|![](https://raw.githubusercontent.com/MengLiMing/EasyKits/master/demo_gif/easysegmentview.gif)|

## 部分组件线上项目效果
|EasyListView+EasySegmentedView+EasyPagingContainerView|
|:---:|
|![](https://raw.githubusercontent.com/MengLiMing/EasyKits/master/demo_gif/app_1.gif)|
|EasyListView+EasySegmentedView+EasyCarouseView|
|![](https://raw.githubusercontent.com/MengLiMing/EasyKits/master/demo_gif/app_2.gif)|

## Author

MengLiMing, 13014795306@163.com

## License

EasyKits is available under the MIT license. See the LICENSE file for more info.
