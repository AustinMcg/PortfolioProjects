library(tidyverse)
library(tidyquant)
library(lubridate)
library(knitr)
library(tinytex)
library(ggrepel)
library(kableExtra)
library(alphavantager)
av_api_key("XTUB6FCG610269WK")
library(bdscale)
library(scales)


index <- c("kweb", "mchi")
key.tech <- c("tcehy", "baba", "jd")
chart.date <- as.Date("2021-01-01") # charting this date

## READ OBV
df.OBV <- read_csv("df.OBV.csv")

time <- df.OBV$time %>%
  sort(descreasing = TRUE)

## READ CCI
df.CCI <- read_csv("df.CCI.csv")

time <- df.CCI$time %>%
  sort(descreasing = TRUE)

## READ AD
df.AD <- read_csv("df.AD.csv")

time <- df.AD$time %>%
  sort(descreasing = TRUE)

## RSI
df.RSI <- read_csv("df.RSI.csv")

### STOCK DATA
stock.data <- read_csv("stock.list.csv")

##HK STOCK DATA
stock.data.hk <- read_csv("stock.list.hk.csv")


time <- stock.data$date %>%
  sort(descreasing = TRUE)


time <- stock.data$date %>%
  sort(descreasing = TRUE)


exclude.bidu.ntes <- c("bidu", "ntes", "mpngy")

### OBV charting

df.OBV %>%
  filter(time > chart.date) %>%
  filter(!symbol %in% index) %>%
  filter(!symbol %in% exclude.bidu.ntes) %>%
  ggplot(aes(time, OBV)) +
  geom_line() +
  geom_hline(yintercept = 0, alpha = 0.5, color = "black") +
  labs(title = "On Balance Volume (OBV) for US Listed Chinese Tech Stocks",
       subtitle = "From Jan 2021 to Date of Report",
       caption = "BIDU, NTES, and MPNGY excluded. Dates in Day/Month format",
       y= "OBV", x = "") +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m"),max.major.breaks=7) +
  theme(
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) +
  facet_wrap(. ~ symbol, scale = "free")


### OBV charting

df.OBV %>%
  filter(time > "2021-06-01") %>%
  filter(!symbol %in% index) %>%
  filter(!symbol %in% exclude.bidu.ntes) %>%
  ggplot(aes(time, OBV)) +
  geom_line() +
  geom_hline(yintercept = 0, alpha = 0.5, color = "black") +
  labs(title = "On Balance Volume for US Listed Chinese Tech Stocks",
       subtitle = "From Jan 2021 to Date of Report.  OBV on Y Axis",
       caption = "BIDU, NTES, and MPNGY excluded. Dates in Day/Month format",
       y= "OBV", x = "") +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m"),max.major.breaks=4) +
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) +
  facet_wrap(. ~ symbol, scale = "free")

### facet wrap for key 
BABA <- stock.data %>%
  filter(date > chart.date) %>%
  filter(symbol %in% "BABA") %>%
  select(time = date, adjusted)

baba <- df.OBV %>%
  filter(time > chart.date) %>%
  filter(symbol %in% "baba") %>%
  select(time, OBV)

baba.fw <- merge(x = BABA, y = baba, by = "time", all = TRUE) %>%
  select(time, Adjusted = adjusted, "On Balance Volume" = OBV) %>%
  gather(key = "type", value = "value", -time)

baba.fw %>%
  filter(time > "2021-06-01") %>%
  ggplot(aes(time, value)) +
  geom_line() +
  labs(title = "Alibaba Adjusted Daily Price Compared to On Balance Volume",
       caption = "Look for divergence between OBV and Price.",
       subtitle = "From June 2021 to Present") +
  facet_wrap( ~ type,nrow = 2, 
              scales = "free") +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m"), max.major.breaks=12)

rm(baba.fw, BABA, baba)

### SAME THING FOR JD
### facet wrap for key 
JD <- stock.data %>%
  filter(date > chart.date) %>%
  filter(symbol %in% "JD") %>%
  select(time = date, adjusted)

jd <- df.OBV %>%
  filter(time > chart.date) %>%
  filter(symbol %in% "jd") %>%
  select(time, OBV)

jd.fw <- merge(x = JD, y = jd, by = "time", all = TRUE) %>%
  select(time, Adjusted = adjusted, "On Balance Volume" = OBV) %>%
  gather(key = "type", value = "value", -time)

