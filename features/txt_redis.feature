Feature: test the TxtRedis object
  As a txt141 owner
  I want need TxtRedis to work
  In order to store and retrieve data

  Scenario: Ensure unique codes
		When I generate a token

	Scenario: Test get_url
		When I get the saved count
		When I get a url with "bob eats lunch"
		Then the saved count should increase by 1
		Then it should have base_url and the token
		When I look up the token
		Then the text should be "bob eats lunch"
		
	Scenario: Test get_txt
		When I get served count
		When I get a url with "bob eats lunch"
		When I look up the token
		Then served count should increase by 1
		Then the text should be "bob eats lunch"
		
	Scenario: Test get_text_for_client
		When I get a url with a long string
		When I get_txt_for_client with a length of 140
		Then I should get the characters minus url minus 4 and a total length of 140
		# When I get_txt_for_client with a length of 420
		# Then I should get the characters minus url minus 4 and a total length of 420
	
	Scenario: Test sanitize
		When I santize the test string
		Then it should equal the sanitized test string
		
