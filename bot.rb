require 'rubygems'
require 'twitter'
require 'mechanize'
load 'mapIO.rb'
load 'wordNGram.rb'
load 'letterNGram.rb'

class Bot
    
    def initialize(model)
    
        @TWEET_NUM = 5;
        @PAGE_NUM = 1000;
    
        @twitter = Twitter::REST::Client.new do |config|
            config.consumer_key         = ""
            config.consumer_secret      = ""
            config.access_token         = ""
            config.access_token_secret  = ""
        end
        
        # @mechanize = Mechanize.new
        
        @model = model
        @n = model.getN
        @corpus = "seuss.txt"
        
        @mapFile = "map" + @n.to_s + ".txt"
        @mapIO = MapIO.new(@mapFile)
        @map = Hash.new
    end
    
    def refresh()
        @map = @mapIO.import
        @model.setMap(@map)
        
        # self.wikipedia
        # self.twitter
        # self.srcfile
        
        self.tweet
        
        @map = @model.getMap
        @mapIO.export(@map)
        # @mapIO.print(@map)
    end
    
    def tweet() 
        tweets = @TWEET_NUM
        until tweets == 0
            puts @model.write
            tweets -= 1
        end
    end
    
    def wikipedia()
        i = 0
        until i == @PAGE_NUM
            page = @mechanize.get('http://en.wikipedia.org/wiki/Special:Random')
            puts "#{i} #{page.title}"
            page.search('p').each { |para|
                @model.map(para.text.strip)
            }       
            i += 1
        end
    end
    
    def twitter()
        handles = ['miramedley', 'seaofcats', 'danielhandler', 'janellenunnally']
        handles.each do |handle|
            tweets = @twitter.search(handle).take(500)
            tweets.each { |tweet|
                @model.map(tweet.text)
            }
        end
    end
    
    def srcfile()    
        f = File.open(@corpus, "r") do |f|
            @model.map(f)
        end
    end
    
end

model = WordNGram.new(2)
bot = Bot.new(model)
bot.refresh
# bot.fromFile
