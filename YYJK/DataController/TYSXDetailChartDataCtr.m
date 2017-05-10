//
//  TYSXDetailChartDataCtr.m
//  tysx
//
//  Created by zwc on 13-12-17.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "TYSXDetailChartDataCtr.h"
#import "NSString+JSONCategory.h"
#import "MKNetworkEngine.h"

@implementation TYSXDetailChartDataCtr
@synthesize selectedRow;
@synthesize selectedSection;

- (id)init {
    if (self = [super init]) {
       // NSLog(@"%@", [self yunying]);
    }
    
    return self;
}

- (NSArray *)hezuoadd {
    return @[
             @[@"渠道名称", @"当日新增数", @"环比"],
             @[@"央广_天和天达_娱乐频道", @"2672", @"514"],
             @[@"凤凰_互联星空_凤凰VIP", @"100", @"43"],
             @[@"央视国际_青岛海信通信_CCTV", @"54", @"7"],
             @[@"营销活动_备用8_天翼视讯", @"36", @"36"],
             @[@"营销活动_凤凰V视1_天翼视讯", @"26", @"18"],
             @[@"电信孵化基地_股票老左推广1_股票老左", @"13", @"13"],
             @[@"央视国际_CCTV_CCTV综合", @"12", @"-1"],
             @[@"新浪_视频频道_电影_天翼视讯", @"11", @"2"],
             @[@"央视国际_CCTV体育_CCTV体育", @"9", @"4"],
             @[@"国视通讯（北京）有限公司_博硕_中国影视院线", @"8", @"3"],
             ];
}

- (NSArray *)hezuounadd{
    return @[
             @[@"渠道名称", @"当日新增数", @"环比"],
             @[@"央广_天和天达_娱乐频道", @"445", @"341"],
             @[@"凤凰_互联星空_凤凰VIP", @"139", @"-127"],
             @[@"省公司专用渠道_宁夏电信_全能看", @"128", @"116"],
             @[@"央广视讯_网鑫科技_央广手机台", @"100", @"-87"],
             @[@"杭州平治_话匣子听书首屏_听电视", @"99", @"-108"],
             @[@"凤凰新媒体_手凤网_凤凰V视", @"62", @"-81"],
             @[@"北方新媒体_南京勒海_天翼视讯游戏频道", @"58", @"-34"],
             @[@"芒果TV_省公司推广_芒果TV", @"57", @"-33"],
             @[@"央视国际_全国21省_体育频道", @"51", @"-56"],
             @[@"天翼视讯_手机凤凰网_数字院线", @"49", @"-48"],
             ];
}

- (NSArray *)pingtai{
return @[
         @[@"渠道名称", @"订购转化率", @"使用率", @"退订率", @"订购数量"],
         @[@"客户端3.1预装渠道_客户端预装_天翼视讯", @"4.9%", @"527%", @"35%", @"3213"],
         @[@"默认客户端", @"5.0%", @"480%", @"70%", @"2489"],
         @[@"WAP门户", @"0.3%", @"11839%", @"103%", @"727"],
         @[@"客户端4.0预装渠道_客户端预装_天翼视讯", @"2.1%", @"887%", @"22%", @"412"],
         @[@"视讯推广_360软件市场新客户端_天翼视讯", @"2.0%", @"2116%", @"32%", @"320"],
         @[@"央视国际_校园活动华为_CCTV三合一子客户端", @"1.9%", @"321%", @"37%", @"206"],
         @[@"天翼视讯_校园活动华为_数字院线", @"2.1%", @"588%", @"28%", @"152"],
         @[@"视讯推广_安智市场新客户端_天翼视讯", @"2.3%", @"1729%", @"41%", @"111"],
         @[@"视讯推广_百度市场新客户端_天翼视讯", @"2.7%", @"1606%", @"33%", @"93"],
         @[@"视讯中心_互联星空推广_天翼视讯", @"3.8%", @"1160%", @"36%", @"55"],
         ];
}

- (NSArray *)hezuo {
    return @[
             @[@"渠道名称", @"订购转化率", @"使用率", @"退订率", @"订购数量"],
             @[@"央广_天和天达_娱乐频道", @"75.5%", @"0%", @"17%", @"2672"],
             @[@"凤凰_互联星空_凤凰VIP", @"0.4%", @"9%", @"139%", @"100"],
             @[@"央视国际_青岛海信通信_CCTV", @"2.1%", @"404%", @"30%", @"54"],
             @[@"营销活动_备用8_天翼视讯", @"75.0%", @"8%", @"0%", @"36"],
             @[@"营销活动_凤凰V视1_天翼视讯", @"144.4%", @"4%", @"8%", @"26"],
             @[@"电信孵化基地_股票老左推广1_股票老左", @"16.9%", @"92%", @"15%", @"13"],
             @[@"央视国际_CCTV_CCTV综合", @"2.3%", @"300%", @"50%", @"12"],
             @[@"新浪_视频频道_电影_天翼视讯", @"2.3%", @"18%", @"27%", @"11"],
             @[@"央视国际_CCTV体育_CCTV体育", @"5.1%", @"289%", @"33%", @"9"],
             @[@"国际通讯（北京）有限公司_博硕_中国影视院线", @"0.8%", @"325%", @"63%", @"8"],
             ];
}

