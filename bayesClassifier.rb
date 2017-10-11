require "rubygems"

class BayesClassifier

	def initialize(categories)
		
		@docWords = {}

	    @total_words = 0		
	    
	    @categories_documents = Hash.new		
	    @total_documents = 0
	    
	    @categories_words = Hash.new
	    
	    categories.each { |category|         
	      @docWords[category] = Hash.new         
	      @categories_documents[category] = 0
	      @categories_words[category] = 0
	    }
	end


	def trainClassifier(category, document)
		count = 0 
		document_words(document).each do |word, count|
			word = word.strip
			if @docWords[category][word] == nil
				@docWords[category][word] = count
			else
				@docWords[category][word] = @docWords[category][word] + count
			end
			@total_words += count
			@categories_words[category] += count
		end
		@categories_documents[category] += 1
		@total_documents += 1
	end


	def sanitizeData()
		allkeys = (@docWords["positive"].keys + @docWords["negative"].keys).uniq
		allkeys.each do |item|
			positiveCount = @docWords["positive"][item] || 0
			negativeCount = @docWords["negative"][item] || 0
			if (positiveCount + negativeCount) < 5
				@docWords["positive"].delete(item)
				@docWords["negative"].delete(item)
			end
		end	
	end


	def printTerms
		puts "positive"
		puts @docWords["positive"].count
		puts "negative"
		puts @docWords["negative"].count
	end


	def document_words(document)
		docWords = createDocWords(document)
		regexx = /[0-9]/
		docWords.keys.each do |item|
			if item.match(regexx) != nil
				docWords.delete(item)
			end
		end
		docWords
	end


	def createDocWords(document)
		documentWords = document.gsub(/[^\w\s]/,"").split
		document = {}
		documentWords.each do |word|
		    document[word.strip] ||= 0
			document[word.strip] += 1		
		end
    	document
	end


	def classify_document(document)
		totalWords = (@docWords["positive"].keys + @docWords["negative"].keys).uniq.count
		
		sorted = probabilities(document, totalWords)
		# // sort {|a,b| a[1]<=>b[1]}
		return sorted
	end


	def probabilities(document, totalWords)
		probabilities = {}
		postiveCategoryWords = @docWords["positive"].count
		negativeCategoryWords = @docWords["negative"].count

		@docWords.each_key do |category|
			catWords = category == "positive" ? postiveCategoryWords : negativeCategoryWords
			probabilities[category] = document_probability(category, document, totalWords, catWords) + Math.log(category_probability(category))
		end
		return probabilities
	end


	def document_probability(category, document, totalWords, catWords)
	    doc_prob = Math.log(1)
	    docWords =document_words(document)
	    
	    docWords.each do |item|
	    	wprb = word_probability(category, item[0], totalWords, catWords)
    		doc_prob = doc_prob + Math.log(wprb)
	    end
	    return doc_prob
	 end


  	def word_probability(category, word, totalWords, categoryWords)
    	(@docWords[category][word].to_f + 1)/(categoryWords).to_f
  	end


	def category_probability(category)
    	x = @categories_documents[category].to_f/@total_documents.to_f
    	x
	end


	def writeModelFile(modelFile)
		file = open(modelFile, "w")	
		file.truncate(0)
		totalWords = (@docWords["positive"].keys + @docWords["negative"].keys).uniq.count
		positive = @docWords["positive"].keys.count
		negative = @docWords["negative"].keys.count

		probPositive = Math.log(positive/totalWords.to_f)
		probNegative = Math.log(negative/totalWords.to_f)
		string1 = "Vacabulary length : " +  totalWords.to_s + "\n"
		string3 =  "postive words : " + positive.to_s + "\n" 
		string4 = "negative words : " + negative.to_s + "\n"
		string5 = "probability (positive) : " +  probPositive.to_s + "\n"
		string6 = "probability (negative) : " +  probNegative.to_s + "\n"
		file.write(string1 + string3 + string4 + string5 + string6)

		writeTermWeights(file)

		file.close()
	end

	def writeTermWeights(file)
		posWords = @docWords["positive"]
		sortedPosDocWords = posWords.sort {|a,b| a[1]<=>b[1]}.reverse.to_h

		negWords = @docWords["negative"]
		sortedNegDocWords = negWords.sort {|a,b| a[1]<=>b[1]}.reverse.to_h
		logRatio = {}
		logRatio1 = {}
		count = 1
		posWords.keys.each do |item|
			posCount = posWords[item]
			negCount = negWords[item]
			if negCount!=nil
				logRatio[item] = Math.log(posCount.to_f/negCount)	
				logRatio1[item] = Math.log(negCount.to_f/posCount)	
			end
		end

		posModelFile = open("posWordsList.txt" , "w")
		negModelFile = open("negWordsList.txt", "w")
		sortedPosDocWords.keys.each do |key|
			string = key + "        :  " + sortedPosDocWords[key].to_s + "\n"
			posModelFile.write(string)
		end

		sortedNegDocWords.keys.each do |key|
			string = key + "        :  " + sortedNegDocWords[key].to_s + "\n"
			negModelFile.write(string)
		end
		posModelFile.close
		negModelFile.close
		topValues = logRatio.sort {|a,b| a[1]<=>b[1]}.reverse[0..19].to_h
		topValues1 = logRatio1.sort {|a,b| a[1]<=>b[1]}.reverse[0..19].to_h
		string = "count" + "    "  + "word    "+ "log(pos/neg)"
		file.write(string + "\n")
		
		topValues.keys.each do |key|
			string = count.to_s + ".  "  + key +"    "  + topValues[key].to_s + "\n"
			file.write(string)
			count = count + 1
		end

		count = 1
		string = "\n" +"\n" + "count" + "    "  + "word    "+ "log(neg/pos)"
		file.write(string + "\n")
		topValues1.keys.each do |key|
			string = count.to_s + ".  "  + key +"    "  + topValues1[key].to_s + "\n"
			file.write(string)
			count = count + 1
		end
	end

end







