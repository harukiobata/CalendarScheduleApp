import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "button"]

  toggle() {
    this.panelTarget.classList.toggle("show")
  }

  closePanel(event) {
    const el = event.target.closest("a")
    if (el) {
      this.panelTarget.classList.remove("show")
    }
  }
}
