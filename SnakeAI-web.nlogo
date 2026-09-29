;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                        ;;
;; This model was based on:                                               ;;
;;  Brooks, P. (2020) Snake-simple. Stuyvesant High School. Avaliable
;;  from http://bert.stuy.edu/pbrooks/fall2020/materials/intro-year-1/Snake-simple.html
;;    [accessed 16 November 2023].                                        ;;
;;                                                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

globals [
  wall-color
  clear-colors ; list of colors that patches the snakes can enter have
  apples; list of apples
  search-count ; web version: id of the current path search (for fast 'visited' checks)
  level tool ; ignore these two variables they are here to prevent warnings when loading the world/map.
]

patches-own [
  age ; if not part of a snake, age=-1. Otherwise age = ticks spent being a snake patch.
  search-id ; web version: equals search-count if this patch was visited by the current search
]

breed [snakes snake]
snakes-own [
  team ; either red team or blue team
  mode ; how is the snake controlled.
  snake-age ; i.e., how long is the snake
  snake-color ; color of the patches that make up the snake
  path-to-food ;
]

;;=======================================================
;; Setup

to setup ; observer
  clear-all
  setup-walls
  setup-snakes

  set clear-colors (list black green (red + 8) (red + 9) (blue + 8) (blue + 9))
  ; there will alwasy be two randomly placed pieces of food within the environment:
  make-food
  make-food
  reset-ticks
end

;;--------------------------------

to setup-walls  ; observer
  ; Web version: the maps are built in code instead of loaded with import-world,
  ; because NetLogo Web can't read files from a maps folder.
  ifelse map-file = "snake-map-3" [ resize-world -20 20 -20 20 set-patch-size 11 ]
                                  [ resize-world -16 16 -16 16 set-patch-size 14 ]
  ask patches [ set age -1
                set pcolor black ]
  set wall-color gray

  ifelse map-file = "empty" [
    ; Set the edge of the environment to the wall-color:
    ask patches with [abs pxcor = max-pxcor or abs pycor = max-pycor] [set pcolor wall-color]
  ] [
    foreach (map-walls map-file) [ xy -> ask patch (item 0 xy) (item 1 xy) [ set pcolor wall-color ] ]
  ]
end