- (NSArray *)hezuoTop {
    return @[
             @[@"渠道名称", @"当日用户登录用户数", @"环比"],
             @[@"凤凰_互联星空_凤凰VIP", @"26204", @"3251"],
             @[@"广州微服_宜搜_掌中微视", @"24743", @"-977"],
             @[@"天翼视讯内容部_安信证券金融_股票老左", @"16598", @"-1667"],
             @[@"互联星空视频频道_视频首页_天翼视讯", @"6379", @"-287"],
             @[@"央广_天和天达_娱乐频道", @"3539", @"907"],
             @[@"北京搜狐新时代信息服务有限公司_手机搜狐网_搜狐视频", @"3059", @"7"],
             @[@"央视国际_青岛海信通信_CCTV", @"2588", @"21"],
             @[@"天翼视讯市场部_美丽传说掌上猫扑_数字院线", @"1841", @"-2917"],
             @[@"新浪_新浪首页推荐位_天翼视讯", @"1598", @"-10"],
             @[@"新华视讯_新闻早晚报_新华社电视", @"1252", @"-1503"],
             ];
}

- (NSArray *)pingtaiTop {
    return @[
             @[@"渠道名称", @"当日用户登录用户数", @"环比"],
             @[@"WAP门户", @"237751", @"-11526"],
             @[@"客户端3.1预装渠道_客户端预装_天翼视讯", @"66037", @"1388"],
             @[@"默认客户端", @"49566", @"23"],
             @[@"客户端4.0预装渠道_客户端预装_天翼视讯", @"19449", @"-17"],
             @[@"视讯推广_360软件市场新客户端_天翼视讯", @"16325", @"-741"],
             @[@"央视国际_校园活动华为_CCTV三合一子客户端", @"10962", @"468"],
             @[@"天翼视讯_校园活动华为_数字院线", @"7258", @"392"],
             @[@"视讯中心_随便看5.0客户端自有渠道推广_天翼视讯", @"5706", @"5584"],
             @[@"互联星空_集团_all_新闻", @"5349", @"-390"],
             @[@"信元公众信息发展有限责任公司_互联星空_游戏_天翼视讯", @"4934", @"-315"],
             ];
}

- (NSArray *)summaryStrings {
   return @[
      @"①门户自然渠道：新增8589（+1344↓），退订4318（-3699↓）；",
      @"②合作推广渠道：新增2975（+615↑），退订2503（-1566↓）；",
      @"③2月28日、3月1日门户自然渠道新增有较大增幅，环比27日增幅+2041，主要来自渠道“00000020 客户端3.1预装渠道_客户端预装_天翼视讯”3212（+873↑）产品包主要是：随心看·天翼视讯实惠包 1556（+446↑），“029999 默认客户端”2489（+506↑），产品包主要是全能看（自订购）556（+202↑）、资讯频道207（+150↑）、影视频道241（+124↑）、动漫频道162（+110↑）以垂直频道为主；",
      @"④28日为月末门户自然渠道退订增幅，当日回跌。主要来自渠道“029999 默认客户端”1733（-1603↓）退订的产品以自营产品为主，其中全能看（自订购）359（-318↓）；“00000020 客户端3.1预装渠道_客户端预装_天翼视讯”1132（-818↓）产品以随心看·天翼视讯实惠包为主529（-334↓）；“019999 WAP门户”752（-750↓）产品分布较为分散，退订降幅最多的是：随心看·天翼视讯实惠包130（-69↓）、影视频道61（-85↓）；",
      @"⑤环比28日合作推广渠道新增增幅，主要来自渠道“100300050101000 央广_天和天达_娱乐频道”2672（+514↑）；",
      @"⑥28日合作推广渠道退订增幅，当日绝大多数渠道回落，回落最多的渠道”10320511 凤凰_互联星空_凤凰VIP“139（-127↓），渠道”10970111 杭州平治_话匣子听书首屏_听电视“99（-108↓）。"
      ];
//    return @"①门户自然渠道：新增8589（+1344↓），退订4318（-3699↓）；\n\n②合作推广渠道：新增2975（+615↑），退订2503（-1566↓）；\n③2月28日、3月1日门户自然渠道新增有较大增幅，环比27日增幅+2041，主要来自渠道“00000020 客户端3.1预装渠道_客户端预装_天翼视讯”3212（+873↑）产品包主要是：随心看·天翼视讯实惠包 1556（+446↑），“029999 默认客户端”2489（+506↑），产品包主要是全能看（自订购）556（+202↑）、资讯频道207（+150↑）、影视频道241（+124↑）、动漫频道162（+110↑）以垂直频道为主；\n④28日为月末门户自然渠道退订增幅，当日回跌。主要来自渠道“029999 默认客户端”1733（-1603↓）退订的产品以自营产品为主，其中全能看（自订购）359（-318↓）；“00000020 客户端3.1预装渠道_客户端预装_天翼视讯”1132（-818↓）产品以随心看·天翼视讯实惠包为主529（-334↓）；“019999 WAP门户”752（-750↓）产品分布较为分散，退订降幅最多的是：随心看·天翼视讯实惠包130（-69↓）、影视频道61（-85↓）； \n⑤环比28日合作推广渠道新增增幅，主要来自渠道“100300050101000 央广_天和天达_娱乐频道”2672（+514↑）；\n⑥28日合作推广渠道退订增幅，当日绝大多数渠道回落，回落最多的渠道”10320511 凤凰_互联星空_凤凰VIP“139（-127↓），渠道”10970111 杭州平治_话匣子听书首屏_听电视“99（-108↓）。 ";
}

- (NSArray *)ziranAdd {
    return @[
             @[@"0.055", @"0.045", @"0.045", @"0.045", @"0.055", @"0.055", @"0.07"],
             @[@"0.005", @"0.27", @"0.26", @"0.24", @"0.24", @"0.275", @"0.32"],
             @[@"0.19", @"0.16", @"0.15", @"0.16", @"0.19", @"0.23", @"0.25"],
             @[@"0.025", @"0.025", @"0.023", @"0.026", @"0.023", @"0.025", @"0.03"],
             @[@"0.005", @"0.005", @"0.005", @"0.005", @"0.005", @"0.005", @"0.005"],
             @[@"0.1", @"0.125", @"0.115", @"0.115", @"0.125", @"0.15", @"0/175"],
             ];
}

