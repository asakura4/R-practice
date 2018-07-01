#Lab1

#Initialize the R enRvironment
#Only needed if you run this outside Data Scientist Workbench or a SparkR shell
sc <- sparkR.init()

#Executing this creates a SQL context using SparkR context
#Make the name of the variable something you can remember, as you'll need the SQL context for most functions
sqlContext <- sparkRSQL.init(sc)

#Create a data frame called "cars" using R's native dataset "mtcars"
cars <- createDataFrame(sqlContext, mtcars)

#Create a temporary SQL table called "cars" using our SparkR data frame "cars"
registerTempTable(cars,"cars")

#Look at the first six rows of our "cars" SparkR data frame
#You need the SparkR:: prefix due to R already having a head function
SparkR::head(cars)

#Look at the schema for our SparkR data frame "cars"
printSchema(cars)


#Lab2

#Initiate our SQL Context
sqlContext <- sparkRSQL.init(sc)
#Create a Data Frame called "cars" from the mtcars dataset
cars <- createDataFrame(sqlContext,mtcars)
#Create a Data Frame called "flowers" from the iris dataset
flowers <- createDataFrame(sqlContext,iris)

#Select from the "cars" data frame the "mpg" column
#select(cars,cars$mpg)
#Select the first six rows of the "mpg" column from the "cars" data frame
#Remember that you have to add the SparkR:: prefix to head since R already has an incompatible head function
SparkR::head(select(cars,cars$mpg))

#Select the first six rows of "cars" that have a value under 20 in the "mpg" column
#We have to use the SparkR:: prefix since R already has a conflicting filter function
SparkR::head(SparkR::filter(cars, cars$mpg < 20))

#Select the first six elements of the grouping of "cars" by its "mpg" column, plus the count of the occurrances of that given
#"mpg" value in the dataset
SparkR::head(summarize(groupBy(cars, cars$mpg), count = n(cars$mpg)))

#Select the first six elements of the grouping of "cars" by its "mpg" column, plus the sum of all occurrances of that given
#"mpg" value in the dataset
SparkR::head(summarize(groupBy(cars, cars$mpg), sum = sum(cars$mpg)))

#Select the first six elements of the grouping of "cars" by its "mpg" column, plus the average of all "hp" column values
#in rows which have that given "mpg" value
SparkR::head(summarize(groupBy(cars, cars$mpg), average = avg(cars$hp)))

#Make a variable called "group" which is the grouping of "cars" by its "mpg" column, plus the average of all "hp" column values 
#in rows which have that given "mpg" value
group <- summarize(groupBy(cars, cars$mpg), average = avg(cars$hp))

#Take the first six elements of "group" which are ordered in decreasing "average" column value order
SparkR::head(arrange(group, desc(group$average)))

#In the "cars" data frame, change the "mpg" (miles per gallon) column to miles per liter and then change it back
#1 gallon is 3.78541178 liters
cars$mpg <- cars$mpg/3.78541178
SparkR::head(cars)
#Change it back
cars$mpg <- cars$mpg*3.78541178
SparkR::head(cars)

#Create a temporary SQL table called "cars" using our SparkR data frame "cars"
registerTempTable(cars,"cars")

#Select the first six rows from the "cars" data frame where the value of the "cyl" column is greater than 6
SparkR::head(sql(sqlContext, "SELECT * FROM cars WHERE cyl > 6"))


#lab3 

#Initiate our SQL Context
sqlContext <- sparkRSQL.init(sc)
#Create a Data Frame called "cars" from the mtcars dataset
cars <- createDataFrame(sqlContext,mtcars)
#Create a Data Frame called "flowers" from the iris dataset
flowers <- createDataFrame(sqlContext,iris)

#Create a GLM of the Gaussian family of models, using the formula that has "mpg" as the response variable and
#"hp" and "cyl" as the predictors.
model <- SparkR::glm(mpg ~ hp + cyl, data = cars, family = "gaussian")

#Retrieve the data from our model
SparkR::summary(model)

#Create predictions based on the model created
predictions <- SparkR::predict(model, newData = cars)
SparkR::head(select(predictions, "mpg", "prediction"))

#Create a Binomial GLM, using the formula that has "am" as the response variable and "hp", "mpg" and "wt" as the predictors
model <- SparkR::glm(am ~ hp + mpg + wt, data = cars, family = "binomial")

#Retrieve data from our model
SparkR::summary(model)

#Create predictions based on the model created
predictions <- SparkR::predict(model, newData = cars)
SparkR::head(select(predictions, "am", "prediction"))