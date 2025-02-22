**Retail Click Stream Data**

**Introduction**

So far, in this course, you have learned about the Hadoop Framework, RDBMS design, and Hive Querying. You have understood how to work with an EMR cluster and write optimized queries on Hive. 

 This assignment aims at testing your skills in Hive and Hadoop concepts learned throughout this course. Similar to Big Data Analysts, you will be required to extract the data, load them into Hive tables, and gather insights from the dataset.
 
**Problem Statement**

With online sales gaining popularity, tech companies are exploring ways to improve their sales by analyzing customer behavior and gaining insights about product trends. Furthermore, the websites make it easier for customers to find the products that they require without much scavenging. Needless to say, the role of big data analysts is among the most sought-after job profiles of this decade. Therefore, as part of this assignment, we will be challenging you, as a big data analyst, to extract data and gather insights from a real-life data set of an e-commerce company.

One of the most popular use cases of Big Data is in eCommerce companies such as Amazon or Flipkart. So before we get into the details of the dataset, let us understand how eCommerce companies make use of these concepts to give customers product recommendations. This is done by tracking your clicks on their website and searching for patterns within them. This kind of data is called a clickstream data. Let us understand how it works in detail.

The clickstream data contains all the logs as to how you navigated through the website. It also contains other details such as time spent on every page, etc. From this, they make use of data ingesting frameworks such as Apache Kafka or AWS Kinesis in order to store it in frameworks such as Hadoop. From there, machine learning engineers or business analysts use this data to derive valuable insights. 

For this assignment, you will be working with a public clickstream dataset of a cosmetics store. Using this dataset, your job is to extract valuable insights which generally data engineers come up with in an e-retail company. So now, let us understand the dataset in detail.

You will find the data in the link given below.

https://e-commerce-events-ml.s3.amazonaws.com/2019-Oct.csv

https://e-commerce-events-ml.s3.amazonaws.com/2019-Nov.csv