jd.fw %>%
  filter(time > "2021-06-01") %>%
  ggplot(aes(time, value)) +
  geom_line() +
  labs(title = "JD Adjusted Daily Closing Price Compared to On Balance Volume",
       caption = "Look for divergence between OBV and Price.",
       subtitle = "From June 2021 to Present") +
  facet_wrap( ~ type,nrow = 2, 
              scales = "free") +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m"), max.major.breaks=12)

rm(jd.fw, JD, jd)

### NOW TENCENT OBC COMPARISON (FACET WRAP)

TCEHY <- stock.data %>%
  filter(date > chart.date) %>%
  filter(symbol %in% "TCEHY") %>%
  select(time = date, adjusted)

tcehy <- df.OBV %>%
  filter(time > chart.date) %>%
  filter(symbol %in% "tcehy") %>%
  select(time, OBV)

tcehy.fw <- merge(x = TCEHY, y = tcehy, by = "time", all = TRUE) %>%
  select(time, Adjusted = adjusted, "On Balance Volume" = OBV) %>%
  gather(key = "type", value = "value", -time)

tcehy.fw %>%
  filter(time > "2021-06-01") %>%
  ggplot(aes(time, value)) +
  geom_line() +
  labs(title = "Tencent Adjusted Daily Closing Price Compared to On Balance Volume",
       caption = "Look for divergence between OBV and Price.",
       subtitle = "From June 2021 to Present") +
  facet_wrap( ~ type,nrow = 2, 
              scales = "free") +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m"), max.major.breaks=12)

rm(tcehy.fw, TCEHY, tcehy)

### CCI useful to compare because its indexed.

df.CCI %>%
  filter(!symbol %in% index) %>%
  ggplot(aes(time, CCI)) +
  geom_area( alpha = 0.5, show.legend = FALSE) +
  geom_hline(yintercept = 0, color="black") +
  geom_hline(yintercept = -200, color="black", alpha = 0.8) +
  geom_hline(yintercept = 200, color="black", alpha = 0.8) +
  labs(title = "Commodity Channel Index US Listed Chinese Tech Stocks",
       subtitle = "Dates from Jan 2021 to Present",
       y= "CCI Index", x = "Date") +
  scale_x_bd(business.dates=time, labels = date_format(format = "%m"), max.major.breaks=12) +
  facet_wrap(. ~ symbol)

df.CCI %>%
  filter(!symbol %in% index) %>%
  ggplot(aes(time, CCI)) +
  geom_area( alpha = 0.5, show.legend = FALSE) +
  geom_hline(yintercept = 0, color="black") +
  geom_hline(yintercept = -200, color="black", alpha = 0.8) +
  geom_hline(yintercept = 200, color="black", alpha = 0.8) +
  labs(title = "Commodity Channel Index US Listed Chinese Tech Stocks",
       subtitle = "Dates from Jan 2021 to Present",
       y= "CCI Index", x = "") +
  scale_x_bd(business.dates=time) +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank()) +
  facet_grid(. ~ symbol)


df.CCI %>%
  filter(time > "2021-07-10") %>%
  filter(!symbol %in% index) %>%
  ggplot(aes(time, CCI)) +
  geom_line( alpha = 0.5, show.legend = FALSE) +
  geom_point(size = 0.1)+
  labs(title = "Commodity Channel Index US Listed Chinese Tech Stocks",
       subtitle = "Dates from Last 30 days (July 10, 2021) to Present",
       y= "CCI", x = "") +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d"), max.major.breaks=5) +
  facet_wrap(. ~ symbol)


### CCI CALCULATIONS FOR COMPARISONs

index.cci <- df.CCI %>%
  filter(symbol != index) 

median.cci <- index.cci %>%  
  group_by(time) %>%
  summarise(median = median(CCI, na.rm = TRUE))
mean.cci <- index.cci %>%  
  group_by(time) %>%
  summarise(mean = mean(CCI, na.rm = TRUE))
stat.cci <- data.frame(median.cci, mean = mean.cci$mean)
rm(median.cci, mean.cci)

stat.cci.gather<- stat.cci %>%
  gather(key = "stat", value = "value", -time)

