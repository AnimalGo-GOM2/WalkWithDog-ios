# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'animalgo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for animalgo
  pod 'ObjectMapper'
  pod 'Alamofire'
  pod 'AlamofireNetworkActivityLogger'
  pod 'Result'
  
  pod 'Hero'
  pod 'SwiftyJSON'
  pod 'SwiftDate'
  pod 'SwiftyBeaver'
  pod 'SDWebImage'
  pod 'EZSwiftExtensions'
  pod 'IQKeyboardManagerSwift'
  pod 'SKPhotoBrowser'
  pod 'DZNEmptyDataSet'
  pod 'CropViewController'
  pod 'NotificationBannerSwift'
  pod 'NVActivityIndicatorView', "= 4.8.0"
  pod 'ExpyTableView'
  pod 'Defaults'
  pod 'StringStylizer', '= 5.0.0'
  pod 'RSKPlaceholderTextView' # TextView PlaceHolder
  pod 'SkeletonView' # 스켈레톤
  pod 'DropDown'
  pod 'DKImagePickerController', :subspecs => ['PhotoGallery', 'Camera', 'InlineCamera'] # 다중 이미지 선택
  
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Messaging'
  pod 'NMapsMap' # 네이버 지도
  pod 'Cosmos' # 리뷰 별표기
  pod 'Daysquare', :git => 'https://github.com/unixzii/Daysquare.git' # 달력
  pod 'Parchment' # 슬라이드 탭
  pod 'UPCarouselFlowLayout'
  pod 'RSKGrowingTextView' # 늘어나는 TextView
  pod 'SwiftLocation' # GPS
  pod 'HCKalmanFilter' # Kalman Filter

  pods_with_specific_swift_versions = {
    'EZSwiftExtensions' => '4.0',
    'RSKGrowingTextView' => '5.0',
    'RSKPlaceholderTextView' => '5.0',
    'ExpyTableView' => '5.0'
  }

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if pods_with_specific_swift_versions.key? target.name
        swift_version = pods_with_specific_swift_versions[target.name]
        target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = swift_version
        end
      end
    end
  end
  


end
