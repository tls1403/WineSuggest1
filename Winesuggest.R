

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

#euclidean distance (유사도 거리 측정)

df.dist <- dist(df.train.scale,method = "euclidean") %>% as.matrix()
View(df.dist)


#k-means(군집)

#군집개수 설정

#elbow method
library(factoextra)

set.seed(12345)#난수 고정
fviz_nbclust(df.train.scale,kmeans,method = "wss",k.max = 15)+ #wss within some of square, x축의 군집개수가 15개 까지
  theme_minimal()+ #테마
  ggtitle("the Elbow Method") #제목

#silhouette method
fviz_nbclust(df.train.scale,kmeans,method = "silhouette",k.max = 15)+
  theme_minimal()+
  ggtitle("Silhouette Plot")

#k =3 으로 정해짐

df.kmeans <- kmeans(df.train.scale, centers = 3, iter.max = 1000) # k = 3 , iter.max = 최대 돌리는 횟수

install.packages("useful")
library(useful)
plot(df.kmeans,df.train.scale) #2차원 그래프로 군집별 데이터 확인

#군집별 평균 시각화
df.kmeans$centers #각 군집별 평균값 확인
barplot(t(df.kmeans$centers),beside = T,col = 2:14) #beside= T : 막대기를 옆으로 세워줌, 색깔은 2번부터 14번
legend("topleft",colnames(df.train.scale),fill = 2:14, cex = 0.5,bty = "n")


#raw data에 cluster 붙힘
df$kmeans_cluster <- df.kmeans$cluster#변수만들어서 넣어줌
head(df,3)

# k medoids clustering
set.seed(2021)
fviz_nbclust(df.train.scale, pam ,method = "wss",k.max = 15)+
  theme_minimal()+
  ggtitle("the Elbow method")

#군집화
library(cluster)
df.kmedoids <- pam(df.train.scale,k =3) #elbow method 에서 k = 3 이나왔다.
plot(df.kmedoids)

#raw data에 k medoid cluster 변수추가
df$kmedoids_cluster <- df.kmedoids$clustering
head(df,3)  

#hierarchical Clustering
library(factoextra)

#군집 개수 설정
fviz_nbclust(df.train.scale,hcut,method = 'wss',k.max = 15)+ #hcut =hierarchical Clustering
  theme_minimal()+
  ggtitle("the Elbow Method")

fviz_nbclust(df.train.scale,hcut,method = "silhouette",k.max = 15)+ 
  theme_minimal()+
  ggtitle("Silhouette Plot")

#hierarchical clustering 은 군집개수를 설정하고 들어가는게 아니라, 가까운 데이터끼리 다 묶은 뒤 군집을 나눠준다.

#군집
#군집 구성 방식별 군집화 진행
df.hclust.single <- hclust(dist(df.train.scale),method = 'single')
df.hclust.cplit <- hclust(dist(df.train.scale),method = 'complete')
df.hclust.avg <- hclust(dist(df.train.scale),method = 'average')
df.hclust.ward <- hclust(dist(df.train.scale),method = 'ward.D')


#시각화 -> 군집 구성 방식 선택
par(mfrow=c(2,2))
plot(df.hclust.single, hang = -1, cex =0.4) #hang = -1 은 덴드로그램이 가장 밑단에서 시작되게
rect.hclust(df.hclust.single,k =3 ,border = 'skyblue') #rect.hclust 는 덴드로그램 위에 시각적으로 군집을 나눠줌
plot(df.hclust.cplit,hang = -1, cex =0.4)
rect.hclust(df.hclust.cplit,k=3,border = 'skyblue')
plot(df.hclust.avg,hang =-1,cex= 0.4)
rect.hclust(df.hclust.avg, k =3, border = 'skyblue')
plot(df.hclust.ward,hang = -1,cex = 0.4)
rect.hclust(df.hclust.ward,k=3,border = 'skyblue')

#군집화 및 군집할당

hclust_cluster <- cutree(df.hclust.ward,k =3) #cutree로 군집을 해서 cluster number을 뽑을수있다.
df$hclust_cluster <- hclust_cluster


head(df,3)

#분석 결과물



#df.dist = 유사도행렬

#-> 유사한 성격의 와인을 찾는데 사용



#df$kmeans_cluster,df$kmedoids_cluster,df$hclust_cluster = 군집데이터

#->다른 성격의 와인 그룹을 찾는데 활용


