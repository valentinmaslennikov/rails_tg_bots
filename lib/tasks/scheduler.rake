task :check_availability => :environment do
  1.upto(9) do |i|
    start_time = DateTime.now
    Checker::Ps5Checker.call
    end_time = DateTime.now
    wait_time = 60 - ((end_time - start_time) * 24 * 60 * 60).to_i
    sleep wait_time if wait_time > 0
  end
end