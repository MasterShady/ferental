//
//  SWLGqqTokenProtocol.swift
//  DoFunNew
//
//  Created by mac on 2021/6/4.
//

import Foundation
import CocoaAsyncSocket
import DFBaseLib
import DFOCBaseLib
class SWLGqqToken8xx:SWLg8xProtocol {
    
    func lg8xxSliderVerify(withUrl: String, withCall: @escaping (String) -> ()) {
        
        
        self.sliderView.configureLoadUrl(withUrl)
        self.sliderView.tickerAndRandstrBlock = { [weak self](ticket,_) in
            
            self?.sliderBackview?.dismiss()
            withCall(ticket)
            
        }
        
        
        self.sliderView.closeBlock = {[weak self]() in
            
            self?.sliderBackview?.dismiss()
        }
        self.sliderBackview = CHAlertView(middleView: self.sliderView)
        self.sliderBackview?.show()
        
    }
    
    
    func lg8xxSendDataToQQ(withHost: String, port: UInt16,data:Data, withCall: @escaping(String?)->())  {
         
        let msgCallBack:(String)->() = { (msg) in
            
            withCall(msg)

        }
        
        if let _qqConnection = socketQQ {
            
            _qqConnection.sendData(withData: data, withCallBack: msgCallBack)
        }else{
            
            socketQQ = SWLgQQSocket(ip: withHost , port: port)
            socketQQ?.sendData(withData: data, withCallBack: msgCallBack)
            
        }
        
    }
    
    
    func lg8xxtokenGetSuccess(withTokenInfo: String) {
         
        eventblock?(1,withTokenInfo)
    }
    
    func lg8xx_plistInfoGetSuccess(with: [String:Any]) {
        
        eventblock?(3,with)
    }
    
    func lg8xxError(withErrorCode: Int, msg: String) {
        
        eventblock?(2,"\(withErrorCode):[qq_8x] \(msg)")
    }
    
    func reload(withMsg:String){
        
        eventblock?(0,"[qq_8x] \(withMsg)")
    }
    
    func uploadError(socket:SWLg8xSocketProtocol,withMsg:String){
        

        //错误信息包含在关键词 标识需要投诉
        isTs = self.quickModel.off_rent.contains {
            
            return withMsg.contains($0)
        }
        
        if isTs == true{
            
            socket.endTask()
            
            socketQQ?.endTask()
            
            var param:[String:Any] = [:]
            
            param["hid"] = self.param.order_info?.hid
            
            param["order_id"] = self.param.order_info?.orderid
            
            param["remark"] = withMsg
            param["source"] = quickModel.source
            param["quick_ts"] = 1
            param["err_times"] = 0
            param["quick_version"] = "5"
            param["order_login"] = self.param.quick_info?.order_login
            
            SWNetworkingTool.requestFun(url:  SW_API_SETTOKENERROR, method: .post, parameters: param) { (json) in
            
            
                        guard let model = SWjd<SWHTTPResponseBase>.deserializeFrom(json: json) else {
            
                            return
                        }
                      
                        if model.status == 2 {
            
            
                            self.eventblock?(0,model.message)
                        }
                    } failBlock: { (error) in
            
            
            }
            
        }
        
        
        
        if isTs == false {
            
            isTry = quickModel.retry.contains {
                
                return withMsg.contains($0)
            }
            
            if isTry == true {
                
                if reTry_num > 0 {
                    
                    reTry_num -= 1
                    socket.reDoTask()
                    
                }else{
                    
                    var param:[String:Any] = [:]
                    
                    param["hid"] = self.param.order_info?.hid
                    
                    param["order_id"] = self.param.order_info?.orderid
                    
                    param["remark"] = withMsg
                    param["source"] = quickModel.source
                    
                    param["err_times"] = 0
                    param["quick_version"] = "5"
                    param["order_login"] = self.param.quick_info?.order_login
                    
                    SWNetworkingTool.requestFun(url:  SW_API_SETTOKENERROR, method: .post, parameters: param) { (_) in
                    
                            } failBlock: { (error) in

                    }

                    socket.endTask()
                    
                    socketQQ?.endTask()
                    
                    eventblock?(2,"84上号失败")
                    
                }
            }
        }
        
    }
    
    //游戏id
    var game_id:String = ""
    
    var quickModel:SWQuickInfoQuickTypeModel!
    
    var param:SWQuickLoginGameModel!
    
    var socketQQ:SWLgQQSocket?
    
    var xxsocket:SWLg8xSocketProtocol! //8.x 协议
    
    var version:Int = 84
    
    var isTry:Bool = false
    var isTs:Bool = false
    var reTry_num:Int = 0
    
    lazy var sliderView:AlertHKMideView = {
        
        let slider = AlertHKMideView()
        
        slider.backgroundColor = .clear
        
        slider.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
    
        return slider
    }()
    
    var sliderBackview:CHAlertView?
    
    /// 事件回调 0 relaod 1成功 2 失败
    var eventblock:((Int,Any)->())?
    
    func queryToken() {
        
        reTry_num = quickModel.retry_times
        
        if  version == 84 {
            
            xxsocket = SWLg84Socket()
            
        }
        
        if version == 88 {
            
            xxsocket = SWLg88Socket()

        }
        
       
        xxsocket.game_id = game_id

        xxsocket.delegate = self

        xxsocket.upload_source = quickModel.source

        xxsocket.doTask(withdic: param)
         
    }
    
    
    func cancel()  {
         
         self.sliderBackview?.dismiss()
        
         socketQQ?.endTask()
         
         xxsocket.endTask()
        
         
    }
}


/// 操作码
extension Int {
    
    static var OP_8001:Int = 8001
    
    static var OP_8002:Int = 8002
    
    static var OP_8003:Int = 8003
    
    static var OP_8004:Int = 8004
    
    static var OP_8005:Int = 8005
    
    static var OP_8007:Int = 8007 //plist方式
    
