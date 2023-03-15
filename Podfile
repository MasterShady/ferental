# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

source 'https://github.com/CocoaPods/Specs.git'
source 'http://192.168.29.27/mengke/Specs.git'

target 'ferental' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

    pod 'SnapKit', '~> 5.6.0'
  pod 'LookinServer', :configurations => ['Debug']
#  pod 'BFKit-Swift'
  pod 'YYKit'
  #pod  'Alamofire'
  #pod 'Moya', '~> 15.0'
  pod 'Moya/RxSwift', :podspec => './Moya.podspec'
  pod 'SwiftyJSON'
  pod 'HandyJSON'
  pod 'MBProgressHUD'
  pod 'Kingfisher', '~> 7.0'
  pod 'EmptyDataSet-Swift', '~> 5.0.0'
  pod 'Parchment', '~> 3.2'
  pod "ESPullToRefresh"
  pod 'AEAlertView'
  pod 'JXPhotoBrowser', '~> 3.0'
  pod 'ETNavBarTransparent'
  pod 'RxSwift', '6.5.0'
  pod 'RxCocoa', '6.5.0'
  pod 'mob_sharesdk'
  pod 'mob_sharesdk/ShareSDKUI'
  pod 'mob_sharesdk/ShareSDKPlatforms/QQ'
  pod 'mob_sharesdk/ShareSDKPlatforms/WeChat'
  pod 'mob_sharesdk/ShareSDKExtension'
  pod 'KeychainAccess'
  pod 'DFFaceVerifyLib','~> 1.0.3'
  pod 'DFBaseLib', '~> 0.6.9'
  pod 'ZipArchive', '~> 1.4.0'
  pod 'AFNetworking'
  pod 'lottie-ios', '~> 3.2.1'
  pod 'DFToGameLib', '~> 3.3.1'
  pod 'JPush'

  target 'ferentalTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ferentalUITests' do
    # Pods for testing
  end
  
  post_install do |installer|
    installer.generated_projects.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
          config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
          config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
        end
      end
  end

end
