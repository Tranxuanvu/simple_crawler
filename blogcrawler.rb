require 'selenium-webdriver'
require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require './recursive_visit'
require 'os'
require 'pry'

if OS.linux?
  Selenium::WebDriver::Chrome.driver_path="./chromedriver_linux64"
elsif OS.windows?
  Selenium::WebDriver::Chrome.driver_path="./chromedriver_win32.exe"
else
  Selenium::WebDriver::Chrome.driver_path="./chromedriver_mac64"
end

Capybara.configure do |config|

  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end

  config.default_driver = :selenium
  config.run_server = false
  config.always_include_port = false

end

class BlogCrawler
  include Capybara::DSL

  attr_reader :paths

  def initialize(paths, options = {})
    @paths = paths.is_a?(Array) ? paths : [paths]
    options.merge! options
  end

  def options
    @options ||= { total: 20, times: 20 }
  end

  def explore
    links = page.all('a')
    RecursiveVisit.new(links, options.fetch(:total)).view_link
  end

  def run
    @paths.each do |path|
      visit path
      options.fetch(:times).times do |i|
        # explore
      end
      sleep 3
    end
  end
end

def usage
  puts "
    Usage: ruby blogcrawler.rb [options]
      -h , --help                                  Show this help.
      -p=domains, --paths=domains                  Domain of page want to visit. Ex: http://example.com
      -t=number, --times=number                    Number of times visit domain
      -tpl=number,  --times_per_link=number        Number of times per link in domain
  "
end

if !ARGV.empty?
  args = Hash[ ARGV.flat_map{|s| s.scan(/--?([^=\s]+)(?:=(\S+))?/) } ]
  return usage unless args.key?('paths') || args.key?('p')

  paths = args['paths'] || args['p']
  times = args['times'] || args['t']
  times_visit_one_link = args['times_per_link'] || args['tpl']
  options = { total: times_visit_one_link.to_i, times: times.to_i }
  options = {} unless times_visit_one_link || times

  BlogCrawler.new(paths, options).run
else
  usage
end