stat.cci.gather %>%
  filter(time > "2021-01-01") %>%
  ggplot(aes(time, value, color = stat)) +
  geom_line() +
  labs(title = "CCI (Mean and Median Values) for US China Tech Basket",
       subtitle = "From Jan 2021 to current date",
       y= "CCI",
       x = " ") +
  scale_x_bd(business.dates=time, max.major.breaks=10)

### KEY TECH ISOLATE

key.cci <- df.CCI %>%
  filter(symbol %in% key.tech)

key.median.cci <- key.cci %>%  
  group_by(time) %>%
  summarise(median = median(CCI, na.rm = TRUE))
key.mean.cci <- key.cci %>%  
  group_by(time) %>%
  summarise(mean = mean(CCI, na.rm = TRUE)) 

key.stat.cci <- data.frame(key.median.cci, mean = key.mean.cci$mean)
key.stat.gather.cci <- key.stat.cci %>%
  gather(key = "stat", value = "value", -time)

#### NOW SOME PLOTTING

key.mean.cci %>%
  filter(time > "2020-01-01") %>%
  ggplot(aes(time, mean)) +
  geom_line() +
  labs(title = "CCI Mean for Alibaba and Tencent",
       subtitle = "From Jan 2020 to current date",
       caption = "(Alibaba CCI + Tencent CCI) / 2",
       y= "CCI",
       x = "") +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m"), max.major.breaks=12)

index.mean.cci <- index.cci %>%
  filter(time > "2020-01-01") %>%
  filter(!symbol %in% key.tech) %>%
  group_by(time) %>%
  summarise(mean = mean(CCI, na.rm = TRUE))


comp.mean.cci <- merge(x = key.mean.cci, y = index.mean.cci, by = "time", all = TRUE) %>%
  select(time, KEY = mean.x, REM = mean.y) %>%
  gather(key = "type", value = "value", -time)

comp.mean.cci %>%
  ggplot(aes(time, value, color = type)) +
  labs(title = "Comparing Mean CCI for Key Stocks (BABA, TCEHY) to Mean CCI of China Basket",
       subtitle = "From June 2021 to current date",
       caption = "Mean CCI of China Basket excludes Index ETF, BABA, TCEHY") +
  geom_line() +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m-%y"), max.major.breaks=12)

## WORKING OUT THE SPREAD BETWEEN THE TWO
merge(x = key.mean.cci, y = index.mean.cci, by = "time", all = TRUE) %>%
  select(time, mean.x, mean.y) %>%
  mutate(spread = mean.x - mean.y) %>%
  select(time, spread) %>%
  ggplot(aes(time, spread)) +
  geom_line() +
  labs(title = "Spread of Mean CCI for Key Stocks (BABA, TCEHY) less Mean CCI of China Basket",
       subtitle = "From June 2021 to date of report",
       caption = " ") +
  geom_hline(yintercept = 0, color="black", alpha = 0.8) +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m-%y"), max.major.breaks=12)


### GETTING THE MEAN OF INDEX ( MSCI AND KWEB )

idx.cci <- df.CCI %>%
  filter(symbol %in% index)

idex.mean.cci <- idx.cci %>%  
  group_by(time) %>%
  summarise(mean = mean(CCI, na.rm = TRUE))

idx.stat.cci <- data.frame(time = key.mean.cci$time, KEY = key.mean.cci$mean, INDEX = idex.mean.cci$mean) %>%
  gather(key = "stat", value = "value", -time)

# PLOT

idx.stat.cci %>%
  ggplot(aes(time, value, color = stat)) +
  geom_hline(yintercept = 0, color="black", alpha = 0.3) +
  labs(title = "Comparing Mean CCI for Key Stocks (BABA, TCEHY) to Mean CCI of China Index ETF",
       subtitle = "From Jan 2020 to current date",
       caption = "Index ETF are (MCHI, KWEB), Key Stocks are (BABA, TCEHY)",
       y = "CCI Index") +
  geom_line() +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m-%y"), max.major.breaks=12)


