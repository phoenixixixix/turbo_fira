import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.flash = document.getElementById("flash")
  }

  close() {
    this.flash.remove()
  }
}
