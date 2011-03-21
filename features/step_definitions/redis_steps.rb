When /^I reset redis$/ do
  REDIS.flushdb
end