    static var OP_9001:Int = 9001
    
    static var OP_9002:Int = 9002
    
    static var OP_9003:Int = 9003
    
    static var OP_0001:Int = 1
    
    static var OP_0002:Int = 2
    
    static var OP_0003:Int = 3
    
    static var OP_0004:Int = 4 //plist方式
}

///长连接状态
enum SW8xEventType:Int {
    
    case NONE      = 0 //初始状态
    
    case HANDSHAKE = 1 //交换Key
    
    case SENDDATA  = 2 //业务逻辑处理
    
    case End 
  
}

//84 88 socket 代理事件
protocol SWLg8xProtocol:AnyObject {
    
    func lg8xxtokenGetSuccess(withTokenInfo: String)
    
    func lg8xxSendDataToQQ(withHost: String, port: UInt16,data:Data, withCall: @escaping(String?)->())
    
    func lg8xxSliderVerify(withUrl:String, withCall: @escaping(String)->())
    
    func lg8xxError(withErrorCode:Int,msg:String)
    
    func reload(withMsg:String)
    
    func uploadError(socket:SWLg8xSocketProtocol,withMsg:String)
    
    func lg8xx_plistInfoGetSuccess(with:[String:Any])
        
    
    
}




/// 请求QQ数据
class SWLgQQSocket: NSObject,GCDAsyncSocketDelegate{
    
    func socket(_ sock: GCDAsyncSocket, didConnectTo url: URL) {
         
         
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
         guard let _ = callBack else {
            
            return
         }
        
         let str1 = String.init(data: data, encoding: String.Encoding.utf8)
         
         SWLGLog(withMsg: "qq Socket did read Data--\(str1 ?? "")")
         
         callBack?(SWLGUtils.hexString(from: data))
        
         callBack = nil
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        
         sock.readData(withTimeout: -1, tag: 0)
    }
    
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        
        print("qq did disconnect")
    }
    var socket:GCDAsyncSocket!
    
    var host:String!
    
    var port:UInt16!
    
    var readedData:Data = Data()
    
    init(ip:String,port:UInt16) {
        
        super.init()
        
        host = ip
        
        self.port = port
        
        socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
    
    }
    
  
    
    var callBack:((String)->())?
    
    func sendData(withData:Data,withCallBack:@escaping(String)->())  {
        
        if socket.isConnected == false {
            
            do {
                try socket.connect(toHost: host, onPort: port)
                
                callBack = withCallBack
               
                socket.write(withData, withTimeout: -1, tag: 0)
                
            } catch  {
                
                print("qqsocket-error-\(error.localizedDescription)")
            }
        }else{
            
            callBack = withCallBack
            socket.write(withData, withTimeout: -1, tag: 0)
        }
        
        
    }
    
    
    func endTask()  {
        
        socket.disconnect()
    }
}


protocol SWLg8xSocketProtocol {
     
    func reDoTask()
    
    func doTask(withdic:SWQuickLoginGameModel)
    
    func endTask()
    
    var  game_id:String  {get set}
    
    var  delegate:SWLg8xProtocol? {get set}
    
    var  upload_source:String {get set}
}




//协议 84
class SWLg84Socket:NSObject,GCDAsyncSocketDelegate {
    
