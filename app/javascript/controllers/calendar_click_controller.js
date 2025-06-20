import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

// Connects to data-controller="calendar-click"
export default class extends Controller {
  static values = {
    date: String,
  }

  async handleClick(event) {
    event.preventDefault()

    const date = this.dateValue
    const eventPanel = document.getElementById("event_panel")
    const isNew = eventPanel && eventPanel.dataset.status === "new"

    await this.visitFrame(`/schedules?date=${date}`, "daily_schedule")

    if (isNew) {
      await this.visitFrame(`/events/new/${date}`, "event_panel")
    }
  }

  async visitFrame(url, frameId) {
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

