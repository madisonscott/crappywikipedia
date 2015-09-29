class WordNGram
    
    def initialize(n)
        @n = n
        @tweet_len = 20
        @map = Hash.new
        @BEGIN = []
        
        j = 0
        until j == @n
            @BEGIN.push("<<<BEGIN>>>")
            j += 1
        end   
    end
    
    def getN()
        return @n
    end
    
    def getMap()
        return @map
    end
    
    def setMap(map)
        @map = map
    end

    def map(text)
        l = 0
        text.each_line { |line|
            words = line.split
            length = words.length
            
            i = 0
            while i < length-(@n+1);
                
                chunk = []
                j = 0
                until j == @n;
                    chunk.push(words[i+j])
                    j += 1;
                end;
                
                nxt = words[i+j]
                
                self.put(chunk, nxt)
                
                # mark as beginner if follows punctuation
                punctuation = ['.', '!', '?']
                last = chunk[-1].split('')[-1]
                if punctuation.include? last;
                    self.put(@BEGIN, nxt);
                end;
                
                #mark as beginner if first word of line
                if (l == 0) and (i == 0);
                    self.put(@BEGIN, words[i])
                end
                
                i += 1;
            end;
            
            l += 1
        }
    end
    
    def normalize(word)
        return word.gsub(/[\n]/, '')
        # .gsub(/[^a-z0-9#@\/']/, '')
    end
    
    def put(key, value)
        # key is in map, add new value to map
        if @map.has_key?(key);
            sub = @map[key]
            
            # value is in submap, increment its count
            if sub.has_key?(value);
                count = sub[value].to_i
                sub.delete(value)
                sub.store(value, count+1);
                
            # value not in submap, add to map
            else;
                sub.store(value, 1);
            end;
            
        # key not in map, create new map with value
        else;
            sub = { value => 1 }
            @map.store(key, sub);
        end;
        
    end
    
    def write()
        chunk = @map.keys.sample # prob(@map[@BEGIN])
        tweet = ""
        
        # add all but last word of chunk to tweet
        chunk.each_with_index { |word, i|
            if i != @n-1;
                tweet += word + " ";
            end;
        }
        
        i = 0
        until i == @tweet_len
            tweet += chunk[-1] + " "
            
            # stop if key is not in map
            if !@map.has_key?(chunk);
                break;
                
            else;
                punctuation = ['.', ';', '!', '?', '"']
                last = chunk[-1].split('')[-1]
                nxt = []
                
                # add all but first chunk word to new chunk
                j = @n-1
                until j == 0
                    nxt.push(chunk[-1*j])
                    j -= 1
                end
                
                nxt.push(prob(@map[chunk]))
                chunk = nxt;
                
                # if chunk ends in punctuation, end tweet or re-sample
                if punctuation.include? last;
                    if i > 10;
                        break;
                    else;
                        chunk = @map.keys.sample # prob(@map[@BEGIN]);
                    end;
                end;
                
                i += 1;
            end;
        end
        
        tweet += "\n\n"
        return tweet
        
    end 
    
    def prob(sub)
        pmap = Hash.new
        
        # rearrange map by occurrences
        total = 0
        sub.keys.each { |word|
            total += sub[word].to_i
            pmap.store(total, word)
        }
        
        # pmap.keys.each { |key| 
        #     puts "#{key} => #{pmap[key]}"
        # }
        
        random = rand(total)
        # puts "random is #{random}"
        
        # find smallest key larger than random
        min = total
        pmap.keys.each { |key|
            # puts "min is #{min} => key is #{key}"
            if (key > random) and (key < min);
                min = key;
            end;
        }
        
        return pmap[min]
        
    end
    
end


