import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.handleClickOutside = this.handleClickOutside.bind(this)
  }

  toggle(event) {
    event.stopPropagation()
    if (this.menuTarget.classList.contains("event-actions--visible")) {
      this.hideMenu()
    } else {
      this.showMenu()
    }
  }

  showMenu() {
    this.menuTarget.classList.add("event-actions--visible")
    document.addEventListener("click", this.handleClickOutside)
  }

  hideMenu() {
    this.menuTarget.classList.remove("event-actions--visible")
    document.removeEventListener("click", this.handleClickOutside)
  }
  
  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.hideMenu()
    }
  }
}