    func socket(_ sock: GCDAsyncSocket, didConnectTo url: URL) {
         
        
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        
        print("socket 断开-\(err.debugDescription)")
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
        guard let data_str =  String(data: data, encoding: .utf8) else {
            
            return
        }
        
        self.readedData += data
        
        if data_str.hasSuffix("\0") == false {
            
            sock.readData(withTimeout: -1, tag: 0)
            
            return
        }
        
        guard let result = String(data: readedData, encoding: .utf8) else {
            
            return
        }
        
        readedData.removeAll()
        let json =  SWLGUtils.turnString(toDictionary: result)
        
        
        guard json.isEmpty == false else {
            
            return
        }
        
        guard let ec = json.getValue(key: "ec", t: Int.self), ec == 0  else {
            
            
            self.delegate?.lg8xxError(withErrorCode: 8, msg: json["em"] as? String ?? "")
            return
        }
        
        SWLGLog(withMsg:"Server->\(json)")
        switch status {
        case .HANDSHAKE:
             
            guard let srv_key_crypt = json.getValue(key: "srv_key", t: String.self) else {
                
                return
            }
            srv_key = RSAUtil.decryptString(srv_key_crypt, publicKey: rsa_key)
            
            if let qtoken = qq_token , qtoken.isEmpty == false {
                
              let qq_uin =  game_auth_dic.getValue(key: "qq", t: String.self)!
              
              let dic:[String:Any] = ["op":Int.OP_8002,"usr_info":["uin":Int(qq_uin)!],"dev_info":game_auth_dic ["deviceinfo"] as Any,"gm_init":["gm_id":game_id,"qq_token":qtoken]]
                
                guard let _data = _operationMsg(content: dic) else {
                    
                    return
                }
                
                sendData(withData: _data)
                
            }else{
                 
                if re_open_token {
                    
                    let qq_uin =  info.qq
                    let password_c = info.quick_info?.game_mm ?? ""
                    if password_c.count == 0 {
                        
                        print("密码为空")
                    }
                    let userDic:[String:Any] = ["uin":Int(qq_uin)!,"password_c":password_c]
                    
                    let devDic = game_auth_dic["deviceinfo"]!
                    
                    let dic:[String:Any] = ["op":Int.OP_8001,"usr_info":userDic,"dev_info":devDic]
                    
                    guard let _data = _operationMsg(content: dic) else {
                        
                        return
                    }
                    
                    sendData(withData: _data)
                }else{
                    
                    /**
                     交换秘钥后，上号端先发 8002根据qtoken获取游戏token, 如果获取成功上报数据并上号，如果获取失败，则重新走一次上号短开通
                     */
                    let qq_uin:Int =  Int(game_auth_dic.getValue(key: "qq", t: String.self)!)!
                    let dic:[String:Any] = ["op":Int.OP_8002,"usr_info":["uin":qq_uin],"dev_info":game_auth_dic["deviceinfo"] as Any  ,"gm_init":["gm_id":game_id,"qq_token":game_auth_dic["qtoken"]]]
                    
                    guard let _data = _operationMsg(content: dic) else {
                        
                        return
                    }
                    
                    sendData(withData: _data)
                }
                
                
            }
            
        case .SENDDATA:
            
            
            guard let hexStr = json.getValue(key: "data", t: String.self),hexStr.isEmpty == false else {
                
                self.delegate?.lg8xxError(withErrorCode: 1, msg: "server 返回数据 为空")
                
                return
            }
            
           let deAesStr =  DFAES.aes128DecryptECB(hexStr, key: srv_key)
            
            guard deAesStr.isEmpty == false else {
                
                self.delegate?.lg8xxError(withErrorCode: 1, msg: "aes 128 解密数据 为空")
                return
            }
            
           let serv_dic  = SWLGUtils.turnString(toDictionary: deAesStr)
           print(serv_dic)
           guard let oprationCode = serv_dic.getValue(key: "op", t: Int.self) else {
                
                return
            }
          
            if oprationCode == Int.OP_9001 {
                
                let ip  =  serv_dic.getValue(key: "transpond", t: [String:Any].self)!.getValue(key: "ip", t: String.self)!
                
                let port = serv_dic.getValue(key: "transpond", t: [String:Any].self)!.getValue(key: "port", t: Int.self)!
                
                let qq_data = SWLGUtils.convertHexStr(toData: serv_dic.getValue(key: "transpond", t: [String:Any].self)!.getValue(key: "data", t: String.self)!)
                
                self.delegate?.lg8xxSendDataToQQ(withHost: ip, port: UInt16(exactly: port)!, data: qq_data, withCall: { [self] (msg) in
                    
                    let pkg_dic:[String:Any] = ["op":Int.OP_8003,"transpond":["r_data":msg!]]
                    
                    if let _data = _operationMsg(content: pkg_dic)  {
                        
                        self.sendData(withData: _data)
                    }
                })
            }
            else if oprationCode == Int.OP_9002{
                //弹出滑块验证
                
                guard let url = serv_dic.getValue(key: "v_code", t: [String:Any].self)?.getValue(key: "uri", t: String.self) else {
                    
                    return
                }
                
                self.delegate?.lg8xxSliderVerify(withUrl: url, withCall: { ticket in
                    
                    let pkg_dic:[String:Any] = ["op":Int.OP_8004,"v_code":["key":ticket]]
                    guard let _data = self._operationMsg(content: pkg_dic) else {
                        
                        return
                    }
                    
                    self.sendData(withData: _data)
                })
                
              
                
                
            }
            else if oprationCode == Int.OP_9003{
                
                self.delegate?.uploadError(socket: self,withMsg: "触发短信验证码")
                
//                uploadError(withInfo: "触发短信验证码")
            }
            else if oprationCode == Int.OP_0001{
                
                qq_token = serv_dic.getValue(key: "result", t: [String:Any].self)?.getValue(key: "qq_token", t: String.self)
                
                game_auth_sign = serv_dic.getValue(key: "result", t: [String:Any].self)?.getValue(key: "sign", t: String.self)
            
                reDoTask()
                
            }
            else if oprationCode == Int.OP_0002{
                
                //获取gmtoken
                guard let tokenStr = serv_dic.getValue(key: "result", t: [String:Any].self)?.getValue(key: "gm_token", t: String.self),tokenStr.isEmpty == false else {
                    
                    return
                }
                
                let tokenArr = tokenStr.split(separator: "_").map {
                    return String($0)
                }
               
                guard tokenArr.count == 3 else {
                    
                    return
                }
                
                uploadGameTokenInfo(withAtoken: tokenArr[0], openid: tokenArr[1], ptoken: tokenArr[2])
                
                //开始上号
                
                self.delegate?.lg8xxtokenGetSuccess(withTokenInfo: tokenStr)
                
            }
            else if oprationCode == Int.OP_0003 {
                
               let error = serv_dic.getValue(key: "result", t: [String:Any].self)?.getValue(key: "error", t: String.self)
                
                if re_open_token == false {
                    
                    re_open_token = true
                    
                    reDoTask()
                    
                }else{
                    
//                    uploadError(withInfo: error ?? "OP_0003")
                    
                    self.delegate?.uploadError(socket: self,withMsg: error ?? "OP_0003")
                }
                
                
            }
            else{
                //未定义code
                
                print("84 socket 未定义操作码逻辑")
            }
            
            
        default:
            
            break
        }
        
    }
    
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        
        //状态已数据发送成功为准
        
        switch status {
        case .NONE:
            
            status = .HANDSHAKE
            
        case .HANDSHAKE:
        
        status = .SENDDATA
        
        default:
            break
        }
        
