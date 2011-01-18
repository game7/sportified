Feature: Manage divisions
  In order to administer a sports league
  As a league admin
  I want to create and manage divisions

  Scenario: Create new division
    Given I have no divisions
    And I go to the divisions page
    When I follow "New Division"
    And I fill in "Name" with "Mite"
    And I press "Create"
    Then I should see "Division was successfully created"
    And I should see "Mite"
    And I should have 1 division

  Scenario: List the divisions
    Given a division named "Peewee"
    And a division named "Squirt"
    When I go to the divisions page
    Then I should see "Peewee"
    And I should see "Squirt"
  
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
  # Another way to avoid Cucumber-Rails javascript emulation without using any
  # of the tags above is to modify your views to use <button> instead. You can
  # see how in http://github.com/jnicklas/capybara/issues#issue/12
  #
  #Scenario: Delete divisions
  #  Given the following divisions:
  #    ||
  #    ||
  #    ||
  #    ||
  #    ||
  #  When I delete the 3rd divisions
  #  Then I should see the following divisions:
  #    ||
  #    ||
  #    ||
  #    ||
