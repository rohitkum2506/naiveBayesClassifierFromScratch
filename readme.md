#testClassifier.rb
Algorithm to classify a set of documents present in test directory.

Ruby version - ruby 2.2.1p85 (2015-02-26 revision 49769)

Libraries used :
4. rubygem - Ruby gem for package management in ruby.

NOTE: The whole list could be found in gemfile

Pre-requisities for running the application:
1. Ruby version (>2.2.0).
2. RVM (ruby version manager) used for easy installation of ruby and version management. Ignore if ruby is already installated on machine.
3. bundler - Gem which downloads the required rubygems mentioned in Gemfile.


Steps to run:


1. Ruby Installation : On any bash environment run '\curl -sSL https://get.rvm.io | bash -s stable --ruby'. 
   If you want to localise the setup, run the command from the project directory only.
   for more details please visit: 'https://rvm.io/rvm/install'.
2. Check your ruby installation by typing 'ruby -v'. It should tell you the ruby version installed. 
3. Do 'gem install bundler'.
4. Goto the project directory, Rohit_Kumar_CS6200_HW3 and run 'bundle install'. This will download all the required libraries and dependencies.
5. To run the application use command format: 'ruby <filename.rb> <spaceSeperatedParameters>'. 
   For example, for the testClassifier use:
   ruby testClassifier.rb 

6. The pred.txt file contains the classified documents along with the positive and negative scores.
7. The model file contains parameters for NB classifier. 
posWordsList.txt, negWordsList.txt contain the list of positive and negative terms with terms excluded as:
   a. numbers
   b. terms whose combined count in pos and neg data set is les than 5.

Results for dev directory run :

percentage result match in dev : 1st is positive match percentage.
positive match percentage : 0.99
negative match percentage : 0.38
  
   