## NOW CALCULATING THE INDEX SPREAD
data.frame(time = key.mean.cci$time, KEY = key.mean.cci$mean, INDEX = idex.mean.cci$mean) %>%  
  select(time, KEY, INDEX) %>%
  mutate(spread = KEY - INDEX) %>%
  select(time, spread) %>%
  ggplot(aes(time, spread)) +
  labs(title = "CCI: Key Stocks Spread to Index ETF",
       subtitle = "Spread of Mean CCI for Key Stocks (BABA, TCEHY) less Mean CCI of China Index",
       caption = "China index ETF is mean of KWEB and MCHI CCI") +
  geom_hline(yintercept = 0, color="black", alpha = 0.8) +
  geom_line() +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m-%y"), max.major.breaks=14)


## AD CHARTINGS
df.AD %>%
  filter(time > chart.date) %>%
  filter(!symbol %in% index) %>%
  ggplot(aes(time, AD)) +
  geom_line() +
  labs(title = "Chaikin AD Line for US Listed Chinese Tech Stocks",
       subtitle = "From Jan 2021 to date of report",
       caption = "Data is not useful for NTES.",
       y= "AD", x = "") +
  facet_wrap(. ~ symbol, scale = "free") +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m"), max.major.breaks=4) +
theme(axis.title.y=element_blank(),
      axis.text.y=element_blank(),
      axis.ticks.y=element_blank())

df.AD %>%
  filter(time > "2021-05-01") %>%
  filter(symbol %in% key.tech) %>%
  ggplot(aes(time, AD)) +
  geom_line() +
  labs(title = "Chaikin AD Line for Key US Listed Chinese Tech",
       subtitle = "From Jan 2021 to Date of Report",
       y= "AD", x = "") +
  facet_wrap(. ~ symbol, scale = "free") +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m"), max.major.breaks=6) +
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())


baba <- stock.data %>%
  filter(date > "2020-01-01")%>%
  filter(symbol == "BABA") %>%
  select(baba = adjusted)
spy <- stock.data %>%
  filter(date > "2020-01-01")%>%
  filter(symbol == "SPY")
comb <- data.frame(spy, baba)
rm(baba, spy) 

comb %>%
  mutate(ratio = baba/adjusted) %>%
  select(date, ratio) %>%
  ggplot(aes(date, ratio)) +
  labs(title = "Ratio of Alibaba to SPY",
       subtitle = "BABA / SPY",
       caption = "Using daily adjusted closing price.  Moves up are overperformance relative to SPY.") +
  geom_line() +
  geom_area(alpha=0.3) +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m"), max.major.breaks=20)


#### NOW MCHI RATIO
### US VS CHINA RATIO COMPARISON

mchi <- stock.data %>%
  filter(date > "2020-01-01")%>%
  filter(symbol == "MCHI") %>%
  select(mchi = adjusted)
spy <- stock.data %>%
  filter(date > "2020-01-01")%>%
  filter(symbol == "SPY")
comb <- data.frame(spy, mchi)
rm(spy, mchi) 

comb %>%
  mutate(ratio = mchi/adjusted) %>%
  select(date, ratio) %>%
  ggplot(aes(date, ratio)) +
  labs(title = "Ratio of MCHI to SPY",
       subtitle = "MCHI / SPY",
       caption = "Using daily adjusted closing price.  Moves up are overperformance relative to SPY.") +
  geom_line() +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m-%y"), max.major.breaks=20)

baba <- stock.data %>%
  filter(date > "2020-01-01")%>%
  filter(symbol == "BABA") %>%
  select(baba = adjusted)
kweb <- stock.data %>%
  filter(date > "2020-01-01")%>%
  filter(symbol == "KWEB")
comb <- data.frame(baba, kweb)
rm(baba, kweb) 


comb %>%
  mutate(ratio = baba/adjusted) %>%
  select(date, ratio) %>%
  filter(date > "2021-01-01") %>%
  ggplot(aes(date, ratio)) +
  labs(title = "Alibaba Ratio to KWEB China Internet ETF",
       subtitle = "From Jan 2021 to Date of Report",
       caption = "Alibaba is outperforming KWEB") +
  geom_line() +
  geom_point(size=0.1) +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m"), max.major.breaks=12)

#### RSI

df.RSI %>%
  filter(time >"2021-01-01") %>%
  filter(symbol %in% "tcehy") %>%
  ggplot(aes(time, RSI)) +
  labs(title = "Relative Strength Index for Tencent",
       subtitle = "From Jan 2021 to date of report") +
  geom_line() +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m"), max.major.breaks=12)
  
