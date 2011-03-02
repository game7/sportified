Feature: Manage seasons
  In order to administer a sports league
  As a league administrator
  I want to create and manage seasons for a division

  Background:
    Given a division named "Novice"
    And the "Novice" division has the following seasons:
      | name   |
      | Winter |
      | Summer |
      | Spring |

  Scenario: List seasons for a division
    When I go to the page for the "Novice" division
    Then I should see "Winter"
    And I should see "Summer"
    And I should see "Spring"
  
  Scenario: Create new season
    When I go to the page for the "Novice" division
    And I follow "New Season"
    And I fill in "Name" with "Fall"
    And I fill in "Starts on" with "9/1/2010"
    And I fill in "Ends on" with "2/1/2011"
    And I press "Create"
    Then I should see "Season was successfully created"
    When I go to the page for the "Novice" division
    And I should see the following seasons:
      | name   |
      | Winter |
      | Summer |
      | Spring |
      | Fall   |

  Scenario: Display a season
    When I go to the page for the "Winter" season
    Then I should see "Winter"


  # Rails generates Delete links that use Javascript to pop up a confirmation
  # dialog and then do a HTTP POST request (emulated DELETE request).
  #
  # Capybara must use Culerity/Celerity or Selenium2 (webdriver) when pages rely
  # on Javascript events. Only Culerity/Celerity supports clicking on confirmation
  # dialogs.
  #
  # Since Culerity/Celerity and Selenium2 has some overhead, Cucumber-Rails will
  # detect the presence of Javascript behind Delete links and issue a DELETE request 
  # instead of a GET request.
  #
  # You can turn this emulation off by tagging your scenario with @no-js-emulation.
  # Turning on browser testing with @selenium, @culerity, @celerity or @javascript
  # will also turn off the emulation. (See the Capybara documentation for 
  # details about those tags). If any of the browser tags are present, Cucumber-Rails
  # will also turn off transactions and clean the database with DatabaseCleaner 
  # after the scenario has finished. This is to prevent data from leaking into 
  # the next scenario.
  #
  # Another way to avoid Cucumber-Rails' javascript emulation without using any
  # of the tags above is to modify your views to use <button> instead. You can
  # see how in http://github.com/jnicklas/capybara/issues#issue/12
  #
  #Scenario: Delete season
  #  Given the following seasons:
  #    ||
  #    ||
  #    ||
  #    ||
  #    ||
  #  When I delete the 3rd season
  #  Then I should see the following seasons:
  #    ||
  #    ||
  #    ||
  #    ||
