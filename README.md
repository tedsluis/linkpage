# linkpage
Generate html page with bookmarks
* Creates single `index.html` file with links.
* Generation based on an `INI` file with URLs.
* Generated using a bash script.
* Links categorized on seperate page tabs.
* Opens URLs in a new browser tab.
  
## Screenshots
[![Linkpage screenshot](https://raw.githubusercontent.com/tedsluis/linkpage/master/screenshot.git)](https://raw.githubusercontent.com/tedsluis/linkpage/master/screenshot.gif)
Try it: http://htmlpreview.github.io/?https://github.com/tedsluis/linkpage/blob/master/index.html


## URLs url.ini file
The link page will be generated based on a list of URLs in the url.ini file. This file has an `INI` file format:  
```
[Learning]
https://instruqt.com;Instruqt
https://www.edx.org;EDX
https://www.pluralsight.com:Plurasight
https://training.linuxfoundation.org
https://eu.udacity.com;Udacity
https://www.cncf.io/certification/training;Cloud Native Computing Foundation
[Tools]
https://www.ipaddressguide.com
[Bash]
https://www.gnu.org/software/bash/manual;GNU Bash manual
https://github.com/dylanaraps/pure-bash-bible;The Pure Bash Bible;A collection of pure bash alternatives to external processes.
[Golang]
https://golang.org
https://github.com/golang
https://gobyexample.com;Golang by example.
etc....
```
  
## File format  
The `INI` format is of the url.ini:   
* The `INI` file must contain one or more [SECTIONS].
* Each [SECTION] must be followed by one or more line(s) with a URL.
* Each line with an URL can also contain a display TEXT and a TITLE (displayed while mouse hoover).
```
[<SECTION NAME>]  
<URL>[;[<TEXT>[;[<TITLE>]]]]
```
* SECTION NAME = Display name tab (mandatory). Each section will create a new tab page.
* URL = Link address (mandatory).
* TEXT = Text displayed on the link page (optional). If not specified, the URL will be displayed.
* TITLE = Additional description, displayed when mouse hoover (optional). When TEXT is specified, the URL is added to the TITLE.
  
## Generate index.html
To re-generate a new `index.html` file, run the `create-link-page.sh` script:  
```
$ ./create-link-page.sh 

Read url.ini:
number of sections: 13
number of URLs: 77
number of lines skipped: 16
number of lines that didn't match: 0

URLs per section:
Azure......(6)
Bash..(2)
Cloud...........(11)
Golang...(3)
Kubernetes....(4)
Learning......(6)
My-Github..................(18)
News..(2)
PERL....(4)
PowerShell..(2)
Social-media...........(11)
Tools.(1)
Weather.......(7)

New index.html generated!
```
