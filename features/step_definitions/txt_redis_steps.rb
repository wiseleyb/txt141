When /^I generate a token$/ do
  @token = TxtRedis.generate_token
end

When /^I get the saved count$/ do
  @saved_count = TxtRedis.saved
end

When /^I get a url with "([^"]*)"$/ do |text|
  @text = text
  @url = TxtRedis.get_url(text)
  @token = token_from_url(@url)
end

Then /^the saved count should increase by (\d+)$/ do |amount|
  assert TxtRedis.saved == @saved_count + amount.to_i
end

Then /^it should have base_url and the token$/ do 
  assert @url.include?(BASE_URL)
  assert token_from_url(@url) == @token
end

When /^I look up the token$/ do
  @text = TxtRedis.get_txt(@token)
end

When /^I get served count$/ do
  @served_count = TxtRedis.served
end

Then /^served count should increase by (\d+)$/ do |amount|
  assert TxtRedis.served == @served_count + amount.to_i
end

Then /^the text should be "([^"]*)"$/ do |text|
  assert @text == text
end

When /^I get a url with a long string$/ do
  @url = TxtRedis.get_url(long_string)
end

When /^I get_txt_for_client with a length of (\d+)$/ do |size|
  txt = TxtRedis.get_txt(token_from_url(@url))
  @text_for_client = TxtRedis.get_txt_for_client(txt, @url, size.to_i)
end

Then /^I should get the characters minus url minus (\d+) and a total length of (\d+)$/ do |s1, s2|
  assert @text_for_client.size == s2.to_i
  s3 = @text_for_client.size - @url.size - s1.to_i - 1
  assert @text_for_client[0..s3] == long_string[0..s3]
end

When /^I santize the test string$/ do
  @sanitized_string = TxtRedis.sanitize(sanitize_test_string)
end

Then /^it should equal the sanitized test string$/ do
  assert @sanitized_string == sanitized_test_string
end

def long_string
  %(In pellentesque faucibus vestibulum. Nulla at nulla justo, eget luctus tortor. Nulla facilisi. Duis aliquet egestas purus in blandit. Curabitur vulputate, ligula lacinia scelerisque tempor, lacus lacus ornare ante, ac egestas est urna sit amet arcu. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Sed molestie augue sit amet leo consequat posuere. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Proin vel ante a orci tempus eleifend ut et magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus luctus urna sed urna ultricies ac tempor dui sagittis. In condimentum facilisis porta. Sed nec diam eu diam mattis viverra. Nulla fringilla, orci ac euismod semper, magna diam porttitor mauris, quis sollicitudin sapien justo in libero. Vestibulum mollis mauris enim. Morbi euismod magna ac lorem rutrum elementum. Donec viverra auctor lobortis. Pellentesque eu est a nulla placerat dignissim. Morbi a enim in magna semper bibendum. Etiam scelerisque, nunc ac egestas consequat, odio nibh euismod nulla, eget auctor orci nibh vel nisi. Aliquam erat volutpat. Mauris vel neque sit amet nunc gravida congue sed sit amet purus. Quisque lacus quam, egestas ac tincidunt a, lacinia vel velit. Aenean facilisis nulla vitae urna tincidunt congue sed ut dui. Morbi malesuada nulla nec purus convallis consequat. Vivamus id mollis quam. Morbi ac commodo nulla. In condimentum orci id nisl volutpat bibendum. Quisque commodo hendrerit lorem quis egestas. Maecenas quis tortor arcu. Vivamus rutrum nunc non neque consectetur quis placerat neque lobortis. Nam vestibulum, arcu sodales feugiat consectetur, nisl orci bibendum elit, eu euismod magna sapien ut nibh. Donec semper quam scelerisque tortor dictum gravida. In hac habitasse platea dictumst. Nam pulvinar, odio sed rhoncus suscipit, sem diam ultrices mauris, eu consequat purus metus eu velit. Proin metus odio, aliquam eget molestie nec, gravida ut sapien. Phasellus quis est sed turpis sollicitudin venenatis sed eu odio. Praesent eget neque eu eros interdum malesuada non vel leo. Sed fringilla porta ligula egestas tincidunt. Nullam risus magna, ornare vitae varius eget, scelerisque a libero. Morbi eu porttitor ipsum. Nullam lorem nisi, posuere quis volutpat eget, luctus nec massa. Pellentesque aliquam lacinia tellus sit amet bibendum. Ut posuere justo in enim pretium scelerisque. Etiam ornare vehicula euismod. Vestibulum at risus augue. Sed non semper dolor. Sed fringilla consequat velit a porta. Pellentesque sed lectus pharetra ipsum ultricies commodo non sit amet velit. Suspendisse volutpat lobortis ipsum, in scelerisque nisi iaculis a. Duis pulvinar lacinia commodo. Integer in lorem id nibh luctus aliquam. Sed elementum, est ac sagittis porttitor, neque metus ultricies ante, in accumsan massa nisl non metus. Vivamus sagittis quam a lacus dictum tempor. Nullam in semper ipsum. Cras a est id massa malesuada tincidunt. Etiam a urna tellus. Ut rutrum vehicula dui, eu cursus magna tincidunt pretium. Donec malesuada accumsan quam, et commodo orci viverra et. Integer tincidunt sagittis lectus. Mauris ac ligula quis orci auctor tincidunt. Suspendisse odio justo, varius id posuere sit amet, iaculis sit amet orci. Suspendisse potenti.)
end

def sanitize_test_string
  "bob <b>bob</b>"
end

def sanitized_test_string
  "bob bob"
end

def token_from_url(url)
  url.split("/").last
end