#!/bin/bash

# 1- Count most-watched Netflix title
the_most_watched=$(awk -F ',' '$3 > 0 { titles[$4]++ } END { max = 0; max_title = ""; for (title in titles) { if (titles[title] > max) { max = titles[title]; max_title = title } } print max_title }' vodclickstream_uk_movies_03.csv)

# We are considering the dataset where the duration is > 0 and for every title, we count the occurrences and then we assign the max title the one with the max occurrences

# -F ',' : means that the field separator is the comma
# $3 > 0 { titles[$4]++ } : we are selecting values >0 and for the every lines we increment a counter 'titles' based on the fourth column
# max = 0; max_title = ""; for (title in titles) { if (titles[title] > max) { max = titles[title]; max_title = title } } print max_title : in this last part we iterate, doing updates,
# until we find the max_title which is the title with more count


# 2- Calculate average time between subsequent clicks
average_time_secs=$(awk -F ',' 'NR > 1 { if (last_user == $7) { diff = mktime(gensub(/[-:]/," ","g", $2)) - last_time; sum += diff; count++ } last_time = mktime(gensub(/[-:]/," ","g", $2)); last_user = $7 } END { if (count > 0) { avg = sum / count; print avg }}' vodclickstream_uk_movies_03.csv)

# We are calculating the everage time between subsequent clicks based on the difference in datetime for each user

# -F ',': means that the field separator is the comma
#  NR > 1 : here we consider lines numbere > 1
# last_user == $7 : we are checking if the user_id is equal to the one before
# diff = mktime(gensub(/[-:]/," ","g", $2)) - last_time : we are doing the difference between the current and last click
# mktime covert datatime to unix timestamp, allowing easier computation and comparison of time differences in seconds
# sum += diff : we are adding the diff to the sum
# count++ : we are incrementing the 'count' that is the count of subsequent clicks
# avg = sum / count : in the last part we calculate the average


# 3- Find the user who spent the most time
iduser_most_time=$(awk -F ',' '$3 > 0 { duration[$8] += $3; user[$8] = $NF; } END { max_duration = 0; max_user = ""; for (u in duration) { if (duration[u] > max_duration) { max_duration = duration[u]; max_user = user[u]; } } if (max_user != "" && max_duration > 0) { print max_user; } }' vodclickstream_uk_movies_03.csv)

# We are considering the dataset where the duration is > 0 and for each user we calculate the sum of their time spent on Netflix
# and we consider the user with more time spent

# -F ',' : same as before
# $3 > 0 { duration[$8] += $3; user[$8] = $NF; } : we are considering the posive values for the column 3 which is the 'duration'
# for the lines we are considering we accumulate the duration for each user_id and stores the user_id in 'user'
# max_duration = 0; max_user = ""; for (u in duration) { if (duration[u] > max_duration) { max_duration = duration[u]; max_user = user[u]; } } if (max_user != "" && max_duration > 0) { print max_user; } :
# in this last part we iterate with the for cycle and in the end we find the user with most time spent = 'max_user'

# Printing the results
echo "The most-watched Netflix title is: $the_most_watched"
echo "The average time between subsequent clicks is: $average_time_secs seconds"
echo "The ID of the user that has spent the most time on Netflix is: $iduser_most_time"

