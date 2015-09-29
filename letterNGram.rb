class LetterNGram
    
    def initialize(n)
        @map = Hash.new
        @n = n
    end
    
    def getMap()
        return @map
    end
    
    def setMap(map)
        @map = map
    end
    
    def map(tweets)
        tweets.each { |tweet|

            tweet = tweet.text.split('')
            length = tweet.length
            
            i = 0
            while i < length-(@n+1)
                segment = ""
                j = 0
                
                until j == @n
                    segment += tweet[i+j]
                    j += 1
                end;
                
                nxt = tweet[i+j]
                
                self.put(segment, nxt)
                i += 1
            end;
        }
        
    end
    
    def put(key, value)
        if @map.has_key?(key);
            list = @map[key]
            # puts "in map > #{list}"
            list.push(value)
            # puts "list now > #{list}"
            @map.delete(key)
            @map.store(key, list);
            # puts "sanity check > #{@map[key]}"
        else;
            list = [value]
            # puts "not in map"
            @map.store(key, list);
            # puts "sanity check > #{@map[key]}"
        end;
    end
    
    def write()
        word = @map.keys.sample
        # puts word
        tweet = word + " "
        
        i = 130
        until i == 0
            if !@map.has_key?(word);
                break;
            else;
                word = @map[word].sample
                tweet += word + " "
                i -= 1;
            end;
        end
        
        tweet += "\n\n"
        
        return tweet
    end

end
        