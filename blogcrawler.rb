require 'selenium-webdriver'
require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require './recursive_visit'  

Capybara.configure do |config|

  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end

  config.current_driver = :selenium
  config.run_server = false
  # config.app_host   = 'http://blog.tenluaweb.com'
  config.always_include_port = false

end

class BlogCrawler
  include Capybara::DSL

  attr_reader :paths, :tags

  def initialize(paths, options = {})
    @paths = paths.is_a?(Array) ? paths : [paths]
    option.merge! options
  end

  def option
    @option ||= { total: 20 }
  end

  def explore
    links = page.all('a')
    RecursiveVisit.new(links, option.fetch(:total)).view_link
  end

  def search_google
    visit "http://www.google.com.vn/"
    fill_in 'gbqfq', :with => 'tenluaweb.com'
    # find(:id, 'gbqfq').native.send_keys('tenluaweb.com')
    find(:id, 'gbqfb').click

    20.times do |i|
      within(:xpath, '//div[@id="ires"]') do
        search_res = page.all('a')
        result = search_res.map { |link| link[:href] }
        puts result
        # result.each do |_link|
        #   puts "visit #{_link}"
        #   visit _link
        sleep 3
        # end
        # explore
      end
      i = i + 1
    end
    sleep 3
  end

end

BlogCrawler.new('').search_google