        sock.readData(withTimeout: -1, tag: 0)
    }
    
    unowned var delegate:SWLg8xProtocol?
    
    var socket:GCDAsyncSocket!
    
    var info:SWQuickLoginGameModel!
    
    var status:SW8xEventType = .NONE
    
    var aes_key:String = "" //
    
    var srv_key:String = ""
    
    var qq_token:String?
    
    var game_auth_sign:String?  // sign OP_0001 返回 上报接口用到
    
    var game_id:String = ""
    
    var upload_source:String = ""
    
    
    var re_open_token:Bool = false
    
    var game_auth_dic:[String:Any] = [:]
    
    var readedData:Data = Data()
    
    lazy var sliderView:AlertHKMideView = {
        
        let slider = AlertHKMideView()
        
        slider.backgroundColor = .clear
        
        slider.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
    
        return slider
    }()
    
    var sliderBackview:CHAlertView?
    
    
    override init() {
        
        super.init()
        
        socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        
        
        
    }
    
    
    /// 重新开始
    func reDoTask() {
        
        status = .NONE
        
        aes_key = SWLGUtils.random128BitAESKey()
        
        guard let host = info.quick_info?.rent_auth_address else {
            
            self.delegate?.lg8xxError(withErrorCode: 1, msg: "socket ip 为空")
            return
        }
        guard let pt = info.quick_info?.rent_auth_port else {
            
            self.delegate?.lg8xxError(withErrorCode: 1, msg: "socket port 为空")
            return
        }
        
        
        if socket.isConnected == false{
        
            do {
                
                try socket.connect(toHost: host, onPort: UInt16(exactly: pt)!)
               //链接成功 ，开始数据传输
                
                guard let data = _handshake() else {
                    
                    return
                }

                sendData(withData: data)
            } catch {
                
                self.delegate?.lg8xxError(withErrorCode: 4, msg: "socket connet error")
            }
        }else{
            
            //链接成功 ，开始数据传输
            guard let data = _handshake() else {
                
                self.delegate?.lg8xxError(withErrorCode: 5, msg: "握手包构建失败")
                return
            }
            
            sendData(withData: data)
        }
        
    }
    
    
    /// 开始任务
    /// - Parameter withdic: 必要信息
    func doTask(withdic:SWQuickLoginGameModel) {
        
        info = withdic
        
        aes_key = SWLGUtils.random128BitAESKey()
        
        guard let game_auth = info.quick_info?.game_auth.uppercased() else {
            
            self.delegate?.lg8xxError(withErrorCode: 1, msg: "game_auth 为空")
            return
        }
        
        guard let rc4TokenStr = ZSRc4.swRc4Decrypt(withSource: game_auth, rc4Key: game_auth_key) else {
            
            self.delegate?.lg8xxError(withErrorCode: 2, msg: "game_auth rc4 解密失败")
            return
        }
        
        SWLGLog(withMsg: "gameauth->\(rc4TokenStr)")
        guard let dictoken = try? JSONSerialization.jsonObject(with: rc4TokenStr.data(using: .utf8)!, options: .mutableContainers) else {
            
            self.delegate?.lg8xxError(withErrorCode: 3, msg: "game_auth 解析失败")
            return
        }
        
        
        game_auth_dic = dictoken as! [String:Any]
        
        guard game_auth_dic.isEmpty == false else {
            
            self.delegate?.lg8xxError(withErrorCode: 1, msg: "game_auth_dic 为空")
            return
        }
        
        
        guard let host = info.quick_info?.rent_auth_address else {
            
            self.delegate?.lg8xxError(withErrorCode: 1, msg: "socket ip 为空")
            return
        }
        guard let pt = info.quick_info?.rent_auth_port else {
            
            self.delegate?.lg8xxError(withErrorCode: 1, msg: "socket port 为空")
            return
        }
        
        guard status == .NONE else {
            
            return
        }
        if socket.isConnected == false{
        
            do {
                
                try socket.connect(toHost: host, onPort: UInt16(exactly: pt)!)
               //链接成功 ，开始数据传输
                
                guard let data = _handshake() else {
                    
                    return
                }

                sendData(withData: data)
                
            } catch {
                
                self.delegate?.lg8xxError(withErrorCode: 4, msg: "socket connet error")
            }
        }else{
            
            //链接成功 ，开始数据传输
            guard let data = _handshake() else {
                
                self.delegate?.lg8xxError(withErrorCode: 5, msg: "握手包构建失败")
                return
            }
            
            sendData(withData: data)
        }
        
        
            
    }
    
    
    func endTask()  {
        
        socket.disconnect()
    }
    
    
    func sendData(withData:Data)  {
         
         socket.write(withData, withTimeout: -1, tag: 0)
    }
    
   
    
}


///处理需要发送的数据
extension SWLg84Socket {
    
    
    func _msgBody(withDic:[String:Any]) -> Data? {
        
        guard var jsonstr = withDic.toJsonString() else {
            
            return nil
        }
        
        jsonstr += "\0"
        
        return jsonstr.data(using: .utf8)
        
    }
    
    ///握手消息 - 发送客户端key到S端
    func _handshake() ->Data? {
        
        let qq = info.qq
        
        guard let quick_identity = info.quick_info?.quick_identity else {
            
            return nil
        }
        
        guard let hid = info.order_info?.hid else {
            
            return nil
        }
        
    
       let str =  RSAUtil.encryptString(aes_key, publicKey: rsa_key) as String
        
        let cln_token = "hid=\(hid)qq=\(qq)&token=\(quick_identity)"
        
        let dic:[String : Any] = ["cln_key":str,"srv_ide":1,"cln_app":SWOtherInfoWrap.shared.appId,"cln_token":cln_token,"cln_dev":APPUUID()]
        
        
        return _msgBody(withDic: dic)
    }
    
    
    
    ///  Commond 消息
    /// - Parameter content: 消息
    /// - Returns: 消息加密
    
