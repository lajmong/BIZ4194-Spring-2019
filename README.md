# BIZ4194-Spring-2019
R files and one Rapid Miner file for data mining in Business Analytics course, BIZ4194.

1. Assignments dealing with various data mining methods; naive bayesian, kNN, decision tree, neural network
2. Group project analyzes video game sales from a data obtained from kaggle
(https://www.kaggle.com/rush4ratio/video-game-sales-with-ratings)


### Objective <br>
Find elements that influence the sales of video games and predict future release game sales <br>

### Program Used
R studio

### Variables
* Input = Platform, Genre, Publisher, Critic_score, User_score, Rating
* Output = NA_sales, EU_sales, JP_sales, Other_sales, Global_sales


### Preprocessing (Common)
<img width="681" alt="pp" src="https://user-images.githubusercontent.com/49318161/62003607-543a8000-b154-11e9-9f7c-1692a0bc8903.png"> <br>
-- Outliers in output variable -> Cut off 2.5% of each end of the data and used only 95% <br>
-- Critic_score: Divided the score by 10 (max score: 100 -> 10)

### Data Mining Method
#### 1. Naive Baysian
* Preprocessing

-- Platform: Divided into 5 categories(DS, PC, PS, Wii, XBox) <br>
-- User_score, Critic_score, Sales(NA, JP, EU): <br>
changed type from numeric to factor, divided into 4 bins by respective 25%, 50%, 75% points.<br>

* Process

-- Ran the program 3 times depending on the region(ex. NA, JP, EU) <br>
-- Input: Platform, Genre, Publisher, Rating, Critic_score, User_score <br>
-- Output: Sales(NA, JP, EU)<br>


#### 2. Neural Network
* Preprocessing

-- Critic_score, User_score: rounded from the second decimal point and normalized the values to 0~1
-- Global_sales: if Global_sales >= 1million then hit (changed type numeric to factor)

* Process

Ran two separate tests where the output variable is the same(Global_sales) and input variables different. <br>
1. Designated input variables as Critic_score and User_score. <br>
2. Designated input variables that seem to be irrelevant with marketing success, such as Platform, Genre and Rating and ran the test again.


#### 3. k-NN
* Process

Ran three separte tests with different criteria of Global_sales being a 'success' and 'failure'. First was the median value, 0.29 the other two were random numbers 1.0 and 1.5. The plot was drawn with Critic_score in the x-axis and User_score in the y-axis.
