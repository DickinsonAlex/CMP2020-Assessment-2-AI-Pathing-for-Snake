# 🐍 Multi-Agent Snake AI – NetLogo

<!-- tags:start -->
![NetLogo](https://img.shields.io/badge/NetLogo-3A6EA5) ![AI](https://img.shields.io/badge/AI-2F6F8F) ![Pathfinding](https://img.shields.io/badge/Pathfinding-2F6F8F) ![Search Algorithms](https://img.shields.io/badge/Search%20Algorithms-2F6F8F) ![University of Lincoln: CMP2020 Artificial Intelligence](https://img.shields.io/badge/University%20of%20Lincoln-CMP2020%20Artificial%20Intelligence-8A1538)
<!-- tags:end -->
This project explores autonomous agent control in a multi-player Snake game using classical AI search techniques. Each snake operates in a fully observable environment, navigating toward food while avoiding collisions with walls, other snakes, and itself.

✅ Core Features:
- Search-based pathfinding with selectable algorithms for each snake
- Supported algorithms include: Depth-First, Breadth-First, Uniform Cost, Greedy, and A*
- Real-time path execution with one move per tick
- Dropdown menus for assigning specific algorithms to each team

🧠 Enhancements:
- 3D Visual Mode: A custom rendering layer that adds a 3D-like perspective to the game grid (Stored on seperate branch)
- Map Selection: Interface for choosing from a set of predefined maps to alter the game environment

## ▶️ Play in your browser

**[snake.alexxdickinson.co.uk](https://snake.alexxdickinson.co.uk)** runs the 2D version in the browser with NetLogo Web: pick a map and a search algorithm for each snake, press **setup**, then **go**.

The browser version is `SnakeAI-web.nlogo`. It's the same model, except the maps are built in code instead of loaded from `maps/*.csv`, because NetLogo Web can't read files from a folder.

The web version also fixes a few problems that showed up in the browser:
- **Depth-first search** now backtracks properly. The original could plan a path that jumped to a patch that wasn't next to the snake (so it crashed), or loop forever when it boxed itself in.
- **No more freezing:** "visited" is a mark on each patch instead of a search through a list, and path scores are stored in the queue instead of being recalculated on every comparison. The slowest tick went from about 3 seconds to under 0.1 s.
- **Unreachable food** no longer breaks the greedy, uniform and A* searches (they used to run off the end of an empty queue).
- **Highscore mode no longer drives through walls.** It only ignores the max age now; crashing still ends the game (and shows the length reached). This is fixed in `SnakeAI.nlogo` too.
- **A safety check** before every move: the snake only follows its plan onto a clear patch next to it; otherwise it drops the plan and steps somewhere safe.

### Rebuilding and deploying the web version
1. Go to [netlogoweb.org/launch](https://www.netlogoweb.org/launch) and upload `SnakeAI-web.nlogo` with the file picker at the top.
2. Click **Export: HTML** and save it over `web/index.html`.
3. Deploy with `npx wrangler deploy` (no build step). The site is set up in `wrangler.jsonc`.

<img width="997" height="881" alt="image" src="https://github.com/user-attachments/assets/2f9769dd-83c9-4fcf-b9bd-384699da2ec4" />

![explorer_jak0J9m85j](https://github.com/user-attachments/assets/a4d0c62f-59d8-4c08-868e-19a668949961)