; Wall coordinates exported from the original maps/*.csv files
to-report map-walls [ name ]
  if name = "snake-map-1" [ report [[-16 16] [-15 16] [-14 16] [-13 16] [-12 16] [-11 16] [-10 16] [-9 16] [-8 16] [-7 16] [-6 16] [-5 16] [-4 16] [-3 16] [-2 16] [-1 16] [0 16] [1 16] [2 16] [3 16] [4 16] [5 16] [6 16] [7 16] [8 16] [9 16] [10 16] [11 16] [12 16] [13 16] [14 16] [15 16] [16 16] [-16 15] [16 15] [-16 14] [16 14] [-16 13] [-12 13] [-11 13] [-10 13] [16 13] [-16 12] [-12 12] [-11 12] [-10 12] [16 12] [-16 11] [-12 11] [-11 11] [-10 11] [16 11] [-16 10] [16 10] [-16 9] [16 9] [-16 8] [-8 8] [-7 8] [-6 8] [16 8] [-16 7] [-8 7] [-7 7] [-6 7] [16 7] [-16 6] [-8 6] [-7 6] [-6 6] [16 6] [-16 5] [16 5] [-16 4] [16 4] [-16 3] [16 3] [-16 2] [16 2] [-16 1] [-6 1] [-5 1] [-4 1] [-3 1] [-2 1] [-1 1] [0 1] [1 1] [2 1] [3 1] [4 1] [5 1] [6 1] [16 1] [-16 0] [-6 0] [-5 0] [-4 0] [-3 0] [-2 0] [-1 0] [0 0] [1 0] [2 0] [3 0] [4 0] [5 0] [6 0] [16 0] [-16 -1] [-6 -1] [-5 -1] [-4 -1] [-3 -1] [-2 -1] [-1 -1] [0 -1] [1 -1] [2 -1] [3 -1] [4 -1] [5 -1] [6 -1] [16 -1] [-16 -2] [-6 -2] [-5 -2] [-4 -2] [-3 -2] [-2 -2] [-1 -2] [0 -2] [1 -2] [2 -2] [3 -2] [4 -2] [5 -2] [6 -2] [16 -2] [-16 -3] [16 -3] [-16 -4] [16 -4] [-16 -5] [16 -5] [-16 -6] [16 -6] [-16 -7] [5 -7] [6 -7] [7 -7] [16 -7] [-16 -8] [5 -8] [6 -8] [7 -8] [16 -8] [-16 -9] [5 -9] [6 -9] [7 -9] [16 -9] [-16 -10] [16 -10] [-16 -11] [10 -11] [11 -11] [12 -11] [16 -11] [-16 -12] [10 -12] [11 -12] [12 -12] [16 -12] [-16 -13] [10 -13] [11 -13] [12 -13] [16 -13] [-16 -14] [16 -14] [-16 -15] [16 -15] [-16 -16] [-15 -16] [-14 -16] [-13 -16] [-12 -16] [-11 -16] [-10 -16] [-9 -16] [-8 -16] [-7 -16] [-6 -16] [-5 -16] [-4 -16] [-3 -16] [-2 -16] [-1 -16] [0 -16] [1 -16] [2 -16] [3 -16] [4 -16] [5 -16] [6 -16] [7 -16] [8 -16] [9 -16] [10 -16] [11 -16] [12 -16] [13 -16] [14 -16] [15 -16] [16 -16]] ]
  if name = "snake-map-2" [ report [[-16 16] [-15 16] [-14 16] [-13 16] [-12 16] [-11 16] [-10 16] [-9 16] [-8 16] [-7 16] [-6 16] [-5 16] [-4 16] [-3 16] [-2 16] [-1 16] [0 16] [1 16] [2 16] [3 16] [4 16] [5 16] [6 16] [7 16] [8 16] [9 16] [10 16] [11 16] [12 16] [13 16] [14 16] [15 16] [16 16] [-16 15] [16 15] [-16 14] [16 14] [-16 13] [16 13] [-16 12] [-12 12] [-11 12] [-10 12] [-9 12] [7 12] [8 12] [9 12] [10 12] [16 12] [-16 11] [-12 11] [-11 11] [-10 11] [-9 11] [7 11] [8 11] [9 11] [10 11] [16 11] [-16 10] [-12 10] [-11 10] [-10 10] [-9 10] [7 10] [8 10] [9 10] [10 10] [16 10] [-16 9] [-12 9] [-11 9] [-10 9] [-9 9] [7 9] [8 9] [9 9] [10 9] [16 9] [-16 8] [-12 8] [-11 8] [-10 8] [-9 8] [7 8] [8 8] [9 8] [10 8] [16 8] [-16 7] [-12 7] [-11 7] [-10 7] [-9 7] [7 7] [8 7] [9 7] [10 7] [16 7] [-16 6] [-12 6] [-11 6] [-10 6] [-9 6] [7 6] [8 6] [9 6] [10 6] [16 6] [-16 5] [-12 5] [-11 5] [-10 5] [-9 5] [-3 5] [-2 5] [-1 5] [0 5] [1 5] [7 5] [8 5] [9 5] [10 5] [16 5] [-16 4] [-12 4] [-11 4] [-10 4] [-9 4] [-3 4] [-2 4] [-1 4] [0 4] [1 4] [16 4] [-16 3] [-12 3] [-11 3] [-10 3] [-9 3] [-3 3] [-2 3] [-1 3] [0 3] [1 3] [16 3] [-16 2] [-3 2] [-2 2] [-1 2] [0 2] [1 2] [16 2] [-16 1] [-3 1] [-2 1] [-1 1] [0 1] [1 1] [16 1] [-16 0] [-3 0] [-2 0] [-1 0] [0 0] [1 0] [16 0] [-16 -1] [-3 -1] [-2 -1] [-1 -1] [0 -1] [1 -1] [16 -1] [-16 -2] [-3 -2] [-2 -2] [-1 -2] [0 -2] [1 -2] [16 -2] [-16 -3] [-3 -3] [-2 -3] [-1 -3] [0 -3] [1 -3] [16 -3] [-16 -4] [-12 -4] [-11 -4] [-10 -4] [-9 -4] [-3 -4] [-2 -4] [-1 -4] [0 -4] [1 -4] [7 -4] [8 -4] [9 -4] [10 -4] [16 -4] [-16 -5] [-12 -5] [-11 -5] [-10 -5] [-9 -5] [7 -5] [8 -5] [9 -5] [10 -5] [16 -5] [-16 -6] [-12 -6] [-11 -6] [-10 -6] [-9 -6] [7 -6] [8 -6] [9 -6] [10 -6] [16 -6] [-16 -7] [-12 -7] [-11 -7] [-10 -7] [-9 -7] [7 -7] [8 -7] [9 -7] [10 -7] [16 -7] [-16 -8] [-12 -8] [-11 -8] [-10 -8] [-9 -8] [7 -8] [8 -8] [9 -8] [10 -8] [16 -8] [-16 -9] [-12 -9] [-11 -9] [-10 -9] [-9 -9] [7 -9] [8 -9] [9 -9] [10 -9] [16 -9] [-16 -10] [-12 -10] [-11 -10] [-10 -10] [-9 -10] [7 -10] [8 -10] [9 -10] [10 -10] [16 -10] [-16 -11] [-12 -11] [-11 -11] [-10 -11] [-9 -11] [7 -11] [8 -11] [9 -11] [10 -11] [16 -11] [-16 -12] [-12 -12] [-11 -12] [-10 -12] [-9 -12] [7 -12] [8 -12] [9 -12] [10 -12] [16 -12] [-16 -13] [16 -13] [-16 -14] [16 -14] [-16 -15] [16 -15] [-16 -16] [-15 -16] [-14 -16] [-13 -16] [-12 -16] [-11 -16] [-10 -16] [-9 -16] [-8 -16] [-7 -16] [-6 -16] [-5 -16] [-4 -16] [-3 -16] [-2 -16] [-1 -16] [0 -16] [1 -16] [2 -16] [3 -16] [4 -16] [5 -16] [6 -16] [7 -16] [8 -16] [9 -16] [10 -16] [11 -16] [12 -16] [13 -16] [14 -16] [15 -16] [16 -16]] ]
  report [[-20 20] [-19 20] [-18 20] [-17 20] [-16 20] [-15 20] [-14 20] [-13 20] [-12 20] [-11 20] [-10 20] [-9 20] [-8 20] [-7 20] [-6 20] [-5 20] [-4 20] [-3 20] [-2 20] [-1 20] [0 20] [1 20] [2 20] [3 20] [4 20] [5 20] [6 20] [7 20] [8 20] [9 20] [10 20] [11 20] [12 20] [13 20] [14 20] [15 20] [16 20] [17 20] [18 20] [19 20] [20 20] [-20 19] [20 19] [-20 18] [20 18] [-20 17] [20 17] [-20 16] [20 16] [-20 15] [-14 15] [-13 15] [-12 15] [-11 15] [-10 15] [-9 15] [-8 15] [-7 15] [-6 15] [5 15] [6 15] [7 15] [8 15] [9 15] [10 15] [11 15] [20 15] [-20 14] [-14 14] [-13 14] [-12 14] [-11 14] [-10 14] [-9 14] [-8 14] [-7 14] [-6 14] [5 14] [6 14] [7 14] [8 14] [9 14] [10 14] [11 14] [20 14] [-20 13] [20 13] [-20 12] [20 12] [-20 11] [20 11] [-20 10] [-7 10] [-6 10] [-5 10] [-4 10] [-3 10] [-2 10] [-1 10] [0 10] [1 10] [2 10] [9 10] [10 10] [11 10] [12 10] [13 10] [14 10] [20 10] [-20 9] [-7 9] [-6 9] [-5 9] [-4 9] [-3 9] [-2 9] [-1 9] [0 9] [1 9] [2 9] [9 9] [10 9] [11 9] [12 9] [13 9] [14 9] [20 9] [-20 8] [20 8] [-20 7] [20 7] [-20 6] [20 6] [-20 5] [-11 5] [-10 5] [7 5] [20 5] [-20 4] [-11 4] [-10 4] [7 4] [20 4] [-20 3] [-11 3] [-10 3] [7 3] [20 3] [-20 2] [-11 2] [-10 2] [-2 2] [-1 2] [7 2] [20 2] [-20 1] [-11 1] [-10 1] [-2 1] [-1 1] [7 1] [20 1] [-20 0] [-11 0] [-10 0] [-2 0] [-1 0] [7 0] [20 0] [-20 -1] [-11 -1] [-10 -1] [-2 -1] [-1 -1] [20 -1] [-20 -2] [-11 -2] [-10 -2] [-2 -2] [-1 -2] [20 -2] [-20 -3] [-2 -3] [-1 -3] [20 -3] [-20 -4] [-2 -4] [-1 -4] [20 -4] [-20 -5] [20 -5] [-20 -6] [20 -6] [-20 -7] [5 -7] [6 -7] [7 -7] [8 -7] [9 -7] [10 -7] [11 -7] [20 -7] [-20 -8] [-15 -8] [-14 -8] [-13 -8] [-12 -8] [-11 -8] [-10 -8] [-9 -8] [-8 -8] [5 -8] [6 -8] [7 -8] [8 -8] [9 -8] [10 -8] [11 -8] [20 -8] [-20 -9] [-15 -9] [-14 -9] [-13 -9] [-12 -9] [-11 -9] [-10 -9] [-9 -9] [-8 -9] [20 -9] [-20 -10] [20 -10] [-20 -11] [20 -11] [-20 -12] [20 -12] [-20 -13] [2 -13] [3 -13] [4 -13] [5 -13] [6 -13] [7 -13] [8 -13] [9 -13] [10 -13] [11 -13] [20 -13] [-20 -14] [2 -14] [3 -14] [4 -14] [5 -14] [6 -14] [7 -14] [8 -14] [9 -14] [10 -14] [11 -14] [20 -14] [-20 -15] [-10 -15] [-9 -15] [-8 -15] [-7 -15] [-6 -15] [-5 -15] [-4 -15] [-3 -15] [-2 -15] [20 -15] [-20 -16] [-10 -16] [-9 -16] [-8 -16] [-7 -16] [-6 -16] [-5 -16] [-4 -16] [-3 -16] [-2 -16] [20 -16] [-20 -17] [20 -17] [-20 -18] [20 -18] [-20 -19] [20 -19] [-20 -20] [-19 -20] [-18 -20] [-17 -20] [-16 -20] [-15 -20] [-14 -20] [-13 -20] [-12 -20] [-11 -20] [-10 -20] [-9 -20] [-8 -20] [-7 -20] [-6 -20] [-5 -20] [-4 -20] [-3 -20] [-2 -20] [-1 -20] [0 -20] [1 -20] [2 -20] [3 -20] [4 -20] [5 -20] [6 -20] [7 -20] [8 -20] [9 -20] [10 -20] [11 -20] [12 -20] [13 -20] [14 -20] [15 -20] [16 -20] [17 -20] [18 -20] [19 -20] [20 -20]]
end

;;--------------------------------

to setup-snakes  ; observer
  ; create the red/orange snake:
  create-snakes 1 [
    set team "red" ; /orange
    set xcor max-pxcor - 1
    set color red - 2
    set snake-color red + 11

    set mode red-team-mode
  ]
  ; create the blue/purple snake (but only when in two-player mode):
  if two-player[
    create-snakes 1 [
      set team "blue" ;/purple
      set xcor 0 -(max-pxcor - 1)
      set color blue - 2
      set snake-color blue + 11

      set mode blue-team-mode
    ]
  ]

  ; set the attributes that are the same for both snakes:
  ask snakes [
    set heading 0
    set ycor 0
    set snake-age 2 ; i.e. body contains two patches

    ;; Create the initial snake body
    ask patch [xcor] of self  0 [set pcolor [snake-color] of myself
                                 set age 0 ]
    ask patch [xcor] of self  -1 [set pcolor [snake-color] of myself
                                  set age 1]
    set path-to-food []
  ]
end

;;=======================================================

;;;
; Make a random patch green (e.g. the color of the food)
to make-food
  ask one-of patches with [pcolor = black] [
    set pcolor green
    if apples = 0 [set apples []]
    set apples lput self apples
  ]
end

;;=======================================================

;;;
; Our main game control method
to go ; observer
  let loser nobody ; nobody has lost the game yet...
  let winner nobody ; nobody has won the game yet...

  ask snakes [
    (ifelse
      mode = "random" [
        face-random-neighboring-patch
      ]
      mode = "depth-first" [
        face-depth-first
      ]
      mode = "breadth-first" [
        face-breadth-first
      ]
      mode = "uniform" [
        face-uniform
      ]
      mode = "greedy" [
        face-greedy
      ]
      mode = "A*" [
        face-A*
      ]
      [] ) ; end of ifelse



    ; 2. move the head of the snake forward
    fd 1

    ; 3. check for a collision (and thus game lost)
    ; (highscore mode only ignores the max age: crashing still ends the game, otherwise
    ;  the snake would drive through walls and erase them)
    if not member? pcolor clear-colors [
      set loser self
      stop
    ]

    ; 4. eat food
    if pcolor = green [
      make-food
      set snake-age snake-age + 1
    ]

    ; 5. check if max age reached (and thus game won)
    if snake-age >= max-snake-age and not highscore-mode [
      set winner self
      stop
    ]

    ; 6. move snake body parts forward
    ask patches with [pcolor = [snake-color] of myself] [
      set age age + 1
      if age > [snake-age] of myself [
        set age -1
        set pcolor black
      ]
    ]

    ; 7. set the patch colour and age of the snake's head.
    set pcolor snake-color
    set age 0
  ]

  ; A collision has happened: show message and stop the game
  (ifelse loser != nobody [
    ifelse highscore-mode [
      user-message (word "Game Over! Team " [team] of loser " crashed at length " [snake-age] of loser)
    ] [
      user-message (word "Game Over! Team " [team] of loser " lost")
    ]
    stop
  ] winner != nobody [
    user-message (word "Game Over! Team " [team] of winner " won!")
    stop
  ])
  tick
end

to color-path [visited]
  let trailcolor red

  if team = "blue" [set trailcolor blue]

  ask patches with [pcolor = trailcolor + 8 or pcolor = trailcolor + 9] [
    set pcolor black
  ]

  ; color visited color value 30
  foreach visited[ square ->
    if [pcolor] of square = black [
      ask square [ set pcolor (trailcolor + 8)]
    ]
  ]
  ; color path to food color value 23
  foreach path-to-food[ square ->
    if [pcolor] of square = black or [pcolor] of square = (trailcolor + 8)[
      ask square [ set pcolor (trailcolor + 9)]
    ]
  ]
end

;;--------------------------------------------

;;;
; Make the turtle face a random unoccupied neighboring patch
;  if all patches are occupied, then any patch will be selected (and the snake lose :( )
to face-random-neighboring-patch ; turtle
  let next-patch one-of neighbors4 with [member? pcolor clear-colors]

  if next-patch = nobody [ ; if none of the neighbours are clear:
    set next-patch one-of neighbors4
  ]
  ; make the snake face towards the patch we want the snake to go to:
  face next-patch
end

;;--------------------------------------------

;;--------------------------------------------

; Web version: take the next step of the planned path, but only if it's a clear patch
; right next to the snake. Otherwise (no path found, or the path is out of date) forget
; the plan and step onto a clear neighbouring patch instead of crashing.
to follow-path ; turtle
  ifelse not empty? path-to-food and member? (item 0 path-to-food) ([neighbors4] of patch-here) and member? [pcolor] of (item 0 path-to-food) clear-colors [
    face item 0 path-to-food
    set path-to-food butfirst path-to-food
  ] [
    set path-to-food []
    face-random-neighboring-patch
  ]
end

to-report will-collide
  foreach (range 0 carefullness)
  [ j ->
    if length path-to-food > j
    [
      let square item j path-to-food
      if not member? [pcolor] of square clear-colors
      [
        report true
      ]
    ]
  ]
  report false
end

;;--------------------------------------------
; Web version of the searches. Same algorithms as the original, made faster so the
; browser doesn't freeze: "visited" is a mark on each patch instead of a list search,
; apple positions are read once per search, and path scores are stored in the queue
; instead of being recalculated for every comparison.

to start-search [node] ; turtle
  set search-count search-count + 1
  ask node [ set search-id search-count ]
  set apples filter [a -> [pcolor] of a = green] apples
end

to mark-visited [node]
  ask node [ set search-id search-count ]
end

to-report open-neighbors [node] ; clear neighbouring patches this search hasn't visited yet
  report filter [n -> member? [pcolor] of n clear-colors and [search-id] of n != search-count] ([sort neighbors4] of node)
end

to-report needs-new-path ; turtle
  let next-blocked false ;This block allows the snake to recalculate the route to avoid players which may have since moved to block them
  if avoid-snakes [set next-blocked will-collide]
  report empty? path-to-food or next-blocked
end

;;--------------------------------------------

; Face the turtle according to the depth-first search algorithm
; (a standard depth-first search with backtracking: the original could jump to a patch
;  that wasn't next to the snake, or loop forever when it boxed itself in)
to face-depth-first
  if needs-new-path [
    let start patch-here
    start-search start
    let visited (list start)
    let current-node start
    let found-food false
    let stuck false
    set path-to-food []

    while [not found-food and not stuck] [
      let options open-neighbors current-node
      ifelse empty? options [
        ; dead end: back up one step (or give up if we're back at the start)
        ifelse empty? path-to-food [
          set stuck true
        ] [
          set path-to-food but-last path-to-food
          set current-node ifelse-value empty? path-to-food [start] [last path-to-food]
        ]
      ] [
        let next-node first options
        mark-visited next-node
        set visited fput next-node visited
        set path-to-food lput next-node path-to-food
        set current-node next-node
        if [pcolor] of next-node = green [ set found-food true ]
      ]
    ]
    if debug-paths [color-path visited];function to color the future path of snake
  ]
  follow-path
end

;;--------------------------------------------

; Face the turtle according to the breadth-first search algorithm
to face-breadth-first
  if needs-new-path [
    let current-node patch-here
    start-search current-node
    let queue (list (list current-node))
    let visited (list current-node)
    let found-food false
    set path-to-food []

    while [not empty? queue and not found-food] [
      let path item 0 queue
      set queue butfirst queue
      foreach open-neighbors last path [ neighbor ->
        if not found-food [
          let new-path lput neighbor path
          ifelse [pcolor] of neighbor = green [
            set path-to-food butfirst new-path
            set found-food true
          ] [
            mark-visited neighbor
            set queue lput new-path queue
            set visited lput neighbor visited
          ]
        ]
      ]
    ]
    if debug-paths [color-path visited] ;function to color the future path of snake
  ]
  follow-path
end

;;--------------------------------------------

; Greedy, uniform and A* share one search. Queue entries are (list stored-score path),
; kept in order; `mode` picks how a new path is scored:
;   greedy:  distance from the path's last patch to the nearest apple
;   uniform: the sum of those distances along the whole path
;   A*:      inserted by (sum along the path + distance from its last patch),
;            stored with the path's sum (as in the original)
to face-greedy
  informed-search "greedy"
end

to face-uniform
  informed-search "uniform"
end

to face-A*
  informed-search "A*"
end

to informed-search [kind] ; turtle
  if needs-new-path [
    let current-node patch-here
    start-search current-node
    let start-score get-node-score current-node
    let queue (list (list start-score (list current-node)))
    let visited (list current-node)
    let found-food false
    set path-to-food []

    while [not found-food and not empty? queue] [
      let entry item 0 queue
      set queue butfirst queue
      let path item 1 entry
      let branch item 0 entry

      foreach open-neighbors last path [ neighbor ->
        if not found-food [
          let new-path lput neighbor path
          ifelse [pcolor] of neighbor = green [
            set path-to-food butfirst new-path
            set found-food true
          ] [
            mark-visited neighbor
            set visited lput neighbor visited
            let node-score get-node-score neighbor
            (ifelse
              kind = "greedy" [ set queue insert-by-score (list node-score new-path) node-score queue ]
              kind = "uniform" [ set queue insert-by-score (list (branch + node-score) new-path) (branch + node-score) queue ]
              [ set queue insert-by-score (list (branch + node-score) new-path) (branch + node-score + node-score) queue ])
          ]
        ]
      ]
    ]
    if debug-paths [color-path visited];function to color the future path of snake
  ]
  follow-path
end

; Insert an entry before the first queue entry whose stored score is >= new-score
to-report insert-by-score [entry new-score queue]
  if empty? queue or new-score > item 0 last queue [ report lput entry queue ]
  let index 0
  while [index < length queue and new-score > item 0 item index queue] [ set index index + 1 ]
  report insert-item index queue entry
end

to-report get-node-score [node];informed search, returns the Manhattan distance to the nearest apple
  if empty? apples [ report 10000 ]
  let node-x [pxcor] of node
  let node-y [pycor] of node
  report min map [a -> abs (node-x - [pxcor] of a) + abs (node-y - [pycor] of a)] apples
end

;;--------------------------------------------

;;;
; Human controlled snakes:
to head-up [selected-team]
  ask snakes with [team = selected-team] [ set heading 0 ]
end
;----
to head-right [selected-team]
  ask snakes with [team = selected-team] [ set heading 90 ]
end
;----
to head-down [selected-team]
  ask snakes with [team = selected-team] [ set heading 180 ]
end
;----
to head-left [selected-team]
  ask snakes with [team = selected-team] [ set heading 270 ]
end
;;---------------------

;;=======================================================

;; for displaying the age within the GUI:
to-report report-snake-age [team-name]
  report [snake-age] of one-of snakes with [team = team-name]
end

;;---------------------
@#$#@#$#@
GRAPHICS-WINDOW
210
10
680
481
-1
-1
14.0
1
10
1
1
1
0
0
0
1
-16
16
-16
16
1
1
1
ticks
30.0

BUTTON
36
37
109
70
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
36
74
99
107
NIL
go
T
1
T
OBSERVER
NIL
M
NIL
NIL
1

CHOOSER
477
486
615
531
red-team-mode
red-team-mode
"human" "random" "depth-first" "breadth-first" "uniform" "greedy" "A*"
2

BUTTON
251
537
306
570
up
head-up \"blue\"
NIL
1
T
OBSERVER
NIL
W
NIL
NIL
1

BUTTON
249
601
304
634
down
head-down \"blue\"
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
196
568
251
601
left
head-left \"blue\"
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
1

BUTTON
303
571
358
604
right
head-right \"blue\"
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
1

CHOOSER
194
485
320
530
blue-team-mode
blue-team-mode
"human" "random" "depth-first" "breadth-first" "uniform" "greedy" "A*"
0

BUTTON
537
535
592
568
up
head-up \"red\"
NIL
1
T
OBSERVER
NIL
I
NIL
NIL
1

BUTTON
590
566
645
599
right
head-right \"red\"
NIL
1
T
OBSERVER
NIL
L
NIL
NIL
1

BUTTON
535
599
590
632
down
head-down \"red\"
NIL
1
T
OBSERVER
NIL
K
NIL
NIL
1

BUTTON
481
567
536
600
left
head-left \"red\"
NIL
1
T
OBSERVER
NIL
J
NIL
NIL
1

CHOOSER
34
135
181
180
map-file
map-file
"empty" "snake-map-1" "snake-map-2" "snake-map-3"
0

SWITCH
33
187
181
220
two-player
two-player
1
1
-1000

TEXTBOX
690
448
912
486
You need to press setup after changing the map or modes.
12
0.0
1

SLIDER
32
230
181
263
max-snake-age
max-snake-age
3
30
20.0
1
1
NIL
HORIZONTAL

MONITOR
324
486
399
531
Blue age
report-snake-age \"blue\"
0
1
11

MONITOR
619
487
690
532
Red age
report-snake-age \"red\"
0
1
11

SWITCH
726
29
851
62
debug-paths
debug-paths
0
1
-1000

SWITCH
721
199
850
232
avoid-snakes
avoid-snakes
0
1
-1000

SLIDER
721
244
893
277
carefullness
carefullness
1
3
1.0
1
1
NIL
HORIZONTAL

TEXTBOX
720
292
960
376
Carefullness determines how many steps into the future the snake will look to avoid hitting another (significantly slows program at higher numbers)
11
0.0
1

TEXTBOX
728
69
878
125
Shows the path the snake intends to follow and the patches it has visited to reach that path
11
0.0
1

SWITCH
28
316
174
349
highscore-mode
highscore-mode
1
1
-1000

TEXTBOX
28
356
178
384
Ignore the max age and go for aslong as possible
11
0.0
1

@#$#@#$#@
# CMP2020 -- Assessment Item 1

__If you find any bugs in the code or have any questions regarding the assessment, please contact the module delivery team.__

## Your details

Name:

Student Number:

## Extensions made

(a brief description of the extensions you have made -- that go beyond the search algorithms studied during this module.)







## References

(add your references below the provided reference)

Brooks, P. (2020) Snake-simple. Stuyvesant High School. Avaliable from http://bert.stuy.edu/pbrooks/fall2020/materials/intro-year-1/Snake-simple.html [accessed 16 November 2023].
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