    func _operationMsg(content:[String:Any]) -> Data?  {
         
        guard let jsonStr = content.toJsonString() else {
            
            return nil
        }
        
        let enc_str =  DFAES.aes128EncryptECB(jsonStr, key: aes_key)
        
        let sign_str = SWLGUtils.md5ForBytes(toLower32Bate: enc_str) as String
        
        var param:[String:Any] = [:]
        
        param["time"] = String.timeIntervalChangeToTimeStr(timeInterval: NSDate().timeIntervalSince1970)
        
        param["data"] = enc_str
        param["sign"] = sign_str
        
        return _msgBody(withDic: param)
        
        
    }
    
    
    
    
    /**
     8.4 获取游戏数据，进行上报
     */
    func uploadGameTokenInfo(withAtoken:String,openid:String,ptoken:String)  {
        
        var param:[String:Any] = [:]
        param["hid"] = info.order_info?.hid
        
        //订单id
        param["order_id"] = info.order_info?.orderid
        
        param["source"] = upload_source
        
        param["err_times"] = 0
        
        param["quick_version"] = "5"
        
        param["order_login"] = info.quick_info?.order_login
        
        let tokenInfo:[String:Any] = ["ptoken":ptoken,"openid":openid,"atoken":withAtoken,"current_uin":openid,"platform":"qq_m"]
        
       let rc4Str = ZSRc4.swRc4Encrypt(withSource: tokenInfo.toJsonString()!, rc4Key: game_auth_key)
        
      param["login_token"] = rc4Str
        
        if re_open_token {
            
            var game_dic:[String:Any] = ["qtoken":qq_token as Any,"deviceinfo":game_auth_dic["deviceinfo"]!,"qq":game_auth_dic["qq"]!]
            if let sign = game_auth_sign {
                
                game_dic["sign"] = sign
            }
            let rc4Str = ZSRc4.swRc4Encrypt(withSource: game_dic.toJsonString()!, rc4Key: game_auth_key)
            param["game_auth"] = rc4Str
            param["remark"] = "上号端重新开通,成功"
            
        }else{
            
            param["remark"] = "上号成功"
        }
        
        SWNetworkingTool.requestFun(url:  SW_API_SETTOKENSOFT, method: .post, parameters: param) { (json) in
            
        } failBlock: { (error) in
           
        }

        
    }
}




//协议 88
class SWLg88Socket:NSObject,GCDAsyncSocketDelegate {
    
