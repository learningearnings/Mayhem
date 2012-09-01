## Food Fight
This is my attempt to extract a new schema to reimplement the FoodFight game.

### Interaction
#### FoodFight#show 
This route will show the current front page for food fights.  It shows the
following:
- link to "my stats"
- link to "Throw Food"
- top three throwers for my school
- current round

#### FoodFight#play
This will find a random food fight question in the current round.  It then
presents the question, along with all of its potential answers, and a table
showing percent correct/incorrect answers to this question.  It shows a button
that says 'submit answer'

#### FoodFight::Throw#show
This will show the result of a given attempt to answer a food fight question.

If incorrect, it will show the submitted answer, highlighted in red, and the
correct answer, highlighted in green.  It also shows statistics, as well as
a button to a 'new question'

If correct, it will redirect to FoodFight#pick\_food

#### FoodFight#pick\_food
This shows all of the available foods to throw.  Picking a food forwards you to
FoodFight#pick\_school with the appropriate item\_id selected (food chosen to
throw)

#### FoodFight#pick\_school
This allows the user to choose the school to throw some eggs at.  It's a
paginated-by-initial-letter list of schools.  Picking a school saves the throw
record and redirects to FoodFight#play

#### FoodFight#

### Tables
- Games::Question (x)
  - type:string
  - category\_id:integer
  - number\_of\_answers:integer
  - grade:integer
  - body:string
  - approval\_count:integer # what is this for?
  - teacher\_id:integer
  - created\_by:integer
  - updated\_by:integer
  - status:string
  - game\_type:string
- Games::Answer (x)
  - type:string
  - body:string
- Games::QuestionAnswer (x)
  - question\_id:integer
  - answer\_id:integer
  - correct:boolean
  - status:string
- Games::QuestionCategory # What is this for?
  - subject:string
  - category:string
  - status:string
- Games::QuestionGrouping # What is this?
  - abbr:string
  - description:string
  - teacher\_id:integer
  - filter\_id:integer
  - status:string
  - game\_type:string
- Games::FoodFight::Rounds
  - abbr:string
  - description:string
  - filter\_id:integer
  - question\_group\_id:integer
  - start\_date:datetime
  - end\_date:datetime
- Games::FoodFight::UserStatistic
  - user\_id:integer
  - round\_id:integer
  - answered:integer
  - throws:integer
  - correct:integer
- Games::FoodFight::Items
  - name:string
  - image\_uid:string
  - image\_name:string
  - splat\_image\_uid:string
  - splat\_image\_name:string
  - unlock\_count:integer
- Games::FoodFight::Throws
  - round\_id:integer
  - user\_id:integer
  - user\_answer\_id:integer
  - food\_item\_id:integer
  - target\_type:string
  - target\_id:integer