-(NSArray *)ziranUnAdd {
    return @[
             @[@"650", @"950", @"900", @"970", @"990", @"1500", @"700"],
             @[@"660", @"1250", @"1350", @"1450", @"1550", @"1950", @"1200"],
             @[@"1750", @"2250", @"2250", @"2500", @"2750", @"3250", @"1750"],
             @[@"100", @"100", @"100", @"100", @"200", @"200", @"100"],
             @[@"80", @"79", @"76", @"70", @"65", @"60", @"40"],
             @[@"500", @"500", @"600", @"700", @"700", @"1000", @"500"],
             ];
}

- (NSArray *)add {
    return @[
              @[@"0.38", @"0.63", @"0.60", @"0.59", @"0.65", @"0.72", @"0.86"],
              @[@"0.16", @"0.17", @"0.22", @"0.10", @"0.25", @"0.24", @"0.30"]
            ];
}

- (NSArray *)unadd {
    return @[
             @[@"0.38", @"0.50", @"0.51", @"0.58", @"0.64", @"0.80", @"0.43"],
             @[@"0.18", @"0.24", @"0.27", @"0.28", @"0.30", @"0.41", @"0.25"]
             ];
}


- (NSArray *)sectionTitles {
    return [NSArray arrayWithObjects:@"整体情况",@"渠道包月新增情况分析",@"渠道退订情况分析",@"重点产品包渠道推广情况", nil];
}

- (NSString *)lastDate {
    return @"2014-03-01";
}

- (NSArray *)addTen {
    NSMutableArray *retArr = [NSMutableArray array];
    [retArr addObject:[NSArray arrayWithObjects:@"渠道号",@"渠道名称",@"前日新增数",@"当日新增数",@"环比", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"100300050101000",@"央广_天和天达_娱乐频道",@"2158",@"2672",@"514", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"10320511",@"凤凰_互联星空_凤凰VIP",@"57",@"100",@"43", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"10960121",@"央视国际_青岛海信通信_CCTV",@"47",@"54",@"7", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"00313818",@"营销活动_备用8_天翼视讯",@"8",@"26",@"18", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"00312811",@"营销活动_凤凰V视1_天翼视讯",@"76",@"81",@"5", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"01112111",@"电信孵化基地_股票老左推广1_股票老左",@"0",@"13",@"13", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"100290080202000",@"央视国际_CCTV_CCTV综合",@"13",@"12",@"-1", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"10770810",@"新浪_视频频道_电影_天翼视讯",@"9",@"11",@"2", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"100290090203000",@"央视国际_CCTV体育_CCTV体育",@"5",@"9",@"4", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"100010060101000",@"国视通讯（北京）有限公司_博硕_中国影视院线",@"5",@"8",@"3", nil]];
    return retArr;
    
//    NSString *jsonData = @"[[\"000070020100000\",\"信元公众信息发展有限责任公司_互联星空_入口_天翼视讯\",\"0\",\"0\",\"0\"],[\"00310411\",\"营销活动_娱乐1_天翼视讯\",\"0\",\"0\",\"0\"],[\"00932722\",\"天翼视讯_360市场_全能看\",\"0\",\"0\",\"0\"],[\"00932810\",\"天翼视讯_集团活动视讯业务体验竞赛_天翼视讯\",\"0\",\"0\",\"0\"],[\"000130230101000\",\"省公司专用渠道_辽宁电信_全能看\",\"0\",\"0\",\"0\"],[\"000070060101000\",\"互联星空_彩信报_天翼视讯\",\"0\",\"0\",\"0\"],[\"000070080101000\",\"互联星空_奥运_天翼视讯\",\"0\",\"0\",\"0\"],[\"000070010100002\",\"互联星空_集团_all_国学\",\"0\",\"0\",\"0\"],[\"000070100101007\",\"互联星空_推荐7_跨屏\",\"0\",\"0\",\"0\"],[\"00150110\",\"视讯中心WAP PUSH_PUSH0_天翼视讯\",\"0\",\"0\",\"0\"]]";
//    return [jsonData JSONValue];
}

- (NSArray *)unTen {
    NSMutableArray *retArr = [NSMutableArray array];
    [retArr addObject:[NSArray arrayWithObjects:@"渠道号",@"渠道名称",@"前日退订数",@"当日退订数",@"环比", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"100300050101000",@"央广_天和天达_娱乐频道",@"104",@"445",@"341", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"10320511",@"凤凰_互联星空_凤凰VIP",@"266",@"139",@"-127", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"000130220101000",@"省公司专用渠道_宁夏电信_全能看",@"12",@"128",@"116", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"100300140101000",@"央广视讯_网鑫科技_央广手机台",@"187",@"100",@"-87", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"10970111",@"杭州平治_话匣子听书首屏_听电视",@"207",@"99",@"-108", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"10320911",@"凤凰新媒体_手凤网_凤凰V视",@"143",@"62",@"-81", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"10840211",@"北方新媒体_南京勒海_天翼视讯游戏频道",@"92",@"58",@"-34", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"10830311",@"芒果TV_省公司推广_芒果TV",@"90",@"57",@"-33", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"100290060101000",@"央视国际_全国21省_体育频道",@"107",@"51",@"-56", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"00930211",@"天翼视讯_手机凤凰网_数字院线",@"97",@"49",@"-48", nil]];
    return retArr;
//    NSString *jsonData = @"[[\"000070020100000\",\"信元公众信息发展有限责任公司_互联星空_入口_天翼视讯\",\"0\",\"0\",\"0\"],[\"00310411\",\"营销活动_娱乐1_天翼视讯\",\"0\",\"0\",\"0\"],[\"00932722\",\"天翼视讯_360市场_全能看\",\"0\",\"0\",\"0\"],[\"00932810\",\"天翼视讯_集团活动视讯业务体验竞赛_天翼视讯\",\"0\",\"0\",\"0\"],[\"000130230101000\",\"省公司专用渠道_辽宁电信_全能看\",\"0\",\"0\",\"0\"],[\"000070060101000\",\"互联星空_彩信报_天翼视讯\",\"0\",\"0\",\"0\"],[\"000070080101000\",\"互联星空_奥运_天翼视讯\",\"0\",\"0\",\"0\"],[\"000070010100002\",\"互联星空_集团_all_国学\",\"0\",\"0\",\"0\"],[\"000070100101007\",\"互联星空_推荐7_跨屏\",\"0\",\"0\",\"0\"],[\"00150110\",\"视讯中心WAP PUSH_PUSH0_天翼视讯\",\"0\",\"0\",\"0\"]]";
//    return [jsonData JSONValue];
}

