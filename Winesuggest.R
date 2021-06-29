

df <- read.csv('wine.csv')
colnames(df) <- c('Cultivar','Alcohol','Malic acid','Ash','Alcalinity of ash','Magnesium', #변수들을 넣어줌
                  'Total phenols','Flavanoids','Nonflavanoid phenols',
                  'Proanthocyanins','Color intensity','Hue','OD280/OD315 of diluted wines','Proline')
str(df) #구조확인

#결측치 확인
colSums(is.na(df))

#변수별 기술 통계 및 분포 확인

summary(df[,-1])

boxplot(df[,-1], cex.axis =0.5) #첫번째 Cultivar 변수 제거.. 범주형 변수이므로..

# 마지막 변수값이 너무 커서 변수값을 조절해준다.

par(mfrow=c(1,2)) #한화면에 여러 사진넣기위함

boxplot(df[,-1], ylim = c(0,200), cex.axis = 0.5) #y 를 0부터 200까지 조정해봄
boxplot(df[,-1], ylim = c(0,30), cex.axis = 0.5)  #y 를 0부터 30까지 조정해봄

#변수들의 크기 차이가 너무 많이 나므로 표준화를 진행해준다

df.train <- df[,-1] #첫번째 변수를 제외한 데이터를 df.train 에 넣어줌
df.train.scale <- scale(df.train)


