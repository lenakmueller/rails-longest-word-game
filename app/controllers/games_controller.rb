require "open-uri"

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)


  # method definition that can be called later in the program
  def new
    # @letters instance variable, stores data that can be accessed by different methods within same object
    # Array.new(5) creates array with five slots
    # { VOWELS.sample } randomly selects value from "vowels"array and assigns it to slot in new array
    @letters = Array.new(5) { VOWELS.sample }
    # += concetenates two arrays (10 letters in total)
    # (('A'..'Z').to_a - VOWELS).sample generates random non-vowel letter
    # ('A'..'Z') creates range from A to Z
    # .to_a converts that range into an array of letters
    #  - VOWELS subracts the VOWELS array from the array of all letters leaving only non-vowels
    # .sample selects random element from resulting array
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    # modifies original array to create new aray every time
    @letters.shuffle!
  end

  def score
    # params is special variable in ROR that holds information about request parameters sent to server
    # params[:letters] retrieves value of the letters parameter from the request
    # .split method that splits a string into an array of substrings based on whitespace characters
    @letters = params[:letters].split
    # @word another instance variable that is set to params[:word] IF it exists, if not it is set to empty string
    # || operator which provides default value if left side of the operator is nil or false
    # upcase is method valled on variable that converts value to uppcase letters, ensures word is compared in case-insensitive manner later in the coe
    @word = (params[:word] || "").upcase
    # @included vaiable is assigned the result of a method called included?(@word, @letters)
    @included = included?(@word, @letters)
    # method checks if word is a valid English word by making request to an external dictionary API
    # API response is parsed and the result is stored in the @english_word variable
    @english_word = english_word?(@word)
  end

  private

  # We are defining a method named "included?"
  # This method takes two arguments: "word" and "letters"
  def included?(word, letters)
    # It checks if the count of the letter in the word is less than or equal to the count of the letter in the letters array
    # If this condition is true for all the letters in the word, the method returns true; otherwise, it returns false
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  # We are defining another method named "english_word?"
  # This method takes one argument: "word"
  def english_word?(word)
    # # We are making a request to an external API by opening a URL
    # The URL is constructed using the "word" as a parameter to look up in the dictionary API
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    # We are parsing the response from the API as JSON
    # This allows us to extract data from the response in a structured way
    json = JSON.parse(response.read)
    # We are accessing the value of the "found" key in the parsed JSON data
    # This indicates if the word was found in the dictionary or not
    # The result is returned by the method
    json['found']
  end
end
