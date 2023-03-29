# PKGModule



## Example

参考demo 集成步骤 

* step1 初始化离线包

![image-20230323183758894](Images/image-20230323183758894.png)

config 初始化参数说明

```swift
	/// 配置
  /// - Parameters:
  ///   - appId: appId
  ///   - appVersion: app自定义版本 用来控制B面的显示
  ///   - httpSignKey: http sign key, 请求签名使用
  ///   - webSocketSignKey: webSocket sign key , 心跳请求签名
  ///   - appURLScheme: 本app打开的 url scheme, 建议和bundleId 一致
  ///   - faceBusnissId: 网易人脸验证的业务id
  ///   - source: 枚举, 加载线上包 还是本地宝
  ///   - apiEnv: 请求环境, 测试, 生产, 预生产
  ///   - checkVersion: 是否检查版本来控制 B 面显示, 方便测试.
  public init(appId: String, appVersion: String, httpSignKey:String, webSocketSignKey:String,appURLScheme: String, faceBusnissId: String, source:PKGSource, apiEnv: LOLDF_APIEnv, checkVersion: Bool = true) {
    self.appId = appId
    self.source = source
    self.apiEnv = apiEnv
    self.appVersion = appVersion
    self.checkVersion = checkVersion
    self.httpSignKey = httpSignKey
    self.appURLScheme = appURLScheme
    self.faceBusnissId = faceBusnissId
    self.webSocketSignKey = webSocketSignKey
  }
```

initJPush 方法说明

截图中initJPush 是 推送三方相关代码, 与离线包业务无关, 需要单独集成. 离线包业务中需要集成推送的功能, 需要将app是否授权推送的状态告知前端, 因此需要在推送状态更新PKGManager.notificationAvaliable的状态. 

![image-20230323172903840](Images/image-20230323172903840.png)

还有一处, app 进入前台时也要进行更新判断.

![image-20230323173011218](Images/image-20230323173011218.png)



* step2  设置离线包准备完成回调. 直接进行视图切换即可.

![image-20230323173334308](Images/image-20230323173334308.png)

* step3 设置离线包中的message 展示的回调

![image-20230323184054601](Images/image-20230323184054601.png)



* step4, info.plist 中 设置 `Queried URL Schemes` ,  注意这里`Queried URL Schemes` 只有前50条是有效的,超过50条之后的设置无效.

* step5  `xcodeproj ->Info->URL Type` 设置 打开此app的`URL Scheme`.    **这里的`URL Scheme`需要 和  step1 中保持一致**

* step6 检查 `Privacy - Microphone Usage Description`, `Privacy - Photo Library Additions Usage Description` `Privacy - Photo Library Usage Description` 配置

* step7 检查 Capability 中的推送是否添加.

  



## Requirements

## Installation



```ruby
platform :ios, '13.0'
source 'https://github.com/CocoaPods/Specs.git'
source 'http://git.zhw.com/mengke/Specs.git'

target 'XXX' do
	pod 'PKGModule'
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
```

## Author



## License

PKGModule is available under the MIT license. See the LICENSE file for more info.