- (NSArray *)productPackage1 {
    NSMutableArray *retArr = [NSMutableArray array];
    [retArr addObject:[NSArray arrayWithObjects:@"", @"当日用户登录数", @"环比", @"前日占比渠道登录用户数", @"环比",@"当日播放用户数", @"环比",@"占比渠道总播放数",@"环比", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"垂直频道", @"157568", @"2844", @"48.49%", @"0.0245",@"41356", @"11222",@"54.67%",@"0.0943", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"品牌包", @"36062", @"1101", @"11.10%", @"0.0069",@"14696", @"163",@"19.43%",@"-0.0239", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"跨屏产品", @"66416", @"-9279", @"20.44%", @"-0.0208",@"1496", @"28",@"1.98%",@"-0.0023", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"渠道产品包", @"18969", @"-81", @"5.84%", @"0.017",@"837", @"-14",@"1.11%",@"-0.0017", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"合计", @"279015", @"-5415", @"85.86%", @"0.0123",@"58385", @"11399",@"77.18%",@"0.0664", nil]];
    return retArr;
}

- (NSArray *)productPackage2 {
    NSMutableArray *retArr = [NSMutableArray array];
    [retArr addObject:[NSArray arrayWithObjects:@"", @"当日用户登录数", @"环比", @"前日占比渠道登录用户数", @"环比",@"当日播放用户数", @"环比",@"占比渠道总播放数",@"环比", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"垂直频道", @"26", @"-13", @"3.06%", @"0.0114",@"474", @"-106",@"12.81%",@"-0.0038", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"品牌包", @"151", @"-27", @"17.76%", @"0.0140",@"2355", @"-472",@"63.63%",@"-0.0063", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"跨屏产品", @"430", @"20", @"50.59%", @"0.0645",@"785", @"-109",@"21.21%",@"-0.0089", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"渠道产品包", @"79", @"-22", @"9.29%", @"0.0158",@"87", @"-9",@"2.35%",@"-0.0017", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"合计", @"686", @"-42", @"80.71%", @"0.0234",@"3701", @"-696",@"100.00%",@"0.0005", nil]];
    return retArr;
}

- (NSArray *)productPackage3 {
    //
    NSMutableArray *retArr = [NSMutableArray array];
    [retArr addObject:[NSArray arrayWithObjects:@"", @"平均订购转换率", @"环比", @"平均使用率", @"环比", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"垂直频道", @"0.02%", @"-0.0001", @"159062%", @"817.95", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"品牌包", @"0.42%", @"-0.0009", @"9732%", @"15.68", nil]];
        [retArr addObject:[NSArray arrayWithObjects:@"跨屏产品", @"0.65%", @"0.0011", @"348%", @"-0.10", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"渠道产品包", @"0.42%", @"-0.0011", @"1056%", @"2.17", nil]];
    //[retArr addObject:[NSArray arrayWithObjects:@"合计", @"686", @"-42", @"80.71%", @"0.0234", nil]];
    return retArr;
}

- (NSArray *)tv189 {
    //假数据
    NSMutableArray *retArr = [NSMutableArray array];
    [retArr addObject:[NSArray arrayWithObjects:@"渠道名称",@"当日登录数",@"环比", @"当日包月订购数", @"环比", @"订购转换率", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"天翼视讯_校园活动华为_数字影院",@"2276", @"199", @"56", @"3", @"2.46%", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"天翼视讯_校园活动海信_数字影院",@"320", @"22", @"11", @"0", @"3.44%", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"天翼视讯_ROI统计手凤网_TV189院线",@"13803", @"-603", @"11", @"-3", @"0.08%", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"天翼视讯_TV189院线",@"9", @"6", @"9", @"9", @"100.00%", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"天翼视讯_校园活动三星_数字影院",@"1053", @"116", @"8", @"0", @"0.76%", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"天翼视讯_校园活动联想_数字影院",@"177", @"20", @"5", @"1", @"2.82%", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"天翼视讯_ROI统计手机搜狐网_TV189院线",@"4097", @"-2084", @"5", @"-4", @"0.12%", nil]];
    return retArr;
//    NSArray *names = [NSArray arrayWithObjects:
//                      @"天翼视讯_校园活动华为_数字影院",
//                      @"天翼视讯_校园活动海信_数字影院",
//                      @"天翼视讯_ROI统计手凤网_TV189院线",
//                      @"天翼视讯_TV189院线",
//                      @"天翼视讯_校园活动三星_数字影院",
//                      @"天翼视讯_校园活动联想_数字影院",
//                      @"天翼视讯_ROI统计手机搜狐网_TV189院线",nil];
//    NSMutableArray *retArr = [NSMutableArray array];
//    for (int i = 0; i < [names count]; i++) {
//        NSMutableArray *tempArr = [NSMutableArray array];
//        [tempArr addObject:[names objectAtIndex:i]];
//        [tempArr addObject:@"0"];
//        [tempArr addObject:@"0.00%"];
//        [tempArr addObject:@"0"];
//        [tempArr addObject:@"0.00%"];
//        [tempArr addObject:@"0.00%"];
//        [retArr addObject:tempArr];
//    }
//    
//    return retArr;
}

