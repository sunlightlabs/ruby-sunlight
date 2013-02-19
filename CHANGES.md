### 1.1.0 / 2010-05-18

* Added Gemfile (thanks Bobby Wilson)
* Removed support for deprecated API methods (thanks Steve Gass)
* Added new fields to match API fields (thanks Bobby Wilson)
* Cleaned up Rakefile (thanks Chris A)

### 1.0.7 / 2010-06-11

* Support for Ruby 1.9.x, specifically the JSON gem (thanks to Brian Cardarella)

### 1.0.6 / 2010-05-25

* Added committee.rb to the gemspec (thanks to Dan Melton)

### 1.0.5 / 2009-10-27

* Implement birthdate on Legislator as a Time object

### 1.0.4 / 2009-10-02

* Implement youtube_id for YouTube usernames

### 1.0.3 / 2009-09-03

* Be a good Ruby citizen and remove require 'rubygems'

### 1.0.2 / 2009-09-03

* Ensure that Base gets loaded first.

### 1.0.1 / 2009-07-28

* Account for the API returning district numbers as "01" instead of "1"

### 1.0 / 2009-06-25

* Move to the sunlightlabs GitHub account
* Fully support the Sunlight Labs API, notably the Committee methods

### 0.9.0 / 2009-03-15

* Warning: This release is not backwards-compatible!
* Change loading behavior of base functionality, works better with Rails and Merb
* Sunlight::SunlightObject is now Sunlight::Base
* For set up, Sunlight.api_key= is now Sunlight::Base.api_key=
* For set up, using "include 'Sunlight'" is no longer recommended
* Correct usage is Sunlight::Legislator.all_for(...) instead of just Legislator.all_for(...)
* Credit to Rue the Ghetto (rughetto on GitHub) and Eric Mill for inspiring the improvements above
* Add support for senate_class ("I", "II", or "III") and in_office (0 or 1) on Legislator
* Add support for Lobbyists, Filings, and Issues
* Huge credit to mindleak on GitHub for Lobbyist-related functionality

### 0.2.0 / 2009-03-01

* Add support for twitter_id and youtube_url on Legislator
* Add Legislator#search_by_name for fuzzy name searching
* Add Legislator#all_in_zipcode for better lookups on a five-digit zip code
* Raise exception when API Key isn't set
* Credit for various fixes goes to GitHub users pengwynn, hoverbird, and wilson

### 0.1.0 / 2008-08-20

* Initial version
