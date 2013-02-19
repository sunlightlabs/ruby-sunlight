# Ruby Sunlight client

## Description

A Ruby wrapper for the Sunlight Congress API. From the [full API documentation](http://sunlightlabs.github.com/congress/):

> A live JSON API for the people and work of Congress, provided by the Sunlight Foundation.

Find who represents you:

* Look up legislators by location or by zip code.
* Official Twitter, YouTube, and Facebook accounts.
* Committees and subcommittees in Congress, including memberships and rankings.

Or Congress' daily work:

* All introduced bills in the House and Senate, and what occurs to them (updated daily).
* Full text search over bills, with powerful Lucene-based query syntax.
* Real time notice of votes, floor activity, and committee hearings, and when bills are scheduled for debate.

## Installation

```
gem install sunlight
```

The sunlight gem works in Ruby 1.8 or 1.9.

## Set Up

First, register for an API key](http://services.sunlightlabs.com/api/register/] 

Then, you'll want to stick the following lines somewhere in your Ruby environment:

```ruby
require 'sunlight'
Sunlight::Base.api_key = 'your-api-key'
```

## Usage

The Sunlight gem fully wraps the Sunlight Labs API.

### Legislator

Time to get to the good stuff. The most useful method is @Legislator#all_for@:

```ruby
congresspeople = Sunlight::Legislator.all_for(:address => "123 Fifth Ave New York, NY 10003")
senior_senator = congresspeople[:senior_senator]
junior_senator = congresspeople[:junior_senator]
representative = congresspeople[:representative]

junior_senator.firstname          # returns "Kirsten" 
junior_senator.lastname           # returns "Gillibrand"   
junior_senator.congress_office    # returns "531 Dirksen Senate Office Building"
junior_senator.phone              # returns "202-224-4451"  
```

Note that you should make the best attempt to get a full street address, as that is geocoded behind the scenes into a lat/long pair. If all you have is a five-digit zip code, you should not use @Legislator#all_for@, instead opting for @Legislator#all_in_zipcode@ (see below). If you pass in a zip+4, then go ahead and use @Legislator#all_for@.

So @Legislator#all_for@ returns a hash of @Legislator@ objects, and the keys are @:senior_senator@, @:junior_senator@, and @:representative@. Make sure to review all the available fields from the "Sunlight Labs API":http://services.sunlightlabs.com/api/docs/legislators/. You can also pass in a lat/long pair:

```ruby
congresspeople = Sunlight::Legislator.all_for(:latitude => 33.876145, :longitude => -84.453789)
```

This bypasses the geocoding necessary by the Google Maps API. For social networks and other applications with a User object, it makes sense to geocode the user's address up front and save the lat/long data in the local database. Then, use the lat/long pair instead of address, which cuts a substantial bit of time from the @Legislator#all_for@ request since the Google Maps API Geocoding function doesn't have to be called.

Have a five-digit zip code only? You can use the @Legislator#all_in_zipcode@ method, but keep in mind that a single zip may have multiple U.S. Representatives, as congressional district lines frequently divide populous zip codes. Unlike @Legislator#all_for@, this method returns an array of legislators, and it'll be up to you to parse through them (there will be a senior senator, a junior senator, and one or more representatives).

```ruby
members_of_congress = Sunlight::Legislator.all_in_zipcode(90210)

members_of_congress.each do |member|
	# do stuff
end
```

You can also use the @Legislator#all_where@ method for searching based on available fields. Again, you'll get back an array of @Legislator@ objects:

```ruby
johns = Sunlight::Legislator.all_where(:firstname => "John")
floridians = Sunlight::Legislator.all_where(:state => "FL")
dudes = Sunlight::Legislator.all_where(:gender => "M")

johns.each do |john|
  # do stuff
end
```

Lastly, to provide your users with a name search functionality, use @Legislator#search_by_name@, which uses fuzzy matching to compensate for nicknames and misspellings. So "Ed Markey" (real name Edward Markey) and "Jack Murtha" (real name John Murtha) will return the correct matches. You can specify a higher confidence threshold (default set to 0.80) if you feel that the matches being returned aren't accurate enough. This also returns an array of @Legislator@ objects:

```ruby
legislators = Sunlight::Legislator.search_by_name("Ed Markey")
legislators = Sunlight::Legislator.search_by_name("Johnny Boy Kerry", 0.91)
```


### District

There's also the @District@ object. @District#get@ takes in either lat/long or an address and does it's best to return the correct Congressional District:

```ruby
district = Sunlight::District.get(:latitude => 33.876145, :longitude => -84.453789)
district.state            # returns "GA"
district.number           # returns "6"

district = Sunlight::District.get(:address => "123 Fifth Ave New York, NY") 
```

Finally, two more methods, @District.all_from_zipcode@ and @District.zipcodes_in@, help you out when you want to get all districts in a given zip code, or if you want to get back all zip codes in a given district.

```ruby
districts = Sunlight::District.all_from_zipcode(90210)    # returns array of District objects
zipcodes = Sunlight::District.zipcodes_in("NY", "10")     # returns array of zip codes as strings  ["11201", "11202", "11203",...]
```


### Committees

Members of Congress sit on all-important @Committees@, the smaller bodies that hold hearings and are first to review legislation.

The @Committee@ object has three identifying fields, and an array of subcommittees, which are @Committee@ objects themselves. To get all the committees for a given chamber of Congress:

```ruby
committees = Sunlight::Committee.all_for_chamber("Senate") # or "House" or "Joint"
some_committee = committees.last
some_committee.name       # "Senate Committee on Agriculture, Nutrition, and Forestry"
some_committee.id         # "SSAF"
some_committee.chamber    # "Senate"

some_committee.subcommittees.each do |subcommittee|
  # do some stuff...
end
```

The @Committee@ object also keeps a collection of members in that committee, but since that's an API-heavy call, it must be done for each Committee one at a time:

```ruby
committees = Sunlight::Committee.all_for_chamber("Senate") # or "House" or "Joint"
some_committee = committees.last    # some_committee.members starts out as nil
some_committee.load_members         # some_committee.members is now populated
some_committee.members.each do |legislator|
  # do some stuff...
end
```

Coming from the opposite direction, the @Legislator@ object has a method for getting all committees for that particular Legislator, returning an array of @Committee@ objects:

```ruby
legislators = Sunlight::Legislator.search_by_name("Byron Dorgan")
legislator = legislators.first
legislator.committees.each do |committee|
  # do some stuff...
end
```


## License

See the terms of usage for the [Sunlight Foundation's APIs](http://services.sunlightlabs.com/accounts/register/#tos).

Copyright &copy; 2009 by Luigi Montanez and the Sunlight Foundation. See LICENSE for more information.
