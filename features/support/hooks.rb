After("@timecop") do
  Timecop.return
end

Before("@capsulecrm") do
  @capsule_cleanup = []
end

After("@capsulecrm") do
  @capsule_cleanup.each do |x|
    x.delete!
  end
end