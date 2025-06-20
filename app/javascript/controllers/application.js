import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import dropdownController from "./dropdown_controller"
import calendarClickController from "./calendar_click_controller"

const application = Application.start()

application.register("dropdown", dropdownController)
application.register("calendar-click", calendarClickController)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