- (NSArray *)gupiao {
    //假数据
    NSMutableArray *retArr = [NSMutableArray array];
    [retArr addObject:[NSArray arrayWithObjects:@"渠道名称",@"当日登录数",@"环比", @"当日包月订购数", @"环比", @"订购转换率", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"天翼视讯内容部_快点文化陕西省推广_股票老左",@"200", @"2", @"196", @"1", @"98.00%", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"电信孵化基地_股票老左推广_股票老左",@"91", @"5", @"6", @"3", @"6.59%", nil]];
    [retArr addObject:[NSArray arrayWithObjects:@"天翼视讯总编室_天翼视讯_股票老左",@"0", @"0", @"4", @"3", @"0.00%", nil]];
    return retArr;
    
//    NSArray *names = [NSArray arrayWithObjects:
//                      @"天翼视讯内容部_快点文化陕西省推广_股票老左",
//                      @"电信孵化基地_股票老左推广_股票老左",
//                      @"天翼视讯总编室_天翼视讯_股票老左",nil];
//    NSMutableArray *retArr = [NSMutableArray array];
//    for (int i = 0; i < [names count]; i++) {
//        NSMutableArray *tempArr = [NSMutableArray array];
//        [tempArr addObject:[names objectAtIndex:i]];
//        [tempArr addObject:@"0"];
//        [tempArr addObject:@"0.00%"];
//        [tempArr addObject:@"0"];
//        [tempArr addObject:@"0.00%"];
//        [tempArr addObject:@"0.00%"];
//        [retArr addObject:tempArr];
//    }
//    
//    return retArr;
}

- (NSArray *)yunying1 {
    //假数据
    NSMutableArray *retArr = [NSMutableArray array];
    [retArr addObject:[NSArray arrayWithObjects:@"019999",@"WAP",[NSNumber numberWithInt:663351], [NSNumber numberWithInt:511], [NSNumber numberWithInt:671], [NSNumber numberWithInt:-9], [NSNumber numberWithInt:1024], [NSNumber numberWithInt:-263], nil]];
        [retArr addObject:[NSArray arrayWithObjects:@"029999",@"客户端1.X、2.X",[NSNumber numberWithInt:1412783], [NSNumber numberWithInt:2459], [NSNumber numberWithInt:2685], [NSNumber numberWithInt:270], [NSNumber numberWithInt:2348], [NSNumber numberWithInt:-1053], nil]];
        [retArr addObject:[NSArray arrayWithObjects:@"00000020",@"富媒体",[NSNumber numberWithInt:270015], [NSNumber numberWithInt:1472], [NSNumber numberWithInt:2677], [NSNumber numberWithInt:141], [NSNumber numberWithInt:927], [NSNumber numberWithInt:-166], nil]];
        [retArr addObject:[NSArray arrayWithObjects:@"049999",@"客户端4.X",[NSNumber numberWithInt:19926], [NSNumber numberWithInt:195], [NSNumber numberWithInt:266], [NSNumber numberWithInt:56], [NSNumber numberWithInt:75], [NSNumber numberWithInt:1], nil]];
        [retArr addObject:[NSArray arrayWithObjects:@"059999",@"客户端5.X",[NSNumber numberWithInt:4380], [NSNumber numberWithInt:62], [NSNumber numberWithInt:122], [NSNumber numberWithInt:21], [NSNumber numberWithInt:31], [NSNumber numberWithInt:-7], nil]];
        [retArr addObject:[NSArray arrayWithObjects:@"",@"其他",[NSNumber numberWithInt:118429], [NSNumber numberWithInt:483], [NSNumber numberWithInt:913], [NSNumber numberWithInt:-21], [NSNumber numberWithInt:334], [NSNumber numberWithInt:-65], nil]];
        [retArr addObject:[NSArray arrayWithObjects:@"",@"合计",[NSNumber numberWithInt:2488884], [NSNumber numberWithInt:5137], [NSNumber numberWithInt:7334], [NSNumber numberWithInt:458], [NSNumber numberWithInt:4739], [NSNumber numberWithInt:-1153], nil]];
    return retArr;
    
    
    NSString *jsonStr = @"[[\"019999\",\"WAP\",\"\",\"\",\"\",\"\",\"\",\"\"],[\"029999\",\"客户端1.X、2.X\",\"\",\"\",\"\",\"\",\"\",\"\"],[\"00000020\",\"富媒体\",\"\",\"\",\"\",\"\",\"\",\"\"],[\"049999\",\"客户端4.X\",\"\",\"\",\"\",\"\",\"\",\"\"],[\"059999\",\"客户端5.X\",\"\",\"\",\"\",\"\",\"\",\"\"],[\"\",\"其他\",\"\",\"\",\"\",\"\",\"\",\"\"]]";
    NSArray *array = [jsonStr JSONValue];
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:array];
    [tempArr addObject:[NSArray arrayWithObjects:@"",@"合计",@"",@"0.05",@"",@"-0.67",@"",@"", nil]];
    return tempArr;
}

