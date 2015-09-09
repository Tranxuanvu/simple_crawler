class RecursiveVisit
  include Capybara::DSL

  SLEEP_TIME = 2

  def initialize(links, total = 300)
    @links = links.map { |link| link[:href] }
    @total = total
  end

  def view_link
    @total.times do |i|
      print "NEW LOOP #{i} \n"
      subset_link.each do |link|
        puts "visit #{link}"

        visit link
        sleep rand(SLEEP_TIME)
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
    print @links
  end
end
