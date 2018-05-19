class RecursiveVisit
  include Capybara::DSL

  SLEEP_TIME = 5

  def initialize(links, total = 300)
    @links = links.map { |link| link[:href] }.compact
    @links.reject!{|link| !link.match('https?:\/\/[\S]+')}
    @total = total
  end

  def view_link
    @total.times do |i|
      print "NEW LOOP #{i} \n"
      subset_link.each do |link|
        puts "visit #{link}"

        visit link
        sleep SLEEP_TIME
      end

      reset_session
    end
  end

  private

  def reset_session
    Capybara.reset_sessions!
  end

  def subset_link
    @links.sample(rand(@links.count) + 1)
  end
end