- (NSDictionary *)yunying {
    NSString *jsonStr = @"[[\"WAP\",\"11-13\",\"669\",\"983\"],[\"WAP\",\"11-14\",\"711\",\"872\"],[\"WAP\",\"11-15\",\"655\",\"1748\"],[\"WAP\",\"11-16\",\"749\",\"841\"],[\"WAP\",\"11-17\",\"682\",\"807\"],[\"WAP\",\"11-18\",\"587\",\"994\"],[\"WAP\",\"11-19\",\"662\",\"966\"],[\"WAP\",\"11-20\",\"622\",\"894\"],[\"WAP\",\"11-21\",\"621\",\"927\"],[\"WAP\",\"11-22\",\"645\",\"967\"],[\"WAP\",\"11-23\",\"828\",\"792\"],[\"WAP\",\"11-24\",\"789\",\"856\"],[\"WAP\",\"11-25\",\"573\",\"988\"],[\"WAP\",\"11-26\",\"548\",\"1015\"],[\"客户端1.X、2.X\",\"11-13\",\"2748\",\"2457\"],[\"客户端1.X、2.X\",\"11-14\",\"2504\",\"2077\"],[\"客户端1.X、2.X\",\"11-15\",\"2638\",\"4251\"],[\"客户端1.X、2.X\",\"11-16\",\"3633\",\"2098\"],[\"客户端1.X、2.X\",\"11-17\",\"3557\",\"1962\"],[\"客户端1.X、2.X\",\"11-18\",\"2440\",\"2175\"],[\"客户端1.X、2.X\",\"11-19\",\"2330\",\"2037\"],[\"客户端1.X、2.X\",\"11-20\",\"2536\",\"2235\"],[\"客户端1.X、2.X\",\"11-21\",\"2380\",\"2260\"],[\"客户端1.X、2.X\",\"11-22\",\"2642\",\"2087\"],[\"客户端1.X、2.X\",\"11-23\",\"3118\",\"2039\"],[\"客户端1.X、2.X\",\"11-24\",\"3531\",\"2130\"],[\"客户端1.X、2.X\",\"11-25\",\"2076\",\"2427\"],[\"客户端1.X、2.X\",\"11-26\",\"1984\",\"2407\"],[\"富媒体\",\"11-13\",\"2991\",\"985\"],[\"富媒体\",\"11-14\",\"2879\",\"942\"],[\"富媒体\",\"11-15\",\"3217\",\"1736\"],[\"富媒体\",\"11-16\",\"3682\",\"1086\"],[\"富媒体\",\"11-17\",\"3242\",\"1037\"],[\"富媒体\",\"11-18\",\"2876\",\"1011\"],[\"富媒体\",\"11-19\",\"2823\",\"975\"],[\"富媒体\",\"11-20\",\"3135\",\"983\"],[\"富媒体\",\"11-21\",\"2866\",\"1071\"],[\"富媒体\",\"11-22\",\"3143\",\"1042\"],[\"富媒体\",\"11-23\",\"3453\",\"1063\"],[\"富媒体\",\"11-24\",\"3500\",\"1113\"],[\"富媒体\",\"11-25\",\"2727\",\"1140\"],[\"富媒体\",\"11-26\",\"2642\",\"1126\"],[\"客户端4.X\",\"11-13\",\"209\",\"68\"],[\"客户端4.X\",\"11-14\",\"176\",\"48\"],[\"客户端4.X\",\"11-15\",\"212\",\"97\"],[\"客户端4.X\",\"11-16\",\"232\",\"64\"],[\"客户端4.X\",\"11-17\",\"209\",\"46\"],[\"客户端4.X\",\"11-18\",\"206\",\"54\"],[\"客户端4.X\",\"11-19\",\"153\",\"55\"],[\"客户端4.X\",\"11-20\",\"153\",\"44\"],[\"客户端4.X\",\"11-21\",\"153\",\"46\"],[\"客户端4.X\",\"11-22\",\"187\",\"62\"],[\"客户端4.X\",\"11-23\",\"201\",\"39\"],[\"客户端4.X\",\"11-24\",\"197\",\"76\"],[\"客户端4.X\",\"11-25\",\"139\",\"73\"],[\"客户端4.X\",\"11-26\",\"153\",\"59\"],[\"客户端5.X\",\"11-13\",\"94\",\"41\"],[\"客户端5.X\",\"11-14\",\"74\",\"32\"],[\"客户端5.X\",\"11-15\",\"80\",\"22\"],[\"客户端5.X\",\"11-16\",\"105\",\"34\"],[\"客户端5.X\",\"11-17\",\"59\",\"21\"],[\"客户端5.X\",\"11-18\",\"161\",\"28\"],[\"客户端5.X\",\"11-19\",\"254\",\"45\"],[\"客户端5.X\",\"11-20\",\"300\",\"57\"],[\"客户端5.X\",\"11-21\",\"280\",\"52\"],[\"客户端5.X\",\"11-22\",\"277\",\"46\"],[\"客户端5.X\",\"11-23\",\"331\",\"61\"],[\"客户端5.X\",\"11-24\",\"339\",\"68\"],[\"客户端5.X\",\"11-25\",\"270\",\"74\"],[\"客户端5.X\",\"11-26\",\"183\",\"68\"],[\"其他\",\"11-13\",\"1129\",\"3272\"],[\"其他\",\"11-14\",\"1191\",\"3010\"],[\"其他\",\"11-15\",\"1377\",\"6067\"],[\"其他\",\"11-16\",\"1520\",\"2880\"],[\"其他\",\"11-17\",\"1390\",\"2849\"],[\"其他\",\"11-18\",\"1962\",\"3368\"],[\"其他\",\"11-19\",\"44106\",\"3244\"],[\"其他\",\"11-20\",\"46928\",\"3276\"],[\"其他\",\"11-21\",\"40927\",\"3148\"],[\"其他\",\"11-22\",\"3533\",\"3074\"],[\"其他\",\"11-23\",\"31964\",\"2986\"],[\"其他\",\"11-24\",\"28020\",\"3009\"],[\"其他\",\"11-25\",\"1494\",\"3506\"],[\"其他\",\"11-26\",\"3746\",\"3605\"]]";
    NSArray *midArr = [jsonStr JSONValue];
    NSMutableArray *titleArr = [NSMutableArray array];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    NSDictionary *retDic = [NSDictionary dictionaryWithObjectsAndKeys:titleArr,@"title",contentDic,@"content", nil];
    NSString *channelName = nil;
    NSMutableArray *tempArr = nil;
    for (int i = 0; i < [midArr count]; i++) {
        if (![channelName isEqualToString:[[midArr objectAtIndex:i] objectAtIndex:0]]) {
            channelName = [[midArr objectAtIndex:i] objectAtIndex:0];
            tempArr = [NSMutableArray array];
            [contentDic setValue:tempArr forKey:channelName];
            [titleArr addObject:channelName];
        }
        [tempArr addObject:[midArr objectAtIndex:i]];
    }
    return retDic;
}