df.RSI %>%
  filter(time >"2021-01-01") %>%
  filter(symbol %in% "baba") %>%
  ggplot(aes(time, RSI)) +
  labs(title = "Relative Strength Index for Alibaba",
       subtitle = "From Jan 2021 to date of report") +
  geom_line() +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m"), max.major.breaks=12)

temp.select <- c("kweb", "baba", "tcehy")

df.RSI %>%
  filter(time >"2021-01-01") %>%
  filter(symbol %in% temp.select) %>%
  ggplot(aes(time, RSI, color = symbol)) +
  labs(title = "Relative Strength Index for Key Tech",
       subtitle = "From Jan 2021 to date of report") +
  geom_line() +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m"), max.major.breaks=12)

### EDIT

mean.rsi <- df.RSI %>%
  filter(symbol != index) %>%
  filter(!symbol %in% "BABA") %>%
  group_by(time) %>%
  summarise(mean = mean(RSI, na.rm = TRUE))
key.rsi <- df.RSI %>%
  filter(symbol %in% "baba") %>%
  group_by(time) %>%
  summarise(mean = mean(RSI, na.rm = TRUE)) %>%
  select(keymean = mean)

baba.spread.rsi <- data.frame(mean.rsi, key.rsi) %>%
  mutate(spread = keymean - mean) %>%
  select(time, BABA.Spread = spread) 
  
stat.rsi <- data.frame(mean.rsi, key.rsi) %>%
  gather(key = "stat", value = "value", -time)


stat.rsi %>%
  ggplot(aes(time, value, color = stat)) +
  labs(title = "Mean RSI for Key Stocks and Mean RSI for Sector",
       subtitle = "From Jan 2020 to date of report") +
  geom_line() +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m-%y"), max.major.breaks=12)

stat.rsi %>%
  filter(time > "2021-01-01") %>%
  ggplot(aes(time, value, color = stat)) +
  labs(title = "Mean RSI for Key Stocks and Mean RSI for Sector",
       subtitle = "From Jan 2021 to date of report") +
  geom_line() +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m"), max.major.breaks=12)

data.frame(mean.rsi, key.rsi) %>%
  mutate(spread = keymean - mean) %>%
  select(time, spread) %>%
ggplot(aes(time, spread)) +
  labs(title = "Spread of Alibaba RSI less Mean RSI for China Tech Sector",
       subtitle = "From Jan 2020 to date of report",
       caption = "Rest of sector excludes Alibaba and Index ETF",
       y = "RSI") +
  geom_line() +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m-%y"), max.major.breaks=12)

mean.rsi <- df.RSI %>%
  filter(symbol != index) %>%
  filter(!symbol %in% "TCEHY") %>%
  group_by(time) %>%
  summarise(mean = mean(RSI, na.rm = TRUE))
key.rsi <- df.RSI %>%
  filter(symbol %in% "tcehy") %>%
  group_by(time) %>%
  summarise(mean = mean(RSI, na.rm = TRUE)) %>%
  select(keymean = mean)
stat.rsi <- data.frame(mean.rsi, key.rsi) %>%
  gather(key = "stat", value = "value", -time)

data.frame(mean.rsi, key.rsi) %>%
  mutate(spread = keymean - mean) %>%
  select(time, spread) %>%
  ggplot(aes(time, spread)) +
  labs(title = "Spread of Tencent RSI less Mean RSI for China Tech Sector",
       subtitle = "From Jan 2020 to date of report",
       caption = "Rest of sector excludes Tencent and Index ETF",
       y = "RSI") +
  geom_line() +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m-%y"), max.major.breaks=12)

tcehy.spread.rsi <- data.frame(mean.rsi, key.rsi) %>%
  mutate(spread = keymean - mean) %>%
  select(time, TCEHY.Spread = spread)

stat.comp.rsi <- data.frame(tcehy.spread.rsi, BABA.Spread = baba.spread.rsi$BABA.Spread) %>%
  gather(key = "type", value = "value", -time)

stat.comp.rsi %>%
ggplot(aes(time, value, color = type)) +
  labs(title = "Spread of Alibaba and Tencent Mean RSI less Mean RSI for China Tech Sector",
       subtitle = "From Jan 2020 to date of report",
       caption = " ") +
  geom_line() +
  geom_hline(yintercept = 0, color = "black") +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m-%y"), max.major.breaks=12)


