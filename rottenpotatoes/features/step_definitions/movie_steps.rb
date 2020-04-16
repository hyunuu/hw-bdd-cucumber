# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(:title => movie["title"], :rating => movie["rating"], :release_date => movie["release_date"])
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  temp = page.body.split(e2)
  expect(temp[0].include? e1).to eq true
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  if uncheck
    rating_list.split.each do |rating|
      step %{I uncheck "#{"ratings_"+rating.chomp(",")}"}
      #uncheck("ratings_"+rating.chomp(","))
    end
  else
    rating_list.split.each do |rating|
      #check("ratings_"+rating.chomp(","))
      step %{I check "#{"ratings_"+rating.chomp(",")}"}
    end
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  rows = all("table#movies tr").count
  expect(rows).to eq 11
end
