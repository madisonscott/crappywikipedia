class MapIO
    
    def initialize(file)
        @file = file
    end 

    def import()
        map = Hash.new
        
        key = []
        f = File.open(@file, "a+") do |f|
            f.each_line { |line|
                line = line.split
                brk = line.find_index(">>>")
                
                i = 0;
                
                # reset key if needed
                if brk != 0;
                    key = []
                    until i == brk
                        key.push(line[i])
                        i += 1
                    end
                end;

                i += 1; # skip the >>>
                
                value = line[i]
                count = line[i+1]
                                
                put(map, key, value, count)
            }
        end
                
        return map
    end
    
    def put(map, key, value, count)
        # key is in map, add new value to map
        if map.has_key?(key);
            sub = map[key]
            
            # store value and count in sub map
            sub.store(value, count);
            
        # key not in map, create new map with value
        else;
            sub = { value => count }
            map.store(key, sub);
        end;
    end
        
    def export(map)
        if File.exist?(@file);
            File.delete(@file);
        end;
     
        f = File.open(@file, "a+") do |f|
            map.keys.each { |key|
                line = ""
                
                key.each { |word|
                    line += word + " "
                }
                                
                sub = map[key]
                sub.keys.each { |val|
                    count = sub[val]
                    nline = line + ">>> " + val + " " + count.to_s
                    nline += "\n"
                    f.write(nline)  
                    line = ""
                }
            }
        end
    end
    
    def print(map)
        map.keys.each { |key|
            sub = map[key]
            sub.keys.each { |val|
                puts "#{key} => #{val} (#{sub[val]})"
            }
        }
    end

end