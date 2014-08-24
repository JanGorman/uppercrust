Feature: Generator
  
  Scenario: I generate .h and .m files
    When I run `uppercrust generate --path data --base_only true`
    Then the following files should exist:
      | output/_Article.h |
    Then the file "output/_Article.h" should contain:
      """
      Something
      """