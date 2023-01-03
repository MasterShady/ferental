//
//  BrandVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/8.
//

import Foundation
import UIKit

class BrandVC : BaseVC{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    override func configSubViews() {
        
        
        let brandLabel = UILabel()
        view.addSubview(brandLabel)
        brandLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp_topMargin)
            make.left.equalTo(14)
        }
        let raw = "品牌  大牌游戏设备云集"
        let brandText = "品牌"
        let attrText = NSMutableAttributedString(string: raw, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#1D1E21")!,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)
        ])
        
        attrText.setAttributes([
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#1D1E21")!,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)
        ], range: (raw as NSString).range(of: brandText))
        
        brandLabel.attributedText = attrText
        
        view.addSubview(computerBrandView)
        computerBrandView.snp.makeConstraints { make in
            make.top.equalTo(brandLabel.snp.bottom).offset(19)
            make.left.equalTo(14)
            make.right.equalTo(-14)
        }
        
        view.addSubview(phoneBrandView)
        phoneBrandView.snp.makeConstraints { make in
            make.top.equalTo(computerBrandView.snp.bottom).offset(8)
            make.left.equalTo(14)
            make.right.equalTo(-14)
        }
        
    }
    
    
    
    lazy var computerBrandView: UIView = {
        let view = UIView()
        view.chain.backgroundColor(.white).corner(radius: 4).clipsToBounds(true)
        let header = UIView()
        view.addSubview(header)
        header.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        header.backgroundColor = .init(hexString: "#C1F00C")
        
        let titleBtn = UIButton()
        header.addSubview(titleBtn)
        titleBtn.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
        }
        titleBtn.chain.normalImage(.init(named: "brand_computer")).normalTitle(text: "租游戏本").font(.boldSystemFont(ofSize: 16)).normalTitleColor(color: .init(hexColor: "#1D1E21"))
        titleBtn.setImagePosition(.left, spacing: 7)
        
        let container = UIView()
        view.addSubview(container)
        
        let HInset = 26.0
        let VInset = 16.0
        let HSpacing = 34.0
        let VSpacing = 25.0
        let containerW = kScreenWidth - 14 * 2
        let containerH = 190.0
        
        container.snp.makeConstraints { make in
            make.height.equalTo(containerH)
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(header.snp_bottomMargin)
        }
        
        let layoutW = containerW - HInset * 2
        let layoutH = containerH - VInset * 2

        let itemW = (layoutW - HSpacing * 3) / 4
        let itemH = (layoutH - VSpacing) / 2
        
        for (i, brand) in AppData.computeBrands.enumerated(){
            let row = i / 4
            let line = i % 4
            let offsetX = (itemW + HSpacing) * line
            let offsetY = (itemH + VSpacing) * row
            let itemView = UIView(frame:CGRect(x: HInset + offsetX, y: VInset + offsetY, width: itemW, height: itemH))
            itemView.chain.tap { [weak self] in
                let vc =  DeviceListVC(brand: brand)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            container.addSubview(itemView)
            let brandIcon = UIImageView()
            itemView.addSubview(brandIcon)
            brandIcon.snp.makeConstraints { make in
                make.top.centerX.equalToSuperview()
                make.size.equalTo(CGSize(width: 50, height: 50))
            }
            brandIcon.contentMode = .scaleAspectFit
            brandIcon.kf.setImage(with: URL(string: brand.icon))
            
            let branNameLabel = UILabel()
            itemView.addSubview(branNameLabel)
            branNameLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            branNameLabel.chain.font(.systemFont(ofSize: 12)).text(color: .init(hexColor: "585960")).text(brand.name)
            
        }
        
        return view
    }()
    
    lazy var phoneBrandView: UIView = {
        let view = UIView()
        view.chain.backgroundColor(.white).corner(radius: 4).clipsToBounds(true)
        let header = UIView()
        view.addSubview(header)
        header.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        header.backgroundColor = .init(hexString: "#1D1E21")
        
        let titleBtn = UIButton()
        header.addSubview(titleBtn)
        titleBtn.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
        }
        titleBtn.chain.normalImage(.init(named: "brand_phone")).normalTitle(text: "租游戏手机").font(.boldSystemFont(ofSize: 16)).normalTitleColor(color: .white)
        titleBtn.setImagePosition(.left, spacing: 7)
        
        let container = UIView()
        view.addSubview(container)
        
        let HInset = 26.0
        let VInset = 16.0
        let HSpacing = 34.0
        let VSpacing = 25.0
        let containerW = kScreenWidth - 14 * 2
        let containerH = 190.0
        
        container.snp.makeConstraints { make in
            make.height.equalTo(containerH)
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(header.snp_bottomMargin)
        }
        
        let layoutW = containerW - HInset * 2
        let layoutH = containerH - VInset * 2

        let itemW = (layoutW - HSpacing * 3) / 4
        let itemH = (layoutH - VSpacing) / 2
        
        for (i, brand) in AppData.phoneBrands.enumerated(){
            let row = i / 4
            let line = i % 4
            let offsetX = (itemW + HSpacing) * line
            let offsetY = (itemH + VSpacing) * row
            let itemView = UIView(frame:CGRect(x: HInset + offsetX, y: VInset + offsetY, width: itemW, height: itemH))
            container.addSubview(itemView)
            let brandIcon = UIImageView()
            itemView.addSubview(brandIcon)
            brandIcon.snp.makeConstraints { make in
                make.top.centerX.equalToSuperview()
                make.size.equalTo(CGSize(width: 50, height: 50))
            }
            brandIcon.contentMode = .scaleAspectFit
            brandIcon.kf.setImage(with: URL(string: brand.icon))
            
            let branNameLabel = UILabel()
            itemView.addSubview(branNameLabel)
            branNameLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            branNameLabel.chain.font(.systemFont(ofSize: 12)).text(color: .init(hexColor: "585960")).text(brand.name)
            
        }
        
        return view
    }()
    
}