    func socket(_ sock: GCDAsyncSocket, didConnectTo url: URL) {
         
        
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        
         SWLGWarning(withMsg: "socket did disconnet")
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
        guard let data_str =  String(data: data, encoding: .utf8) else {
            
            return
        }
        
        self.readedData += data
        
        if data_str.hasSuffix("\0") == false {
            
            sock.readData(withTimeout: -1, tag: 0)
            
            return
        }
        
        guard let result = String(data: readedData, encoding: .utf8) else {
            
            return
        }
        
        readedData.removeAll()
        let json =  SWLGUtils.turnString(toDictionary: result)
        SWLGLog(withMsg: "服务端返回数据\(json)")
        
        guard json.isEmpty == false else {
            
            return
        }
        
        guard let ec = json.getValue(key: "ec", t: Int.self), ec == 0  else {
            
            if let msg = json["em"] as? String, msg == "PACK_STATUS::UNPACK_ERROR"  {
                
                SWLGWarning(withMsg: "PACK_STATUS::UNPACK_ERROR")
                re_open_token = true
                
                reDoTask()
                
            }else{
                
                self.delegate?.lg8xxError(withErrorCode: 8, msg: json["em"] as? String ?? "")
            }
            
            return
        }
        
        
       
        switch status {
        case .HANDSHAKE:
             
            guard let srv_key_crypt = json.getValue(key: "srv_key", t: String.self) else {
                
                return
            }
            srv_key = RSAUtil.decryptString(srv_key_crypt, publicKey: rsa_key)
            
            if let qtoken = qq_token , qtoken.isEmpty == false {
                
              let qq_uin =  game_auth_dic.getValue(key: "qq", t: String.self)!
              
              let dic:[String:Any] = ["op":Int.OP_8007,"usr_info":["uin":Int(qq_uin)!],"dev_info":getDeviceInfo(),"gm_init":["gm_id":game_id,"qq_token":qtoken]]
                print("8007数据包",dic)
                guard let _data = _operationMsg(content: dic) else {
                    
                    return
                }
                
                sendData(withData: _data)
                
            }else{
                 
                if re_open_token {
                    
//                    let qq_uin =  info.qq
//                    let password_c = info.quick_info?.game_mm ?? ""
//                    if password_c.count == 0 {
//
//                        SWLGWarning(withMsg: "密码为空")
//                    }
//                    let userDic:[String:Any] = ["uin":Int(qq_uin)!,"password_c":password_c]
//
//                    let devDic = game_auth_dic["deviceinfo"]!
//
//                    let dic:[String:Any] = ["op":Int.OP_8001,"usr_info":userDic,"dev_info":devDic]
                    
                    guard let _data = _open() else {
                        
                        return
                    }
                    
                    
                    sendData(withData: _data)
                }else{
                    //88 取deviceInfo
                    /**
                     交换秘钥后，上号端先发 8002根据qtoken获取游戏token, 如果获取成功上报数据并上号，如果获取失败，则重新走一次上号短开通
                     */
                    let qq_uin:Int =  Int(game_auth_dic.getValue(key: "qq", t: String.self)!)!
                    let dic:[String:Any] = ["op":Int.OP_8007,"usr_info":["uin":qq_uin],"dev_info":getDeviceInfo() ,"gm_init":["gm_id":game_id,"qq_token":game_auth_dic["qtoken"]]]

                    guard let _data = _operationMsg(content: dic) else {

                        return
                    }

                    sendData(withData: _data)
                    
//                    let qq_uin =  info.qq
//                    let password_c = info.quick_info?.game_mm ?? ""
//                    if password_c.count == 0 {
//
//                        SWLGWarning(withMsg: "密码为空")
//                    }
//                    let userDic:[String:Any] = ["uin":Int(qq_uin)!,"password_c":password_c]
//
//                    let devDic = game_auth_dic["deviceinfo"]!
//
//                    let dic:[String:Any] = ["op":Int.OP_8001,"usr_info":userDic,"dev_info":devDic]
//
//                    guard let _data = _operationMsg(content: dic) else {
//
//                        return
//                    }
//
//                    sendData(withData: _data)
                }
                
                
            }
            
        case .SENDDATA:
            
            
            guard let hexStr = json.getValue(key: "data", t: String.self),hexStr.isEmpty == false else {
                
                self.delegate?.lg8xxError(withErrorCode: 1, msg: "server 返回数据 为空")
                
                return
            }
            
            let deAesStr =  DFAES.aes128DecryptECB(hexStr, key: srv_key)
            
            guard deAesStr.isEmpty == false else {
                
                SWLGError(withMsg: "aes解密服务端数据为空")
                self.delegate?.lg8xxError(withErrorCode: 1, msg: "aes 128 解密数据 为空")
                return
            }
           
            SWLGLog(withMsg: "Data_Str->\(deAesStr)")
            let serv_dic  = SWLGUtils.turnString(toDictionary: deAesStr)
            SWLGLog(withMsg: "解密服务端数据\(serv_dic)")
            guard let oprationCode = serv_dic.getValue(key: "op", t: Int.self) else {
                
                return
            }
           
            if oprationCode == Int.OP_9001 {
                
                let ip  =  serv_dic.getValue(key: "transpond", t: [String:Any].self)!.getValue(key: "ip", t: String.self)!
                
                let port = serv_dic.getValue(key: "transpond", t: [String:Any].self)!.getValue(key: "port", t: Int.self)!
                
                let qq_data = SWLGUtils.convertHexStr(toData: serv_dic.getValue(key: "transpond", t: [String:Any].self)!.getValue(key: "data", t: String.self)!)
                
                self.delegate?.lg8xxSendDataToQQ(withHost: ip, port: UInt16(exactly: port)!, data: qq_data, withCall: { [self] (msg) in
                    
                    let pkg_dic:[String:Any] = ["op":Int.OP_8003,"transpond":["r_data":msg!]]
                    
                    if let _data = _operationMsg(content: pkg_dic)  {
                        
                        self.sendData(withData: _data)
                    }
                })
            }
            else if oprationCode == Int.OP_9002{
                //弹出滑块验证
                
                guard let url = serv_dic.getValue(key: "v_code", t: [String:Any].self)?.getValue(key: "uri", t: String.self) else {
                    
                    return
                }
                
                self.delegate?.lg8xxSliderVerify(withUrl: url, withCall: { ticket in
                    
                    let pkg_dic:[String:Any] = ["op":Int.OP_8004,"v_code":["key":ticket]]
                    guard let _data = self._operationMsg(content: pkg_dic) else {
                        
                        return
                    }
                    
                    self.sendData(withData: _data)
                })
                
              
                
                
            }
            else if oprationCode == Int.OP_9003{
                
                SWLGError(withMsg: "操作码9003,触发短信验证码")
                self.delegate?.uploadError(socket: self,withMsg: "触发短信验证码")
                
                 
            }
            else if oprationCode == Int.OP_0001{
                
                let result = serv_dic.getValue(key: "result", t: [String:Any].self)
                
                qq_token = result?.getValue(key: "qq_token", t: String.self)
                
                qq_skey = result?.getValue(key: "qq_skey", t: String.self)
                
                game_auth_sign = result?.getValue(key: "sign", t: String.self)
                
                SWLGLog(withMsg: "操作码9001,重新开启任务")
                reDoTask()
                
            }
            else if oprationCode == Int.OP_0002{
                
                let result = serv_dic.getValue(key: "result", t: [String:Any].self)
                
                qq_skey = result?.getValue(key: "qq_skey", t: String.self)
                
                //获取gmtoken
                guard let tokenStr = result?.getValue(key: "gm_token", t: String.self),tokenStr.isEmpty == false else {
                    
                    return
                }
                
                let tokenArr = tokenStr.split(separator: "_").map {
                    return String($0)
                }
                
                guard tokenArr.count == 3 else {
                    
                    return
                }
                
                uploadGameTokenInfo(withAtoken: tokenArr[0], openid: tokenArr[1], ptoken: tokenArr[2])
                
                //开始上号
                
                self.delegate?.lg8xxtokenGetSuccess(withTokenInfo: tokenStr)
                
            }
            else if oprationCode == Int.OP_0003 {
                
               let  error = serv_dic.getValue(key: "result", t: [String:Any].self)?.getValue(key: "error", t: String.self)
                
                if re_open_token == false {
                    
                    re_open_token = true
                    
                    reDoTask()
                    
                }else{
                    
                    self.delegate?.uploadError(socket: self,withMsg: error ?? "OP_0003")
                }
                
                
            }
            //plist方式
            else if oprationCode == Int.OP_0004{
                
                if let result = serv_dic.getValue(key: "result", t: [String:Any].self), let gmtoken = result["gm_token"] as? [String:Any] {
                    
                   qq_skey = result.getValue(key: "qq_skey", t: String.self)
                    
                   SWLGLog(withMsg: "str=====>\(gmtoken)")
                    
                   
                   self.uploadGameTokenInfo(with: gmtoken)
                    //开始上号
                    
                   self.delegate?.lg8xx_plistInfoGetSuccess(with: gmtoken)
                }else{
                    
                    SWLGLog(withMsg: "Plist 数据格式有误")
                }
                
                
                
                
                
            }
            else{
                //未定义code
                
                
                SWLGWarning(withMsg: "socket 未定义操作码逻辑\(oprationCode)")
            }
            
            
        default:
            
            break
        }
        
    }
    
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        
        //状态已数据发送成功为准
        
        switch status {
        case .NONE:
            
            status = .HANDSHAKE
        case .HANDSHAKE:
        
        status = .SENDDATA
        
        default:
            break
        }
        
