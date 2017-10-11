require "rubygems"
require "./bayesClassifier.rb"


$classifier = BayesClassifier.new(["positive", "negative"])
		

def nbtrain(trainDir, modelFile)
	
	count = 0
	c = 0

	Dir.glob(trainDir + '/pos/*.txt') do |file|
		count = count +1
		document1 = File.read(file)
		$classifier.trainClassifier("positive", document1)
	end

	c = 0
	count = 0
	Dir.glob(trainDir+'neg/*.txt') do |file|
		count = count + 1
		document2 = File.read(file)
		$classifier.trainClassifier("negative", document2)
	end

	$classifier.sanitizeData();
	
	$classifier.printTerms()

	$classifier.writeModelFile(modelFile)
	nbtest("model.txt", "textcat/dev1/", "pred.txt")

end

def nbtest(modelFile, testDir, predictonFile)
	count =0
	posFile = open("positiveFile.txt", "w")
	posFile.truncate(0)

	negFile = open("negativeFile.txt", "w")
	negFile.truncate(0)

	predictonFile = open(predictonFile, "w")
	predictonFile.truncate(0)
	posFiles = {}
	negFiles = {}
	Dir.glob(testDir+ "*.txt") do |file|
		count = count + 1
		document3 = File.read(file)
		res = $classifier.classify_document(document3)
		
		predictonFile.write(count.to_s + ". " +"filename:  " +  file + "    pos Prob: "  + res["positive"].to_s  +  "    neg Prob: "  + res["negative"].to_s + "\n")
		sortedRes = res.sort {|a,b| a[1]<=>b[1]}

		if sortedRes.pop[0].include?"positive"
			posFile.write("filename:  " +  file + "\n")
			posFiles = posFiles.merge!({file.split("/")[2].split(".")[0] => 1})
		else
			negFile.write("filename:  " +  file + "\n")
			negFiles = negFiles.merge!({file.split("/")[2].split(".")[0] => 1})
		end
		
	end
	if testDir.include?"dev"
		
		
		actualPosFiles = {}
		actualNegFiles = {}
		Dir.glob("textcat/dev/pos/*.txt") do |file|
			
			actualPosFiles = actualPosFiles.merge!({file.split("/")[3].split(".")[0] => 1})
		end
		Dir.glob("textcat/dev/neg/*.txt") do |file|
			actualNegFiles = actualNegFiles.merge!({file.split("/")[3].split(".")[0] => 1})
		end
		posMatchCount  =0 
		negMatchCount  =0 
		actualPosFiles.keys.each do |key|
			
			if posFiles[key] != nil
				posMatchCount = posMatchCount + 1
			end
		end
		actualNegFiles.keys.each do |key|
			if negFiles[key] != nil
				negMatchCount = negMatchCount + 1
			end
		end
		puts posMatchCount
		puts negMatchCount
		puts "actual count pos"
		puts actualPosFiles.count
		puts "actual count neg"
		puts actualNegFiles.count
		puts "percentage result match in dev : 1st is positive match percentage."
		puts posMatchCount.to_f/actualPosFiles.count
		puts negMatchCount.to_f/actualNegFiles.count
		
	end
	puts count	
end


nbtrain("textcat/train/", "model.txt")