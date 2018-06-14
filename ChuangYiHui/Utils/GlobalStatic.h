
// 颜色
#define COLOR(r, g, b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1])
#define COLOR_A(r, g, b, a) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])
#define MAIN_COLOR COLOR(0, 139, 230)
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define kScreen_Bounds [UIScreen mainScreen].bounds
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define TAB_HEIGHT 49
#define NAV_HEIGHT 64
#define STATUS_HEIGHT 20
#define SEGMENT_HEIGHT 50 

#define GOOD_DETAIL_LEFT_EDGE 0
#define GOOD_DETAIL_TOP_EDGE 0


#define BG_MAIN_COLOR COLOR(249, 249, 249)

//#define LINE_COLOR COLOR(197.0, 203.0, 213.0)
#define LINE_COLOR COLOR(239.0, 239.0, 239.0)

#define DARK_FONT_COLOR COLOR(73.0, 79.0, 85.0)
#define LIGHT_FONT_COLOR COLOR(139.0, 155.0, 171.0)

#define MONDAY_COLOR COLOR(240.0, 102.0, 102.0)
#define TUESDAY_COLOR COLOR(240.0, 190.0, 102.0)
#define WEDNESDAY_COLOR COLOR(102.0, 240.0, 108.0)
#define THURSDAY_COLOR COLOR(193.0, 102.0, 240.0)
#define FRIDAY_COLOR COLOR(102.0, 134.0, 240.0)
#define SATURDAY_COLOR COLOR(173.0, 240.0, 102.0)
#define SUNDAY_COLOR COLOR(240.0, 102.0, 190.0)


//原本气泡的颜色
//绿
#define FIRST_COLOR COLOR(135.0, 229.0, 83.0)
//棕
#define SECOND_COLOR COLOR(229.0, 145.0, 83.0)
//蓝
#define THIRD_COLOR COLOR(102.0, 134.0, 240.0)
//红
#define FOURTH_COLOR COLOR(240.0, 102.0, 102.0)
//黄
#define FIFTH_COLOR COLOR(240.0, 209.0, 102.0)

// 16进制转换RGB
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


//sip服务器IP
#define SIP_SERVER @"119.90.53.251"

//sip服务器端口
#define SIP_PORT @"5060"
//sip代理服务器地址
#define PROXY_SERVER  [NSString stringWithFormat: @"%@:%@", SIP_SERVER, SIP_PORT]

#define UmengAppkey   @"575e566167e58e96ba000a2b"
#define WXAppId  @"wx38895a8a7e25a948"

//还需要添加到 URL schemes 
#define WXAppSecret @"432e3e90fb97ba18ff59bd7e7fb7f294"
#define WXUrl URL_SHARE_URL

//快递100
#define CustomerID @"029CD38D3DA36AD2E9CB8289C663AB0D"
#define CustomerKey @"IpBuAyOz1844"

//蒲公英appId
#define PgyerAppId @"5538d7bb1b062851292ced85e8920e97"

//融云AppKey
#define RongYunAppkey @"pkfcgjstprfb8"


#define kAdTypeMyWealth  0
#define kAdTypeOfficialRecharge 1
#define kAdTypePOS 2
#define kAdTypeLoan 3
#define kAdTypeManageMoney 4
#define kAdTypeOperateCenter 5
#define kAdTypeJiaLianPay 6
#define kAdTypeShare 7

typedef NS_ENUM(NSInteger, DisplayType) {
    User_Friends,
    User_Followed,
    User_Follower,
    User_Score,
    User_Friend_Invitation,
    User_Team_Invitation,
    User_Followed_Team,
    User_Followed_User,
    User_Comments,
    User_Event_Comments,
    Team_Event_Comments,
    Team_Visitors,
    Team_Member_Requests,
    Team_Achievements,
    Activity_Comments,
    Competition_Comments,
};