        sock.readData(withTimeout: -1, tag: 0)
    }
    
    unowned var delegate:SWLg8xProtocol?
    
    var socket:GCDAsyncSocket!
    
    var info:SWQuickLoginGameModel!
    
    var status:SW8xEventType = .NONE
    
    var aes_key:String = "" //
    
    var srv_key:String = ""
    
    var qq_token:String?
    
    var qq_skey:String?
    
    var game_id:String = ""
    
    var game_auth_sign:String? // sign OP_0001 返回 上报接口用到
    
    var upload_source:String = ""
    
    
    var re_open_token:Bool = false
    
    var game_auth_dic:[String:Any] = [:]
    
    var readedData:Data = Data()
    
    lazy var sliderView:AlertHKMideView = {
        
        let slider = AlertHKMideView()
        
        slider.backgroundColor = .clear
        
        slider.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
    
        return slider
    }()
    
    var sliderBackview:CHAlertView?
    
    
    override init() {
        
        super.init()
        
        socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        
        
        
    }
    
    
    /// 重新开始
    func reDoTask() {
        
        status = .NONE
        
        aes_key = SWLGUtils.random128BitAESKey()
        
        guard let host = info.quick_info?.game_auth_address else {
            
            self.delegate?.lg8xxError(withErrorCode: 1, msg: "socket ip 为空")
            return
        }
        guard let pt = info.quick_info?.game_auth_port else {
            
            self.delegate?.lg8xxError(withErrorCode: 1, msg: "socket port 为空")
            return
        }
        
        
        if socket.isConnected == false{
        
            do {
                
                try socket.connect(toHost: host, onPort: UInt16(exactly: pt)!)
               //链接成功 ，开始数据传输
                
                guard let data = _handshake() else {
                    
                    return
                }

                sendData(withData: data)
            } catch {
                
                SWLGError(withMsg: "socket connet error\(error.localizedDescription)")
                self.delegate?.lg8xxError(withErrorCode: 4, msg: "socket connet error")
            }
        }else{
            
            //链接成功 ，开始数据传输
            guard let data = _handshake() else {
                
                self.delegate?.lg8xxError(withErrorCode: 5, msg: "握手包构建失败")
                return
            }
            
            sendData(withData: data)
        }
        
    }
    
    
    /// 开始任务
    /// - Parameter withdic: 必要信息
    func doTask(withdic:SWQuickLoginGameModel) {
        
        info = withdic
        
        aes_key = SWLGUtils.random128BitAESKey()
        
        guard let game_auth = info.quick_info?.game_auth_88.uppercased() else {
            
            self.delegate?.lg8xxError(withErrorCode: 1, msg: "game_auth 为空")
            return
        }
        
        guard let rc4TokenStr = ZSRc4.swRc4Decrypt(withSource: game_auth, rc4Key: game_auth_key) else {
            
            self.delegate?.lg8xxError(withErrorCode: 2, msg: "game_auth rc4 解密失败")
            return
        }
        
        guard let dictoken = try? JSONSerialization.jsonObject(with: rc4TokenStr.data(using: .utf8)!, options: .mutableContainers) else {
            
            self.delegate?.lg8xxError(withErrorCode: 3, msg: "game_auth 解析失败")
            return
        }
        
        SWLGLog(withMsg: "gameAuth88--\(rc4TokenStr)")
        game_auth_dic = dictoken as! [String:Any]
        print("88->game_dic",game_auth_dic)
        guard game_auth_dic.isEmpty == false else {
            
            self.delegate?.lg8xxError(withErrorCode: 1, msg: "game_auth_dic 为空")
            return
        }
        
        
        guard let host = info.quick_info?.game_auth_address else {
            
            self.delegate?.lg8xxError(withErrorCode: 1, msg: "socket ip 为空")
            return
        }
        guard let pt = info.quick_info?.game_auth_port else {
            
            self.delegate?.lg8xxError(withErrorCode: 1, msg: "socket port 为空")
            return
        }
        
        guard status == .NONE else {
            
            return
        }
        if socket.isConnected == false{
        
            do {
                
               try socket.connect(toHost: host, onPort: UInt16(exactly: pt)!)
//                try socket.connect(toHost: "192.168.23.143", onPort: 20003)
               //链接成功 ，开始数据传输
                
                guard let data = _handshake() else {
                    
                    return
                }

                sendData(withData: data)
            } catch {
                
                self.delegate?.lg8xxError(withErrorCode: 4, msg: "socket connet error")
            }
        }else{
            
            //链接成功 ，开始数据传输
            guard let data = _handshake() else {
                
                self.delegate?.lg8xxError(withErrorCode: 5, msg: "握手包构建失败")
                return
            }
            
            sendData(withData: data)
        }
        
        
            
    }
    
    
    func endTask()  {
        
        socket.disconnect()
    }
    
    
    func sendData(withData:Data)  {
         
         socket.write(withData, withTimeout: -1, tag: 0)
    }
    
   
    
}


///处理需要发送的数据
extension SWLg88Socket {
    
    //开通包
    func _open() -> Data? {
        
        let qq_uin =  info.qq
        let password_c = info.quick_info?.game_mm ?? ""
        if password_c.count == 0 {
            
            SWLGWarning(withMsg: "密码为空")
        }
        let userDic:[String:Any] = ["uin":Int(qq_uin)!,"password_c":password_c]
        //88 取deviceInfo
        let devDic = getDeviceInfo()
        
        let dic:[String:Any] = ["op":Int.OP_8001,"usr_info":userDic,"dev_info":devDic]
        
        guard let _data = _operationMsg(content: dic) else {
            
            return nil
        }
        
        return _data
    }
    
    
    func _msgBody(withDic:[String:Any]) -> Data? {
        
        guard var jsonstr = withDic.toJsonString() else {
            
            return nil
        }
        
        jsonstr += "\0"
        
        return jsonstr.data(using: .utf8)
        
    }
    
    ///握手消息 - 发送客户端key到S端
    func _handshake() ->Data? {
        
        let qq = info.qq
        
        guard let quick_identity = info.quick_info?.quick_identity else {
            
            return nil
        }
        
        guard let hid = info.order_info?.hid else {
            
            return nil
        }
        
    
       let str =  RSAUtil.encryptString(aes_key, publicKey: rsa_key) as String
        
        let cln_token = "hid=\(hid)qq=\(qq)&token=\(quick_identity)"
        
        let dic:[String : Any] = ["cln_key":str,"srv_ide":1,"cln_app":SWOtherInfoWrap.shared.appId,"cln_token":cln_token,"cln_dev":APPUUID()]
        
        
        return _msgBody(withDic: dic)
    }
    
    
    
