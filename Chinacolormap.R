library(geojsonsf)
library(sf)
library(ggplot2)
library(RColorBrewer)
​
API_pre = "http://xzqh.mca.gov.cn/data/"
## 1.全国
China = st_read(dsn = paste0(API_pre, "quanguo.json"), 
                stringsAsFactors=FALSE) 
st_crs(China) = 4326
​
# 2.国境线
China_line = st_read(dsn = paste0(API_pre, "quanguo_Line.geojson"), 
                     stringsAsFactors=FALSE) 
st_crs(China_line) = 4326
​
gjx <- China_line[China_line$QUHUADAIMA == "guojiexian",]
​
# 3.读取省份地理中心
# 地图中心坐标：基于st_centroid和省会坐标以及部分调整值
province_mid <- read.csv("https://raw.githubusercontent.com/slyang-cn/data/slyangcn/province.csv")
​
# 4.着色数据+全国地图
zhuose_data <- read.csv("https://raw.githubusercontent.com/slyang-cn/data/slyangcn/your_data.csv")
zhuose_data$QUHUADAIMA <- as.character(zhuose_data$QUHUADAIMA) # 因China数据中QUHUADAIMA是chr类型
CHINA <- dplyr::left_join(China,zhuose_data,by= "QUHUADAIMA")
​
​
###----全国地图完整（无右下角小地图）----------###
ggplot()+
  # 绘制主图
  geom_sf(data = CHINA,aes(fill = factor(yanse))) +
  scale_fill_manual("class", values=c("#FFCCCC", "#FF9333", "#FF6660","#FF5111","#CC0070"),
                    breaks = c("0~200","200~400","400~600","600~1000","1000+"),
                    labels = c("0~200","200~400","400~600","600~1000","1000+"))+
  # 绘制国境线及十/九段线
  geom_sf(data = gjx)+
  geom_text(data = province,aes(x=dili_Jd,y=dili_Wd,label=省市),
            position = "identity",size=3,check_overlap = TRUE) +
  labs(title="中国地图",subtitle="随机着色",caption = "reference")+
  theme(
    plot.title = element_text(color="red", size=16, face="bold",vjust = 0.1,hjust = 0.5),
    plot.subtitle = element_text(size=10,vjust = 0.1,hjust = 0.5),
    legend.title=element_blank(),
    legend.position = c(0.2,0.2),
    panel.grid=element_blank(),
    panel.background=element_blank(),
    axis.text=element_blank(),
    axis.ticks=element_blank(),
    axis.title=element_blank()
  )