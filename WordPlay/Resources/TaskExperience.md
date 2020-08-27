* how much time was invested

Total 5 hours, where i  was struggled in view animation completion which took around 2 hours for finding a working solution. If I can have few more hour then it can be fully completed but because of the time constraint I left with failing unit tests.

* how was the time distributed (concept, model layer, view(s), game mechanics)
  - First half hour understanding the tasks given, then deciding to do the first task though 2nd task looks more interesting but also it seems more time consuming because of the multiplayer functionality so I chose the first task.
  - 20-25 minute to draw a wireframe in notepad and planning
  - more than 2 hours in view because of the struggling on animation completion.
  - around an hour for presenter and json parsing
  - half hour for testing and major issue solving
  - 20-25 minutes for writing unit tests
* decisions made to solve certain aspects of the game
  - Animation Completion can be done using timer but chose to get completion handler for accurate synchronous operation
  - trying to keep navigation, view, presentation logic, interactor logic in different classes with inversion of control
* decisions made because of restricted time
  - betterment of ux not been done
  - thorough checking for bugs not done
  - presenter class has interactor methods which need to be keep in separate class
  - thorough unit tests has been skipped with keeping failed tests
  - interface of presenter should be used in view files which is skipped
* what would be the first thing to improve or add if there had been more time
  - extract the player logic from presenter in another classes
  - write more unit tests for logic methods
  - ux improvement - timing of animation, placements of views