    ///  Commond 消息
    /// - Parameter content: 消息
    /// - Returns: 消息加密
    
    func _operationMsg(content:[String:Any]) -> Data?  {
         
        guard let jsonStr = content.toJsonString() else {
            
            return nil
        }
        
        let enc_str =  DFAES.aes128EncryptECB(jsonStr, key: aes_key)
        
        let sign_str = SWLGUtils.md5ForBytes(toLower32Bate: enc_str) as String
        
        var param:[String:Any] = [:]
        
        param["time"] = String.timeIntervalChangeToTimeStr(timeInterval: NSDate().timeIntervalSince1970)
        
        param["data"] = enc_str
        param["sign"] = sign_str
        
        print("将要发送的包",param)
        return _msgBody(withDic: param)
        
        
    }
    
    
    
    
    /**
     8.8 获取游戏数据，进行上报
     */
    func uploadGameTokenInfo(withAtoken:String,openid:String,ptoken:String)  {
        
        var param:[String:Any] = [:]
        param["hid"] = info.order_info?.hid
        
        //订单id
        param["order_id"] = info.order_info?.orderid
        
        param["source"] = upload_source
        
        param["err_times"] = 0
        
        param["quick_version"] = "5"
        
        param["order_login"] = info.quick_info?.order_login
        
        let tokenInfo:[String:Any] = ["ptoken":ptoken,"openid":openid,"atoken":withAtoken,"current_uin":openid,"platform":"qq_m","qq_skey":qq_skey ?? ""]
        
       let rc4Str = ZSRc4.swRc4Encrypt(withSource: tokenInfo.toJsonString()!, rc4Key: game_auth_key)
        
       param["login_token"] = rc4Str
        
        if re_open_token {
            //88 取deviceInfo
            var  game_dic:[String:Any] = ["qtoken":qq_token as Any,"deviceinfo":getDeviceInfo(),"qq":game_auth_dic["qq"]!]
            if let sign = game_auth_sign {
                
                game_dic["sign"] = sign
            }
            let rc4Str = ZSRc4.swRc4Encrypt(withSource: game_dic.toJsonString()!, rc4Key: game_auth_key)
            
            param["game_auth"] = rc4Str
            param["remark"] = "上号端重新开通,成功"
            
        }else{
            
            param["remark"] = "上号成功"
        }
        
        SWNetworkingTool.requestFun(url:  SW_API_SETTOKENSOFT, method: .post, parameters: param) { (json) in
            
        } failBlock: { (error) in
           
        }

        
    }
    
    /**
     8.8 获取游戏数据，进行上报
     {\"access_token\":\"E92C3623BC44AED2DA7273BDFE7D0286\",\
     "encrytoken\":\"be929b1bc4fdcbcb7e87b484025a019c\",
     \"expires_in\":7776000,\
     "openid\":\"1C7BC3D2A82C56B95130125A15522844\",\
     "pay_token\":\"0B69F8440FAD787E510781DB4CEA0D81\",
     \"pf\":\"openmobile_ios\"
     ,\"pfkey\":\"b756d1a9315bcced74d6872efb2f4b6d\"}
     */
    func uploadGameTokenInfo(with:[String:Any])  {
        
        var param:[String:Any] = [:]
        param["hid"] = info.order_info?.hid
        
        //订单id
        param["order_id"] = info.order_info?.orderid
        
        param["source"] = upload_source
        
        param["err_times"] = 0
        
        param["quick_version"] = "5"
        
        param["order_login"] = info.quick_info?.order_login
        
        let ptoken = with["pay_token"] as? String ?? ""
        let openid =  with["openid"] as? String ?? ""
        let withAtoken = with["access_token"] as? String ?? ""
        let pf = with["pf"] as? String ?? ""
        let pfkey = with["pfkey"] as? String ?? ""
        let expires_in = with["expires_in"] as? Int ?? 0
        let encrytoken = with["encrytoken"] as? String ?? ""
        
        let tokenInfo:[String:Any] = ["ptoken":ptoken,"openid":openid,"atoken":withAtoken,"current_uin":openid,"platform":"qq_m","qq_skey":qq_skey ?? "","pf":pf,"pfkey":pfkey,"expires_in":expires_in,"encrytoken":encrytoken]
        
        let rc4Str = ZSRc4.swRc4Encrypt(withSource: tokenInfo.toJsonString()!, rc4Key: game_auth_key)
        
        param["login_token"] = rc4Str
        
        if re_open_token {
            //88 取deviceInfo
            var game_dic:[String:Any] = ["qtoken":qq_token as Any,"deviceinfo":getDeviceInfo(),"qq":game_auth_dic["qq"]!]
            
            if let sign = game_auth_sign {
                
                game_dic["sign"] = sign
            }
            let  rc4Str = ZSRc4.swRc4Encrypt(withSource: game_dic.toJsonString()!, rc4Key: game_auth_key)
            param["game_auth"] = rc4Str
            param["remark"] = "上号端重新开通,成功"
            
        }else{
            
            param["remark"] = "上号成功"
        }
        
        SWNetworkingTool.requestFun(url:  SW_API_SETTOKENSOFT, method: .post, parameters: param) { (json) in
            
        } failBlock: { (error) in
           
        }

        
    }
    
    //MARK: 兼容devideinfo 和deviceinfo88
    func getDeviceInfo() -> Any {
        
        if let info = game_auth_dic["deviceinfo"]  {
            
            SWLGLog(withMsg: "deviceinfo \(info)")
            return info
        }
        
        else if let info88 = game_auth_dic["deviceinfo88"]
        {
            SWLGLog(withMsg: "deviceinfo88 \(info88)")
            return info88
            
        }else{
            
            return ""
        }
         
    }
}


extension SWLg84Socket:SWLg8xSocketProtocol {
    
}

extension SWLg88Socket:SWLg8xSocketProtocol {
    
    
}



