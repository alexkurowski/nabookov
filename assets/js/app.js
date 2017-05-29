// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

import Global from "js/global"
import Modals from "js/modals"
import Books  from "js/books"

window.csrf = () => {
  return $('meta[name="csrf-token"]').attr('content')
}

window.switchClass = (el, kl, cond) => {
  if (cond) $(el).addClass(kl);
  else      $(el).removeClass(kl);
}

window.plural = (count) => {
  if (count == 1) return '';
  else            return 's';
}

window.initializeAll = () => {
  Global.initialize()
  Modals.initialize()
  Books.initialize()
}

window.initializeOnly = (filename) => {
  switch (filename) {
    case 'global': return Global.initialize();
    case 'modals': return Modals.initialize();
    case 'Books':  return Books.initialize();
  }
}
