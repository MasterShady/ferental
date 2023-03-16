//
//  Poster.swift
//  ferental
//
//  Created by 刘思源 on 2023/3/16.
//

import Foundation
import JXPhotoBrowser
import MobileCoreServices
import AVFoundation
import AVKit


class Poster : BaseView, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    let container = UIView()
    let layoutWidth: CGFloat //布局宽度, 间距自适应
    let itemSize: CGFloat
    
    init(layoutWidth: CGFloat, itemSize: CGFloat) {
        self.layoutWidth = layoutWidth
        self.itemSize = itemSize
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var posters: [(type:Int, image:UIImage, url: URL?)] = []{
        didSet{
            updateUI()
        }
    }
    
    override func configSubviews() {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalTo(insets)
        }
        updateUI()
    }
    
    func updateUI(){
        container.removeSubviews()
        let countPerRow = 4
        let itemSpacing = (layoutWidth - itemSize * countPerRow) / (countPerRow - 1)
        
        for i in 0...posters.count{
            let row = i / 4
            let line = i % 4
            let item =  UIImageView()
            item.chain.backgroundColor(.kExLightGray).corner(radius: 4).clipsToBounds(true).contentMode(.scaleAspectFill).userInteractionEnabled(true)
            
            container.addSubview(item)
            item.snp.makeConstraints { make in
                make.top.equalTo(row * (itemSpacing + itemSize))
                make.left.equalTo(line * (itemSpacing + itemSize))
                make.width.height.equalTo(itemSize)
            }
     
            if i == posters.count{
                item.image = .init(named: "fb_add")
                item.contentMode = .center
                item.chain.tap {
                    self.selectMedia()
                }
                item.snp.makeConstraints { make in
                    make.bottom.equalToSuperview()
                }
            }else{
                let type = self.posters[i].type
                
                item.image = posters[i].image
                item.contentMode = .scaleAspectFill
                let deleteBtn = UIButton()
                item.addSubview(deleteBtn)
                deleteBtn.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.right.equalTo(-3)
                }
                deleteBtn.chain.normalImage(.init(named: "fb_delete")).addAction {[weak self] _ in
                    self?.posters.remove(at: i)
                }
                
                if (type == 1){
                    let playIcon = UIImageView()
                    playIcon.image = .init(named: "fb_play")
                    item.addSubview(playIcon)
                    playIcon.snp.makeConstraints { make in
                        make.center.equalToSuperview()
                    }
                }
                
                item.chain.tap {
                    
                    if type == 0{
                        let browser = JXPhotoBrowser()
                        // 浏览过程中实时获取数据总量
                        browser.numberOfItems = {
                            1
                        }
                        // 刷新Cell数据。本闭包将在Cell完成位置布局后调用。
                        browser.reloadCellAtIndex = { [weak self] context in
                            guard let self = self else {return}
                            let browserCell = context.cell as? JXPhotoBrowserImageCell
                            browserCell?.imageView.image = self.posters[i].image
                        }
                        browser.show()
                    }else{
                        if let url = self.posters[i].url{
                            self.playVideo(at: url)
                        }
                        
                    }
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let mediaType = info[.mediaType] as? String {
                if mediaType == kUTTypeMovie as String {
                    // 选择了视频
                    if let videoURL = info[.mediaURL] as? URL {
                        if let image = self.generateThumbnail(for: videoURL){
                            posters.append((1,image,videoURL))
                        }
                    }
                } else if mediaType == kUTTypeImage as String {
                    let image = info[.originalImage] as! UIImage
                    posters.append((0,image,nil))
                }
            }
        
        picker.dismiss(animated: true)

    }
    
    func selectMedia(){
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(.init(title: "拍摄照片", style: .default, handler: {[weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            self?.viewController?.present(picker, animated: true)
        }))
        
        
        sheet.addAction(.init(title: "拍摄视频", style: .default, handler: {[weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.delegate = self
            self?.viewController?.present(picker, animated: true)
        }))
        
        sheet.addAction(.init(title: "从相册中选择", style: .default, handler: {[weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self?.viewController?.present(picker, animated: true)
        }))
        
        sheet.addAction(.init(title: "取消", style: .cancel))
        self.viewController?.present(sheet, animated: true)
    }
    
    
    func generateThumbnail(for videoURL: URL) -> UIImage? {
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
        var actualTime = CMTime.zero
        do {
            let image = try imageGenerator.copyCGImage(at: time, actualTime: &actualTime)
            return UIImage(cgImage: image)
        } catch {
            print(error)
            return nil
        }
    }
    
    func playVideo(at url: URL) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.viewController?.present(playerViewController, animated: true) {
            player.play()
        }
    }
    
}
