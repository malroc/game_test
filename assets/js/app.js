// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

async function render() {
  let response = await fetch("./api/v1/players")
  let players = await response.json()

  for (let div of document.querySelectorAll(".cell:not(.wall)")) {
    div.className = "cell"
    div.innerHTML = ""
  }

  let currentUser = null
  let currentUserDiv = null

  for (let p of players) {
    let div = document.getElementById(`cell-${p["y"]}-${p["x"]}`)
    div.classList.add("player")

    if (!p["is_alive"]) {
      div.classList.add("dead")
    }

    div.innerHTML = p["name"]

    if (p["name"] == document.currentUserName) {
      currentUser = p
      currentUserDiv = div
    }
  }

  if (currentUser && currentUserDiv) {
    currentUserDiv.innerHTML = currentUser["name"]
    currentUserDiv.classList.add("current")

    if (currentUser["is_alive"]) {
      currentUserDiv.classList.remove("dead")
    }
  }
}

function updatePlayer(body) {
  fetch(
    `./api/v1/players/${document.currentUserName}`,
    {
      method: "PUT",
      body: JSON.stringify(body),
      headers: {'Content-Type': 'application/json'}
    }
  )
}

render()
setInterval(render, 1000)

document.getElementById("move-left").onclick = () => updatePlayer({moving: "left"})
document.getElementById("move-right").onclick = () => updatePlayer({moving: "right"})
document.getElementById("move-up").onclick = () => updatePlayer({moving: "up"})
document.getElementById("move-down").onclick = () => updatePlayer({moving: "down"})

document.getElementById("attack").onclick  = () => updatePlayer({attacking: true})
