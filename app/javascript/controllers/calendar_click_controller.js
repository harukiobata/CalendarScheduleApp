import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static values = {
    date: String,
  }

  async handleClick(event) {
    event.preventDefault()
    const date = this.dateValue

    await this.visitFrame(`/schedules?date=${date}`)
  }

  async visitFrame(url) {
    const response = await fetch(url, {
      headers: {
        Accept: "text/vnd.turbo-stream.html"
      }
    })

    if (response.ok) {
      const html = await response.text()
      Turbo.renderStreamMessage(html)
    } else {
      console.error(`Failed to fetch ${url} with Turbo Stream`)
    }
  }
}
