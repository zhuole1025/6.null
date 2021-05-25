# Data Wrangling
* Definition: take data in one format and turn it into a different format
* We can use `|` operator
    ```shell
    last | grep Mon | less # less gives us a 'pager' that allows us to scroll up and down the data
    ```
* Sed: a stream editor
    * `s/REGEX/SUBSTITUTION` : substitution
	```shell
	last | grep Mon | sed 's/.*
  last | grep May | sed 's/.*ttys/hahaha/'
  last | grep May | sed -E 's/.*ttys(000|001)+/hahaha/'
  last | grep May | sed -E 's/.*ttys(000|001)(.*)(Tue|Wed) May.*$/\3/'
  last | grep May | sed -E 's/.*ttys00[0-9].*[A-Z]+[a-z]+ [0-9]+ //'
  last | grep May | sed -E 's/.*ttys00[0-9].*[A-Z]+[a-z]+ [0-9]+ //' | sort | uniq -c | sort -nk1,1 | tail -n10 | awk '{print $2}'
  last | grep May | sed -E 's/.*ttys00[0-9].*[A-Z]+[a-z]+ [0-9]+ //' | sort | uniq -c | sort -nk1,1 | tail -n10 | awk '$1 == 1 && $2 ~ /^reboot$/ {print $2}' | wc -l
	```


* Regular expression
    * `.` means “any single character” except newline
    * `*` zero or more of the preceding match
    * `+` one or more of the preceding match
    * `[abc]` any one character of `a`, `b`, and `c`
    * `(RX1|RX2)` either something that matches `RX1` or `RX2`
    * `^` the start of the line
    * `$` the end of the line
    * Use `-E` to avoid some weird problem relating to above commands to avoid some weird problem relating to above commands
    * [Regex debugger](https://regex101.com)
* Useful tools
	* sort
	* uniq
	* wc
	* paste
	* awk: based on columns
	* bc: An arbitrary precision calculator language
	* R: a progamming languague for statistics
	* gnuplot
	* xargs
	* ffmpeg
---
#### Exercise
1. Take this [short interactive regex tutorial](https://missing.csail.mit.edu/2020/data-wrangling/).
2. Find the number of words (in `/usr/share/dict/words`) that contain at least three `a`s and don’t have a `'s` ending. What are the three most common last two letters of those words? `sed`’s y command, or the `tr` program, may help you with case insensitivity. How many of those two-letter combinations are there? And for a challenge: which combinations do not occur?
  * number of words: 5290
      ```shell
      cat /usr/share/dict/words | grep -E "^(.*[aA]){3,}.*[^s]$" | uniq -c | wc -l
      ```
  * three most common last two letters of those words: `ae:637` `an:763` `al:1039`
      ```shell
      cat /usr/share/dict/words | grep -E "^(.*[aA]){3,}.*[^s]$" | uniq -c | wc -l
      ```
  * how many of those two-letter combinations: `140`
      ```shell
      cat /usr/share/dict/words | grep -E "^(.*[aA]){3,}.*[^s]$" | sed -E "s/^.*(..)$/\1/" | sort | uniq -c | wc -l
      ```
  * which combinations do not cccur :
      ```shell
      cat /usr/share/dict/words | grep -E "^(.*[aA]){3,}.*[^s]$" | sed -E "s/^.*(..)$/\1/" | sort | uniq > occured
      printf "%s\n" {a..z}{a..z} > all_two-letter
      comm -3 occured all_teo-letter | awk '{print $1}' > ans
      paste -s -d , ans > ans
      cat ans
      ```
3. To do in-place substitution it is quite tempting to do something like `sed s/REGEX/SUBSTITUTION/ input.txt > input.txt`. However this is a bad idea, why? Is this particular to sed? Use man sed to find out how to accomplish this.
  * `sed -i s/REGEX/SUBSTITUTION/ input.txt`
4. Find your average, median, and max system boot time over the last ten boots. Use journalctl on Linux and log show on macOS, and look for log timestamps near the beginning and end of each boot.
  * 
      ```shell
      sudo apt install r-base
      journalctl | grep -e "userspace" | head -n 10 | sed -E 's/^.*= (.*)s\./\1/g' | R --slave -e 'x <- scan(file="stdin", quiet=TRUE); summary(x)'
      ```
5. Look for boot messages that are not shared between your past three reboots (see `journalctl`’s `-b` flag).
  * 
  ```shell
  touch uniq_messages
  journalctl -b | tail -n +2 | sed -E 's/^.*kali (.*)$/\1/' | sort | uniq | sort >> uniq_messages
  journalctl -b -1 | tail -n +2 | sed -E 's/^.*kali (.*)$/\1/' | sort | uniq | sort >> uniq_messages
  journalctl -b -2 | tail -n +2 | sed -E 's/^.*kali (.*)$/\1/' | sort | uniq | sort >> uniq_messages
  # Shared
  cat uniq_messages | sort | uniq -c | awk '{print $1}' | grep 3 | wc -l
  # Not Shared
  cat uniq_messages | sort | uniq -c | awk '{print $1}' | grep -v 3 | wc -l
  # All 7408 unshared lines
  cat uniq_messages | sort | uniq -c | sort -n |awk '{$1=$1};1'| sed -nE 's/^[^3] (.*)$/\1/p'
 ```
6. Find an online data set. Fetch it using curl and extract out just two columns of numerical data. If you’re fetching HTML data, `pup` might be helpful. For JSON data, try jq. Find the min and max of one column in a single command, and the sum of the difference between the two columns in another.
  * 
      ```shell
      wget https://ucr.fbi.gov/crime-in-the-u.s/2016/crime-in-the-u.s.-2016/topic-pages/tables/table-1
      cat table-1 | pup 'td.group1 text{}'
      cat table-1 | pup 'td.group2 text{}'
      ```
