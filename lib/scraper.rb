require 'open-uri'
require 'pry'
class Scraper

  def self.scrape_index_page(index_url) #takes the index page url and spits out a hash with each :name, :location and :profile_url
    index_page = Nokogiri::HTML(open("https://learn-co-curriculum.github.io/student-scraper-test-page/"))
    hash_array = []
    index_page.css(".student-card").each do |card|
      student_hash = {}
      student_hash[:name] = card.css(".student-name").text
      student_hash[:location] = card.css(".student-location").text
      student_hash[:profile_url] = card.css("a").first["href"]
      hash_array << student_hash
    end
    hash_array
  end

  def self.scrape_profile_page(profile_url) #takes a profile url and returns twitter, linkedin, github, blog, profile_quote and bio
    profile_page = Nokogiri::HTML(URI.open(profile_url))
    scraped_student = {}
    count = 0
    if profile_page.css(".social-icon-container").css("a")[count]["href"].include?("twitter")
      scraped_student[:twitter] = profile_page.css(".social-icon-container").css("a")[count]["href"]
      count+=1
    end
    if profile_page.css(".social-icon-container").css("a")[count]["href"].include?("linkedin")
      scraped_student[:linkedin] = profile_page.css(".social-icon-container").css("a")[count]["href"]
      count+=1
    end
    if profile_page.css(".social-icon-container").css("a")[count]["href"].include?("github")
      scraped_student[:github] = profile_page.css(".social-icon-container").css("a")[count]["href"]
      count+=1
    end
    if count < profile_page.css(".social-icon-container").css("a").length
      scraped_student[:blog] = profile_page.css(".social-icon-container").css("a")[count]["href"]
    end
    scraped_student[:profile_quote] = profile_page.css(".profile-quote").text
    scraped_student[:bio] = profile_page.css(".description-holder").css("p").text
    scraped_student
  end

end

