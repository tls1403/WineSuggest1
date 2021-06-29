

df <- read.csv('wine.csv')
colnames(df) <- c('Cultivar','Alcohol','Malic acid','Ash','Alcalinity of ash','Magnesium', #변수들을 넣어줌
                  'Total phenols','Flavanoids','Nonflavanoid phenols',
                  'Proanthocyanins','Color intensity','Hue','OD280/OD315 of diluted wines','Proline')
str(df) #구조확인

#결측치 확인
colSums(is.na(df))
