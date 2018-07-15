# linkpage
Generate html page with bookmarks  

The link page will be generated based on a list of URLs in an `INI` file format:  
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
