//
//  trd.m
//  DoFunNew
//
//  Created by mac on 2021/11/8.
//

#import "OC_Const.h"

NSString* fontName(FONT_TYPE tp){
    switch (tp) {
        case FONT_TYPE_REGULAR:{
            return @"PingFangSC-Regular";
        }
            break;
        case FONT_TYPE_MEDIUM:{
            return @"PingFangSC-Medium";
        }
            break;
        case FONT_TYPE_LIGHT:{
            return @"PingFangSC-Light";
        }
            break;
        case FONT_TYPE_DISPLAY:{
            return @".SFNSDisplay";
        }
            break;
        case FONT_TYPE_BOLD:{
            return @"PingFangSC-Semibold";
        }
        case FONT_RM_MEDIUM:{
            return @"RobotoMedium-Medium";
        }
            break;
        default:
            break;
    }
}

/*
 比例计算高度(宽度)
 */
CGFloat SCALE_WIDTHS(CGFloat value)
{
    return value * BASE_WIDTH_SCALE;
    
   
}

CGFloat SCALE_HEIGTHS(CGFloat value)
{
    return value * BASE_WIDTH_SCALE;
   // return BASE_WIDTH_SCALE == 1 ? value : value * BASE_HEIGHT_SCALE;
}
UIFont* DFFont(CGFloat size, FONT_TYPE tp){
    UIFont* font = [UIFont fontWithName:fontName(tp) size:size*BASE_WIDTH_SCALE];
    if(!font){
        font = [UIFont systemFontOfSize:size*BASE_WIDTH_SCALE];
    }
    return font;
}

