//
//  UIViewExt.swift
//  DoFunNew
//
//  Created by mac on 2021/2/25.
//

import UIKit

// MARK: - 坐标和宽高

public extension UIView {
    
    //MARK：添加渐变色图层
    func gradientColor(_ startPoint: CGPoint, _ endPoint: CGPoint, _ colors: [Any]) {
        guard startPoint.x >= 0, startPoint.x <= 1, startPoint.y >= 0, startPoint.y <= 1, endPoint.x >= 0, endPoint.x <= 1, endPoint.y >= 0, endPoint.y <= 1 else {
                    return
                }
                
                // 外界如果改变了self的大小，需要先刷新
                layoutIfNeeded()
                
                var gradientLayer: CAGradientLayer!
                
                removeGradientLayer()

                gradientLayer = CAGradientLayer()
                gradientLayer.frame = self.layer.bounds
                gradientLayer.startPoint = startPoint
                gradientLayer.endPoint = endPoint
                gradientLayer.colors = colors
                gradientLayer.cornerRadius = self.layer.cornerRadius
                gradientLayer.masksToBounds = true
                // 渐变图层插入到最底层，避免在uibutton上遮盖文字图片
                self.layer.insertSublayer(gradientLayer, at: 0)
                self.backgroundColor = UIColor.clear
                // self如果是UILabel，masksToBounds设为true会导致文字消失
                self.layer.masksToBounds = false
    }
    
    // MARK: 移除渐变图层
    // （当希望只使用backgroundColor的颜色时，需要先移除之前加过的渐变图层）
    func removeGradientLayer() {
            if let sl = self.layer.sublayers {
                for layer in sl {
                    if layer.isKind(of: CAGradientLayer.self) {
                        layer.removeFromSuperlayer()
                    }
                }
            }
        }
    
    
    
    //MARK: - UIView转UIImage
    func getImageFromView() -> UIImage {
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        self.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    
    var origin: CGPoint{
        get{
            return frame.origin
        }
        set{
            self.frame.origin = newValue
        }
    }
    
    var size: CGSize{
        get{
            return frame.size
        }
        set{
            self.frame.size = newValue
        }
    }
    
    var bottomRight: CGPoint{
        let x = frame.origin.x + frame.size.width;
        let y = frame.origin.y + frame.size.height;
        return CGPoint(x: x, y: y);
    }
    
    var bottomLeft: CGPoint{
        let x = frame.origin.x;
        let y = frame.origin.y + frame.size.height;
        return CGPoint(x: x, y: y);
    }
    
    var topRight: CGPoint{
        let x = frame.origin.x + frame.size.width;
        let y = frame.origin.y;
        return CGPoint(x: x, y: y);
    }
    
    
    var width: CGFloat{
        get{
            return frame.size.width
        }
        set{
            self.frame.size.width = newValue
        }
    }
    
    var height: CGFloat{
        get{
            return frame.size.height
        }
        set{
            self.frame.size.height = newValue
        }
    }
    
    var top: CGFloat{
        get{
            return frame.origin.y
        }
        set{
            self.frame.origin.y = newValue
        }
    }
    
    var left: CGFloat{
        get{
            return frame.origin.x
        }
        set{
            self.frame.origin.x = newValue
        }
    }
    
    var bottom: CGFloat{
        get{
            return frame.origin.y + frame.size.height
        }
        set{
            self.frame.origin.y = newValue - frame.size.height
        }
    }
    
    var right: CGFloat{
        get{
            return frame.origin.x + frame.size.width
        }
        set{
            self.frame.origin.x = newValue - frame.size.width
        }
    }
    
    var centerX: CGFloat{
        get{
            return frame.origin.x + frame.size.width/2
        }
        set{
            self.frame.origin.x = newValue - frame.size.width/2
        }
    }
    
    var centerY: CGFloat{
        get{
            return frame.origin.y + frame.size.height/2
        }
        set{
            self.frame.origin.y = newValue - frame.size.height/2
        }
    }
    
    
    
    
    //view指定位置圆角
    func addCorner(conrners:UIRectCorner, radius:CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
}

