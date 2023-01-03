//
//  SelectItemView.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/9.
//

import UIKit
import Combine

class SelectItemView: UIView {
    
    private static let kLongText = "这是一段很长的文本,用来计算自动布局时,Button中Label的最大宽度,然后二次调整Image的偏移量, 否则当文字过长需要被裁剪时,图片偏移量会计算错误"
    
    var cancellables = Set<AnyCancellable>()
    
    var valueBtn : UIButton?
    
    var value : String?{
        set{
            if let valueBtn = valueBtn{
                //这里的图片偏移需要获取文本的最大布局宽度后二次计算
                valueBtn.chain.title(text: SelectItemView.kLongText, for: .normal)
                valueBtn.setImagePosition(.right, spacing: 8)
                valueBtn.layoutIfNeeded()
                let maxTitleLayoutW = valueBtn.titleLabel!.width
                
                if let newValue = newValue, newValue.count > 0{
                    valueBtn.chain.title(text: newValue, for: .normal).titleColor(color: UIColorFromHex("333333"), for: .normal)
                    valueBtn.setImagePosition(.right, maxTitleLayoutW: maxTitleLayoutW, spacing: 8)
                }else{
                    valueBtn.chain.title(text: "请选择", for: .normal).titleColor(color: UIColorFromHex("#D4D5DB"), for: .normal)
                    valueBtn.setImagePosition(.right, maxTitleLayoutW: maxTitleLayoutW, spacing: 8)
                }
            }

        }
        get{
            return valueBtn?.title(for: .normal)
        }
    }
    
    override func layoutSubviews() {
        
    }

    init(config:(title:String,defaultValue:String?), clickHandler:(@escaping ()->Void)){
        super.init(frame: .zero)
        self.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        let label = UILabel()
        self.addSubview(label)
        label.chain.text(config.title).font(.boldSystemFont(ofSize: 14)).text(color: .kTextBlack)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        valueBtn = UIButton()
        self.addSubview(valueBtn!)
        valueBtn?.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-14)
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(label.snp.right).offset(10)
        }
        valueBtn?.chain.title(front: .boldSystemFont(ofSize: 15)).normalImage(.init(named: "arrow_right"))
        valueBtn?.titleLabel?.lineBreakMode = .byTruncatingTail
        
        valueBtn?.addBlock(for: .touchUpInside, block: { _ in
            clickHandler()
        })
        
        self.value = config.defaultValue
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
