import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import dropdownController from "./dropdown_controller"

const application = Application.start()

application.register("dropdown", dropdownController)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