- (NSArray *)rowTitlesWithSection:(NSInteger)section {
    NSArray *ret = nil;
    switch (section) {
        case 0:
            ret = [NSArray arrayWithObjects:@"分部门",@"分产品包", nil];
            break;
        case 1:
            ret = [NSArray arrayWithObjects:@"渠道订购来源",@"合作推广渠道导入的产品包分类新增", @"当日渠道新增数量前十", nil];
            break;
        case 2:
            ret = [NSArray arrayWithObjects:@"当日渠道退订数量前十", nil];
            break;
        case 3:
            ret = [NSArray arrayWithObjects:@"TV189院线",@"股票老左", nil];
            break;
        default:
            break;
    }
    return ret;
}

#pragma mark net work update

- (void)updateData {
    NSString * updateDateStr = [self lastDate];
   // [self displayData];
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:kDefaultServerUrl customHeaderFields:nil];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"dataType", updateDateStr, @"startDate", updateDateStr, @"endDate", nil];
    MKNetworkOperation *op = [engine operationWithPath:@"/app" params:params httpMethod:@"GET" ssl:NO];
    op.stringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        //NSLog(@"%@", operation.responseString);
        //NSArray *arr = [operation.responseString JSONValue];
       // NSLog(@"%@", [arr objectAtIndex:<#(NSUInteger)#>]);
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"MKNetwork request error : %@", [err localizedDescription]);
    }];
    [engine enqueueOperation:op];
    
}

