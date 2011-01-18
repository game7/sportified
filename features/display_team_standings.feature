Feature: Display Team Standings
  In order to view a sports league
  As a website visitor
  I want to view the team standings

  Background:  
    Given a division named "Novice"
    And the "Novice" division has the following seasons:
      | name   |
      | Winter |
      | Summer |
      | Spring |
    And the "Winter" season has the following teams
      | name   | show_in_standings |
      | Kings  | true              |
      | Sharks | true              |
      | Stars  | true              |
      | Ducks  | true              |
      | Foo    | false             |
    And the "Summer" season has the following teams
      | name    | show_in_standings |
      | Bears   | true              |
      | Lions   | true              |
      | Packers | true              |
      | Vikings | true              |
      | Bar     | false             |
    And the "Summer" is the current season for the "Novice" division

  Scenario: List standings for the current season of a division
    When I go to the standings page for the "Novice" division
    Then I should see the following teams:
      | name    |
      | Bears   |
      | Lions   |
      | Packers |
      | Vikings |
    And I should not see "Bar"

  Scenario: List standings for a previous season of a division
    When I go to the standings page for the "Novice" division
    And I follow "Winter"
    Then I should see the following teams:
      | name   |
      | Kings  |
      | Sharks |
      | Stars  |
      | Ducks  |
    And I should not see "Foo"