spread.sl.hk <- stock.data.hk %>%
  spread(symbol, adjusted)

spread.sl.hk <- spread.sl.hk %>%
  mutate(BABA.conv = BABA / 8)

spread.sl.hk <- spread.sl.hk %>%
  filter(date > "2021-01-01") %>%
  select(date, BABA.conv, BABAHK = "9988.HK", HKD = "HKD=X") %>%
  mutate(BABACONV = BABAHK / HKD) %>%
  select(date, BABA.conv, BABACONV)

spread.sl.hk <- spread.sl.hk %>%
  mutate(abs.spread = BABACONV - BABA.conv)
spread.sl.hk.copy <- spread.sl.hk %>%
  mutate(abs.spread = BABACONV - BABA.conv)

spread.sl.hk %>%
  ggplot(aes(date, abs.spread)) +
    geom_col() +
    geom_smooth() +
  labs(title = "Alibaba HK and US Exchange, US Dollar Spread",
       subtitle = "From Jan 2021 to date of report",
       caption = "Comparison with US value of HK shares.") +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m-%y"), max.major.breaks=5)


spread.sl.hk <- spread.sl.hk %>%
  mutate(spread.pct = (abs.spread/BABACONV)*100) %>%
  select(date, spread.pct) 

spread.sl.hk %>%
  ggplot(aes(date, spread.pct)) +
  labs(title = "Alibaba HK and US Exchange, Percent Spread",
       subtitle = "From Jan 2021 to Date of Report",
       caption = "") +
  geom_smooth() +
  geom_col() +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m-%y"), max.major.breaks=12)

spread.sl.hk %>%
  filter(date > "2021-05-01") %>%
  ggplot(aes(date, spread.pct)) +
  labs(title = "Alibaba HK and US Exchange, Percent Spread",
       subtitle = "From May 2021 to Date of Report",
       caption = "") +
  geom_smooth() +
  ylim(-3,3) +
  geom_col() +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m"), max.major.breaks=12)


spread.sl.hk.copy %>%
  group_by(date) %>% 
  mutate(A_cum_sum = cumsum(abs.spread)) %>%
  ggplot(aes(date, abs.spread)) +
  labs(title = "Alibaba HK and US Exchange, Cumulative US Dollar Spread",
       subtitle = "From Jan 2021 to Date of Report",
       caption = "") +
  geom_smooth() +
  geom_col() +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m"), max.major.breaks=12)

spread.sl.hk.copy %>%
  filter(date > "2021-05-01") %>%
  group_by(date) %>% 
  mutate(A_cum_sum = cumsum(abs.spread)) %>%
  ggplot(aes(date, abs.spread)) +
  labs(title = "Alibaba HK and US Exchange, Cumulative US Dollar Spread",
       subtitle = "From May 2021 to Date of Report",
       caption = "") +
  geom_smooth() +
  geom_col() +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m"), max.major.breaks=12)
  
###

df.RSI %>%
  filter(time >"2021-01-01") %>%
  filter(symbol %in% key.tech) %>%
  filter(!symbol %in% "jd") %>%
  ggplot(aes(time, RSI, color = symbol)) +
  labs(title = "Relative Strength Index Alibaba and Tencent",
       subtitle = "From Jan 2021 to date of report") +
  geom_line() +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m"), max.major.breaks=12)

df.RSI %>%
  filter(time >"2021-06-01") %>%
  filter(symbol %in% key.tech) %>%
  filter(!symbol %in% "jd") %>%
  ggplot(aes(time, RSI, color = symbol)) +
  labs(title = "Relative Strength Index Alibaba and Tencent",
       subtitle = "From June 2021 to date of report") +
  geom_line() +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m"), max.major.breaks=12)


df.RSI %>%
  filter(time >"2021-06-01") %>%
  filter(!symbol %in% index) %>%
  ggplot(aes(time, RSI)) +
  geom_line() +
  labs(title = "Relative Strength Index for China Tech Stocks",
       subtitle = "From June 2021 to date of report") +
  facet_wrap(. ~ symbol) +
  scale_x_bd(business.dates=time, labels = date_format(format = "%d-%m"), max.major.breaks=5)

  