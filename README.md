# Simple Viewer
## Install
- install ruby version 2.3.1
- `git clone https://github.com/Tranxuanvu/simple_viewer.git`
- `bundle`
## Usage
```
  ruby blogcrawler.rb [options]
    -h , --help                                  Show this help.
    -p=domains, --paths=domains                  Domain of page want to visit. Ex: http://example.com
    -t=number, --times=number                    Number of times visit domain
    -tpl=number,  --times_per_link=number        Number of times per link in domain
```
- Example:

  `ruby blogcrawler.rb -p=http://example.com -t=5 -tpl=2`
  
  `ruby blogcrawler.rb -p=[http://example.com] -t=5 -tpl=2`