- (NSString *)testJson{
    return @"[{\"list4\":[[\"000070020100000\",\"信元公众信息发展有限责任公司_互联星空_入口_天翼视讯\",\"0\",\"0\",\"0\"],[\"00310411\",\"营销活动_娱乐1_天翼视讯\",\"0\",\"0\",\"0\"],[\"00932722\",\"天翼视讯_360市场_全能看\",\"0\",\"0\",\"0\"],[\"00932810\",\"天翼视讯_集团活动视讯业务体验竞赛_天翼视讯\",\"0\",\"0\",\"0\"],[\"000130230101000\",\"省公司专用渠道_辽宁电信_全能看\",\"0\",\"0\",\"0\"],[\"000070060101000\",\"互联星空_彩信报_天翼视讯\",\"0\",\"0\",\"0\"],[\"000070080101000\",\"互联星空_奥运_天翼视讯\",\"0\",\"0\",\"0\"],[\"000070010100002\",\"互联星空_集团_all_国学\",\"0\",\"0\",\"0\"],[\"000070100101007\",\"互联星空_推荐7_跨屏\",\"0\",\"0\",\"0\"],[\"00150110\",\"视讯中心WAP PUSH_PUSH0_天翼视讯\",\"0\",\"0\",\"0\"]],\"list5\":[],\"list2\":[[\"WAP\",\"11-13\",\"669\",\"983\"],[\"WAP\",\"11-14\",\"711\",\"872\"],[\"WAP\",\"11-15\",\"655\",\"1748\"],[\"WAP\",\"11-16\",\"749\",\"841\"],[\"WAP\",\"11-17\",\"682\",\"807\"],[\"WAP\",\"11-18\",\"587\",\"994\"],[\"WAP\",\"11-19\",\"662\",\"966\"],[\"WAP\",\"11-20\",\"622\",\"894\"],[\"WAP\",\"11-21\",\"621\",\"927\"],[\"WAP\",\"11-22\",\"645\",\"967\"],[\"WAP\",\"11-23\",\"828\",\"792\"],[\"WAP\",\"11-24\",\"789\",\"856\"],[\"WAP\",\"11-25\",\"573\",\"988\"],[\"WAP\",\"11-26\",\"548\",\"1015\"],[\"客户端1.X、2.X\",\"11-13\",\"2748\",\"2457\"],[\"客户端1.X、2.X\",\"11-14\",\"2504\",\"2077\"],[\"客户端1.X、2.X\",\"11-15\",\"2638\",\"4251\"],[\"客户端1.X、2.X\",\"11-16\",\"3633\",\"2098\"],[\"客户端1.X、2.X\",\"11-17\",\"3557\",\"1962\"],[\"客户端1.X、2.X\",\"11-18\",\"2440\",\"2175\"],[\"客户端1.X、2.X\",\"11-19\",\"2330\",\"2037\"],[\"客户端1.X、2.X\",\"11-20\",\"2536\",\"2235\"],[\"客户端1.X、2.X\",\"11-21\",\"2380\",\"2260\"],[\"客户端1.X、2.X\",\"11-22\",\"2642\",\"2087\"],[\"客户端1.X、2.X\",\"11-23\",\"3118\",\"2039\"],[\"客户端1.X、2.X\",\"11-24\",\"3531\",\"2130\"],[\"客户端1.X、2.X\",\"11-25\",\"2076\",\"2427\"],[\"客户端1.X、2.X\",\"11-26\",\"1984\",\"2407\"],[\"富媒体\",\"11-13\",\"2991\",\"985\"],[\"富媒体\",\"11-14\",\"2879\",\"942\"],[\"富媒体\",\"11-15\",\"3217\",\"1736\"],[\"富媒体\",\"11-16\",\"3682\",\"1086\"],[\"富媒体\",\"11-17\",\"3242\",\"1037\"],[\"富媒体\",\"11-18\",\"2876\",\"1011\"],[\"富媒体\",\"11-19\",\"2823\",\"975\"],[\"富媒体\",\"11-20\",\"3135\",\"983\"],[\"富媒体\",\"11-21\",\"2866\",\"1071\"],[\"富媒体\",\"11-22\",\"3143\",\"1042\"],[\"富媒体\",\"11-23\",\"3453\",\"1063\"],[\"富媒体\",\"11-24\",\"3500\",\"1113\"],[\"富媒体\",\"11-25\",\"2727\",\"1140\"],[\"富媒体\",\"11-26\",\"2642\",\"1126\"],[\"客户端4.X\",\"11-13\",\"209\",\"68\"],[\"客户端4.X\",\"11-14\",\"176\",\"48\"],[\"客户端4.X\",\"11-15\",\"212\",\"97\"],[\"客户端4.X\",\"11-16\",\"232\",\"64\"],[\"客户端4.X\",\"11-17\",\"209\",\"46\"],[\"客户端4.X\",\"11-18\",\"206\",\"54\"],[\"客户端4.X\",\"11-19\",\"153\",\"55\"],[\"客户端4.X\",\"11-20\",\"153\",\"44\"],[\"客户端4.X\",\"11-21\",\"153\",\"46\"],[\"客户端4.X\",\"11-22\",\"187\",\"62\"],[\"客户端4.X\",\"11-23\",\"201\",\"39\"],[\"客户端4.X\",\"11-24\",\"197\",\"76\"],[\"客户端4.X\",\"11-25\",\"139\",\"73\"],[\"客户端4.X\",\"11-26\",\"153\",\"59\"],[\"客户端5.X\",\"11-13\",\"94\",\"41\"],[\"客户端5.X\",\"11-14\",\"74\",\"32\"],[\"客户端5.X\",\"11-15\",\"80\",\"22\"],[\"客户端5.X\",\"11-16\",\"105\",\"34\"],[\"客户端5.X\",\"11-17\",\"59\",\"21\"],[\"客户端5.X\",\"11-18\",\"161\",\"28\"],[\"客户端5.X\",\"11-19\",\"254\",\"45\"],[\"客户端5.X\",\"11-20\",\"300\",\"57\"],[\"客户端5.X\",\"11-21\",\"280\",\"52\"],[\"客户端5.X\",\"11-22\",\"277\",\"46\"],[\"客户端5.X\",\"11-23\",\"331\",\"61\"],[\"客户端5.X\",\"11-24\",\"339\",\"68\"],[\"客户端5.X\",\"11-25\",\"270\",\"74\"],[\"客户端5.X\",\"11-26\",\"183\",\"68\"],[\"其他\",\"11-13\",\"1129\",\"3272\"],[\"其他\",\"11-14\",\"1191\",\"3010\"],[\"其他\",\"11-15\",\"1377\",\"6067\"],[\"其他\",\"11-16\",\"1520\",\"2880\"],[\"其他\",\"11-17\",\"1390\",\"2849\"],[\"其他\",\"11-18\",\"1962\",\"3368\"],[\"其他\",\"11-19\",\"44106\",\"3244\"],[\"其他\",\"11-20\",\"46928\",\"3276\"],[\"其他\",\"11-21\",\"40927\",\"3148\"],[\"其他\",\"11-22\",\"3533\",\"3074\"],[\"其他\",\"11-23\",\"31964\",\"2986\"],[\"其他\",\"11-24\",\"28020\",\"3009\"],[\"其他\",\"11-25\",\"1494\",\"3506\"],[\"其他\",\"11-26\",\"3746\",\"3605\"]],\"list3\":[[\"000070020100000\",\"信元公众信息发展有限责任公司_互联星空_入口_天翼视讯\",\"0\",\"0\",\"0\"],[\"00310411\",\"营销活动_娱乐1_天翼视讯\",\"0\",\"0\",\"0\"],[\"00932722\",\"天翼视讯_360市场_全能看\",\"0\",\"0\",\"0\"],[\"00932810\",\"天翼视讯_集团活动视讯业务体验竞赛_天翼视讯\",\"0\",\"0\",\"0\"],[\"000130230101000\",\"省公司专用渠道_辽宁电信_全能看\",\"0\",\"0\",\"0\"],[\"000070060101000\",\"互联星空_彩信报_天翼视讯\",\"0\",\"0\",\"0\"],[\"000070080101000\",\"互联星空_奥运_天翼视讯\",\"0\",\"0\",\"0\"],[\"000070010100002\",\"互联星空_集团_all_国学\",\"0\",\"0\",\"0\"],[\"000070100101007\",\"互联星空_推荐7_跨屏\",\"0\",\"0\",\"0\"],[\"00150110\",\"视讯中心WAP PUSH_PUSH0_天翼视讯\",\"0\",\"0\",\"0\"]],\"list\":[[\"019999\",\"WAP\",\"\",\"\",\"\",\"\",\"\",\"\"],[\"029999\",\"客户端1.X、2.X\",\"\",\"\",\"\",\"\",\"\",\"\"],[\"00000020\",\"富媒体\",\"\",\"\",\"\",\"\",\"\",\"\"],[\"049999\",\"客户端4.X\",\"\",\"\",\"\",\"\",\"\",\"\"],[\"059999\",\"客户端5.X\",\"\",\"\",\"\",\"\",\"\",\"\"],[\"\",\"其他\",\"\",\"\",\"\",\"\",\"\",\"\"]],\"list6\":[],\"list7\":[[]]}]";
}


@end
