Feature: ARFF
  In order to access .arff data from a Ruby program
  As a programmer
  I want to turn .arff files into Ruby data structures

  Scenario: Parse an ARFF file
    Given I have an .arff file at ~/Dropbox/school/fall_2011/cs_478/labs/decision_tree/features/support/test.arff
    When I pass it in to process
    Then I should get an array of hashes back

